
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli(configs = c("plain", "unicode"), "ul", {
  expect_snapshot(local({
    lid <- cli_ul()
    cli_li("foo")
    cli_li(c("bar", "foobar"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ol", {
  expect_snapshot(local({
    cli_div(theme = list(ol = list()))
    lid <- cli_ol()
    cli_li("foo")
    cli_li(c("bar", "foobar"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ul ul", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        "ul ul" = list("list-style-type" = "-", "margin-left" = 2)
      )
    )
    lid <- cli_ul()
    cli_li("1")
    lid2 <- cli_ul()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ul ol", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_ul()
    cli_li("1")
    lid2 <- cli_ol()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ol ol", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        "li" = list("margin-left" = 2),
        "li li" = list("margin-left" = 2)
      )
    )
    lid <- cli_ol()
    cli_li("1")
    lid2 <- cli_ol()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ol ul", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        ul = list("margin-left" = 2)
      )
    )
    lid <- cli_ol()
    cli_li("1")
    lid2 <- cli_ul()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "starting with an item", {
  expect_snapshot(local({
    cli_li("foo")
    cli_li(c("bar", "foobar"))
    cli_end()
    cli_end()
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ol, with first item", {
  expect_snapshot(local({
    cli_div(theme = list(ol = list()))
    lid <- cli_ol("foo", .close = FALSE)
    cli_li(c("bar", "foobar"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ul, with first item", {
  expect_snapshot(local({
    lid <- cli_ul("foo", .close = FALSE)
    cli_li(c("bar", "foobar"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "dl", {
  expect_snapshot(local({
    cli_div(theme = list(ul = list()))
    lid <- cli_dl()
    cli_li(c(this = "foo"))
    cli_li(c(that = "bar", other = "foobar"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "dl dl", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_dl()
    cli_li(c(a = "1"))
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "dl ol", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_dl()
    cli_li(c(a = "1"))
    lid2 <- cli_ol()
    cli_li(c("1 1"))
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "dl ul", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_dl()
    cli_li(c(a = "1"))
    lid2 <- cli_ul()
    cli_li(c("1 1"))
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ol dl", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_ol()
    cli_li("1")
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "ul dl", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        li = list("margin-left" = 2)
      )
    )
    lid <- cli_ul()
    cli_li("1")
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li("2")
    cli_end(lid)
  }))
})

test_that_cli(configs = c("plain", "unicode"), "dl, with first item", {
  expect_snapshot(local({
    cli_div(theme = list(ul = list()))
    lid <- cli_dl(c(this = "foo"), .close = FALSE)
    cli_li(c(that = "bar", other = "foobar"))
    cli_end(lid)
  }))
})
