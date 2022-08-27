
# -- {.url} ---------------------------------------------------------------

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.url}", {
  expect_snapshot({
    cli_text("{.url https://cli.r-lib.org}")
  })
})

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.url} vector", {
  expect_snapshot({
    urls <- paste0("https://cli.r-lib.org/", 1:3)
    cli_text("{.url {urls}}")
  })
})

# -- {.file} and {.path} --------------------------------------------------

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.file} and {.path}", {

  # absolute path
  expect_snapshot({
    cli_text("{.file /absolute/path}")
    cli_text("{.file file:///absolute/path}")
    cli_text("{.path /absolute/path}")
    cli_text("{.path file:///absolute/path}")
  })

  # relative path
  expect_snapshot({
    cli_text("{.file relative/path}")
    cli_text("{.file ./relative/path}")
    cli_text("{.path relative/path}")
    cli_text("{.path ./relative/path}")
  }, transform = sanitize_wd)

  # ~
  expect_snapshot({
    cli_text("{.file ~/relative/path}")
    cli_text("{.path ~/relative/path}")
  }, transform = sanitize_home)

  # vectorized
  expect_snapshot({
    paths <- c("~/foo", "bar", "file:///abs")
    cli_text("{.file {paths}}")
  }, transform = function(x) sanitize_home(sanitize_wd(x)))

  # weird names
  expect_snapshot({
    paths <- c("foo  ", " bar ", "file:///a bs ")
    cli_text("{.file {paths}}")
  }, transform = sanitize_wd)

  # hand created hyperlink is skipped
  expect_snapshot({
    name <- cli::style_hyperlink("/foo/bar", "/foo/bar")
    cli_text("{.file {name}}")
  })
})

# -- {.email} -------------------------------------------------------------

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.email}", {

  expect_snapshot({
    cli_text("{.email bugs.bunny@acme.com}")
  })
})

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.email} vectors", {

  expect_snapshot({
    emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
    cli_text("{.email {emails}}")
  })
})

# -- {.href} --------------------------------------------------------------

test_that_cli(config = "plain", links = c("all", "none"),
              "{.href}", {
  expect_snapshot({
    cli_text("{.href https://cli.r-lib.org}")
    cli_text("{.href https://cli.r-lib.org linktext}")
    cli_text("{.href https://cli.r-lib.org link text}")
  })
})

test_that_cli(config = "plain", links = c("all", "none"),
              "{.href} vectors", {
  expect_snapshot({
    url <- paste0("https://cli.r-lib.org/", 1:3)
    cli_text("{.href {url}}")
  })
})
