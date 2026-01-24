---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/95"]
tags: ["from:archive", "extraction", "phase-1", "github"]
---

# Integrate system timers: fstrim, paccache, reflector, keyring

**Source**: [Github #95](https://github.com/SkogAI/skogansible/issues/95)

## Description

## Summary
Integrate systemd timer management for system maintenance tasks.

## Source
- `tmp/archive-2025-10-05-ansible/tasks/skogai-core.yml`

## Timers to Enable
- [ ] `fstrim.timer` - Weekly SSD TRIM
- [ ] `paccache.timer` - Weekly package cache cleanup
- [ ] `reflector.timer` - Mirror list updates
- [ ] `archlinux-keyring-wkd-sync.timer` - Weekly keyring updates
- [ ] `plocate-updatedb.timer` - File database updates (12h)

## Custom Timers to Create
- [ ] `trash-empty.timer` - Daily trash c

## Notes

*Imported from external tracker. See source link for full context.*
