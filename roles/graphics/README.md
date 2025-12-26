# Ansible Role: Graphics

GPU driver and Ollama management role for Arch Linux systems.

This role provides automated GPU driver installation and Ollama AI model management including:

- NVIDIA driver installation (nvidia, nvidia-utils, lib32-nvidia-utils)
- AMD driver installation (xf86-video-amdgpu, vulkan-radeon)
- Intel driver installation (xf86-video-intel, vulkan-intel)
- CUDA toolkit installation (optional)
- Ollama installation (pacman or script method)
- Ollama service management
- Ollama model pulling
- Automatic initramfs regeneration

## Requirements

- Ansible 2.10 or higher
- `community.general` collection (for `pacman` module)
- Target system: Arch Linux
- User must have sudo privileges

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/graphics.yml`.

### GPU Driver Selection

```yaml
graphics_driver: "none"          # Options: nvidia, amd, intel, none
```

### NVIDIA Drivers

```yaml
graphics_nvidia_packages:
  - nvidia
  - nvidia-utils
  - lib32-nvidia-utils
```

### AMD Drivers

```yaml
graphics_amd_packages:
  - xf86-video-amdgpu
  - vulkan-radeon
  - lib32-vulkan-radeon
```

### Intel Drivers

```yaml
graphics_intel_packages:
  - xf86-video-intel
  - vulkan-intel
  - lib32-vulkan-intel
```

### CUDA Toolkit

```yaml
graphics_install_cuda: false     # Install CUDA toolkit (requires nvidia driver)
graphics_cuda_packages:
  - cuda
  - cudnn
```

### Ollama Installation

```yaml
graphics_install_ollama: true
graphics_ollama_method: "pacman"           # Options: pacman, script
graphics_ollama_script_url: "https://ollama.ai/install.sh"
```

### Ollama Service

```yaml
graphics_ollama_enable_service: true
graphics_ollama_service_state: "started"   # Options: started, stopped
```

### Ollama Models

```yaml
graphics_ollama_models: []       # List of models to pull after installation
# Example:
# graphics_ollama_models:
#   - llama2
#   - codellama
#   - mistral
```

### System Configuration

```yaml
graphics_regenerate_initramfs: true   # Regenerate initramfs after driver installation
```

## Dependencies

None.

## Example Playbooks

### Basic NVIDIA Setup

Install NVIDIA drivers and Ollama:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "nvidia"
        graphics_install_ollama: true
        graphics_ollama_models:
          - llama2
```

### AMD with CUDA Disabled

Install AMD drivers without CUDA:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "amd"
        graphics_install_cuda: false
        graphics_install_ollama: true
```

### NVIDIA with CUDA

Install NVIDIA drivers, CUDA toolkit, and Ollama:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "nvidia"
        graphics_install_cuda: true
        graphics_install_ollama: true
        graphics_ollama_models:
          - llama2
          - codellama
          - mistral
```

### Intel Graphics

Install Intel drivers:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "intel"
        graphics_install_ollama: false
```

### Ollama Only (No GPU Drivers)

Install and configure Ollama without GPU driver changes:

```yaml
- hosts: localhost
  roles:
    - role: graphics
      vars:
        graphics_driver: "none"
        graphics_install_ollama: true
        graphics_ollama_method: "script"
        graphics_ollama_models:
          - llama2
```

### With Variables File

Using `vars/graphics.yml`:

```yaml
- hosts: localhost
  vars_files:
    - vars/graphics.yml
  roles:
    - graphics
  tags:
    - graphics
```

## Role Tasks

The role executes tasks in this order:

### 1. Driver Installation (`drivers.yml`)

Installs GPU drivers based on `graphics_driver` selection:

- **NVIDIA**: Installs nvidia, nvidia-utils, lib32-nvidia-utils
- **AMD**: Installs xf86-video-amdgpu, vulkan-radeon, lib32-vulkan-radeon
- **Intel**: Installs xf86-video-intel, vulkan-intel, lib32-vulkan-intel

Notifies `Regenerate initramfs` handler after driver installation.

### 2. CUDA Installation (`cuda.yml`)

Installs CUDA toolkit if enabled:

- Verifies NVIDIA drivers are installed
- Installs cuda and cudnn packages

**Note**: CUDA requires NVIDIA drivers (`graphics_driver: nvidia`).

### 3. Ollama Installation (`ollama.yml`)

Installs and configures Ollama:

- Installs Ollama via pacman or install script
- Enables and starts Ollama systemd service
- Waits for Ollama to be ready (port 11434)
- Pulls specified models

### 4. Initramfs Regeneration

Regenerates initramfs after driver installation:

- Runs `mkinitcpio -P` to rebuild initramfs
- Notifies that system reboot is required

## Tags

The role supports granular execution via tags:

- `graphics` - All graphics tasks
- `drivers` - GPU driver installation only
- `cuda` - CUDA toolkit installation only
- `ollama` - Ollama installation and configuration only
- `initramfs` - Initramfs regeneration only

### Tag Usage Examples

```bash
# Install only GPU drivers
ansible-playbook playbooks/workstation.yml --tags graphics,drivers

