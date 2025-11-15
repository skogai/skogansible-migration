# Complete System Inventory - Organized by Ansible Primitives

## Overview
This document categorizes ALL system configuration into the 7 Ansible primitives.
Goal: Complete disaster recovery - rebuild entire system from scratch.

---

## 1. ENSURE_STATE (Resource Existence)
*Make resources exist with specific properties*

### 1.1 Packages (pacman)
**Data source:** `packages_explicit.txt` (477 packages)
**Operation:** `community.general.pacman: name={{ item }} state=present`
**Notes:** Already in vars/main.yml (93 packages) - need to merge/expand

### 1.2 AUR Packages
**Data source:** `packages_aur.txt` (67 packages)
**Operation:** `kewlfft.aur.aur: name={{ item }} use=yay state=present`
**Notes:** Already in vars/main.yml (18 packages) - need to merge/expand

### 1.3 Users
**Data source:** `user_credentials.json`
- User: skogix (sudo=true, enc_password provided)
- User: aldervall (sudo=false, enc_password provided)

**Operation:**
```yaml
- user:
    name: {{ item.username }}
    password: {{ item.enc_password }}
    groups: wheel  # if sudo
    shell: /bin/zsh
    create_home: true
```

### 1.4 Directories (implied)
**Need to identify:**
- /mnt/extra (from fstab)
- /mnt/warez (from fstab)
- Custom script locations in /usr/local/bin
- Any other directories that need specific ownership/permissions

**Operation:** `file: path=X state=directory mode=0755 owner=X group=X`

### 1.5 Systemd Services (enabled/started)
**Data source:** `services_enabled.txt` (27 services)

**Services to enable:**
- autorandr.service
- avahi-daemon.service
- cloudflared.service
- containerd.service
- docker.service
- lightdm.service
- NetworkManager.service
- NetworkManager-dispatcher.service
- NetworkManager-wait-online.service
- nvidia-hibernate/resume/suspend.service
- podman.service
- postgresql.service
- power-profiles-daemon.service
- soft-serve.service
- sshd.service
- warp-svc.service

**Sockets:**
- avahi-daemon.socket
- podman.socket

**Timers:**
- fstrim.timer
- paccache.timer

**Operation:** `systemd: name={{ item }} enabled=yes state=started`

---

## 2. ENSURE_CONTENT (File Content Management)
*Make files contain specific content/lines*

### 2.1 System Configuration Files (copy/template)

#### /etc/environment
**Content:**
```
BROWSER=firefox
EDITOR=nano
```
**Operation:** `copy: content=X dest=/etc/environment mode=0644`

#### /etc/fstab (append entries)
**Content:**
```
UUID=93f3c5d5-d775-4364-abc2-09161102aa04 /mnt/extra  ext4 defaults 0 2
UUID=4cb7e060-09f1-455d-8a4b-dea8286c6c0a /mnt/warez  ext4 defaults 0 2
```
**Operation:** `lineinfile: path=/etc/fstab line=X`

#### /etc/pacman.conf
**Source:** `extra-settings/pacman.conf`
**Key customizations:**
- Color
- ILoveCandy
- VerbosePkgLists
- ParallelDownloads = 5
- DownloadUser = alpm
- Custom repo [endeavouros]

**Operation:** `copy: src=pacman.conf dest=/etc/pacman.conf mode=0644`
OR selective `lineinfile` for specific options

#### /etc/ssh/sshd_config
**Source:** `extra-settings/sshd_config`
**Content:** Hardened SSH config (modern crypto, no root login, only skogix user)
**Operation:** `copy: src=sshd_config dest=/etc/ssh/sshd_config mode=0600`
**Note:** File says "Ansible managed" - already templated?

### 2.2 Xorg Configurations

#### /etc/X11/xorg.conf.d/00-keyboard.conf
**Source:** `extra-settings/xorg.conf.d/00-keyboard.conf`
**Content:** Swedish keyboard layout (se + us_dvorak variant)
**Operation:** `copy: src=00-keyboard.conf dest=/etc/X11/xorg.conf.d/00-keyboard.conf`

#### /etc/X11/xorg.conf.d/30-scroll.conf
**Source:** `extra-settings/xorg.conf.d/30-scroll.conf`
**Operation:** `copy: src=X dest=/etc/X11/xorg.conf.d/Y`

