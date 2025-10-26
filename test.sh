#!/usr/bin/env bash
#
# test.sh - Local testing script for Ansible configuration
#
# This script runs static analysis tests locally before pushing to GitHub.
# It helps catch issues early in the development cycle.
#
# Usage:
#   ./test.sh           Run all static analysis tests
#   ./test.sh --check   Run tests + optional check mode (requires vault)
#   ./test.sh --help    Show this help message

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Parse arguments
RUN_CHECK_MODE=false
RUN_MOLECULE=false
for arg in "$@"; do
  case $arg in
    --check)
      RUN_CHECK_MODE=true
      shift
      ;;
    --molecule)
      RUN_MOLECULE=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --check      Include Ansible check mode (dry-run)"
      echo "  --molecule   Run molecule tests for roles (requires molecule)"
      echo "  -h, --help   Show this help message"
      echo ""
      echo "This script runs the same tests as CI:"
      echo "  1. Ansible syntax check"
      echo "  2. ansible-lint (if available)"
      echo "  3. yamllint (if available)"
      echo "  4. Ansible check mode (if --check flag is used)"
      echo "  5. Molecule role tests (if --molecule flag is used)"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $arg${NC}"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_step() {
    echo -e "${BLUE}▸${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Local testing script for Ansible configuration validation.

OPTIONS:
    --check     Run Ansible check mode after static tests (requires vault setup)
    --help      Show this help message

TESTS RUN:
    1. Ansible syntax check
    2. YAML linting (yamllint)
    3. Ansible linting (ansible-lint)
    4. Check mode (optional, with --check flag)

REQUIREMENTS:
    - ansible-playbook
    - yamllint
    - ansible-lint
    - Ansible collections (from requirements.yml)

Install missing tools:
    pip install ansible ansible-lint yamllint
    ansible-galaxy collection install -r requirements.yml

EXAMPLES:
    # Run all static tests (recommended before commit)
    ./test.sh

    # Run tests including check mode
    ./test.sh --check

EOF
}

# Parse command line arguments
RUN_CHECK_MODE=false
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
elif [[ "$1" == "--check" ]]; then
    RUN_CHECK_MODE=true
elif [[ -n "$1" ]]; then
    print_error "Unknown option: $1"
    echo "Run '$(basename "$0") --help' for usage information"
    exit 1
fi

# Check for required tools
print_step "Checking for required tools..."
MISSING_TOOLS=()

if ! command -v ansible-playbook &> /dev/null; then
    MISSING_TOOLS+=("ansible-playbook")
fi

if ! command -v yamllint &> /dev/null; then
    MISSING_TOOLS+=("yamllint")
fi

if ! command -v ansible-lint &> /dev/null; then
    MISSING_TOOLS+=("ansible-lint")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    print_error "Missing required tools: ${MISSING_TOOLS[*]}"
    echo "Install with: pip install ansible ansible-lint yamllint"
    exit 1
fi

print_success "All required tools found"
echo ""

# Check if Ansible collections are installed
print_step "Checking for Ansible collections..."
MISSING_COLLECTIONS=()
for collection in "community.general" "kewlfft.aur" "ansible.posix"; do
    if ! ansible-galaxy collection list 2>/dev/null | grep -q "$collection"; then
        MISSING_COLLECTIONS+=("$collection")
    fi
done

