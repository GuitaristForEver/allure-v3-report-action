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

Follow Conventional Commits:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Adding or updating tests
- `chore:` Maintenance tasks
- `refactor:` Code refactoring

Examples:
- `feat: add support for custom Allure plugins`
- `fix: history not preserved with subfolder`
- `docs: update README with new examples`

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