#### /etc/X11/xorg.conf.d/30-button_mapping.conf
**Source:** `extra-settings/xorg.conf.d/30-button_mapping.conf`
**Operation:** `copy: src=X dest=/etc/X11/xorg.conf.d/Y`

### 2.3 Kernel Module Configurations

#### /etc/modprobe.d/mlx4.conf
**Source:** `extra-settings/modprobe.d/mlx4.conf`
**Operation:** `copy: src=X dest=/etc/modprobe.d/X`

#### /etc/modprobe.d/truescale.conf
**Source:** `extra-settings/modprobe.d/truescale.conf`
**Operation:** `copy: src=X dest=/etc/modprobe.d/X`

### 2.4 Udev Rules

#### /etc/udev/rules.d/99-jbl-headphones.rules
**Source:** `extra-settings/rules.d/99-jbl-headphones.rules`
**Operation:** `copy: src=X dest=/etc/udev/rules.d/X mode=0644`

### 2.5 Systemd Unit Files (custom services)

#### /etc/systemd/system/cloudflared.service
**Source:** `extra-settings/cloudflared.service`
**Content:** Cloudflare tunnel service with token
**Operation:** `copy: src=X dest=/etc/systemd/system/X mode=0644`
**Note:** Contains secret token - needs vault/secret management!

#### /etc/systemd/system/cloudflared-update.service
**Source:** `extra-settings/cloudflared-update.service`
**Operation:** `copy: src=X dest=/etc/systemd/system/X mode=0644`

#### /etc/systemd/system/paccache.service
**Source:** `extra-settings/paccache.service`
**Operation:** `copy: src=X dest=/etc/systemd/system/X mode=0644`

### 2.6 LightDM Configuration
**Source:** `extra-settings/lightdm/` (multiple files)
- lightdm.conf
- slick-greeter.conf
- users.conf
- keys.conf
- lightdm.conf.d/10-eos-slick.conf
- Xsession

**Operation:** `copy: src=lightdm/{{ item }} dest=/etc/lightdm/{{ item }}`

### 2.7 System Configuration from archinstall JSON

**From user_configuration.json:**
- Hostname: skogix-workstation
- Timezone: Europe/Stockholm
- Locale: en_US.UTF-8 (encoding: UTF-8)
- Keyboard: sv-latin1
- Bootloader: systemd-boot
- NTP: enabled
- Network: NetworkManager
- Audio: pipewire
- Swap: enabled
- Mirror region: Sweden (multiple mirrors)

**Operations:**
- `hostname: name=skogix-workstation`
- `timezone: name=Europe/Stockholm`
- `locale_gen: name=en_US.UTF-8 state=present`
- systemd-timesyncd enabled (already in services list)

---

## 3. QUERY_STATE (Check Current State)
*Discover current state before making decisions*

### 3.1 Existing Query Patterns
**Already used:** `stat: path=/usr/bin/yay register=yay_stat`

### 3.2 Needed Queries
- Check if fstab entries already exist before appending
- Check if users already exist before creating
- Check if kernel parameters are already set
- Check if services are already enabled

**Pattern:** `stat` + `register` + `when` conditions

---

## 4. SYNC_REPO (Git Repository Management)
*Clone/update git repositories*

### 4.1 Identified Needs
- Custom scripts in /usr/local/bin (if tracked in git)
- Dotfiles repository (if used - not explicit in data but common pattern)
- Any custom tool repositories

**Pattern:** `git: repo=X dest=Y update=true`

### 4.2 ZSH Related (from user's message)
```bash
# git clone https://github.com/zplug/zplug $ZPLUG_HOME
```
**Data:** $ZPLUG_HOME = $HOME/zsh.d/.zplug
**Operation:** `git: repo=https://github.com/zplug/zplug dest={{ zplug_home }}`

---

## 5. EXECUTE (Arbitrary Commands)
*Run commands that don't fit other primitives*

### 5.1 Kernel Boot Parameters
**Data:** `nvme_load=YES nowatchdog nvidia_drm.modeset=1`
**Current tool:** systemd-boot
**Operation:**
```yaml
- command: bootctl set-default X
# OR modify /boot/loader/entries/*.conf files
# OR use kernel-install hooks
```

### 5.2 Update GRUB (if using grub instead of systemd-boot)
**Operation:** `command: grub-mkconfig -o /boot/grub/grub.cfg`
**Note:** User is using systemd-boot, not GRUB

