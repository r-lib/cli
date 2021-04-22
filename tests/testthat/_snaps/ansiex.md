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

