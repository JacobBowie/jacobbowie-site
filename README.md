# jacobbowie.com

Source for [jacobbowie.com](https://jacobbowie.com) — a single-page Quarto site
serving as Jacob Bowie's research portfolio.

## Stack

- **Quarto** (1.9.37) for authoring
- **Netlify** for hosting and TLS at the `jacobbowie.com` apex
- `@quarto/netlify-plugin-quarto` installs Quarto on Netlify's build image; the
  rendered `_site/` is regenerated on every push. No R or Python on CI.

## Build

```bash
quarto render
```

Renders `index.qmd` to `_site/index.html` for local preview. Push to `main`;
Netlify rebuilds and deploys (~30-60 seconds for a single static page).

## Layout

- `index.qmd` — the page
- `_quarto.yml` — site config (theme, layout)
- `styles.css` — overrides on top of the cosmo theme
- `netlify.toml` — Netlify build configuration
- `package.json` — registers the Quarto plugin for Netlify
