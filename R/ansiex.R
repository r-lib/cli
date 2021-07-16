
ansi_string <- function(x) {
  if (!is.character(x)) x <- as.character(x)
  class(x) <- unique(c("ansi_string", class(x), "character"))
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
#' @param sgr Whether to look for SGR (styling) control sequences.
#' @param csi Whether to look for non-SGR control sequences.
#' @return Logical vector, `TRUE` for the strings that have some
#'   ANSI styling.
#'
#' @family low level ANSI functions
#' @export
#' @examples
#' ## The second one has style if ANSI colors are supported
#' ansi_has_any("foobar")
#' ansi_has_any(col_red("foobar"))

ansi_has_any <- function(string, sgr = TRUE, csi = TRUE) {
  if (!is.character(string)) string <- as.character(string)
  stopifnot(
    is_flag(sgr),
    is_flag(csi)
  )
  .Call(clic_ansi_has_any, string, sgr, csi)
}

#' Remove ANSI escape sequences from a string
#'
#' The input may be of class `ansi_string` class, this is also dropped
#' from the result.
#'
#' @param string The input string.
#' @param sgr Whether to remove for SGR (styling) control sequences.
#' @param csi Whether to remove for non-SGR control sequences.
#' @return The cleaned up string. Note that `ansi_strip()` always drops
#' the `ansi_string` class, wven if `sgr` and sci` are `FALSE`.
#'
#' @family low level ANSI functions
#' @export
#' @examples
#' ansi_strip(col_red("foobar")) == "foobar"

ansi_strip <- function(string, sgr = TRUE, csi = TRUE) {
  if (!is.character(string)) string <- as.character(string)
  stopifnot(
    is_flag(sgr),
    is_flag(csi)
  )
  clean <- .Call(clic_ansi_strip, string, sgr, csi)
  class(clean) <- setdiff(class(clean), "ansi_string")
  clean
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

ansi_nchar <- function(x, type = c("chars", "bytes", "width")) {
  type <- match.arg(type)
  x <- ansi_strip(x)
  if (type == "width") {
    utf8_display_width(x)
  } else {
    base::nchar(x, allowNA = FALSE, keepNA = TRUE)
  }
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
  start <- rep_len(start, length(x))
  stop <- rep_len(stop, length(x))
  .Call(clic_ansi_substr, x, start, stop)
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
  first <- rep_len(as.integer(first), n)
  last <- rep_len(as.integer(last), n)
  .Call(clic_ansi_substr, text, first, last)
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
      if(nrow(y) && !nzchar(split.r[[i]]) && !utils::head(y, 1L)[, "length"]) {
        y <- y[-1L, , drop=FALSE]
      }
      # drop empty last matches
      if(nrow(y) && !utils::tail(y, 1L)[, "length"]) y[-nrow(y), , drop=FALSE] else y
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
    x <- .Call(clic_ansi_substr, x, 1L + sl, ansi_nchar(x) - rl)
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

  # Form feeds are forced line breaks
  x <- gsub("\f", "\n\n\f\n\n", x, fixed = TRUE, useBytes = TRUE)
  fix_ff <- function(x) {
    rem <- which(x == "\f")
    if (length(rem)) {
      x[-c(rem - 1, rem, rem + 1)]
    } else {
      x
    }
  }

  # First we need to remove the multiple spaces, to make it easier to
  # map the strings later on. We do this per paragraph, to keep paragraphs.
  pars <- strsplit(x, "\n[ \t\n]*\n", perl = TRUE)
  pars <- lapply(pars, ansi_trimws)

  # Within paragraphs, replace multiple spaces with one, except when there
  # were two spaces at the end of a sentence, where we keep two.
  # This does not work well, when some space is inside an ANSI tag, and
  # some is outside, but for now, we'll live with this limitation.
  pars <- lapply(pars, function(s) {
    # First replace multiple spaces that are not at the end of a sentence
    s <- gsub("(?<![.!?])[ \t\n][ \t\n]*", " ", s, perl = TRUE)
    # Handle multiple spaces at the end of a sentence
    s <- gsub("(?<=[.!?])[ \t\n][ \t\n][ \t\n]*", "  ", s, perl = TRUE)
    # Handle simple space at the end of a sentence
    gsub("(?<=[.!?])[ \t\n]", " ", s, perl = TRUE)
  })

  # Put them back together
  xx <- vcapply(pars, function(s) paste(s, collapse = "\n\n"))

  xs <- ansi_strip(xx)
  xw0 <- base::strwrap(xs, width = width, indent = indent, exdent = exdent)
  if (xs == xx) return(ansi_string(unicode_post(fix_ff(xw0))))

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

  wrp <- vcapply(seq_along(splits[-1]), function(i) {
    from <- splits[i]
    to <- splits[i + 1L] - 1L
    while (from %in% drop) from <- from + 1L
    .Call(clic_ansi_substr, xx, from, to)
  })

  indent <- strrep(" ", indent)
  ansi_string(unicode_post(fix_ff(paste0(indent, wrp))))
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
  xt <- .Call(clic_ansi_substr, x, 1L, as.integer(width))
  tw <- ansi_nchar(ellipsis, "width")

  # If there was a cut, or xt is too wise (using _width_!), that's bad
  # We keep the initial bad ones, these are the ones that need an ellipsis.
  # Then we keep chopping off single characters from the too wide ones,
  # until they are narrow enough.
  bad0 <- bad <- xt != x | ansi_nchar(xt, "width") > width
  while (any(bad)) {
    xt[bad] <- .Call(clic_ansi_substr, xt[bad], 1L, ansi_nchar(xt[bad]) - 1L)
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

#' ANSI character translation and case folding
#'
#' There functions are similar to [toupper()], [tolower()] and
#' [chartr()], but they keep the ANSI colors of the string.
#'
#' @inheritParams base::chartr
#' @param x Input string. May have ANSI colors and styles.
#' @return Character vector of the same length as `x`, containing
#'   the translated strings. ANSI styles are retained.
#'
#' @family ANSI string operations
#' @export
#' @examples
#' ansi_toupper(col_red("Uppercase"))
#'
#' ansi_tolower(col_red("LowerCase"))
#'
#' x <- paste0(col_green("MiXeD"), col_red(" cAsE 123"))
#' ansi_chartr("iXs", "why", x)

ansi_toupper <- function(x) {
  ansi_convert(x, toupper)
}

#' @family ANSI string operations
#' @export
#' @rdname ansi_toupper

ansi_tolower <- function(x) {
  ansi_convert(x, tolower)
}

#' @family ANSI string operations
#' @export
#' @rdname ansi_toupper

ansi_chartr <- function(old, new, x) {
  ansi_convert(x, chartr, old, new)
}

ansi_convert <- function(x, converter, ...) {
  ansi <- re_table(ansi_regex(), x)
  text <- non_matching(ansi, x, empty=TRUE)
  out <- mapply(x, text, USE.NAMES = FALSE, FUN = function(x1, t1) {
    t1 <- t1[t1[,1] <= t1[,2], , drop = FALSE]
    for (i in seq_len(nrow(t1))) {
      substring(x1, t1[i, 1], t1[i, 2]) <-
        converter(x = substring(x1, t1[i, 1], t1[i, 2]), ...)
    }
    x1
  })

  ansi_string(out)
}

#' Simplify ANSI styling tags
#'
#' It creates an equivalent, but possibly shorter ANSI styled string, by
#' removing duplicate and empty tags.
#'
#' @param x Input string
#' @param csi What to do with non-SGR ANSI sequences, either `"keep"`,
#'   or `"drop"` them.
#' @return Simplified `ansi_string` vector.
#'
#' @export

ansi_simplify <- function(x, csi = c("keep", "drop")) {
  if (!is.character(x)) x <- as.character(x)
  csi <- match.arg(csi)
  .Call(clic_ansi_simplify, x, csi == "keep")
}

#' Convert ANSI styled text to HTML
#'
#' @param x Input character vector.
#' @param escape_reserved Whether to escape characters that are reserved
#'   in HTML (`&`, `<` and `>`).
#' @param csi What to do with non-SGR ANSI sequences, either `"keep"`,
#'   or `"drop"` them.
#' @return Character vector of HTML.
#'
#' @family ANSI to HTML conversion
#' @export
#' @examplesIf cli:::has_packages(c("prettycode", "htmltools", "withr"))
#' ## Syntax highlight the source code of an R function with ANSI tags,
#' ## and export it to a HTML file.
#' code <- withr::with_options(
#'   list(ansi.num_colors = 256),
#'   prettycode::highlight(format(ansi_html))
#' )
#' hcode <- paste(ansi_html(code), collapse = "\n")
#' css <- paste(format(ansi_html_style()), collapse=  "\n")
#' page <- htmltools::tagList(
#'   htmltools::tags$head(htmltools::tags$style(css)),
#'   htmltools::tags$pre(htmltools::HTML(hcode))
#' )
#'
#' if (interactive()) htmltools::html_print(page)

ansi_html <- function(x, escape_reserved = TRUE, csi = c("drop", "keep")) {
  if (!is.character(x)) x <- as.character(x)
  csi <- match.arg(csi)
  if (escape_reserved) {
    x <- gsub("&", "&amp;", x, fixed = TRUE, useBytes = TRUE)
    x <- gsub("<", "&lt;",  x, fixed = TRUE, useBytes = TRUE)
    x <- gsub(">", "&gt;",  x, fixed = TRUE, useBytes = TRUE)
  }
  .Call(clic_ansi_html, x, csi == "keep")
}

ansi_themes <- rbind(
  read.table(
    "tools/ansi-themes.txt",
    comment = ";",
    stringsAsFactors = FALSE
  ),
  read.table(
    "tools/ansi-iterm-themes.txt",
    comment = ";",
    stringsAsFactors = FALSE
  )
)

#' CSS styles for the output of `ansi_html()`
#'
#'
#'
#' @param colors Whether or not to include colors. `FALSE` will not include
#'   colors, `TRUE` or `8` will include eight colors (plus their bright
#'   variants), `256` will include 256 colors.
#' @param theme Character scalar, theme to use for the first eight colors
#'   plus their bright variants. Terminals define these colors differently,
#'   and cli includes a couple of examples. Sources of themes:
#'   * https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
#'   * iTerm2 builtin themes
#'   * https://github.com/sindresorhus/iterm2-snazzy
#' @return Named list of CSS declaration blocks, where the names are
#'   CSS selectors. It has a `format()` and `print()` methods, which you
#'   can use to write the output to a CSS or HTML file.
#'
#' @family ANSI to HTML conversion
#' @export
#' @examples
#' ansi_html_style(colors = FALSE)
#' ansi_html_style(colors = 8, theme = "iterm-snazzy")

ansi_html_style <- function(colors = TRUE, theme = NULL) {
  if (is.character(theme)) {
    theme <- match.arg(theme)
    theme <- as.list(ansi_themes[theme, ])
  }

  stopifnot(
    isTRUE(colors) || identical(colors, FALSE) ||
      (is_count(colors) && colors %in% c(8,256)),
    is_string(theme) || is.list(theme) && length(theme) == 16
  )

  ret <- list(
    ".ansi-bold"       = "{ font-weight: bold;             }",
    # .ansi-faint ???
    ".ansi-italic"     = "{ font-style: italic;            }",
    ".ansi-underline"  = "{ text-decoration: underline;    }",
    ".ansi-blink"      = "{ text-decoration: blink;        }",
    # .ansi-inverse ???
    ".ansi-hide"       = "{ visibility: hidden;            }",
    ".ansi-crossedout" = "{ text-decoration: line-through; }"
  )

  if (!identical(colors, FALSE)) {
    fg <- structure(
      names = paste0(".ansi-color-", 0:15),
      paste0("{ color: ", theme, " }")
    )
    bg <- structure(
      names = paste0(".ansi-bg-color-", 0:15),
      paste0("{ background-color: ", theme, " }")
    )
    ret <- c(ret, fg, bg)
  }

  if (isTRUE(colors) || colors == 256) {
    grid <- expand.grid(r = 0:5, g = 0:5, b = 0:5)
    num <- 16 + 36 * grid$r + 6 * grid$g + grid$b
    cols <- grDevices::rgb(grid$r, grid$g, grid$b, maxColorValue = 5)
    fg256 <- structure(
      names = paste0(".ansi-color-", num),
      paste0("{ color: ", tolower(cols), " }")
    )
    bg256 <- structure(
      names = paste0(".ansi-bg-color-", num),
      paste0("{ background-color: ", tolower(cols), " }")
    )
    gr <- seq(1, 24)
    grcols <- grDevices::rgb(gr, gr, gr, maxColorValue = 25)
    fggrey <- structure(
      names = paste0(".ansi-color-", 232:255),
      paste0("{ color: ", tolower(grcols), " }")
    )
    bggrey <- structure(
      names = paste0(".ansi-bg-color-", 232:255),
      paste0("{ background-color: ", tolower(grcols), " }")
    )
    ret <- c(ret, fg256, fggrey, bg256, bggrey)
  }

  class(ret) <- "cli_ansi_html_style"
  ret
}

# This avoids duplication, but messes up the source ref of the function...
formals(ansi_html_style)$theme <- c("vscode", setdiff(rownames(ansi_themes), "vscode"))
attr(body(ansi_html_style), "srcref") <- NULL
attr(body(ansi_html_style), "wholeSrcref") <- NULL
attr(body(ansi_html_style), "srcfile") <- NULL

#' @export

format.cli_ansi_html_style <- function(x, ...) {
  paste0(format(names(x)), " ", x)
}

#' @export

print.cli_ansi_html_style <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}
