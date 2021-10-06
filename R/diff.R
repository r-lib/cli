
#' Compare two character vectors elementwise
#'
#' Its printed output is similar to calling `diff -u` at the command
#' line.
#'
#' @param old First character vector.
#' @param new Second character vector.
#' @return A list that is a `cli_diff_chr` object, with a `format()` and a
#' `print()` method. You can also access its members:
#'  * `old` and `new` are the original inputs,
#'  * `lcs` is a data frame of LCS edit that transform `old` into `new`.
#'
#' The `lcs` data frame has the following columns:
#' * `operation`: one of `"match"`, `"delete"` or `"insert"`.
#' * `offset`: offset in `old` for matches and deletions, offset in `new`
#'   for insertions.
#' * `length`: length of the operation, i.e. number of matching, deleted
#'   or inserted elements.
#' * `old_offset`: offset in `old` _after_ the operation.
#' * `new_offset`: offset in `new` _after_ the operation.
#'
#' @family diff functions in cli
#' @seealso The diffobj package for a much more comprehensive set of
#' `diff`-like tools.
#' @export
#' @examples
#' letters2 <- c("P", "R", "E", letters, "P", "O", "S", "T")
#' letters2[11:16] <- c("M", "I", "D", "D", "L", "E")
#' ediff_chr(letters, letters2)

ediff_chr <- function(old, new) {
  stopifnot(
    is.character(old),
    is.character(new)
  )
  lcs <- .Call(clic_diff_chr, old, new)
  op <- c("match", "delete", "insert")[lcs[[1]]]
  lcs <- data.frame(
    stringsAsFactors = FALSE,
    operation = op,
    offset = lcs[[2]],
    length = lcs[[3]],
    old_offset = cumsum(ifelse(op == "insert", 0, lcs[[3]])),
    new_offset = cumsum(ifelse(op == "delete", 0, lcs[[3]]))
  )

  ret <- structure(
    list(old = old, new = new, lcs = lcs),
    class = c("cli_diff_chr", "cli_diff", "list")
  )

  ret
}

#' Compare two character strings, character by character
#'
#' Characters are defined by UTF-8 graphemes.
#'
#' @param old First string, must not be `NA`.
#' @param new Second string, must not be `NA`.
#'
#' @family diff functions in cli
#' @seealso The diffobj package for a much more comprehensive set of
#' `diff`-like tools.
#'
#' @export
#' @examples
#' str1 <- "abcdefghijklmnopqrstuvwxyz"
#' str2 <- "PREabcdefgMIDDLEnopqrstuvwxyzPOST"
#' ediff_str(str1, str2)

ediff_str <- function(old, new) {
  stopifnot(
    is_string(old),
    is_string(new)
  )

  old1 <- utf8_graphemes(old)[[1]]
  new1 <- utf8_graphemes(new)[[1]]

  ret <- ediff_chr(old1, new1)

  class(ret) <- c("cli_diff_str", class(ret))

  ret
}

#' @export

format.cli_diff_chr <- function(x, context = 3L, ...) {
  stopifnot(context == Inf || is_count(context))
  if (length(list(...)) > 0) {
    warning("Extra arguments were ignored in `format.cli_diff_chr()`.")
  }

  nochunks <- context == Inf
  if (nochunks) context <- max(length(x$old), length(x$new))

  chunks <- get_diff_chunks(x$lcs, context = context)
  out <- lapply(
    seq_len(nrow(chunks)),
    format_chunk,
    x = x,
    chunks = chunks,
    context = context
  )

  ret <- as.character(unlist(out))
  if (nochunks && length(ret) > 0) ret <- ret[-1]

  ret
}

