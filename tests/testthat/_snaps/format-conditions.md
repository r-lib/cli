# format_error [plain]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Error <simpleError>
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Error <simpleError>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_error [ansi]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Error <simpleError>
      [1m[22m[1m[1m[1m[1m[30m[47m`n`[1m[1m[39m[49m must be a numeric vector[1m[22m
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Error <simpleError>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_error [unicode]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Error <simpleError>
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Error <simpleError>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_error [fancy]

    Code
      local({
        n <- "boo"
        stop(format_error(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
      })
    Error <simpleError>
      [1m[22m[1m[1m[1m[1m[30m[47m`n`[1m[1m[39m[49m must be a numeric vector[1m[22m
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Error <simpleError>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# format_warning [plain]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Warning <simpleWarning>
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
    Warning <simpleWarning>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_warning [ansi]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Warning <simpleWarning>
      [1m[22m[1m[1m[1m[1m[30m[47m`n`[1m[1m[39m[49m must be a numeric vector[1m[22m
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Warning <simpleWarning>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_warning [unicode]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Warning <simpleWarning>
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
    Warning <simpleWarning>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_warning [fancy]

    Code
      n <- "boo"
      warning(format_warning(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Warning <simpleWarning>
      [1m[22m[1m[1m[1m[1m[30m[47m`n`[1m[1m[39m[49m must be a numeric vector[1m[22m
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        warning(format_warning(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Warning <simpleWarning>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# format_message [plain]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message <simpleMessage>
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
    Message <simpleMessage>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# format_message [ansi]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message <simpleMessage>
      [1m[22m[30m[47m`n`[39m[49m must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message <simpleMessage>
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# format_message [unicode]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message <simpleMessage>
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
    Message <simpleMessage>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# format_message [fancy]

    Code
      n <- "boo"
      message(format_message(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector.")))
    Message <simpleMessage>
      [1m[22m[30m[47m`n`[39m[49m must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        message(format_message(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}.")))
      })
    Message <simpleMessage>
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# format_error width in RStudio

    Code
      local({
        len <- 26
        idx <- 100
        stop(format_error(c(lorem_ipsum(1, 3), i = lorem_ipsum(1, 3), x = lorem_ipsum(
          1, 3))))
      })
    Error <simpleError>
      Duis quis magna incididunt nulla commodo minim non
      exercitation nostrud ullamco dolor exercitation ut veniam.
      Fugiat irure tempor commodo voluptate ut. In et tempor excepteur
      quis.
      i Et nisi ad quis ad cupidatat tempor laborum est excepteur aliqua
        veniam ex. Sunt magna veniam Lorem elit enim et pariatur
        aliqua occaecat mollit consequat dolore in mollit. Officia
        labore reprehenderit culpa dolore quis nisi do aliqua commodo
        deserunt fugiat cupidatat nostrud ad.
      x Ad laboris consectetur esse minim pariatur irure do anim anim.
        Mollit ad cupidatat ullamco ullamco nulla elit in.

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

