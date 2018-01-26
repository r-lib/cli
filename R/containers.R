
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

  invisible(id)
}

cli__container_end <- function(self, private, id) {
  ## don't remove first element, "base"
  if (length(private$state) == 1) return(invisible())

  ## defaults to the last container
  id <- id %||% tail(c(NA, names(private$state)), 1)

  ## what to remove?
  wh <- match(id, names(private$state))
  if (is.na(wh)) return(invisible())

  ## bottom margins, we just use the maximum
  bottom <- max(viapply(
    private$state[wh:length(private$state)],
    function(x) as.integer(x$style$bottom %||% 0L)
  ))
  private$vspace(bottom)

  ## update state
  private$state <- head(private$state, wh - 1)

  invisible(self)
}

## Paragraph --------------------------------------------------------

cli_par <- function(self, private, .auto_close, .envir) {
  container <- list(type = "par", style = private$theme[["par"]])
  cli__container_start(self, private, container, .auto_close, .envir)
}

## Lists ------------------------------------------------------------

cli_itemize <- function(self, private, items, .auto_close, .envir) {
  container <- list(type = "itemize", style = private$theme[["itemize"]])
  id <- cli__container_start(self, private, container, .auto_close, .envir)
  if (length(items)) self$end(self$item(items))
  invisible(id)
}

cli_enumerate <- function(self, private, items, .auto_close, .envir) {
  container <- list(
    type = "enumerate",
    style = private$theme[["enumerate"]],
    counter = 0L)
  id <- cli__container_start(self, private, container, .auto_close, .envir)
  if (length(items)) self$end(self$item(items))
  invisible(id)
}

cli_describe <- function(self, private, items, .auto_close, .envir) {
  container <- list(type = "describe", style = private$theme[["describe"]])
  id <- cli__container_start(self, private, container, .auto_close, .envir)
  if (length(items)) self$end(self$item(items))
  invisible(id)
}

cli_item <- function(self, private, items, .auto_close, .envir) {
  num_cont <- length(private$state)

  ## check the last active list container
  types <- vcapply(private$state, "[[", "type")
  lc <- tail_na(which(types %in% c("itemize", "enumerate", "describe")))

  ## if not the last container, close the ones below it
  if (!is.na(lc) && lc != num_cont) {
    close_id <- names(private$state)[lc + 1]
    self$end(close_id)
  }

  ## if none, then create an itemize container
  if (is.na(lc)) {
    cnt_id <- self$itemize(.auto_close = .auto_close, .envir = .envir)
    type <- "itemize"
  } else {
    type <- types[lc]
    cnt_id <- names(private$state)[lc]
  }

  container <- list(type = "item", style = private$theme[["item"]])
  i <- 1
  repeat {
    id <- cli__container_start(self, private, container, .auto_close, .envir)
    if (i > length(items)) break
    private$item_text(type, names(items)[i], items[[i]], cnt_id,
                      .envir = .envir)
    self$end(id)
    i <- i + 1
  }

  invisible(id)
}

cli__item_text <- function(self, private, type, name, text, cnt_id,
                           .envir) {

  head <- if (type == "itemize") {
    "* "
  } else if (type == "enumerate") {
    private$state[[cnt_id]]$counter <- private$state[[cnt_id]]$counter + 1L
    paste0(private$state[[cnt_id]]$counter, ". ")
  } else if (type == "describe") {
    paste0(name, ": ")
  }
  text[1] <- paste0(head, text[1])
  private$xtext(text, indent = -2, .envir = .envir)
}

## Code -------------------------------------------------------------

cli_code <- function(self, private, lines, .auto_close, .envir) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

cli_end <- function(self, private, id) {
  cli__container_end(self, private, id)
}
