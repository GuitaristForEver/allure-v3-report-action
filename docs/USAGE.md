# Usage Guide

## Input Parameters

### Required Inputs

#### `allure_results`

Path to the directory containing Allure test results.

**Default:** `allure-results`

```yaml
with:
  allure_results: build/test-results
```

#### `allure_report`

Path where Allure will write the generated HTML report.

**Default:** `allure-report`

```yaml
with:
  allure_report: build/reports/allure
```

#### `allure_history`

Path for publishing the report history to GitHub Pages.

**Default:** `allure-history`

```yaml
with:
  allure_history: docs/reports
```

#### `gh_pages`

Path to the checked-out gh-pages branch (for history).

**Default:** `gh-pages`

```yaml
with:
  gh_pages: gh-pages
```

### Optional Inputs

#### `report_name`

Custom title for your Allure report.

**Default:** `Allure Report`

```yaml
with:
  report_name: 'E2E Test Results - Production'
```

#### `subfolder`

Use subfolders to host multiple independent reports in the same repository.

**Default:** `''` (empty)

```yaml
# iOS report at: https://user.github.io/repo/ios/
with:
  subfolder: ios

# Android report at: https://user.github.io/repo/android/
with:
  subfolder: android
```

#### `keep_reports`

Number of previous reports to retain for history.

**Default:** `20`

```yaml
with:
  keep_reports: 50  # Keep last 50 reports
```

#### `report_url`

Override the default GitHub Pages URL with a custom domain.

**Default:** `''` (uses github.io URL)

```yaml
with:
  report_url: 'https://reports.example.com'
```

## Complete Example

```yaml
- name: Generate Allure Report
  uses: yuvalgabay/allure-v3-report-action@v1
  if: always()
  with:
    # Paths
    allure_results: test-output/allure-results
    allure_report: allure-report
    allure_history: allure-history
    gh_pages: gh-pages

    # Customization
    report_name: 'Integration Tests - ${{ github.ref_name }}'
    subfolder: integration
    keep_reports: 30

    # GitHub context (usually use defaults)
    github_run_num: ${{ github.run_number }}
    github_run_id: ${{ github.run_id }}
    github_repo: ${{ github.repository }}
```

## History Management

The action automatically manages test history:

1. Fetches previous history from gh-pages branch
2. Merges with current test results
3. Generates report with trends
4. Cleans old reports based on `keep_reports`
5. Saves history for next run

### Setting Up History

First run (no gh-pages branch yet):

```yaml
- name: Get Allure history
  uses: actions/checkout@v4
  continue-on-error: true  # Important! Branch might not exist yet
  with:
    ref: gh-pages
    path: gh-pages
```

The `continue-on-error: true` ensures the workflow continues even if gh-pages doesn't exist.

## GitHub Pages Setup

1. Create the gh-pages branch (automatically created on first deploy)
2. Enable GitHub Pages in repository settings
3. Set source to gh-pages branch

Your reports will be available at:
```
https://<username>.github.io/<repository>/
```

With subfolders:
```
https://<username>.github.io/<repository>/<subfolder>/
```

## Troubleshooting

### Report not showing history

- Ensure gh-pages checkout step has `continue-on-error: true`
- Verify `last-history` directory exists in gh-pages branch
- Check that `keep_reports` is not 0

### Reports overwriting each other

- Use different `subfolder` values for different test suites
- Ensure unique `github_run_num` (defaults should work)

### Large repository size

- Reduce `keep_reports` value
- Use `subfolder` to separate old reports
- Consider periodically cleaning gh-pages branch
