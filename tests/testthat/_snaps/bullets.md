# bullets [plain]

    Code
      cli_bullets(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet", `>` = "arrow", `[]` = "TODO", `?` = "question"))
    Message
      noindent
        space
      v success
      x danger
      ! warning
      i info
      * bullet
      > arrow
      [ ] TODO
      (?) question

# bullets [ansi]

    Code
      cli_bullets(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet", `>` = "arrow", `[]` = "TODO", `?` = "question"))
    Message
      noindent
        space
      [32mv[39m success
      [31mx[39m danger
      [33m![39m warning
      [36mi[39m info
      [36m*[39m bullet
      > arrow
      [31m[ ][39m TODO
      [31m(?)[39m question

# bullets [unicode]

    Code
      cli_bullets(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet", `>` = "arrow", `[]` = "TODO", `?` = "question"))
    Message
      noindent
        space
      ✔ success
      ✖ danger
      ! warning
      ℹ info
      • bullet
      → arrow
      ☐ TODO
      ❓ question

# bullets [fancy]

    Code
      cli_bullets(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet", `>` = "arrow", `[]` = "TODO", `?` = "question"))
    Message
      noindent
        space
      [32m✔[39m success
      [31m✖[39m danger
      [33m![39m warning
      [36mℹ[39m info
      [36m•[39m bullet
      → arrow
      [31m☐[39m TODO
      [31m❓[39m question

# bullets glue [plain]

    Code
      cli_bullets(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}", `>` = "arrow {.key {1:3}}", `[]` = "TODO {.key {1:3}}",
        `?` = "question {.key {1:3}}"))
    Message
      noindent [1], [2], and [3]
        space [1], [2], and [3]
      v success [1], [2], and [3]
      x danger [1], [2], and [3]
      ! warning [1], [2], and [3]
      i info [1], [2], and [3]
      * bullet [1], [2], and [3]
      > arrow [1], [2], and [3]
      [ ] TODO [1], [2], and [3]
      (?) question [1], [2], and [3]

# bullets glue [ansi]

    Code
      cli_bullets(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}", `>` = "arrow {.key {1:3}}", `[]` = "TODO {.key {1:3}}",
        `?` = "question {.key {1:3}}"))
    Message
      noindent [34m[1][39m, [34m[2][39m, and [34m[3][39m
        space [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [32mv[39m success [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31mx[39m danger [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [33m![39m warning [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [36mi[39m info [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [36m*[39m bullet [34m[1][39m, [34m[2][39m, and [34m[3][39m
      > arrow [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31m[ ][39m TODO [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31m(?)[39m question [34m[1][39m, [34m[2][39m, and [34m[3][39m

# bullets glue [unicode]

    Code
      cli_bullets(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}", `>` = "arrow {.key {1:3}}", `[]` = "TODO {.key {1:3}}",
        `?` = "question {.key {1:3}}"))
    Message
      noindent [1], [2], and [3]
        space [1], [2], and [3]
      ✔ success [1], [2], and [3]
      ✖ danger [1], [2], and [3]
      ! warning [1], [2], and [3]
      ℹ info [1], [2], and [3]
      • bullet [1], [2], and [3]
      → arrow [1], [2], and [3]
      ☐ TODO [1], [2], and [3]
      ❓ question [1], [2], and [3]

# bullets glue [fancy]

    Code
      cli_bullets(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}", `>` = "arrow {.key {1:3}}", `[]` = "TODO {.key {1:3}}",
        `?` = "question {.key {1:3}}"))
    Message
      noindent [34m[1][39m, [34m[2][39m, and [34m[3][39m
        space [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [32m✔[39m success [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31m✖[39m danger [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [33m![39m warning [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [36mℹ[39m info [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [36m•[39m bullet [34m[1][39m, [34m[2][39m, and [34m[3][39m
      → arrow [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31m☐[39m TODO [34m[1][39m, [34m[2][39m, and [34m[3][39m
      [31m❓[39m question [34m[1][39m, [34m[2][39m, and [34m[3][39m

# bullets wrapping [plain]

    Code
      cli_bullets(c(txt, ` ` = txt, v = txt, x = txt, `!` = txt, i = txt, `*` = txt,
        `>` = txt, `[]` = txt, `?` = txt))
    Message
      This is some text that is longer than the width. This is some text that is
      longer than the width. This is some text that is longer than the width.
        This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      v This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      x This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ! This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      i This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      * This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      > This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [ ] This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      (?) This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.

# bullets wrapping [ansi]

    Code
      cli_bullets(c(txt, ` ` = txt, v = txt, x = txt, `!` = txt, i = txt, `*` = txt,
        `>` = txt, `[]` = txt, `?` = txt))
    Message
      This is some text that is longer than the width. This is some text that is
      longer than the width. This is some text that is longer than the width.
        This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [32mv[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31mx[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [33m![39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [36mi[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [36m*[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      > This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31m[ ][39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31m(?)[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.

# bullets wrapping [unicode]

    Code
      cli_bullets(c(txt, ` ` = txt, v = txt, x = txt, `!` = txt, i = txt, `*` = txt,
        `>` = txt, `[]` = txt, `?` = txt))
    Message
      This is some text that is longer than the width. This is some text that is
      longer than the width. This is some text that is longer than the width.
        This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ✔ This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ✖ This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ! This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ℹ This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      • This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      → This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ☐ This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      ❓ This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.

# bullets wrapping [fancy]

    Code
      cli_bullets(c(txt, ` ` = txt, v = txt, x = txt, `!` = txt, i = txt, `*` = txt,
        `>` = txt, `[]` = txt, `?` = txt))
    Message
      This is some text that is longer than the width. This is some text that is
      longer than the width. This is some text that is longer than the width.
        This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [32m✔[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31m✖[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [33m![39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [36mℹ[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [36m•[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      → This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31m☐[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.
      [31m❓[39m This is some text that is longer than the width. This is some text that is
        longer than the width. This is some text that is longer than the width.

