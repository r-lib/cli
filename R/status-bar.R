
#' Update the status bar
#'
#' The status bar is the last line of the terminal. cli apps can use this
#' to show status information, progress bars, etc. The status bar is kept
#' intact by all semantic cli output.
#'
#' Use [cli_status_clear()] to clear the status bar.
#'
#' @param ... The text to show, in character vectors. They will be
#'   concatenated into a single string. Long lines are cut to
#'   [console_width()].
#' @param .keep What to do when this status bar is cleared. If `TRUE` then
#'   the content of this status bar is kept, as regular cli output (the
#'   screen is scrolled up if needed). If `FALSE`, then this status bar
#'   is deleted.
#' @param .auto_close Whether to clear the status bar when the calling
#'   function finishes (or ‘.envir’ is removed from the stack, if
#'   specified).
#' @param .envir Environment to evaluate the glue expressions in. It is
#'   also used to auto-clear the status bar if ‘.auto_close’ is ‘TRUE’.
#' @return The id of the new status bar container element, invisibly.
#'
#' @family status bar
#' @export

cli_status <- function(..., .keep = FALSE, .auto_close = TRUE,
                       .envir = parent.frame()) {
  cli__message(
    "status",
    list(id = NULL, glue_cmd(..., .envir = .envir), .keep = .keep),
    .auto_close = .auto_close,
    .envir = .envir
  )
}

#' Clear the status bar
#'
#' @param id Id of the status bar container to clear. If `id` is not the id
#'   of the current status bar (because it was overwritten by another
#'   status bar container), then the status bar is not cleared. If `NULL`
#'   (the default) then the status bar is always cleared. 
#' 
#' @family status bar
#' @export

cli_status_clear <- function(id = NULL) {
  cli__message("status_clear", list(id = id %||% NA_character_))
}

#' Update the status bar
#'
#' @param ... Text to update the status bar with.
#' @param id Id of the status bar to update. Defaults to the current
#' status bar container.
#' @param .envir Environment to evaluate the glue expressions in.
#' @return Id of the status bar container.
#'
#' @family status bar
#' @export

cli_status_update <- function(..., id = NULL, .envir = parent.frame()) {
  cli__message("status_update", list(text = glue_cmd(..., .envir = .envir),
                                     id = id %||% NA_character_))
}

clii_status <- function(app, id, text, class, .keep) {
  bar_app <- cliapp(
    theme = NULL,
    user_theme = NULL,
    output = app$output
  )
  bar_app$themes <- app$themes
  clii__container_start(bar_app, "div", class = "statusbar", id = id)
  app$status_bar[[id]] <- list(
    app = bar_app,
    content = "",
    keep = .keep
  )
  clii_status_update(app, id, text)
}

clii_status_clear <- function(app, id) {
  ## No such status bar?
  if (!id %in% names(app$status_bar)) return(invisible())

  if (names(app$status_bar)[1] == id) {
    ## This is the active one
    if (app$status_bar[[id]]$keep) {
      ## Keep? Just emit it
      app$cat("\n")

    } else {
      ## Not keep? Remove it
      clii__clear_status_bar(app)
    }

  } else {
    if (app$status_bar[[id]]$keep) {
      ## Keep?
      clii__clear_status_bar(app)
      app$cat(paste0(app$status_bar[[id]]$content, "\n"))
      app$cat(paste0(app$status_bar[[1]]$content))

    } else {
      ## Not keep? Nothing to output
    }
  }

  ## Remove
  app$status_bar[[id]] <- NULL

  ## Switch to the previous one
  if (length(app$status_bar)) app$cat(paste0(app$status_bar[[1]]$content))
}

#' @importFrom fansi substr_ctl

clii_status_update <- function(app, id, text) {
  ## If NA then the most recent one
  if (is.na(id)) id <- names(app$status_bar)[1]

  ## If no active status bar, then ignore
  if (is.na(id)) return(invisible())

  ## Otherwise clear line
  if (length(app$status_bar)) clii__clear_status_bar(app)

  ## Format the line
  content <- ""
  withCallingHandlers(
    app$status_bar[[id]]$app$xtext(text),
    message = function(msg) {
      content <<- paste0(content, msg$message)
      invokeRestart("muffleMessage")
    }
  )

  content <- strsplit(content, "\r?\n")[[1]][1]

  ## Update status bar, put it in front
  app$status_bar[[id]]$content <- content
  app$status_bar <- c(
    app$status_bar[id],
    app$status_bar[setdiff(names(app$status_bar), id)])

  ## New content
  app$cat(content)
}

#' @importFrom fansi nchar_ctl

clii__clear_status_bar <- function(app) {

  text <- app$status_bar[[1]]$content
  len <- nchar_ctl(text)
  app$cat(paste0("\r", strrep(" ", len), "\r"))
}
