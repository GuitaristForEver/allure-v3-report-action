# Changelog

## [1.0.0](https://github.com/GuitaristForEver/allure-v3-report-action/compare/v1.0.0...v1.0.0) (2026-01-15)

### Features

- Initial release of Allure v3 Report Action
- Support for Allure v3.0.1 (npm package)
- History tracking across workflow runs via gh-pages
- GitHub Pages deployment integration
- Multiple reports via subfolder support
- Customizable report names and URLs
- Configurable report retention (keep_reports parameter)
- Comprehensive documentation and examples

### Improvements

- Node.js 20-based Docker container for modern runtime
- Automatic history management between workflow runs
- Old report cleanup to prevent storage bloat
- Executor metadata injection for CI/CD context
- Index redirect generation for easy report access
- Full compatibility with Allure v3.0.1 format

### Bug Fixes

- Fixed Allure v3 compatibility by removing unsupported --clean flag
- Added required Allure v3 fields (historyId, testCaseId, fullName) to test fixtures
- Fixed test result file naming convention to use *-result.json suffix
- Added error handling for missing history directory on first run
