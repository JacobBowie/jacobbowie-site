# jacobbowie.com — Claude context

This is the source repo for **https://jacobbowie.com**, Jacob Bowie's research portfolio. Quarto site, Netlify-hosted, custom domain.

Read this before editing anything in this repo.

## Stack

- **Quarto 1.9.37** authors `.qmd` → static HTML
- **Netlify** builds + hosts at `jacobbowie.com` (apex) + `jacobbowie.netlify.app`
- **No R or Python on CI** — the site is pure-markdown Quarto, no code execution at build time

## Build path: Path A (inline tarball)

The build command in `netlify.toml` curls the Quarto release tarball into `/tmp/quarto/` and renders. No build plugin (`@quarto/netlify-plugin-quarto` is functionally abandoned per the 2026-05-11 audit), no committed `_site/`, no Netlify CLI in the loop. Builds in ~15-30 seconds.

**Do not** revert to the plugin. **Do not** extract the tarball to repo root (it places `.qmd` template files that crash `quarto render`).

Full audit + alternative paths: `~/.claude/skills/quarto-netlify/SKILL.md`.

## File layout

```
index.qmd                    Homepage — 5-tile project grid
hire.qmd                     "Work together" posture page
work/                        Case studies (multi-page, growing)
  synthesim.qmd              First case study (shipped 2026-05-12)
  # listing/index pending — see navbar refactor plan
citation-network/            Banister Constellation case study
  index.qmd                  Landing page
  og_metadata.html           OG card metadata for the route
_quarto.yml                  Site config: theme, schema.org JSON-LD, resources globs
styles.scss                  SCSS on top of the cosmo theme
netlify.toml                 Build command + per-route X-Frame-Options
favicon.svg                  JB monogram in brand #3C5488
img/                         Homepage thumbnails (committed binaries)
Bowie_CV.pdf                 CV download (committed)
_drafts/                     Drafts not yet promoted to case studies (gitignored from render)
```

## Routes pulled from external releases at build time

The `/citation-network/{interactive,notebook,assets}/` subtrees are NOT committed. Netlify fetches them at build time from `JacobBowie/citation-network@${CN_TAG}` release assets. To update the citation network viz: cut a new release in that repo, bump `CN_TAG` in `netlify.toml`, push.

`.gitignore` excludes the fetched paths so they don't accidentally get committed.

## Headers + redirects

Site-wide default is `X-Frame-Options: DENY`. Per-route `SAMEORIGIN` overrides exist for `/citation-network/{interactive,notebook}/*` because those routes embed their own viz via iframe. If you add another iframed route, add a matching `[[headers]]` block — without it the iframe will be silently blank.

## What is live vs draft vs deferred

**Live (in `main`, deployed):**
- `/` homepage (5-tile grid)
- `/hire/` posture page
- `/work/synthesim/` case study
- `/citation-network/` case study + interactive + notebook routes
- `/Bowie_CV.pdf`

**Drafts** (in `_drafts/`, not rendered):
- `emg-fatigue.md` — blocked on `leg-extension-emg-fatigue-2026` flip-public
- `literature-pipeline.md` — repo public; promote to `work/literature-pipeline.qmd`
- `unlearning.md` — blocked on `marimo-unlearning` flip-public + v0.1.0 release

**Planned next:** navbar + `/work/` Quarto listing page. Plan in user memory `project_jacobbowie_site_v1_3_navbar_plan.md`.

## Conventions

- **No em-dashes.** Strip from any prose you add. Use sentence rewrites, period+comma, or en-dash in ranges. See `feedback_no_em_dashes_in_user_output` in user memory.
- **Quarto front matter** uses `pagetitle` for the `<title>` tag; `title:` is the page H1.
- **Case-study image paths** are relative from inside `work/` so `../img/foo.png` not `/img/foo.png`.
- **Branch deploys** are gated by `allowed_branches` in Netlify site config. Restored to `["main"]` after testing per the credit-budget pattern.

## Auth + preview workflow

- Netlify PAT: env var `NETLIFY_AUTH_TOKEN` (40 chars). Smoke-test: `curl -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" https://api.netlify.com/api/v1/user`. If unauth, the site/deploys endpoints still return a stripped 200 anonymous view — easy to misdiagnose. Check `${#NETLIFY_AUTH_TOKEN}=40` first.
- For visual-change PRs, push to a feature branch — Netlify auto-builds a `deploy-preview-N--jacobbowie.netlify.app` URL. Eyeball before merging.

## Net positive checks before any commit

1. `quarto render` succeeds locally (catches YAML errors, broken cross-refs)
2. No new em-dashes (`git diff main..HEAD | grep "^\+" | grep "—"`)
3. If touching `netlify.toml`: push to a test branch first, never test on main
4. If touching `_quarto.yml` `resources` globs: verify `_site/` actually contains the resource after render
