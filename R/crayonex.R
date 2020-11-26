
#' Perl comparible regular expression that matches ANSI escape
#' sequences
#'
#' Don't forget to use `perl = TRUE` when using this with [grepl()] and
#' friends.
#'
#' @return String scalar, the regular expression.
#'
#' @family low level ANSI functions
#' @export

ansi_regex <- function() {
  paste0(
    "(?:(?:\\x{001b}\\[)|\\x{009b})",
    "(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])",
    "|\\x{001b}[A-M]",
    # this is for hyperlinks, we must be non-greedy
    "|\\x{001b}\\]8;;.*?\\x{0007}"
  )
}

#' Check if a string has some ANSI styling
#'
#' @param string The string to check. It can also be a character
#'   vector.
#' @return Logical vector, `TRUE` for the strings that have some
#'   ANSI styling.
#'
#' @family low level ANSI functions
#' @export
#' @examples
#' ## The second one has style if crayon is enabled
#' ansi_has_any("foobar")
#' ansi_has_any(col_red("foobar"))

ansi_has_any <- function(string) {
  grepl(ansi_regex(), string, perl = TRUE)
}

#' Remove ANSI escape sequences from a string
#'
#' The input may be of class `ansi_string` class, this is also dropped
#' from the result.
#'
#' @param string The input string.
#' @return The cleaned up string.
#'
#' @family low level ANSI functions
#' @export
#' @examples
#' ansi_strip(col_red("foobar")) == "foobar"

ansi_strip <- function(string) {
  clean <- gsub(ansi_regex(), "", string, perl = TRUE)
  class(clean) <- setdiff(class(clean), "ansi_string")
  clean
}


## Create a mapping between the string and its style-less version.
## This is useful to work with the colored string.

#' @importFrom utils tail

map_to_ansi <- function(x, text = NULL) {

  if (is.null(text)) {
    text <- non_matching(re_table(ansi_regex(), x), x, empty=TRUE)
  }

  map <- lapply(
    text,
    function(text) {
      cbind(
        pos = cumsum(c(1, text[, "length"], Inf)),
        offset = c(text[, "start"] - 1, tail(text[, "end"], 1), NA)
      )
    })

  function(pos) {
    pos <- rep(pos, length.out = length(map))
    mapply(pos, map, FUN = function(pos, table) {
      if (pos < 1) {
        pos
      } else {
        slot <- which(pos < table[, "pos"])[1] - 1
        table[slot, "offset"] + pos - table[slot, "pos"] + 1
      }
    })
  }
}

#' Count number of characters in an ANSI colored string
#'
#' This is a color-aware counterpart of [base::nchar()],
#' which does not do well, since it also counts the ANSI control
#' characters.
#'
#' @param x Character vector, potentially ANSO styled, or a vector to be
#'   coarced to character.
#' @param ... Additional arguments, passed on to `base::nchar()`
#'   after removing ANSI escape sequences.
#' @return Numeric vector, the length of the strings in the character
#'   vector.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' str <- paste(
#'   col_red("red"),
#'   "default",
#'   col_green("green")
#' )
#'
#' cat(str, "\n")
#' nchar(str)
#' ansi_nchar(str)
#' nchar(ansi_strip(str))

ansi_nchar <- function(x, ...) {
  base::nchar(ansi_strip(x), ...)
}


#' Substring(s) of an ANSI colored string
#'
#' This is a color-aware counterpart of [base::substr()].
#' It works exactly like the original, but keeps the colors
#' in the substrings. The ANSI escape sequences are ignored when
#' calculating the positions within the string.
#'
#' @param x Character vector, potentially ANSI styled, or a vector to
#'   coarced to character.
#' @param start Starting index or indices, recycled to match the length
#'   of `x`.
#' @param stop Ending index or indices, recycled to match the length
#'   of `x`.
#' @return Character vector of the same length as `x`, containing
#'   the requested substrings. ANSI styles are retained.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' str <- paste(
#'   col_red("red"),
#'   "default",
#'   col_green("green")
#' )
#'
#' cat(str, "\n")
#' cat(ansi_substr(str, 1, 5), "\n")
#' cat(ansi_substr(str, 1, 15), "\n")
#' cat(ansi_substr(str, 3, 7), "\n")
#'
#' substr(ansi_strip(str), 1, 5)
#' substr(ansi_strip(str), 1, 15)
#' substr(ansi_strip(str), 3, 7)
#'
#' str2 <- paste(
#'   "another",
#'   col_red("multi-", style_underline("style")),
#'   "text"
#' )
#'
#' cat(str2, "\n")
#' cat(ansi_substr(c(str, str2), c(3,5), c(7, 18)), sep = "\n")
#' substr(ansi_strip(c(str, str2)), c(3,5), c(7, 18))

