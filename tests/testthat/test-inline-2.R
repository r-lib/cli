
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli(
  configs = c("plain", "ansi"),
  "quoting phrases that don't start or end with letter or number", {

    expect_snapshot(local({
      x0 <- "good-name"
      cli_text("The name is {.file {x0}}.")

      x <- "weird-name "
      cli_text("The name is {.file {x}}.")
      cli_text("The name is {.path {x}}.")
      cli_text("The name is {.email {x}}.")
    }))
  }
)

test_that_cli(configs = c("plain", "ansi"), "quoting weird names, still", {
  nb <- function(x) gsub("\u00a0", " ", x, fixed = TRUE)
  expect_snapshot(local({
    cat_line(nb(quote_weird_name("good")))
    cat_line(nb(quote_weird_name("  bad")))
    cat_line(nb(quote_weird_name("bad  ")))
    cat_line(nb(quote_weird_name("  bad  ")))
  }))
})

test_that_cli(configs = c("ansi"), "~/ files are not weird", {
  nb <- function(x) gsub("\u00a0", " ", x, fixed = TRUE)
  expect_snapshot(local({
    cat_line(nb(quote_weird_name("~/good")))
    cat_line(nb(quote_weird_name("~~bad")))
    cat_line(nb(quote_weird_name("bad~  ")))
    cat_line(nb(quote_weird_name(" ~ bad ~ ")))
  }))
})

test_that_cli("custom truncation", {
  expect_snapshot({
    x <- cli_vec(1:100, list("vec-trunc" = 5))
    cli_text("Some numbers: {x}.")
    cli_text("Some numbers: {.val {x}}.")
  })
})

test_that_cli(configs = c("plain", "ansi"), "collapsing class names", {
  expect_snapshot(local({
    cc <- c("one", "two")
    cli_text("this is a class: {.cls myclass}")
    cli_text("multiple classes: {.cls {cc}}")
  }))
})

test_that_cli(configs = c("plain", "ansi"), "transform", {
  expect_snapshot(local({
    cli_text("This is a {.field field} (before)")
    foo <- function(x) toupper(x)
    cli_div(theme = list(span.field = list(transform = foo)))
    cli_text("This is a {.field field} (during)")
    cli_end()
    cli_text("This is a {.field field} (after)")
  }))
})

test_that("cli_format", {
  expect_snapshot(
    cli_format(1:4/7, list(digits = 2))
  )
})

test_that("cli_format() is used for .val", {
  withr::local_options(cli.width = 60)
  withr::local_rng_version("3.3.0")
  set.seed(42)
  expect_snapshot(local({
    cli_div(theme = list(.val = list(digits = 2)))
    cli_text("Some random numbers: {.val {runif(4)}}.")
  }))
})

test_that(".q always double quotes", {
  expect_snapshot(
    cli_text("just a {.q string}, nothing more")
  )
})

test_that(".or", {
  expect_snapshot(
    cli_text("{.or {letters[1:5]}}")
  )
  expect_snapshot(
    cli_text("{.or {letters[1:2]}}")
  )
})

test_that("line breaks", {
  txt <- paste(
    "Cupidatat deserunt culpa enim deserunt minim aliqua tempor fugiat",
    "cupidatat laboris officia esse ex aliqua. Ullamco mollit adipisicing",
    "anim."
  )
  txt2 <- paste0(txt, "\f", txt)
  expect_snapshot(ansi_strwrap(txt2, width = 60))
})

test_that_cli(configs = "ansi", "double ticks", {
  x <- c("a", "`x`", "b")
  cli_div(theme = list(
    .code = list(color = "red"),
    .fun = list(color = "red")
  ))
  expect_snapshot(format_inline("{.code {x}}"))
  expect_snapshot(format_inline("{.fun {x}}"))
})

test_that("do not inherit 'transform' issue #422", {
  expect_snapshot({
    d <- deparse(c("cli", "glue"))
    cli::cli_alert_info("To install, run {.code install.packages({d})}")
  })

  expect_snapshot({
    cli::cli_text("{.code foo({1+1})}")
  })
})

test_that_cli(configs = c("ansi", "plain"), "no inherit color, issue #474", {
  expect_snapshot({
    cli::cli_text("pre {.val x {'foo'} y} post")
  })
})

test_that_cli(configs = c("ansi", "plain"), "\\f at the end, issue #491", {
  expect_snapshot({
    cli_fmt(cli::cli_text("{.val a}{.val b}"))
    cli_fmt(cli::cli_text("\f{.val a}{.val b}"))
    cli_fmt(cli::cli_text("\f\f{.val a}{.val b}"))
    cli_fmt(cli::cli_text("{.val a}\f{.val b}"))
    cli_fmt(cli::cli_text("{.val a}\f\f{.val b}"))
    cli_fmt(cli::cli_text("{.val a}{.val b}\f"))
    cli_fmt(cli::cli_text("{.val a}{.val b}\f\f"))
    cli_fmt(cli::cli_text("\f\f\f{.val a}\f\f\f{.val b}\f\f\f"))
  })
})

test_that("truncate vectors at 20", {
  expect_snapshot(
    cli::cli_text("Some letters: {letters}")
  )
})

test_that_cli(configs = "ansi", "brace expresssion edge cases", {
  foo <- "foo"
  bar <- "bar"
  expect_snapshot({
    cli_text("{.code {foo} and {bar}}")
    cli_text("{.emph {foo} and {bar}}")
    cli_text("{.q {foo} and {bar}}")
  })
})

test_that("various errors", {
  expect_snapshot_error(
    cli_text("xx {.foobar} yy")
  )
  expect_snapshot_error(
    cli_text("xx {.someverylong+expression} yy")
  )
  expect_snapshot(
    error = TRUE,
    cli_text("xx {__cannot-parse-this__} yy"),
    transform = sanitize_srcref,
    variant = if (getRversion() < "4.2.0") "old-r" else "new-r"
  )
  expect_snapshot(
    error = TRUE,
    cli_text("xx {1 + 'a'} yy"),
    transform = function(x) sanitize_call(sanitize_srcref(x))
  )
})

test_that("format_inline and newlines", {
  expect_snapshot({
    format_inline("foo\nbar")
    format_inline("\nfoo\n\nbar\n")
    format_inline("foo\fbar")
    format_inline("\ffoo\f\fbar\f")
  })

  expect_snapshot({
    format_inline("foo\nbar", keep_whitespace = FALSE)
    format_inline("\nfoo\n\nbar\n", keep_whitespace = FALSE)
    format_inline("foo\fbar", keep_whitespace = FALSE)
    format_inline("\ffoo\f\fbar\f", keep_whitespace = FALSE)
  })
})

test_that(".bytes", {
  expect_snapshot({
    format_inline("--- {.bytes 123123123} ---")
    format_inline("--- {.bytes {1:4 * 10000}} ---")
  })
})

test_that(".num", {
  expect_snapshot({
    format_inline("--- {.num 123123123} ---")
    format_inline("--- {.num {1:4 * 10000}} ---")
  })
})
