# Security Assessment Report

**Repository:** SkogAI/skogansible
**Date:** 2025-12-25
**Assessment Type:** General Security Checkup

## Executive Summary

This document contains a comprehensive security assessment of the skogansible repository. The assessment covers credential management, file permissions, privilege escalation, secrets handling, and overall security posture.

**Overall Status:** 🟡 MODERATE - Several security improvements needed

### Critical Findings: 1
### High Priority Findings: 3
### Medium Priority Findings: 4
### Low Priority Findings: 3

---

## Critical Issues (Fix Immediately)

### 🔴 CRITICAL-1: Hardcoded Admin Password in Semaphore Docker Compose

**Location:** `semaphore/docker-compose.yml:9`

**Issue:**
```yaml
SEMAPHORE_ADMIN_PASSWORD: skogsund1
```

Admin password is hardcoded in plaintext in the Docker Compose file and committed to the repository.

**Risk:**
- Anyone with repository access has the admin password
- Password is in git history permanently
- Compromises the Semaphore UI security completely
- Exposed via public/Cloudflare tunnel at https://semaphore.skogai.se

**Recommendation:**
1. **Immediate:** Change the password via Semaphore UI
2. Use environment variables from `.env` file (add to .gitignore)
3. Use secrets management (skogcli or ansible-vault)
4. Update the docker-compose.yml to reference environment variables:
   ```yaml
   SEMAPHORE_ADMIN_PASSWORD: ${SEMAPHORE_ADMIN_PASSWORD}
   ```
5. Consider using Docker secrets for sensitive data

**Example Fix:**
```yaml
# docker-compose.yml
services:
  semaphore:
    environment:
      SEMAPHORE_ADMIN_PASSWORD: ${SEMAPHORE_ADMIN_PASSWORD:-changeme}
    env_file:
      - .env  # Not committed to git
```

---

## High Priority Issues

### 🟠 HIGH-1: Password Files Referenced in Scripts

**Location:** `run.sh:20-21`, `.envrc:2-3`

**Issue:**
```bash
# run.sh
--vault-password-file ~/.ssh/ansible-vault-password
--become-password-file ~/.ssh/ansible-become-password

# .envrc
export ANSIBLE_BECOME_PASSWORD_FILE=/home/skogix/.ssh/ansible-become-password
export ANSIBLE_VAULT_PASSWORD_FILE=/home/skogix/.ssh/ansible-vault-password
```

Hardcoded paths to password files in the user's home directory.

**Risk:**
- Assumes password files exist in specific locations
- No validation that files exist before use
- Fails if user has different home directory structure
- Exposes the location where sensitive files are stored

**Recommendation:**
1. Use environment variables with fallback defaults
2. Add validation to check if files exist before ansible-playbook execution
3. Document the expected location and setup in README
4. Consider using `ansible-vault` with `--ask-vault-pass` as fallback

**Example Fix:**
```bash
# run.sh
VAULT_PASSWORD_FILE="${ANSIBLE_VAULT_PASSWORD_FILE:-$HOME/.ssh/ansible-vault-password}"
BECOME_PASSWORD_FILE="${ANSIBLE_BECOME_PASSWORD_FILE:-$HOME/.ssh/ansible-become-password}"

# Validate files exist
if [ ! -f "$VAULT_PASSWORD_FILE" ]; then
  echo "Warning: Vault password file not found at $VAULT_PASSWORD_FILE"
  VAULT_PASS_ARG="--ask-vault-pass"
else
  VAULT_PASS_ARG="--vault-password-file $VAULT_PASSWORD_FILE"
fi

# Similar for become password...
```

### 🟠 HIGH-2: Overly Permissive AUR Builder Sudo Access

**Location:** `roles/packages/tasks/aur_user.yml:27`

**Issue:**
```yaml
line: '%wheel ALL=(aur_builder) NOPASSWD: ALL'
```

The wheel group can become aur_builder without password and execute ALL commands.

**Risk:**
- While limited to aur_builder user, this gives broad access
- Should be restricted to only necessary commands for AUR building
- Potential for privilege escalation if aur_builder is compromised

**Current Security Model:**
- ✅ Good: aur_builder can only run `/usr/bin/pacman` with sudo
- ⚠️ Concern: wheel → aur_builder allows ALL commands

**Recommendation:**
While the current setup follows AUR helper best practices, consider:
1. Document why wheel→aur_builder needs ALL commands (for makepkg, git clone, etc.)
2. Investigate if this can be restricted to specific commands
3. Ensure aur_builder home directory has proper permissions (700)
4. Consider adding explicit restrictions for sensitive operations

**Note:** This is how most AUR helper setups work, but should be documented for security awareness.

### 🟠 HIGH-3: SSH Vault Encryption Verification

**Location:** `vars/ssh_vault.yml`

**Issue:**
The SSH vault file is verified as encrypted (✅ Good), but there's no automated verification in CI/CD.

**Current Status:**
```bash
$ file vars/ssh_vault.yml
vars/ssh_vault.yml: Ansible Vault, version 1.1, encryption AES256
```

