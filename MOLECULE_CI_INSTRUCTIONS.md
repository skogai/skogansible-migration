# Adding Molecule Tests to CI Workflow

## Background

This repository has Molecule testing configured for the `01_host_info` role, but it's not currently integrated into the CI workflow. This document provides instructions for adding Molecule testing to the GitHub Actions workflow.

## Why Not Automated?

GitHub App permissions prevent automated modifications to `.github/workflows/` files. You'll need to manually add the job definition below to your workflow file.

## Instructions

Add the following job to `.github/workflows/ansible-test.yml` after the existing `ansible-test` job (after line 48):

```yaml
  molecule-test:
    name: Molecule Role Tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install ansible molecule molecule-plugins[docker]

      - name: Install Ansible collections
        run: |
          ansible-galaxy collection install community.docker ansible.posix
        continue-on-error: true

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Run molecule tests for 01_host_info
        run: |
          cd roles/01_host_info
          molecule test
        continue-on-error: false
```

## What This Job Does

1. **Checks out the code** - Gets the repository contents
2. **Sets up Python 3.11** - Required for Ansible and Molecule
3. **Installs dependencies** - Ansible, Molecule, and Docker plugin
4. **Installs collections** - `community.docker` and `ansible.posix` (required by molecule scenarios)
5. **Sets up Docker** - Required for running containers
6. **Runs molecule test** - Tests the `01_host_info` role in an Arch Linux container

## Testing Locally First

Before adding to CI, verify molecule tests work locally:

```bash
# Install dependencies
pip install molecule molecule-plugins[docker]
ansible-galaxy collection install community.docker ansible.posix

# Test using the test.sh script
./test.sh --molecule

# Or test directly
cd roles/01_host_info
molecule test
```

## Adding More Roles

When you add Molecule scenarios to other roles, update the workflow to test them:

```yaml
      - name: Run molecule tests for all roles
        run: |
          for role_dir in roles/*/molecule/default; do
            if [ -d "$role_dir" ]; then
              role_name=$(basename $(dirname $(dirname "$role_dir")))
              echo "Testing role: $role_name"
              cd "$(dirname $(dirname "$role_dir"))"
              molecule test
              cd - > /dev/null
            fi
          done
```

## Why `continue-on-error: false`?

Unlike the syntax check which has `continue-on-error: true`, molecule tests should fail the build if they fail. This ensures role functionality is verified before merging.

## References

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [GitHub Actions - Docker Setup](https://github.com/docker/setup-buildx-action)
- Repository-specific docs: `MOLECULE.md`
