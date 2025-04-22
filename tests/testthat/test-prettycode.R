
col_seq <- list(function(x)
  paste0("1", x),
  function(x)
    paste0("2", x),
  function(x)
    paste0("3", x))

test_that("bracket highlighting", {
  # [](){}
  expect_equal(color_brackets(c("[", "]", "(", ")", "{", "}"), col_seq),
               c("1[", "1]", "1(", "1)", "1{", "1}"))
  
  # [({[({})]})]
  expect_equal(
    color_brackets(c(
      "[", "(", "{", "[", "(", "{", "}", ")", "]", "}", ")", "]"
    ),
    col_seq),
    c(
      "1[",
      "2(",
      "3{",
      "1[",
      "2(",
      "3{",
      "3}",
      "2)",
      "1]",
      "3}",
      "2)",
      "1]"
    )
  )
  
  # [[ [] ]][[ ()() ]]
  expect_equal(
    color_brackets(
      c("[[", "[", "]", "]", "]", "[[", "(", ")", "(", ")", "]", "]"),
      col_seq
    ),
    c(
      "1[[",
      "2[",
      "2]",
      "1]",
      "1]",
      "1[[",
      "2(",
      "2)",
      "2(",
      "2)",
      "1]",
      "1]"
    )
  )
})

test_that_cli(configs = c("plain", "ansi"), "reserved", {
  expect_snapshot({
    cat(code_highlight("function () { }", list(reserved = "bold")))
    cat(code_highlight("if (1) NULL else NULL", list(reserved = "bold")))
    cat(code_highlight("repeat {}", list(reserved = "bold")))
    cat(code_highlight("while (1) {}", list(reserved = "bold")))
    cat(code_highlight("for (i in x) next", list(reserved = "bold")))
    cat(code_highlight("for (i in x) break", list(reserved = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "number", {
  expect_snapshot({
    cat(code_highlight("1 + 1.0 + -1 + 2L + Inf", list(number = "bold")))
    cat(code_highlight(
      "NA + NA_real_ + NA_integer_ + NA_character_",
      list(number = "bold")
    ))
    cat(code_highlight("TRUE + FALSE", list(number = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "null", {
  expect_snapshot({
    cat(code_highlight("NULL", list(null = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "operator", {

  expect_snapshot({
    cat(code_highlight("~ ! 1 - 2 + 3:4 * 5 / 6 ^ 7", list(operator = "bold")))
    cat(code_highlight(
      "? 1 %% 2 %+% 2 < 3 & 4 > 5 && 6 == 7 | 8 <= 9 || 10 >= 11",
      list(operator = "bold")
    ))
    cat(code_highlight(
      "a <- 10; 20 -> b; c = 30; a$b; a@b",
      list(operator = "bold")
    ))
  })
})

test_that_cli(configs = c("plain", "ansi"), "call", {
  expect_snapshot({
    cat(code_highlight("ls(2)", list(call = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "string", {
  expect_snapshot({
    cat(code_highlight("'s' + \"s\"", list(string = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "comment", {
  expect_snapshot({
    cat(code_highlight(c("# COM", " ls() ## ANOT"), list(comment = "bold")))
  })
})

test_that_cli(configs = c("plain", "ansi"), "bracket", {
  expect_snapshot({
    cat(code_highlight("foo <- function(x){x}", list(bracket = list("bold"))))
  })
})

test_that("replace_in_place", {
  expect_equal(
    replace_in_place("1234567890", c(2, 6), c(5, 8), c("foobar", "xxx")),
    "1foobarxxx90"
  )

  expect_equal(
    replace_in_place("1234567890", c(1, 5), c(6, 10), c("A", "B")),
    "AB"
  )
})

test_that("replace_in_place corner cases", {
  expect_equal(
    replace_in_place("foobar", integer(), integer(), character()),
    "foobar"
  )

  expect_equal(
    replace_in_place("12345", 1L, 5L, "no!"),
    "no!"
  )

  expect_equal(
    replace_in_place("12345", 1:5, 1:5, letters[1:5]),
    "abcde"
  )
})

test_that_cli(configs = c("plain", "ansi"), "parse errors", {
  expect_equal(
    code_highlight("not good!!!"), "not good!!!"
  )
  cnd <- NULL
  withCallingHandlers(
    expect_equal(
      code_highlight("not good!!!"), "not good!!!"
    ),
    cli_parse_failure = function(e) cnd <<- e
  )
  expect_s3_class(cnd, "cli_parse_failure")
  expect_s3_class(cnd, "condition")
  expect_equal(cnd$code, "not good!!!")
})

test_that("code themes", {
  withr::local_options(cli.code_theme = "solarized_dark")
  expect_equal(code_theme_default()$reserved, "#859900")

  withr::local_options(cli.code_theme = NULL)
  withr::local_envvar(RSTUDIO = "0")
  withr::local_options(cli.code_theme_terminal = "solarized_light")
  expect_equal(code_theme_default()$reserved, "#859900")

  local_mocked_bindings(
    rstudio_detect = function() list(type = "rstudio_console")
  )
  withr::local_options(cli.code_theme_rstudio = "Xcode")
  expect_equal(code_theme_default()$reserved, "#C800A4")

  withr::local_options(cli.code_theme_rstudio = NULL)
  skip_if_not_installed("rstudioapi")
  local_mocked_bindings(code_theme_default_rstudio = function() "foo")
  expect_equal(code_theme_default(), "foo")
})

test_that("code themes 2", {
  withr::local_options(cli.code_theme = "nope!!")
  expect_warning(code_theme_default(), "Unknown cli code theme")

  withr::local_options(cli.code_theme = 111)
  expect_warning(code_theme_default(), "Invalid cli code theme")
})

test_that("code_theme_default_rstudio", {
  local_mocked_bindings(
    get_rstudio_theme = function() list(editor = "Solarized Dark")
  )
  expect_equal(code_theme_default_rstudio()$reserved, "#859900")

  local_mocked_bindings(
    get_rstudio_theme = function() list(editor = "Not really")
  )
  expect_warning(
    cth <- code_theme_default_rstudio(),
    "cli does not know this RStudio theme"
  )
  expect_equal(cth, code_theme_default_term())
})

test_that("code_theme_list", {
  expect_snapshot(code_theme_list())
})

test_that_cli(configs = "ansi", "new language features, raw strings", {
  if (getRversion() < "4.0.1") { expect_true(TRUE); return() }
  expect_snapshot(
    cat(code_highlight(
      '"old" + r"("new""")"',
      list(string = "bold", reserved = "italic")
    ))
  )
})

test_that_cli(configs = "ansi", "new language features, pipe", {
  if (getRversion() < "4.1.0") { expect_true(TRUE); return() }
  expect_snapshot(
    cat(code_highlight('dir() |> toupper()', list(operator = "bold")))
  )
})

test_that_cli(configs = "ansi", "new language features, lambda functions", {
  if (getRversion() < "4.1.0") { expect_true(TRUE); return() }
  expect_snapshot(
    cat(code_highlight('\\(x) x * 2', list(reserved = "bold")))
  )
})

test_that("code_highlight() works on long strings and symbols", {
  expect_true(
    grepl(
      strrep("-", 1000),
      code_highlight(paste0("foo('", strrep("-", 1000), "')"))
    )
  )

  expect_true(
    grepl(
      strrep("-", 1000),
      code_highlight(paste0("foo(`", strrep("-", 1000), "`)"))
    )
  )
  expect_true(
    grepl(
      strrep("-", 1000),
      code_highlight(paste0("a$`", strrep("-", 1000), "`"))
    )
  )

  expect_true(
    grepl(
      strrep("-", 1000),
      code_highlight(paste0("`", strrep("-", 1000), "`$a"))
    )
  )
})
