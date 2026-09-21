# FZeroSNESRecomp

A native PC build of *F-Zero* for SNES.

You bring your own legally dumped *F-Zero (USA)* ROM. No ROM is included.

<p align="center">
  <img src="docs/screenshots/bs-forest-iii-race-21x9.png" width="96%" alt="BS F-Zero Deluxe Forest III race in 21:9">
  <br>
  <img src="docs/screenshots/widescreen-title.png" width="48%" alt="F-Zero title screen in widescreen">
  <img src="docs/screenshots/bs-blue-thunder.png" width="48%" alt="BS F-Zero Deluxe Blue Thunder machine select">
  <br>
  <img src="docs/screenshots/bs-forest-iii-race.png" width="48%" alt="BS F-Zero Deluxe Forest III race in 16:9">
  <img src="docs/screenshots/bs-forest-iii.png" width="48%" alt="BS F-Zero Deluxe Forest III course select">
</p>

## Features

- Play *F-Zero* as a native app.
- Widescreen modes: 16:9, 21:9, 32:9, and Fit.
- Optional [HD Mode 7](docs/HD_MODE7.md): 2x/4x track rendering, independent of widescreen and presentation FPS.
- High refresh presentation: 60, 90, 120, 144, 165, 240, or 360 FPS.
- Display shaders: CRT Soft, LCD Grid, Sharp, Warm Composite, or your own GLSL shader.
- Save states with a slot browser and thumbnails, opened with **F7** or **Select + R**.
- Rewind: step back through the last few seconds and drop back in.
- Gamepad support through SDL.
- Optional BS F-Zero Deluxe content.
- Optional MSU-1 music packs for stock F-Zero and BS Deluxe (bring your own patch and audio).

## Download And Play

On Windows:

1. Download the Windows x64 ZIP from the Releases page.
2. Extract the whole ZIP.
3. Run `FZeroSNESRecomp.exe`.
4. Pick your own *F-Zero (USA)* `.sfc` or `.smc` ROM when asked.

On Linux:

1. Download the Linux AppImage from the Releases page.
2. Put your own *F-Zero (USA)* `.sfc` or `.smc` ROM next to it.
3. Make the AppImage executable.
4. Run it.

The app remembers your ROM path after the first launch.

## Settings

Open **Settings > Display** for:

- **Aspect ratio:** 4:3, 16:9, 21:9, 32:9, or Fit.
- **Shader:** None (default), CRT Soft, LCD Grid, Sharp, Warm Composite, or a custom shader.

Open **Mods** for:

- **Widescreen:** makes races wider.
- **Presentation FPS:** makes motion smoother on high refresh screens.
- **HD Mode 7:** sharper tracks at 2x or 4x; off by default.
- **BS Deluxe:** adds the Satellaview machines, leagues, and tracks.

When the Widescreen mod is on, its aspect setting wins over the normal Display aspect setting.

### Importing CRT-Geom or another shader

In **Settings > Display**, use **Browse** beside Shader to select your own
`.glslp` preset or `.glsl` shader. Keep the preset's accompanying files and
subdirectories intact: for example, `crt-geom.glslp` needs
`shaders/crt-geom.glsl` beside it. The app remembers the selected path; it
does not copy the pack, so leave it in a permanent location. RetroArch Slang
(`.slangp`) presets are not supported by this OpenGL path.

