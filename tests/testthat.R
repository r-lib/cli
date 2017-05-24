library(testthat)
library(boxes)

## Run the tests in fancy mode and non-fancy mode as well

withr::with_options(
  list(boxes.unicode = TRUE),
  test_check("boxes")
)

withr::with_options(
  list(boxes.unicode = FALSE),
  test_check("boxes")
)
