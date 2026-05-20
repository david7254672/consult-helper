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

`index.html` loads `data.js` via a plain `<script src="data.js">` tag, so opening `index.html` directly over `file://` works in most browsers. A local server is recommended for parity with the GitHub Pages environment.

## Deploying to GitHub Pages

```bash
bash deploy.sh
```

First-time setup is documented in README.md. `deploy.sh` works inside git worktrees as well as the main checkout.

## Architecture

All clinical content lives in `data.js`. The app shell (`index.html`) never needs to be edited to add or change conditions.

### `data.js` — the only file to edit for content

Declares two globals:

- `var DATA_VERSION = "YYYY-MM-DD"` — the date of the last meaningful content review. **Bump this whenever you make non-trivial content changes**; it's rendered in the page footer so the reference shows when it was last reviewed.
- `var conditions = [...]` — array of condition objects. This file is the single source of truth for the schema below; the data-shape comment in `data.js` and the runtime validator in `index.html` should match it.

Schema for each condition:

```
{
  id:            string   // unique slug, used as dropdown value
  label:         string   // display name in the dropdown and search results
  specialty:     "hematology" | "oncology"
  history:       { quick: string[], full: string[] }
  exam:          { quick: string[], full: string[] }
  considerations: string[]
  labs: {
    copyable: string[]   // joined with ", " and copied to clipboard
    other:    string[]   // imaging and other investigations, read-only list
  }
}
```

A runtime validator in `index.html` will `console.warn` if any condition is missing fields, has a bad `specialty`, or duplicates an `id`.

### `index.html` — app shell

Loads `data.js` via `<script src="data.js">`, then runs all app logic in a second `<script>` block. Key behaviours:
- Specialty buttons (`setSpecialty`) filter conditions into the dropdown
- The search input fuzzy-matches across all conditions regardless of specialty; selecting a result switches to that specialty and opens the condition
- `setCondition` renders the selected card and saves `{specialty, id}` to `localStorage` so the last-used condition reopens on next visit
- History and Exam sections have Quick/Full toggles; checked items persist until the condition changes or Reset is clicked
- The Copy Labs button writes `labs.copyable` as a comma-separated string to the clipboard
- Footer shows `DATA_VERSION`; a `@media print` stylesheet hides controls and stacks columns for clean printing

## Content conventions

- This is an **outpatient** consultation tool. Differentials, investigation lists, and urgency language should reflect an ambulatory setting — patients are seen in clinic, not admitted. True emergencies (TTP, cord compression, leukostasis, acute leukemia) should still be flagged clearly with same-day action language, but the default framing is "workup to initiate at this visit or arrange shortly after."
- Avoid inpatient-centric language (daily monitoring, nursing checks, stat orders) unless describing a red flag that warrants ED referral.
- `history.quick` — short, negative-framed bullets ("No fevers…") for at-a-glance pre-consult review
- `history.full` — comprehensive positive-framed questions with clinical reasoning, for thorough clerking
- `labs.copyable` — terse test names only, no explanatory text (they get pasted directly into a lab requisition)
- `labs.other` — imaging and procedures; can include brief clinical indication in parentheses
- `considerations` — DDx framing, interpretation pearls, management decision points; not a treatment protocol