[CRT-Geom is available upstream](https://github.com/libretro/glsl-shaders/tree/master/crt).
It carries GPL-2.0-or-later terms. It is **not bundled**: redistribution
compatibility with this app's differently licensed dependencies has not been
established. User-selected CRT-Geom has been tested through the existing shader
loader. An unreadable or invalid preset falls back to unfiltered output.

### MSU-1 music

1. Obtain the **Conn/Cubear v11** patch from the
   [authors' BS F-Zero Deluxe MSU-1 page](https://www.zeldix.net/t2768-bs-f-zero-deluxe-msu-1).
2. Extract `f-zero_msu1.ips` into your music pack's folder, alongside its
   numbered `.pcm` tracks. Keep the pack's original track numbering and common
   filename prefix. Use a pack made for this patch's track layout.
3. Enable **MSU-1** in **Settings > Sound** and select that folder.

Keep using your **unmodified USA ROM**. The app verifies the exact v11 patch
(709 bytes, SHA-256 `9019013f085ff16f5501c4516531a044bc5f36703aadb58844e67c5456413532`)
and applies it in memory, **after BS Deluxe** if enabled. No ROM file is
rewritten. The patch and music are not included in downloads. Missing or
unsupported patches produce a warning and leave the original soundtrack active.
The patch handles missing PCM tracks through its original-audio fallback.

Stock and Deluxe have been exercised with synthetic tracks and a user-supplied
JUD6MENT pack, widescreen, and high-refresh presentation. Compatibility is
limited to these two supported cartridge layouts;
arbitrary third-party ROM patches are not accepted or claimed compatible.

MSU sessions currently execute the patched cartridge through the interpreter,
so compiled stock routines cannot bypass its audio hooks. Normal sessions
retain native dispatch. Save states and rewind restore the selected song from
its beginning, not its exact playback position. MSU saves are separate from
non-MSU saves, as shown below.

For command-line use, `SNESRECOMP_MSU1` can select a pack folder or filename
prefix; `off` overrides a saved enabled setting. `FZERO_MSU1_PATCH` can point
to the v11 IPS in another folder.

## Save States And Rewind

### The save-state menu

Press **F7**, or hold **Select + R** on a gamepad, to open the save-state
browser. The game freezes while it is open, so a state you take is that exact
moment.

- **Up / Down** or the **arrow keys** pick one of 12 slots.
- **A** on a pad, or **X** on the keyboard, loads the selected slot.
- **X** on a pad, or **S** on the keyboard, saves to it.
- **B** on a pad, or **Escape**, closes the menu without doing anything.
- **1**-**9** jump straight to a slot.

Each slot shows a thumbnail of the moment it was saved, so you can tell them
apart without loading them.

### Rewind

Press **F8**, or hold **Select + L** on a gamepad, to open the rewind
filmstrip. It shows the recent past as a strip of frames:

- **Left / Right** scrub back and forward. Hold a direction to keep scrubbing.
- **A** on a pad, or **Enter** / **Space**, jumps to the selected moment.
- **B** on a pad, or **Escape**, leaves without changing anything.

Rewind is **off by default**, because it keeps whole snapshots of the machine
in memory. Turn it on in the launcher under **Settings**, where you can also
set:

- **Rewind depth:** how many snapshots to keep (50, 100, 150, or 200).
- **Rewind interval:** how many frames apart they are (1, 4, 8, 12, 15, or 30).

More snapshots make the history longer; a shorter interval makes it finer.
Both cost memory: one snapshot of *F-Zero* is about 330 KB, so 100 of them is
roughly 33 MB. At the default 50 snapshots every 15 frames you can step back
about 12 seconds.

### Changing the keys

Both keys are rebindable in the launcher's **Controls** page, as
**SaveStateMenu** and **Rewind**. They are saved to `config.ini` next to the
executable and take effect the next time you start the game. The rewind
switch, depth and interval are remembered in the same file.

The quick-slot keys - **F1**-**F12** to load a slot, **Shift + F1**-**F12**
to save one - still work. Where a binding above uses a key (F7 and F8 by
default), that binding wins and the quick slot behind it is unavailable; both
slots are still reachable from the menu. Rebinding SaveStateMenu or Rewind to
another key hands the F-key straight back.

### Where states are kept

Stock *F-Zero* and BS F-Zero Deluxe keep separate states, because they are
different cartridges and their snapshots are not interchangeable:

| Mode | Slot files |
| --- | --- |
| Stock | `saves/fzero<N>.sav` |
| BS F-Zero Deluxe | `saves/bs-deluxe/fzero-bs-deluxe<N>.sav` |
| Stock + MSU-1 | `saves/msu1/fzero-msu1<N>.sav` |
| BS Deluxe + MSU-1 | `saves/bs-deluxe/msu1/fzero-bs-deluxe-msu1<N>.sav` |

A thumbnail sits beside each as `.sav.thumb`. If a state from the other mode
somehow ends up in a slot, loading it is refused and the game keeps running -
the title bar says so and nothing is disturbed.

## BS F-Zero Deluxe

BS F-Zero Deluxe is included with permission from its authors:
GuyPerfect, Porthor, and PowerPanda.

The release includes two BS Deluxe files:

- `mods/bs-deluxe.dat` is used by this app.
- `patches/bs-deluxe-usa.ips` is the upstream v1.1 USA SNES patch for your own ROM.

No patched ROM is included.

## If The Game Crashes

Send these files from the game folder:

- `crash_report_*.json`
- `crash_minidump_*.dmp`
- `last_run_report.json`

## Build From Source

Clone with submodules:

```bash
git clone --recurse-submodules git@github.com:mstan/FZeroSNESRecomp.git
cd FZeroSNESRecomp
```

Put your own USA ROM at `fzero.sfc`, then generate and build:

```bash
bash tools/regen.sh
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

Local ROMs, generated files, saves, captures, and builds are ignored by git.

Run the ROM-free regression suites with `ctest --test-dir build --output-on-failure`.
With your local ROM and the upstream patch ZIP, `tests/test_msu_integration.py`
checks stock/Deluxe playback using generated test tones, missing-track fallback
and invalid-patch rejection. On Windows, `tests/test_desktop_integration.py`
additionally checks real launcher persistence, imported shaders, controller
overlays and save/load. Both scripts accept `--help` and keep their test data
under ignored `captures/` directories; neither bundles music or a shader.

`python tests/test_rom_persistence.py --source build` checks ROM selection
through the actual Windows file dialog, then Play/close and repeated restarts.
It also checks cancellation, an invalid pick, and selecting a moved ROM. It
requires an interactive desktop and never seeds the ROM cache itself.

On Linux, `xvfb-run -a python3 tests/test_appimage_rom_persistence.py
--appimage PATH --output captures/rom-persistence-linux` exercises the packaged
AppImage through the real zenity picker, then Play/quit and repeated relaunches.
It requires `zenity` and `xdotool`; use a fresh output directory for each run.

## PortMaster / Anbernic H700 (muOS)

Experimental packaging for Anbernic H700-chip handhelds - the RG34XX,
RG34XX H, and RG34XXSP family - running muOS, installed as a PortMaster
port. **This has not been tested on real hardware.** Everything below was
built and reasoned about on a desktop machine with no H700 device
available; please try it and report back what does and doesn't work.

### What's verified and what isn't

Verified in this repository's CI and locally on x86_64:

- The ROM-independent `fzero_video` library and its unit tests
  (`fzero_hdma`, `fzero_video`, `fzero_mode7`, `fzero_hotkeys`,
  `fzero_state_mode`) configure, build, and pass with
  `-DFZERO_BUILD_GAME=OFF` on `ubuntu-24.04-arm` (aarch64) in
  [`.github/workflows/arm64-linux.yml`](.github/workflows/arm64-linux.yml),
  matching the H700's CPU architecture. This does not need the
  `snesrecomp`/`recomp-ui` submodules or a ROM.
- `FzeroCalculateViewport()` (`src/fzero_video.c`) already derives the
  correct aspect ratio from whatever window size it's given, clamped
  between 4:3 and 32:9. At the RG34XX family's native 720x480 panel
  (720/480 = 1.5, i.e. 3:2) that clamp is a no-op, so a fullscreen launch
  with the default `Aspect=Fit` setting renders at the panel's real 3:2
  aspect ratio with no source changes. This was checked by reading the
  formula, not by rendering on a real panel.

**Not verified - cannot be, from this environment:**

- Building the actual `FZeroSNESRecomp` game binary for aarch64. That
  needs `FZERO_BUILD_GAME=ON`, the `snesrecomp`/`recomp-ui` submodules, and
  a maintainer's own legally dumped ROM run through `tools/regen.sh` to
  produce `src/gen/*.c` - none of which can exist in a public CI runner or
  this sandbox. It has to be built locally (or on a self-hosted runner) by
  someone who owns the ROM, on or for aarch64.
- Anything about actually running on an RG34XX/muOS: window creation,
  controller mapping, audio, performance, and the video driver PortMaster
  picks at runtime.
- **The GPU/driver path.** `src/sdl_main.c` requests an OpenGL **3.3
  core** context (`SDL_GL_CONTEXT_MAJOR/MINOR_VERSION` = 3/3) and hard-fails
  (`ogl_IsVersionGEQ(3, 3)`) if it doesn't get one - but only on the path
  used when a custom GLSL shader preset is selected in Settings > Display.
  The H700's Mali-G31 runs Mesa's Panfrost driver, whose desktop OpenGL
  ceiling is currently **3.1** - below what that shader path requires.
  With no shader selected (the default the packaged config below ships
  with), the game instead uses SDL's own `SDL_Renderer` path
  (`snesrecomp_sdl_create_renderer`), which does not force a 3.3 core
  context and should be compatible with Panfrost. **Practical takeaway:
  leave Shader set to None on this handheld** - selecting a custom shader
  is expected to fail to initialize on this GPU/driver combination.

### Building and packaging

You need your own legally dumped F-Zero (USA) ROM and an aarch64 build
environment (the RG34XX family is Cortex-A55, so an aarch64 host or a
cross-compiling toolchain both work):

```bash
bash tools/bootstrap.sh                 # snesrecomp + recomp-ui submodules
# stage your verified ROM as fzero.sfc, then:
bash tools/regen.sh
cmake -S . -B build-portmaster -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build-portmaster --target FZeroSNESRecomp -j"$(nproc)"
bash tools/package_portmaster.sh --build build-portmaster
```

This produces `release-portmaster/FZeroSNESRecomp-portmaster-<version>.zip`,
laid out the way PortMaster expects (verified against
[PortsMaster/PortMaster-New](https://github.com/PortsMaster/PortMaster-New)'s
own published ports): `port.json` and `FZeroSNESRecomp.sh` at the zip root,
alongside an `FZeroSNESRecomp/` folder holding the binary, its assets, and
a default `config.ini` / `fzero-video.ini` with `Fullscreen=1` and
`Aspect=Fit` already set, so a first launch is already fullscreen and
correctly 3:2 without visiting the Settings menu first. The tracked
sources for the launcher script and metadata live under
[`portmaster/`](portmaster/); `tools/package_portmaster.sh` only copies
them together with a build you already produced - it does not build
anything itself.

### Installing on muOS

1. Copy the zip's contents onto the SD card's PortMaster ports folder
   (typically `SD1:/roms/ports` under muOS), or install it through muOS's
   own PortMaster app if you're distributing it that way -
   [see muOS's PortMaster docs](https://muos.dev/) for the app-based flow.
2. Drop your own `F-Zero (USA).sfc`/`.smc` ROM into the
   `FZeroSNESRecomp/` folder that was installed.
3. Launch **F-Zero SNES Recomp** from muOS's Ports list.

The launcher script (`portmaster/FZeroSNESRecomp.sh`) mirrors the ROM
auto-detection the official Linux AppImage already uses
(`tools/build-linux.sh`'s `AppRun`): it looks for a `.sfc`/`.smc` file
next to the binary and caches its path in `rom.cfg`, the same file the
game's own launcher UI reads. It deliberately does not hardcode
`SDL_VIDEODRIVER`, since real PortMaster ports disagree on the right
default for muOS (some force `x11`, some force `kmsdrm`, some only
override for a detected vendor `mali` driver) and which is correct here
cannot be checked without the actual device; the script has a commented
override for either, with the reasoning, if you hit a black screen.

**This is untested on real hardware - please report issues** (ideally with
`FZeroSNESRecomp/log.txt` from the port's folder attached) so the launcher
script, default config, and this section can be corrected against what an
actual RG34XX/muOS setup does.

## License

MIT License, Copyright (c) 2026 Matthew Stanley. See `LICENSE`. Bundled dependencies keep their own licenses under `licenses/` in each release; BS F-Zero Deluxe content is included with its authors' permission and is not covered by this license.

*F-Zero* belongs to Nintendo. The game ROM is not included.
