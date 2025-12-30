# Filesystems Role

Ansible role for managing filesystem mounts on Arch Linux systems.

## Features

- ✅ Create mount point directories with proper permissions
- ✅ Manage `/etc/fstab` entries using UUID-based mounting
- ✅ Mount/unmount filesystems
- ✅ Automatic fstab backup before changes
- ✅ Support for various filesystem types (ext4, btrfs, xfs, etc.)
- ✅ Configurable mount options
- ✅ Idempotent operations

## Role Variables

### Control Variables

Available in `defaults/main.yml`:

```yaml
# Enable/disable mount management
filesystems_manage_mounts: true

# Create mount point directories automatically
filesystems_create_mount_points: true

# Mount point directory permissions
filesystems_mount_point_mode: "0755"
filesystems_mount_point_owner: root
filesystems_mount_point_group: root

# Backup fstab before making changes
filesystems_backup_fstab: true
```

### Mount Definitions

Define your mounts in `vars/filesystems.yml`:

```yaml
data_mounts:
  - path: /mnt/extra
    uuid: 93f3c5d5-d775-4364-abc2-09161102aa04
    fstype: ext4
    opts: defaults
    state: mounted
    dump: 0
    passno: 2

  - path: /mnt/warez
    uuid: 4cb7e060-09f1-455d-8a4b-dea8286c6c0a
    fstype: ext4
    opts: defaults
    state: mounted
    dump: 0
    passno: 2
```

### Mount Configuration Options

Each mount entry supports the following parameters:

- **`path`** (required): Mount point directory path
- **`uuid`** (required): Filesystem UUID (use `blkid` to find)
- **`fstype`** (required): Filesystem type (ext4, xfs, btrfs, ntfs, etc.)
- **`opts`** (optional): Mount options (default: "defaults")
- **`state`** (optional): Mount state (default: "mounted")
  - `mounted`: Add to fstab and mount immediately
  - `present`: Add to fstab but don't mount
  - `unmounted`: Keep in fstab but unmount
  - `absent`: Remove from fstab and unmount
- **`dump`** (optional): Dump backup field (default: 0)
- **`passno`** (optional): Fsck pass number (default: 2)

## Example Playbook

```yaml
---
- name: Configure filesystem mounts
  hosts: all

  vars_files:
    - vars/filesystems.yml

  roles:
    - role: filesystems
      tags: [filesystems]
```

## Usage

### Run the entire role

```bash
./run.sh --tags filesystems
```

### Dry-run to see what changes would be made

```bash
./run.sh --tags filesystems --check
```

### Only create mount points (don't modify fstab)

```bash
./run.sh --tags filesystems-mount-points
```

### Only manage fstab entries

```bash
./run.sh --tags filesystems-fstab
```

## Finding Filesystem UUIDs

Use `blkid` to find the UUID of your filesystems:

```bash
# List all block devices with UUIDs
sudo blkid

# Find UUID for a specific device
sudo blkid /dev/sda1

# Or use lsblk with filesystem info
lsblk -f
```

Example output:

```
/dev/sda1: UUID="93f3c5d5-d775-4364-abc2-09161102aa04" TYPE="ext4"
```

## Common Mount Options

### Basic Options

- `defaults`: Use default options (rw, suid, dev, exec, auto, nouser, async)
- `rw`: Mount read-write
- `ro`: Mount read-only
- `noatime`: Don't update access times (improves performance)
- `relatime`: Update access times relatively (good balance)

### Performance Options

```yaml
opts: "defaults,noatime,nodiratime"
```

### Network File Systems

```yaml
opts: "defaults,_netdev"  # Wait for network before mounting
```

### User Permissions

```yaml
opts: "defaults,uid=1000,gid=1000"  # Set owner/group for FAT/NTFS
```

## Example Configurations

### Data Drive

```yaml
data_mounts:
  - path: /mnt/data
    uuid: 93f3c5d5-d775-4364-abc2-09161102aa04
    fstype: ext4
    opts: defaults,noatime
    state: mounted
```

### Backup Drive (mount manually)

```yaml
data_mounts:
  - path: /mnt/backup
    uuid: 4cb7e060-09f1-455d-8a4b-dea8286c6c0a
    fstype: ext4
    opts: defaults,noauto
    state: present
```

### Removable Media

```yaml
data_mounts:
  - path: /mnt/usb
    uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    fstype: vfat
    opts: defaults,uid=1000,gid=1000,umask=0022
    state: mounted
```

### Unmount and Remove

```yaml
data_mounts:
  - path: /mnt/old-drive
    uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    fstype: ext4
    state: absent
```

## Tags

This role supports the following tags:

- `filesystems`: Run all filesystem tasks
- `filesystems-mount-points`: Only create mount point directories
- `filesystems-mount`: Only mount filesystems
- `filesystems-fstab`: Only manage fstab entries

## Safety Features

1. **Backup**: Automatically backs up `/etc/fstab` before modifications
2. **Idempotent**: Safe to run multiple times
3. **UUID-based**: Uses UUIDs instead of device names (more reliable)
4. **Directory Creation**: Creates mount points before mounting

## Troubleshooting

### Mount fails with "mount point does not exist"

The role should create mount points automatically. If it fails, check:

- The `filesystems_create_mount_points` variable is `true`
- The parent directory exists (e.g., `/mnt` for `/mnt/extra`)

### Mount fails with "wrong fs type"

- Verify the filesystem type with `blkid`
- Ensure the necessary filesystem driver is installed

### Mount fails with "can't find UUID"

- Double-check the UUID with `sudo blkid`
- Ensure the disk is properly connected

### Changes not persisting after reboot

- Check that `state: mounted` is set (not just `present`)
- Verify the fstab entry with `cat /etc/fstab`
