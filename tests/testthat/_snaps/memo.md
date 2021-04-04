# memo [plain]

    Code
      cli_memo(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet"))
    Message <cliMessage>
      noindent
        space
        v success
        x danger
        ! warning
        i info
        * bullet

# memo [ansi]

    Code
      cli_memo(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet"))
    Message <cliMessage>
      noindent
        space
        [32mv[39m success
        [31mx[39m danger
        [33m![39m warning
        [36mi[39m info
        [36m*[39m bullet

# memo [unicode]

    Code
      cli_memo(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet"))
    Message <cliMessage>
      noindent
        space
        ✔ success
        ✖ danger
        ! warning
        ℹ info
        ● bullet

# memo [fancy]

    Code
      cli_memo(c("noindent", ` ` = "space", v = "success", x = "danger", `!` = "warning",
        i = "info", `*` = "bullet"))
    Message <cliMessage>
      noindent
        space
        [32m✔[39m success
        [31m✖[39m danger
        [33m![39m warning
        [36mℹ[39m info
        [36m●[39m bullet

# memo glue [plain]

    Code
      cli_memo(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}"))
    Message <cliMessage>
      noindent [1], [2], and [3]
        space [1], [2], and [3]
        v success [1], [2], and [3]
        x danger [1], [2], and [3]
        ! warning [1], [2], and [3]
        i info [1], [2], and [3]
        * bullet [1], [2], and [3]

# memo glue [ansi]

    Code
      cli_memo(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}"))
    Message <cliMessage>
      noindent [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        space [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [32mv[39m success [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [31mx[39m danger [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [33m![39m warning [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [36mi[39m info [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [36m*[39m bullet [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m

# memo glue [unicode]

    Code
      cli_memo(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}"))
    Message <cliMessage>
      noindent [1], [2], and [3]
        space [1], [2], and [3]
        ✔ success [1], [2], and [3]
        ✖ danger [1], [2], and [3]
        ! warning [1], [2], and [3]
        ℹ info [1], [2], and [3]
        ● bullet [1], [2], and [3]

# memo glue [fancy]

    Code
      cli_memo(c("noindent {.key {1:3}}", ` ` = "space {.key {1:3}}", v = "success {.key {1:3}}",
        x = "danger {.key {1:3}}", `!` = "warning {.key {1:3}}", i = "info {.key {1:3}}",
        `*` = "bullet {.key {1:3}}"))
    Message <cliMessage>
      noindent [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        space [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [32m✔[39m success [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [31m✖[39m danger [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [33m![39m warning [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [36mℹ[39m info [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m
        [36m●[39m bullet [34m[34m[1][34m[39m, [34m[34m[2][34m[39m, and [34m[34m[3][34m[39m

