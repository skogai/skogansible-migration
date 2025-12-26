# Settings Decisions Registry

**Purpose:** When agents are uncertain about configuration values, they ADD questions here instead of guessing. This is a log of decisions that need human input.

**Status:** 🔴 NEEDS HUMAN INPUT - Questions marked with ❓ require @skogix to answer

---

## How to Use This File

### For Agents - CRITICAL

**When you encounter uncertainty about a setting value:**

1. **DO NOT GUESS** - Never assume or make up configuration values
2. **ADD A QUESTION** to the "Pending Decisions" section below using this format:

   ```markdown
   ### N. [Short Description]
   **Question:** What should [setting] be?

   **Context:** [Why you need this, what you found]

   **Options found:** (if any)
   - Option A (source)
   - Option B (source)

   **Answer:** `_______________` <!-- @skogix: Fill this in -->
   ```

3. **SKIP** that part of implementation and note it in your PR/commit
4. **REFERENCE** confirmed decisions (✅) when they exist

### For @skogix

1. Answer questions by filling in the `_______________` blanks
2. Move answered items to "Confirmed Decisions" section
3. Add context that helps future agent decisions

---

## Confirmed Decisions ✅

### User Identity

| Setting | Value | Source | Notes |
|---------|-------|--------|-------|
| `user_name` | `skogix` | All repos agree | Primary username |
| `real_name` | `Emil Skogsund` | vars/main.yml | Full name for git, etc. |
| `default_editor` | `nvim` | All repos agree | |
| `default_pager` | `bat` | vars/main.yml | |

### Paths

| Setting | Value | Notes |
|---------|-------|-------|
| `project_root` | `~/dev` | Development projects |
| `config_root` | `~/.config` | XDG config |
| `data_root` | `~/.local/share` | XDG data |

### System

| Setting | Value | Notes |
|---------|-------|-------|
| `locale` | `en_US.UTF-8` | All repos agree |
| `aur_helper` | `yay` | Current repo uses yay |
| `window_manager` | `i3` | vars/chezmoi.yml:60 - X11-based WM |
| `display_server` | `X11` | Uses i3, not Wayland/sway |

---

## Pending Decisions ❓

### 1. Git Email Address

**Question:** Which email should be the primary git email?

**Options found:**

- `emil@skogsund.se` (current repo, ansible-base main.yml)
- `emil.skogsund@gmail.com` (ansible-base user.yml)

**Context:** Different emails found in different files. Need canonical answer.

**Answer:** `_______________` <!-- @skogix: Fill this in -->

---

### 2. Shell Path

**Question:** Which shell path is correct?

**Options found:**

- `/bin/zsh` (current repo)
- `/usr/bin/zsh` (ansible-base)

**Context:** On Arch Linux, `/usr/bin/zsh` is typical. `/bin` is often a symlink to `/usr/bin`.

**Recommendation:** Use `/usr/bin/zsh` for consistency with Arch conventions.

**Answer:** `_______________` <!-- @skogix: Confirm or override -->

---

### 3. Window Manager ✅ RESOLVED

**Question:** Which window manager is primary?

**Answer:** `i3` (confirmed in vars/chezmoi.yml:60)

**Resolution:** Confirmed by examining vars/chezmoi.yml which explicitly sets `chezmoi_wm: i3`. This is an X11-based window manager, confirming the system uses X11 (not Wayland). Moved to Confirmed Decisions table above.

**Date Resolved:** 2025-12-26

---

### 4. Git Commit Signing

**Question:** Should commits be signed? If yes, GPG or SSH?

**Found in ansible-base:**

```yaml
git_signing_key: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlUcpcztoYpgvgKEhnYBY0c52gl0/GLNDxYK4X5umgK"
```

**Current repo:** Signing disabled (`git_gpg_sign_commits: false`, `git_ssh_sign_commits: false`)

**Options:**

- [ ] No signing
- [ ] SSH signing with key above
- [ ] GPG signing (need key ID)

**Answer:** `_______________` <!-- @skogix: Which option? -->

---

### 5. User Groups

**Question:** Which additional groups should user be in?

**Found in archive:**

```yaml
additional_groups: docker,wheel,render
```

