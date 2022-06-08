# cli_abort [plain]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
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
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      Error:
      ! Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

---

    Code
      c(err$message, err$body)
    Output
                                                                                    x 
               "`n` must be a numeric vector" "You've supplied a <character> vector." 

# cli_abort [ansi]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m Must index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

---

    Code
      c(err$message, err$body)
    Output
                                                              
                               "`n` must be a numeric vector" 
                                                            x 
      "You've supplied a \033[34m<character>\033[39m vector." 

# cli_abort [unicode]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
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
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      Error:
      ! Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

---

    Code
      c(err$message, err$body)
    Output
                                                                                    x 
               "`n` must be a numeric vector" "You've supplied a <character> vector." 

# cli_abort [fancy]

    Code
      local({
        n <- "boo"
        cli_abort(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m Must index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

---

    Code
      c(err$message, err$body)
    Output
                                                              
                               "`n` must be a numeric vector" 
                                                            x 
      "You've supplied a \033[34m<character>\033[39m vector." 

# cli_warn [plain]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Condition
      Warning:
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
    Condition
      Warning:
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

---

    Code
      wrn$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_warn [ansi]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

---

    Code
      wrn$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_warn [unicode]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Condition
      Warning:
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
    Condition
      Warning:
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

---

    Code
      wrn$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_warn [fancy]

    Code
      n <- "boo"
      cli_warn(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22m`n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_warn(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Condition
      [1m[33mWarning[39m:[22m
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

---

    Code
      wrn$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_inform [plain]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message
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
    Message
      Must index an existing element:
      i There are 26 elements.
      x You've tried to subset element 100.

---

    Code
      tail(inf, 1)[[1]]$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_inform [ansi]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message
      [1m[22m`n` must be a numeric vector
      [31mx[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message
      [1m[22mMust index an existing element:
      [36mi[39m There are 26 elements.
      [31mx[39m You've tried to subset element 100.

---

    Code
      tail(inf, 1)[[1]]$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_inform [unicode]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message
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
    Message
      Must index an existing element:
      ℹ There are 26 elements.
      ✖ You've tried to subset element 100.

---

    Code
      tail(inf, 1)[[1]]$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_inform [fancy]

    Code
      n <- "boo"
      cli_inform(c("{.var n} must be a numeric vector", x = "You've supplied a {.cls {class(n)}} vector."))
    Message
      [1m[22m`n` must be a numeric vector
      [31m✖[39m You've supplied a [34m<character>[39m vector.

---

    Code
      local({
        len <- 26
        idx <- 100
        cli_inform(c("Must index an existing element:", i = "There {?is/are} {len} element{?s}.",
          x = "You've tried to subset element {idx}."))
      })
    Message
      [1m[22mMust index an existing element:
      [36mℹ[39m There are 26 elements.
      [31m✖[39m You've tried to subset element 100.

---

    Code
      tail(inf, 1)[[1]]$cli_bullets
    Output
                                                                                i 
          "Must index an existing element:"              "There are 26 elements." 
                                          x 
      "You've tried to subset element 100." 

# cli_abort width in RStudio

    Code
      local({
        len <- 26
        idx <- 100
        cli_abort(c(lorem_ipsum(1, 3), i = lorem_ipsum(1, 3), x = lorem_ipsum(1, 3)))
      })
    Condition
      Error:
      ! Duis quis magna incididunt nulla commodo minim non exercitation
        nostrud ullamco dolor exercitation ut veniam. Fugiat irure tempor commodo
        voluptate ut. In et tempor excepteur quis.
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

# cli_abort() captures correct call and backtrace

    Code
      print(expect_error(f()))
    Output
      <error/rlang_error>
      Error in `h()`:
      ! foo
      ---
      Backtrace:
        1. base::print(expect_error(f()))
        8. cli (local) f()
        9. cli (local) g()
       10. cli (local) h()

---

    Code
      print(expect_error(f(list())))
    Output
      <error/cli_my_class>
      Error in `h()`:
      ! `x` can't be empty.
      ---
      Backtrace:
        1. base::print(expect_error(f(list())))
        8. cli (local) f(list())
        9. cli (local) g(x)
       10. cli (local) h(x)

