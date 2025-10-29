#!/usr/bin/env bash
#
# Setup script for pre-commit hooks
# This script installs pre-commit and its dependencies, then installs the hooks

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if we're in a git repository
if [ ! -d .git ]; then
    print_error "This script must be run from the root of a git repository"
    exit 1
fi

echo "Setting up pre-commit hooks for skogansible..."
echo

# Check Python installation
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is required but not installed"
    exit 1
fi
print_status "Python 3 found: $(python3 --version)"

# Check pip installation
if ! command -v pip3 &> /dev/null && ! python3 -m pip --version &> /dev/null; then
    print_error "pip is required but not installed"
    exit 1
fi
print_status "pip found"

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    print_warning "pre-commit not found, installing..."
    python3 -m pip install --user pre-commit
    print_status "pre-commit installed"
else
    print_status "pre-commit already installed: $(pre-commit --version)"
fi

# Install pre-commit hooks
print_warning "Installing pre-commit hooks..."
pre-commit install
print_status "Pre-commit hooks installed"

# Install hook environments
print_warning "Installing hook environments (this may take a few minutes)..."
pre-commit install-hooks
print_status "Hook environments installed"

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Pre-commit setup complete!${NC}"
echo
echo "The following hooks are now active:"
echo "  • trailing-whitespace - Remove trailing whitespace"
echo "  • end-of-file-fixer - Ensure files end with newline"
echo "  • check-merge-conflict - Check for merge conflict markers"
echo "  • mixed-line-ending - Normalize line endings to LF"
echo "  • yamllint - YAML file linting"
echo "  • ansible-lint - Ansible best practices"
echo "  • ansible-syntax-check - Ansible playbook syntax validation"
echo
echo "Usage:"
echo "  • Hooks run automatically on 'git commit'"
echo "  • Test now: pre-commit run --all-files"
echo "  • Bypass if needed: git commit --no-verify"
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
