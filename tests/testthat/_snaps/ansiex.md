# ansi_substr bad input

    Code
      ansi_substr("foobar", NULL, 10)
    Condition
      Error:
      ! `ansi_substr()` must have non-empty `start` and `stop` arguments
      i `start` has length 0

---

    Code
      ansi_substr("foobar", 10, NULL)
    Condition
      Error:
      ! `ansi_substr()` must have non-empty `start` and `stop` arguments
      i `stop` has length 0

---

    Code
      ansi_substr("foobar", "bad", "bad")
    Condition
      Error:
      ! `start` and `stop` must not have `NA` values
      i `start` has 1 `NA` value, after coercion to integer
      i `stop` has 1 `NA` value, after coercion to integer

# ansi_substr corner cases

    Code
      ansi_substr("abc", "hello", 1)
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`start` and `stop` must not have `NA` values
      [36mi[39m `start` has 1 `NA` value, after coercion to integer

# Weird length 'split'

    Code
      ansi_strsplit(c("ab", "bd"), c("b", "d"))
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`split` must be character of length <= 1, or must coerce to that
      [36mi[39m `split` is (or was coerced to) a character vector

# ansi_strtrim with zero-length ellipsis

    Code
      ansi_strtrim("12345", 1, ellipsis = "")
    Output
      <cli_ansi_string>
      [1] 1
    Code
      ansi_strtrim("12345", 3, ellipsis = "")
    Output
      <cli_ansi_string>
      [1] 123
    Code
      ansi_strtrim("12345", 5, ellipsis = "")
    Output
      <cli_ansi_string>
      [1] 12345

# ansi_columns

    foo 1     foo 2     foo 3     foo 4     
    foo 5     foo 6     foo 7     foo 8     
    foo 9     foo 10                        

---

    123456789012...

# ansi_toupper [plain]

    Code
      local({
        cat_line(x)
        cat_line(ansi_toupper(x))
      })
    Output
      Red normal green
      RED NORMAL GREEN

# ansi_toupper [ansi]

    Code
      local({
        cat_line(x)
        cat_line(ansi_toupper(x))
      })
    Output
      [31mRed [39mnormal [1m[32mgreen[39m[22m
      [31mRED [39mNORMAL [1m[32mGREEN[39m[22m

# ansi_tolower [plain]

    Code
      local({
        cat_line(x)
        cat_line(ansi_tolower(x))
      })
    Output
      Red NORMAL grEeN
      red normal green

# ansi_tolower [ansi]

    Code
      local({
        cat_line(x)
        cat_line(ansi_tolower(x))
      })
    Output
      [31mRed [39mNORMAL [1m[32mgrEeN[39m[22m
      [31mred [39mnormal [1m[32mgreen[39m[22m

# ansi_chartr [plain]

    Code
      local({
        cat_line(x)
        cat_line(ansi_chartr(" R_", "-r*", x))
      })
    Output
      Red normal green
      red-normal-green

# ansi_chartr [ansi]

    Code
      local({
        cat_line(x)
        cat_line(ansi_chartr(" R_", "-r*", x))
      })
    Output
      [31mRed [39mnormal [1m[32mgreen[39m[22m
      [31mred-[39mnormal-[1m[32mgreen[39m[22m

