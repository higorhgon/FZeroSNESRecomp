#!/usr/bin/env bash
# Assemble a PortMaster-ready zip for FZeroSNESRecomp, for the Anbernic
# H700-chip handhelds (RG34XX / RG34XX H / RG34XXSP) running muOS.
#
# This script does NOT build the game. It packages a binary that was already
# built for aarch64 with FZERO_BUILD_GAME=ON, which itself requires a
# maintainer's own legally dumped F-Zero (USA) ROM and the private
# src/gen/*.c sources produced by `bash tools/regen.sh`. See the "PortMaster
# / Anbernic H700 (muOS)" section of README.md for the full local workflow:
#
#   1. bash tools/bootstrap.sh                     # submodules
#   2. put your verified ROM at fzero.sfc, then: bash tools/regen.sh
#   3. cmake -S . -B build-portmaster -G Ninja -DCMAKE_BUILD_TYPE=Release
#      cmake --build build-portmaster --target FZeroSNESRecomp -j"$(nproc)"
#      (on an aarch64 host or cross-compiling toolchain - see README)
#   4. bash tools/package_portmaster.sh --build build-portmaster
#
# The resulting zip's layout follows the standard PortMaster convention (a
# zip root containing port.json, <Name>.sh, and a <Name>/ folder with the
# game's own files) confirmed against PortsMaster/PortMaster-New's own
# published ports.
set -euo pipefail

APP_NAME="FZeroSNESRecomp"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$REPO/build"
OUT="$REPO/release-portmaster"
VERSION="$(tr -d '\r\n' < "$REPO/VERSION" 2>/dev/null || echo 0.0.0)"
SKIP_ARCH_CHECK=0

while [ $# -gt 0 ]; do
  case "$1" in
    --build) BUILD="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --version) VERSION="$2"; shift 2;;
    --skip-arch-check) SKIP_ARCH_CHECK=1; shift;;
    -h|--help)
      sed -n '1,25p' "$0"
      exit 0
      ;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

command -v zip >/dev/null 2>&1 || { echo "package_portmaster.sh: 'zip' is required" >&2; exit 1; }

echo "[1/5] locate the built binary"
BIN=""
while IFS= read -r file; do
  if [ "$(basename "$file")" = "$APP_NAME" ] && file -b "$file" 2>/dev/null | grep -q "ELF.*executable"; then
    BIN="$file"
    break
  fi
done < <(find "$BUILD" -maxdepth 4 -type f 2>/dev/null)
[ -n "$BIN" ] || {
  echo "package_portmaster.sh: no Linux ELF named $APP_NAME found under $BUILD" >&2
  echo "  Build it first with -DFZERO_BUILD_GAME=ON and a generated ROM (see README)." >&2
  exit 1
}
echo "  found: $BIN"

if [ "$SKIP_ARCH_CHECK" = "0" ]; then
  ARCH_INFO="$(file -b "$BIN" 2>/dev/null || true)"
  case "$ARCH_INFO" in
    *aarch64*|*ARM\ aarch64*) echo "  arch: aarch64 (matches the H700's Cortex-A53 cores)";;
    *)
      echo "package_portmaster.sh: $BIN does not look like an aarch64 binary ($ARCH_INFO)" >&2
      echo "  The H700 (RG34XX family) needs an aarch64 build. Pass --skip-arch-check to" >&2
      echo "  package anyway (e.g. while testing the zip layout on a desktop build)." >&2
      exit 1
      ;;
  esac
fi

BIN_DIR="$(dirname "$BIN")"

echo "[2/5] stage the port layout"
WORK="$(mktemp -d)"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT
STAGE="$WORK/stage"
GAMEDIR="$STAGE/$APP_NAME"
mkdir -p "$GAMEDIR/saves"

cp "$REPO/portmaster/port.json" "$STAGE/port.json"
cp "$REPO/portmaster/$APP_NAME.sh" "$STAGE/$APP_NAME.sh"
chmod +x "$STAGE/$APP_NAME.sh"

cp "$BIN" "$GAMEDIR/$APP_NAME"
chmod +x "$GAMEDIR/$APP_NAME"

echo "[3/5] stage assets and default config"
if [ -d "$BIN_DIR/assets" ]; then
  cp -r "$BIN_DIR/assets" "$GAMEDIR/assets"
else
  echo "package_portmaster.sh: warning: no assets/ directory beside the binary" >&2
fi
# BS Deluxe payload/patches, if this build embedded them (see build-linux.sh
# for the same convention: mods/ + patches/ beside the binary).
[ -d "$BIN_DIR/mods" ] && cp -r "$BIN_DIR/mods" "$GAMEDIR/mods"
[ -d "$BIN_DIR/patches" ] && cp -r "$BIN_DIR/patches" "$GAMEDIR/patches"
[ -f "$REPO/patches/bs-deluxe-usa.ips" ] && mkdir -p "$GAMEDIR/patches" &&
  cp "$REPO/patches/bs-deluxe-usa.ips" "$GAMEDIR/patches/bs-deluxe-usa.ips"

# Shipped so first launch is already fullscreen + Fit on the 720x480 panel
# without the user having to find the launcher's Settings menu first. See
# src/fzero_video.c (FzeroVideoDefaults/FzeroCalculateViewport) and
# src/sdl_main.c (the [Graphics] Fullscreen key) for what these do.
cp "$REPO/portmaster/default-config/fzero-video.ini" "$GAMEDIR/fzero-video.ini"
cp "$REPO/portmaster/default-config/config.ini" "$GAMEDIR/config.ini"

echo "[4/5] build the zip"
mkdir -p "$OUT"
ZIP="$OUT/FZeroSNESRecomp-portmaster-$VERSION.zip"
rm -f "$ZIP"
(cd "$STAGE" && zip -r -X "$ZIP" . >/dev/null)

echo "[5/5] done"
echo "  $ZIP"
echo
echo "This zip has NOT been tested on real hardware. Install it through muOS's"
echo "PortMaster app (or by extracting it into the SD card's PortMaster ports"
echo "folder), drop your own F-Zero (USA) .sfc/.smc ROM into the FZeroSNESRecomp"
echo "folder it creates, and please report back what does and doesn't work."
