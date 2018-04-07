
get_term_version <- function(env_var) {
  version <- Sys.getenv(env_var, "")
  version <- as.integer(strsplit(version, ".", fixed = TRUE)[[1]])
  length(version) <- 3
  version[is.na(version)] <- 0
  names(version) <- c("major", "minor", "patch")
  version
}

#' @export

supports_hyperlinks <- function(stream = stderr()) {
  if (fh <- tolower(Sys.getenv("FORCE_HYPERLINK", "")) %in%
        c("true", "yes", "1")) {
    return(TRUE)
  }

  if (fh %in% c("false", "no", "0"))  return(FALSE)

  if (!isatty(stream)) return(FALSE)

  if (.Platform$OS.type == "windows") return(FALSE)

  if (env_set("CI")) return(FALSE)

  if (env_set("TEAMCITY_VERSION")) return(FALSE)

  if (env_set("TERM_PROGRAM")) {
    version <- get_term_version("TERM_PROGRAM_VERSION")
    switch(
      Sys.getenv("TERM_PROGRAM", ""),
      "iTerm.app" = {
        if (version[["major"]] == 3) return(version[["minor"]] >= 1)
        return (version[["major"]] > 3)
      }
    )
  }

  if (env_set("VTE_VERSION")) {
    ## 0.50.0 was supposed to support hyperlinks, but throws a segfault
    if (Sys.getenv("VTE_VERSION") == "0.50.0") return(FALSE)
    version <- get_term_version("VTE_VERSION")
    return(version[["major"]] > 0 || version[["minor"]] >= 50)
  }

  FALSE
}
