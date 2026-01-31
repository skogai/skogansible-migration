---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/92"]
tags: ["extraction", "new-role", "from:ansible-base", "phase-1", "github"]
---

# New role: graphics - GPU drivers and Ollama setup

**Source**: [Github #92](https://github.com/SkogAI/skogansible/issues/92)

## Description

## Summary

Create a new `roles/graphics/` role extracted from `ansible-base/roles/08-graphics/`.

## Source

- `tmp/ansible-base/roles/08-graphics/tasks/main.yml`
- `tmp/ansible-base/roles/08-graphics/defaults/main.yml`

## Features to Include

- [ ] NVIDIA driver installation (nvidia, nvidia-utils, lib32-nvidia-utils)
- [ ] AMD driver installation (xf86-video-amdgpu, vulkan-radeon)
- [ ] Intel driver installation (xf86-video-intel, vulkan-intel)
- [ ] CUDA toolkit installation (optional)
- [ ] Ol

## Notes

*Imported from external tracker. See source link for full context.*
