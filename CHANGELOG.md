# Changelog

## [1.0.1](https://github.com/GuitaristForEver/allure-v3-report-action/compare/v1.0.0...v1.0.1) (2026-01-15)


### Bug Fixes

* add contents:write permission for GitHub Pages deployment ([5eef6c8](https://github.com/GuitaristForEver/allure-v3-report-action/commit/5eef6c88435be9d5bc6b88367857fa0f15098d6c))
* add required Allure v3 fields to test fixtures (historyId, testCaseId, fullName) ([b29223f](https://github.com/GuitaristForEver/allure-v3-report-action/commit/b29223f4bc305a94bd6fdc567c0104231c2c1dd1))
* use correct Allure v3 file naming convention for test results ([cfd108d](https://github.com/GuitaristForEver/allure-v3-report-action/commit/cfd108df0e9a5e09f6d1c6613373e3ad119be848))
* use proper test fixtures and handle missing history directory ([4d95e4a](https://github.com/GuitaristForEver/allure-v3-report-action/commit/4d95e4a56a5345b397503eefe1965970209c590f))

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
