# Template Role Information

This directory contains template files showing the standard structure and patterns for Ansible roles in this repository.

## Directory Structure

```
_template/
├── README.md              # Role documentation (user-facing)
├── TEMPLATE_INFO.md       # This file (explains template usage)
├── defaults/
│   └── main.yml          # Default variables with conservative values
├── tasks/
│   ├── main.yml          # Main task orchestrator (includes other tasks)
│   ├── configure.yml     # Example: Configuration tasks
│   └── feature-x.yml     # Example: Feature-specific tasks
├── templates/
│   └── toolrc.j2         # Example: Jinja2 template file
├── vars/
│   └── main.yml          # Variables that override defaults (optional)
├── handlers/
│   └── main.yml          # Event handlers (restart/reload services)
└── meta/
    └── main.yml          # Role metadata and dependencies
```

## File Purposes

### README.md
User-facing documentation showing:
- Role purpose and features
- Requirements and dependencies
- All variables with examples
- Usage examples (basic, advanced, custom)
- Available tags
- Troubleshooting

### defaults/main.yml
Default values for all role variables:
- Organized with section headers (`# ===...===`)
- Every variable has explanatory comment
- Conservative defaults (dangerous features disabled)
- Commented examples for complex data structures

### tasks/main.yml
Main task orchestrator:
- Includes other task files conditionally
- All tasks have proper naming (`"ROLE | Description"`)
- All tasks have tags in bracket format: `tags: [role, role-feature]`
- Uses `when:` conditions based on feature flags

### tasks/*.yml
Modular task files:
- One file per feature/operation
- Declarative state management (not imperative checks)
- Trust Ansible module idempotency

### templates/*.j2
Jinja2 template files:
- Use variables from defaults/vars
- Include "Managed by Ansible" warning
- Conditional sections based on feature flags

### vars/main.yml
Optional variable overrides:
- Environment-specific values
- Values that override defaults
- Typically empty or commented examples

### handlers/main.yml
Event handlers triggered by `notify:`:
- Service restarts
- Configuration reloads
- Use `listen:` for named handler groups

### meta/main.yml
Role metadata:
- Author information
- Supported platforms
- Minimum Ansible version
- Role dependencies (if any)

## Using This Template

1. Copy the entire `_template/` directory to `roles/newrole/`
2. Rename all occurrences of `template` to `newrole`
3. Update README.md with actual role description
4. Define variables in defaults/main.yml
5. Implement tasks in tasks/*.yml
6. Create templates as needed
7. Update meta/main.yml with correct metadata

## Standards Applied

This template follows all standards defined in `/home/skogix/.ansible/RULES.md`:
- ✅ Task naming format: `"ROLE | Description"`
- ✅ Tag format: `tags: [role, role-feature]` (bracket, kebab-case)
- ✅ Conservative defaults philosophy
- ✅ Feature flags with when conditions
- ✅ Declarative state management
- ✅ Section headers in defaults
- ✅ Comprehensive documentation
