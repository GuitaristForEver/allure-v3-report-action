# Contributing to Allure v3 Report Action

Thank you for considering contributing! 🎉

## How to Contribute

### Reporting Bugs

Open an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, GitHub Actions runner)
- Sample workflow YAML

### Suggesting Features

Open an issue describing:
- Use case and motivation
- Proposed solution
- Alternative approaches considered

### Submitting Pull Requests

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Make** your changes
4. **Test** locally with Docker
5. **Commit** with clear messages (`git commit -m 'feat: add amazing feature'`)
6. **Push** to your fork (`git push origin feature/amazing-feature`)
7. **Open** a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/allure-v3-report-action.git
cd allure-v3-report-action

# Build Docker image
docker build -t allure-v3-action:dev .

# Test locally
mkdir -p allure-results
echo '{"uuid":"test","name":"Test","status":"passed","stage":"finished"}' > allure-results/test.json

docker run --rm \
  -e INPUT_ALLURE_RESULTS=allure-results \
  -e INPUT_ALLURE_REPORT=allure-report \
  -e INPUT_GH_PAGES=gh-pages \
  -e INPUT_ALLURE_HISTORY=allure-history \
  -e INPUT_KEEP_REPORTS=20 \
  -e INPUT_GITHUB_RUN_NUM=1 \
  -e INPUT_GITHUB_RUN_ID=1 \
  -e INPUT_GITHUB_REPO=test/repo \
  -e INPUT_GITHUB_REPO_OWNER=test \
  -e INPUT_GITHUB_TESTS_REPO=test/repo \
  -e INPUT_GITHUB_SERVER_URL=https://github.com \
  -e INPUT_SUBFOLDER='' \
  -e INPUT_REPORT_URL='' \
  -e INPUT_REPORT_NAME='Test Report' \
  -v $(pwd):/app \
  allure-v3-action:dev
```

## Commit Message Guidelines

We use **Conventional Commits** for automated semantic versioning and changelog generation.

### Format

```
<type>[(scope)]: <description>

[optional body]

[optional footer]
```

### Types and Version Bumps

- **`feat:`** - New feature → **Minor version bump** (1.0.0 → 1.1.0)
- **`fix:`** - Bug fix → **Patch version bump** (1.0.0 → 1.0.1)
- **`feat!:`** or **`fix!:`** or `BREAKING CHANGE:` → **Major version bump** (1.0.0 → 2.0.0)
- **`docs:`** - Documentation (no version bump, appears in changelog)
- **`perf:`** - Performance improvement (patch bump)
- **`refactor:`** - Code refactoring (no version bump, hidden from changelog)
- **`test:`** - Tests (no version bump, hidden from changelog)
- **`chore:`** - Maintenance (no version bump, hidden from changelog)
- **`build:`** - Build system (no version bump, hidden from changelog)
- **`ci:`** - CI/CD changes (no version bump, hidden from changelog)

### Examples

**Feature (minor bump):**
```bash
git commit -m "feat: add support for custom Allure plugins

Allows users to load custom Allure plugins via the plugins_path input"
```

**Bug Fix (patch bump):**
```bash
git commit -m "fix: history not preserved with subfolder configuration

Fixes issue where history was lost when using subfolder parameter"
```

**Breaking Change (major bump):**
```bash
git commit -m "feat!: redesign input parameters

BREAKING CHANGE: Renamed allure_results to results_path for clarity.
Users must update their workflows to use the new parameter name."
```

**Documentation (no bump):**
```bash
git commit -m "docs: update README with new examples"
```

📖 **See [docs/RELEASES.md](docs/RELEASES.md) for complete release management documentation.**

## Testing

Test your changes with:

1. **Local Docker test** (see above)
2. **Workflow test** - Push to your fork and check Actions tab
3. **Integration test** - Use in a real project

## Code Style

- Use bash best practices
- Add comments for complex logic
- Keep functions small and focused
- Validate inputs before use
- Handle errors gracefully

## Questions?

Open an issue or discussion if you need help!
