#!/usr/bin/env bash
set -e

echo "🚀 Allure v3 Report Action"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create necessary directories
mkdir -p "./${INPUT_GH_PAGES}"
mkdir -p "./${INPUT_ALLURE_HISTORY}"

# Copy existing history
echo "📂 Copying existing history..."
cp -r "./${INPUT_GH_PAGES}/." "./${INPUT_ALLURE_HISTORY}"

# Extract repository information
REPOSITORY_OWNER_SLASH_NAME=${INPUT_GITHUB_REPO}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${INPUT_GITHUB_REPO_OWNER}.github.io/${REPOSITORY_NAME}"

# Handle subfolder configuration
if [[ ${INPUT_SUBFOLDER} != '' ]]; then
    INPUT_ALLURE_HISTORY="${INPUT_ALLURE_HISTORY}/${INPUT_SUBFOLDER}"
    INPUT_GH_PAGES="${INPUT_GH_PAGES}/${INPUT_SUBFOLDER}"
    echo "📁 Using subfolder: ${INPUT_SUBFOLDER}"
    mkdir -p "./${INPUT_ALLURE_HISTORY}"
    GITHUB_PAGES_WEBSITE_URL="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_SUBFOLDER}"
fi

# Handle custom report URL
if [[ ${INPUT_REPORT_URL} != '' ]]; then
    GITHUB_PAGES_WEBSITE_URL="${INPUT_REPORT_URL}"
    echo "🔗 Using custom URL: ${GITHUB_PAGES_WEBSITE_URL}"
fi

# Clean up old reports
COUNT=$(ls "./${INPUT_ALLURE_HISTORY}" 2>/dev/null | wc -l || echo "0")
echo "📊 Current report count: ${COUNT}"

INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS + 1))
if (( COUNT > INPUT_KEEP_REPORTS )); then
    echo "🧹 Cleaning old reports (keeping ${INPUT_KEEP_REPORTS})..."
    cd "./${INPUT_ALLURE_HISTORY}"
    rm -f index.html last-history
    ls | sort -n | grep -v 'CNAME' | head -n -$((INPUT_KEEP_REPORTS - 2)) | xargs rm -rf
    cd "${GITHUB_WORKSPACE}"
fi

# Generate index.html redirect
echo "📝 Creating index.html redirect..."
cat > "./${INPUT_ALLURE_HISTORY}/index.html" << EOF
<!DOCTYPE html>
<meta charset="utf-8">
<meta http-equiv="refresh" content="0; URL=${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/index.html">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<title>Redirecting to latest report...</title>
<body>
<p>Redirecting to <a href="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/index.html">latest report</a>...</p>
</body>
EOF

# Create executor.json for Allure
echo "⚙️  Creating executor.json..."
[ -z "$INPUT_REPORT_NAME" ] && INPUT_REPORT_NAME="Allure Report"

cat > executor.json << EOF
{
  "name": "GitHub Actions",
  "type": "github",
  "reportName": "${INPUT_REPORT_NAME}",
  "url": "${GITHUB_PAGES_WEBSITE_URL}",
  "reportUrl": "${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}",
  "buildUrl": "${INPUT_GITHUB_SERVER_URL}/${INPUT_GITHUB_TESTS_REPO}/actions/runs/${INPUT_GITHUB_RUN_ID}",
  "buildName": "GitHub Actions Run #${INPUT_GITHUB_RUN_ID}",
  "buildOrder": "${INPUT_GITHUB_RUN_NUM}"
}
EOF

mv executor.json "./${INPUT_ALLURE_RESULTS}/"

# Copy previous history into results
echo "📜 Restoring previous run history..."
if [ -d "./${INPUT_GH_PAGES}/last-history" ]; then
    cp -r "./${INPUT_GH_PAGES}/last-history/." "./${INPUT_ALLURE_RESULTS}/history"
    echo "✅ History restored from previous run"
else
    echo "ℹ️  No previous history found - creating bootstrap"
    bash /history-bootstrap.sh "./${INPUT_ALLURE_RESULTS}"
fi

# Copy Allure configuration to enable history
cp /allurerc.json ./allurerc.json

# Generate Allure report
echo "🎨 Generating Allure v3 report..."
echo "   Results: ${INPUT_ALLURE_RESULTS}"
echo "   Output:  ${INPUT_ALLURE_REPORT}"
echo "   Config:  allurerc.json"

# Clean output directory if it exists (Allure v3 doesn't support --clean flag)
rm -rf "./${INPUT_ALLURE_REPORT}"

allure generate "${INPUT_ALLURE_RESULTS}" -o "${INPUT_ALLURE_REPORT}"

# Copy report to history location
echo "💾 Copying report to history..."
cp -r "./${INPUT_ALLURE_REPORT}/." "./${INPUT_ALLURE_HISTORY}/${INPUT_GITHUB_RUN_NUM}"

# Save history for next run
echo "💾 Saving history for next run..."
mkdir -p "./${INPUT_ALLURE_HISTORY}/last-history"
if [ -d "./${INPUT_ALLURE_REPORT}/history" ]; then
  cp -r "./${INPUT_ALLURE_REPORT}/history/." "./${INPUT_ALLURE_HISTORY}/last-history"
else
  echo "⚠️  No history directory in report (first run or no tests)"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Report generated successfully!"
echo "📍 Report location: ${INPUT_ALLURE_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
echo "🌐 Will be available at: ${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}"
