
# -- {.email} -------------------------------------------------------------

test_that_cli(configs = c("plain", "fancy"), links = c("all", "none"),
              "{.email}", {

  expect_snapshot({
    cli_text("{.email bugs.bunny@acme.com}")
  })
})

test_that_cli(configs = c("plain", "fancy"), links = c("all", "none"),
              "{.email} vectors", {

  expect_snapshot({
    emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
    cli_text("{.email {emails}}")
  })
})

# -- {.file} and {.path} --------------------------------------------------

test_that_cli(configs = c("plain", "fancy"), links = c("all", "none"),
              "{.file} and {.path}", {

  withr::local_envvar(R_CLI_HYPERLINK_STYLE = NA_character_)

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

  local_mocked_bindings(is_windows = function() TRUE)
  expect_equal(
    abs_path1("c:/foo/bar"),
    "file://c:/foo/bar"
  )
})

# -- {.fun} ---------------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.fun}", {

  expect_snapshot({
    cli_text("{.fun myfun}")
    cli_text("{.fun mypackage::myfun}")
  })

  expect_snapshot({
    funs <- paste0("mypkg::myfun", 1:3)
    cli_text("{.fun {funs}}")
  })
})

test_that_cli(configs = "plain", links = "all", "turning off help", {
  withr::local_options(cli.hyperlink_help = FALSE)
  expect_snapshot({
    cli_text("{.fun pkg::func}")
  })
})

# -- {.help} --------------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.help}", {

  expect_snapshot({
    cli_text("{.help pkg::fun}")
    cli_text("{.help [link text](pkg::fun)}")
  })

  expect_snapshot({
    funcs <- paste0("pkg::fun", 1:3)
    cli_text("{.help {funcs}}")
  })
})

# -- {.href} --------------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.href}", {
  expect_snapshot({
    cli_text("{.href https://cli.r-lib.org}")
    cli_text("{.href [linktext](https://cli.r-lib.org)}")
    cli_text("{.href [link text](https://cli.r-lib.org)}")
  })
})

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.href} vectors", {
  expect_snapshot({
    url <- paste0("https://cli.r-lib.org/", 1:3)
    cli_text("{.href {url}}")
  })
})

# -- {.run} ---------------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.run}", {
  expect_snapshot({
    cli_text("{.run pkg::fun(param)}")
    cli_text("{.run [run(p1, p2)](pkg::fun(p1, p2, other = 'foo'))}")
  })
})

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.run} vectors", {
  expect_snapshot({
    codes <- paste0("pkg::fun", 1:3, "()")
    cli_text("{.run {codes}}")
  })
})

# -- {.topic} -------------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.topic}", {

  expect_snapshot({
    cli_text("{.topic pkg::topic}")
    cli_text("{.topic [link text](pkg::topic)}")
  })

  expect_snapshot({
    topics <- paste0("pkg::topic", 1:3)
    cli_text("{.topic {topics}}")
  })
})

# -- {.url} ---------------------------------------------------------------

test_that_cli(configs = c("plain", "fancy"), links = c("all", "none"),
              "{.url}", {
  expect_snapshot({
    cli_text("{.url https://cli.r-lib.org}")
  })
})

test_that_cli(configs = c("plain", "fancy"), links = c("all", "none"),
              "{.url} vector", {
  expect_snapshot({
    urls <- paste0("https://cli.r-lib.org/", 1:3)
    cli_text("{.url {urls}}")
  })
})

test_that_cli(configs = "plain", links = "all", "linked {.url}", {
  expect_snapshot({
    link <- c(
      "https://cli.r-lib.org",
      style_hyperlink("text", "https://cli.r-lib.org")
    )
    cli_text("{.url {link}}")
  })
})

test_that("make_link_url", {
  withr::local_options(cli.hyperlink = TRUE)
  x <- style_hyperlink(paste0("foo", 1:3), paste0("https://foo.bar/", 1:3))
  expect_equal(make_link_url(x), x)
})

# -- {.vignette} ----------------------------------------------------------

test_that_cli(configs = "plain", links = c("all", "none"),
              "{.vignette}", {

  expect_snapshot({
    cli_text("{.vignette pkg::name}")
    cli_text("{.vignette [link text](pkg::name)}")
  })

  expect_snapshot({
    vignettes <- paste0("pkg::topic", 1:3)
    cli_text("{.vignette {vignettes}}")
  })
})
