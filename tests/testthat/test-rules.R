
test_that_cli("make_line", {

  expect_equal(make_line(1, "-"), "-")
  expect_equal(make_line(0, "-"), "")
  expect_equal(make_line(2, "-"), "--")
  expect_equal(make_line(10, "-"), "----------")

  expect_equal(make_line(2, "12"), "12")
  expect_equal(make_line(0, "12"), "")
  expect_equal(make_line(1, "12"), "1")
  expect_equal(make_line(9, "12"), "121212121")
  expect_equal(make_line(10, "12"), "1212121212")
})

test_that("width option", {
  expect_equal(
    rule(width = 11, line = "-"),
    rule_class("-----------")
  )
})

test_that("left label", {

  expect_equal(
    rule("label", width = 12, line = "-"),
    rule_class("-- label ---")
  )
  expect_equal(
    rule("l", width = 12, line = "-"),
    rule_class("-- l -------")
  )
  expect_equal(
    rule("label", width = 9, line = "-"),
    rule_class("-- label ")
  )
  expect_equal(
    rule("label", width = 8, line = "-"),
    rule_class("-- label")
  )
  expect_equal(
    rule("label", width = 6, line = "-"),
    rule_class("-- lab")
  )
})

test_that("centered label", {

  expect_error(
    rule(left = "label", center = "label"),
    "cannot be specified"
  )
  expect_error(
    rule(center = "label", right = "label"),
    "cannot be specified"
  )

  expect_equal(
    rule(center = "label", width = 13, line = "-"),
    rule_class("--- label ---")
  )
  expect_equal(
    rule(center = "label", width = 14, line = "-"),
    rule_class("---- label ---")
  )
  expect_equal(
    rule(center = "label", width = 9, line = "-"),
    rule_class("- label -")
  )
  expect_equal(
    rule(center = "label", width = 8, line = "-"),
    rule_class("- labe -")
  )
  expect_equal(
    rule(center = "label", width = 7, line = "-"),
    rule_class("- lab -")
  )
})

test_that("right label", {
  expect_equal(
    rule(right = "label", width = 12, line = "-"),
    rule_class("--- label --")
  )
  expect_equal(
    rule(right = "l", width = 12, line = "-"),
    rule_class("------- l --")
  )
  expect_equal(
    rule(right = "label", width = 9, line = "-"),
    rule_class(" label --")
  )
  expect_equal(
    rule(right = "label", width = 8, line = "-"),
    rule_class(" label -")
  )
  expect_equal(
    rule(right = "label", width = 6, line = "-"),
    rule_class(" label")
  )
  expect_equal(
    rule(right = "label", width = 5, line = "-"),
    rule_class(" labe")
  )
  expect_equal(
    rule(right = "label", width = 4, line = "-"),
    rule_class(" lab")
  )
})

test_that("line_col", {

  withr::with_options(
    list(cli.num_colors = 256L), {
      expect_true(ansi_has_any(
        rule(line_col = "red")
      ))
      expect_true(ansi_has_any(
        rule(left = "left", line_col = "red")
      ))
      expect_true(ansi_has_any(
        rule(left = "left", right = "right", line_col = "red")
      ))
      expect_true(ansi_has_any(
        rule(center = "center", line_col = "red")
      ))
      expect_true(ansi_has_any(
        rule(right = "right", line_col = "red")
      ))

      expect_true(ansi_has_any(
        rule(line_col = col_red)
      ))
    }
  )
})

test_that_cli("get_line_char", {
  expect_equal(get_line_char(1), cli::symbol$line)
  expect_equal(get_line_char(2), cli::symbol$double_line)

  expect_equal(get_line_char("bar1"), cli::symbol$lower_block_1)
  expect_equal(get_line_char("bar2"), cli::symbol$lower_block_2)
  expect_equal(get_line_char("bar3"), cli::symbol$lower_block_3)
  expect_equal(get_line_char("bar4"), cli::symbol$lower_block_4)
  expect_equal(get_line_char("bar5"), cli::symbol$lower_block_5)
  expect_equal(get_line_char("bar6"), cli::symbol$lower_block_6)
  expect_equal(get_line_char("bar7"), cli::symbol$lower_block_7)
  expect_equal(get_line_char("bar8"), cli::symbol$lower_block_8)

  expect_equal(get_line_char("xxx"), "xxx")
  expect_equal(get_line_char(c("x", "y", "z")), "xyz")
})

test_that("print.rule", {
  withr::local_options(cli.width = 20)
  expect_snapshot(rule("foo"))
})
