# Teodoro Leite — portfolio

Live at **https://teodsl06.github.io/portfolio/** (GitHub Pages, `main` / root).
The old misspelled address, `teodsl06.github.io/portfilio`, redirects here — it is
printed on résumés that are already out.

Static site, no framework. Two pages (home and the EWB Kenya case study), inline CSS,
one Google Fonts request, and a little vanilla JS.

## Files

| File | What it is |
| --- | --- |
| `_head.html` | `<title>`, font link, and all the CSS. **Edit here.** |
| `_body.html` | Home page content and its script. **Edit here.** |
| `_kenya.html` | EWB Kenya case study content. **Edit here.** |
| `build.sh` | Builds the pages below from the sources. |
| `index.html`, `kenya.html` | Generated. What GitHub Pages serves. |
| `artifact.html`, `kenya-artifact.html` | Generated. Self-contained copies (assets inlined) for Claude Artifacts. |
| `assets/` | Photos, video and toolpath SVGs. |
| `resume.pdf` | The current résumé — replace this file to update the Résumé links. |

Edit the `_*.html` sources, then:

```bash
bash build.sh
```

Never edit the generated files by hand — the next build overwrites them.

## The scope

The hero is an ARPA-style radar plot. Each role or build is a contact: AIS
triangles for work, radar echoes for builds, diamonds for ME 360 coursework.
Range is how long ago, bearing is the kind of work. Clicking a contact (or a
row in the contact list) locks it, zooms the scope onto it, and opens a panel
with that entry's full content — cloned from the matching `<article id="…">`
further down the page, so there is only one copy of every write-up.

To add a contact: give the article an `id`, add an `<a class="contact">` to the
scope SVG (position = bearing/range on the 600×600 plot) and a row to the
contact list. Anything inside a card's `<div class="more" hidden>` only shows in
the panel.

## Design notes

- Palette is taken from NOAA nautical charts: chart-paper ground, sounding-blue
  tints, and the magenta that marks cautionary and restricted areas as the accent.
  Dark theme follows the ECDIS night palette. The scope itself is always a dark
  display, like the real instrument.
- Type: Archivo (display), IBM Plex Sans (body), IBM Plex Mono (data and labels),
  Spectral italic for the section eyebrows — the italic that labels hydrography on
  a real chart.
- Light and dark are both defined at the token level in `:root`, so the page
  follows the visitor's OS theme. Reduced-motion stops the sweep and the zoom.

## Kept off the page on purpose

- **Phone number** — public page, email and LinkedIn are enough.
- **BU ID** — the ME 360 videos carry it for grading; the stills used here are cropped clear of it.
- **AutoCAD** — committed to, not yet done. Add to Skills when real hours are in.
