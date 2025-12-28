# Ansible Role: Git

Comprehensive Git configuration and repository management role for Ansible.

This role provides standardized, reusable functions for all common git operations including:

- Git installation and verification
- Global gitconfig management
- Git aliases configuration
- Credential helper setup
- Repository cloning and management
- Global .gitignore patterns
- Git hooks deployment
- GPG/SSH commit signing
- Git LFS support
- Repository-specific configurations
- Git maintenance tasks

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/git.yml`.

### Installation

```yaml
git_install: true                    # Install git if not present
git_package_name: "git"              # Git package name
```

### Global Configuration

```yaml
git_deploy_config: false             # Deploy .gitconfig from template
git_config_template: "gitconfig.j2"  # Template to use
git_user_name: ""                    # Git user name
git_user_email: ""                   # Git user email
git_editor: "vim"                    # Default editor
git_default_branch: "main"           # Default branch name
```

### Git Aliases

```yaml
git_deploy_aliases: false            # Enable alias deployment
git_aliases:                         # Customize as needed
  st: "status"
  co: "checkout"
  br: "branch"
  ci: "commit"
  lg: "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### Credential Management

```yaml
git_configure_credentials: false     # Enable credential helper
git_credential_helper: "cache"       # cache, store, osxkeychain, etc.
git_credential_cache_timeout: 3600   # Cache timeout in seconds
```

### Repository Management

```yaml
git_clone_repos: false               # Enable repository cloning
git_repositories:                    # List of repos to clone
  - repo: "https://github.com/user/repo.git"
    dest: "{{ ansible_facts['env']['HOME'] }}/projects/repo"
    version: "main"
    update: true
    depth: 0
```

### Global .gitignore

```yaml
git_deploy_global_gitignore: false   # Deploy global gitignore
git_global_gitignore_patterns:       # Patterns to ignore
  - ".DS_Store"
  - "*.swp"
  - ".vscode/"
  - "node_modules/"
```

### Git Hooks

```yaml
git_deploy_hooks: false              # Deploy git hooks
git_hooks:
  - name: "pre-commit"
    template: "pre-commit.j2"
    mode: "0755"
```

### Commit/Tag Signing

```yaml
# GPG Signing
git_gpg_sign_commits: false
git_gpg_sign_tags: false
git_gpg_key_id: ""

# SSH Signing (Git 2.34+)
git_ssh_sign_commits: false
git_ssh_sign_tags: false
git_ssh_signing_key: ""
```

### Git LFS

```yaml
git_lfs_install: false               # Install Git LFS
git_lfs_user_install: false          # Run 'git lfs install'
```

### Advanced Configuration

See `defaults/main.yml` for complete list of configuration options including:

- Core settings (autocrlf, filemode, ignorecase)
- Push/pull/merge settings
- Diff/rebase settings
- Rerere configuration
- Pack optimization
- Submodule settings
- And more...

## Example Playbooks

### Basic Setup

Install git and configure user information:

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_install: true
        git_user_name: "John Doe"
        git_user_email: "john@example.com"
```

### Complete Configuration

Full git setup with aliases, gitignore, and credential helper:

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_install: true
        git_user_name: "John Doe"
        git_user_email: "john@example.com"
        git_default_branch: "main"
        git_editor: "vim"

        # Deploy full config from template
        git_deploy_config: true

        # Enable aliases
        git_deploy_aliases: true

        # Configure credentials
        git_configure_credentials: true
        git_credential_helper: "cache"
        git_credential_cache_timeout: 7200

        # Deploy global gitignore
        git_deploy_global_gitignore: true
```

### Clone Multiple Repositories

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_clone_repos: true
        git_repositories:
          - repo: "https://github.com/ansible/ansible.git"
            dest: "{{ ansible_facts['env']['HOME'] }}/projects/ansible"
            version: "devel"
            update: true

          - repo: "git@github.com:user/private-repo.git"
            dest: "{{ ansible_facts['env']['HOME'] }}/projects/private"
            version: "main"
            key_file: "{{ ansible_facts['env']['HOME'] }}/.ssh/id_ed25519"
            accept_hostkey: true
```

### Git LFS Setup

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_lfs_install: true
        git_lfs_user_install: true
```

### Deploy Git Hooks

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_deploy_hooks: true
        git_hooks:
          - name: "pre-commit"
            template: "pre-commit.j2"
            mode: "0755"
          - name: "commit-msg"
            template: "commit-msg.j2"
            mode: "0755"
```

### Repository-Specific Configuration

Configure different git settings for work repositories:

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_deploy_repo_configs: true
        git_repo_configs:
          - path: "{{ ansible_facts['env']['HOME'] }}/work/project"
            config:
              user.email: "john@company.com"
              user.name: "John Doe (Work)"
              core.sshCommand: "ssh -i ~/.ssh/work_key"
```

### GPG Commit Signing

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_gpg_sign_commits: true
        git_gpg_sign_tags: true
        git_gpg_key_id: "ABCD1234"
```

### SSH Commit Signing (Git 2.34+)

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_ssh_sign_commits: true
        git_ssh_signing_key: "{{ ansible_facts['env']['HOME'] }}/.ssh/id_ed25519.pub"
```

### Git Maintenance

```yaml
- hosts: localhost
  roles:
    - role: git
      vars:
        git_run_maintenance: true
        git_maintenance_repos:
          - "{{ ansible_facts['env']['HOME'] }}/projects/repo1"
          - "{{ ansible_facts['env']['HOME'] }}/projects/repo2"
        git_maintenance_schedule: "daily"
```

## Tags

The role provides granular tags for running specific tasks:

