# Ansible Role: Graphics

GPU driver and Ollama management role for Arch Linux systems.

This role provides comprehensive graphics and AI infrastructure management including:

- NVIDIA GPU drivers and CUDA toolkit
- AMD GPU drivers and Vulkan support
- Intel GPU drivers and Vulkan support
- Ollama AI model server installation and configuration
- Automatic model pulling and service management
- Initramfs regeneration for kernel module updates

## Requirements

- Ansible 2.10 or higher
- `community.general` collection (for `pacman` module)
- Target system: Arch Linux
- User must have sudo privileges
- Compatible GPU hardware (NVIDIA, AMD, or Intel)

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/graphics.yml`.

### GPU Driver Selection

```yaml
graphics_driver: "none"              # Options: nvidia, amd, intel, none
graphics_install_drivers: false      # Set to true to install GPU drivers
```

### NVIDIA Configuration

```yaml
graphics_nvidia_packages:            # NVIDIA driver packages
  - nvidia
  - nvidia-utils
  - lib32-nvidia-utils
graphics_nvidia_install_cuda: false  # Install CUDA toolkit
graphics_nvidia_cuda_packages:       # CUDA packages
  - cuda
  - cuda-tools
```

### AMD Configuration

```yaml
graphics_amd_packages:               # AMD driver packages
  - xf86-video-amdgpu
  - vulkan-radeon
  - lib32-vulkan-radeon
```

### Intel Configuration

```yaml
graphics_intel_packages:             # Intel driver packages
  - xf86-video-intel
  - vulkan-intel
  - lib32-vulkan-intel
```

### Ollama Configuration

```yaml
graphics_install_ollama: true        # Install Ollama
graphics_ollama_method: "pacman"     # Installation method: pacman or script
graphics_ollama_install_url: "https://ollama.com/install.sh"  # Script URL
graphics_ollama_enable_service: true # Enable systemd service
graphics_ollama_start_service: true  # Start service after installation
```

### Ollama Model Management

```yaml
graphics_ollama_pull_models: false   # Automatically pull models
graphics_ollama_models: []           # List of models to pull
# Example models:
# - llama2
# - codellama
# - mistral
# - phi
```

### System Configuration

```yaml
graphics_regenerate_initramfs: false # Regenerate initramfs after driver installation
```

## Dependencies

None.

## Example Playbooks

### NVIDIA GPU Setup

Install NVIDIA drivers and Ollama:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "nvidia"
        graphics_install_drivers: true
        graphics_regenerate_initramfs: true
        graphics_install_ollama: true
```

### NVIDIA with CUDA and Models

Install NVIDIA drivers, CUDA toolkit, Ollama, and pull AI models:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "nvidia"
        graphics_install_drivers: true
        graphics_nvidia_install_cuda: true
        graphics_regenerate_initramfs: true
        graphics_install_ollama: true
        graphics_ollama_pull_models: true
        graphics_ollama_models:
          - llama2
          - codellama
          - mistral
```

### AMD GPU Setup

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "amd"
        graphics_install_drivers: true
        graphics_regenerate_initramfs: true
        graphics_install_ollama: true
```

### Intel GPU Setup

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "intel"
        graphics_install_drivers: true
        graphics_regenerate_initramfs: true
        graphics_install_ollama: true
```

### Ollama Only (No GPU Drivers)

Install only Ollama without GPU driver changes:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_install_drivers: false
        graphics_install_ollama: true
        graphics_ollama_method: "pacman"
```

### Ollama with Script Installation

Use the official Ollama installation script instead of pacman:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_install_drivers: false
        graphics_install_ollama: true
        graphics_ollama_method: "script"
```

## Role Tasks

The role executes tasks in this order:

### 1. GPU Driver Installation

Installs appropriate GPU drivers based on `graphics_driver`:

- **NVIDIA** (`nvidia.yml`): Installs nvidia, nvidia-utils, lib32-nvidia-utils, optionally CUDA
- **AMD** (`amd.yml`): Installs xf86-video-amdgpu, vulkan-radeon, lib32-vulkan-radeon
- **Intel** (`intel.yml`): Installs xf86-video-intel, vulkan-intel, lib32-vulkan-intel

All driver installations trigger initramfs regeneration if `graphics_regenerate_initramfs: true`.

### 2. Ollama Installation (`ollama.yml`)

- Installs Ollama via pacman or official script
- Enables and starts ollama systemd service
- Waits for service to be ready (port 11434)
- Pulls specified AI models

## Tags

The role supports granular execution via tags:

- `graphics` - All graphics tasks
- `nvidia` - NVIDIA driver tasks only
- `amd` - AMD driver tasks only
- `intel` - Intel driver tasks only
- `cuda` - CUDA toolkit installation
- `ollama` - Ollama installation and configuration
- `service` - Ollama service management
- `models` - AI model pulling

### Tag Usage Examples

```bash
# Install only NVIDIA drivers
ansible-playbook playbook.yml --tags nvidia

