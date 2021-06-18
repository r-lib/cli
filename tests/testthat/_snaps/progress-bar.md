# make_progress_bar [plain]

    Code
      make_progress_bar(0.5)
    Output
      [1] "===============>--------------- "

# make_progress_bar [ansi]

    Code
      make_progress_bar(0.5)
    Output
      [1] "===============>--------------- "

# make_progress_bar [unicode]

    Code
      make_progress_bar(0.5)
    Output
      [1] "■■■■■■■■■■■■■■■■                "

# make_progress_bar [fancy]

    Code
      make_progress_bar(0.5)
    Output
      [1] "■■■■■■■■■■■■■■■■                "

# cli_progress_styles [fancy]

    Code
      make_progress_bar(0.5)
    Output
      [1] "################                "

---

    Code
      make_progress_bar(0.5)
    Output
      [1] "■■■■■■■■■■■■■■■■                "

---

    Code
      make_progress_bar(0.5)
    Output
      [1] "\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[31m●\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m\033[90m─\033[39m "

---

    Code
      make_progress_bar(0.5)
    Output
      [1] "■■■■■■■■■■■■■■■■\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m\033[90m□\033[39m "

---

    Code
      make_progress_bar(0.5)
    Output
      [1] "████████████████\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m\033[90m█\033[39m "

# custom style [plain]

    Code
      make_progress_bar(0.5)
    Output
      [1] "XXXXXXXXXXXXXXX>OOOOOOOOOOOOOOO "

# custom style [unicode]

    Code
      make_progress_bar(0.5)
    Output
      [1] "XXXXXXXXXXXXXXX>OOOOOOOOOOOOOOO "

