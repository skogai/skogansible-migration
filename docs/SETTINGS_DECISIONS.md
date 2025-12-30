# Settings Decisions Registry

**Purpose:** When agents are uncertain about configuration values, they ADD questions here instead of guessing. This is a log of decisions that need human input.

**Status:** ✅ COMPLETE - 9/10 questions answered (2025-12-28)

**Remaining:**

- Docker/Podman (deferred until needed)

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
| `git_email` | `emil@skogsund.se` | User decision 2025-12-28 | Primary git email |

### Paths

| Setting | Value | Notes |
|---------|-------|-------|
| `project_root` | `~/dev` | Development projects |
| `config_root` | `~/.config` | XDG config |
| `data_root` | `~/.local/share` | XDG data |
| `shell_path` | `/usr/bin/zsh` | Arch convention (functionally same as /bin/zsh) |

### System

| Setting | Value | Notes |
|---------|-------|-------|
| `locale` | `en_US.UTF-8` | All repos agree |
| `aur_helper` | `yay` | Current repo uses yay |
| `machine_type` | `workstation` | Desktop with GPU |
| `window_manager` | `i3` | X11 window manager |

### Development

| Setting | Value | Notes |
|---------|-------|-------|
| `git_signing` | `disabled` | No commit/tag signing (causes issues) |
| `user_groups_base` | `wheel` | Always include wheel; other groups per-role |

### Package Management

| Setting | Value | Notes |
|---------|-------|-------|
| `pacman_parallel_downloads` | `5` | Default/basic optimization |
| `package_selection_strategy` | `organic` | Add packages to vars/packages.yml as needed, not bulk migration |

### Audio

| Setting | Value | Notes |
|---------|-------|-------|
| `pipewire_stack` | `full` | Current live config: pipewire, pipewire-{alsa,audio,jack,pulse}, wireplumber, gst-plugin-pipewire |

---

## Pending Decisions ❓

**None.** All configuration decisions have been made except:

| Decision | Status | Notes |
|----------|--------|-------|
| Docker/Podman | Deferred | User wants rootless containers; decide between rootless Docker or Podman when container needs arise |

---

## Settings Conflicts Resolution

### Resolved Conflicts

| Setting | Conflict | Resolution | Date |
|---------|----------|------------|------|
| `git_email` | `emil@skogsund.se` vs `emil.skogsund@gmail.com` | Use `emil@skogsund.se` | 2025-12-28 |
| `shell_path` | `/bin/zsh` vs `/usr/bin/zsh` | Use `/usr/bin/zsh` (Arch convention) | 2025-12-28 |
| `wm_type` | `i3` vs `sway` | Use `i3` (X11) | 2025-12-28 |
| `git_signing` | Enabled in ansible-base vs disabled in current | Keep disabled (causes issues) | 2025-12-28 |
| `machine_type` | Multiple options | Confirmed `workstation` | 2025-12-28 |
| `package_selection` | Bulk migration vs organic | Organic growth strategy | 2025-12-28 |
| `pipewire_stack` | Full stack vs minimal | Use full stack (matches live system) | 2025-12-28 |

### Unresolved Conflicts

| Setting | Values Found | Status |
|---------|--------------|--------|
| `docker_vs_podman` | Docker in ansible-base vs commented out in current | Deferred - evaluating options |

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
| 2025-12-28 | Answered 9/10 questions; confirmed Pipewire full stack from live system | Claude + skogix |
| 2025-12-28 | Answered 8/10 questions; moved to confirmed decisions | Claude + skogix |
| 2025-12-23 | Initial creation with pending questions | Claude |

---

## Notes for Future

- When adding new roles, check if they need settings added here
- When user answers questions, update both this file AND the relevant vars/*.yml
- Keep this file in sync with actual configuration
