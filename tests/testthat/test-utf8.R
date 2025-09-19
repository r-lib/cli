# We need an UTF-8 platform or a recent R version on Windows

utf8 <- l10n_info()$`UTF-8`
newwin <- .Platform$OS.type == "windows" && getRversion() >= "4.0.0"
if (!utf8 && !newwin) return()

test_that("UTF-8 output on Windows", {
  skip_on_cran()
  skip_on_covr()
  out <- r_utf8(function() {
    library(cli)
    options(cli.unicode = TRUE)
    options(cli.num_colors = 1)
    options(cli.width = 70)
    options(cli.dynamic = FALSE)
    Sys.setenv(RSTUDIO = NA)

    s1 <- "\u30DE\u30EB\u30C1\u30D0\u30A4\u30C8\u306E\u30BF\u30A4\u30C8\u30EB"
    s2 <- "\u00e1rv\u00edzt\u0171r\u0151 t\u00fck\u00f6rf\u00far\u00f3g\u00e9p"

    cli_h1("Alerts")
    cli_alert(s1)
    cli_alert_danger(s2)
    cli_alert_info(s1)
    cli_alert_success(s1)
    cli_alert_warning(s1)

    cli_h1("Block quote")
    cli_blockquote(s1, s2)

    cli_h1("Bullets")
    cli_bullets(c("*" = s1, "!" = s2))

    cli_h1("Code")
    cli_code(c(s1, s2))

    cli_h1("Lists")
    cli_dl(c(s1 = s1, s2 = s2))
    cli_ol(c(s1, s2))
    cli_ul(c(s1, s2))

    cli_h1("Headers")
    cli_h1(s1)
    cli_h2(s2)
    cli_h3(s1)

    cli_h1("Progress bars")
    cli_progress_step(s1)
    cli_progress_step(s2)
    cli_progress_done()

    cli_h1("Text")
    idx <- c(1L, 2L, 1L, 2L, 1L, 1L, 1L, 1L, 2L, 1L, 2L, 1L, 1L, 1L, 1L)
    cli_text(paste(c(s1, s2)[idx], collapse = " "))

    cli_h1("Verbatim")
    cli_verbatim(c(s1, s2))
  })

  out$stdout <- gsub("\\[[.0-9]+m?s\\]", "[1s]", out$stdout)

  tmp <- tempfile(fileext = ".txt")
  writeBin(charToRaw(out$stdout), tmp)
  expect_snapshot_file(tmp, name = "utf8-output.txt")
})

test_that("utf8_graphemes", {
  expect_equal(utf8_graphemes(character()), list())
  expect_equal(utf8_graphemes(""), list(character()))

  str <- c(
    NA,
    "",
    "alpha",
    "\U0001f477\U0001f3ff\u200d\u2640\ufe0f",
    "\U0001f477\U0001f3ff",
    "\U0001f477\u200d\u2640\ufe0f",
    "\U0001f477\U0001f3fb",
    "\U0001f477\U0001f3ff"
  )
  exp <- list(
    NA_character_,
    character(),
    c("a", "l", "p", "h", "a"),
    "\U0001f477\U0001f3ff\u200d\u2640\ufe0f",
    "\U0001f477\U0001f3ff",
    "\U0001f477\u200d\u2640\ufe0f",
    "\U0001f477\U0001f3fb",
    "\U0001f477\U0001f3ff"
  )
  expect_equal(utf8_graphemes(str), exp)

  str2 <- paste0(na.omit(str), collapse = "")
  exp2 <- list(na.omit(unlist(exp)))
  expect_equal(utf8_graphemes(str2), exp2)
})

test_that("errors", {
  expect_snapshot_error(
    fix_r_utf8_output("\x02\xff\xfe \x03\xff\xfe \x03\xff\xfe")
  )
})
