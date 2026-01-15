# Test Suite for Allure v3 Report Action

## Overview

This directory contains comprehensive tests for the Allure v3 Report Action.

## Test Structure

```
tests/
├── fixtures/          # Sample test data and Allure results
├── integration/       # Integration test workflows
├── unit/             # Unit tests for bash scripts
└── validate.sh       # Comprehensive validation script
```

## Running Tests

### Quick Validation

```bash
./tests/validate.sh
```

### Unit Tests

```bash
cd tests/unit
./test-entrypoint.sh
```

### Integration Tests

Integration tests run automatically in GitHub Actions:
- `.github/workflows/test-local.yml` - Basic functionality
- `tests/integration/test-*.yml` - Specific scenarios

## Test Coverage

### Unit Tests
- ✅ Entrypoint script syntax
- ✅ Variable handling
- ✅ History management logic
- ✅ Report cleanup logic
- ✅ URL generation

### Integration Tests
- ✅ Basic report generation
- ✅ History preservation
- ✅ Subfolder support
- ✅ Multiple reports
- ✅ Custom URLs
- ✅ Report retention

### Fixtures
- ✅ Passing tests
- ✅ Failing tests
- ✅ Skipped tests
- ✅ Tests with attachments
- ✅ Parameterized tests

## Adding New Tests

1. Create fixture data in `fixtures/`
2. Add test workflow in `integration/`
3. Update validation script
4. Document in this README
