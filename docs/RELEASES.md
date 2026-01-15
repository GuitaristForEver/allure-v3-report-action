# Automated Release Management

This project uses automated semantic versioning and release management powered by [Release Please](https://github.com/googleapis/release-please).

## How It Works

1. **Commit with Conventional Commits**: When you push to `main` with properly formatted commits
2. **Release PR Created**: A pull request is automatically created with updated version and CHANGELOG
3. **Merge to Release**: When you merge the release PR, a GitHub release is created with the new version tag
4. **Major Version Tag Updated**: The major version tag (v1, v2, etc.) is automatically updated for GitHub Actions Marketplace

## Conventional Commits Format

Use these prefixes in your commit messages:

### Version Bumps

- **`feat:`** - New feature → **Minor version bump** (1.0.0 → 1.1.0)
- **`fix:`** - Bug fix → **Patch version bump** (1.0.0 → 1.0.1)
- **`feat!:`** or **`fix!:`** or footer `BREAKING CHANGE:` → **Major version bump** (1.0.0 → 2.0.0)

### No Version Bump (Only in CHANGELOG)

- **`docs:`** - Documentation changes
- **`perf:`** - Performance improvements
- **`refactor:`** - Code refactoring (no functional change)
- **`test:`** - Adding or updating tests
- **`build:`** - Build system changes
- **`ci:`** - CI/CD configuration changes
- **`chore:`** - Other changes (not in CHANGELOG by default)
- **`style:`** - Code style/formatting (not in CHANGELOG by default)

## Commit Message Examples

### Feature (Minor Bump)
```bash
git commit -m "feat: add support for custom report themes

Allows users to specify custom CSS themes for Allure reports
via the theme_path input parameter."
```

### Bug Fix (Patch Bump)
```bash
git commit -m "fix: handle missing allure-results directory gracefully

Prevents action from failing when results directory doesn't exist.
Now shows a clear error message instead."
```

### Breaking Change (Major Bump)
```bash
git commit -m "feat!: change default report directory to 'reports'

BREAKING CHANGE: The default allure_report input changed from
'allure-report' to 'reports'. Update your workflows accordingly."
```

Or using footer:
```bash
git commit -m "feat: redesign configuration interface

Complete redesign of input parameters for better usability.

BREAKING CHANGE:
- Renamed 'allure_results' to 'results_path'
- Renamed 'allure_history' to 'history_path'
- Removed 'subfolder' parameter (use path prefixes instead)"
```

### Documentation (No Bump)
```bash
git commit -m "docs: update README with new examples"
```

### Performance (Patch Bump)
```bash
git commit -m "perf: optimize report generation for large test suites

Reduces memory usage by 40% for test suites with 1000+ tests."
```

## Release Process

### Automatic Process

1. **Push to main** with conventional commits:
   ```bash
   git commit -m "feat: add dark mode support"
   git push origin main
   ```

2. **Release Please creates a PR** with:
   - Updated version number
   - Generated CHANGELOG entry
   - Release notes

3. **Review and merge the release PR**:
   - Check the version bump is correct
   - Review the CHANGELOG
   - Merge when ready

4. **Release is automatically created** with:
   - New version tag (e.g., v1.2.0)
   - Updated major tag (e.g., v1)
   - GitHub Release with notes
   - Published to GitHub Actions Marketplace

### Manual Version Override

If you need to force a specific version, edit `.release-please-manifest.json`:

```json
{
  ".": "2.0.0"
}
```

Then commit and push. The next release will use that version.

## Checking Release Status

### View Release PR

```bash
gh pr list --label "autorelease: pending"
```

### View Releases

```bash
gh release list
```

### View Tags

```bash
git tag -l | sort -V
```

## Multiple Commits

Release Please intelligently combines multiple commits:

```bash
# These three commits...
git commit -m "feat: add report filtering"
git commit -m "feat: add search functionality"
git commit -m "fix: correct date formatting"

# ...result in one release PR with:
# Version: 1.1.0 → 1.2.0 (minor bump from features)
# CHANGELOG lists all three changes
```

## Rollback

If you need to rollback a release:

1. **Delete the tag** (locally and remotely):
   ```bash
   git tag -d v1.2.0
   git push origin :refs/tags/v1.2.0
   ```

2. **Delete the release** on GitHub:
   ```bash
   gh release delete v1.2.0
   ```

3. **Update manifest** to previous version:
   ```json
   {
     ".": "1.1.0"
   }
   ```

4. **Revert the merge commit**:
   ```bash
   git revert -m 1 <merge-commit-hash>
   git push origin main
   ```

## Best Practices

1. **Use descriptive commit messages**: Help users understand what changed
2. **Group related changes**: Combine related commits in a single PR
3. **Test before merging release PR**: Run tests against the release branch
4. **Review CHANGELOG**: Ensure generated changelog is accurate
5. **Don't skip versions**: Let Release Please handle versioning automatically
6. **Document breaking changes**: Always explain what users need to update

## Troubleshooting

### Release PR not created

- Check your commit messages follow conventional format
- Verify the workflow has necessary permissions (contents: write, pull-requests: write)
- Check workflow logs: `gh run list --workflow=release-please.yml`

### Wrong version bump

- Check your commit prefix (feat vs fix vs chore)
- Use `feat!:` or `BREAKING CHANGE:` footer for major bumps
- Edit the release PR to adjust version if needed

### Major tag not updating

- Check the workflow completed successfully
- Verify git push permissions
- Manually update: `git tag -fa v1 -m "Update v1" && git push origin v1 --force`

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Release Please Documentation](https://github.com/googleapis/release-please)
- [Semantic Versioning](https://semver.org/)
