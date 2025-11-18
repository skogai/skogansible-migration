# i3 → Sway/Wayland Transition Documentation

**Date**: 2025-11-16
**Branch**: master
**Last commit**: deebd7f (Merge branch 'release/0.0.0')

## Context

User has swapped from i3 (X11 window manager) to sway/wayland compositor. This document captures the current state, analysis, questions, and proposals for the transition.

## Current State Analysis

### What Was Done

Major package changes in `vars/main.yml`:

#### Correctly Removed for Sway Transition ✓

**i3 Window Manager Stack:**
- i3-wm
- i3blocks
- i3lock
- i3status

**X11 Infrastructure:**
- xclip
- xdg-utils
- xdotool
- xorg-server-xvfb
- xorg-xinit
- xterm
- xss-lock

**X11 Display Manager:**
- lightdm
- lightdm-gtk-greeter

**X11 Compositor:**
- picom

**X11 Screenshot Tool:**
- maim

#### Wayland-Compatible Packages Still Active ✓

- `kitty` (line 39) - Wayland-native terminal
- `firefox` (line 25) - Full Wayland support
- `gammastep` (line 27) - Wayland-compatible redshift alternative
- `gst-plugin-pipewire` (line 31) - GStreamer PipeWire plugin
- `steam` (line 75) - Works via XWayland
- `zsh` - Shell (platform-independent)

#### Other Removals (Not Transition-Related)

**Docker Stack:**
- docker
- docker-buildx
- docker-compose

**.NET Stack:**
- dotnet-host
- dotnet-runtime
- dotnet-sdk
- dotnet-source-built-artifacts

**PostgreSQL Stack:**
- pgbouncer
- pgcli
- postgresql
- postgrest

**Development Tools:**
- ripgrep
- uv
- python-uv
- vim
- sheldon
- zoxide
- neovim-nvim-treesitter
- neovim-nightly-bin (AUR)

**System/Network:**
- grub
- intel-ucode
- iwd
- networkmanager
- network-manager-applet
- wireless_tools

**Audio (Full PipeWire Stack):**
- pipewire
- pipewire-alsa
- pipewire-jack
- pipewire-pulse
- wireplumber

**Graphics:**
- nvidia-dkms
- libva-nvidia-driver

**Other:**
- nano
- ncspot (Spotify client)
- ollama-cuda
- smartmontools
- wget
- zip
- zram-generator
- polkit-gnome
- libnotify
- libpulse
- mandoc
- nvm

#### Kernel Packages Removed 🚨

- linux
- linux-firmware
- linux-headers

### Packages Added/Enabled

**AUR Packages:**
- google-chrome (moved from commented to active)
- mods (active)
- rcm (active)

## Questions & Concerns

### Critical Issues 🚨

1. **Kernel packages commented out**
   - `linux`, `linux-firmware`, `linux-headers` are essential system packages
   - **Question**: Was this intentional? These are typically required for a functioning system
   - **Impact**: System may not boot or update properly without these

2. **Network management commented out**
   - `networkmanager` and `network-manager-applet` removed
   - `wireless_tools` removed
   - **Question**: How is network connectivity being managed?
   - **Impact**: May lose network connectivity on next playbook run

3. **Bootloader commented out**
   - `grub` removed
   - **Question**: Is a different bootloader being used? (systemd-boot, rEFInd?)
   - **Impact**: System may not boot if grub is removed

### Sway/Wayland Gaps

4. **Missing Sway Core Components**
   - No `sway` package itself listed
   - **Question**: Is sway installed outside of Ansible management?
   - **Proposal**: Add to vars/main.yml if using Ansible for system management

5. **Missing Sway Ecosystem Tools**
   - No status bar: `waybar` or `swaybar`
   - No screen locker: `swaylock`
   - No background setter: `swaybg` (or using sway config)
   - **Proposal**: Add these packages for full sway functionality

6. **Missing Wayland Utilities**
   - No clipboard manager: `wl-clipboard` (replaces xclip)
   - No screenshot tools: `grim` + `slurp` (replaces maim)
   - **Proposal**: Add these for Wayland clipboard and screenshot functionality

7. **X11-Only Tools Still Active**
   - `dmenu` (line 15) - X11 only, will run via XWayland
   - `feh` (line 24) - X11 image viewer, will run via XWayland
   - **Proposal**: Consider Wayland alternatives:
     - dmenu → `wofi`, `bemenu`, or `rofi` (Wayland mode)
     - feh → `imv` or `swayimg`

