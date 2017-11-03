
## This is how the RDS file is created:

'
json <- "https://raw.githubusercontent.com/sindresorhus/cli-spinners/dac4fc6571059bb9e9bc204711e9dfe8f72e5c6f/spinners.json"
parsed <- jsonlite::fromJSON(json, simplifyVector = TRUE)
pasis <- lapply(parsed, function(x) { x$frames <- I(x$frames); x })
pdt <- as.data.frame(do.call(rbind, pasis))
pdt$name <- rownames(pdt)
rownames(pdt) <- NULL
spinners <- pdt[, c("name", "interval", "frames")]
usethis::use_data(spinners, internal = TRUE)
'

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

## nocov start

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

demo_spinners_terminal <- function() {
  up <- function(n) cat(paste0("\u001B[", n, "A"))
  show <- function() cat("\u001b[?25h")
  hide <- function() cat("\u001b[?25l")

  on.exit(show(), add = TRUE)

  names <- unlist(spinners$name)
  frames <- spinners$frames
  intervals <- unlist(spinners$interval)
  num_frames <- viapply(frames, length)
  spin_width <- viapply(frames, function(x) max(nchar(x, type = "width")))
  name_width <- nchar(names, type = "width")
  col_width <- spin_width + max(name_width) + 3
  col1_width <- max(col_width[1:(length(col_width)/2)])

  frames <- mapply(
    frames,
    names,
    FUN = function(f, n) {
      rpad(paste(lpad(n, max(name_width) + 2), f), col1_width)
    }
  )

  hide()

  for (tick in 0:1000000) {
    tic <- Sys.time()
    wframe <- trunc(tick / intervals) %% num_frames + 1
    sp <- mapply(frames, wframe, FUN = "[")

    sp2 <- paste(
      sep = "  ",
      sp[1:(length(sp) / 2)],
      sp[(length(sp) / 2 + 1):length(sp)]
    )

    cat(sp2, sep = "\n")
    up(length(sp2))
    took <- Sys.time() - tic
    togo <- as.difftime(1/1000, units = "secs") - took
    if (togo > 0) Sys.sleep(togo)
  }

}

## nocov end
