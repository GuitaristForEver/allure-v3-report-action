#!/usr/bin/env bash
# Unit tests for entrypoint.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENTRYPOINT="$PROJECT_ROOT/entrypoint.sh"

PASS=0
FAIL=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test helper functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    if [ "$expected" = "$actual" ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        ((FAIL++))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="$2"

    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  File not found: $file"
        ((FAIL++))
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"

    if echo "$haystack" | grep -q "$needle"; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected to contain: $needle"
        echo "  In: $haystack"
        ((FAIL++))
        return 1
    fi
}

echo "════════════════════════════════════════════════════════════"
echo "Unit Tests for entrypoint.sh"
echo "════════════════════════════════════════════════════════════"
echo ""

# Test 1: Script exists and is executable
echo "Test Suite: File Checks"
echo "────────────────────────────────────────────────────────────"
assert_file_exists "$ENTRYPOINT" "Entrypoint script exists"
if [ -x "$ENTRYPOINT" ]; then
    echo -e "${GREEN}✓${NC} Entrypoint is executable"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Entrypoint is not executable"
    ((FAIL++))
fi
echo ""

# Test 2: Bash syntax validation
echo "Test Suite: Syntax Validation"
echo "────────────────────────────────────────────────────────────"
if bash -n "$ENTRYPOINT" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Bash syntax is valid"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Bash syntax errors detected"
    ((FAIL++))
fi
echo ""

# Test 3: Required commands check
echo "Test Suite: Required Commands"
echo "────────────────────────────────────────────────────────────"
SCRIPT_CONTENT=$(cat "$ENTRYPOINT")

assert_contains "$SCRIPT_CONTENT" "set -e" "Uses 'set -e' for error handling"
assert_contains "$SCRIPT_CONTENT" "allure generate" "Calls 'allure generate' command"
assert_contains "$SCRIPT_CONTENT" "mkdir -p" "Creates directories with 'mkdir -p'"
assert_contains "$SCRIPT_CONTENT" "cp -r" "Copies files recursively"
echo ""

# Test 4: Environment variables usage
echo "Test Suite: Environment Variables"
echo "────────────────────────────────────────────────────────────"
assert_contains "$SCRIPT_CONTENT" "INPUT_ALLURE_RESULTS" "Uses INPUT_ALLURE_RESULTS"
assert_contains "$SCRIPT_CONTENT" "INPUT_ALLURE_REPORT" "Uses INPUT_ALLURE_REPORT"
assert_contains "$SCRIPT_CONTENT" "INPUT_ALLURE_HISTORY" "Uses INPUT_ALLURE_HISTORY"
assert_contains "$SCRIPT_CONTENT" "INPUT_GH_PAGES" "Uses INPUT_GH_PAGES"
assert_contains "$SCRIPT_CONTENT" "INPUT_KEEP_REPORTS" "Uses INPUT_KEEP_REPORTS"
assert_contains "$SCRIPT_CONTENT" "INPUT_SUBFOLDER" "Uses INPUT_SUBFOLDER"
assert_contains "$SCRIPT_CONTENT" "INPUT_REPORT_NAME" "Uses INPUT_REPORT_NAME"
assert_contains "$SCRIPT_CONTENT" "INPUT_REPORT_URL" "Uses INPUT_REPORT_URL"
assert_contains "$SCRIPT_CONTENT" "INPUT_GITHUB_RUN_NUM" "Uses INPUT_GITHUB_RUN_NUM"
assert_contains "$SCRIPT_CONTENT" "INPUT_GITHUB_RUN_ID" "Uses INPUT_GITHUB_RUN_ID"
assert_contains "$SCRIPT_CONTENT" "INPUT_GITHUB_REPO" "Uses INPUT_GITHUB_REPO"
assert_contains "$SCRIPT_CONTENT" "INPUT_GITHUB_SERVER_URL" "Uses INPUT_GITHUB_SERVER_URL"
echo ""

# Test 5: Core logic checks
echo "Test Suite: Core Logic"
echo "────────────────────────────────────────────────────────────"
assert_contains "$SCRIPT_CONTENT" "executor.json" "Creates executor.json"
assert_contains "$SCRIPT_CONTENT" "index.html" "Creates index.html redirect"
assert_contains "$SCRIPT_CONTENT" "last-history" "Manages last-history"
assert_contains "$SCRIPT_CONTENT" "GITHUB_PAGES_WEBSITE_URL" "Builds GitHub Pages URL"
echo ""

# Test 6: Conditional logic
echo "Test Suite: Conditional Logic"
echo "────────────────────────────────────────────────────────────"
assert_contains "$SCRIPT_CONTENT" "if.*SUBFOLDER" "Checks for subfolder input"
assert_contains "$SCRIPT_CONTENT" "if.*REPORT_URL" "Checks for custom URL"
assert_contains "$SCRIPT_CONTENT" "if.*COUNT.*KEEP_REPORTS" "Implements report cleanup"
echo ""

# Test 7: Output messages
echo "Test Suite: User-Facing Messages"
echo "────────────────────────────────────────────────────────────"
assert_contains "$SCRIPT_CONTENT" "Allure v3 Report Action" "Has welcome message"
assert_contains "$SCRIPT_CONTENT" "Copying existing history" "Has history copy message"
assert_contains "$SCRIPT_CONTENT" "Generating Allure v3 report" "Has report generation message"
assert_contains "$SCRIPT_CONTENT" "Report generated successfully" "Has success message"
echo ""

# Test 8: Error handling
echo "Test Suite: Error Handling"
echo "────────────────────────────────────────────────────────────"
# Check that script uses set -e
if head -5 "$ENTRYPOINT" | grep -q "set -e"; then
    echo -e "${GREEN}✓${NC} Uses 'set -e' at start of script"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Missing 'set -e' at start of script"
    ((FAIL++))
fi

# Check for || echo patterns (error recovery)
if grep -q "2>/dev/null || echo" "$ENTRYPOINT"; then
    echo -e "${GREEN}✓${NC} Has error recovery patterns"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} No explicit error recovery patterns (may be intentional)"
fi
echo ""

# Summary
echo "════════════════════════════════════════════════════════════"
echo "Test Results"
echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${RED}Failed:${NC} $FAIL"
TOTAL=$((PASS + FAIL))
echo "Total:  $TOTAL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
