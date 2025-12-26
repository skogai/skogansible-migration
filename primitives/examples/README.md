# Primitives Examples

This directory contains example playbooks demonstrating how to use the primitives.

## Available Examples

### basic_usage.yml

Demonstrates individual primitive usage:

- Installing packages
- Querying file existence
- Managing file content
- Copying files
- Executing commands

**Run:**

```bash
ansible-playbook primitives/examples/basic_usage.yml
```

**Run specific examples:**

```bash
# Only package example
ansible-playbook primitives/examples/basic_usage.yml --tags package

# Only content examples
ansible-playbook primitives/examples/basic_usage.yml --tags content
```

### composition_example.yml

Demonstrates how to compose primitives into complex workflows:

- Complete AUR setup using the `compose/aur_setup.yml` composition
- Verification of setup completion

**Run:**

```bash
ansible-playbook primitives/examples/composition_example.yml
```

## Creating Your Own Examples

When creating new examples:

1. **Document the purpose** - Clear header comment
2. **Show realistic usage** - Real-world scenarios
3. **Use tags** - Allow selective execution
4. **Include verification** - Show how to check results
5. **Keep it simple** - One concept per example

## Testing

These examples serve as basic tests for the primitives. Run them to verify primitives work correctly:

```bash
# Run all examples
ansible-playbook primitives/examples/basic_usage.yml
ansible-playbook primitives/examples/composition_example.yml

# Run in check mode (dry-run)
ansible-playbook primitives/examples/basic_usage.yml --check
```

## Further Reading

- **Primitives README:** `../README.md` - Complete primitives documentation
- **Core Concepts:** `../../docs/primitives/ansible-core.md` - Primitives reference
