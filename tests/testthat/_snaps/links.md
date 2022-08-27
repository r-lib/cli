# {.url} [plain-none]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      <https://cli.r-lib.org>

# {.url} [fancy-none]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      [3m[34m<https://cli.r-lib.org>[39m[23m

# {.url} [plain-all]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      <]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;>

# {.url} [fancy-all]

    Code
      cli_text("{.url https://cli.r-lib.org}")
    Message
      [3m[34m<]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;>[39m[23m

# {.url} vector [plain-none]

    Code
      urls <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.url {urls}}")
    Message
      <https://cli.r-lib.org/1>, <https://cli.r-lib.org/2>, and
      <https://cli.r-lib.org/3>

# {.url} vector [fancy-none]

    Code
      urls <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.url {urls}}")
    Message
      [3m[34m<https://cli.r-lib.org/1>[39m[23m, [3m[34m<https://cli.r-lib.org/2>[39m[23m, and
      [3m[34m<https://cli.r-lib.org/3>[39m[23m

# {.url} vector [plain-all]

    Code
      urls <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.url {urls}}")
    Message
      <]8;;https://cli.r-lib.org/1https://cli.r-lib.org/1]8;;>, <]8;;https://cli.r-lib.org/2https://cli.r-lib.org/2]8;;>, and
      <]8;;https://cli.r-lib.org/3https://cli.r-lib.org/3]8;;>

# {.url} vector [fancy-all]

    Code
      urls <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.url {urls}}")
    Message
      [3m[34m<]8;;https://cli.r-lib.org/1https://cli.r-lib.org/1]8;;>[39m[23m, [3m[34m<]8;;https://cli.r-lib.org/2https://cli.r-lib.org/2]8;;>[39m[23m, and
      [3m[34m<]8;;https://cli.r-lib.org/3https://cli.r-lib.org/3]8;;>[39m[23m

# {.file} and {.path} [plain-none]

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

# {.file} and {.path} [fancy-none]

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

# {.file} and {.path} [plain-all]

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

# {.file} and {.path} [fancy-all]

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

# {.email} [plain-none]

    Code
      cli_text("{.email bugs.bunny@acme.com}")
    Message
      'bugs.bunny@acme.com'

# {.email} [fancy-none]

    Code
      cli_text("{.email bugs.bunny@acme.com}")
    Message
      [34mbugs.bunny@acme.com[39m

# {.email} [plain-all]

    Code
      cli_text("{.email bugs.bunny@acme.com}")
    Message
      ']8;;mailto:bugs.bunny@acme.combugs.bunny@acme.com]8;;'

# {.email} [fancy-all]

    Code
      cli_text("{.email bugs.bunny@acme.com}")
    Message
      ]8;;mailto:bugs.bunny@acme.com[34mbugs.bunny@acme.com[39m]8;;

# {.email} vectors [plain-none]

    Code
      emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
      cli_text("{.email {emails}}")
    Message
      'bugs.bunny-1@acme.com', 'bugs.bunny-2@acme.com', and 'bugs.bunny-3@acme.com'

# {.email} vectors [fancy-none]

    Code
      emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
      cli_text("{.email {emails}}")
    Message
      [34mbugs.bunny-1@acme.com[39m, [34mbugs.bunny-2@acme.com[39m, and [34mbugs.bunny-3@acme.com[39m

# {.email} vectors [plain-all]

    Code
      emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
      cli_text("{.email {emails}}")
    Message
      ']8;;mailto:bugs.bunny-1@acme.combugs.bunny-1@acme.com]8;;', ']8;;mailto:bugs.bunny-2@acme.combugs.bunny-2@acme.com]8;;', and ']8;;mailto:bugs.bunny-3@acme.combugs.bunny-3@acme.com]8;;'

# {.email} vectors [fancy-all]

    Code
      emails <- paste0("bugs.bunny-", 1:3, "@acme.com")
      cli_text("{.email {emails}}")
    Message
      ]8;;mailto:bugs.bunny-1@acme.com[34mbugs.bunny-1@acme.com[39m]8;;, ]8;;mailto:bugs.bunny-2@acme.com[34mbugs.bunny-2@acme.com[39m]8;;, and ]8;;mailto:bugs.bunny-3@acme.com[34mbugs.bunny-3@acme.com[39m]8;;

# {.href} [plain-none]

    Code
      cli_text("{.href https://cli.r-lib.org}")
    Message
      https://cli.r-lib.org
    Code
      cli_text("{.href https://cli.r-lib.org linktext}")
    Message
      linktext (https://cli.r-lib.org)
    Code
      cli_text("{.href https://cli.r-lib.org link text}")
    Message
      link text (https://cli.r-lib.org)

# {.href} [plain-all]

    Code
      cli_text("{.href https://cli.r-lib.org}")
    Message
      ]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;
    Code
      cli_text("{.href https://cli.r-lib.org linktext}")
    Message
      ]8;;https://cli.r-lib.orglinktext]8;;
    Code
      cli_text("{.href https://cli.r-lib.org link text}")
    Message
      ]8;;https://cli.r-lib.orglink text]8;;

# {.href} vectors [plain-none]

    Code
      url <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.href {url}}")
    Message
      https://cli.r-lib.org/1, https://cli.r-lib.org/2, and https://cli.r-lib.org/3

---

    Code
      url <- structure(paste0("https://cli.r-lib.org/", 1:3), names = letters[1:3])
      cli_text("{.href {url}}")
    Message
      a (https://cli.r-lib.org/1), b (https://cli.r-lib.org/2), and c
      (https://cli.r-lib.org/3)

# {.href} vectors [plain-all]

    Code
      url <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.href {url}}")
    Message
      ]8;;https://cli.r-lib.org/1https://cli.r-lib.org/1]8;;, ]8;;https://cli.r-lib.org/2https://cli.r-lib.org/2]8;;, and ]8;;https://cli.r-lib.org/3https://cli.r-lib.org/3]8;;

---

    Code
      url <- structure(paste0("https://cli.r-lib.org/", 1:3), names = letters[1:3])
      cli_text("{.href {url}}")
    Message
      ]8;;https://cli.r-lib.org/1a]8;;, ]8;;https://cli.r-lib.org/2b]8;;, and ]8;;https://cli.r-lib.org/3c]8;;

