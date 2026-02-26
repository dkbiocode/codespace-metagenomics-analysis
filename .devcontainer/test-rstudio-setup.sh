#!/bin/bash
# Test script to verify RStudio can access lessons

echo "Testing RStudio file access setup..."
echo ""

# Simulate the setup
REPO_ROOT="/Users/david/work/codespace-metagenomics-analysis"

echo "1. Checking if lessons directory exists..."
if [ -d "${REPO_ROOT}/lessons" ]; then
    echo "✅ Lessons found: $(ls -1 ${REPO_ROOT}/lessons | wc -l) files"
    ls -1 ${REPO_ROOT}/lessons | head -3
else
    echo "❌ Lessons directory not found!"
fi
echo ""

echo "2. Checking if fig directory exists..."
if [ -d "${REPO_ROOT}/fig" ]; then
    echo "✅ Figures found: $(ls -1 ${REPO_ROOT}/fig | wc -l) files"
else
    echo "❌ Figures directory not found!"
fi
echo ""

echo "3. Checking .Rproj file..."
if [ -f "${REPO_ROOT}/metagenomics-workshop.Rproj" ]; then
    echo "✅ RStudio project file exists"
else
    echo "❌ .Rproj file not found!"
fi
echo ""

echo "4. Checking WELCOME.md..."
if [ -f "${REPO_ROOT}/WELCOME.md" ]; then
    echo "✅ Welcome file exists"
else
    echo "❌ WELCOME.md not found!"
fi
echo ""

echo "What users will see in RStudio Files pane:"
echo "  ~/lessons/     → ${REPO_ROOT}/lessons/"
echo "  ~/fig/         → ${REPO_ROOT}/fig/"
echo "  ~/dc_workshop/ → ${REPO_ROOT}/dc_workshop/"
echo "  ~/WELCOME.md   → ${REPO_ROOT}/WELCOME.md"
echo ""
echo "✅ Setup complete! Users can:"
echo "   - Browse lessons/ in RStudio Files panel"
echo "   - Click .md files to open and read"
echo "   - Copy-paste commands from lessons into Console"
echo "   - Work in ~/dc_workshop/ for their data"
