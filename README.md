# jacobbowie.com

Source for [jacobbowie.com](https://jacobbowie.com), the research portfolio of
Jacob Bowie, PhD. Statistical analysis and machine learning for human
physiology research.

## Stack

- **Quarto** 1.9.37 for authoring
- **Netlify** for hosting and TLS at the `jacobbowie.com` apex
- Path A inline Quarto install: `netlify.toml` curls the Quarto release
  tarball into `/tmp/quarto/` at build time and runs `quarto render`. No
  build plugin, no committed `_site/`, no R or Python on CI.

## Build

```bash
quarto render
```

Renders `index.qmd` to `_site/index.html` for local preview. Push to `main`;
Netlify rebuilds and deploys in ~15 to 30 seconds.

## Pages

- `/` (`index.qmd`): homepage project grid
- `/work/` (`work/`): case-study listing
- `/hire/` (`hire.qmd`): "Work together" posture page
- `/cv` (`cv.qmd`): HTML CV
- `/rtsd/`, `/citation-network/`, `/unlearning/`: interactive case studies whose
  marimo WASM bundles are pulled from per-repo GitHub releases at build time

## Layout

- `_quarto.yml`: site config (theme, navbar, open-graph, schema.org JSON-LD)
- `styles.scss`: SCSS overrides on top of the cosmo theme
- `cv-html.scss`: CV-specific styles, layered on `styles.scss`
- `netlify.toml`: Netlify build configuration (inline Quarto install) plus
  per-route headers and redirects
- `favicon.svg`: JB monogram in brand color `#3C5488`
- `img/`: project thumbnails referenced from `index.qmd`
