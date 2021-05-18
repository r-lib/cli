# cli_abort [plain]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Error <rlang_error>
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Error <rlang_error>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# cli_abort [ansi]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Error <rlang_error>
      [1m[22m[1m[1m[30m[47m[1m[30m[47m`n`[47m[30m[1m[49m[39m must be a numeric vector[1m[22m
      [31mx[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Error <rlang_error>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# cli_abort [unicode]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Error <rlang_error>
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Error <rlang_error>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# cli_abort [fancy]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Error <rlang_error>
      [1m[22m[1m[1m[30m[47m[1m[30m[47m`n`[47m[30m[1m[49m[39m must be a numeric vector[1m[22m
      [31m✖[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Error <rlang_error>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# cli_warn [plain]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Warning <warning>
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Warning <warning>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# cli_warn [ansi]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Warning <warning>
      [1m[22m[1m[1m[30m[47m[1m[30m[47m`n`[47m[30m[1m[49m[39m must be a numeric vector[1m[22m
      [31mx[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Warning <warning>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# cli_warn [unicode]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Warning <warning>
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Warning <warning>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# cli_warn [fancy]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Warning <warning>
      [1m[22m[1m[1m[30m[47m[1m[30m[47m`n`[47m[30m[1m[49m[39m must be a numeric vector[1m[22m
      [31m✖[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Warning <warning>
      [1m[22m[1m[1mMust index an existing element:[1m[22m
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# cli_inform [plain]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message <cliMessage>
      
    Message <message>
      `n` must be a numeric vector
      x You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message <cliMessage>
      
    Message <message>
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

# cli_inform [ansi]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message <cliMessage>
      
    Message <message>
      [1m[22m[30m[47m[30m[47m`n`[47m[30m[49m[39m must be a numeric vector
      [31mx[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message <cliMessage>
      
    Message <message>
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

# cli_inform [unicode]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message <cliMessage>
      
    Message <message>
      `n` must be a numeric vector
      ✖ You've supplied a <character> vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message <cliMessage>
      
    Message <message>
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

# cli_inform [fancy]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message <cliMessage>
      
    Message <message>
      [1m[22m[30m[47m[30m[47m`n`[47m[30m[49m[39m must be a numeric vector
      [31m✖[39m You've supplied a [34m[34m<character>[34m[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message <cliMessage>
      
    Message <message>
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

# cli_abort width in RStudio

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c(lorem_ipsum(1, 3), i = lorem_ipsum(1, 3), x = lorem_ipsum(1, 3)))
      })
    Error <rlang_error>
      Duis quis magna incididunt nulla commodo minim non exercitation nostrud
      ullamco dolor exercitation ut veniam. Fugiat irure tempor commodo voluptate ut.
      In et tempor excepteur quis.
      i Et nisi ad quis ad cupidatat tempor laborum est excepteur aliqua veniam ex.
        Sunt magna veniam Lorem elit enim et pariatur aliqua occaecat mollit
        consequat dolore in mollit. Officia labore reprehenderit culpa dolore quis
        nisi do aliqua commodo deserunt fugiat cupidatat nostrud ad.
      x Ad laboris consectetur esse minim pariatur irure do anim anim. Mollit ad
        cupidatat ullamco ullamco nulla elit in.

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