**Current repo:** Not explicitly configured (relies on system defaults)

**Options:**

- `wheel` - sudo access (essential)
- `docker` - Docker without sudo
- `render` - GPU access (for Ollama, etc.)
- `video` - Video device access
- `audio` - Audio device access

**Answer:** `_______________` <!-- @skogix: List groups -->

---

### 6. Docker Installation

**Question:** Should Docker be installed and configured?

**Found in:**

- ansible-base packages.yml: `docker`, `docker-buildx`, `docker-compose`
- current repo: commented out

**Sub-questions:**

- Install Docker? `___`
- Rootless Docker? `___` (current has `docker-rootless-extras` in AUR)
- Add user to docker group? `___`

**Answer:** `_______________` <!-- @skogix: Yes/No + details -->

---

### 7. Package Selection - Missing from Current

**Question:** Which of these packages from ansible-base should be added?

| Package | Category | Add? |
|---------|----------|------|
| `eza` | CLI - modern ls | ❓ |
| `fd` | CLI - modern find | ❓ |
| `fish` | Shell - fish | ❓ |
| `btop` | Monitoring | ❓ |
| `lynx` | Browser - terminal | ❓ |
| `steam` | Gaming | ❓ |
| `dotnet-sdk` | Development | ❓ |
| `postgresql` | Database | ❓ |

**AUR Packages:**

| Package | Category | Add? |
|---------|----------|------|
| `aichat` | AI CLI tool | ❓ |
| `neovim-nightly-bin` | Editor | ❓ |
| `pdftotext` | PDF tools | ❓ |
| `claude-code` | AI tool | ❓ |

**Answer:** <!-- @skogix: Mark Yes/No for each -->

---

### 8. Pipewire Audio

**Question:** Should Pipewire audio stack be managed by Ansible?

**Found in ansible-base:**

```yaml
- pipewire
- pipewire-alsa
- pipewire-jack
- pipewire-pulse
- wireplumber
```

**Current repo:** Only `wireplumber` and `gst-plugin-pipewire`

**Answer:** `_______________` <!-- @skogix: Full stack or minimal? -->

---

### 9. Pacman Optimization

**Question:** Should pacman be optimized?

**Found in archive:**

```yaml
pacman:
  parallel_downloads: 10
```

**Current repo:** Not configured

**Answer:** `_______________` <!-- @skogix: Yes + value, or No -->

---

### 10. Machine Type

**Question:** What is the primary machine type for this configuration?

**Current repo:** `machine_type: workstation`

**Options:**

- `workstation` - Desktop with GPU
- `laptop` - Portable, battery management
- `server` - Headless
- `wsl` - Windows Subsystem for Linux

**Is this correct?** `_______________` <!-- @skogix: Confirm or change -->

---

## Settings Conflicts Resolution

### Resolved Conflicts

| Setting | Conflict | Resolution | Date |
|---------|----------|------------|------|
| `wm_type` | `i3` vs `sway` | Confirmed `i3` from vars/chezmoi.yml:60 | 2025-12-26 |

### Unresolved Conflicts

| Setting | Values Found | Needs |
|---------|--------------|-------|
| `git_email` in users array | `emil@skogsund.se` vs `emil.skogsund@gmail.com` | Human decision |
| `symlink_force` | `true` (ansible-base) vs `false` (user.yml) | Human decision |

---

## Source Repositories Reference

Settings were extracted from:

| Repo | Location | Status |
|------|----------|--------|
| **skogansible** (current) | `~/.ansible/` | ✅ Active |
| **ansible-base** | `~/.ansible/tmp/ansible-base/` | 🔄 Extracting |
| **archive-2025-10-05** | `~/.ansible/tmp/archive-2025-10-05-ansible/` | 🔄 Extracting |
| **dotfile-ansible** | `~/.ansible/tmp/dotfile-ansible/` | 🔄 Extracting |

---

## Changelog

| Date | Change | By |
|------|--------|-----|
| 2025-12-23 | Initial creation with pending questions | Claude |

---

## Notes for Future

- When adding new roles, check if they need settings added here
- When user answers questions, update both this file AND the relevant vars/*.yml
- Keep this file in sync with actual configuration
