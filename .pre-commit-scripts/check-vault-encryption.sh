#!/bin/bash
# Check that all Ansible vault files are encrypted with AES256

for file in vars/*vault*.yml; do
    # Skip if no vault files exist
    [ ! -f "$file" ] && continue

    # Read first line (vault header)
    header=$(head -1 "$file")

    # Check if file is encrypted
    if ! echo "$header" | grep -q "^\$ANSIBLE_VAULT"; then
        echo "ERROR: $file is not encrypted!"
        exit 1
    fi

    # Warn if not using AES256
    if ! echo "$header" | grep -q "AES256"; then
        echo "WARNING: $file may not be using AES256 encryption"
    fi
done

exit 0
