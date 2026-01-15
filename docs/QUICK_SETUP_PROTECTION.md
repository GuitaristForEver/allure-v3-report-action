# Quick Setup: Branch Protection (5 minutes)

## ✅ What's Already Done

Your repository now has comprehensive PR testing:

1. ✅ **Test Local Action workflow** - Tests action functionality with real Allure reports
2. ✅ **PR Validation workflow** - Validates code, builds Docker, runs end-to-end tests
3. ✅ Both workflows run automatically on every PR
4. ✅ Test results posted as PR comments

## 🔒 What You Need to Do

Enable branch protection to make these tests **mandatory** before merging.

### Step 1: Go to Settings

Click: https://github.com/GuitaristForEver/allure-v3-report-action/settings/branches

### Step 2: Add Protection Rule

1. Click **"Add branch protection rule"**

2. **Branch name pattern**: `main`

3. **Check these boxes:**

   ✅ **Require a pull request before merging**

   ✅ **Require status checks to pass before merging**
   - Click "Add required status checks"
   - Search and select:
     - `Validate Action Changes`
     - `Test Allure v3 Action`

   ✅ **Require branches to be up to date before merging**

4. Click **"Create"**

### Step 3: Test It

The easiest way to test:

```bash
# Your next commit will trigger a new Release PR
git commit --allow-empty -m "test: verify branch protection"
git push

# Check if release PR was created
gh pr list
```

When the release PR appears, you'll see:
- 🔄 Both workflows running automatically
- 🔒 Merge button disabled until checks pass
- ✅ Merge enabled after checks complete

## 📸 Visual Guide

**Before Protection:**
```
PR opened → Merge button available immediately ⚠️
```

**After Protection:**
```
PR opened
  → Workflows run automatically
  → Checks must pass ✅
  → Then merge button enables 🔒
```

## 🎯 What This Prevents

**Without protection:**
- Broken action code can be merged
- Bugs make it to production
- Action users get broken releases

**With protection:**
- Every PR is tested automatically
- Broken code can't be merged
- Action stays reliable

## 📊 Example: Recent Release

**v1.0.1 Release:**
- Release PR automatically created
- Both workflows ran and passed ✅
- Release automatically published
- v1 tag automatically updated

All protected by the tests you now have!

## 🔗 Full Documentation

For detailed setup and troubleshooting:
- [Branch Protection Guide](BRANCH_PROTECTION.md)

## ⏱️ This Takes 2 Minutes

Seriously, just:
1. Click the settings link above
2. Add the rule
3. Check the three boxes
4. Add the two status checks
5. Create

Done! 🎉
