builtin_theme2 <- function(dark = getOption("cli.theme_dark", "auto")) {

    dark <- detect_dark_theme(dark)

    list(
      body = list(
        "class-map" = list(
          fs_path = "file",
          "cli-progress-bar" = "progress-bar"
        )
      ),

      h1 = list(
        "font-weight" = "bold",
        "margin-top" = 1,
        "margin-bottom" = 0,
        fmt = function(x) cli::rule(x, line_col = "cyan")),
      h2 = list(
        "font-weight" = "bold",
        "margin-top" = 1,
        "margin-bottom" = 1,
        fmt = function(x) paste0(symbol$line, symbol$line, " ", x, " ",
                                 symbol$line, symbol$line)),
      h3 = list(
        "margin-top" = 1,
        fmt = function(x) paste0(symbol$line, symbol$line, " ", x, " ")),

      ".alert" = list(
        before = function() paste0(symbol$arrow_right, " ")
      ),
      ".alert-success" = list(
        before = function() paste0(col_green(symbol$tick), " ")
      ),
      ".alert-danger" = list(
        before = function() paste0(col_red(symbol$cross), " ")
      ),
      ".alert-warning" = list(
        before = function() paste0(col_yellow("!"), " ")
      ),
      ".alert-info" = list(
        before = function() paste0(col_cyan(symbol$info), " ")
      ),

      ".bullets .bullet-empty" = list(),
      ".bullets .bullet-space" = list("margin-left" = 2),
      ".bullets .bullet-v" = list(
        "text-exdent" = 2,
        before = function(x) paste0(col_green(symbol$tick), " ")
      ),
      ".bullets .bullet-x" = list(
        "text-exdent" = 2,
        before = function(x) paste0(col_red(symbol$cross), " ")
      ),
      ".bullets .bullet-!" = list(
        "text-exdent" = 2,
        before = function(x) paste0(col_yellow("!"), " ")
      ),
      ".bullets .bullet-i" = list(
        "text-exdent" = 2,
        before = function(x) paste0(col_cyan(symbol$info), " ")
      ),
      ".bullets .bullet-*" = list(
        "text-exdent" = 2,
        before = function(x) paste0(col_cyan(symbol$bullet), " ")
      ),
      ".bullets .bullet->" = list(
        "text-exdent" = 2,
        before = function(x) paste0(symbol$arrow_right, " ")
      ),
      ".bullets .bullet-1" = list(
      ),

      par = list("margin-top" = 0, "margin-bottom" = 1),
      ul = list(
        "list-style-type" = function() symbol$bullet
      ),
      ol = list(
        "list-style-type" = "decimal"
      ),

      # these are tags in HTML, but in cli they are inline
      span.dt = list(postfix = ": "),
      span.dd = list(),

      blockquote = list("padding-left" = 4L, "padding-right" = 10L,
                        "font-style" = "italic", "margin-top" = 1L,
                        "margin-bottom" = 1L,
                        before = function() symbol$dquote_left,
                        after = function() symbol$dquote_right),
      "blockquote cite" = list(
        before = function() paste0(symbol$em_dash, " "),
        "font-style" = "italic",
        "font-weight" = "bold"
      ),

      .code = list(fmt = format_code(dark)),
      .code.R = list(fmt = format_r_code(dark)),

      span.emph = list("font-style" = "italic"),
      span.strong = list("font-weight" = "bold"),
      span.code = theme_code_tick(dark),

      span.q   = list(fmt = quote_weird_name2),
      span.pkg = list(color = "blue"),
      span.fn = theme_function(dark),
      span.fun = theme_function(dark),
      span.arg = theme_code_tick(dark),
      span.kbd = list(before = "[", after = "]", color = "blue"),
      span.key = list(before = "[", after = "]", color = "blue"),
      span.file = theme_file(),
      span.path = theme_file(),
      span.email = list(
        color = "blue",
        transform = function(x) make_link(x, type = "email"),
        fmt = quote_weird_name
      ),
      span.url = list(
        before = "<", after = ">",
        color = "blue", "font-style" = "italic",
        transform = function(x) make_link(x, type = "url")
      ),
      span.href = list(
        transform = function(x) make_link(x, type = "href")
      ),
      span.help = list(
        transform = function(x) make_link(x, type = "help")
      ),
      span.topic = list(
        transform = function(x) make_link(x, type = "topic")
      ),
      span.vignette = list(
        transform = function(x) make_link(x, type = "vignette")
      ),
      span.run = list(
        transform = function(x) make_link(x, type = "run")
      ),
      span.var = theme_code_tick(dark),
      span.col = theme_code_tick(dark),
      span.str = list(fmt = encode_string),
      span.envvar = theme_code_tick(dark),
      span.val = list(
        transform = function(x, ...) cli_format(x, ...),
        color = "blue"
      ),
      span.field = list(color = "green"),
      span.cls = list(collapse = "/", color = "blue", before = "<", after = ">"),
      "span.progress-bar" = list(
        transform = theme_progress_bar,
        color = "green"
      ),
      span.obj_type_friendly = list(
        transform = function(x) format_inline(typename(x))
      ),
      span.type = list(
        transform = function(x) format_inline(typename(x))
      ),
      span.or = list("vec-sep2" = " or ", "vec-last" = ", or "),
      span.timestamp = list(before = "[", after = "]", color = "grey")
    )
  }
