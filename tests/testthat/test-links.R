
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

  # line numbers
  expect_snapshot({
    cli_text("{.file /absolute/path:12}")
    cli_text("{.file file:///absolute/path:5}")
    cli_text("{.path /absolute/path:123}")
    cli_text("{.path file:///absolute/path:51}")
  })
  expect_snapshot({
    cli_text("{.file relative/path:12}")
    cli_text("{.file ./relative/path:5}")
    cli_text("{.path relative/path:123}")
    cli_text("{.path ./relative/path:51}")
  }, transform = sanitize_wd)
  expect_snapshot({
    cli_text("{.file ~/relative/path:12}")
    cli_text("{.path ~/relative/path:5}")
  }, transform = sanitize_home)

  # line and column numbers
  expect_snapshot({
    cli_text("{.file /absolute/path:12:5}")
    cli_text("{.file file:///absolute/path:5:100}")
    cli_text("{.path /absolute/path:123:1}")
    cli_text("{.path file:///absolute/path:51:6}")
  })
  expect_snapshot({
    cli_text("{.file relative/path:12:13}")
    cli_text("{.file ./relative/path:5:20}")
    cli_text("{.path relative/path:123:21}")
    cli_text("{.path ./relative/path:51:2}")
  }, transform = sanitize_wd)
  expect_snapshot({
    cli_text("{.file ~/relative/path:12:23}")
    cli_text("{.path ~/relative/path:5:2}")
  }, transform = sanitize_home)
  expect_snapshot({
    paths <- c("~/foo", "bar:10", "file:///abs:10:20")
    cli_text("{.file {paths}}")
  }, transform = function(x) sanitize_home(sanitize_wd(x)))
})

# -- {.fun} ---------------------------------------------------------------

# TODO

# -- {.help} --------------------------------------------------------------

# TODO

# -- {.href} --------------------------------------------------------------

test_that_cli(config = "plain", links = c("all", "none"),
              "{.href}", {
  expect_snapshot({
    cli_text("{.href https://cli.r-lib.org}")
    cli_text("{.href [linktext](https://cli.r-lib.org)}")
    cli_text("{.href [link text](https://cli.r-lib.org)}")
  })
})

test_that_cli(config = "plain", links = c("all", "none"),
              "{.href} vectors", {
  expect_snapshot({
    url <- paste0("https://cli.r-lib.org/", 1:3)
    cli_text("{.href {url}}")
  })
})

# -- {.run} ---------------------------------------------------------------

# TODO

# -- {.topic} -------------------------------------------------------------

# TODO

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

# -- {.vignette} ----------------------------------------------------------

# TODO