ansi_substr <- function(x, start, stop) {
  if (!is.character(x)) x <- as.character(x)
  if (!length(x)) return(x)
  start <- as.integer(start)
  stop <- as.integer(stop)
  if (!length(start) || !length(stop)) {
    stop("invalid substring arguments")
  }
  if (anyNA(start) || anyNA(stop)) {
    stop("non-numeric substring arguments not supported")
  }
  ansi <- re_table(ansi_regex(), x)
  text <- non_matching(ansi, x, empty=TRUE)
  mapper <- map_to_ansi(x, text = text)
  ansi_substr_internal(x, mapper, start, stop)
}

ansi_substr_internal <- function(x, mapper, start, stop) {
  nstart <- mapper(start)
  nstop  <- mapper(stop)

  bef <- base::substr(x, 1, nstart - 1)
  aft <- base::substr(x, nstop + 1, base::nchar(x))
  ansi_bef <- vapply(regmatches(bef, gregexpr(ansi_regex(), bef)),
                     paste, collapse = "", FUN.VALUE = "")
  ansi_aft <- vapply(regmatches(aft, gregexpr(ansi_regex(), aft)),
                     paste, collapse = "", FUN.VALUE = "")

  paste(sep = "", ansi_bef, base::substr(x, nstart, nstop), ansi_aft)
}

#' Substring(s) of an ANSI colored string
#'
#' This is the color-aware counterpart of [base::substring()].
#' It works exactly like the original, but keeps the colors in the
#' substrings. The ANSI escape sequences are ignored when
#' calculating the positions within the string.
#'
#' @param text Character vector, potentially ANSI styled, or a vector to
#'   coarced to character. It is recycled to the longest of `first`
#'   and `last`.
#' @param first Starting index or indices, recycled to match the length
#'   of `x`.
#' @param last Ending index or indices, recycled to match the length
#'   of `x`.
#' @return Character vector of the same length as `x`, containing
#'   the requested substrings. ANSI styles are retained.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' str <- paste(
#'   col_red("red"),
#'   "default",
#'   col_green("green")
#' )
#'
#' cat(str, "\n")
#' cat(ansi_substring(str, 1, 5), "\n")
#' cat(ansi_substring(str, 1, 15), "\n")
#' cat(ansi_substring(str, 3, 7), "\n")
#'
#' substring(ansi_strip(str), 1, 5)
#' substring(ansi_strip(str), 1, 15)
#' substring(ansi_strip(str), 3, 7)
#'
#' str2 <- paste(
#'   "another",
#'   col_red("multi-", style_underline("style")),
#'   "text"
#' )
#'
#' cat(str2, "\n")
#' cat(ansi_substring(str2, c(3,5), c(7, 18)), sep = "\n")
#' substring(ansi_strip(str2), c(3,5), c(7, 18))

ansi_substring <- function(text, first, last = 1000000L) {
  if (!is.character(text)) text <- as.character(text)
  n <- max(lt <- length(text), length(first), length(last))
  if (lt && lt < n) text <- rep_len(text, length.out = n)
  ansi_substr(text, as.integer(first), as.integer(last))
}


