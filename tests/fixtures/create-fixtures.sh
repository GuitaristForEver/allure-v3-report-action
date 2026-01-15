#!/usr/bin/env bash
# Script to create comprehensive Allure test result fixtures

set -e

OUTPUT_DIR="${1:-allure-results}"
mkdir -p "$OUTPUT_DIR"

echo "Creating comprehensive Allure test fixtures..."

# 1. Simple passing test
cat > "$OUTPUT_DIR/test-pass-simple-result.json" << 'EOF'
{
  "uuid": "test-001",
  "name": "Simple passing test",
  "status": "passed",
  "stage": "finished",
  "description": "A basic test that passes",
  "start": 1704067200000,
  "stop": 1704067205000,
  "labels": [
    {"name": "feature", "value": "Core"},
    {"name": "severity", "value": "normal"}
  ]
}
EOF

# 2. Failing test with stack trace
cat > "$OUTPUT_DIR/test-fail-with-trace-result.json" << 'EOF'
{
  "uuid": "test-002",
  "name": "Failing test with detailed trace",
  "status": "failed",
  "stage": "finished",
  "description": "Test that fails with a detailed stack trace",
  "start": 1704067210000,
  "stop": 1704067215000,
  "statusDetails": {
    "message": "AssertionError: Expected 'hello' to equal 'world'",
    "trace": "AssertionError: Expected 'hello' to equal 'world'\n    at Object.<anonymous> (/test/example.test.js:42:15)\n    at Promise.then.completed (/node_modules/jest-circus/build/utils.js:333:28)\n    at new Promise (<anonymous>)\n    at callAsyncCircusFn (/node_modules/jest-circus/build/utils.js:259:10)"
  },
  "labels": [
    {"name": "feature", "value": "Authentication"},
    {"name": "severity", "value": "critical"},
    {"name": "suite", "value": "Login Flow"}
  ]
}
EOF

# 3. Skipped test
cat > "$OUTPUT_DIR/test-skip-result.json" << 'EOF'
{
  "uuid": "test-003",
  "name": "Skipped test - pending implementation",
  "status": "skipped",
  "stage": "finished",
  "description": "Test skipped due to missing feature",
  "start": 1704067220000,
  "stop": 1704067220100,
  "statusDetails": {
    "message": "Feature not implemented yet"
  },
  "labels": [
    {"name": "feature", "value": "Payment"},
    {"name": "severity", "value": "minor"}
  ]
}
EOF

# 4. Test with parameters
cat > "$OUTPUT_DIR/test-parameterized-result.json" << 'EOF'
{
  "uuid": "test-004",
  "name": "Parameterized test [user=admin, role=superuser]",
  "status": "passed",
  "stage": "finished",
  "description": "Test with multiple parameters",
  "start": 1704067230000,
  "stop": 1704067235000,
  "parameters": [
    {"name": "user", "value": "admin"},
    {"name": "role", "value": "superuser"}
  ],
  "labels": [
    {"name": "feature", "value": "Authorization"},
    {"name": "severity", "value": "critical"}
  ]
}
EOF

# 5. Test with attachment reference
cat > "$OUTPUT_DIR/test-with-attachment-result.json" << 'EOF'
{
  "uuid": "test-005",
  "name": "Test with screenshot attachment",
  "status": "failed",
  "stage": "finished",
  "description": "Test that captures screenshot on failure",
  "start": 1704067240000,
  "stop": 1704067250000,
  "statusDetails": {
    "message": "Element not found on page"
  },
  "attachments": [
    {
      "name": "Screenshot on failure",
      "source": "screenshot-001.png",
      "type": "image/png"
    }
  ],
  "labels": [
    {"name": "feature", "value": "UI"},
    {"name": "severity", "value": "normal"}
  ]
}
EOF

# 6. Long-running test
cat > "$OUTPUT_DIR/test-long-running-result.json" << 'EOF'
{
  "uuid": "test-006",
  "name": "Long-running integration test",
  "status": "passed",
  "stage": "finished",
  "description": "Test that takes significant time",
  "start": 1704067260000,
  "stop": 1704067560000,
  "labels": [
    {"name": "feature", "value": "Integration"},
    {"name": "severity", "value": "normal"},
    {"name": "suite", "value": "E2E Tests"}
  ]
}
EOF

# 7. Broken test (invalid status)
cat > "$OUTPUT_DIR/test-broken-result.json" << 'EOF'
{
  "uuid": "test-007",
  "name": "Broken test - setup failed",
  "status": "broken",
  "stage": "finished",
  "description": "Test where setup or teardown failed",
  "start": 1704067570000,
  "stop": 1704067571000,
  "statusDetails": {
    "message": "Database connection failed during setup"
  },
  "labels": [
    {"name": "feature", "value": "Database"},
    {"name": "severity", "value": "blocker"}
  ]
}
EOF

# 8. Test with steps
cat > "$OUTPUT_DIR/test-with-steps-result.json" << 'EOF'
{
  "uuid": "test-008",
  "name": "Test with multiple steps",
  "status": "passed",
  "stage": "finished",
  "description": "Test demonstrating step-by-step execution",
  "start": 1704067580000,
  "stop": 1704067590000,
  "steps": [
    {
      "name": "Navigate to login page",
      "status": "passed",
      "stage": "finished",
      "start": 1704067580000,
      "stop": 1704067582000
    },
    {
      "name": "Enter credentials",
      "status": "passed",
      "stage": "finished",
      "start": 1704067582000,
      "stop": 1704067585000
    },
    {
      "name": "Click login button",
      "status": "passed",
      "stage": "finished",
      "start": 1704067585000,
      "stop": 1704067590000
    }
  ],
  "labels": [
    {"name": "feature", "value": "Authentication"},
    {"name": "severity", "value": "critical"}
  ]
}
EOF

# 9. Flaky test (passed but historically unstable)
cat > "$OUTPUT_DIR/test-flaky-result.json" << 'EOF'
{
  "uuid": "test-009",
  "name": "Potentially flaky test",
  "status": "passed",
  "stage": "finished",
  "description": "Test that sometimes fails intermittently",
  "start": 1704067600000,
  "stop": 1704067605000,
  "labels": [
    {"name": "feature", "value": "Network"},
    {"name": "severity", "value": "normal"},
    {"name": "flaky", "value": "true"}
  ]
}
EOF

# 10. Test with links
cat > "$OUTPUT_DIR/test-with-links-result.json" << 'EOF'
{
  "uuid": "test-010",
  "name": "Test with external links",
  "status": "passed",
  "stage": "finished",
  "description": "Test that references external resources",
  "start": 1704067610000,
  "stop": 1704067615000,
  "links": [
    {
      "name": "Related Issue",
      "url": "https://github.com/example/repo/issues/123",
      "type": "issue"
    },
    {
      "name": "Test Documentation",
      "url": "https://docs.example.com/test-guide",
      "type": "tms"
    }
  ],
  "labels": [
    {"name": "feature", "value": "Documentation"},
    {"name": "severity", "value": "trivial"}
  ]
}
EOF

echo "✅ Created 10 test fixtures in $OUTPUT_DIR"
echo ""
echo "Fixture summary:"
echo "  1. Simple passing test"
echo "  2. Failing test with stack trace"
echo "  3. Skipped test"
echo "  4. Parameterized test"
echo "  5. Test with attachment"
echo "  6. Long-running test"
echo "  7. Broken test"
echo "  8. Test with steps"
echo "  9. Flaky test"
echo " 10. Test with links"