- `git` - All git tasks
- `git-install` - Git installation
- `git-config` - Global configuration
- `git-aliases` - Alias configuration
- `git-credentials` - Credential helper
- `git-gitignore` - Global gitignore
- `git-lfs` - Git LFS setup
- `git-clone` - Repository cloning
- `git-hooks` - Git hooks
- `git-signing` - Commit/tag signing
- `git-repo-config` - Repo-specific config
- `git-maintenance` - Maintenance tasks

### Example Tag Usage

```bash
# Run only git installation
ansible-playbook playbook.yml --tags git-install

# Configure git without installing
ansible-playbook playbook.yml --tags git-config,git-aliases

# Clone repositories only
ansible-playbook playbook.yml --tags git-clone
```

## Templates

### gitconfig.j2

Comprehensive .gitconfig template with all standard settings. Customize by modifying role variables.

### gitignore_global.j2

Global .gitignore template. Add patterns via `git_global_gitignore_patterns` variable.

### hooks/pre-commit.j2

Example pre-commit hook with:

- Trailing whitespace check
- Protected branch prevention
- Debug statement detection
- Linter integration (commented examples)

### hooks/commit-msg.j2

Example commit-msg hook with:

- Conventional Commits format validation
- Minimum message length check
- Optional issue reference validation

## File Structure

```
roles/git/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   ├── main.yml              # Main task orchestrator
│   ├── install.yml           # Git installation
│   ├── configure_global.yml  # Global git config
│   ├── configure_aliases.yml # Git aliases
│   ├── configure_credentials.yml # Credential helper
│   ├── install_lfs.yml       # Git LFS
│   ├── clone_repositories.yml # Repository cloning
│   ├── deploy_gitignore.yml  # Global gitignore
│   ├── deploy_hooks.yml      # Git hooks
│   ├── configure_signing.yml # GPG/SSH signing
│   ├── configure_repo_specific.yml # Repo configs
│   └── maintenance.yml       # Git maintenance
├── templates/
│   ├── gitconfig.j2          # .gitconfig template
│   ├── gitignore_global.j2   # Global gitignore
│   └── hooks/
│       ├── pre-commit.j2     # Pre-commit hook
│       └── commit-msg.j2     # Commit message hook
├── handlers/
│   └── main.yml              # Event handlers
├── meta/
│   └── main.yml              # Role metadata
└── README.md                 # This file
```

## Reusable Task Files

Each task file in `tasks/` is designed to be modular and reusable:

| Task File | Purpose | When Used |
|-----------|---------|-----------|
| `install.yml` | Install git package | `git_install: true` |
| `configure_global.yml` | Set global git config | User credentials set or template enabled |
| `configure_aliases.yml` | Configure git aliases | `git_deploy_aliases: true` |
| `configure_credentials.yml` | Setup credential helper | `git_configure_credentials: true` |
| `install_lfs.yml` | Install Git LFS | `git_lfs_install: true` |
| `clone_repositories.yml` | Clone git repos | `git_clone_repos: true` |
| `deploy_gitignore.yml` | Deploy global gitignore | `git_deploy_global_gitignore: true` |
| `deploy_hooks.yml` | Deploy git hooks | `git_deploy_hooks: true` |
| `configure_signing.yml` | Setup commit signing | Signing variables enabled |
| `configure_repo_specific.yml` | Repo-specific settings | `git_deploy_repo_configs: true` |
| `maintenance.yml` | Run git maintenance | `git_run_maintenance: true` |

## Security Considerations

### Credential Storage

The role supports multiple credential helpers:

- **cache** (recommended): Stores credentials in memory for a limited time
- **store**: Stores credentials in plain text (use with caution)
- **osxkeychain**: macOS keychain integration
- **manager-core**: Git Credential Manager Core

### Commit Signing

Consider enabling commit signing for security:

```yaml
# GPG signing
git_gpg_sign_commits: true
git_gpg_key_id: "YOUR_KEY_ID"

# OR SSH signing (Git 2.34+)
git_ssh_sign_commits: true
git_ssh_signing_key: "~/.ssh/id_ed25519.pub"
```

### Hook Security

Git hooks execute arbitrary code. Review all hook templates before deploying:

- Pre-commit hooks run before commits
- Commit-msg hooks validate commit messages
- Custom hooks should be carefully reviewed

## Customization

### Adding Custom Aliases

```yaml
git_aliases:
  # Standard aliases
  st: "status"
  co: "checkout"

  # Custom workflow aliases
  sync: "!git pull --rebase && git push"
  cleanup: "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d"
  undo: "reset --soft HEAD~1"
```

### Custom Global Gitignore

```yaml
git_global_gitignore_patterns:
  # OS-specific
  - ".DS_Store"
  - "Thumbs.db"

  # Editor-specific
  - ".vscode/"
  - ".idea/"
  - "*.sublime-*"

  # Language-specific
  - "node_modules/"
  - "__pycache__/"
  - "*.pyc"
  - "vendor/"
  - ".env"
```

### Custom Hooks

Create your own hook templates in `templates/hooks/`:

1. Create template file: `templates/hooks/post-checkout.j2`
2. Add to configuration:

```yaml
git_hooks:
  - name: "post-checkout"
    template: "post-checkout.j2"
    mode: "0755"
```

## Troubleshooting

### Git not found after installation

Ensure the package name is correct for your distribution:

```yaml
# Arch Linux
git_package_name: "git"

# Some distributions might use different names
# git_package_name: "git-core"
```

### Credential helper not working

Check git version and available helpers:

```bash
git --version
git credential-cache --help
```

### Hooks not applying to existing repos

Hooks are deployed to `~/.git-templates/hooks/`. To apply to existing repositories:

```bash
cd /path/to/repo
git init  # Re-initialize to copy hooks
```
