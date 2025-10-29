#!/usr/bin/env bash
#
# setup-precommit.sh
#
# Automated setup script for pre-commit hooks in skogansible repository.
# This script installs pre-commit, configures the hooks, and installs hook environments.
#
# Usage:
#   ./setup-precommit.sh
#
# Requirements:
#   - Python 3.x
#   - pip (Python package manager)
#   - git repository initialized
#
# Exit codes:
#   0 - Success
#   1 - Missing prerequisites or installation failed
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Banner
echo ""
echo "========================================"
echo "  Pre-commit Hooks Setup"
echo "  skogansible repository"
echo "========================================"
echo ""

# Check prerequisites
info "Checking prerequisites..."

if ! check_command python3; then
    error "Python 3 is not installed. Please install Python 3 first."
    exit 1
fi
success "Python 3 found: $(python3 --version)"

if ! check_command pip3 && ! check_command pip; then
    error "pip is not installed. Please install pip first."
    exit 1
fi
success "pip found"

if ! check_command git; then
    error "git is not installed. Please install git first."
    exit 1
fi
success "git found"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not in a git repository. Please run this script from the skogansible repository root."
    exit 1
fi
success "Git repository detected"

# Check if .pre-commit-config.yaml exists
if [ ! -f ".pre-commit-config.yaml" ]; then
    error ".pre-commit-config.yaml not found. This script must be run from the repository root."
    exit 1
fi
success "Found .pre-commit-config.yaml"

echo ""
info "Installing pre-commit..."

# Install pre-commit
if check_command pre-commit; then
    warning "pre-commit is already installed: $(pre-commit --version)"
else
    if pip3 install --user pre-commit; then
        success "pre-commit installed successfully"
    else
        error "Failed to install pre-commit. Please install it manually with: pip install pre-commit"
        exit 1
    fi
fi

echo ""
info "Installing pre-commit hooks into .git/hooks/..."

# Install the git hooks
if pre-commit install; then
    success "Git hooks installed successfully"
else
    error "Failed to install git hooks"
    exit 1
fi

echo ""
info "Installing hook environments (this may take a few minutes on first run)..."
info "This downloads and sets up yamllint, ansible-lint, and other tools..."

# Install hook environments (downloads dependencies)
if pre-commit install-hooks; then
    success "Hook environments installed successfully"
else
    warning "Failed to install hook environments. They will be installed on first commit."
fi

echo ""
success "Pre-commit hooks setup complete!"
echo ""
echo "========================================"
echo "  Setup Summary"
echo "========================================"
echo ""
echo "✓ pre-commit tool installed"
echo "✓ Git hooks installed in .git/hooks/"
echo "✓ Hook environments prepared"
echo ""
echo "The following hooks will run on every commit:"
echo "  1. yamllint          - YAML file linting"
echo "  2. ansible-lint      - Ansible best practices"
echo "  3. ansible-syntax    - Playbook syntax validation"
echo "  4. trailing-whitespace - Auto-fix trailing spaces"
echo "  5. end-of-file-fixer - Auto-fix missing newlines"
echo "  6. check-merge-conflict - Detect merge markers"
echo "  7. mixed-line-ending - Auto-fix line endings (LF)"
echo ""
echo "========================================"
echo "  Usage"
echo "========================================"
echo ""
echo "Hooks run automatically on 'git commit'"
echo ""
echo "Manual runs:"
echo "  pre-commit run              # Run on staged files"
echo "  pre-commit run --all-files  # Run on all files"
echo "  pre-commit run ansible-lint # Run specific hook"
echo ""
echo "Bypass hooks (not recommended):"
echo "  git commit --no-verify"
echo ""
echo "For more information, see PRE-COMMIT.md"
echo ""
