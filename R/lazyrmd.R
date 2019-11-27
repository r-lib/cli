
lazyrmd <- local({

  lazy_env <- environment()
  parent.env(lazy_env) <- baseenv()

  re_lazy_rmd <- "[.]Rmd$"

  config = list()

  lazy_weave <- function(file, ...) {
    output <- sub(re_lazy_rmd, ".html", file)

    if (! should_build(file, output)) {
      if (!file.exists(output)) file.create(output)
      Sys.setFileTime(output, Sys.time())
      return(output)
    }

    weave(file, ...)
  }

  weave <- function(file, driver, syntax, encoding = "UTF-8",
                    quiet = TRUE, ...) {

    opts <- options(markdown.HTML.header = NULL)
    on.exit({
      knitr::opts_chunk$restore()
      knitr::knit_hooks$restore()
      options(opts)
    }, add = TRUE)

    knitr::opts_chunk$set(error = FALSE)
    knitr::knit_hooks$set(purl = knitr::hook_purl)

    rmarkdown::render(
      file,
      encoding = encoding,
      quiet = quiet,
      envir = globalenv(),
      ...
    )
  }

  lazy_tangle <- function(file, ...) {
    output <- sub(re_lazy_rmd, ".R", file)

    if (! should_build(file, output)) {
      if (!file.exists(output)) file.create(output)
      Sys.setFileTime(output, Sys.time())
      return(output)
    }

    tangle(file, ...)
  }

  tangle <- function(file, ..., encoding = "UTF-8", quiet = FALSE) {
    knitr::purl(file, encoding = encoding, quiet = quiet, ...)
  }

  onload_hook <- function(package, local = "if-newer", ci = TRUE,
                          cran = FALSE) {
    config <<- list(local = local, ci = ci, cran = cran)
    tools::vignetteEngine(
      "lazyrmd",
      weave = lazy_weave,
      tangle = lazy_tangle,
      pattern = re_lazy_rmd,
      package = package
    )
  }

  is_ci <- function() {
    isTRUE(as.logical(Sys.getenv("CI")))
  }

  is_local <- function() {
    if (isTRUE(as.logical(Sys.getenv("NOT_CRAN")))) return(TRUE)
    Sys.getenv("_R_CHECK_PACKAGE_NAME_", "") == ""
  }

  detect_env <- function() {
    # Order matters here, is_local() == TRUE on the CI as well, usually
    if (is_ci()) return("ci")
    if (is_local()) return("local")
    "cran"
  }

  should_build <- function(input, output) {
    env <- detect_env()
    conf <- config[[env]]

    if (isTRUE(conf)) return(TRUE)
    if (identical(conf, FALSE)) return(FALSE)
    if (is.function(conf)) return(isTRUE(conf()))
    if (identical(conf, "if-newer")) {
      return(!file.exists(output) || file_mtime(input) > file_mtime(output))
    }
    FALSE
  }

  file_mtime <- function(...) {
    file.info(..., extra_cols = FALSE)$mtime
  }

  structure(
    list(
      .internal = lazy_env,
      onload_hook = onload_hook
    ),
    class = c("standalone_lazyrmd", "standalone")
  )
})
