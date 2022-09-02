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

---

    Code
      cli_text("{.file /absolute/path:12}")
    Message
      '/absolute/path:12'
    Code
      cli_text("{.file file:///absolute/path:5}")
    Message
      'file:///absolute/path:5'
    Code
      cli_text("{.path /absolute/path:123}")
    Message
      '/absolute/path:123'
    Code
      cli_text("{.path file:///absolute/path:51}")
    Message
      'file:///absolute/path:51'

---

    Code
      cli_text("{.file relative/path:12}")
    Message
      'relative/path:12'
    Code
      cli_text("{.file ./relative/path:5}")
    Message
      './relative/path:5'
    Code
      cli_text("{.path relative/path:123}")
    Message
      'relative/path:123'
    Code
      cli_text("{.path ./relative/path:51}")
    Message
      './relative/path:51'

---

    Code
      cli_text("{.file ~/relative/path:12}")
    Message
      '~/relative/path:12'
    Code
      cli_text("{.path ~/relative/path:5}")
    Message
      '~/relative/path:5'

---

    Code
      cli_text("{.file /absolute/path:12:5}")
    Message
      '/absolute/path:12:5'
    Code
      cli_text("{.file file:///absolute/path:5:100}")
    Message
      'file:///absolute/path:5:100'
    Code
      cli_text("{.path /absolute/path:123:1}")
    Message
      '/absolute/path:123:1'
    Code
      cli_text("{.path file:///absolute/path:51:6}")
    Message
      'file:///absolute/path:51:6'

---

    Code
      cli_text("{.file relative/path:12:13}")
    Message
      'relative/path:12:13'
    Code
      cli_text("{.file ./relative/path:5:20}")
    Message
      './relative/path:5:20'
    Code
      cli_text("{.path relative/path:123:21}")
    Message
      'relative/path:123:21'
    Code
      cli_text("{.path ./relative/path:51:2}")
    Message
      './relative/path:51:2'

---

    Code
      cli_text("{.file ~/relative/path:12:23}")
    Message
      '~/relative/path:12:23'
    Code
      cli_text("{.path ~/relative/path:5:2}")
    Message
      '~/relative/path:5:2'

---

    Code
      paths <- c("~/foo", "bar:10", "file:///abs:10:20")
      cli_text("{.file {paths}}")
    Message
      '~/foo', 'bar:10', and 'file:///abs:10:20'

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

