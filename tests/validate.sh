#!/usr/bin/env bash
# Comprehensive validation script for Allure v3 Action

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

check() {
    ((TOTAL_CHECKS++))
    if "$@"; then
        echo -e "${GREEN}✓${NC} $*"
        ((PASSED_CHECKS++))
        return 0
    else
        echo -e "${RED}✗${NC} $*"
        ((FAILED_CHECKS++))
        return 1
    fi
}

section() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
}

echo -e "${BLUE}"
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║                                                           ║"
echo "  ║     Allure v3 Report Action - Validation Suite           ║"
echo "  ║                                                           ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. File Structure
section "1. File Structure Validation"
check test -f "$PROJECT_ROOT/Dockerfile"
check test -f "$PROJECT_ROOT/entrypoint.sh"
check test -x "$PROJECT_ROOT/entrypoint.sh"
check test -f "$PROJECT_ROOT/action.yml"
check test -f "$PROJECT_ROOT/README.md"
check test -f "$PROJECT_ROOT/LICENSE"
check test -f "$PROJECT_ROOT/CHANGELOG.md"
check test -f "$PROJECT_ROOT/CONTRIBUTING.md"
check test -f "$PROJECT_ROOT/PUBLISHING.md"

# 2. Documentation
section "2. Documentation Validation"
check test -f "$PROJECT_ROOT/docs/USAGE.md"
check test -f "$PROJECT_ROOT/docs/EXAMPLES.md"
check grep -q "yuvalgabay" "$PROJECT_ROOT/README.md"
check grep -q "MIT" "$PROJECT_ROOT/LICENSE"
check grep -q "Allure v3" "$PROJECT_ROOT/README.md"

# 3. Workflows
section "3. GitHub Workflows Validation"
check test -f "$PROJECT_ROOT/.github/workflows/test-local.yml"
check test -f "$PROJECT_ROOT/.github/workflows/example-basic.yml"
check test -f "$PROJECT_ROOT/.github/workflows/example-matrix.yml"
check test -f "$PROJECT_ROOT/.github/workflows/release.yml"

# 4. Test Infrastructure
section "4. Test Infrastructure Validation"
check test -d "$PROJECT_ROOT/tests"
check test -f "$PROJECT_ROOT/tests/README.md"
check test -f "$PROJECT_ROOT/tests/fixtures/create-fixtures.sh"
check test -x "$PROJECT_ROOT/tests/fixtures/create-fixtures.sh"
check test -f "$PROJECT_ROOT/tests/unit/test-entrypoint.sh"
check test -x "$PROJECT_ROOT/tests/unit/test-entrypoint.sh"

# 5. Bash Syntax
section "5. Bash Script Validation"
check bash -n "$PROJECT_ROOT/entrypoint.sh"
check bash -n "$PROJECT_ROOT/tests/fixtures/create-fixtures.sh"
check bash -n "$PROJECT_ROOT/tests/unit/test-entrypoint.sh"
check bash -n "$PROJECT_ROOT/tests/validate.sh"

# 6. Action Configuration
section "6. Action Configuration Validation"
check grep -q "name:" "$PROJECT_ROOT/action.yml"
check grep -q "description:" "$PROJECT_ROOT/action.yml"
check grep -q "author: 'Yuval Gabay'" "$PROJECT_ROOT/action.yml"
check grep -q "branding:" "$PROJECT_ROOT/action.yml"
check grep -q "using: 'docker'" "$PROJECT_ROOT/action.yml"
check grep -q "image: 'Dockerfile'" "$PROJECT_ROOT/action.yml"

# 7. Required Inputs
section "7. Action Inputs Validation"
check grep -q "allure_results:" "$PROJECT_ROOT/action.yml"
check grep -q "allure_report:" "$PROJECT_ROOT/action.yml"
check grep -q "allure_history:" "$PROJECT_ROOT/action.yml"
check grep -q "gh_pages:" "$PROJECT_ROOT/action.yml"
check grep -q "keep_reports:" "$PROJECT_ROOT/action.yml"
check grep -q "report_name:" "$PROJECT_ROOT/action.yml"
check grep -q "subfolder:" "$PROJECT_ROOT/action.yml"

# 8. Entrypoint Script Content
section "8. Entrypoint Script Content Validation"
check grep -q "set -e" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "allure generate" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "INPUT_ALLURE_RESULTS" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "INPUT_ALLURE_HISTORY" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "INPUT_KEEP_REPORTS" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "executor.json" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "index.html" "$PROJECT_ROOT/entrypoint.sh"
check grep -q "last-history" "$PROJECT_ROOT/entrypoint.sh"

# 9. Dockerfile
section "9. Dockerfile Validation"
check grep -q "FROM node:" "$PROJECT_ROOT/Dockerfile"
check grep -q "npm install -g allure" "$PROJECT_ROOT/Dockerfile"
check grep -q "COPY entrypoint.sh" "$PROJECT_ROOT/Dockerfile"
check grep -q "ENTRYPOINT.*entrypoint.sh" "$PROJECT_ROOT/Dockerfile"

# 10. Git Repository
section "10. Git Repository Validation"
cd "$PROJECT_ROOT"
check test -d .git
check git rev-parse --verify HEAD
check git log --oneline --all -1

# 11. Run Unit Tests
section "11. Running Unit Tests"
if [ -x "$PROJECT_ROOT/tests/unit/test-entrypoint.sh" ]; then
    if "$PROJECT_ROOT/tests/unit/test-entrypoint.sh"; then
        echo -e "${GREEN}✓${NC} Unit tests passed"
        ((PASSED_CHECKS++))
    else
        echo -e "${RED}✗${NC} Unit tests failed"
        ((FAILED_CHECKS++))
    fi
    ((TOTAL_CHECKS++))
else
    echo -e "${YELLOW}⚠${NC} Unit tests not executable"
fi

# 12. Test Fixtures
section "12. Test Fixture Generation"
TEMP_DIR=$(mktemp -d)
if "$PROJECT_ROOT/tests/fixtures/create-fixtures.sh" "$TEMP_DIR" > /dev/null 2>&1; then
    FIXTURE_COUNT=$(ls -1 "$TEMP_DIR"/*.json 2>/dev/null | wc -l)
    if [ "$FIXTURE_COUNT" -eq 10 ]; then
        echo -e "${GREEN}✓${NC} All 10 test fixtures created"
        ((PASSED_CHECKS++))
    else
        echo -e "${RED}✗${NC} Expected 10 fixtures, got $FIXTURE_COUNT"
        ((FAILED_CHECKS++))
    fi
    ((TOTAL_CHECKS++))
fi
rm -rf "$TEMP_DIR"

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Validation Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Total checks:  $TOTAL_CHECKS"
echo -e "${GREEN}Passed:        $PASSED_CHECKS${NC}"
if [ $FAILED_CHECKS -gt 0 ]; then
    echo -e "${RED}Failed:        $FAILED_CHECKS${NC}"
else
    echo "Failed:        $FAILED_CHECKS"
fi
echo ""

PASS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
echo "Pass rate:     $PASS_RATE%"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ All validation checks passed!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "The Allure v3 Report Action is ready for:"
    echo "  • Local testing (Docker required)"
    echo "  • GitHub Actions integration testing"
    echo "  • Publishing to GitHub Marketplace"
    echo ""
    exit 0
else
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}❌ Some validation checks failed${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Please review the failed checks above and fix the issues."
    echo ""
    exit 1
fi
