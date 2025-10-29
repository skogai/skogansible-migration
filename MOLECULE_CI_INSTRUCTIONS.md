# Adding Molecule Testing to CI Workflow

## Background

This file contains instructions for manually adding Molecule testing to the GitHub Actions CI workflow. Due to GitHub App permissions, automated tools cannot modify workflow files directly.

## What Was Fixed

The `test.sh` script has been fixed to properly support molecule testing:
- ✅ Removed duplicate molecule test code (was at lines 236-309)
- ✅ Fixed undefined function references (`print_test_header`, `command_exists`, `print_test_result`)
- ✅ Now uses existing functions (`print_step`, `print_success`, `print_error`, `print_warning`)
- ✅ Properly tracks test counters (TESTS_RUN, TESTS_PASSED, TESTS_FAILED, TESTS_SKIPPED)
- ✅ Added molecule tests to summary output

## How to Add Molecule Testing to CI

### Option 1: Add as a Separate Job (Recommended)

Add this job to `.github/workflows/ansible-test.yml` after the existing `ansible-test` job:

```yaml
  molecule-test:
    name: Molecule Role Testing
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
          ansible-galaxy collection install -r requirements.yml
          ansible-galaxy collection install community.docker ansible.posix

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Run molecule tests
        run: |
          # Find all roles with molecule scenarios and test them
          for role_dir in roles/*/molecule/default; do
            if [ -d "$role_dir" ]; then
              role_name=$(basename $(dirname $(dirname "$role_dir")))
              echo "Testing role: $role_name"
              cd "$(dirname $(dirname "$role_dir"))"
              molecule test
              cd -
            fi
          done
```

### Option 2: Add to Existing Job

Alternatively, add these steps to the existing `ansible-test` job in `.github/workflows/ansible-test.yml`:

```yaml
      - name: Install molecule dependencies
        run: |
          pip install molecule molecule-plugins[docker]
          ansible-galaxy collection install community.docker ansible.posix

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Run molecule tests
        run: |
          for role_dir in roles/*/molecule/default; do
            if [ -d "$role_dir" ]; then
              role_name=$(basename $(dirname $(dirname "$role_dir")))
              echo "Testing role: $role_name"
              cd "$(dirname $(dirname "$role_dir"))"
              molecule test
              cd -
            fi
          done
```

### Option 3: Use the test.sh Script

The simplest option - just run the test script with the `--molecule` flag:

```yaml
      - name: Install molecule dependencies
        run: |
          pip install molecule molecule-plugins[docker]
          ansible-galaxy collection install community.docker ansible.posix

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Run all tests including molecule
        run: |
          ./test.sh --molecule
```

## Testing Locally

Before pushing the workflow changes, test locally:

```bash
# Install dependencies
pip install molecule molecule-plugins[docker]
ansible-galaxy collection install community.docker ansible.posix

# Run molecule tests using the test script
./test.sh --molecule

# Or run molecule directly for a specific role
cd roles/01_host_info
molecule test
```

## Current Molecule Coverage

As of this update, the following roles have molecule scenarios configured:

- ✅ `01_host_info` - Basic system information gathering (no sudo required)

## Next Steps

1. Manually add one of the above configurations to `.github/workflows/ansible-test.yml`
2. Commit and push the workflow change
3. Watch the CI run to verify molecule tests work in GitHub Actions
4. Add molecule scenarios to more roles (see `MOLECULE.md` for guidance)

## References

- `MOLECULE.md` - Comprehensive molecule testing documentation
- `test.sh` - Local testing script with `--molecule` flag
- `roles/01_host_info/molecule/default/README.md` - Role-specific testing guide
