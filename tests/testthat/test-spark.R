
test_that_cli(configs = c("plain", "unicode"), "spark_bar", {
  expect_snapshot({
    spark_bar(seq(0, 1, length = 8))
    spark_bar(c(0, NA, 0.5, NA, 1))
  })
})

test_that_cli(configs = c("plain", "unicode"), "spark_line", {
  expect_snapshot({
    spark_line(seq(0, 1, length = 10))
  })
})
