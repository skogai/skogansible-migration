# Molecule Testing for 01_host_info Role

This directory contains Molecule configuration for testing the `01_host_info` role in isolation using Docker containers.

## Prerequisites

1. **Install Molecule and Docker plugin:**
   ```bash
   pip install molecule molecule-plugins[docker]
   ```

2. **Install required Ansible collections:**
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

3. **Ensure Docker is running:**
   ```bash
   docker --version
   docker ps
   ```

## Configuration Files

- **molecule.yml**: Main Molecule configuration defining the test environment
  - Uses Docker driver with `archlinux:latest` image
  - Runs systemd in the container for service management
  - Configures privileged mode for full system access
  
- **converge.yml**: Playbook that applies the role to test instances
  - Sets `ansible_facts_file` variable for test environment
  - Includes the 01_host_info role
  
- **verify.yml**: Playbook that validates the role executed correctly
  - Checks that ansible_facts.yml file was created
  - Verifies ansible_user_id fact is available
  - Verifies sudo_configured fact was set
  
- **prepare.yml**: Playbook that prepares the test environment
  - Installs Python in the Arch Linux container
  - Gathers facts after setup

- **requirements.yml**: Ansible collections required for testing
  - community.docker (>=3.10.2)
  - ansible.posix (>=1.4.0)

## Running Tests

### Full test cycle
Runs the complete test sequence: create, converge, verify, destroy
```bash
cd roles/01_host_info
molecule test
```

### Individual test phases

1. **Create test instance:**
   ```bash
   molecule create
   ```

2. **Apply the role (converge):**
   ```bash
   molecule converge
   ```

3. **Verify the results:**
   ```bash
   molecule verify
   ```

4. **Login to test instance for debugging:**
   ```bash
   molecule login
   ```

5. **Destroy test instance:**
   ```bash
   molecule destroy
   ```

### Development workflow

For iterative development, use:
```bash
# Create instance once
molecule create

# Make changes and test repeatedly
molecule converge
molecule verify

# Destroy when done
molecule destroy
```

## Test Platform

The tests run on:
- **Image**: `archlinux:latest`
- **Container name**: `arch-test`
- **Privileges**: Full privileged mode with systemd support
- **Environment**: Isolated Docker container

## Troubleshooting

### Collections not found
If you see errors about missing `community.docker` or `ansible.posix` collections:
```bash
ansible-galaxy collection install -r requirements.yml
```

### Docker permission denied
If you get permission errors with Docker:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Container fails to start
If the Arch Linux container fails to start, ensure:
- Docker daemon is running
- You have sufficient permissions
- Image can be pulled: `docker pull archlinux:latest`

### Systemd issues in container
The container is configured to run systemd with:
- Privileged mode enabled
- `/sys/fs/cgroup` mounted
- `cgroupns_mode: host`

If systemd still doesn't work, you can modify `molecule.yml` to use a simpler command like `/bin/bash` or remove systemd entirely.

## Role-Specific Notes

The `01_host_info` role is configured to:
- Skip the Arch Linux distribution check when running under Molecule (using `molecule_yml` variable detection)
- Accept a custom `ansible_facts_file` variable to control where facts are saved
- Handle the absence of become password files gracefully in test environments

## CI Integration

To run molecule tests in CI, add to `.github/workflows/ansible-test.yml`:
```yaml
- name: Install molecule
  run: |
    pip install molecule molecule-plugins[docker]
    
- name: Install molecule collections
  run: |
    ansible-galaxy collection install community.docker ansible.posix
    
- name: Run molecule tests
  run: |
    cd roles/01_host_info
    molecule test
```

## References

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Testing Ansible roles with Molecule](https://www.ansible.com/blog/developing-and-testing-ansible-roles-with-molecule-and-podman-part-1)
- [Docker driver documentation](https://github.com/ansible-community/molecule-plugins)
