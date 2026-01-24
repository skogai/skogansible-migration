---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/84"]
tags: ["phase-2", "new-role", "github"]
---

# Optional: Xorg configuration management role

**Source**: [Github #84](https://github.com/SkogAI/skogansible/issues/84)

## Description

## Purpose

Manage Xorg configuration (keyboard layout, mouse settings) through Ansible.

**Note**: Only implement if staying with X11 (vs migrating to Wayland)

## Reference

- Keyboard: Swedish (se) with us_dvorak variant
- Mouse: Button 12 for middle-click scroll
- Config files: `backup/todo/extra-settings/xorg.conf.d/`

## Tasks

- [ ] Decide: Staying with X11 or migrating to Wayland?
- [ ] If X11: Create roles/xorg/ directory structure
- [ ] Create vars/xorg.yml with configuration
- [ ] Add ta

## Notes

*Imported from external tracker. See source link for full context.*
