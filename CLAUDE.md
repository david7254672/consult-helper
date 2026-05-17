# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A static, single-page clinical reference tool for outpatient hematology and oncology consultations. No build step, no framework, no dependencies — just two files served as plain HTML + JS.

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

- This is an **outpatient** consultation tool. Differentials, investigation lists, and urgency language should reflect an ambulatory setting. True emergencies (TTP, cord compression, leukostasis, acute leukemia) should still be flagged clearly, but the default framing is "workup to initiate at this visit."
- `history.quick` — short, negative-framed bullets ("No fevers…") for at-a-glance pre-consult review
- `history.full` — comprehensive positive-framed questions with clinical reasoning, for thorough clerking
- `labs.copyable` — terse test names only, no explanatory text (they get pasted directly into a lab requisition)
- `labs.other` — imaging and procedures; can include brief clinical indication in parentheses
- `considerations` — DDx framing, interpretation pearls, management decision points; not a treatment protocol
