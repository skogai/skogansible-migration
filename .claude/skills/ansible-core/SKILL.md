---
name: ansible-core
description: Use when working with Ansible Core 2.19 for automation, configuration management, playbooks, modules, or infrastructure as code
---

# Ansible Core 2.19 Skill

Comprehensive assistance with Ansible Core development and automation, generated from official Ansible Core 2.19 documentation.

## When to Use This Skill

This skill should be triggered when:
- Writing or debugging Ansible playbooks
- Creating or modifying Ansible modules and plugins
- Setting up Ansible inventories (INI, YAML, dynamic)
- Working with Ansible Vault for secrets management
- Developing Ansible collections
- Configuring automation workflows with ansible-playbook, ansible-pull, or ad-hoc commands
- Troubleshooting Ansible connection, privilege escalation, or module issues
- Converting manual infrastructure tasks into Ansible automation
- Implementing infrastructure as code with Ansible
- Learning Ansible best practices and design patterns

## Quick Reference

### 1. Basic Playbook Structure

A simple playbook with tasks, the fundamental building block of Ansible automation:

```yaml
- name: My first play
  hosts: myhosts
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
       msg: Hello world
```

**What it does:** Defines a play that runs against hosts in the `myhosts` group, pings them to verify connectivity, and prints a debug message.

### 2. Inventory File (INI Format)

Organize your managed hosts into groups with variables:

```ini
[web]
host1
host2 ansible_port=222

[web:vars]
http_port=8080
myvar=23

[web:children]
apache
nginx

[apache]
tomcat1
tomcat2 myvar=34
tomcat3 mysecret="'03#pa33w0rd'"

[nginx]
jenkins1

[all:vars]
has_java = False
```

**What it does:** Defines host groups, assigns variables at group level, creates group hierarchies with `:children`, and sets host-specific overrides.

### 3. Using ansible-vault for Secrets

Encrypt sensitive data and use it in playbooks:

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Use in playbook with password prompt
ansible-playbook site.yml --ask-vault-pass

# Use with password file
ansible-playbook site.yml --vault-password-file ~/.vault_pass.txt

# Use multiple vault IDs
ansible-playbook site.yml --vault-id dev@dev-password --vault-id prod@prompt
```

**What it does:** Encrypts sensitive variables, allows decryption at runtime with passwords from prompts, files, or scripts. Supports multiple vault IDs for different environments.

### 4. Installing Ansible and Creating a Project

Get started with Ansible quickly:

```bash
# Install ansible
pip install ansible

# Create project structure
mkdir ansible_quickstart && cd ansible_quickstart

# Run a playbook
ansible-playbook playbook.yaml
```

**What it does:** Installs Ansible via pip, creates a project directory for organizing automation content, and executes a playbook.

### 5. Ad-hoc Commands

Execute single tasks without writing a playbook:

```bash
# Run ad-hoc command on specific hosts
ansible -i inventory.ini myhosts -m ansible.builtin.ping

# Install package with privilege escalation
ansible localhost -m ansible.builtin.apt -a "name=apache2 state=present" -b -K

# Check disk space
ansible all -m ansible.builtin.shell -a "df -h"
```

**What it does:** Executes Ansible modules directly from CLI for quick tasks. `-b` enables become (sudo), `-K` prompts for privilege escalation password.

### 6. Module with Variables (include_vars)

Dynamically load variables from external files:

```yaml
- name: Include vars of stuff.yaml into the 'stuff' variable
  ansible.builtin.include_vars:
    file: stuff.yaml
    name: stuff

- name: Load variables based on OS
  ansible.builtin.include_vars: "{{ lookup('ansible.builtin.first_found', params) }}"
  vars:
    params:
      files:
        - '{{ansible_distribution}}.yaml'
        - '{{ansible_os_family}}.yaml'
        - default.yaml
      paths:
        - 'vars'
```

**What it does:** Loads YAML/JSON variables at runtime. Supports conditional loading based on facts, directory scanning, and namespace isolation.

### 7. Plugin Development Basics (Python)

Create a custom filter plugin:

```python
from ansible.module_utils.common.text.converters import to_native

try:
    cause_an_exception()
except Exception as e:
    raise AnsibleError('Something happened, this was original exception: %s' % to_native(e))
```

**What it does:** Shows proper error handling in Ansible plugins using `to_native()` for Python 2/3 string compatibility and `AnsibleError` for user-friendly error messages.

### 8. String Encoding in Modules

Ensure proper Unicode handling in custom modules:

```python
from ansible.module_utils.common.text.converters import to_text

