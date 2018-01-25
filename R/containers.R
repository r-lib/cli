
#' @importFrom uuid UUIDgenerate
#' @importFrom withr defer

cli__container_start <- function(self, private, container, .auto_close,
                                 .envir) {
  id <- UUIDgenerate()
  if (.auto_close && !identical(.envir, globalenv())) {
    defer(
      cli__container_end(self, private, id),
      envir = .envir,
      priority = "first"
    )
  }

  ## Mix the current style with the container's style
  old <- tail(private$state, 1)[[1]]$style
  container$style$left <- (container$style$left %||% 0) + old$left
  container$style$right <- (container$style$right %||% 0) + old$right
  container$style$fmt <- if (is.null(container$style$fmt)) {
    old$fmt
  } else {
    function(x) container$style$fmt(old$fmt(x))
  }

  private$state <- c(
    private$state,
    structure(list(container), names = id)
  )
}

cli__container_end <- function(self, private, id) {
  ## don't remove first element, "base"
  if (length(private$state) == 1) return()

  ## defaults to the last container
  id <- id %||% tail(c(NA, names(private$state)), 1)

  ## what to remove?
  wh <- match(id, names(private$state))
  if (is.na(wh)) return()

  ## bottom margins, we just use the maximum
  bottom <- max(viapply(
    private$state[wh:length(private$state)],
    function(x) as.integer(x$style$bottom %||% 0L)
  ))
  private$vspace(bottom)

  ## update state
  private$state <- head(private$state, wh - 1)
}

## Paragraph --------------------------------------------------------

cli_par <- function(self, private, .auto_close, .envir) {
  container <- list(type = "par", style = private$theme[["par"]])
  cli__container_start(self, private, container, .auto_close, .envir)
}

## Lists ------------------------------------------------------------

cli_itemize <- function(self, private, items, .auto_close, .envir) {
  container <- list(type = "itemize", style = private$theme[["itemize"]])
  cli__container_start(self, private, container, .auto_close, .envir)
}

cli_enumerate <- function(self, private, items, .auto_close, .envir) {
  stop("Lists are not implemented yet")
}

cli_describe <- function(self, private, items, .auto_close, .envir) {
  stop("Lists are not implemented yet")
}

cli_item <- function(self, private, ..., .auto_close, .envir) {
  stop("Lists are not implemented yet")
}

## Code -------------------------------------------------------------

cli_code <- function(self, private, lines, .auto_close, .envir) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

cli_end <- function(self, private, id) {
  cli__container_end(self, private, id)
}
