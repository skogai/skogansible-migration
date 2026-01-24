---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/80"]
tags: ["phase-2", "new-role", "github"]
---

# New role: Environment variables management

**Source**: [Github #80](https://github.com/SkogAI/skogansible/issues/80)

## Description

## Purpose
Manage global environment variables through Ansible.

## Reference
- Current settings: `backup/todo/extra-settings/environment`
- Variables to manage:
  - BROWSER=firefox
  - EDITOR=nano

## Tasks
- [ ] Create `roles/environment/` directory structure
- [ ] Create `vars/environment.yml` with variable definitions
- [ ] Add tasks to manage /etc/environment
- [ ] Add role to playbook.yml
- [ ] Test on current system

## Implementation Notes
- Use lineinfile module for /etc/environment
- S

## Notes

*Imported from external tracker. See source link for full context.*
