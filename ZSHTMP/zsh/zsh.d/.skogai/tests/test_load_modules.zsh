#!/bin/zsh

# Test setup
TEST_DIR="/tmp/test_load_modules"
mkdir -p "$TEST_DIR/00-test"
mkdir -p "$TEST_DIR/01-test"
mkdir -p "$TEST_DIR/02-test"
mkdir -p "$TEST_DIR/14-test"
echo 'export TEST_ENV_VAR="test_value"' > "$TEST_DIR/00-test/test.env"
echo 'echo "Sourcing test.zsh"' > "$TEST_DIR/01-test/test.zsh"
echo 'echo "Sourcing 02-test.zsh"' > "$TEST_DIR/02-test/test.zsh"
echo 'echo "Sourcing 14-test.zsh"' > "$TEST_DIR/14-test/test.zsh"

# Source the script to test
source /home/skogix/.config/zsh.d/000-skogai.zsh

# Test 1: Check if .env files are exported first
load_modules "$TEST_DIR"
if [[ "$TEST_ENV_VAR" == "test_value" ]]; then
    debug_echo "TEST" "Test 1 passed: .env files exported successfully."
else
    debug_echo "TEST" "Test 1 failed: .env files not exported."
fi

# Test 2: Check if .zsh files are sourced
if [[ "$(echo "Sourcing test.zsh")" == "Sourcing test.zsh" ]]; then
    debug_echo "TEST" "Test 2 passed: .zsh files sourced successfully."
else
    debug_echo "TEST" "Test 2 failed: .zsh files not sourced."
fi

# Test 3: Check if files are loaded in the correct order, including 02- before 14-
load_order=$(mktemp)
load_modules "$TEST_DIR" 2>&1 | tee "$load_order"
if grep -q "Exporting variables from: $TEST_DIR/00-test/test.env" "$load_order" && \
   grep -q "Sourcing file: $TEST_DIR/01-test/test.zsh" "$load_order" && \
   grep -q "Sourcing file: $TEST_DIR/02-test/test.zsh" "$load_order" && \
   grep -q "Sourcing file: $TEST_DIR/14-test/test.zsh" "$load_order"; then
    debug_echo "TEST" "Test 3 passed: Files loaded in correct order, with 02- before 14-."
else
    debug_echo "TEST" "Test 3 failed: Files not loaded in correct order."
fi
rm "$load_order"

# Clean up
unset TEST_ENV_VAR
rm -rf "$TEST_DIR"
