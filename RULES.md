# Ansible Repository Standards

## Task Naming
- All task names MUST use format: `"ROLE | Description"`
- Example: `"Packages | Install system packages"` NOT `"Install system packages"`

## Tag Format
- Use kebab-case for all tags: `packages-install` NOT `packages_install`
- Use bracket format for tags (better visibility for both humans and LLMs)
  ```yaml
  # Good - all tags visible in one line
  tags: [packages, packages-install, packages-aur]

  # Bad - underscore format
  tags: [packages, packages_install]
  ```

## Tag Coverage
- ALL tasks MUST have at least the role-level tag
- Feature-level tags are OPTIONAL (for granular control)
- Tasks without feature tags run whenever the role runs
- Example hierarchy: `packages` (required) + `packages-install` (optional)
- Example:
  ```yaml
  # Runs always with --tags packages (no feature tag)
  tags: [packages]

  # Runs with --tags packages OR --tags packages-install
  tags: [packages, packages-install]
  ```

## Feature Flags
- ALL feature flags MUST be defined in `roles/ROLE/defaults/main.yml`
- Each flag MUST have an explanatory comment above it
- Format: `# Description of what this controls`
- Example:
  ```yaml
  # Upgrade all system packages (CAUTION: may break system)
  packages_upgrade_system: false
  ```

## Conservative Defaults Philosophy
- Dangerous operations MUST be disabled by default
- User MUST explicitly enable risky features
- Safe operations can be enabled by default
- Examples of dangerous: system upgrades, auto-apply configs, destructive operations
- Examples of safe: cache updates, verification checks, read-only operations

## When Conditions
- Tasks controlled by feature flags MUST have `when:` conditions
- Example:
  ```yaml
  - name: "Packages | Upgrade all packages"
    community.general.pacman:
      upgrade: true
    when: packages_upgrade_system | bool
  ```

## Variable Organization

Ansible variable hierarchy (lowest to highest precedence):

1. **`roles/<role>/defaults/main.yml`** - Sane defaults (anyone can use)
   - Empty strings, conservative flags
   - Safe values for any deployment
   - Example: `git_user_name: ""`

2. **`roles/<role>/vars/main.yml`** - Your personal standard configuration
   - Your typical preferences for this role
   - References/pass through to the global value from `./vars/main.yml`
   - Allows for granular configuration changes while still using global settings as default
   - Example: `git_user_name: "{{ user_name }}"`

3. **`./vars/main.yml`** - Shared variables (source of truth)
   - Variables used by MULTIPLE roles
   - Global user info, paths, common settings
   - Example: `user_name: "skogix"`, `editor: "nvim"`

4. **`./vars/<role>.yml`** - Role-specific overrides
   - Deployment-specific overrides for individual roles
   - Example: `user_email: "skogix@skogai.se"` (work machine)

5. **`./vars/<role>_vault.yml`** - Encrypted secrets
   - Sensitive data encrypted with ansible-vault
   - Example: SSH private keys, API tokens

## Documentation Requirements
- Each role MUST have `roles/ROLE/README.md`
- Each flag in defaults/main.yml MUST have explanatory comment
- README MUST document all available feature flags
- README MUST include usage examples

## File Naming
- No strict requirement - use what makes sense (both `aur_user.yml` and `aur-user.yml` acceptable)
- Prefer consistency within a role over global consistency

## Defaults File Structure (defaults/main.yml)
- Use section dividers with clear headers:
  ```yaml
  # ==============================================================================
  # Section Name
  # ==============================================================================
  ```
- Add header comment explaining override locations:
  ```yaml
  # ROLE Role - Default Variables
  # Override these in your playbook, inventory, or vars/ROLE.yml
  ```
- Every variable MUST have explanatory comment above it
- Group related variables together under section headers
- For complex data structures, provide commented examples:
  ```yaml
  # List of repositories to clone
  # git_repositories:
  #   - repo: "https://github.com/user/repo.git"
  #     dest: "/path/to/dest"
  #     version: "main"
  ```

## Declarative State Management
- Declare DESIRED STATE, not step-by-step procedures
- Let Ansible modules handle idempotency (don't check manually)
- Trust module behavior (package/file/user modules check before changing)
- Example:
  ```yaml
  # RIGHT - Declarative
  - name: "Git | Ensure git is installed"
    ansible.builtin.package:
      name: git
      state: present
    tags: [git, git-install]

  # WRONG - Imperative (checking manually)
  # Don't do this - package module already checks!
  ```

## Privilege Escalation
- **ONLY use task-level `become: true`** (never at playbook/play level)
- Granular privilege escalation = better security
- Example:
  ```yaml
  # RIGHT - Task level
  - name: "Packages | Install system packages"
    become: true
    community.general.pacman:
      name: git
      state: present

  # WRONG - Playbook level
  # Never do: become: true at play/playbook level
  ```

## README Structure
- See `roles/_template/README.md` for complete example
- Must include: purpose, requirements, variables, usage examples, tags