### 5.3 Reload udev rules
**After copying udev rules:**
```yaml
- command: udevadm control --reload-rules
- command: udevadm trigger
```

### 5.4 Systemd daemon-reload
**After copying systemd units:**
```yaml
- systemd: daemon_reload=yes
```

### 5.5 Package cache management
**Already have paccache.service + timer**
**Could also:** `command: paccache -r`

### 5.6 Mirror list update
**From user_configuration.json: Sweden mirrors**
**Could generate /etc/pacman.d/mirrorlist** with reflector or manually

### 5.7 NIX Installation (if needed)
**From SYSTEM_CONFIGS_TO_RESTORE.md:**
- NIX package manager detected in system
- Would need: `command: curl -L https://nixos.org/nix/install | sh`

---

## 6. COMPOSE (Task Orchestration)
*Include/organize other task files*

### 6.1 Existing Pattern
```yaml
- include_tasks: aur_user.yml
- include_tasks: aur_helper.yml
- include_tasks: aur_packages.yml
```

### 6.2 Proposed Structure
```yaml
tasks/
  system.yml              # Main orchestrator
    - include_tasks: packages.yml
    - include_tasks: users.yml
    - include_tasks: system_configs.yml
    - include_tasks: xorg_configs.yml
    - include_tasks: systemd_units.yml
    - include_tasks: services.yml
    - include_tasks: kernel_params.yml
```

**OR:** Single large file with all tasks (AI-optimized, no human limits)

---

## 7. UPDATE_CACHE / UPGRADE
*Special package operations*

### 7.1 Existing Operations
```yaml
- pacman: update_cache=true
- pacman: upgrade=true
```

### 7.2 Timing
- Run at start: update cache
- Run conditionally: upgrade only if requested
- Run after: package installation

---

## SPECIAL CONSIDERATIONS

### Secrets Management
**Identified secrets:**
1. User passwords (encrypted in user_credentials.json)
2. Cloudflared tunnel token (in cloudflared.service)
3. Root password (encrypted in user_credentials.json)

**Options:**
- ansible-vault for encrypting files
- Environment variables loaded via direnv
- Separate secrets.yml (vaulted)

### Execution Order Dependencies
```
1. Update package cache
2. Install base packages (base-devel, git)
3. Create aur_builder user
4. Install yay
5. Install official packages
6. Install AUR packages
7. Create actual users (skogix, aldervall)
8. Copy system configuration files
9. Copy systemd units
10. Enable/start services
11. Set kernel parameters
12. Reboot (if needed for kernel params)
```

### Idempotency Checks
- fstab: check before appending (avoid duplicates)
- Users: check existence
- Files: use creates= or when= conditions
- Services: systemd module handles this automatically

### Variable Data (for vars/main.yml expansion)

