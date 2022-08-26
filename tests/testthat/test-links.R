
test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.url}", {
  expect_snapshot({
    cli_text("{.url https://cli.r-lib.org}")
  })
})

test_that_cli(config = c("plain", "fancy"), links = c("all", "none"),
              "{.url}", {

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
