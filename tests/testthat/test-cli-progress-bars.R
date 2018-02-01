
context("cli progress bars")

test_that("progress bars", {
  x <- 100

  withr::with_options(c(cli.width = 40), {
    out <- capt({
      cli$alert_success("so far so good: {x}")
      bar <- cli$progress_bar(total = 5, force = TRUE, show_after = 0)
      bar$tick()
      bar$tick()
      cli$alert_success("still very good: {x}!")
      bar$tick()
      cli$text(strrep("1234567890 ", 6))
      bar$tick()
      bar$tick()
      cli$alert_success("aaaaand we are done")
    }, print_it = FALSE)
  })

  out <- strsplit(out, "\n", fixed = TRUE)[[1]]

  exp <- c(
    glue::glue(  "{symbol$tick} so far so good: 100"),
    glue::glue("\r[=======--------------------------]  20%\\
               \r[=============--------------------]  40%\\
               \r                                        \\
               \r{symbol$tick} still very good: 100!"),
    glue::glue(  "[=============--------------------]  40%\\
               \r[====================-------------]  60%\\
               \r                                        \\
               \r1234567890 1234567890 1234567890"),
    glue::glue(  "1234567890 1234567890 1234567890 "),
    glue::glue(  "[====================-------------]  60%\\
               \r[==========================-------]  80%\\
               \r[=================================] 100%\\
               \r                                        \\
               \r{symbol$tick} aaaaand we are done")
  )

  expect_equal(out, exp)
})