8. **Notification Daemon**
   - `dunst` (line 23) - Works with Wayland but not native
   - **Proposal**: Consider `mako` for more native sway/Wayland integration

### Audio Configuration

9. **PipeWire Stack Commented Out**
   - Full PipeWire stack disabled (pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse, wireplumber)
   - Only `gst-plugin-pipewire` active
   - `bluez` and `bluez-utils` active (Bluetooth audio)
   - **Question**: What audio system is being used?
   - **Note**: Modern Wayland setups typically use PipeWire
   - **Proposal**: Consider re-enabling PipeWire stack for full audio support

### Development Tools

10. **Essential Tools Commented Out**
    - `ripgrep` - Used by many development tools (vim, fzf, etc.)
    - `vim` / `neovim-nightly-bin` - Text editors
    - `uv` / `python-uv` - Python package management
    - `zoxide` - Directory jumping
    - `sheldon` - Shell plugin manager
    - **Question**: Are these tools no longer needed, or managed differently?

11. **Missing xdg-utils**
    - `xdg-utils` commented out (line 84)
    - **Note**: Still useful for Wayland (xdg-open, etc.)
    - **Proposal**: Consider re-enabling

## Proposals for Next Steps

### Immediate Actions Needed

1. **Verify System Packages**
   - Confirm kernel packages (linux, linux-firmware, linux-headers) installation status
   - Confirm bootloader (grub or alternative) installation status
   - Confirm network management solution

2. **Complete Sway Setup**
   - Add `sway` to package list (if not already installed system-wide)
   - Add `waybar` or `swaybar` for status bar
   - Add `swaylock` for screen locking
   - Add `swaybg` for background management (optional)

3. **Add Wayland Utilities**
   - Add `wl-clipboard` for clipboard functionality
   - Add `grim` and `slurp` for screenshots

4. **Replace X11 Tools**
   - Replace `dmenu` with `wofi`, `bemenu`, or `rofi`
   - Replace `feh` with `imv` or `swayimg`
   - Consider replacing `dunst` with `mako`

5. **Audio Configuration**
   - Decide on audio stack (PipeWire recommended for Wayland)
   - Re-enable PipeWire packages if needed

6. **Review Development Tools**
   - Determine which commented development tools should be restored
   - Consider re-enabling: ripgrep, vim/neovim, uv, zoxide, sheldon

### Configuration Files to Review

- `.config/sway/config` - Sway window manager configuration
- `.config/waybar/config` or `.config/swaybar/config` - Status bar config
- Audio configuration (if using PipeWire)
- Dotfiles for sway ecosystem

## Architecture Notes

From CLAUDE.md:
- `vars/main.yml` is single source of truth for all configuration
- `ansible.cfg` uses hardcoded venv: `/home/skogix/.ansible/.venv/bin/python`
- `run-playbook.sh` sources venv before running
- `become` is on individual tasks, gets password from `$ANSIBLE_BECOME_PASSWORD_FILE`
- Environment variables loaded via `skogcli` through `.envrc`

## Git Status at Time of Documentation

**Modified files**: 323 files
**Major changes:**
- vars/main.yml (package list)
- .claude/settings.json
- community.general Ansible collection updated
- One GALAXY.yml deleted

**Recent commits:**
```
deebd7f Merge branch 'release/0.0.0'
03a28e6 backup
5423427 .
a71949d add cc-sessions
35fb67a .
```

## /tmp/todo Analysis

### Installed Packages (packages.txt)

**Total**: 384 packages currently installed on system

**Sway/Wayland packages found:**
- sway itself (NOT in vars/main.yml) 🚨
- foot (terminal - NOT in vars/main.yml, config uses this)
- grim (screenshot tool - NOT in vars/main.yml)
- brightnessctl (in packages.txt, NOT in vars/main.yml)
- gtk-layer-shell (Wayland shell component)
- libdecor (Wayland client decorations)
- libwacom, libwireplumber, libpipewire (libs present)

**System packages present:**
- linux 6.17.8.arch1-1 ✓
- linux-firmware, linux-api-headers ✓
- networkmanager, network-manager-applet ✓
- lightdm, lightdm-gtk-greeter ✓
- grub NOT in packages.txt 🚨

**Audio:**
- libpulse, libpipewire, libwireplumber present
- pavucontrol present
- Full pipewire binaries unknown

### Sway Configuration Files

**Location**: `/tmp/todo/sway/`

**Files:**
1. `config` - Default sway config
   - Terminal: `foot`
   - Launcher: `wmenu-run`
   - Keyboard: Swedish (se) with us_dvorak variant
   - Screenshot: Uses `grim`
   - Volume: Uses `pactl` (PulseAudio/PipeWire control)
   - Brightness: Uses `brightnessctl`

