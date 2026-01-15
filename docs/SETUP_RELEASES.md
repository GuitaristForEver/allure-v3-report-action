# Setting Up Automated Releases

The automated release workflow requires one-time repository configuration.

## Required: Enable GitHub Actions PR Creation

GitHub Actions needs permission to create pull requests for automated releases.

### Steps to Enable:

1. **Go to Repository Settings**
   ```
   https://github.com/GuitaristForEver/allure-v3-report-action/settings
   ```

2. **Navigate to Actions → General**
   - On the left sidebar, click "Actions"
   - Then click "General"

3. **Scroll to "Workflow permissions"**

4. **Enable PR Creation**
   - Check ✅ **"Allow GitHub Actions to create and approve pull requests"**
   - Click "Save"

![Workflow Permissions](https://docs.github.com/assets/cb-51223/mw-1440/images/help/settings/actions-workflow-permissions-repository.webp)

## Alternative: Use Personal Access Token (Optional)

If you prefer not to enable the setting above, you can use a Personal Access Token:

### Create a PAT:

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Name it: `RELEASE_TOKEN`
4. Select scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
5. Click "Generate token"
6. **Copy the token** (you won't see it again!)

### Add Token to Repository:

1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `RELEASE_TOKEN`
4. Value: Paste your PAT
5. Click "Add secret"

### Update Workflow:

Edit `.github/workflows/release-please.yml`:

```yaml
- name: Run Release Please
  uses: googleapis/release-please-action@v4
  id: release
  with:
    release-type: simple
    package-name: allure-v3-report-action
    token: ${{ secrets.RELEASE_TOKEN }}  # Changed from GITHUB_TOKEN
```

## Verify Setup

After enabling one of the options above:

1. **Make a test commit** with conventional format:
   ```bash
   git commit -m "feat: test automated release setup"
   git push origin main
   ```

2. **Check workflow runs**:
   ```bash
   gh run list --workflow=release-please.yml
   ```

3. **Look for Release PR**:
   ```bash
   gh pr list --label "autorelease: pending"
   ```

4. **If successful**, you should see a PR titled:
   - "chore(main): release 1.0.1" (or similar)

## Troubleshooting

### Error: "GitHub Actions is not permitted to create pull requests"

**Solution**: Enable "Allow GitHub Actions to create and approve pull requests" in repository settings (see above).

### Error: "Resource not accessible by integration"

**Solution**: The workflow needs `contents: write` and `pull-requests: write` permissions. These are already configured in the workflow file.

### No PR Created

**Possible causes**:
1. No commits since last release with feat/fix/breaking change
2. Commit messages don't follow conventional format
3. Workflow failed (check logs: `gh run view --log`)

### PR Created But No Release

**This is expected behavior!** Release Please creates a PR first. The actual release is created when you **merge the release PR**.

## How It Works After Setup

Once configured, the workflow runs automatically:

1. **On every push to main**: Analyzes commits using conventional commit format
2. **If new version needed**: Creates/updates a release PR
3. **When you merge the PR**: Automatically creates GitHub release with tag
4. **Major tag updated**: Updates v1/v2/etc. tags for Actions Marketplace

See [RELEASES.md](RELEASES.md) for complete documentation on using the automated release system.
