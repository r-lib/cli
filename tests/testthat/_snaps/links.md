# {.url} [plain-none]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      <https://cli.r-lib.org>

---

    Code
      cli_text("{.file /absolute/path}")
    Message
      '/absolute/path'
    Code
      cli_text("{.file file:///absolute/path}")
    Message
      'file:///absolute/path'
    Code
      cli_text("{.path /absolute/path}")
    Message
      '/absolute/path'
    Code
      cli_text("{.path file:///absolute/path}")
    Message
      'file:///absolute/path'

---

    Code
      cli_text("{.file relative/path}")
    Message
      'relative/path'
    Code
      cli_text("{.file ./relative/path}")
    Message
      './relative/path'
    Code
      cli_text("{.path relative/path}")
    Message
      'relative/path'
    Code
      cli_text("{.path ./relative/path}")
    Message
      './relative/path'

---

    Code
      cli_text("{.file ~/relative/path}")
    Message
      '~/relative/path'
    Code
      cli_text("{.path ~/relative/path}")
    Message
      '~/relative/path'

---

    Code
      paths <- c("~/foo", "bar", "file:///abs")
      cli_text("{.file {paths}}")
    Message
      '~/foo', 'bar', and 'file:///abs'

---

    Code
      paths <- c("foo  ", " bar ", "file:///a bs ")
      cli_text("{.file {paths}}")
    Message
      'foo  ', ' bar ', and 'file:///a bs '

---

    Code
      name <- cli::style_hyperlink("/foo/bar", "/foo/bar")
      cli_text("{.file {name}}")
    Message
      '/foo/bar'

# {.url} [fancy-none]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      [3m[34m<https://cli.r-lib.org>[39m[23m