result_string = to_text(result_string)
```

**What it does:** Converts strings to Unicode (Python 3's `str` type) ensuring Jinja2 compatibility and preventing encoding errors.

### 9. Convert Data to YAML (Filter)

Transform Ansible variables into YAML format in templates:

```yaml
# dump variable in a template to create a YAML document
{{ github_workflow | to_nice_yaml }}

# with custom indentation and sorting
{{ my_dict | to_nice_yaml(indent=4, sort_keys=False) }}
```

**What it does:** Uses the `to_nice_yaml` filter to serialize Ansible variables as YAML strings, useful for generating config files or debugging.

### 10. Testing List Relationships

Use Jinja2 test plugins to validate data:

```yaml
big: [1,2,3,4,5]
small: [3,4]
issmallinbig: '{{ small is subset(big) }}'
```

**What it does:** Tests if one list is a subset of another. Useful for conditional logic in playbooks based on list membership.

## Key Concepts

### Playbooks
YAML files defining automation workflows. Contain plays (ordered lists of tasks) that run against inventory groups. Each task invokes a module with specific parameters.

### Inventory
Lists of managed hosts organized into groups. Can be static (INI/YAML files) or dynamic (scripts/plugins). Supports host and group variables, parent-child relationships.

### Modules
Reusable units of code executed on managed nodes. Ansible ships with hundreds of modules (ansible.builtin collection). Use FQCN (Fully Qualified Collection Name) like `ansible.builtin.copy` for clarity.

### Plugins
Extend Ansible's core functionality. Types include filters, tests, callbacks, connections, inventory, lookup, and vars plugins. Execute on the control node (unlike modules).

### Collections
Packaging format for Ansible content (modules, plugins, roles, playbooks). Use `ansible-galaxy collection install` to add community collections.

### Ansible Vault
Encryption system for sensitive data. Encrypts entire files or individual variables. Supports multiple vault passwords with vault IDs for different environments (dev, prod, etc.).

### FQCN (Fully Qualified Collection Name)
Full path to a module/plugin: `namespace.collection.plugin_name`. Example: `ansible.builtin.copy`. Prevents naming conflicts and improves clarity.

### Facts
System information gathered automatically from managed nodes. Access with `ansible_facts` variable. Disable with `gather_facts: no` in playbooks.

### Handlers
Special tasks triggered by `notify` directive. Run once at the end of a play, even if notified multiple times. Common for service restarts.

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **getting_started.md** (9 pages) - Installation, first playbook, basic concepts, quickstart guide
- **installation.md** - Installation methods for various operating systems, pip, package managers
- **inventory.md** (19 pages) - INI/YAML inventory syntax, dynamic inventory, host patterns, variables
- **playbooks.md** (72 pages) - Playbook syntax, plays, tasks, conditionals, loops, roles, imports
- **modules.md** (52 pages) - Module development, parameters, return values, shell plugins
- **collections.md** (319 pages) - Collection structure, ansible.builtin modules/plugins, filters, tests
- **vault.md** (4 pages) - Encrypting files/variables, vault IDs, password management
- **commands.md** (6 pages) - CLI tools: ansible, ansible-playbook, ansible-galaxy, ansible-vault, ansible-console
- **development.md** - Plugin development, module development, Python coding standards
- **porting.md** - Porting guides for upgrading between Ansible versions
- **os_specific.md** - Platform-specific modules and configurations (Windows, BSD, etc.)
- **community.md** (12 pages) - Contributing guidelines, code review, community resources
- **other.md** - Miscellaneous topics not fitting other categories

Use the reference files when you need:
- **Detailed API documentation** for specific modules or plugins
- **Complete parameter lists** with all options and defaults
- **Advanced use cases** and edge case handling
- **Version-specific information** about features and deprecations

## Working with This Skill

### For Beginners

1. **Start with getting_started.md** - Learn Ansible basics, create your first playbook, understand inventory
2. **Review Quick Reference examples** - Copy and adapt the patterns above
3. **Read inventory.md** - Understand how to organize and manage your hosts
4. **Explore commands.md** - Master the CLI tools for running playbooks and ad-hoc tasks

**First steps:**
- Install Ansible: `pip install ansible`
- Create a simple inventory file with your test hosts
- Write a hello-world playbook using the Quick Reference example #1
- Run it: `ansible-playbook -i inventory.ini playbook.yml`

### For Intermediate Users

1. **Deep dive into playbooks.md** - Learn advanced playbook features (conditionals, loops, handlers, roles)
2. **Explore collections.md** - Discover available modules and plugins for your use cases
3. **Master vault.md** - Secure sensitive data in your automation
4. **Study modules.md** - Understand module parameters and return values for precise control

**Focus areas:**
- Organize automation with roles and collections
- Implement proper error handling and idempotency
- Use variables effectively (group_vars, host_vars, facts)
- Leverage filters and tests for data transformation

### For Advanced Users / Plugin Developers

1. **Study development.md** - Learn to write custom modules and plugins
2. **Review community.md** - Understand contribution guidelines and best practices
3. **Check porting.md** - Stay updated on version changes and deprecations
4. **Explore os_specific.md** - Handle platform-specific automation needs

**Advanced topics:**
- Develop custom modules in Python for domain-specific tasks
- Create collection with reusable automation content
- Implement custom inventory plugins for dynamic infrastructure
- Build callback plugins for custom logging and notifications
- Contribute to ansible-core or community collections

### Navigation Tips

- **Looking for a specific module?** Search collections.md (319 pages) - it's indexed
- **Debugging connection issues?** Check commands.md for SSH options and connection troubleshooting
- **Need to encrypt data?** vault.md has all encryption patterns
- **Writing Python code?** development.md covers coding standards and best practices
- **Platform-specific task?** os_specific.md covers Windows, BSD, and other OS peculiarities

## Common Patterns

### Pattern 1: Conditional Task Execution
```yaml
- name: Install package
  ansible.builtin.apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
