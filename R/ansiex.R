
ansi_string <- function(x) {
  if (!is.character(x)) x <- as.character(x)
  class(x) <- unique(c("ansi_string", class(x)))
  x
}

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
#' ## The second one has style if ANSI colors are supported
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
#' @param type Whether to count characters, bytes, or calculate the
#'   display width of the string. Passed to [base::nchar()].
#' @param ... Additional arguments, passed on to [base::nchar()]
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

ansi_nchar <- function(x, type = c("chars", "bytes", "width"), ...) {
  type <- match.arg(type)
  if (type == "width") x <- unicode_pre(x)
  ansi_nchar_bad(x, type = type, ...)
}

ansi_nchar_bad <- function(x, ...) {
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
  if (!length(x)) return(ansi_string(x))
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

  ansi_string(
    paste(sep = "", ansi_bef, base::substr(x, nstart, nstop), ansi_aft)
  )
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
  lapply(res, ansi_string)
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

  if (!length(text)) return(ansi_string(text))

  res <- if (align == "left") {
    paste0(text, make_space(width - nc))

  } else if (align == "center") {
    paste0(make_space(ceiling((width - nc) / 2)),
           text,
           make_space(floor((width - nc) / 2)))

  } else {
    paste0(make_space(width - nc), text)
  }

  ansi_string(res)
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

#' Remove leading and/or trailing whitespace from an ANSI string
#'
#' This function is similar to [base::trimws()] but works on ANSI strings,
#' and keeps color and other styling.
#'
#' @param x ANSI string vector.
#' @param which Whether to remove leading or trailing whitespace or both.
#' @return ANSI string, with the whitespace removed.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' trimws(paste0("   ", col_red("I am red"), "   "))
#' ansi_trimws(paste0("   ", col_red("I am red"), "   "))
#' trimws(col_red("   I am red   "))
#' ansi_trimws(col_red("   I am red   "))

ansi_trimws <- function(x, which = c("both", "left", "right")) {

  if (!is.character(x)) x <- as.character(x)
  which <- match.arg(which)
  if (!length(x)) return(ansi_string(x))

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

  if (any(sl > 0L | rl > 0L)) {
    x <- ansi_substr(x, 1 + sl, ansi_nchar(x) - rl)
  }

  ansi_string(x)
}

#' Wrap an ANSI styled string to a certain width
#'
#' This function is similar to [base::strwrap()], but works on ANSI
#' styled strings, and leaves the styling intact.
#'
#' @param x ANSI string.
#' @param width Width to wrap to.
#' @param indent Indentation of the first line of each paragraph.
#' @param exdent Indentation of the subsequent lines of each paragraph.
#' @param simplify Whether to return all wrapped strings in a single
#'   charcter vector, or wrap each element of `x` independently and return
#'   a list.
#' @return If `simplify` is `FALSE`, then a list of character vectors,
#'   each an ANSI string. Otherwise a single ANSI string vector.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' text <- cli:::lorem_ipsum()
#' # Highlight some words, that start with 's'
#' rexp <- gregexpr("\\b([sS][a-zA-Z]+)\\b", text)
#' regmatches(text, rexp) <- lapply(regmatches(text, rexp), col_red)
#' cat(text)
#'
#' wrp <- ansi_strwrap(text, width = 40)
#' cat(wrp, sep = "\n")

ansi_strwrap <- function(x, width = console_width(), indent = 0,
                         exdent = 0, simplify = TRUE) {

  if (!is.character(x)) x <- as.character(x)
  if (length(x) == 0) {
    return(ansi_string(x))
  }
  if (length(x) > 1) {
    wrp <- lapply(x, ansi_strwrap, width = width, indent = indent,
                  exdent = exdent, simplify = FALSE)
    if (simplify) wrp <- ansi_string(unlist(wrp))
    return(wrp)
  }

  # Workaround for bad Unicode width
  x <- unicode_pre(x)

  # First we need to remove the multiple spaces, to make it easier to
  # map the strings later on. We do this per paragraph, to keep paragraphs.
  pars <- strsplit(x, "\n[ \t\n]*\n", perl = TRUE)
  pars <- lapply(pars, ansi_trimws)

  # Within paragraphs, replace multiple spaces with one, except when there
  # were two spaces at the end of a sentence, where we keep two.
  # This does not work well, when some space is inside an ANSI tag, and
  # some is outside, but for now, we'll live with this limitation.
  pars <- lapply(pars, function(s) {
    gsub("(?<![.!?])[ \t\n][ \t\n]*", " ", s, perl = TRUE)
  })

  # Put them back together
  xx <- vcapply(pars, function(s) paste(s, collapse = "\n\n"))

  xs <- ansi_strip(xx)
  xw0 <- base::strwrap(xs, width = width, indent = indent, exdent = exdent)
  if (xs == xx) return(ansi_string(unicode_post(xw0)))

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
  ansi_string(unicode_post(paste0(indent, wrp)))
}

#' Truncate an ANSI string
#'
#' This function is similar to [base::strtrim()], but works correcntly with
#' ANSI styled strings. It also adds `...` (or the corresponding Unicode
#' character if Unicode characters are allowed) to the end of truncated
#' strings.
#'
#' @param x Character vector of ANSI strings.
#' @param width The width to truncate to.
#' @param ellipsis The string to append to truncated strings. Supply an
#'   empty string if you don't want a marker.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' text <- cli::col_red(cli:::lorem_ipsum())
#' ansi_strtrim(c(text, "foobar"), 40)

ansi_strtrim <- function(x, width = console_width(),
                         ellipsis = symbol$ellipsis) {

  # Unicode width notes. We have nothing to fix here, because we'll just
  # use ansi_substr() and ansi_nchar(), which work correctly with wide
  # characters.

  # First we cut according to _characters_. This might be too wide if we
  # have wide characters.
  xt <- ansi_substr(x, 1, width)
  tw <- ansi_nchar(ellipsis, "width")

  # If there was a cut, or xt is too wise (using _width_!), that's bad
  # We keep the initial bad ones, these are the ones that need an ellipsis.
  # Then we keep chopping off single characters from the too wide ones,
  # until they are narrow enough.
  bad0 <- bad <- xt != x | ansi_nchar(xt, "width") > width
  while (any(bad)) {
    xt[bad] <- ansi_substr(xt[bad], 1, ansi_nchar(xt[bad]) - 1L)
    bad <- ansi_nchar(xt, "width") > width - tw
  }

  xt[bad0] <- paste0(xt[bad0], ellipsis)
  xt
}

#' Format a character vector in multiple columns
#'
#' This function helps with multi-column output of ANSI styles strings.
#' It works well together with [boxx()], see the example below.
#'
#' If a string does not fit into the specified `width`, it will be
#' truncated using [ansi_strtrim()].
#'
#' @param text Character vector to format. Each element will formatted
#'   as a cell of a table.
#' @param width Width of the screen.
#' @param sep Separator between the columns. It may have ANSI styles.
#' @param fill Whether to fill the columns row-wise or column-wise.
#' @param max_cols Maximum number of columns to use. Will not use more,
#'   even if there is space for it.
#' @param align Alignment within the columns.
#' @param type Passed to [ansi_nchar()] and [ansi_align()]. Most probably
#'   you want the default, `"width"`.
#' @inheritParams ansi_strtrim
#' @return ANSI string vector.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' fmt <- ansi_columns(
#'   paste(col_red("foo"), 1:10),
#'   width = 50,
#'   fill = "rows",
#'   max_cols=10,
#'   align = "center",
#'   sep = "   "
#' )
#' fmt
#' ansi_nchar(fmt, type = "width")
#' boxx(fmt, padding = c(0,1,0,1), header = col_green("foobar"))

ansi_columns <- function(text, width = console_width(), sep = " ",
                         fill = c("rows", "cols"), max_cols = 4,
                         align = c("left", "center", "right"),
                         type = "width", ellipsis = symbol$ellipsis) {

  fill <- match.arg(fill)
  align <- match.arg(align)

  if (length(text) == 0) return(ansi_string(text))

  swdh <- ansi_nchar(sep, type = "width")
  twdh <- max(ansi_nchar(text, type = type)) + swdh
  cols <- min(floor(width / twdh), max_cols)
  if (cols == 0) {
    cols <- 1
    text <- ansi_strtrim(text, width = width, ellipsis = ellipsis)
  }

  len <- length(text)
  extra <- ceiling(len / cols) * cols - len
  text <- c(text, rep("", extra))
  tm <- matrix(text, byrow = fill == "rows", ncol = cols)

  colwdh <- diff(c(0, round((width / cols)  * (1:cols))))
  for (c in seq_len(ncol(tm))) {
    tm[, c] <- ansi_align(
      paste0(tm[, c], if (cols > 1) sep),
      colwdh[c],
      align = align,
      type = type
    )
  }

  clp <- apply(tm, 1, paste0, collapse = "")
  ansi_string(clp)
}
