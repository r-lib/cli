
if (.Platform$OS.type != "windows" || getRversion() < "4.0.0") {
  return()
}

escape <- function(x) {
  x2 <- gsub(
    "<U[+]([A-F0-9][A-F0-9][A-F0-9][A-F0-9])>",
    "\\\\u\\1",
    format(x),
    perl = TRUE
  )

  strsplit(x2, "\r\n", fixed = TRUE)[[1]]
}

test_that("UTF-8 output on Windows", {
  skip_on_cran()
  out <- r_utf8(function() {
    library(cli)
    options(cli.unicode = TRUE)
    options(cli.num_colors = 1)
    s1 <- "\u30DE\u30EB\u30C1\u30D0\u30A4\u30C8\u306E\u30BF\u30A4\u30C8\u30EB"
    s2 <- "\u00e1rv\u00edzt\u0171r\u0151 t\u00fck\u00f6rf\u00far\u00f3g\u00e9p"
    cli_alert(s1)
    cli_alert_success(s1)
    cli_text(s2)
    cli_bullets(c("*" = s1, "*" = s2))
    cli_code(s1)
    cli_dl(c(s1 = s2, s2 = s2))
  })
  expect_equal(Encoding(out$stdout), "UTF-8")
  expect_snapshot(charToRaw(out$stdout))
})
