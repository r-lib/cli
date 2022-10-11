# ruler

    Code
      ruler(20)
    Output
      ----+----1----+----2
      12345678901234567890

# na.omit

    Code
      na.omit(character())
    Output
      character(0)
    Code
      na.omit(integer())
    Output
      integer(0)
    Code
      na.omit(1:5)
    Output
      [1] 1 2 3 4 5
    Code
      na.omit(c(1, NA, 2, NA))
    Output
      [1] 1 2
    Code
      na.omit(c(NA_integer_, NA_integer_))
    Output
      integer(0)
    Code
      na.omit(list(1, 2, 3))
    Output
      [[1]]
      [1] 1
      
      [[2]]
      [1] 2
      
      [[3]]
      [1] 3
      

# str_trim

    Code
      str_trim("foo")
    Output
      [1] "foo"
    Code
      str_trim(character())
    Output
      character(0)
    Code
      str_trim("   foo")
    Output
      [1] "foo"
    Code
      str_trim("foo  ")
    Output
      [1] "foo"
    Code
      str_trim("   foo  ")
    Output
      [1] "foo"
    Code
      str_trim(c(NA_character_, " foo  ", NA_character_, "  bar  "))
    Output
      [1] NA    "foo" NA    "bar"

# leading_space

    Code
      paste0("-", leading_space("foo"), "-")
    Output
      [1] "--"
    Code
      paste0("-", leading_space("  foo"), "-")
    Output
      [1] "-  -"
    Code
      paste0("-", leading_space("  foo  "), "-")
    Output
      [1] "-  -"
    Code
      paste0("-", leading_space(" \t foo  "), "-")
    Output
      [1] "- \t -"
    Code
      paste0("-", leading_space(" foo  "), "-")
    Output
      [1] "- -"
    Code
      paste0("-", leading_space("   foo  "), "-")
    Output
      [1] "-   -"

# trailing_space

    Code
      paste0("-", trailing_space("foo"), "-")
    Output
      [1] "--"
    Code
      paste0("-", trailing_space("foo  "), "-")
    Output
      [1] "-  -"
    Code
      paste0("-", trailing_space("  foo  "), "-")
    Output
      [1] "-  -"
    Code
      paste0("-", trailing_space("  foo \t "), "-")
    Output
      [1] "- \t -"
    Code
      paste0("-", trailing_space("  foo "), "-")
    Output
      [1] "- -"
    Code
      paste0("-", trailing_space("   foo   "), "-")
    Output
      [1] "-   -"

# abbrev

    Code
      abbrev("123456789012345")
    Output
      <cli_ansi_string>
      [1] 1234567...
    Code
      abbrev("12345678901")
    Output
      <cli_ansi_string>
      [1] 1234567...
    Code
      abbrev("1234567890")
    Output
      <cli_ansi_string>
      [1] 1234567890
    Code
      abbrev("123456789")
    Output
      <cli_ansi_string>
      [1] 123456789
    Code
      abbrev("12345")
    Output
      <cli_ansi_string>
      [1] 12345
    Code
      abbrev("1")
    Output
      <cli_ansi_string>
      [1] 1
    Code
      abbrev("")
    Output
      <cli_ansi_string>
      [1] 
    Code
      abbrev("\033[31m1234567890\033[39m")
    Output
      <cli_ansi_string>
      [1] [31m1234567890[39m
    Code
      abbrev(c("\033[31m1234567890\033[39m", "", "1234567890123"), 5)
    Output
      <cli_ansi_string>
      [1] [31m12[39m...
      [2]                      
      [3] 12...                
    Code
      abbrev(rep("\033[31m1234567890\033[39m", 5), 5)
    Output
      <cli_ansi_string>
      [1] [31m12[39m...
      [2] [31m12[39m...
      [3] [31m12[39m...
      [4] [31m12[39m...
      [5] [31m12[39m...

