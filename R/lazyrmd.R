
# # Standalone file for controlling when and where to build vignettes ----
#
# The canonical location of this file is in the asciicast package:
# https://github.com/r-lib/asciicast/master/R/lazyrmd.R
#
# This standalone file provides a vignette builder that gives you more
# control about when, where and how the vignettes of an R package will be
# built. Possible use cases:
# * do not rebuild vignettes on CRAN
# * do not rebuild vignettes on a CI if the build time dependencies are
#   not available.
# * avoid rebuilding long running vignettes.
# * fully static vignettes that never rebuild.
# * etc.
#
# ## API
#
# ```
# onload_hook(local = "if-newer", ci = TRUE, cran = "no-code")
# build(mode = c("force", "if-newer"))
# ```
#
# ## Usage
#
# To use this standalone in your package, do the following:
# 1. Copy this file into your package, without changes.
# 2. Call `lazyrmd$onload_hook()` from the `.onLoad()` function of your
#    package. For example:
#    ```
#    .onLoad <- function(libname, pkgname) {
#      lazyrmd$onload_hook(
#        local = FALSE,
#        ci = function() is_recording_supported(),
#        cran = "no-code"
#      )
#    }
#    ```
# 3. Add the package itself as a vignette builder, in `DESCRIPTION`.
# 4. Also in `DESCRIPTION`, add knitr and rmarkdown to `Suggests`, if you
#    want to install them automatically on the CI, and/or you want to
#    build vignettes in CRAN.
# 5. Change the builder of the vignettes that you want to build lazily,
#    in the YAML header. E.g.:
#    ```
#    vignette: >
#    %\VignetteIndexEntry{asciicast example vignette}
#    %\VignetteEngine{asciicast::lazyrmd}
#    %\VignetteEncoding{UTF-8}
#    ```
#
# ## NEWS:
#
# ### 1.0.0 -- 2019-12-01
#
# * First release.

lazyrmd <- local({

  # config ---------------------------------------------------------------

  # Need to do this before we mess up the environment
  package_name <- utils::packageName()
  lazy_env <- environment()
  parent.env(lazy_env) <- baseenv()

  re_lazy_rmd <- "[.]Rmd$"

  config = list()

  # API ------------------------------------------------------------------

  #' Configure the lazy vignette builder
  #'
  #' @noRd
  #' @param local Whether/when to build vignettes for local builds.
  #' @param ci Whether/when to build vignettes on the CI(s).
  #' @param cran Whether/when to build vignettes on CRAN.
  #'
  #' Possible values for `local`, `ci` and `cran` are:
  #' * `TRUE`: always (re)build the vignettes.
  #' * `FALSE`: never (re)build the vignettes.
  #' * `"if-newer"`: Only re(build) the vignettes if the Rmd file is newer.
  #' * `"no-code"`: never rebuild the vignettes, and make sure that the
  #'                `.R` file only contains dummy code. (This is to make
  #'                sure that the `.R` file runs on CRAN.)
  #' * a function object. This is called without arguments and if it
  #'   returns an `isTRUE()` value, then the vignette is built.

  onload_hook <- function(local = "if-newer", ci = TRUE, cran = "no-code") {
    config <<- list(local = local, ci = ci, cran = cran, forced = NULL)
    tools::vignetteEngine(
      "lazyrmd",
      weave = lazy_weave,
      tangle = lazy_tangle,
      pattern = re_lazy_rmd,
      package = package_name
    )
  }

  #' Build vignettes
  #'
  #' This is a utility function, and you would probably not use it in the
  #' package code itself. It can force the re-building of all vignettes.
  #' This function ignores the vignette configuration that was created with
  #' `onload_hook()`.
  #'
  #' @param mode `"force"` forces vignette re-building, even if the `.Rmd`
  #'   file is older than the output file(s). `"if-newer"` will only
  #'   re-build if the `.Rmd` file is newer.
  #' @return The return value of [tools::buildVignettes()].

  build <- function(mode = c("force", "if-newer")) {
    mode <- match.arg(mode)
    config$forced <<- if (mode == "force") TRUE else mode
    env_save <- Sys.getenv("LAZY_RMD_FORCED", NA_character_)
    if (is.na(env_save)) {
      on.exit(Sys.unsetenv("LAZY_RMD_FORCED"), add = TRUE)
    } else {
      on.exit(Sys.setenv(LAZY_RMD_FORCED = env_save), add = TRUE)
    }
    Sys.setenv(LAZY_RMD_FORCED = "true")
    tools::buildVignettes(dir = ".", tangle = TRUE)
  }

  # internals ------------------------------------------------------------

  #' This is called by [tools::buildVignettes], as the weave function of
  #' the lazyrmd vignette engine

  lazy_weave <- function(file, ...) {
    output <- sub(re_lazy_rmd, ".html", file)
    env <- detect_env()
    conf <- config[[env]]

    if (! should_build(file, output, conf)) {
      create_if_needed(output, conf)
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

    # This will create the `.R` file as well. Then it might get overwritten
    # by a tangle step, if any. Typically it won't because it will be
    # newer than the `.Rmd` file.
    knitr::knit_hooks$set(purl = knitr::hook_purl)

    rmarkdown::render(
      file,
      encoding = encoding,
      quiet = quiet,
      envir = globalenv(),
      ...
    )
  }

  #' This is called by [tools::buildVignettes], as the tangle function of
  #' the lazyrmd vignette engine

  lazy_tangle <- function(file, ...) {
    output <- sub(re_lazy_rmd, ".R", file)
    env <- detect_env()
    conf <- config[[env]]

    if (! should_build(file, output, conf)) {
      create_if_needed(output, conf)
      return(output)
    }

    tangle(file, ...)
  }

  tangle <- function(file, ..., encoding = "UTF-8", quiet = FALSE) {
    output <- sub(re_lazy_rmd, ".R", file)
    knitr::purl(file, encoding = encoding, quiet = quiet, ...)
  }

  is_ci <- function() {
    isTRUE(as.logical(Sys.getenv("CI")))
  }

  #' If NOT_CRAN is set to a true value, then we are local
  #' Otherwise we are local if not running inside `R CMD check`.

  is_local <- function() {
    if (isTRUE(as.logical(Sys.getenv("NOT_CRAN")))) return(TRUE)
    Sys.getenv("_R_CHECK_PACKAGE_NAME_", "") == ""
  }

  detect_env <- function() {
    # Order matters here, is_local() == TRUE on the CI as well, usually
    if (!is.na(Sys.getenv("LAZY_RMD_FORCED", NA_character_))) return("forced")
    if (is_ci()) return("ci")
    if (is_local()) return("local")
    "cran"
  }

  should_build <- function(input, output, conf) {
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

  create_if_needed <- function(path, conf) {
    if (!file.exists(path)) file.create(path)
    if (identical(conf, "no-code")) {
      code_file <- sub("\\.html$", ".R", path)
      cat("# Dummy file for static vignette\n", file = code_file)
    }
    Sys.setFileTime(path, Sys.time())
  }

  structure(
    list(
      .internal = lazy_env,
      onload_hook = onload_hook,
      build = build
    ),
    class = c("standalone_lazyrmd", "standalone")
  )
})
