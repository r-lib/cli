# simplest

    Code
      for (n in 0:2) cli_text("{n} package{?s}")
    Message <cliMessage>
      0 packages
      1 package
      2 packages
    Code
      for (n in 0:2) print(pluralize("{n} package{?s}"))
    Output
      0 packages
      1 package
      2 packages

# irregular

    Code
      for (n in 0:2) cli_text("{n} dictionar{?y/ies}")
    Message <cliMessage>
      0 dictionaries
      1 dictionary
      2 dictionaries
    Code
      for (n in 0:2) print(pluralize("{n} dictionar{?y/ies}"))
    Output
      0 dictionaries
      1 dictionary
      2 dictionaries

# multiple substitutions

    Code
      for (n in 0:2) cli_text("{n} package{?s} {?is/are} ...")
    Message <cliMessage>
      0 packages are ...
      1 package is ...
      2 packages are ...
    Code
      for (n in 0:2) print(pluralize("{n} package{?s} {?is/are} ..."))
    Output
      0 packages are ...
      1 package is ...
      2 packages are ...

# multiple quantities

    Code
      for (m in 0:2) for (n in 0:2) cli_text("{m} package{?s} and {n} folder{?s}")
    Message <cliMessage>
      0 packages and 0 folders
      0 packages and 1 folder
      0 packages and 2 folders
      1 package and 0 folders
      1 package and 1 folder
      1 package and 2 folders
      2 packages and 0 folders
      2 packages and 1 folder
      2 packages and 2 folders
    Code
      for (m in 0:2) for (n in 0:2) print(pluralize(
        "{m} package{?s} and {n} folder{?s}"))
    Output
      0 packages and 0 folders
      0 packages and 1 folder
      0 packages and 2 folders
      1 package and 0 folders
      1 package and 1 folder
      1 package and 2 folders
      2 packages and 0 folders
      2 packages and 1 folder
      2 packages and 2 folders

# no()

    Code
      for (n in 0:2) cli_text("{no(n)} package{?s}")
    Message <cliMessage>
      no packages
      1 package
      2 packages
    Code
      for (n in 0:2) print(pluralize("{no(n)} package{?s}"))
    Output
      no packages
      1 package
      2 packages

# set qty() explicitly

    Code
      for (n in 0:2) cli_text("{qty(n)}There {?is/are} {n} package{?s}")
    Message <cliMessage>
      There are 0 packages
      There is 1 package
      There are 2 packages
    Code
      for (n in 0:2) print(pluralize("{qty(n)}There {?is/are} {n} package{?s}"))
    Output
      There are 0 packages
      There is 1 package
      There are 2 packages

# collapsing vectors

    Code
      pkgs <- (function(n) glue("pkg{seq_len(n)}"))
      for (n in 1:3) cli_text("The {pkgs(n)} package{?s}")
    Message <cliMessage>
      The pkg1 package
      The pkg1 and pkg2 packages
      The pkg1, pkg2, and pkg3 packages
    Code
      for (n in 1:3) print(pluralize("The {pkgs(n)} package{?s}"))
    Output
      The pkg1 package
      The pkg1 and pkg2 packages
      The pkg1, pkg2, and pkg3 packages

# pluralization and style

    Code
      special_style <- list(span.foo = list(before = "<", after = ">"))
      cli_div(theme = special_style)
      for (n in 0:2) cli_text("{n} {.foo package{?s}}")
    Message <cliMessage>
      0 packages
      1 package
      2 packages

---

    Code
      pkgs <- (function(n) glue("pkg{seq_len(n)}"))
      for (n in 1:3) cli_text("The {.foo {pkgs(n)}} package{?s}")
    Message <cliMessage>
      The pkg1 package
      The pkg1 and pkg2 packages
      The pkg1, pkg2, and pkg3 packages

# post-processing

    Code
      for (n in 0:2) cli_text("Package{?s}: {n}")
    Message <cliMessage>
      Packages: 0
      Package: 1
      Packages: 2

---

    Code
      pkgs <- (function(n) glue("pkg{seq_len(n)}"))
      for (n in 1:2) cli_text("Package{?s}: {pkgs(n)}")
    Message <cliMessage>
      Package: pkg1
      Packages: pkg1 and pkg2
    Code
      for (n in 1:2) print(pluralize("Package{?s}: {pkgs(n)}"))
    Output
      Package: pkg1
      Packages: pkg1 and pkg2

# issue 158

    Code
      print(pluralize("{0} word{?A/B/}"))
    Output
      0 wordA
    Code
      print(pluralize("{1} word{?A/B/}"))
    Output
      1 wordB
    Code
      print(pluralize("{9} word{?A/B/}"))
    Output
      9 word

