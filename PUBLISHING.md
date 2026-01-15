# Publishing to GitHub Marketplace

This guide explains how to publish and maintain the Allure v3 Report Action on GitHub Marketplace.

## Pre-Publication Checklist

Before publishing to the marketplace, ensure:

- [ ] All tests pass in GitHub Actions
- [ ] Documentation is complete and accurate
- [ ] README.md has clear installation instructions
- [ ] action.yml has proper branding (icon and color)
- [ ] LICENSE file exists (MIT)
- [ ] CHANGELOG.md is up to date
- [ ] Version number follows semantic versioning

## First-Time Publication

### Step 1: Push to GitHub

```bash
# Ensure repository is pushed
git remote add origin https://github.com/yuvalgabay/allure-v3-report-action.git
git branch -M main
git push -u origin main
```

### Step 2: Create First Release

```bash
# Create and push the v1.0.0 tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release with Allure v3 support"
git push origin v1.0.0
```

The release workflow will automatically create a GitHub release.

### Step 3: Publish to Marketplace

1. Go to your repository on GitHub
2. Navigate to the **Releases** section
3. Find the v1.0.0 release
4. Click **"Publish this Action to the GitHub Marketplace"**
5. Select categories:
   - Primary: **Testing**
   - Secondary: **Code Quality**
6. Review the marketplace listing preview
7. Click **"Publish release"**

### Step 4: Verify Marketplace Listing

1. Visit: `https://github.com/marketplace/actions/allure-v3-report-with-history`
2. Verify:
   - README renders correctly
   - Branding icon shows (bar-chart-2)
   - Installation instructions are clear
   - Categories are correct

## Testing the Published Action

Before announcing, test the action from the marketplace:

```yaml
name: Test Published Action

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Create sample results
        run: |
          mkdir allure-results
          echo '{"uuid":"test","name":"Test","status":"passed","stage":"finished"}' > allure-results/test.json

      - uses: yuvalgabay/allure-v3-report-action@v1
        with:
          allure_results: allure-results
          allure_history: allure-history
```

## Publishing Updates

### For Bug Fixes (Patch Release)

```bash
# Update CHANGELOG.md with fixes
# Commit changes
git add .
git commit -m "fix: resolve history not being preserved"

# Create patch release
git tag -a v1.0.1 -m "Release v1.0.1 - Bug fixes"
git push origin v1.0.1
```

### For New Features (Minor Release)

```bash
# Update CHANGELOG.md with new features
# Commit changes
git add .
git commit -m "feat: add support for custom Allure plugins"

# Create minor release
git tag -a v1.1.0 -m "Release v1.1.0 - Custom plugin support"
git push origin v1.1.0
```

### For Breaking Changes (Major Release)

```bash
# Update CHANGELOG.md with breaking changes
# Update documentation
# Commit changes
git add .
git commit -m "feat!: change input parameter names for consistency"

# Create major release
git tag -a v2.0.0 -m "Release v2.0.0 - Breaking changes to input names"
git push origin v2.0.0
```

## Updating Marketplace Listing

After pushing a new tag:

1. GitHub release is created automatically by the workflow
2. The marketplace listing updates automatically
3. Verify the new version appears at: `https://github.com/marketplace/actions/allure-v3-report-with-history`

## Major Version Tags

Keep major version tags updated for convenience:

```bash
# After releasing v1.0.1, update v1 tag
git tag -fa v1 -m "Update v1 to v1.0.1"
git push origin v1 --force

# Users can now use @v1 and get latest v1.x.x
```

## Announcement Strategy

### Initial Launch

1. **GitHub Discussions** (if enabled)
   - Create announcement post
   - Include feature highlights
   - Link to documentation

2. **Community Engagement**
   - Comment on [simple-elf/allure-report-action#74](https://github.com/simple-elf/allure-report-action/issues/74)
   - Share in relevant GitHub discussions
   - Post on dev communities (Reddit, Dev.to, etc.)

3. **Social Media** (optional)
   - Twitter/X with #GitHubActions hashtag
   - LinkedIn with project details

### Template for Announcements

```markdown
🎉 **Allure v3 Report Action** is now available on GitHub Marketplace!

A production-ready GitHub Action for generating Allure v3 reports with history tracking.

✨ **Features:**
- Allure v3 (latest npm version)
- History tracking across runs
- GitHub Pages integration
- Multiple reports support
- Zero configuration required

🚀 **Get started:**
https://github.com/yuvalgabay/allure-v3-report-action

📦 **Marketplace:**
https://github.com/marketplace/actions/allure-v3-report-with-history

📖 **Docs:** Full examples for Playwright, Jest, Cypress, and more!
```

## Monitoring and Maintenance

### Track Metrics

Monitor in GitHub repository:
- Stars and forks
- Issues opened
- Marketplace installs (shown in insights)
- Documentation views

### Regular Updates

- **Monthly**: Check for new Allure v3 releases
- **Quarterly**: Update Node.js base image
- **As needed**: Address user issues and feature requests

### Security

- Enable Dependabot alerts
- Monitor Docker image security advisories
- Keep base image updated
- Review and address security issues promptly

## Deprecating Old Versions

If a version has critical bugs:

1. Create a new patch release with fixes
2. Update README with warning
3. Add note to old release on GitHub
4. Update v1 tag to latest stable

Example deprecation notice:

```markdown
⚠️ **Version 1.0.0 has been deprecated due to a critical bug.**

Please upgrade to v1.0.1 or later:

\`\`\`yaml
- uses: yuvalgabay/allure-v3-report-action@v1.0.1
# or
- uses: yuvalgabay/allure-v3-report-action@v1  # always gets latest v1.x
\`\`\`
```

## Troubleshooting

### Release Workflow Fails

- Check GITHUB_TOKEN permissions in repository settings
- Verify tag format matches `v*` pattern
- Review workflow logs for specific error

### Marketplace Listing Not Updating

- Wait up to 15 minutes for propagation
- Check that release is not marked as draft
- Verify release is not marked as pre-release (unless intended)

### Action Not Found Error

Users getting "action not found" means:
- Repository is private (make it public)
- Tag doesn't exist (verify: `git tag -l`)
- Repository name mismatch in uses: line

## Support

For questions about marketplace publishing:
- [GitHub Actions Documentation](https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace)
- [GitHub Support](https://support.github.com/)
