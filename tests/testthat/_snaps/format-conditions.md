# format_error [plain]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Condition
      Error:
      ! `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      Error:
      ! Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_error [ansi]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_error [unicode]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Condition
      Error:
      ! `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      Error:
      ! Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_error [fancy]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# format_warning [plain]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Condition
      Warning:
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      Warning:
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_warning [ansi]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_warning [unicode]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Condition
      Warning:
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      Warning:
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_warning [fancy]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m`n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# format_message [plain]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_message [ansi]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message
      [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_message [unicode]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_message [fancy]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message
      [1m[22m`n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# color in RStudio [ansi]

    Code
      col <- get_rstudio_fg_color0()
      cat(col("this is the new color"))
    Output
      [30mthis is the new color[39m

# update_rstudio_color [ansi]

    Code
      cat(update_rstudio_color("color me interested"))
    Output
      [32mcolor me interested[39m

# named first element

    Code
      format_error(c(`*` = "foo", `*` = "bar"))
    Output
      [1] "* foo\n* bar"

---

    Code
      format_warning(c(`*` = "foo", `*` = "bar"))
    Output
      [1] "* foo\n* bar"

# cli.condition_width

    Code
      format_error(msg)
    Output
      [1] "1234567890 1234567890 1234567890\n1234567890 1234567890 1234567890\n1234567890 1234567890"
    Code
      format_warning(msg)
    Output
      [1] "1234567890 1234567890 1234567890\n1234567890 1234567890 1234567890\n1234567890 1234567890"
    Code
      format_message(msg)
    Output
      [1] "1234567890 1234567890 1234567890\n1234567890 1234567890 1234567890\n1234567890 1234567890"

---

    Code
      format_error(msg)
    Output
      [1] "1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890"
    Code
      format_warning(msg)
    Output
      [1] "1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890"
    Code
      format_message(msg)
    Output
      [1] "1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890"

# suppressing Unicode bullets [plain]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.",
          v = "Success.", i = "Info.", `*` = "Bullet", `>` = "Arrow")))
      })
    Condition
      Error:
      ! `n` must be a numeric vector
      x You've supplied a <character> vector.
      v Success.
      i Info.
      * Bullet
      > Arrow

# suppressing Unicode bullets [ansi]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.",
          v = "Success.", i = "Info.", `*` = "Bullet", `>` = "Arrow")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.
      [32mv[39m Success.
      [36mi[39m Info.
      [36m*[39m Bullet
      > Arrow

# suppressing Unicode bullets [unicode]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.",
          v = "Success.", i = "Info.", `*` = "Bullet", `>` = "Arrow")))
      })
    Condition
      Error:
      ! `n` must be a numeric vector
      x You've supplied a <character> vector.
      v Success.
      i Info.
      * Bullet
      > Arrow

# suppressing Unicode bullets [fancy]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.",
          v = "Success.", i = "Info.", `*` = "Bullet", `>` = "Arrow")))
      })
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.
      [32mv[39m Success.
      [36mi[39m Info.
      [36m*[39m Bullet
      > Arrow

