# Usage Examples

## Basic Configuration

### Minimal Setup

```yaml
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: allure-results
    allure_history: allure-history
```

### With History

```yaml
- name: Get Allure history
  uses: actions/checkout@v4
  continue-on-error: true
  with:
    ref: gh-pages
    path: gh-pages

- name: Generate Report
  uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: allure-results
    allure_history: allure-history
    gh_pages: gh-pages

- name: Deploy to GitHub Pages
  uses: peaceiris/actions-gh-pages@v4
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_branch: gh-pages
    publish_dir: allure-history
```

## Advanced Configurations

### Multiple Test Suites

```yaml
jobs:
  test-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run frontend tests
        run: npm run test:frontend

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: frontend/allure-results
          allure_history: allure-history
          subfolder: frontend
          report_name: Frontend Tests

  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run backend tests
        run: npm run test:backend

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: backend/allure-results
          allure_history: allure-history
          subfolder: backend
          report_name: Backend Tests
```

### Mobile Testing (iOS + Android)

```yaml
jobs:
  test-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run iOS tests
        run: fastlane test

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: ios/test-results
          allure_history: allure-history
          subfolder: ios
          report_name: iOS Tests
          keep_reports: 10

  test-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Android tests
        run: ./gradlew test

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: app/build/allure-results
          allure_history: allure-history
          subfolder: android
          report_name: Android Tests
          keep_reports: 10
```

### Matrix Strategy

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [18, 20, 22]
        browser: [chrome, firefox]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}

      - name: Run tests
        run: npm test
        env:
          BROWSER: ${{ matrix.browser }}

      - uses: actions/checkout@v4
        if: always()
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: allure-results
          allure_history: allure-history
          subfolder: node${{ matrix.node }}-${{ matrix.browser }}
          report_name: Node ${{ matrix.node }} - ${{ matrix.browser }}
```

### Custom Domain

```yaml
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: allure-results
    allure_history: allure-history
    report_url: 'https://reports.mycompany.com'
    report_name: 'Production E2E Tests'
```

### Pull Request Reports

```yaml
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run tests
        run: npm test

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: allure-results
          allure_history: allure-history
          subfolder: pr-${{ github.event.pull_request.number }}
          report_name: 'PR #${{ github.event.pull_request.number }}'

      - name: Comment PR
        if: always()
        uses: actions/github-script@v7
        with:
          script: |
            const reportUrl = `https://${{ github.repository_owner }}.github.io/${{ github.event.repository.name }}/pr-${{ github.event.pull_request.number }}/${{ github.run_number }}`;
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `📊 Allure Report: ${reportUrl}`
            });
```

### Scheduled Regression Tests

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM

jobs:
  regression:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run regression suite
        run: npm run test:regression

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: regression-results
          allure_history: allure-history
          subfolder: regression
          report_name: 'Nightly Regression - ${{ github.run_number }}'
          keep_reports: 30  # Keep 30 days of history
```

### Monorepo with Multiple Projects

```yaml
jobs:
  test-all:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        project:
          - name: api
            path: packages/api
          - name: web
            path: packages/web
          - name: mobile
            path: packages/mobile

    steps:
      - uses: actions/checkout@v4

      - name: Test ${{ matrix.project.name }}
        working-directory: ${{ matrix.project.path }}
        run: npm test

      - uses: actions/checkout@v4
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      - uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: ${{ matrix.project.path }}/allure-results
          allure_history: allure-history
          subfolder: ${{ matrix.project.name }}
          report_name: ${{ matrix.project.name }} Tests
```

## Integration Examples

### With Playwright

```yaml
- name: Run Playwright tests
  run: npx playwright test --reporter=allure-playwright

- uses: yuvalgabay/allure-v3-report-action@v1
  if: always()
  with:
    allure_results: allure-results
    allure_history: allure-history
    report_name: Playwright E2E Tests
```

### With Jest

```yaml
- name: Run Jest with Allure
  run: npm test -- --reporters=jest-allure

- uses: yuvalgabay/allure-v3-report-action@v1
  if: always()
  with:
    allure_results: allure-results
    allure_history: allure-history
    report_name: Jest Unit Tests
```

### With Cypress

```yaml
- name: Run Cypress tests
  run: npx cypress run --reporter=mocha-allure-reporter

- uses: yuvalgabay/allure-v3-report-action@v1
  if: always()
  with:
    allure_results: cypress/allure-results
    allure_history: allure-history
    report_name: Cypress E2E Tests
```
