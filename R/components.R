
new_cpt <- function(type, contents) {
  structure(
    list(structure(
      list(type = type, contents = contents),
      class = c(paste0("cli_component_", type), "cli_component")
    )),
    class = "cli_component_container"
  )
}

#' @export

format.cli_component <- function(x, ...) {
  paste0("<", class(x)[1], ">")
}

#' @export

print.cli_component <- function(x, ...) {
  writeLines(format(x, ...))
}

cpt__emit <- function(cpt) {
  cli__message(cpt[[1]]$type, cpt[[1]]$contents)
}

#' Create a *text* component
#'
#' @param ... The text to show, in character vectors, or other *text*
#'   components. Adjacent character vectors will be concatenated into a
#'   single string. Newlines are _not_ preserved.
#' @param .envir Environment to evaluate the glue expressions in.
#' @param .call Call to pass down, for better error messages.
#'
#' @family cli components
#' @export

cpt_text <- function(..., .envir = parent.frame(), .call = sys.call()) {

  cpts <- c(...)
  cpts2 <- list()
  is_cpt <- vlapply(cpts, inherits, "cli_component")
  parts <- rle(is_cpt)
  ivs <- rle_ivs(parts)
  for (i in seq_along(parts$values)) {
    if (parts$values[i]) {
      # copy components
      for (j in ivs$from[i]:ivs$to[i]) {
        if (cpts[[j]]$type != "text") {
          throw(cli_error(
            "You can only include other {.val text} components inside `cpt_text()`.",
            "i" = "Found component type: {.val {cpts[[j]]$type}}."
          ))
        }
        cpts2[(length(cpts2) + 1L):(length(cpts2) + length(cpts[[j]]$contents))] <-
                cpts[[j]]$contents
      }
    } else {
      # merge text into a single component
      merged <- glue_cmd(
        cpts[ivs$from[i]:ivs$to[i]],
        .envir = .envir,
        .call = .call
      )
      cpts2[[length(cpts2) + 1L]] <- merged
    }
  }

  new_cpt("text", cpts2)
}

#' Create a *verbatim* component
#'
#' @param ... TOFO
#' @param .envir TODO
#' @param .call TODO
#' @export

cpt_verbatim <- function(..., .envir = parent.frame(), .call = sys.call()) {
  contents <- c(list(...), list(.envir = .envir))
  new_cpt("verbatim", contents)
}
