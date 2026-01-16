# Allure v3 Report Action 🎯

[![Test Action](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/test-local.yml/badge.svg)](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/test-local.yml)
[![PR Validation](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/pr-validation.yml/badge.svg)](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/pr-validation.yml)
[![Release](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/release-please.yml/badge.svg)](https://github.com/GuitaristForEver/allure-v3-report-action/actions/workflows/release-please.yml)

Generate beautiful Allure v3 test reports with history tracking in GitHub Actions.

## ✨ Features

- 🎨 **Allure v3** - Latest generation of Allure reporting framework
- 📊 **History Tracking** - Maintain test trends across runs
- 🚀 **GitHub Pages** - Easy deployment to gh-pages
- 📁 **Multiple Reports** - Support multiple projects via subfolders
- 🎯 **Zero Config** - Works out of the box with sensible defaults
- 🔧 **Customizable** - Full control over report names and URLs

## 🚀 Quick Start

```yaml
name: Tests with Allure Report

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      # Run your tests and generate allure-results
      - name: Run tests
        run: npm test  # or your test command

      # Get previous report history
      - name: Get Allure history
        uses: actions/checkout@v4
        if: always()
        continue-on-error: true
        with:
          ref: gh-pages
          path: gh-pages

      # Generate report
      - name: Generate Allure Report
        uses: yuvalgabay/allure-v3-report-action@v1
        if: always()
        with:
          allure_results: allure-results
          allure_history: allure-history

      # Publish to GitHub Pages
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        if: always()
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_branch: gh-pages
          publish_dir: allure-history
```

## 📋 Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `allure_results` | Path to Allure test results | Yes | `allure-results` |
| `allure_report` | Path for generated report | Yes | `allure-report` |
| `allure_history` | Path for history publication | Yes | `allure-history` |
| `gh_pages` | Path to gh-pages checkout | Yes | `gh-pages` |
| `report_name` | Custom report title | No | `Allure Report` |
| `subfolder` | Subfolder for multiple reports | No | `''` |
| `keep_reports` | Number of reports to keep | No | `20` |
| `report_url` | Custom URL override | No | `''` |

For all inputs and advanced configuration, see [USAGE.md](docs/USAGE.md).

## 📖 Examples

### Basic Usage

```yaml
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: test-results
    allure_history: reports
```

### Multiple Reports

```yaml
# iOS tests
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: ios-results
    allure_history: allure-history
    subfolder: ios
    report_name: iOS Tests

# Android tests
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: android-results
    allure_history: allure-history
    subfolder: android
    report_name: Android Tests
```

See [EXAMPLES.md](docs/EXAMPLES.md) for more use cases.

## 🔄 Migration from Allure v2

If you're using `simple-elf/allure-report-action`, migration is simple:

**Before:**
```yaml
- uses: simple-elf/allure-report-action@master
  with:
    allure_results: allure-results
```

**After:**
```yaml
- uses: yuvalgabay/allure-v3-report-action@v1
  with:
    allure_results: allure-results
```

Your existing history will be preserved automatically.

## 🎯 Why Allure v3?

- **Modern Architecture** - Built with TypeScript, plugin-based design
- **Better Performance** - Faster report generation
- **Enhanced Visuals** - New "Awesome" theme with better charts
- **Active Development** - Latest features and improvements
- **v2 Compatible** - Reads Allure v2 test results format

## 🤖 Automatic Updates

This repository uses **Dependabot** to track Allure v3 releases and automatically create PRs when updates are available.

### What's tracked:
- 📦 **Allure npm package** - Weekly checks for new versions
- 🎯 **GitHub Actions** - Weekly checks for action updates

### When Allure updates:
Dependabot will create a PR with:
- Detailed changelog information
- Checklist for verifying new features
- **Special attention** to categories.json support ([Issue #441](https://github.com/allure-framework/allure3/issues/441))

### Current known limitations:
- ❌ **Quality Gates**: Categories.json not yet supported in Allure v3.0.1 ([Issue #441](https://github.com/allure-framework/allure3/issues/441))
- ❌ **Status Dynamics**: History directory not generated by Allure v3.0.1 ([Issue #455](https://github.com/allure-framework/allure3/issues/455))
- ❌ **Status Transitions**: History directory not generated by Allure v3.0.1 ([Issue #455](https://github.com/allure-framework/allure3/issues/455))

These are **upstream Allure v3 limitations**, not issues with this action. Once Allure v3 adds these features, Dependabot will create a PR and the widgets will automatically start working!

## 📊 Live Examples

[Example Report](https://yuvalgabay.github.io/allure-v3-report-action/)

## 🛠️ Development

```bash
# Clone repository
git clone https://github.com/yuvalgabay/allure-v3-report-action.git
cd allure-v3-report-action

# Build Docker image
docker build -t allure-v3-action .

# Test locally
docker run --rm \
  -e INPUT_ALLURE_RESULTS=allure-results \
  -e INPUT_ALLURE_REPORT=allure-report \
  -v $(pwd):/app \
  allure-v3-action
```

## 🤝 Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## 📄 License

MIT © Yuval Gabay

## 🙏 Acknowledgments

This action is built with and dedicated to the [**Allure Framework v3**](https://github.com/allure-framework/allure3) - the next generation of the powerful test reporting framework. Special thanks to the Allure team for creating such an amazing tool that makes test reporting beautiful and insightful.

- **Allure Framework v3**: [GitHub Repository](https://github.com/allure-framework/allure3) | [Official Documentation](https://allurereport.org/docs/)
- Inspired by [simple-elf/allure-report-action](https://github.com/simple-elf/allure-report-action)

## 📚 Resources

- **[Allure v3 Documentation](https://allurereport.org/docs/)** - Official documentation
- **[Allure v3 GitHub Repository](https://github.com/allure-framework/allure3)** - Source code and issues
- [Allure Report Examples](https://allurereport.org/docs/examples/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Creating GitHub Actions](https://docs.github.com/en/actions/creating-actions)