2. `skogconfig` - Migrated i3 config (ISSUES) 🚨
   - Terminal: `kitty` (good)
   - Still has i3-specific commands:
     - `exec --no-startup-id "i3-msg 'workspace 1; exec kitty'"` (line 86)
     - `exec_always --no-startup-id picom` (line 88) - X11 compositor
     - `exec --no-startup-id redshift` (line 89) - should be gammastep
     - `exec_always xrandr` (line 118) - X11 display tool
     - `exec --no-startup-id xss-lock` (line 112) - X11 screen locker
     - `exec --no-startup-id feh --bg-fill` (line 119) - X11 wallpaper
     - `status_command i3blocks` (line 273) - i3 status bar
   - Has gaps settings (lines 14-15)
   - Workspace icons configured
   - Uses rofi launcher
   - Keyboard: Swedish us_dvorak (lines 256-257)

### Config Directories Present

- `/tmp/todo/byobu/` - terminal multiplexer
- `/tmp/todo/dconf/` - GNOME config system
- `/tmp/todo/dunst/` - notification daemon config
- `/tmp/todo/gh/` - GitHub CLI config
- `/tmp/todo/glow/` - Markdown viewer
- `/tmp/todo/i3/` - Old i3 config (archived)
- `/tmp/todo/kitty/` - Terminal config
- `/tmp/todo/lazygit/` - Git UI config
- `/tmp/todo/picom/` - X11 compositor (shouldn't be used with sway)
- `/tmp/todo/pipewire/` - Audio config dir
- `/tmp/todo/pulse/` - PulseAudio cookie (compat layer)

## Critical Findings Summary

### INSTALLED but NOT in vars/main.yml 🚨

These packages are installed on system but missing from Ansible management:

1. **sway** - The compositor itself!
2. **foot** - Terminal used in default sway config
3. **grim** - Screenshot tool used in sway config
4. **brightnessctl** - Brightness control
5. **neovim** - Text editor (version 0.11.5)
6. **claude-code** - This tool (2.0.42-1)

### COMMENTED in vars/main.yml but STILL INSTALLED 🚨

These are commented out in Ansible but still present on system:

1. **linux** kernel packages (6.17.8.arch1-1)
2. **networkmanager** and network-manager-applet
3. **lightdm** and lightdm-gtk-greater
4. **nano** editor
5. **neovim-nvim-treesitter**

### X11 Tools in Sway Config (skogconfig) 🚨

**Needs replacement:**
- picom → Remove (Wayland compositors don't need this)
- redshift → gammastep (already in vars/main.yml)
- xrandr → swaymsg/wlr-randr or sway output config
- xss-lock → swayidle + swaylock
- feh → swaybg or sway output config
- i3blocks → waybar or swaybar
- i3-msg → swaymsg
- rofi → Keep (has Wayland support) or use wofi

## Questions Updated

### From /tmp/todo Analysis

12. **Why is sway not in vars/main.yml?**
    - Sway is installed and running but not managed by Ansible
    - **Proposal**: Add to vars/main.yml for proper management

13. **Why is foot terminal not in vars/main.yml?**
    - Default sway config uses `foot`
    - User's skogconfig uses `kitty`
    - **Proposal**: Decide on terminal and add both to vars/main.yml

14. **Is grub actually installed?**
    - Not in packages.txt output
    - **Question**: Using different bootloader? systemd-boot?

15. **Why two sway configs?**
    - `/tmp/todo/sway/config` - clean default
    - `/tmp/todo/sway/skogconfig` - migrated from i3 with X11 cruft
    - **Question**: Which one is actually being used?
    - **Proposal**: Clean up skogconfig to be pure Wayland

16. **PipeWire status unclear**
    - Libs present (libpipewire, libwireplumber)
    - pavucontrol installed
    - Full pipewire stack commented in vars/main.yml
    - pulse cookie file exists
    - **Question**: Is PipeWire actually running? Check with `systemctl --user status pipewire`

## Next Conversation Topics

1. Kernel/bootloader/network package status verification
2. Which sway config is active? (~/.config/sway/config)
3. Add missing packages to vars/main.yml (sway, foot, grim, brightnessctl)
4. Clean up skogconfig X11 references
5. Verify PipeWire status
6. Sync vars/main.yml with actual installed packages

---

**Note**: This document captures the state as of 2025-11-16. Updated with /tmp/todo analysis.
