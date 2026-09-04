# Teodoro Leite — portfolio

Single-page portfolio site. No framework, no build step beyond `cat` — the whole
page is one HTML file with inline CSS and one Google Fonts request.

## Files

| File | What it is |
| --- | --- |
| `_head.html` | `<title>`, font link, and all the CSS. **Edit here.** |
| `_body.html` | All the page content. **Edit here.** |
| `build.sh` | Concatenates the two sources into the outputs below. |
| `index.html` | Generated. Standalone page for GitHub Pages or any static host. |
| `artifact.html` | Generated. Same page as a fragment, for publishing as a Claude Artifact. |

Edit `_head.html` / `_body.html`, then:

```bash
bash build.sh
```

Never edit `index.html` or `artifact.html` by hand — the next build overwrites them.

## Publishing to GitHub Pages

```bash
git init
git add .
git commit -m "Portfolio site"
git branch -M main
git remote add origin https://github.com/teodsl06/portfolio.git
git push -u origin main
```

Then on GitHub: **Settings → Pages → Source: Deploy from a branch → `main` / `(root)`**.
The site goes live at `https://teodsl06.github.io/portfolio/` in about a minute.

For a URL without the `/portfolio/` suffix, name the repo `teodsl06.github.io`
instead — it then serves from `https://teodsl06.github.io/`.

## Design notes

- Palette is taken from NOAA nautical charts: chart-paper ground, sounding-blue
  tints, and the magenta that marks cautionary and restricted areas as the accent.
  Dark theme follows the ECDIS night palette.
- Type: Archivo (display), IBM Plex Sans (body), IBM Plex Mono (data and labels),
  Spectral italic for the section eyebrows — the italic that labels hydrography on
  a real chart.
- Light and dark are both defined at the token level in `:root`, so the page
  follows the visitor's OS theme.

## Kept off the page on purpose

- **Phone number** — public page, email and LinkedIn are enough.
- **BlueTIDE award** — the exact wording and Robosys credit aren't confirmed yet.
  Add it once they are.
- **AutoCAD** — committed to, not yet done. Add to Skills when real hours are in.
