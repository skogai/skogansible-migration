# Ansible Role: Timers

Systemd timer management role for Arch Linux system maintenance tasks.

This role provides:

- Enable and manage standard Arch Linux system timers
- Create and manage custom systemd timers
- Automatic trash cleanup with configurable retention

## Requirements

- Ansible 2.10 or higher
- `ansible.posix` collection (for `systemd` module)
- Target system: Arch Linux
- Systemd as init system

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/timers.yml`.

### Timer Management

```yaml
timers_enable: true                    # Enable timer management
```

### System Timers

```yaml
timers_system_enabled:                 # List of system timers to enable
  - fstrim.timer                       # Weekly SSD TRIM
  - paccache.timer                     # Weekly package cache cleanup
  - reflector.timer                    # Mirror list updates
  - archlinux-keyring-wkd-sync.timer   # Weekly keyring updates
  - plocate-updatedb.timer             # File database updates (12h)
```

### Custom Timers

```yaml
timers_custom_enabled: true            # Enable custom timer creation
```

### Trash Empty Timer

```yaml
timers_trash_empty_enabled: true       # Enable trash-empty timer
timers_trash_empty_days: 30            # Delete trash older than N days
timers_trash_empty_schedule: daily     # When to run (daily, weekly, monthly)
```

## Dependencies

- `trash-cli` package (for trash-empty command)

## Example Playbook

### Basic Usage

Enable all default timers:

```yaml
- hosts: localhost
  roles:
    - role: timers
```

### Custom Configuration

Enable only specific timers:

```yaml
- hosts: localhost
  roles:
    - role: timers
      vars:
        timers_system_enabled:
          - fstrim.timer
          - paccache.timer
        timers_trash_empty_enabled: true
        timers_trash_empty_days: 14
        timers_trash_empty_schedule: weekly
```

### With Variables File

```yaml
- hosts: localhost
  vars_files:
    - vars/timers.yml
  roles:
    - timers
```

## Role Tasks

The role executes tasks in this order:

### 1. Enable System Timers

- Enables and starts each timer in `timers_system_enabled` list
- Uses `ansible.posix.systemd` module for idempotency
- Requires elevated privileges (`become: true`)

### 2. Setup Custom Timers

- Deploys trash-empty service unit from template
- Deploys trash-empty timer unit from template
- Reloads systemd daemon when units change
- Enables and starts custom timers

## Tags

The role supports granular execution via tags:

- `timers` - All timer tasks
- `timers-system` - System timer enablement only
- `timers-custom` - Custom timer setup only
- `trash-empty` - Trash-empty timer only

### Tag Usage Examples

```bash
# Enable all timers
./run.sh --tags timers

# Enable only system timers
./run.sh --tags timers-system

# Setup only custom timers
./run.sh --tags timers-custom

# Setup only trash-empty timer
./run.sh --tags trash-empty
```

## System Timer Descriptions

### fstrim.timer

**Purpose:** Weekly SSD TRIM operation for better performance and longevity

**Default schedule:** Weekly

**What it does:** Discards unused blocks on mounted filesystems that support TRIM

### paccache.timer

**Purpose:** Clean old package cache files to save disk space

**Default schedule:** Weekly

**What it does:** Removes old versions of installed packages from `/var/cache/pacman/pkg/`

### reflector.timer

**Purpose:** Update pacman mirrorlist with fastest mirrors

**Default schedule:** Weekly

**What it does:** Ranks mirrors by speed and updates `/etc/pacman.d/mirrorlist`

### archlinux-keyring-wkd-sync.timer

**Purpose:** Keep Arch Linux package signing keys up to date

**Default schedule:** Weekly

**What it does:** Synchronizes package signing keys via Web Key Directory

### plocate-updatedb.timer

**Purpose:** Update file database for fast file searches

**Default schedule:** Every 12 hours

**What it does:** Updates the database used by `plocate` command

## Custom Timer: trash-empty

### Purpose

Automatically clean old files from trash to prevent disk space issues.

### Configuration

```yaml
timers_trash_empty_enabled: true       # Enable/disable timer
timers_trash_empty_days: 30            # Delete files older than N days
timers_trash_empty_schedule: daily     # When to run
```

### Schedule Options

- `daily` - Run once per day
- `weekly` - Run once per week
- `monthly` - Run once per month
- Custom systemd calendar expression (e.g., `*-*-* 03:00:00`)

### Files Created

- `/etc/systemd/system/trash-empty.service` - Service unit
- `/etc/systemd/system/trash-empty.timer` - Timer unit

### Manual Operation

```bash
# Check timer status
systemctl status trash-empty.timer

# Run manually
systemctl start trash-empty.service

# View logs
journalctl -u trash-empty.service
```

## Verifying Timer Status

Check which timers are enabled and their next run time:

```bash
# List all timers
systemctl list-timers

# Check specific timer
systemctl status fstrim.timer

# View timer logs
journalctl -u fstrim.timer
```

## Troubleshooting

### Timer not running

Check if timer is enabled:

```bash
systemctl status <timer-name>
```

Check if timer is loaded:

```bash
systemctl list-unit-files | grep timer
```

### Custom timer not found

Ensure systemd daemon was reloaded:

```bash
sudo systemctl daemon-reload
```

### trash-empty fails

Ensure trash-cli is installed:

```bash
pacman -Q trash-cli
```

If not installed, add to `vars/packages.yml`:

```yaml
packages:
  - trash-cli
```

## Role Structure

```
roles/timers/
├── tasks/
│   ├── main.yml                    # Main task orchestrator
│   ├── enable_system_timers.yml    # Enable system timers
│   └── setup_custom_timers.yml     # Setup custom timers
├── templates/
│   ├── trash-empty.service.j2      # Trash service unit
│   └── trash-empty.timer.j2        # Trash timer unit
├── defaults/main.yml               # Default variables
├── handlers/main.yml               # Systemd daemon-reload handler
├── meta/main.yml                   # Role metadata
└── README.md                       # This file
```

## Integration with Other Roles

This role complements:

- **packages** - Ensures required packages (trash-cli, reflector) are installed
- **filesystems** - Works with fstrim for SSD maintenance

## Adding Custom Timers

To add your own custom timer:

1. Create service template in `templates/your-timer.service.j2`
2. Create timer template in `templates/your-timer.timer.j2`
3. Add tasks to `tasks/setup_custom_timers.yml`
4. Add variables to `defaults/main.yml`

Example:

```yaml
# templates/backup.service.j2
[Unit]
Description=Daily backup
[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh

# templates/backup.timer.j2
[Unit]
Description=Daily backup timer
[Timer]
OnCalendar=daily
Persistent=true
[Install]
WantedBy=timers.target
```

## License

MIT

## Author

SkogAI (skogansible repository)