```

### Pattern 2: Loop Over Items
```yaml
- name: Create multiple users
  ansible.builtin.user:
    name: "{{ item }}"
    state: present
  loop:
    - alice
    - bob
    - charlie
```

### Pattern 3: Handler for Service Restart
```yaml
tasks:
  - name: Update config
    ansible.builtin.copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: restart nginx

handlers:
  - name: restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

### Pattern 4: Register and Use Task Output
```yaml
- name: Check if file exists
  ansible.builtin.stat:
    path: /etc/myapp/config
  register: config_stat

- name: Create config if missing
  ansible.builtin.copy:
    src: default-config
    dest: /etc/myapp/config
  when: not config_stat.stat.exists
```

## Best Practices

1. **Always use FQCN** - `ansible.builtin.copy` instead of `copy` for clarity
2. **Name all tasks and plays** - Makes debugging and logs readable
3. **Use `--check` mode** - Test playbooks without making changes
4. **Implement idempotency** - Ensure playbooks can run multiple times safely
5. **Encrypt secrets with vault** - Never commit plain-text passwords or keys
6. **Use roles for organization** - Group related tasks, vars, and handlers
7. **Document with comments** - Explain complex logic in playbooks
8. **Test with `--diff`** - See what changes before applying them
9. **Use version control** - Track playbook changes in git
10. **Follow YAML syntax strictly** - Use consistent indentation (2 spaces)

## Troubleshooting

**Connection issues:**
```bash
# Test connectivity
ansible all -m ping -i inventory.ini

# Use verbose mode
ansible-playbook playbook.yml -vvv

# Check SSH configuration
ansible all -m shell -a "whoami" --ask-pass
```

**Variable debugging:**
```yaml
- name: Debug variable value
  ansible.builtin.debug:
    var: my_variable
    verbosity: 0
```

**Syntax validation:**
```bash
# Check playbook syntax
ansible-playbook playbook.yml --syntax-check

# Lint with ansible-lint (if installed)
ansible-lint playbook.yml
```

## Resources

### Official Documentation
- Ansible Core Docs: https://docs.ansible.com/ansible-core/2.19/
- Module Index: Browse collections.md reference file
- Getting Started Guide: getting_started.md reference file

### Community
- Ansible Galaxy: https://galaxy.ansible.com/ - Browse and install collections
- GitHub: https://github.com/ansible/ansible - Source code and issues
- Community Forum: https://forum.ansible.com/ - Ask questions and share knowledge

### Learning Resources
- Ansible Examples: https://github.com/ansible/ansible-examples
- Workshops: https://ansible.github.io/workshops/
- Interactive Labs: Multiple providers offer hands-on Ansible training

## Notes

- This skill was automatically generated from official Ansible Core 2.19 documentation
- Reference files preserve structure and examples from source documentation
- Code examples use proper language detection for syntax highlighting
- Quick reference patterns are extracted from real-world usage examples
- All module/plugin names use FQCN format for clarity and future compatibility

## Updating This Skill

To refresh with updated documentation:
```bash
# Re-scrape with same configuration
uv run cli/doc_scraper.py --config configs/ansible-core.json --enhance-local

# Or use cached data for faster rebuild
uv run cli/doc_scraper.py --config configs/ansible-core.json --skip-scrape --enhance-local
```

The skill will be rebuilt with the latest information from the Ansible Core documentation.