---

    Code
      cli_text("{.file /absolute/path:12}")
    Message
      [34m/absolute/path:12[39m
    Code
      cli_text("{.file file:///absolute/path:5}")
    Message
      [34mfile:///absolute/path:5[39m
    Code
      cli_text("{.path /absolute/path:123}")
    Message
      [34m/absolute/path:123[39m
    Code
      cli_text("{.path file:///absolute/path:51}")
    Message
      [34mfile:///absolute/path:51[39m

---

    Code
      cli_text("{.file relative/path:12}")
    Message
      [34mrelative/path:12[39m
    Code
      cli_text("{.file ./relative/path:5}")
    Message
      [34m./relative/path:5[39m
    Code
      cli_text("{.path relative/path:123}")
    Message
      [34mrelative/path:123[39m
    Code
      cli_text("{.path ./relative/path:51}")
    Message
      [34m./relative/path:51[39m

---

    Code
      cli_text("{.file ~/relative/path:12}")
    Message
      [34m~/relative/path:12[39m
    Code
      cli_text("{.path ~/relative/path:5}")
    Message
      [34m~/relative/path:5[39m

---

    Code
      cli_text("{.file /absolute/path:12:5}")
    Message
      [34m/absolute/path:12:5[39m
    Code
      cli_text("{.file file:///absolute/path:5:100}")
    Message
      [34mfile:///absolute/path:5:100[39m
    Code
      cli_text("{.path /absolute/path:123:1}")
    Message
      [34m/absolute/path:123:1[39m
    Code
      cli_text("{.path file:///absolute/path:51:6}")
    Message
      [34mfile:///absolute/path:51:6[39m

---

    Code
      cli_text("{.file relative/path:12:13}")
    Message
      [34mrelative/path:12:13[39m
    Code
      cli_text("{.file ./relative/path:5:20}")
    Message
      [34m./relative/path:5:20[39m
    Code
      cli_text("{.path relative/path:123:21}")
    Message
      [34mrelative/path:123:21[39m
    Code
      cli_text("{.path ./relative/path:51:2}")
    Message
      [34m./relative/path:51:2[39m

---

    Code
      cli_text("{.file ~/relative/path:12:23}")
    Message
      [34m~/relative/path:12:23[39m
    Code
      cli_text("{.path ~/relative/path:5:2}")
    Message
      [34m~/relative/path:5:2[39m

---

    Code
      paths <- c("~/foo", "bar:10", "file:///abs:10:20")
      cli_text("{.file {paths}}")
    Message
      [34m~/foo[39m, [34mbar:10[39m, and [34mfile:///abs:10:20[39m

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

---

    Code
      cli_text("{.file /absolute/path:12}")
    Message
      ']8;line = 12:col = 1;file:///absolute/path/absolute/path:12]8;;'
    Code
      cli_text("{.file file:///absolute/path:5}")
    Message
      ']8;line = 5:col = 1;file:///absolute/pathfile:///absolute/path:5]8;;'
    Code
      cli_text("{.path /absolute/path:123}")
    Message
      ']8;line = 123:col = 1;file:///absolute/path/absolute/path:123]8;;'
    Code
      cli_text("{.path file:///absolute/path:51}")
    Message
      ']8;line = 51:col = 1;file:///absolute/pathfile:///absolute/path:51]8;;'

---

    Code
      cli_text("{.file relative/path:12}")
    Message
      ']8;line = 12:col = 1;file:///testthat/home/relative/pathrelative/path:12]8;;'
    Code
      cli_text("{.file ./relative/path:5}")
    Message
      ']8;line = 5:col = 1;file:///testthat/home/./relative/path./relative/path:5]8;;'
    Code
      cli_text("{.path relative/path:123}")
    Message
      ']8;line = 123:col = 1;file:///testthat/home/relative/pathrelative/path:123]8;;'
    Code
      cli_text("{.path ./relative/path:51}")
    Message
      ']8;line = 51:col = 1;file:///testthat/home/./relative/path./relative/path:51]8;;'

---

    Code
      cli_text("{.file ~/relative/path:12}")
    Message
      ']8;line = 12:col = 1;file:///my/home/relative/path~/relative/path:12]8;;'
    Code
      cli_text("{.path ~/relative/path:5}")
    Message
      ']8;line = 5:col = 1;file:///my/home/relative/path~/relative/path:5]8;;'

---

    Code
      cli_text("{.file /absolute/path:12:5}")
    Message
      ']8;line = 12:col = 5;file:///absolute/path/absolute/path:12:5]8;;'
    Code
      cli_text("{.file file:///absolute/path:5:100}")
    Message
      ']8;line = 5:col = 100;file:///absolute/pathfile:///absolute/path:5:100]8;;'
    Code
      cli_text("{.path /absolute/path:123:1}")
    Message
      ']8;line = 123:col = 1;file:///absolute/path/absolute/path:123:1]8;;'
    Code
      cli_text("{.path file:///absolute/path:51:6}")
    Message
      ']8;line = 51:col = 6;file:///absolute/pathfile:///absolute/path:51:6]8;;'

---

    Code
      cli_text("{.file relative/path:12:13}")
    Message
      ']8;line = 12:col = 13;file:///testthat/home/relative/pathrelative/path:12:13]8;;'
    Code
      cli_text("{.file ./relative/path:5:20}")
    Message
      ']8;line = 5:col = 20;file:///testthat/home/./relative/path./relative/path:5:20]8;;'
    Code
      cli_text("{.path relative/path:123:21}")
    Message
      ']8;line = 123:col = 21;file:///testthat/home/relative/pathrelative/path:123:21]8;;'
    Code
      cli_text("{.path ./relative/path:51:2}")
    Message
      ']8;line = 51:col = 2;file:///testthat/home/./relative/path./relative/path:51:2]8;;'

---

    Code
      cli_text("{.file ~/relative/path:12:23}")
    Message
      ']8;line = 12:col = 23;file:///my/home/relative/path~/relative/path:12:23]8;;'
    Code
      cli_text("{.path ~/relative/path:5:2}")
    Message
      ']8;line = 5:col = 2;file:///my/home/relative/path~/relative/path:5:2]8;;'

---

    Code
      paths <- c("~/foo", "bar:10", "file:///abs:10:20")
      cli_text("{.file {paths}}")
    Message
      ']8;;file:///my/home/foo~/foo]8;;', ']8;line = 10:col = 1;file:///testthat/home/barbar:10]8;;', and ']8;line = 10:col = 20;file:///absfile:///abs:10:20]8;;'

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

---

    Code
      cli_text("{.file /absolute/path:12}")
    Message
      ]8;line = 12:col = 1;file:///absolute/path[34m/absolute/path:12[39m]8;;
    Code
      cli_text("{.file file:///absolute/path:5}")
    Message
      ]8;line = 5:col = 1;file:///absolute/path[34mfile:///absolute/path:5[39m]8;;
    Code
      cli_text("{.path /absolute/path:123}")
    Message
      ]8;line = 123:col = 1;file:///absolute/path[34m/absolute/path:123[39m]8;;
    Code
      cli_text("{.path file:///absolute/path:51}")
    Message
      ]8;line = 51:col = 1;file:///absolute/path[34mfile:///absolute/path:51[39m]8;;

---

    Code
      cli_text("{.file relative/path:12}")
    Message
      ]8;line = 12:col = 1;file:///testthat/home/relative/path[34mrelative/path:12[39m]8;;
    Code
      cli_text("{.file ./relative/path:5}")
    Message
      ]8;line = 5:col = 1;file:///testthat/home/./relative/path[34m./relative/path:5[39m]8;;
    Code
      cli_text("{.path relative/path:123}")
    Message
      ]8;line = 123:col = 1;file:///testthat/home/relative/path[34mrelative/path:123[39m]8;;
    Code
      cli_text("{.path ./relative/path:51}")
    Message
      ]8;line = 51:col = 1;file:///testthat/home/./relative/path[34m./relative/path:51[39m]8;;

---

    Code
      cli_text("{.file ~/relative/path:12}")
    Message
      ]8;line = 12:col = 1;file:///my/home/relative/path[34m~/relative/path:12[39m]8;;
    Code
      cli_text("{.path ~/relative/path:5}")
    Message
      ]8;line = 5:col = 1;file:///my/home/relative/path[34m~/relative/path:5[39m]8;;

---

    Code
      cli_text("{.file /absolute/path:12:5}")
    Message
      ]8;line = 12:col = 5;file:///absolute/path[34m/absolute/path:12:5[39m]8;;
    Code
      cli_text("{.file file:///absolute/path:5:100}")
    Message
      ]8;line = 5:col = 100;file:///absolute/path[34mfile:///absolute/path:5:100[39m]8;;
    Code
      cli_text("{.path /absolute/path:123:1}")
    Message
      ]8;line = 123:col = 1;file:///absolute/path[34m/absolute/path:123:1[39m]8;;
    Code
      cli_text("{.path file:///absolute/path:51:6}")
    Message
      ]8;line = 51:col = 6;file:///absolute/path[34mfile:///absolute/path:51:6[39m]8;;

---

    Code
      cli_text("{.file relative/path:12:13}")
    Message
      ]8;line = 12:col = 13;file:///testthat/home/relative/path[34mrelative/path:12:13[39m]8;;
    Code
      cli_text("{.file ./relative/path:5:20}")
    Message
      ]8;line = 5:col = 20;file:///testthat/home/./relative/path[34m./relative/path:5:20[39m]8;;
    Code
      cli_text("{.path relative/path:123:21}")
    Message
      ]8;line = 123:col = 21;file:///testthat/home/relative/path[34mrelative/path:123:21[39m]8;;
    Code
      cli_text("{.path ./relative/path:51:2}")
    Message
      ]8;line = 51:col = 2;file:///testthat/home/./relative/path[34m./relative/path:51:2[39m]8;;

---

    Code
      cli_text("{.file ~/relative/path:12:23}")
    Message
      ]8;line = 12:col = 23;file:///my/home/relative/path[34m~/relative/path:12:23[39m]8;;
    Code
      cli_text("{.path ~/relative/path:5:2}")
    Message
      ]8;line = 5:col = 2;file:///my/home/relative/path[34m~/relative/path:5:2[39m]8;;

---

    Code
      paths <- c("~/foo", "bar:10", "file:///abs:10:20")
      cli_text("{.file {paths}}")
    Message
      ]8;;file:///my/home/foo[34m~/foo[39m]8;;, ]8;line = 10:col = 1;file:///testthat/home/bar[34mbar:10[39m]8;;, and ]8;line = 10:col = 20;file:///abs[34mfile:///abs:10:20[39m]8;;

# {.fun} [plain-none]

    Code
      cli_text("{.fun myfun}")
    Message
      `myfun()`
    Code
      cli_text("{.fun mypackage::myfun}")
    Message
      `mypackage::myfun()`

---

    Code
      funs <- paste0("mypkg::myfun", 1:3)
      cli_text("{.fun {funs}}")
    Message
      `mypkg::myfun1()`, `mypkg::myfun2()`, and `mypkg::myfun3()`

# {.fun} [plain-all]

    Code
      cli_text("{.fun myfun}")
    Message
      `myfun()`
    Code
      cli_text("{.fun mypackage::myfun}")
    Message
      `]8;;x-r-help:mypackage::myfunmypackage::myfun]8;;()`

---

    Code
      funs <- paste0("mypkg::myfun", 1:3)
      cli_text("{.fun {funs}}")
    Message
      `]8;;x-r-help:mypkg::myfun1mypkg::myfun1]8;;()`, `]8;;x-r-help:mypkg::myfun2mypkg::myfun2]8;;()`, and `]8;;x-r-help:mypkg::myfun3mypkg::myfun3]8;;()`

# turning off help [plain-all]

    Code
      cli_text("{.fun pkg::func}")
    Message
      `pkg::func()`

# {.help} [plain-none]

    Code
      cli_text("{.help pkg::fun}")
    Message
      `?pkg::fun()`
    Code
      cli_text("{.help [link text](pkg::fun)}")
    Message
      link text (`?pkg::fun()`)

---

    Code
      funcs <- paste0("pkg::fun", 1:3)
      cli_text("{.help {funcs}}")
    Message
      `?pkg::fun1()`, `?pkg::fun2()`, and `?pkg::fun3()`

# {.help} [plain-all]

    Code
      cli_text("{.help pkg::fun}")
    Message
      ]8;;x-r-help:pkg::funpkg::fun]8;;
    Code
      cli_text("{.help [link text](pkg::fun)}")
    Message
      ]8;;x-r-help:pkg::funlink text]8;;

---

    Code
      funcs <- paste0("pkg::fun", 1:3)
      cli_text("{.help {funcs}}")
    Message
      ]8;;x-r-help:pkg::fun1pkg::fun1]8;;, ]8;;x-r-help:pkg::fun2pkg::fun2]8;;, and ]8;;x-r-help:pkg::fun3pkg::fun3]8;;

# {.href} [plain-none]

    Code
      cli_text("{.href https://cli.r-lib.org}")
    Message
      <https://cli.r-lib.org>
    Code
      cli_text("{.href [linktext](https://cli.r-lib.org)}")
    Message
      linktext (<https://cli.r-lib.org>)
    Code
      cli_text("{.href [link text](https://cli.r-lib.org)}")
    Message
      link text (<https://cli.r-lib.org>)

# {.href} [plain-all]

    Code
      cli_text("{.href https://cli.r-lib.org}")
    Message
      <]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;>
    Code
      cli_text("{.href [linktext](https://cli.r-lib.org)}")
    Message
      ]8;;https://cli.r-lib.orglinktext]8;;
    Code
      cli_text("{.href [link text](https://cli.r-lib.org)}")
    Message
      ]8;;https://cli.r-lib.orglink text]8;;

# {.href} vectors [plain-none]

    Code
      url <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.href {url}}")
    Message
      <https://cli.r-lib.org/1>, <https://cli.r-lib.org/2>, and
      <https://cli.r-lib.org/3>

# {.href} vectors [plain-all]

    Code
      url <- paste0("https://cli.r-lib.org/", 1:3)
      cli_text("{.href {url}}")
    Message
      <]8;;https://cli.r-lib.org/1https://cli.r-lib.org/1]8;;>, <]8;;https://cli.r-lib.org/2https://cli.r-lib.org/2]8;;>, and
      <]8;;https://cli.r-lib.org/3https://cli.r-lib.org/3]8;;>

# {.topic} [plain-none]

    Code
      cli_text("{.topic pkg::topic}")
    Message
      `?pkg::topic`
    Code
      cli_text("{.topic [link text](pkg::topic)}")
    Message
      link text (`?pkg::topic`)

---

    Code
      topics <- paste0("pkg::topic", 1:3)
      cli_text("{.topic {topics}}")
    Message
      `?pkg::topic1`, `?pkg::topic2`, and `?pkg::topic3`

# {.topic} [plain-all]

    Code
      cli_text("{.topic pkg::topic}")
    Message
      ]8;;x-r-help:pkg::topicpkg::topic]8;;
    Code
      cli_text("{.topic [link text](pkg::topic)}")
    Message
      ]8;;x-r-help:pkg::topiclink text]8;;

---

    Code
      topics <- paste0("pkg::topic", 1:3)
      cli_text("{.topic {topics}}")
    Message
      ]8;;x-r-help:pkg::topic1pkg::topic1]8;;, ]8;;x-r-help:pkg::topic2pkg::topic2]8;;, and ]8;;x-r-help:pkg::topic3pkg::topic3]8;;

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

