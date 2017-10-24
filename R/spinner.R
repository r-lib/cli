
## This is how the JSON file is created:
## json <- "https://raw.githubusercontent.com/sindresorhus/cli-spinners/dac4fc6571059bb9e9bc204711e9dfe8f72e5c6f/spinners.json"
## parsed <- jsonlite::fromJSON(json, simplifyVector = TRUE)
## pasis <- lapply(parsed, function(x) { x$frames <- I(x$frames); x })
## pdt <- as.data.frame(do.call(rbind, p))
## pdt$name <- rownames(pdt)
## rownames(pdt) <- NULL
## spinners <- pdt[, c("name", "interval", "frames")]
## usethis::use_data(spinners, internal = TRUE)

#' Character vector to put a spinner on the screen
#'
#' `cli` contains many different spinners, you choose one according to your
#' taste.
#'
#' @param which The name of the chosen spinner. The default depends on
#'   whether the platform supports Unicode.
#' @return A list with entries: `name`, `interval`: the suggested update
#'   interval in milliseconds and `frames`: the character vector of the
#'   spinner's frames.
#'
#' @family spinners
#' @export
#' @examples
#' get_spinner()
#' get_spinner("shark")

get_spinner <- function(which = NULL) {
  assert_that(is.null(which) || is_string(which))

  if (is.null(which)) {
    which <- if (fancy_boxes()) "dots" else "line"
  }

  row <- match(which, spinners$name)
  list(
    name = which,
    interval = spinners$interval[[row]],
    frames = spinners$frames[[row]])
}

#' List all available spinners
#'
#' @return Character vector of all available spinner names.
#'
#' @family spinners
#' @export
#' @examples
#' list_spinners()
#' get_spinner(list_spinners()[1])

list_spinners <- function() {
  spinners$name
}

#' Show a demo of some (by default all) spinners
#'
#' Each spinner is shown for about 2-3 seconds.
#'
#' @param which Character vector, which spinners to demo.
#'
#' @family spinners
#' @export
#' @examples
#' \dontrun{
#'   demo_spinners(sample(list_spinners(), 10))
#' }

demo_spinners <- function(which = NULL) {
  assert_that(is.null(which) || is.character(which))

  all <- list_spinners()
  which <- which %||% all

  if (length(bad <- setdiff(which, all))) {
    stop("Unknown spinners: ", paste(bad, collapse = ", "))
  }

  rpad <- function(x, width) {
    w <- nchar(x, type = "width")
    paste0(x, strrep(" ", max(width - w, 0)))
  }

  for (w in which) {
    sp <- get_spinner(w)
    interval <- sp$interval / 1000
    frames <- sp$frames
    cycles <- max(round(2.5 / ((length(frames) - 1) * interval)), 1)
    for (i in 1:(length(frames) * cycles) - 1) {
      fr <- unclass(frames[i %% length(frames) + 1])
      cat("\r", rpad(fr, width = 10), w, sep = "")
      Sys.sleep(interval)
    }
    cat("\n")
  }
}
