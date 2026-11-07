# Regenerate the animated SVGs in man/figures/.
#
# devtools::document() reuses the existing SVGs (see man/roxygen/meta.R)
# because every recording has slightly different timings. Run this script
# from the package root when an SVG example changes:
#
#   Rscript tools/render-svgs.R
#
# Re-recording is skipped for chunks whose code hasn't changed since they were
# last cached in man/_cache. Delete that directory to force a full re-render.

render_svgs <- function() {
  withr::local_envvar(CLI_RENDER_SVG = "true")
  devtools::document()
}

render_svgs()
