# tree [plain]

    Code
      tree(data)
    Output
      processx
      +-assertthat
      +-crayon
      +-debugme
      | \-crayon
      \-R6

---

    Code
      tree(data, root = "desc")
    Output
      desc
      +-assertthat
      +-R6
      +-crayon
      \-rprojroot
        \-backports

# tree [ansi]

    Code
      tree(data)
    Output
      processx
      +-assertthat
      +-crayon
      +-debugme
      | \-crayon
      \-R6

---

    Code
      tree(data, root = "desc")
    Output
      desc
      +-assertthat
      +-R6
      +-crayon
      \-rprojroot
        \-backports

# tree [unicode]

    Code
      tree(data)
    Output
      processx
      ├─assertthat
      ├─crayon
      ├─debugme
      │ └─crayon
      └─R6

---

    Code
      tree(data, root = "desc")
    Output
      desc
      ├─assertthat
      ├─R6
      ├─crayon
      └─rprojroot
        └─backports

# tree [fancy]

    Code
      tree(data)
    Output
      processx
      ├─assertthat
      ├─crayon
      ├─debugme
      │ └─crayon
      └─R6

---

    Code
      tree(data, root = "desc")
    Output
      desc
      ├─assertthat
      ├─R6
      ├─crayon
      └─rprojroot
        └─backports

# trimming [plain]

    Code
      tree(pkgs, trim = TRUE)
    Output
      dplyr@0.8.3
      +-assertthat@0.2.1
      +-glue@1.3.1
      +-magrittr@1.5
      +-R6@2.4.0
      +-Rcpp@1.0.2
      +-rlang@0.4.0
      +-tibble@2.1.3
      | +-cli@1.1.0
      | | +-assertthat@0.2.1  (trimmed)
      | | \-crayon@1.3.4
      | +-crayon@1.3.4  (trimmed)
      | +-fansi@0.4.0
      | +-pillar@1.4.2
      | | +-cli@1.1.0  (trimmed)
      | | +-crayon@1.3.4  (trimmed)
      | | +-fansi@0.4.0  (trimmed)
      | | +-rlang@0.4.0  (trimmed)
      | | +-utf8@1.1.4
      | | \-vctrs@0.2.0
      | |   +-backports@1.1.5
      | |   +-ellipsis@0.3.0
      | |   | \-rlang@0.4.0  (trimmed)
      | |   +-digest@0.6.21
      | |   +-glue@1.3.1  (trimmed)
      | |   +-rlang@0.4.0  (trimmed)
      | |   \-zeallot@0.1.0
      | +-pkgconfig@2.0.3
      | \-rlang@0.4.0  (trimmed)
      \-tidyselect@0.2.5
        +-glue@1.3.1  (trimmed)
        +-rlang@0.4.0  (trimmed)
        \-Rcpp@1.0.2  (trimmed)

# trimming [ansi]

    Code
      tree(pkgs, trim = TRUE)
    Output
      dplyr@0.8.3
      +-assertthat@0.2.1
      +-glue@1.3.1
      +-magrittr@1.5
      +-R6@2.4.0
      +-Rcpp@1.0.2
      +-rlang@0.4.0
      +-tibble@2.1.3
      | +-cli@1.1.0
      | | +-assertthat@0.2.1  (trimmed)
      | | \-crayon@1.3.4
      | +-crayon@1.3.4  (trimmed)
      | +-fansi@0.4.0
      | +-pillar@1.4.2
      | | +-cli@1.1.0  (trimmed)
      | | +-crayon@1.3.4  (trimmed)
      | | +-fansi@0.4.0  (trimmed)
      | | +-rlang@0.4.0  (trimmed)
      | | +-utf8@1.1.4
      | | \-vctrs@0.2.0
      | |   +-backports@1.1.5
      | |   +-ellipsis@0.3.0
      | |   | \-rlang@0.4.0  (trimmed)
      | |   +-digest@0.6.21
      | |   +-glue@1.3.1  (trimmed)
      | |   +-rlang@0.4.0  (trimmed)
      | |   \-zeallot@0.1.0
      | +-pkgconfig@2.0.3
      | \-rlang@0.4.0  (trimmed)
      \-tidyselect@0.2.5
        +-glue@1.3.1  (trimmed)
        +-rlang@0.4.0  (trimmed)
        \-Rcpp@1.0.2  (trimmed)

# trimming [unicode]

    Code
      tree(pkgs, trim = TRUE)
    Output
      dplyr@0.8.3
      ├─assertthat@0.2.1
      ├─glue@1.3.1
      ├─magrittr@1.5
      ├─R6@2.4.0
      ├─Rcpp@1.0.2
      ├─rlang@0.4.0
      ├─tibble@2.1.3
      │ ├─cli@1.1.0
      │ │ ├─assertthat@0.2.1  (trimmed)
      │ │ └─crayon@1.3.4
      │ ├─crayon@1.3.4  (trimmed)
      │ ├─fansi@0.4.0
      │ ├─pillar@1.4.2
      │ │ ├─cli@1.1.0  (trimmed)
      │ │ ├─crayon@1.3.4  (trimmed)
      │ │ ├─fansi@0.4.0  (trimmed)
      │ │ ├─rlang@0.4.0  (trimmed)
      │ │ ├─utf8@1.1.4
      │ │ └─vctrs@0.2.0
      │ │   ├─backports@1.1.5
      │ │   ├─ellipsis@0.3.0
      │ │   │ └─rlang@0.4.0  (trimmed)
      │ │   ├─digest@0.6.21
      │ │   ├─glue@1.3.1  (trimmed)
      │ │   ├─rlang@0.4.0  (trimmed)
      │ │   └─zeallot@0.1.0
      │ ├─pkgconfig@2.0.3
      │ └─rlang@0.4.0  (trimmed)
      └─tidyselect@0.2.5
        ├─glue@1.3.1  (trimmed)
        ├─rlang@0.4.0  (trimmed)
        └─Rcpp@1.0.2  (trimmed)

# trimming [fancy]

    Code
      tree(pkgs, trim = TRUE)
    Output
      dplyr@0.8.3
      ├─assertthat@0.2.1
      ├─glue@1.3.1
      ├─magrittr@1.5
      ├─R6@2.4.0
      ├─Rcpp@1.0.2
      ├─rlang@0.4.0
      ├─tibble@2.1.3
      │ ├─cli@1.1.0
      │ │ ├─assertthat@0.2.1  (trimmed)
      │ │ └─crayon@1.3.4
      │ ├─crayon@1.3.4  (trimmed)
      │ ├─fansi@0.4.0
      │ ├─pillar@1.4.2
      │ │ ├─cli@1.1.0  (trimmed)
      │ │ ├─crayon@1.3.4  (trimmed)
      │ │ ├─fansi@0.4.0  (trimmed)
      │ │ ├─rlang@0.4.0  (trimmed)
      │ │ ├─utf8@1.1.4
      │ │ └─vctrs@0.2.0
      │ │   ├─backports@1.1.5
      │ │   ├─ellipsis@0.3.0
      │ │   │ └─rlang@0.4.0  (trimmed)
      │ │   ├─digest@0.6.21
      │ │   ├─glue@1.3.1  (trimmed)
      │ │   ├─rlang@0.4.0  (trimmed)
      │ │   └─zeallot@0.1.0
      │ ├─pkgconfig@2.0.3
      │ └─rlang@0.4.0  (trimmed)
      └─tidyselect@0.2.5
        ├─glue@1.3.1  (trimmed)
        ├─rlang@0.4.0  (trimmed)
        └─Rcpp@1.0.2  (trimmed)

