# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A static, single-page clinical reference tool for **outpatient** hematology and oncology consultations. No build step, no framework, no dependencies — just two files served as plain HTML + JS.

## GitHub

- Repo: https://github.com/david7254672/consult-helper
- Pages (live site): https://david7254672.github.io/consult-helper/
- Git identity configured locally: `david` / `david@local`

## Local preview

```bash
python3 -m http.server 8080
# open http://localhost:8080
```

The app cannot be opened via `file://` (the browser blocks cross-file JS loads). Always use a local server or GitHub Pages.

## Deploying to GitHub Pages

```bash
bash deploy.sh
```

First-time setup is documented in README.md.

**When working in a git worktree**, `deploy.sh` will fail (`ERROR: Not a git repository`) because worktrees have a `.git` file rather than a directory. Instead:

```bash
# 1. Commit in the worktree as normal, then from the main repo:
cd "/Users/david/Desktop/Claude Code/Consult Helper"
git merge <worktree-branch>
git push
```

## Architecture

All clinical content lives in `data.js`. The app shell (`index.html`) never needs to be edited to add or change conditions.

**`data.js`** — declares a global `var conditions = [...]`. Each entry has:
```
{
  id:            string   // unique slug, used as dropdown value
  label:         string   // display name
  specialty:     "hematology" | "oncology"
  history:       { quick: string[], full: string[] }
  exam:          { quick: string[], full: string[] }
  considerations: string[]
  labs: {
    copyable: string[]   // joined with ", " and copied to clipboard
    other:    string[]   // imaging and non-lab investigations, display only
  }
}
```

**`index.html`** — loads `data.js` via `<script src="data.js">`, then runs all app logic in a second `<script>` block. Key behaviours:
- Specialty buttons (`setSpecialty`) filter conditions into the dropdown
- `setCondition` renders the selected card and saves `{specialty, id}` to `localStorage` so the last-used condition reopens on next visit
- History and Exam sections have Quick/Full toggles; checked items persist until the condition changes or Reset is clicked
- The Copy Labs button writes `labs.copyable` as a comma-separated string to the clipboard

## Content conventions

- This is an **outpatient** consultation tool. Differentials, investigation lists, and urgency language should reflect an ambulatory setting — patients are seen in clinic, not admitted. True emergencies (TTP, cord compression, leukostasis, acute leukemia) should still be flagged clearly with same-day action language, but the default framing is "workup to initiate at this visit or arrange shortly after."
- Avoid inpatient-centric language (daily monitoring, nursing checks, stat orders) unless describing a red flag that warrants ED referral.
- `history.quick` — short, negative-framed bullets ("No fevers…") for at-a-glance pre-consult review
- `history.full` — comprehensive positive-framed questions with clinical reasoning, for thorough clerking
- `labs.copyable` — terse test names only, no explanatory text (they get pasted directly into a lab requisition)
- `labs.other` — imaging and procedures; can include brief clinical indication in parentheses
- `considerations` — DDx framing, interpretation pearls, management decision points; not a treatment protocol