```yaml
# System identity
hostname: skogix-workstation
timezone: Europe/Stockholm
locale: en_US.UTF-8
keyboard_layout: sv-latin1

# Users (from user_credentials.json)
users:
  - username: skogix
    password: $y$j9T$BCeRhW2F299w7JlZVjol00$be9ri4X9MqwLZP3sXpllBIwv/o05raETY.iR0NL3FU.
    sudo: true
    shell: /bin/zsh
  - username: aldervall
    password: $y$j9T$rOLZg03kIXiPnjkmOUcSd.$5t1HNKSoUaMcaO0C/Z4cVrPIhUEZV47IkxFi95j.Kv1
    sudo: false
    shell: /bin/bash

root_password: $y$j9T$9fAuAjI3Q57wDxeuPYNKS0$KBhElxRFUB1xPQQrCrYfQnzCGmUy2Cjb9TjsElvYIpC

# Packages (from packages_explicit.txt - 477 packages)
packages: [list...]

# AUR packages (from packages_aur.txt - 67 packages)
aur_packages: [list...]

# Filesystems
fstab_entries:
  - uuid: 93f3c5d5-d775-4364-abc2-09161102aa04
    path: /mnt/extra
    fstype: ext4
    options: defaults
    dump: 0
    pass: 2
  - uuid: 4cb7e060-09f1-455d-8a4b-dea8286c6c0a
    path: /mnt/warez
    fstype: ext4
    options: defaults
    dump: 0
    pass: 2

# Services (from services_enabled.txt)
services_enabled:
  - autorandr.service
  - avahi-daemon.service
  - cloudflared.service
  - containerd.service
  - docker.service
  - getty@.service
  - lightdm.service
  - NetworkManager.service
  - NetworkManager-dispatcher.service
  - NetworkManager-wait-online.service
  - nvidia-hibernate.service
  - nvidia-resume.service
  - nvidia-suspend.service
  - podman.service
  - postgresql.service
  - power-profiles-daemon.service
  - soft-serve.service
  - sshd.service
  - warp-svc.service

sockets_enabled:
  - avahi-daemon.socket
  - podman.socket

timers_enabled:
  - fstrim.timer
  - paccache.timer

# Kernel parameters
kernel_cmdline_params:
  - nvme_load=YES
  - nowatchdog
  - nvidia_drm.modeset=1

# Environment variables
environment_vars:
  BROWSER: firefox
  EDITOR: nano

# Configuration file sources
config_files:
  - src: sshd_config
    dest: /etc/ssh/sshd_config
    mode: '0600'
  - src: pacman.conf
    dest: /etc/pacman.conf
    mode: '0644'
  - src: environment
    dest: /etc/environment
    mode: '0644'

xorg_configs:
  - src: xorg.conf.d/00-keyboard.conf
    dest: /etc/X11/xorg.conf.d/00-keyboard.conf
  - src: xorg.conf.d/30-scroll.conf
    dest: /etc/X11/xorg.conf.d/30-scroll.conf
  - src: xorg.conf.d/30-button_mapping.conf
    dest: /etc/X11/xorg.conf.d/30-button_mapping.conf

modprobe_configs:
  - src: modprobe.d/mlx4.conf
    dest: /etc/modprobe.d/mlx4.conf
  - src: modprobe.d/truescale.conf
    dest: /etc/modprobe.d/truescale.conf

udev_rules:
  - src: rules.d/99-jbl-headphones.rules
    dest: /etc/udev/rules.d/99-jbl-headphones.rules

systemd_units:
  - src: cloudflared.service
    dest: /etc/systemd/system/cloudflared.service
  - src: cloudflared-update.service
    dest: /etc/systemd/system/cloudflared-update.service
  - src: paccache.service
    dest: /etc/systemd/system/paccache.service

lightdm_configs:
  - src: lightdm/lightdm.conf
    dest: /etc/lightdm/lightdm.conf
  - src: lightdm/slick-greeter.conf
    dest: /etc/lightdm/slick-greeter.conf
  - src: lightdm/users.conf
    dest: /etc/lightdm/users.conf
  - src: lightdm/keys.conf
    dest: /etc/lightdm/keys.conf
  - src: lightdm/Xsession
    dest: /etc/lightdm/Xsession
  - src: lightdm/lightdm.conf.d/10-eos-slick.conf
    dest: /etc/lightdm/lightdm.conf.d/10-eos-slick.conf
```

---

## GAPS / MISSING DATA

### 1. Dotfiles (User-level configs)
Not in system backup - mentioned as "already backed up" in SYSTEM_CONFIGS_TO_RESTORE.md
- ~/.zshrc (ZSH config - user showed snippet with zplug)
- ~/.gitconfig
- ~/.config/i3/ (i3wm config)
- ~/.config/kitty/
- ~/.config/nvim/
- All other dotfiles

**Strategy:** Separate dotfile management? Or include in Ansible?

### 2. Custom Scripts
**Mentioned in SYSTEM_CONFIGS_TO_RESTORE.md:**
- /usr/local/bin/forge (user: skogix)
- /usr/local/bin/kubectl
- /usr/local/bin/profile-activate
- /usr/local/bin/yai

**Need:** Source files or git repos for these

### 3. Application Data
- PostgreSQL databases/users (packages installed but no data)
- Docker containers/images/volumes
- MongoDB data
- NIX packages (if using)

**Strategy:** Separate backup/restore? Or initialization scripts?

### 4. Firewall Rules
Not mentioned in current data
**Check if needed:** iptables/nftables rules?

### 5. GPU/Driver Configuration
**Mentioned:**
- nvidia packages installed
- nvidia_drm.modeset=1 kernel param
- nvidia-hibernate/resume/suspend services

**Missing:** Any additional nvidia-settings configs?

---

## NEXT STEPS

1. ✅ Gather all config data (DONE)
2. ✅ Categorize by primitives (DONE - this document)
3. → Structure vars/main.yml with all data
4. → Create task files (or single task file) using the 7 primitives
5. → Test in isolated environment (git worktree)
6. → Iterate until complete
