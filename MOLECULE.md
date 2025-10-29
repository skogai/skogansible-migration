# Molecule Testing Guide

This repository uses [Molecule](https://molecule.readthedocs.io/) for testing Ansible roles in isolated containerized environments.

## Overview

Molecule allows you to:
- Test roles in isolation without affecting your system
- Test against different operating systems and configurations
- Verify that roles work correctly before applying them to production
- Automate role testing in CI/CD pipelines

## Setup

### 1. Install Molecule

```bash
pip install molecule molecule-plugins[docker]
```

### 2. Install Required Collections

Molecule's Docker driver requires the following Ansible collections:

```bash
ansible-galaxy collection install community.docker ansible.posix
```

### 3. Ensure Docker is Running

Molecule uses Docker to create test containers:

```bash
docker --version
docker ps
```

## Available Test Scenarios

Currently configured roles:

### 01_host_info

Tests the basic host information gathering and sudo configuration checking role.

**Location:** `roles/01_host_info/molecule/default/`

**Run tests:**
```bash
cd roles/01_host_info
molecule test
```

## Running Tests

### Quick Test (Full Cycle)

Run the complete test cycle that creates, tests, and destroys the test environment:

```bash
cd roles/<role_name>
molecule test
```

This executes the following sequence:
1. `dependency` - Install required collections (if enabled)
2. `cleanup` - Clean up from previous runs
3. `destroy` - Remove any existing test instances
4. `syntax` - Check playbook syntax
5. `create` - Create test container
6. `prepare` - Set up the test environment
7. `converge` - Apply the role
8. `idempotence` - Verify the role is idempotent
9. `side_effect` - Run any side-effect playbooks
10. `verify` - Validate the results
11. `cleanup` - Clean up
12. `destroy` - Destroy test instances

### Development Workflow

For faster iteration during development:

```bash
cd roles/<role_name>

# Create test instance (once)
molecule create

# Make changes to your role, then test
molecule converge  # Apply changes
molecule verify    # Check results

# Repeat converge/verify as needed

# Clean up when done
molecule destroy
```

### Useful Commands

**List test scenarios:**
```bash
molecule list
```

**Login to test container:**
```bash
molecule login
```

**Check Ansible syntax:**
```bash
molecule syntax
```

**Test idempotence:**
```bash
molecule idempotence
```

**View test logs:**
```bash
molecule --debug test
```

## Test Configuration

Each role's molecule scenario is configured in:
```
roles/<role_name>/molecule/default/
├── molecule.yml        # Main configuration
├── converge.yml        # Playbook to apply the role
├── verify.yml          # Playbook to verify results
├── prepare.yml         # (Optional) Setup playbook
├── requirements.yml    # Required collections
└── README.md          # Scenario documentation
```

### molecule.yml

Key configuration options:

```yaml
driver:
  name: docker            # Use Docker containers

platforms:
  - name: arch-test
    image: archlinux:latest  # Test on Arch Linux
    privileged: true         # Allow systemd and privileged operations
    command: /usr/sbin/init  # Run systemd in container

provisioner:
  name: ansible

verifier:
  name: ansible
```

## Platform-Specific Considerations

### Arch Linux Testing

Most roles in this repository are designed for Arch Linux. The molecule configuration uses:
- **Image:** `archlinux:latest`
- **Privileged mode:** Enabled for package installation and systemd
- **Systemd:** Running in the container for service management

### Privilege Escalation

Roles that require sudo (like `02_package_managers`) are configured to:
- Run containers in privileged mode
- Mock or provide test credentials in the molecule environment
- Skip become password checks during testing

### Vault Secrets

For roles that use vault-encrypted variables:
- Use test fixtures with mock data
- Set environment variables in molecule.yml
- Document any required test secrets in the role's README

## CI Integration

Molecule tests can be integrated into GitHub Actions. Example workflow:

```yaml
name: Molecule Tests

on: [push, pull_request]

jobs:
  molecule:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        role:
          - 01_host_info
          - 02_package_managers
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install molecule molecule-plugins[docker]
          ansible-galaxy collection install community.docker ansible.posix

      - name: Run molecule tests
        run: |
          cd roles/${{ matrix.role }}
          molecule test
```

## Creating New Test Scenarios

### For a New Role

1. **Create molecule directory structure:**
   ```bash
   cd roles/<role_name>
   mkdir -p molecule/default
   ```

2. **Copy configuration from existing role:**
   ```bash
   cp ../01_host_info/molecule/default/*.yml molecule/default/
   ```

3. **Customize for your role:**
   - Update `molecule.yml` if different platform/config needed
   - Modify `converge.yml` to include your role
   - Update `verify.yml` with role-specific assertions
   - Adjust `prepare.yml` if special setup is required

4. **Document your tests:**
   - Create `README.md` in `molecule/default/`
   - Document any special requirements or considerations

### For Multiple Scenarios

To test a role against multiple platforms or configurations:

```bash
cd roles/<role_name>
mkdir -p molecule/centos
mkdir -p molecule/ubuntu
```

Each scenario gets its own subdirectory with separate configuration files.

Run specific scenario:
```bash
molecule test -s centos
```

## Troubleshooting

### "Cannot find collection"

Install the required collections:
```bash
ansible-galaxy collection install -r roles/<role_name>/molecule/default/requirements.yml
```

### "Docker daemon not running"

Start Docker:
```bash
sudo systemctl start docker
```

### "Permission denied" accessing Docker

Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Systemd doesn't work in container

Ensure molecule.yml has:
```yaml
platforms:
  - name: instance
    privileged: true
    command: /usr/sbin/init
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
```

### Tests fail on distribution check

If a role checks for Arch Linux, it should skip the check in Molecule:
```yaml
- name: Check distribution
  # ...
  when: not (molecule_yml is defined)
```

### Network issues during testing

Some CI environments block external network access. Consider:
- Pre-installing collections in CI
- Disabling dependency stage: `dependency: enabled: false`
- Using pre-built container images with dependencies

## Best Practices

1. **Keep tests fast** - Use `--destroy=never` during development, destroy manually when done
2. **Test idempotence** - Ensure roles can run multiple times safely
3. **Verify thoroughly** - Check file contents, service status, not just file existence
4. **Document assumptions** - Note platform requirements, network needs, privileges
5. **Use prepare wisely** - Minimize setup, keep container close to production environment
6. **Handle failures gracefully** - Roles should skip tasks when requirements aren't met
7. **Test edge cases** - Missing files, wrong permissions, different distributions

## Resources

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Molecule Docker Driver](https://github.com/ansible-community/molecule-plugins/tree/main/src/molecule_plugins/docker)
- [Testing Ansible Roles with Molecule](https://www.ansible.com/blog/developing-and-testing-ansible-roles-with-molecule-and-podman-part-1)
- [Molecule Command Reference](https://molecule.readthedocs.io/en/latest/usage.html)

## Getting Help

If you encounter issues:
1. Check the role-specific README in `molecule/default/README.md`
2. Review this guide and the troubleshooting section
3. Consult Molecule documentation
4. Check GitHub issues in the repository