---

    Code
      cli_text("{.file /absolute/path}")
    Message
      [34m/absolute/path[39m
    Code
      cli_text("{.file file:///absolute/path}")
    Message
      [34mfile:///absolute/path[39m
    Code
      cli_text("{.path /absolute/path}")
    Message
      [34m/absolute/path[39m
    Code
      cli_text("{.path file:///absolute/path}")
    Message
      [34mfile:///absolute/path[39m

---

    Code
      cli_text("{.file relative/path}")
    Message
      [34mrelative/path[39m
    Code
      cli_text("{.file ./relative/path}")
    Message
      [34m./relative/path[39m
    Code
      cli_text("{.path relative/path}")
    Message
      [34mrelative/path[39m
    Code
      cli_text("{.path ./relative/path}")
    Message
      [34m./relative/path[39m

---

    Code
      cli_text("{.file ~/relative/path}")
    Message
      [34m~/relative/path[39m
    Code
      cli_text("{.path ~/relative/path}")
    Message
      [34m~/relative/path[39m

---

    Code
      paths <- c("~/foo", "bar", "file:///abs")
      cli_text("{.file {paths}}")
    Message
      [34m~/foo[39m, [34mbar[39m, and [34mfile:///abs[39m

---

    Code
      paths <- c("foo  ", " bar ", "file:///a bs ")
      cli_text("{.file {paths}}")
    Message
      '[34mfoo[39m[44m  [49m', '[44m [49m[34mbar[39m[44m [49m', and '[34mfile:///a bs[39m[44m [49m'

---

    Code
      name <- cli::style_hyperlink("/foo/bar", "/foo/bar")
      cli_text("{.file {name}}")
    Message
      [34m/foo/bar[39m

# {.url} [plain-all]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      <]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;>

---

    Code
      cli_text("{.file /absolute/path}")
    Message
      ']8;;file:///absolute/path/absolute/path]8;;'
    Code
      cli_text("{.file file:///absolute/path}")
    Message
      ']8;;file:///absolute/pathfile:///absolute/path]8;;'
    Code
      cli_text("{.path /absolute/path}")
    Message
      ']8;;file:///absolute/path/absolute/path]8;;'
    Code
      cli_text("{.path file:///absolute/path}")
    Message
      ']8;;file:///absolute/pathfile:///absolute/path]8;;'

---

    Code
      cli_text("{.file relative/path}")
    Message
      ']8;;file:///testthat/home/relative/pathrelative/path]8;;'
    Code
      cli_text("{.file ./relative/path}")
    Message
      ']8;;file:///testthat/home/./relative/path./relative/path]8;;'
    Code
      cli_text("{.path relative/path}")
    Message
      ']8;;file:///testthat/home/relative/pathrelative/path]8;;'
    Code
      cli_text("{.path ./relative/path}")
    Message
      ']8;;file:///testthat/home/./relative/path./relative/path]8;;'

---

    Code
      cli_text("{.file ~/relative/path}")
    Message
      ']8;;file:///my/home/relative/path~/relative/path]8;;'
    Code
      cli_text("{.path ~/relative/path}")
    Message
      ']8;;file:///my/home/relative/path~/relative/path]8;;'

---

    Code
      paths <- c("~/foo", "bar", "file:///abs")
      cli_text("{.file {paths}}")
    Message
      ']8;;file:///my/home/foo~/foo]8;;', ']8;;file:///testthat/home/barbar]8;;', and ']8;;file:///absfile:///abs]8;;'

---

    Code
      paths <- c("foo  ", " bar ", "file:///a bs ")
      cli_text("{.file {paths}}")
    Message
      ']8;;file:///testthat/home/foo  foo]8;;  ', ' ]8;;file:///testthat/home/ bar bar]8;; ', and ']8;;file:///a bs file:///a bs]8;; '

---

    Code
      name <- cli::style_hyperlink("/foo/bar", "/foo/bar")
      cli_text("{.file {name}}")
    Message
      ']8;;/foo/bar/foo/bar]8;;'

# {.url} [fancy-all]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      [3m[34m<]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;>[39m[23m

---

    Code
      cli_text("{.file /absolute/path}")
    Message
      ]8;;file:///absolute/path[34m/absolute/path[39m]8;;
    Code
      cli_text("{.file file:///absolute/path}")
    Message
      ]8;;file:///absolute/path[34mfile:///absolute/path[39m]8;;
    Code
      cli_text("{.path /absolute/path}")
    Message
      ]8;;file:///absolute/path[34m/absolute/path[39m]8;;
    Code
      cli_text("{.path file:///absolute/path}")
    Message
      ]8;;file:///absolute/path[34mfile:///absolute/path[39m]8;;

---

    Code
      cli_text("{.file relative/path}")
    Message
      ]8;;file:///testthat/home/relative/path[34mrelative/path[39m]8;;
    Code
      cli_text("{.file ./relative/path}")
    Message
      ]8;;file:///testthat/home/./relative/path[34m./relative/path[39m]8;;
    Code
      cli_text("{.path relative/path}")
    Message
      ]8;;file:///testthat/home/relative/path[34mrelative/path[39m]8;;
    Code
      cli_text("{.path ./relative/path}")
    Message
      ]8;;file:///testthat/home/./relative/path[34m./relative/path[39m]8;;

---

    Code
      cli_text("{.file ~/relative/path}")
    Message
      ]8;;file:///my/home/relative/path[34m~/relative/path[39m]8;;
    Code
      cli_text("{.path ~/relative/path}")
    Message
      ]8;;file:///my/home/relative/path[34m~/relative/path[39m]8;;

---

    Code
      paths <- c("~/foo", "bar", "file:///abs")
      cli_text("{.file {paths}}")
    Message
      ]8;;file:///my/home/foo[34m~/foo[39m]8;;, ]8;;file:///testthat/home/bar[34mbar[39m]8;;, and ]8;;file:///abs[34mfile:///abs[39m]8;;

---

    Code
      paths <- c("foo  ", " bar ", "file:///a bs ")
      cli_text("{.file {paths}}")
    Message
      ']8;;file:///testthat/home/foo  [34mfoo[39m]8;;[44m  [49m', '[44m [49m]8;;file:///testthat/home/ bar [34mbar[39m]8;;[44m [49m', and ']8;;file:///a bs [34mfile:///a bs[39m]8;;[44m [49m'

---

    Code
      name <- cli::style_hyperlink("/foo/bar", "/foo/bar")
      cli_text("{.file {name}}")
    Message
      ]8;;/foo/bar[34m/foo/bar[39m]8;;