get_diff_chunks <- function(lcs, context = 3L) {
  # the number of chunks is the number of non-matching sequences if
  # context == 0, but short matching parts do not separate chunks
  runs <- rle(lcs$operation != "match" | lcs$length <= 2 * context)
  nchunks <- sum(runs$values)

  # special case for a single short chunk
  if (nrow(lcs) == 1 && lcs$operation == "match") nchunks <- 0

  chunks <- data.frame(
    op_begin   = integer(nchunks),    # first op in chunk
    op_length  = integer(nchunks),    # number of operations in chunk
    old_begin  = integer(nchunks),    # first line from `old` in chunk
    old_length = integer(nchunks),    # number of lines from `old` in chunk
    new_begin  = integer(nchunks),    # first line from `new` in chunk
    new_length = integer(nchunks)     # number of lines from `new` in chunk
  )

  if (nchunks == 0) return(chunks)

  # infer some data about the original diff input
  old_off <- c(0, lcs$old_offset)
  new_off <- c(0, lcs$new_offset)
  old_size <- old_off[length(old_off)]
  new_size <- new_off[length(new_off)]
  old_empty <- old_size == 0
  new_empty <- new_size == 0

  # chunk starts at operation number sum(length) before it, plus 1, but
  # at the end we change this to include the context chunks are well
  chunks$op_begin  <- c(0, cumsum(runs$length))[which(runs$values)] + 1
  chunks$op_length <- runs$lengths[runs$values]

  # `old` positions are from `old_off`, but need to fix the boundaries
  chunks$old_begin <- old_off[chunks$op_begin] - context + 1
  chunks$old_begin[chunks$old_begin <= 1] <- if (old_empty) 0 else 1
  old_end <- old_off[chunks$op_begin + chunks$op_length] + context
  old_end[old_end > old_size] <- old_size
  chunks$old_length <- old_end - chunks$old_begin + 1

  # `new` positions are similar
  chunks$new_begin <- new_off[chunks$op_begin] - context + 1
  chunks$new_begin[chunks$new_begin <= 1] <- if (new_empty) 0 else 1
  new_end <- new_off[chunks$op_begin + chunks$op_length] + context
  new_end[new_end > new_size] <- new_size
  chunks$new_length <- new_end - chunks$new_begin + 1

  # change to include context chunks
  if (context > 0) {
    # calculae the end before updating the begin
    op_end <- chunks$op_begin + chunks$op_length - 1 + 1
    op_end[op_end > nrow(lcs)] <- nrow(lcs)
    chunks$op_begin <- chunks$op_begin - 1
    chunks$op_begin[chunks$op_begin == 0] <- 1
    chunks$op_length <- op_end - chunks$op_begin + 1
  }

  chunks
}

format_chunk <- function(x, chunks, num, context) {
  hdr <- paste0(
    "@@ -",
    chunks$old_begin[num],
    if ((l <- chunks$old_length[num]) != 1) paste0(",", l),
    " +",
    chunks$new_begin[num],
    if ((l <- chunks$new_length[num]) != 1) paste0(",", l),
    " @@"
  )

  from <- chunks$op_begin[num]
  to <- chunks$op_begin[num] + chunks$op_length[num] - 1

  lines <- lapply(from:to, function(i) {
    op <- x$lcs$operation[i]
    off <- x$lcs$offset[i]
    len <- x$lcs$length[i]
    if (op == "match") {
      if (len > context) {
        if (i == from) {
          # start later
          off <- off + len - context
          len <- context
        } else {
          # finish earlier
          len <- context
        }
      }
      paste0(" ", x$old[off + 1:len])

    } else if (op == "delete") {
      col_blue(paste0("-", x$old[off + 1:len]))

    } else if (op == "insert") {
      col_green(paste0("+", x$new[off + 1:len]))
    }
  })
  c(hdr, lines)
}

#' @export

print.cli_diff_chr <- function(x, ...) {
  writeLines(format(x, ...))
}

#' @export

format.cli_diff_str <- function(x, ...) {
  if (length(list(...)) > 0) {
    warning("Extra arguments were ignored in `format.cli_diff_chr()`.")
  }

  if (num_ansi_colors() == 1) {
    format_diff_str_nocolor(x, ...)
  } else {
    format_diff_str_color(x, ...)
  }
}

format_diff_str_color <- function(x, ...) {
  out <- lapply(seq_len(nrow(x$lcs)), function(i) {
    op <- x$lcs$operation[i]
    off <- x$lcs$offset[i]
    len <- x$lcs$length[i]
    if (op == "match") {
      paste0(x$old[off + 1:len], collapse = "")

    } else if (op == "delete") {
      bg_blue(col_black(paste0(x$old[off + 1:len], collapse = "")))

    } else if (op == "insert") {
      bg_green(col_black(paste0(x$new[off + 1:len], collapse = "")))
    }
  })

  paste(out, collapse = "")
}

format_diff_str_nocolor <- function(x, ...) {
  out <- lapply(seq_len(nrow(x$lcs)), function(i) {
    op <- x$lcs$operation[i]
    off <- x$lcs$offset[i]
    len <- x$lcs$length[i]
    if (op == "match") {
      paste0(x$old[off + 1:len], collapse = "")

    } else if (op == "delete") {
      paste0(c("{--", x$old[off + 1:len], "--}"), collapse = "")

    } else if (op == "insert") {
      paste0(c("{++", x$new[off + 1:len], "++}"), collapse = "")
    }
  })

  paste(out, collapse = "")
}