#' Split an ANSI colored string
#'
#' This is the color-aware counterpart of [base::strsplit()].
#' It works almost exactly like the original, but keeps the colors in the
#' substrings.
#'
#' @param x Character vector, potentially ANSI styled, or a vector to
#'   coarced to character.
#' @param split Character vector of length 1 (or object which can be coerced to
#'   such) containing regular expression(s) (unless `fixed = TRUE`) to use
#'   for splitting.  If empty matches occur, in particular if `split` has
#'   zero characters, `x` is split into single characters.
#' @param ... Extra arguments are passed to `base::strsplit()`.
#' @return A list of the same length as `x`, the \eqn{i}-th element of
#'   which contains the vector of splits of `x[i]`. ANSI styles are
#'   retained.
#'
#' @family ANSI string operations
#' @export
#' @importFrom utils head
#' @examples
#' str <- paste0(
#'   col_red("I am red---"),
#'   col_green("and I am green-"),
#'   style_underline("I underlined")
#' )
#'
#' cat(str, "\n")
#'
#' # split at dashes, keep color
#' cat(ansi_strsplit(str, "[-]+")[[1]], sep = "\n")
#' strsplit(ansi_strip(str), "[-]+")
#'
#' # split to characters, keep color
#' cat(ansi_strsplit(str, "")[[1]], "\n", sep = " ")
#' strsplit(ansi_strip(str), "")

ansi_strsplit <- function(x, split, ...) {
  split <- try(as.character(split), silent=TRUE)
  if(inherits(split, "try-error") || !is.character(split) || length(split) > 1L)
    stop("`split` must be character of length <= 1, or must coerce to that")
  if(!length(split)) split <- ""
  plain <- ansi_strip(x)
  splits <- re_table(split, plain, ...)
  chunks <- non_matching(splits, plain, empty = TRUE)
  # silently recycle `split`; doesn't matter currently since we don't support
  # split longer than 1, but might in future
  split.r <- rep(split, length.out=length(x))
  # Drop empty chunks to align with `substr` behavior
  chunks <- lapply(
    seq_along(chunks),
    function(i) {
      y <- chunks[[i]]
      # empty split means drop empty first match
      if(nrow(y) && !nzchar(split.r[[i]]) && !head(y, 1L)[, "length"]) {
        y <- y[-1L, , drop=FALSE]
      }
      # drop empty last matches
      if(nrow(y) && !tail(y, 1L)[, "length"]) y[-nrow(y), , drop=FALSE] else y
    }
  )
  zero.chunks <- !vapply(chunks, nrow, integer(1L))
  # Pull out zero chunks from colored string b/c ansi_substring won't work
  # with them
  res <- vector("list", length(chunks))
  res[zero.chunks] <- list(character(0L))
  res[!zero.chunks] <- mapply(
    chunks[!zero.chunks], x[!zero.chunks], SIMPLIFY = FALSE,
    FUN = function(tab, xx) ansi_substring(xx, tab[, "start"], tab[, "end"])
  )
  res
}

#' Align an ANSI colored string
#'
#' @param text The character vector to align.
#' @param width Width of the field to align in.
#' @param align Whether to align `"left"`, `"center"` or `"right"`.
#' @param type Passed on to [ansi_nchar()] and there to [nchar()]
#' @return The aligned character vector.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' ansi_align(col_red("foobar"), 20, "left")
#' ansi_align(col_red("foobar"), 20, "center")
#' ansi_align(col_red("foobar"), 20, "right")

ansi_align <- function(text, width = console_width(),
                      align = c("left", "center", "right"),
                      type = "width") {

  align <- match.arg(align)
  nc <- ansi_nchar(text, type = type)

  if (!length(text)) return(text)

  if (align == "left") {
    paste0(text, make_space(width - nc))

  } else if (align == "center") {
    paste0(make_space(ceiling((width - nc) / 2)),
           text,
           make_space(floor((width - nc) / 2)))

  } else {
    paste0(make_space(width - nc), text)
  }
}

make_space <- function(num, filling = " ") {
  num <- pmax(0, num)
  res <- strrep(filling, num)
  Encoding(res) <- Encoding(filling)
  res
}

strrep <- function (x, times) {
  x = as.character(x)
  if (length(x) == 0L) return(x)

  mapply(
    function(x, times) {
      if (is.na(x) || is.na(times)) {
        NA_character_
      } else if (times <= 0L) {
        ""
      } else {
        paste0(rep(x, times), collapse = "")
      }
    },
    x, times,
    USE.NAMES = FALSE
  )
}

