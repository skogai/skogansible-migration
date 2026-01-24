---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/85"]
tags: ["phase-2", "new-role", "github"]
---

# New role: Kernel parameters management

**Source**: [Github #85](https://github.com/SkogAI/skogansible/issues/85)

## Description

## Purpose
Manage kernel boot parameters (especially NVIDIA and NVME settings) through Ansible.

## Reference
- Current kernel params: `backup/todo/extra-settings/kernel_cmdline.txt`
- Required params: nvidia_drm.modeset=1 (critical for NVIDIA), nowatchdog, nvme_load=YES

## Tasks
- [ ] Create roles/kernel/ directory structure
- [ ] Create vars/kernel.yml with parameter definitions
- [ ] Add tasks to manage GRUB_CMDLINE_LINUX_DEFAULT
- [ ] Add handler to update grub config
- [ ] Add role to play

## Notes

*Imported from external tracker. See source link for full context.*
