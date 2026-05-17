# Heme-Onc Clinical Reference

A static, mobile-friendly bedside reference for hematology and oncology consults. No build step, no framework — just two files.

## Files

| File | Purpose |
|------|---------|
| `index.html` | App shell — all CSS and JS logic. Never needs editing to add content. |
| `data.js` | All clinical content as an ES module. **Only file you ever edit.** |

## Adding a new condition

Open `data.js` and copy any existing condition block. Change:
- `id` — unique slug (e.g. `"hemolytic-anemia"`)
- `label` — display name in the dropdown
- `specialty` — `"hematology"` or `"oncology"`
- Fill in `history.quick`, `history.full`, `exam.quick`, `exam.full`, `considerations`, `labs.copyable`, `labs.other`

Save. Done.

## Local preview

Because `index.html` uses an ES module (`import` from `data.js`), browsers block it over `file://`. Use a local server:

```bash
cd "/Users/david/Desktop/Claude Code/Consult Helper"
python3 -m http.server 8080
# then open http://localhost:8080
```

## GitHub Pages deployment

### First time only

```bash
cd "/Users/david/Desktop/Claude Code/Consult Helper"
git init
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
bash deploy.sh
```

Then in your repo on GitHub:
**Settings → Pages → Source → Deploy from branch → `main` / `/ (root)` → Save**

Your site will be at: `https://YOUR_USERNAME.github.io/YOUR_REPO/`

### Every time after that

```bash
bash deploy.sh
```

That's it. Changes go live within ~30 seconds.
