if (exists(".knitr_asciicast_process", envir = .GlobalEnv)) {
  rm(list = ".knitr_asciicast_process", envir = .GlobalEnv)
}

asciicast::init_knitr_engine(
  echo = TRUE,
  echo_input = FALSE,
  interactive = TRUE,
  timeout = as.integer(Sys.getenv("ASCIICAST_TIMEOUT", 10)),
  startup = quote({
    options(cli.width = 70)
    options(cli.progress_show_after = 0)
    options(cli.progress_clear = FALSE)
    library(cli)
    set.seed(1)
    # Make output independent of the machine, user, process, and time,
    # to avoid churn in the generated .Rd files
    Sys.setenv(HOME = "/Users/user", LOGNAME = "user", USER = "user")
    local({
      clienv <- cli:::clienv
      clienv$pid <- 12345L
    })
    local({
      ns <- asNamespace("cli")
      unlockBinding("pb_timestamp", ns)
      makeActiveBinding(
        "pb_timestamp",
        function() {
          if (is.null(getOption("cli__pb"))) "" else "2025-04-22T12:27:16+00:00"
        },
        ns
      )
      lockBinding("pb_timestamp", ns)
    })
  })
)

# Animated SVGs contain real recording timings, so re-rendering them always
# creates churn. By default, reuse the existing man/figures/{label}.svg
# instead of recording; run tools/render-svgs.R to regenerate them.
local({
  ns <- asNamespace("asciicast")
  skip_svg <- function(options) {
    if (Sys.getenv("CLI_RENDER_SVG") == "true") {
      return(FALSE)
    }
    if (!identical(options$asciicast_knitr_output, "svg")) {
      return(FALSE)
    }
    path <- file.path(options$fig.path, paste0(options$label, ".svg"))
    file.exists(path)
  }
  existing_svg <- function(options) {
    options$echo <- attr(options$echo, "asciicast") %||% options$echo
    if (!isFALSE(options$echo)) {
      options$code <- ns$parse_header(options$code)$body
    }
    options$engine <- "r"
    path <- file.path(options$fig.path, paste0(options$label, ".svg"))
    fig_proc <- knitr::opts_current$get("fig.process")
    if (!is.null(fig_proc)) {
      path <- fig_proc(path)
    }
    img <- knitr::knit_hooks$get("plot")(path, options)
    knitr::engine_output(options, options$code, "", img)
  }
  wrap <- function(engine) {
    function(options) {
      if (skip_svg(options)) existing_svg(options) else engine(options)
    }
  }
  knitr::knit_engines$set(asciicast = wrap(ns$eng_asciicast))
  # Chunks cached while skipping have no recording, so record them now
  cache_eng <- function(options) {
    if (file.exists(paste0(options$hash, ".cast"))) {
      ns$cache_eng_asciicast(options)
    } else {
      ns$eng_asciicast(options)
    }
  }
  knitr::cache_engines$set(asciicast = wrap(cache_eng))
})

knitr::opts_chunk$set(
  asciicast_knitr_output = "html",
  asciicast_include_style = FALSE,
  asciicast_theme = "pkgdown"
)

list(
  markdown = TRUE,
  knitr_chunk_options = list(
    cache = TRUE,
    cache_lazy = FALSE,
    cache.path = file.path(getwd(), "man/_cache/"),
    fig.path = file.path(getwd(), "man/figures"),
    error = TRUE
  ),
  restrict_image_formats = TRUE
)