**Risk:**
- Could accidentally commit decrypted vault file
- No pre-commit hook specifically validates vault encryption
- detect-secrets may not catch decrypted vault variables

**Recommendation:**
1. Add a pre-commit hook to verify vault files are encrypted:
   ```yaml
   - repo: local
     hooks:
       - id: check-vault-encryption
         name: Ensure vault files are encrypted
         entry: bash -c 'for file in vars/*vault*.yml; do [ ! -f "$file" ] || head -1 "$file" | grep -q "^\$ANSIBLE_VAULT" || exit 1; done'
         language: system
         pass_filenames: false
   ```
2. Add to CI/CD pipeline
3. Document vault file naming convention (*vault*.yml)

---

## Medium Priority Issues

### 🟡 MEDIUM-1: Bootstrap Script Uses Sudo Without Validation

**Location:** `bootstrap.sh:23`

**Issue:**
```bash
sudo pacman -S python-uv uv ansible ansible-core --noconfirm
```

Script uses sudo without checking if packages are already installed or validating user permissions.

**Risk:**
- Could fail if user doesn't have sudo access
- No error handling for failed package installation
- Uses `--noconfirm` which auto-accepts all prompts (minor risk)

**Recommendation:**
1. Add check for sudo access:
   ```bash
   if ! sudo -v; then
       echo "Error: sudo access required for bootstrap"
       exit 1
   fi
   ```
2. Check if packages already installed before installing
3. Add error handling and rollback on failure
4. Consider making sudo operations optional with flag

### 🟡 MEDIUM-2: Hardcoded Python Interpreter Path

**Location:** `ansible.cfg:4`

**Issue:**
```ini
interpreter_python = /bin/python
```

Hardcoded system Python path that may not exist on all systems.

**Risk:**
- Fails if Python is installed elsewhere (/usr/bin/python3, etc.)
- Ignores the virtual environment setup by bootstrap.sh
- May use wrong Python version

**Recommendation:**
1. Use `auto` to let Ansible discover Python:
   ```ini
   interpreter_python = auto
   ```
2. Or use the venv Python explicitly:
   ```ini
   interpreter_python = {{ ansible_playbook_python }}
   ```
3. Document Python version requirements

### 🟡 MEDIUM-3: SSH Key Deployment Uses no_log Inconsistently

**Location:** `roles/ssh/tasks/main.yml:43,62,81`

**Issue:**
Private key deployment uses `no_log: true` but public key deployment doesn't.

**Current:**
```yaml
- name: "SSH | Deploy ED25519 private key"
  no_log: true  # ✅ Good

- name: "SSH | Deploy ED25519 public key"
  # ❌ Missing no_log
```

**Risk:**
- Public keys may be logged in Ansible output
- While less sensitive than private keys, public keys can reveal identity
- Inconsistent security practices

**Recommendation:**
Add `no_log: true` to all key deployment tasks for consistency, or document why public keys are logged.

### 🟡 MEDIUM-4: File Permissions Not Set for Password Files

**Location:** `run.sh`, `.envrc`

**Issue:**
The scripts reference password files but don't verify or set proper permissions (should be 600).

**Risk:**
- Password files could have overly permissive permissions
- Other users on the system could read passwords
- No validation that files are secure

**Recommendation:**
Add permission check in run.sh:
```bash
check_password_file_permissions() {
    local file="$1"
    if [ -f "$file" ]; then
        local perms=$(stat -c "%a" "$file")
        if [ "$perms" != "600" ]; then
            echo "Warning: $file has permissions $perms (should be 600)"
            chmod 600 "$file"
        fi
    fi
}
```

---

## Low Priority Issues

### 🟢 LOW-1: Git Credential Store Warning Missing in Vars

**Location:** `roles/git/tasks/configure_credentials.yml:13`

**Issue:**
The task properly warns about plaintext password storage, but this warning doesn't propagate to the user-facing configuration file.

**Risk:**
- Users may not understand the security implications of credential.helper=store
- Plaintext passwords in ~/.git-credentials

**Recommendation:**
Add comment in `vars/git.yml`:
```yaml
# WARNING: store mode saves passwords in PLAINTEXT at ~/.git-credentials
# Consider using 'cache' mode (temporary, 2h timeout) instead
git_credential_helper: "cache --timeout=7200"
```

### 🟢 LOW-2: Empty SSH Key Passphrase Default

**Location:** `roles/ssh/defaults/main.yml:116`

**Issue:**
```yaml
ssh_key_passphrase: ""
```

Default is empty passphrase for generated SSH keys.

**Risk:**
- Keys generated without passphrase protection
- Less secure if private key is compromised
- Should be explicit user choice

**Recommendation:**
1. Add documentation about passphrase importance
2. Consider prompting user during key generation
3. Add comment explaining security tradeoff:
   ```yaml
   # Empty passphrase = convenience but less secure if key is stolen
   # Add passphrase for additional security layer
   ssh_key_passphrase: ""
   ```

### 🟢 LOW-3: Sensitive File Exclusions in .gitignore

**Location:** `.gitignore:1-3`

**Issue:**
The .gitignore only has basic exclusions and doesn't explicitly list sensitive files.

