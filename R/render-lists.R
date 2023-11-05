render_li <- function(cpt, width = console_width()) {
  if (inherits(cpt, "cli_component_tree")) {
    style <- cpt[["style"]] %||%
    cpt[["prestyle"]] %||%
    cpt[["component"]][["attr"]][["style"]]
  } else if (inherits(cpt, "cli_component")) {
    style <- cpt[["attr"]][["style"]]
  } else {
    stop("Cannot render object of class ", class(cpt)[1])
  }

  item_lines <- render_block(
    cpt[["children"]],
    width = width,
    style = style
  )

  item_lines
}

list_merker_width_limit <- 10L

format_list_markers <- function(markers, width) {
  long <- ansi_nchar(markers, type = "width") > width
  markers <- ifelse(long, ansi_strtrim(markers, width), markers)
  ansi_align(markers, width = width, align = "right")
}

render_ul <- function(cpt, width = console_width()) {
  if (inherits(cpt, "cli_component_tree")) {
    style <- cpt[["style"]] %||% cpt[["prestyle"]] %||%
    cpt[["component"]][["attr"]][["style"]]
  } else if (inherits(cpt, "cli_component")) {
    style <- cpt[["attr"]][["style"]]
  } else {
    stop("Cannot render object of class ", class(cpt)[1])
  }

  start <- style[["start"]] %||% 1L
  markers <- extract_list_bullets(
    cpt[["children"]],
     start = start,
     type = cpt[["tag"]]
  )
  marker_width <- max(c(0L, ansi_nchar(markers, type = "width")))
  marker_width <- min(c(list_merker_width_limit, marker_width))
  markers <- format_list_markers(markers, marker_width)

  margin_left <- style[["margin-left"]] %||% 0L
  margin_right <- style[["margin-right"]] %||% 0L
  padding_left <- style[["padding-left"]] %||% 0L
  padding_right <- style[["padding-right"]] %||% 0L
  child_width <- width - margin_left - margin_right -
  padding_left - padding_right - marker_width - 1L
  if (child_width <= 0) child_width <- 1L                           # nocov

  children_lines <- lapply(
    cpt[["children"]],
    render_styled,
    width = child_width
  )

  for (idx in seq_along(children_lines)) {
    # Add the marker to the first line, pad the rest of the lines
    nr <- length(children_lines[[idx]])
    if (nr > 0) {
      children_lines[[idx]] <- c(
        paste0(
          markers[[idx]],
          "\u00a0",
          children_lines[[idx]][1]
        ),
        if (nr > 1) {
          paste0(
            strrep("\u00a0", marker_width + 1L),
            children_lines[[idx]][-1]
          )
        }
      )
    } else {
      # If the child is empty, then just have a marker? Makes sense? IDK
      children_lines[[idx]] <- paste0(
        markers[[idx]],
        strrep("\u00a0", child_width + 1L)
      )
    }
  }

  lines <- unlist(children_lines)

  margin_top <- style[["margin-top"]] %||% 0L
  margin_bottom <- style[["margin-bottom"]] %||% 0L
  c(rep("", margin_top), lines, rep("", margin_bottom))
}

extract_list_bullets <- function(cpts, start, type) {
  default_bullet <- if (type == "ul") "*" else "decimal"
  lst <- vcapply(cpts, function(cpt) {
    x <- cpt[["style"]][["list-style-type"]]
    x <- call_if_fun(x)
    if (!is_string(x)) x <- NULL
    x <- x %||% default_bullet
  })

  res <- lst

  # Starts with 'raw:' then it is used as is
  raw <- startsWith(lst, "text:")
  res[raw] <- substr(lst[raw], 6, nchar(lst[raw]))

  # Otherwise interpreted
  lst_names <- c(
    disc = symbol$bullet,
    circle = symbol$cicle,
    none = "",
    square = symbol$square_small_filled
  )
  res[!raw] <- lst_names[lst[!raw]]

  res <- format_numbered_items(res, lst, offset = start - 1L)

  # Otherwise literal
  lit <- is.na(res)
  res[lit] <- lst[lit]

  res
}

format_numbered_items <- function(res, type, offset) {
  if (!anyNA(res)) return(res)

  dcm <- type[is.na(res)] == "decimal"
  if (any(dcm)) {
    res[dcm] <- paste0(seq_along(res) + offset, ".")[dcm]
  }

  dcm0 <- type[is.na(res)] == "decimal-leading-zero"
  if (any(dcm0)) {
    res[dcm0] <- seq_leading_zero(length(res), offset)[dcm0]
  }

  llat <- type[is.na(res)] %in% c("lower-alpha", "lower-latin")
  if (any(llat)) {
    res[llat] <- seq_lower_alpha(length(res), offset)[llat]
  }

  lrom <- type[is.na(res)] == "lower-roman"
  if (any(lrom)) {
    res[lrom] <- seq_lower_roman(length(res), offset)[lrom]
  }

  ulat <- type[is.na(res)] %in% c("upper-alpha", "upper-latin")
  if (any(ulat)) {
    res[ulat] <- seq_upper_alpha(length(res), offset)[ulat]
  }

  urom <- type[is.na(res)] == "upper-roman"
  if (any(urom)) {
    res[urom] <- seq_upper_roman(length(res), offset)[urom]
  }

  res
}

seq_leading_zero <- function(n, offset = 0) {
  if (n + offset <= 9) {
    paste0("0", seq_len(n) + offset, ".")
  } else {
    c(paste0("0", 1:9, "."), paste0(seq_len(n)[-(1:9)] + offset, "."))
  }
}

seq_lower_alpha <- function(n, offset) {
  s <- seq_len(n) + offset
  res <- rep("", length(s))
  while (any(s > 0)) {
    m <- (s - 1L) %% 26L + 1L
    res[s > 0] <- paste0(letters[m], res)[s > 0]
    s <- (s - 1L) %/% 26L
  }
  paste0(res, ".")
}

seq_upper_alpha <- function(n, offset) {
  toupper(seq_lower_alpha(n, offset))
}

seq_lower_roman <- function(n, offset) {
  paste0(tolower(utils::as.roman(seq_len(n) + offset)), ".")
}

seq_upper_roman <- function(n, offset) {
  paste0(utils::as.roman(seq_len(n) + offset), ".")
}