# Install only Ollama
ansible-playbook playbooks/workstation.yml --tags graphics,ollama

# Full graphics setup
ansible-playbook playbooks/workstation.yml --tags graphics
```

## Variables File Example

Create `vars/graphics.yml`:

```yaml
---
# GPU driver selection
graphics_driver: "nvidia"

# CUDA toolkit
graphics_install_cuda: false

# Ollama configuration
graphics_install_ollama: true
graphics_ollama_method: "pacman"
graphics_ollama_enable_service: true
graphics_ollama_service_state: "started"

# Ollama models
graphics_ollama_models:
  - llama2
  - codellama
  - mistral

# System configuration
graphics_regenerate_initramfs: true
```

## Handlers

### Regenerate initramfs

Triggered after driver installation:

```yaml
- name: Regenerate initramfs
  become: true
  ansible.builtin.command:
    cmd: mkinitcpio -P
```

### Reboot required

Displays warning that system reboot is required:

```yaml
- name: Reboot required
  ansible.builtin.debug:
    msg: "⚠️  System reboot required for GPU driver changes to take effect"
```

## Security Considerations

### Driver Installation

GPU driver installation requires:

- Sudo privileges (`become: true`)
- System reboot after installation
- Initramfs regeneration

### Ollama Installation

Ollama can be installed via:

- **pacman** (recommended): Official Arch package
- **script**: Downloads and runs install script from ollama.ai

The script method executes remote code. Review the script before using:

```bash
curl -fsSL https://ollama.ai/install.sh | less
```

### CUDA Requirements

CUDA toolkit requires NVIDIA drivers. The role will fail if CUDA is enabled without `graphics_driver: nvidia`.

## Troubleshooting

### Driver Installation Fails

Check system compatibility:

```bash
# NVIDIA
lspci | grep -i nvidia

# AMD
lspci | grep -i amd

# Intel
lspci | grep -i intel
```

### Initramfs Regeneration Fails

Manually regenerate:

```bash
sudo mkinitcpio -P
```

Check for errors in `/var/log/pacman.log`.

### Ollama Service Won't Start

Check service status:

```bash
sudo systemctl status ollama
journalctl -u ollama -f
```

Verify Ollama installation:

```bash
which ollama
ollama --version
```

### CUDA Installation Fails

Ensure NVIDIA drivers are installed:

```bash
nvidia-smi
```

Verify CUDA compatibility with GPU:

```bash
lspci | grep -i nvidia
# Check GPU model against CUDA compatibility list
```

### Ollama Model Pull Fails

Check Ollama service is running:

```bash
systemctl status ollama
```

Manually pull model:

```bash
ollama pull llama2
```

Check disk space:

```bash
df -h
```

## Post-Installation

### After Driver Installation

**System reboot required** for GPU driver changes to take effect:

```bash
sudo reboot
```

### Verify GPU Driver

After reboot, verify driver is loaded:

```bash
# NVIDIA
nvidia-smi

# AMD
glxinfo | grep -i amd

# Intel
glxinfo | grep -i intel
```

### Verify Ollama

Check Ollama is running:

```bash
systemctl status ollama
ollama list  # List installed models
```

Test a model:

```bash
ollama run llama2
```

## File Structure

```
roles/graphics/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   ├── main.yml              # Main task orchestrator
│   ├── drivers.yml           # GPU driver installation
│   ├── cuda.yml              # CUDA toolkit installation
│   └── ollama.yml            # Ollama installation and configuration
├── handlers/
│   └── main.yml              # Initramfs regeneration handler
├── meta/
│   └── main.yml              # Role metadata
└── README.md                 # This file
```

## Integration with Playbook

Add graphics role to your playbook:

```yaml
---
- name: System configuration
  hosts: localhost
  connection: local

  vars_files:
    - vars/main.yml
    - vars/packages.yml
    - vars/graphics.yml

  roles:
    - packages
    - graphics

  tags:
    - all
```

## Performance Considerations

### Driver Installation

- Large packages (nvidia, cuda): 500MB - 3GB download
- Installation time: 2-10 minutes depending on connection speed

### Ollama Installation

- Ollama package: ~50MB
- Model downloads: 4GB - 70GB per model
- First model pull can take 10-60 minutes

### Initramfs Regeneration

- Time: 10-30 seconds
- Required for driver changes to take effect

## Further Reading

- **NVIDIA on Arch Wiki**: https://wiki.archlinux.org/title/NVIDIA
- **AMD on Arch Wiki**: https://wiki.archlinux.org/title/AMDGPU
- **Intel Graphics**: https://wiki.archlinux.org/title/Intel_graphics
- **CUDA**: https://wiki.archlinux.org/title/GPGPU
- **Ollama Documentation**: https://ollama.ai/docs

## License

MIT

## Author

SkogAI (skogansible repository)
