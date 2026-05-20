#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# deploy.sh — commit and push the clinical reference to GitHub
#
# First-time setup (run once):
#   git init
#   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
#   git branch -M main
#   bash deploy.sh
#
# Then in GitHub: Settings → Pages → Source: main branch / root
#
# After that, just run:
#   bash deploy.sh
# ─────────────────────────────────────────────────────────────
set -e

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo ""
  echo "ERROR: Not a git repository."
  echo "Run these first:"
  echo "  git init"
  echo "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
  echo "  git branch -M main"
  echo ""
  exit 1
fi

git add index.html data.js

if git diff --cached --quiet; then
  echo "Nothing new to commit — site is already up to date."
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git commit -m "Update clinical reference — ${TIMESTAMP}"
git push

echo ""
echo "Done. Changes are live (allow ~30 sec for GitHub Pages to rebuild)."
