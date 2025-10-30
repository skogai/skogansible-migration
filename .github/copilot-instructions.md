# GitHub Copilot Instructions

This file provides guidance to GitHub Copilot when working with code in this repository.

## Quick Reference

**Tech Stack:** Ansible, YAML, Bash, Arch Linux  
**Primary Language:** YAML (Ansible playbooks and roles)  
**Testing:** ansible-lint, yamllint, Molecule  
**CI/CD:** GitHub Actions  
**Documentation:** [README.md](../README.md), [CLAUDE.md](../CLAUDE.md), [MOLECULE.md](../MOLECULE.md)

## Repository Purpose

This is the centralized Ansible configuration directory (`~/.ansible`) that provides global settings and paths for all Ansible operations on this system.

This is a centralized Ansible configuration directory for this system. It houses global configuration files, local playbooks, roles, and variable files used for system management and Arch Linux configuration.

## Key Files and Directories

- **ansible.cfg**: Global Ansible configuration
- **.envrc**: direnv environment setup
- **.env**: Protected environment variables (contains secrets)
- **.hosts**: Inventory file (localhost)
- **run.sh**: Playbook execution script (ALWAYS use this, not `ansible-playbook` directly)
- **test.sh**: Local testing script (run before pushing)
- **requirements.yml**: Ansible collections requirements
- **playbooks/**: Ansible playbooks (main: `all.yml`)
- **roles/**: Ansible roles
  - `01_host_info/`: System info and sudo checks
  - `02_package_managers/`: Package installation (pacman + AUR)
- **vars/**: Variable files
  - `packages.yml`: Package lists (packages, aur_packages)
  - `user.yml`: User configuration

## Configuration Details

### Ansible Configuration (ansible.cfg)

- Collections path: `~/.ansible/.collections`
- Fact caching: `community.general.yaml` backend at `~/.ansible/.cache`
- Inventory: `.hosts` file
- Roles path: `roles/` directory
- Working directories: `/tmp/.ansible`
- Vault password: `~/.ssh/ansible-vault-password`

### Security Notes

- The `.env` file contains sensitive data - never commit secrets

## Important Practices

### Issue and PR Workflow

When assigned to an issue or working on changes:

1. **Understand the requirement** - Read the issue description and comments thoroughly
2. **Review existing code** - Check similar implementations in other roles
3. **Make minimal changes** - Only modify what's necessary to address the issue
4. **Follow patterns** - Use existing conventions and code style
5. **Test thoroughly** - Run `./test.sh` before committing
6. **Document changes** - Update relevant documentation if needed

**Working on PRs:**
- Always create focused, single-purpose changes
- Use descriptive commit messages
- Reference issue numbers in commits
- Respond to review comments promptly
- Keep PRs small and reviewable

### Running Playbooks

**ALWAYS use run.sh for playbook execution:**

```bash
bash run.sh
```

**NEVER run ansible-playbook directly.** The `run.sh` script ensures consistent execution.

### Testing Changes

**ALWAYS test your changes locally before pushing** using the test.sh script:

```bash
./test.sh
```

This runs the same checks as the GitHub Actions CI workflow:
1. **Ansible syntax check** - Validates playbook syntax
2. **ansible-lint** - Checks for best practices and potential issues
3. **yamllint** - Validates YAML formatting

**Optional check mode:**

```bash
./test.sh --check
```

This additionally runs Ansible in check mode (dry-run) to verify changes would work on the target system.

### Testing Tools Installation

```bash
pip install ansible-lint yamllint
```

The `ansible-playbook` command is required (comes with ansible), while `ansible-lint` and `yamllint` are optional but recommended.

## Ansible-Specific Patterns

### Checking Sudo/Privilege Access

If privileged tasks fail, ensure:
1. You are in the correct directory where .envrc can be loaded
2. Your .env or .envrc files are properly sourced
3. You have appropriate sudo access configured on your system

The playbook will attempt to run tasks that require privileges using `become: true`. If this fails, check your environment setup.

### AUR Package Installation

AUR packages require a special setup because `makepkg` refuses to run as root.

**The aur_builder user:**
- Created by the `02_package_managers` role
- Member of `wheel` group
- Has passwordless sudo for `/usr/bin/pacman` only

**Workflow:**
1. `aur_builder` builds the AUR package (without sudo)
2. `yay` internally calls `sudo pacman` to install (using passwordless sudo)
3. No password prompts, no errors

**Example:**

```yaml
- name: Create the `aur_builder` user
  become: true
  ansible.builtin.user:
    name: aur_builder
    create_home: yes
    groups: wheel
    append: yes
- name: Allow the `aur_builder` user to run `sudo pacman` without a password
  become: true
  ansible.builtin.lineinfile:
    path: /etc/sudoers.d/11-install-aur_builder
    line: "aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman"
    create: yes
    mode: 0440
    validate: "visudo -cf %s"

- name: Install AUR packages
  become: true
  become_user: aur_builder
  kewlfft.aur.aur:
    name: "{{ aur_packages }}"
    use: auto
    state: present
```

**Important:** `become` and `become_user` are task-level directives, NOT module parameters. Always place them at the task level, before the module name.

## Best Practices

### Code Style

- Use fully qualified collection names (FQCNs) for all modules: `ansible.builtin.`, `community.general.`, etc.
- Follow existing YAML formatting conventions (see `.yamllint` for rules)
- Follow Ansible best practices (see `.ansible-lint` for rules)

### Common Patterns

- **Force handlers**: Enabled globally (`force_handlers = true`) - handlers run even when tasks fail
- **Diff mode**: Always enabled (`always = yes`) - shows file changes before applying
- **Color output**: Forced on (`force_color = true`) for better readability

### Assumptions to Avoid

- Never assume it's a system/kernel/Ansible bug - always check our configuration first
- Never check external documentation for basic functionality issues - investigate locally first

## Testing Results Interpretation

- ✓ Green checkmarks indicate passed tests
- ✗ Red X marks indicate failed tests
- ⊘ Yellow marks indicate skipped tests (missing tool or configuration)

The test script exits with code 0 on success, non-zero on failure, making it suitable for use in git hooks or CI pipelines.

## Development Environment

### Initial Setup

For first-time contributors or when setting up a development environment:

```bash
# 1. Install Python dependencies
pip install ansible ansible-lint yamllint pre-commit

# 2. Install Ansible collections
ansible-galaxy collection install -r requirements.yml

# 3. Set up pre-commit hooks (optional but recommended)
pre-commit install

# 4. Verify environment
./test.sh
```

### Recommended Tools

- **direnv** - Auto-loads environment variables from `.envrc`
- **pre-commit** - Runs tests automatically before commits
- **molecule** - Role testing in Docker (optional, see MOLECULE.md)
- **ansible-navigator** - Enhanced Ansible CLI (optional)

### IDE Integration

For the best experience with Copilot:
- Use VS Code with the Ansible extension
- Enable YAML syntax validation
- Configure yamllint and ansible-lint integration
- Set up Ansible language server for better completions

## Working with Copilot

### Best Practices for AI Collaboration

1. **Be specific in issues** - Clear requirements help Copilot generate better solutions
2. **Provide context** - Reference existing files, patterns, or examples
3. **Review suggestions** - Always verify Copilot's code against best practices
4. **Iterate on feedback** - Use PR comments to refine Copilot's work
5. **Test thoroughly** - Run `./test.sh` on all Copilot-generated changes

### Common Tasks for Copilot

**Adding a new package:**
- Edit `vars/packages.yml` to add package to appropriate list
- Run `./test.sh` to validate YAML syntax
- Test with `./test.sh --check` to verify installation

**Creating a new role:**
- Follow existing role structure (see `roles/01_host_info/` as template)
- Include `tasks/main.yml` with fully qualified module names
- Add role to appropriate playbook (numbered or named)
- Create Molecule test scenario (optional, see MOLECULE.md)
- Document role purpose and variables in role README

**Modifying existing roles:**
- Preserve existing functionality unless explicitly requested
- Follow existing patterns and conventions
- Update documentation if behavior changes
- Test changes with `./test.sh` and optionally `./test.sh --check`

### Security Considerations

When working with Copilot:
- **Never** commit secrets or passwords to `.env` file
- Use `ansible-vault` for sensitive data
- Review all Copilot suggestions for security implications
- Follow principle of least privilege
- Validate file permissions (especially for sudoers files)
- Test privilege escalation carefully

## Additional Resources

- **[README.md](../README.md)** - Quick start guide and overview
- **[CLAUDE.md](../CLAUDE.md)** - Detailed development guide
- **[MOLECULE.md](../MOLECULE.md)** - Testing guide
- **.ansible-lint** - Linting rules configuration
- **.yamllint** - YAML formatting rules
- **.pre-commit-config.yaml** - Pre-commit hook configuration
