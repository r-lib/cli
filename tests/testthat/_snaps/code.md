# issue #154 [plain]

    Code
      cli_code("a\nb\nc")
    Message
      a
      b
      c

# issue #154 [ansi]

    Code
      cli_code("a\nb\nc")
    Message
      a
      b
      c

# issue #154 [unicode]

    Code
      cli_code("a\nb\nc")
    Message
      a
      b
      c

# issue #154 [fancy]

    Code
      cli_code("a\nb\nc")
    Message
      a
      b
      c

# Jenny's problem [plain]

    Code
      cli_code_wrapper("if (1) {true_val} else {false_val}")
    Message
      if (1) TRUE else 'FALSE'

# Jenny's problem [ansi]

    Code
      cli_code_wrapper("if (1) {true_val} else {false_val}")
    Message
      [33mif[39m [33m([39m[35m1[39m[33m)[39m [35mTRUE[39m [33melse[39m [36m'FALSE'[39m

# Jenny's problem [unicode]

    Code
      cli_code_wrapper("if (1) {true_val} else {false_val}")
    Message
      if (1) TRUE else 'FALSE'

# Jenny's problem [fancy]

    Code
      cli_code_wrapper("if (1) {true_val} else {false_val}")
    Message
      [33mif[39m [33m([39m[35m1[39m[33m)[39m [35mTRUE[39m [33melse[39m [36m'FALSE'[39m

