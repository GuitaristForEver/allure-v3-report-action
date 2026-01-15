# Branch Protection Setup

To ensure all PRs are tested before merging, configure branch protection rules.

## Required Status Checks

The following workflows must pass before PRs can be merged:

1. **PR Validation** - Comprehensive validation including Docker build and action testing
2. **Test Local Action** - End-to-end action testing with report verification

## Setup Instructions

### 1. Navigate to Branch Protection Settings

Go to: https://github.com/GuitaristForEver/allure-v3-report-action/settings/branches

### 2. Add Rule for `main` Branch

1. Click **"Add branch protection rule"** (or edit existing rule)

2. **Branch name pattern**: `main`

3. **Enable these settings:**

   ✅ **Require a pull request before merging**
   - Required approvals: 0 (or 1 if you want self-review)

   ✅ **Require status checks to pass before merging**
   - Click "Add required status checks"
   - Search for and add:
     - `Validate Action Changes` (from PR Validation workflow)
     - `Test Allure v3 Action` (from Test Local Action workflow)

   ✅ **Require branches to be up to date before merging**
   - Ensures PRs are tested against latest main

   ⚠️ **Do not require reviews from Code Owners** (unless you set up CODEOWNERS)

   ✅ **Require conversation resolution before merging** (recommended)

   ✅ **Include administrators** (optional - applies rules to admins too)

4. Click **"Create"** or **"Save changes"**

### 3. Verify Protection

After setup, try creating a test PR:

```bash
# Create test branch
git checkout -b test-branch-protection
git commit --allow-empty -m "test: verify branch protection"
git push origin test-branch-protection

# Create PR
gh pr create --title "Test: Branch Protection" --body "Testing required checks"
```

You should see:
- ✅ Both workflows start automatically
- 🔒 Merge button is disabled until checks pass
- ✅ Merge becomes available after checks pass

### 4. Example Protection Rule

Here's the recommended configuration:

```yaml
Branch Protection Rule: main

Protect matching branches
  ✅ Require a pull request before merging
      Required approvals: 0

  ✅ Require status checks to pass before merging
      ✅ Require branches to be up to date before merging

      Status checks that are required:
        - Validate Action Changes
        - Test Allure v3 Action

  ✅ Require conversation resolution before merging

  ⬜ Require signed commits (optional)

  ⬜ Require linear history (optional)

  ✅ Include administrators
```

## What Happens with Protection Enabled

### Before Merging a PR:

1. **PR opened** → Both workflows trigger automatically
2. **Workflows run**:
   - Validate action.yml, Dockerfile, entrypoint.sh
   - Build Docker image
   - Test action end-to-end
   - Verify report generation (9 tests expected)
   - Post results as PR comment
3. **Checks pass** → Merge button enables ✅
4. **Checks fail** → Merge blocked ❌

### On Release PR (#2):

The automated release PR will also run these checks before merging, ensuring:
- No bugs introduced in recent commits
- Action still works correctly
- Report generation is functional

## Testing the Protection

### Test Case 1: Breaking Change

Try breaking the action to verify protection works:

```bash
git checkout -b test-break-action

# Break the Dockerfile
echo "INVALID SYNTAX" >> Dockerfile

git commit -am "test: break action"
git push origin test-break-action
gh pr create --title "Test: Breaking change" --body "Should fail checks"
```

**Expected**: ❌ PR validation fails, merge is blocked

### Test Case 2: Working Change

```bash
git checkout -b test-working-change

# Make a harmless change
echo "# Comment" >> README.md

git commit -am "docs: add comment"
git push origin test-working-change
gh pr create --title "Test: Safe change" --body "Should pass checks"
```

**Expected**: ✅ PR validation passes, merge is allowed

## Bypassing Protection (Emergency)

If you need to bypass protection in an emergency:

**Option 1**: Disable "Include administrators" in protection settings

**Option 2**: Temporarily disable the rule:
1. Go to Settings → Branches
2. Click "Edit" on the rule
3. Uncheck "Require status checks to pass before merging"
4. Save changes
5. Merge PR
6. Re-enable the requirement immediately

⚠️ **Not recommended** - only use in genuine emergencies

## CI/CD Best Practices

With branch protection enabled:

1. **Always create PRs** - Even for small changes
2. **Wait for checks** - Don't override unless emergency
3. **Fix failures** - Don't merge failing tests
4. **Keep PRs small** - Easier to review and test
5. **Update regularly** - Rebase on main to avoid conflicts

## Troubleshooting

### "Merge button is always enabled"

- Check required status check names match exactly
- Verify workflows completed (not skipped)
- Ensure "Require status checks to pass" is enabled

### "Checks never appear"

- Verify workflows trigger on `pull_request` event
- Check workflow permissions (may need write access)
- Look for workflow errors in Actions tab

### "Can't merge even after checks pass"

- Check for unresolved conversations (if enabled)
- Verify branch is up to date with main
- Check review requirements (if enabled)

## See Also

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Required Status Checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)
