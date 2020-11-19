
`%||%` <- function(l, r) if (is.null(l)) r else l

new_class <- function(class_name, ...) {
  structure(as.environment(list(...)), class = class_name)
}

make_space <- function(len) {
  strrep(" ", len)
}

strrep <- function(x, times) {
  x <- as.character(x)
  if (length(x) == 0L) return(x)
  r <- .mapply(
    function(x, times) {
      if (is.na(x) || is.na(times)) return(NA_character_)
      if (times <= 0L) return("")
      paste0(replicate(times, x), collapse = "")
    },
    list(x = x, times = times),
    MoreArgs = list()
  )

  res <- unlist(r, use.names = FALSE)
  Encoding(res) <- Encoding(x)
  res
}

is_latex_output <- function() {
  if (!("knitr" %in% loadedNamespaces())) return(FALSE)
  get("is_latex_output", asNamespace("knitr"))()
}

is_windows <-  function() {
  .Platform$OS.type == "windows"
}

apply_style <- function(text, style, bg = FALSE) {
  if (identical(text, ""))
    return(text)

  if (is.function(style)) {
    style(text)
  } else if (is.character(style)) {
    make_ansi_style(style, bg = bg)(text)
  } else if (is.null(style)) {
    text
  } else {
    stop("Not a colour name or ANSI style function", call. = FALSE)
  }
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}

viapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = integer(1), ..., USE.NAMES = USE.NAMES)
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = logical(1), ..., USE.NAMES = USE.NAMES)
}

ruler <- function(width = console_width()) {
  x <- seq_len(width)
  y <- rep("-", length(x))

  y[x %% 5 == 0] <- "+"
  y[x %% 10 == 0] <- style_bold(as.character((x[x %% 10 == 0] %/% 10) %% 10))

  cat(y, "\n", sep = "")
  cat(x %% 10, "\n", sep = "")
}

rpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(x, strrep(" ", pmax(width - w, 0)))
}

lpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(strrep(" ", pmax(width - w, 0)), x)
}

#' @importFrom utils tail

tail_na <- function(x, n = 1) {
  tail(c(rep(NA, n), x), n)
}

#' @importFrom utils head

dedent <- function(x, n = 2) {
  first_n_char <- strsplit(ansi_substr(x, 1, n), "")[[1]]
  n_space <- cumsum(first_n_char == " ")
  d_n_space <- diff(c(0, n_space))
  first_not_space <- head(c(which(d_n_space == 0), n + 1), 1)
  ansi_substr(x, first_not_space, nchar(x))
}

new_uuid <- (function() {
  cnt <- 0
  function() {
    cnt <<- cnt + 1
    paste0("cli-", clienv$pid, "-", cnt)
  }
})()

na.omit <- function(x) {
  if (is.atomic(x)) x[!is.na(x)] else x
}

last <- function(x) {
  tail(x, 1)[[1]]
}

str_tail <- function(x) {
  substr(x, 2, nchar(x))
}

push <- function(l, el, name = NULL) {
  c(l, structure(list(el), names = name))
}

try_silently <- function(expr) {
  suppressWarnings(tryCatch(expr, error = function(x) x))
}

random_id <- function() {
  paste(sample(c(letters, LETTERS, 0:9), 7, replace = TRUE), collapse = "")
}

str_trim <- function(x) {
  sub("^\\s+", "", sub("\\s+$", "", x))
}

has_asciicast_support <- function() {
 tryCatch({
   asNamespace("asciicast")$is_recording_supported() &&
     asNamespace("asciicast")$is_svg_supported()
 }, error = function(e) FALSE)
}

last_character <- function(x) {
  substr(x, nchar(x), nchar(x))
}

first_character <- function(x) {
  substr(x, 1, 1)
}

is_alnum <- function(x) {
  x %in% c(letters, LETTERS, 0:9, "/")
}

os_type <- function() {
  .Platform$OS.type
}