if [ ${#MISSING_COLLECTIONS[@]} -gt 0 ]; then
    print_error "Missing required collections: ${MISSING_COLLECTIONS[*]}"
    echo "Install with: ansible-galaxy collection install -r requirements.yml"
    exit 1
fi

print_success "All required collections found"
echo ""

# Test 1: Ansible syntax check
print_step "Running Ansible syntax check..."
if ansible-playbook playbooks/all.yml --syntax-check; then
    print_success "Ansible syntax check passed"
else
    print_error "Ansible syntax check failed"
    exit 1
fi
echo ""

# Test 2: YAML linting
print_step "Running yamllint..."
if yamllint .; then
    print_success "YAML linting passed"
else
    print_error "YAML linting failed"
    exit 1
fi
echo ""

# Test 3: Ansible linting
print_step "Running ansible-lint..."
if ansible-lint playbooks/ roles/; then
    print_success "Ansible linting passed"
else
    print_error "Ansible linting failed"
    exit 1
fi
echo ""

# Test 4: Optional check mode
if [ "$RUN_CHECK_MODE" = true ]; then
    print_step "Running Ansible check mode (dry run)..."
    print_warning "This requires proper environment setup (.env and .envrc sourced)"

    if ansible-playbook \
        playbooks/all.yml \
        --check \
        --diff; then
        print_success "Check mode passed"
    else
        print_error "Check mode failed"
        echo ""
        print_warning "If privilege escalation failed, check:"
        print_warning "  1. Are you in the correct directory?"
        print_warning "  2. Is .envrc or .env properly sourced?"
        print_warning "  3. Do you have sudo access configured?"
        exit 1
    fi
    echo ""
fi

# Test 5: Molecule Tests (optional)
if [ "$RUN_MOLECULE" = true ]; then
  print_test_header "Molecule Role Tests"

  if ! command_exists molecule; then
    echo -e "${YELLOW}molecule is not installed. Install with: pip install molecule molecule-plugins[docker]${NC}"
    print_test_result "Molecule Tests" "SKIP"
  else
    echo -e "${BLUE}Testing roles with Molecule...${NC}"
    MOLECULE_FAILED=0

    # Find all roles with molecule scenarios
    for role_dir in roles/*/molecule/default; do
      if [ -d "$role_dir" ]; then
        role_name=$(basename $(dirname $(dirname "$role_dir")))
        echo ""
        echo -e "${BLUE}Testing role: $role_name${NC}"

        cd "$(dirname $(dirname "$role_dir"))"
        if molecule test --destroy=never 2>&1; then
          echo -e "${GREEN}✓ $role_name molecule tests passed${NC}"
        else
          echo -e "${RED}✗ $role_name molecule tests failed${NC}"
          MOLECULE_FAILED=1
        fi
        cd - > /dev/null
      fi
    done

    if [ $MOLECULE_FAILED -eq 0 ]; then
      print_test_result "Molecule Tests" "PASS"
    else
      print_test_result "Molecule Tests" "FAIL"
      exit 1
    fi
  fi
fi

# Test 5: Molecule Tests (optional)
if [ "$RUN_MOLECULE" = true ]; then
  print_test_header "Molecule Role Tests"

  if ! command_exists molecule; then
    echo -e "${YELLOW}molecule is not installed. Install with: pip install molecule molecule-plugins[docker]${NC}"
    print_test_result "Molecule Tests" "SKIP"
  else
    MOLECULE_FAILED=0

    # Find all roles with molecule scenarios
    for role_dir in roles/*/molecule/default; do
      if [ -d "$role_dir" ]; then
        role_name=$(basename $(dirname $(dirname "$role_dir")))
        echo ""
        echo -e "${BLUE}Testing role: $role_name${NC}"

        cd "$(dirname $(dirname "$role_dir"))"
        if molecule test --destroy=never 2>&1; then
          print_success "$role_name molecule tests passed"
          ((TESTS_PASSED++))
        else
          print_error "$role_name molecule tests failed"
          MOLECULE_FAILED=1
          ((TESTS_FAILED++))
        fi
        ((TESTS_RUN++))
        cd - > /dev/null
      fi
    done

    if [ $MOLECULE_FAILED -eq 0 ]; then
      print_test_result "Molecule Tests" "PASS"
    else
      print_test_result "Molecule Tests" "FAIL"
      exit 1
    fi
  fi
  echo ""
fi

# Print summary
echo ""
print_success "All tests passed!"
echo ""
print_step "Summary:"
echo "  ✓ Ansible syntax check"
echo "  ✓ YAML linting"
echo "  ✓ Ansible linting"
if [ "$RUN_CHECK_MODE" = true ]; then
    echo "  ✓ Check mode (dry run)"
fi
if [ "$RUN_MOLECULE" = true ]; then
    echo "  ✓ Molecule tests"
fi
echo ""
echo "Ready to commit and push!"