# linked {.url} [plain-all]

    Code
      link <- c("https://cli.r-lib.org", style_hyperlink("text",
        "https://cli.r-lib.org"))
      cli_text("{.url {link}}")
    Message
      <]8;;https://cli.r-lib.orghttps://cli.r-lib.org]8;;> and <]8;;https://cli.r-lib.orgtext]8;;>

# {.vignette} [plain-none]

    Code
      cli_text("{.vignette pkg::name}")
    Message
      `vignette(pkg::name)`
    Code
      cli_text("{.vignette [link text](pkg::name)}")
    Message
      link text (`vignette(pkg::name)`)

---

    Code
      vignettes <- paste0("pkg::topic", 1:3)
      cli_text("{.vignette {vignettes}}")
    Message
      `vignette(pkg::topic1)`, `vignette(pkg::topic2)`, and `vignette(pkg::topic3)`

# {.vignette} [plain-all]

    Code
      cli_text("{.vignette pkg::name}")
    Message
      ]8;;x-r-vignette:pkg::namepkg::name]8;;
    Code
      cli_text("{.vignette [link text](pkg::name)}")
    Message
      ]8;;x-r-vignette:pkg::namelink text]8;;

---

    Code
      vignettes <- paste0("pkg::topic", 1:3)
      cli_text("{.vignette {vignettes}}")
    Message
      ]8;;x-r-vignette:pkg::topic1pkg::topic1]8;;, ]8;;x-r-vignette:pkg::topic2pkg::topic2]8;;, and ]8;;x-r-vignette:pkg::topic3pkg::topic3]8;;