# Install only Ollama
ansible-playbook playbook.yml --tags ollama

# Install Ollama and pull models
ansible-playbook playbook.yml --tags ollama,models

# Full graphics setup
ansible-playbook playbook.yml --tags graphics
```

## Variables File Example

Create `vars/graphics.yml`:

```yaml
---
# GPU Configuration
graphics_driver: "nvidia"
graphics_install_drivers: true
graphics_nvidia_install_cuda: true
graphics_regenerate_initramfs: true

# Ollama Configuration
graphics_install_ollama: true
graphics_ollama_method: "pacman"
graphics_ollama_enable_service: true
graphics_ollama_start_service: true

# AI Models
graphics_ollama_pull_models: true
graphics_ollama_models:
  - llama2
  - codellama
  - mistral
  - phi
```

## Handlers

### Regenerate initramfs

Triggered when GPU drivers are installed and `graphics_regenerate_initramfs: true`:

```yaml
- name: Regenerate initramfs
  become: true
  ansible.builtin.command:
    cmd: mkinitcpio -P
```

**Important**: After initramfs regeneration, a system reboot is recommended to load the new kernel modules.

## Security Considerations

### Ollama Service

The Ollama service runs as a system service and listens on port 11434. By default, it's accessible only from localhost. To expose it to the network, additional firewall configuration may be required.

### CUDA Toolkit

The CUDA toolkit is large (~3GB) and includes development tools. Only install if you need CUDA development capabilities.

### Model Pulling

Model pulling can be bandwidth-intensive and time-consuming:

- llama2: ~4GB
- codellama: ~4GB
- mistral: ~4GB
- phi: ~1.6GB

Set `graphics_ollama_pull_models: false` and pull models manually if preferred:

```bash
ollama pull llama2
ollama pull codellama
```

## Troubleshooting

### GPU Drivers Not Loading

After driver installation, regenerate initramfs and reboot:

```bash
sudo mkinitcpio -P
sudo reboot
```

Verify driver loading:

```bash
# NVIDIA
nvidia-smi

# AMD
lspci -k | grep -A 3 VGA

# Intel
lspci -k | grep -A 3 VGA
```

### Ollama Service Not Starting

Check service status:

```bash
sudo systemctl status ollama
journalctl -u ollama -f
```

Verify Ollama binary:

```bash
which ollama
ollama --version
```

Test Ollama manually:

```bash
ollama serve  # Run in foreground to see errors
```

### Model Pulling Fails

Check network connectivity:

```bash
curl -I https://ollama.com
```

Check available disk space:

```bash
df -h /usr/share/ollama  # Default model storage
```

Pull models manually with verbose output:

```bash
ollama pull llama2 --verbose
```

### CUDA Not Found

Verify CUDA installation:

```bash
nvcc --version
ls -la /opt/cuda
```

Add CUDA to PATH in your shell profile:

```bash
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
```

### Initramfs Regeneration Fails

Check for errors:

```bash
sudo mkinitcpio -P
```

Common issues:

- Missing linux kernel package
- Corrupted kernel modules
- Insufficient disk space in /boot

## Testing

Test the role in check mode (dry-run):

```bash
ansible-playbook playbook.yml --tags graphics --check
```

Test specific components:

```bash
# Test NVIDIA driver installation
ansible-playbook playbook.yml --tags nvidia --check

# Test Ollama installation
ansible-playbook playbook.yml --tags ollama --check

# Test model pulling
ansible-playbook playbook.yml --tags models --check
```

## Role Structure

```
roles/graphics/
├── tasks/
│   ├── main.yml           # Main task orchestrator
│   ├── nvidia.yml         # NVIDIA driver installation
│   ├── amd.yml            # AMD driver installation
│   ├── intel.yml          # Intel driver installation
│   └── ollama.yml         # Ollama installation and configuration
├── defaults/main.yml      # Default variables
├── handlers/main.yml      # Initramfs regeneration handler
├── meta/main.yml          # Role metadata
└── README.md              # This file
```

## Integration with Playbook

Add the graphics role to your main playbook:

```yaml
---
- name: System configuration
  hosts: localhost
  connection: local

  vars_files:
    - vars/main.yml
    - vars/packages.yml
    - vars/graphics.yml  # Add this

  roles:
    - packages
    - graphics  # Add this
    - ssh
    - git
    - chezmoi

  tags:
    - all
```

Run with:

```bash
./run.sh --tags graphics
```

## License

MIT

## Author

SkogAI (skogansible repository)

## Further Reading

- [NVIDIA Arch Wiki](https://wiki.archlinux.org/title/NVIDIA)
- [AMDGPU Arch Wiki](https://wiki.archlinux.org/title/AMDGPU)
- [Intel Graphics Arch Wiki](https://wiki.archlinux.org/title/Intel_graphics)
- [Ollama Documentation](https://ollama.com/docs)
- [CUDA Toolkit Documentation](https://docs.nvidia.com/cuda/)
