# Security Checklist

Quick reference for security validation and maintenance.

## Pre-Deployment Checklist

Before running any playbook:

- [ ] Vault password file exists: `~/.ssh/ansible-vault-password`
- [ ] Vault password file has 600 permissions
- [ ] Become password file exists: `~/.ssh/ansible-become-password`
- [ ] Become password file has 600 permissions
- [ ] Vault files are encrypted: `file vars/*vault*.yml`
- [ ] No uncommitted changes to sensitive files: `git status`

## Post-Changes Checklist

After making repository changes:

- [ ] Run detect-secrets: `detect-secrets scan --baseline .secrets.baseline`
- [ ] Run pre-commit hooks: `pre-commit run --all-files`
- [ ] Check for password patterns: `grep -r "password\|secret\|key" . --include="*.yml" | grep -v vault | grep -v example`
- [ ] Verify .gitignore patterns: `git status --ignored`
- [ ] Review file permissions: `find . -type f -name "*password*" -o -name "*secret*"`

## Monthly Security Audit

Run monthly or after security incidents:

```bash
# 1. Verify vault encryption
echo "==> Checking vault files..."
file vars/*vault*.yml

# 2. Check password file permissions
echo "==> Checking password file permissions..."
ls -la ~/.ssh/ansible-*-password 2>/dev/null || echo "No password files found"

# 3. Scan for secrets
echo "==> Scanning for secrets..."
if command -v detect-secrets &>/dev/null; then
    detect-secrets scan --baseline .secrets.baseline
else
    echo "detect-secrets not installed"
fi

# 4. Check git history
echo "==> Checking git history for sensitive data..."
git log -p -5 | grep -i "password\|secret\|key" | grep -v "vault" || echo "None found in last 5 commits"

# 5. Verify sudoers
echo "==> Checking sudoers configuration..."
sudo cat /etc/sudoers.d/11-install-aur_builder 2>/dev/null || echo "Not installed"
sudo cat /etc/sudoers.d/12-wheel-to-aur_builder 2>/dev/null || echo "Not installed"

# 6. Check file permissions in repo
echo "==> Checking script permissions..."
find . -type f -name "*.sh" -exec ls -la {} \;

# 7. Verify sensitive files not tracked
echo "==> Checking for untracked sensitive files..."
find . -name ".env" -o -name "*password*" -o -name "*.key" | grep -v ".venv"

echo "==> Security audit complete!"
```

## Quarterly Security Tasks

Every 3 months:

- [ ] Rotate Semaphore admin password
- [ ] Review and update `.secrets.baseline`
- [ ] Audit Semaphore access logs
- [ ] Review sudo logs: `sudo journalctl | grep sudo`
- [ ] Check for failed SSH attempts: `journalctl | grep sshd | grep -i failed`
- [ ] Update security documentation
- [ ] Review and test incident response procedures

## Annual Security Tasks

Once per year:

- [ ] Rotate vault password: `ansible-vault rekey vars/ssh_vault.yml`
- [ ] Consider rotating SSH keys
- [ ] Review all API tokens and credentials
- [ ] Audit all system access logs
- [ ] Update security documentation
- [ ] Review and update `.gitignore`
- [ ] Review and update pre-commit hooks

## Security Issue Response

If a security issue is found:

1. **STOP** - Don't commit or push anything
2. **Assess** - Determine severity and scope
3. **Document** - Note what was found and when
4. **Fix** - Follow incident response procedures in docs/SECURITY.md
5. **Verify** - Run full security audit after fix
6. **Report** - Update security log

## Quick Commands

```bash
# Encrypt a file with vault
ansible-vault encrypt path/to/file

# View encrypted file
ansible-vault view vars/ssh_vault.yml

# Edit encrypted file
ansible-vault edit vars/ssh_vault.yml

# Change vault password
ansible-vault rekey vars/ssh_vault.yml

# Fix password file permissions
chmod 600 ~/.ssh/ansible-vault-password ~/.ssh/ansible-become-password

# Check file is encrypted
head -1 vars/ssh_vault.yml | grep "^\$ANSIBLE_VAULT"

# Run playbook with password prompts
./run.sh --ask-vault-pass --ask-become-pass

# Scan for secrets
detect-secrets scan --all-files

# Update secrets baseline
detect-secrets scan --baseline .secrets.baseline --all-files
```

## Red Flags 🚩

Stop immediately if you see:

- ❌ Plaintext passwords in any file
- ❌ Unencrypted private keys
- ❌ `.env` file in git status
- ❌ Password files with permissions other than 600
- ❌ Vault files that are not encrypted
- ❌ Secrets in git history
- ❌ Credentials in docker-compose.yml
- ❌ API tokens in configuration files

## Contact

Security questions or concerns:

- Email: emil@skogsund.se
- GitHub: @skogix
- For vulnerabilities: Use GitHub Security Advisories

---

**Last Updated:** 2025-12-25
**Format Version:** 1.0