#' @export

ansi_trim_ws <- function(x, which = c("both", "left", "right")) {

  if (!is.character(x)) x <- as.character(x)
  which <- match.arg(which)
  if (!length(x)) return(x)

  sl <- 0L
  if (which %in% c("both", "left")) {
    xs <- ansi_strip(x)
    xl <- trimws(xs, "left")
    nxs <- nchar(xs)
    sl <- nxs - nchar(xl)
  }

  rl <- 0L
  if (which %in% c("both", "right")) {
    xs <- ansi_strip(x)
    xr <- trimws(xs, "right")
    nxs <- nchar(xs)
    rl <- nxs - nchar(xr)
  }

  if (any(sl > 0L) || rl > 0L) {
    x <- ansi_substr(x, 1 + sl, ansi_nchar(x) - rl)
  }

  x
}

#' @export

ansi_strwrap <- function(x, width = console_width(), indent = 0,
                         exdent = 0, simplify = TRUE) {

  if (!is.character(x)) x <- as.character(x)
  if (length(x) == 0) return(x)
  if (length(x) > 1) {
    wrp <- lapply(x, ansi_strwrap, width = width, indent = indent,
                  exdent = exdent, simplify = FALSE)
    if (simplify) wrp <- unlist(wrp)
    return(wrp)
  }

  # First we need to remove the multiple spaces, to make it easier to
  # map the strings later on. We do this per paragraph, to keep paragraphs.
  pars <- strsplit(x, "\n[ \t\n]*\n", perl = TRUE)
  pars <- lapply(pars, ansi_trim_ws)

  # Within paragraphs, replace multiple spaces with one, except when there
  # were two spaces at the end of a sentence, where we keep two.
  pars <- lapply(pars, function(s) {
    gsub("(?<![.!?])[ \t\n][ \t\n]*", " ", s, perl = TRUE)
  })

  # Put them back together
  xx <- vcapply(pars, function(s) paste(s, collapse = "\n\n"))

  xs <- ansi_strip(xx)
  xw0 <- base::strwrap(xs, width = width, indent = indent, exdent = exdent)
  if (xs == xx) return(xw0)

  xw <- trimws(xw0, "left")
  indent <- nchar(xw0) - nchar(xw)

  # Now map the positions from xw back to xs by going over both in parallel
  splits <- 1L
  drop <- integer()
  xslen <- nchar(xs)
  xsidx <- 1L
  xwlen <- nchar(xw[1])
  xwidx <- c(1L, 1L)

  while (xsidx <= xslen) {
    xsc <- substr(xs, xsidx, xsidx)
    xwc <- substr(xw[xwidx[1]], xwidx[2], xwidx[2])
    if (xsc == xwc) {
      xsidx <- xsidx + 1L
      xwidx[2] <- xwidx[2] + 1L
    } else if (xsc %in% c(" ", "\n", "\t")) {
      drop <- c(drop, xsidx)
      xsidx <- xsidx + 1L
    } else if (xwc == " ") {
      xwidx[2] <- xwidx[2] + 1L
    } else {
      stop("Internal error")
    }

    while (xsidx <= xslen && xwidx[1] <= length(xw) && xwidx[2] > xwlen) {
      splits <- c(splits, xsidx)
      xwidx[1] <- xwidx[1] + 1L
      xwidx[2] <- 1L
      xwlen <- nchar(xw[xwidx[1]])
    }
  }
  splits <- c(splits, xsidx)

  ansi <- re_table(ansi_regex(), xx)
  text <- non_matching(ansi, xx, empty=TRUE)
  mapper <- map_to_ansi(xx, text = text)

  wrp <- vcapply(seq_along(splits[-1]), function(i) {
    from <- splits[i]
    to <- splits[i + 1L] - 1L
    while (from %in% drop) from <- from + 1L
    ansi_substr_internal(xx, mapper, from, to)
  })

  indent <- strrep(" ", indent)
  paste0(indent, wrp)
}