**Current:**
```
backup/todo
/tmp/*
roles/ssh/files/test_examples/
```

**Recommendation:**
Add explicit exclusions for sensitive files:
```gitignore
# Sensitive files
*.key
*.pem
*.p12
*.pfx
.env
.env.local
*.secret
*_vault.yml.decrypted

# Password files
*password*
*secret*
!roles/ssh/vars/example_vault.yml
!*README*

# Semaphore
semaphore/.env
semaphore/data/
```

---

## Security Best Practices (Currently Implemented) ✅

### Excellent Practices Already in Place:

1. **✅ Ansible Vault Encryption**
   - SSH keys properly stored in encrypted vault file
   - AES256 encryption verified
   - Vault password stored separately from repository

2. **✅ Proper File Permissions**
   - SSH directory: 0700
   - Private keys: 0600
   - Public keys: 0644
   - SSH config: 0600

3. **✅ Dedicated AUR Builder User**
   - Follows AUR security best practices
   - Isolated from main user account
   - Limited sudo access to pacman only
   - Proper sudoers validation with visudo

4. **✅ Secrets Detection**
   - detect-secrets baseline configured
   - Pre-commit hooks for secret detection
   - Comprehensive plugin list for various secret types
   - Proper exclusions for example files

5. **✅ No Hardcoded Credentials in Tasks**
   - All sensitive variables from vault
   - Proper use of no_log for sensitive operations
   - Variables properly templated

6. **✅ SSH Configuration Security**
   - Connection multiplexing (security + performance)
   - Proper key type defaults (ed25519)
   - Backup functionality with encryption option
   - Known hosts management

7. **✅ Minimal Privilege Principle**
   - Tasks use `become: true` only when needed (not playbook-wide)
   - Specific user/group ownership on files
   - Proper validation of sudoers files

---

## Additional Security Recommendations

### 1. Documentation

Create `docs/SECURITY.md` with:
- Password file setup instructions
- Vault management guide
- Secure credential handling practices
- Incident response procedures

### 2. CI/CD Security

Add GitHub Actions security checks:
```yaml
- name: Security Scan
  run: |
    # Verify vault files are encrypted
    # Run detect-secrets
    # Check file permissions in repository
    # Validate sudoers files syntax
```

### 3. Audit Logging

Consider adding audit logging for:
- Sudo operations
- SSH key deployments
- Vault decryptions
- Package installations

### 4. Secrets Rotation

Document and implement:
- Vault password rotation schedule
- SSH key rotation policy  
- Semaphore admin password rotation
- API token rotation (SEMAPHORE_API_TOKEN)

### 5. Access Control

Review and document:
- Who has vault password access
- Repository access controls
- Semaphore UI access
- SSH key distribution

---

## Compliance & Standards

### Alignment with Security Standards:

- ✅ **CIS Ansible Benchmark**: Mostly compliant
- ✅ **NIST Password Guidelines**: Following best practices
- ⚠️ **OWASP Top 10**: Credential storage needs improvement
- ✅ **Principle of Least Privilege**: Generally followed

---

## Action Items Summary

### Immediate (Critical):
1. Remove hardcoded password from semaphore/docker-compose.yml
2. Use environment variables for Semaphore credentials
3. Change Semaphore admin password

### Short-term (High Priority):
1. Add password file validation in run.sh
2. Document AUR builder sudo requirements
3. Add vault encryption pre-commit hook
4. Set proper permissions on password files

### Medium-term (Medium Priority):
1. Improve bootstrap.sh error handling
2. Fix ansible.cfg Python interpreter setting
3. Add no_log to public key deployments (or document why not needed)
4. Add permission checks for password files

### Long-term (Low Priority):
1. Enhance .gitignore for sensitive files
2. Add security documentation
3. Implement secrets rotation policy
4. Add CI/CD security scanning

---

## Testing & Validation

### Security Test Checklist:

- [ ] Run detect-secrets scan: `detect-secrets scan --baseline .secrets.baseline`
- [ ] Verify vault files encrypted: `file vars/*vault*.yml`
- [ ] Check file permissions: `find . -type f -name "*password*" -o -name "*secret*"`
- [ ] Validate sudoers files: `visudo -cf roles/packages/tasks/aur_user.yml`
- [ ] Review git history for secrets: `git log -p | grep -i password`
- [ ] Test ansible-vault operations: `ansible-vault view vars/ssh_vault.yml`
- [ ] Verify no plaintext credentials: `grep -r "password.*=" . --include="*.yml"`

---

## Conclusion

The skogansible repository demonstrates **good security practices overall**, with proper use of Ansible Vault, secure file permissions, and thoughtful privilege separation. However, the **critical issue with the hardcoded Semaphore password** needs immediate attention.

The repository would benefit from:
1. Removing hardcoded credentials from docker-compose.yml
2. Better validation and error handling in scripts
3. Documentation of security practices and expectations
4. Automated security checks in CI/CD

**Risk Level:** 🟡 MODERATE (after fixing critical issue: 🟢 LOW)

---

**Assessed by:** Claude (Anthropic AI)
**Review Date:** 2025-12-25
**Next Review:** Recommended within 30 days after fixes
