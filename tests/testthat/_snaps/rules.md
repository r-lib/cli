# centered label

    Code
      rule(left = "label", center = "label")
    Condition
      Error in `rule()`:
      ! 'center' cannot be specified with 'left' or 'right'
    Code
      rule(center = "label", right = "label")
    Condition
      Error in `rule()`:
      ! 'center' cannot be specified with 'left' or 'right'

# print.cli_rule

    Code
      rule("foo")
    Output
      -- foo -------------

