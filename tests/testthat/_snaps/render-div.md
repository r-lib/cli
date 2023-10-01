# render_div [plain]

    Code
      render_div(cpt_div(cpt_text(txt)), width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-top` = 1))),
      width = 40)
    Output
      [1] ""                                        
      [2] "Labore aliquip deserunt mollit sint     "
      [3] "enim commodo cupidatat officia nulla    "
      [4] "id. Minim in adipisicing esse elit aute "
      [5] "cillum anim quis officia.               "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-bottom` = 1))),
      width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
      [5] ""                                        
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-left` = 2))),
      width = 40)
    Output
      [1] "  Labore aliquip deserunt mollit sint   "
      [2] "  enim commodo cupidatat officia nulla  "
      [3] "  id. Minim in adipisicing esse elit    "
      [4] "  aute cillum anim quis officia.        "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-right` = 2))),
      width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit      "
      [4] "aute cillum anim quis officia.          "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-top` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "                                        "
      [2] "Labore aliquip deserunt mollit sint     "
      [3] "enim commodo cupidatat officia nulla    "
      [4] "id. Minim in adipisicing esse elit aute "
      [5] "cillum anim quis officia.               "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-bottom` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
      [5] "                                        "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-left` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] " Labore aliquip deserunt mollit sint    "
      [2] " enim commodo cupidatat officia nulla   "
      [3] " id. Minim in adipisicing esse elit     "
      [4] " aute cillum anim quis officia.         "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-right` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit      "
      [4] "aute cillum anim quis officia.          "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(color = "grey"))),
      width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "

# render_div [ansi]

    Code
      render_div(cpt_div(cpt_text(txt)), width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-top` = 1))),
      width = 40)
    Output
      [1] ""                                        
      [2] "Labore aliquip deserunt mollit sint     "
      [3] "enim commodo cupidatat officia nulla    "
      [4] "id. Minim in adipisicing esse elit aute "
      [5] "cillum anim quis officia.               "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-bottom` = 1))),
      width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
      [5] ""                                        
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-left` = 2))),
      width = 40)
    Output
      [1] "  Labore aliquip deserunt mollit sint   "
      [2] "  enim commodo cupidatat officia nulla  "
      [3] "  id. Minim in adipisicing esse elit    "
      [4] "  aute cillum anim quis officia.        "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`margin-right` = 2))),
      width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit      "
      [4] "aute cillum anim quis officia.          "
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-top` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "\033[47m                                        \033[49m"
      [2] "\033[47mLabore aliquip deserunt mollit sint     \033[49m"
      [3] "\033[47menim commodo cupidatat officia nulla    \033[49m"
      [4] "\033[47mid. Minim in adipisicing esse elit aute \033[49m"
      [5] "\033[47mcillum anim quis officia.               \033[49m"
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-bottom` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "\033[47mLabore aliquip deserunt mollit sint     \033[49m"
      [2] "\033[47menim commodo cupidatat officia nulla    \033[49m"
      [3] "\033[47mid. Minim in adipisicing esse elit aute \033[49m"
      [4] "\033[47mcillum anim quis officia.               \033[49m"
      [5] "\033[47m                                        \033[49m"
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-left` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "\033[47m Labore aliquip deserunt mollit sint    \033[49m"
      [2] "\033[47m enim commodo cupidatat officia nulla   \033[49m"
      [3] "\033[47m id. Minim in adipisicing esse elit     \033[49m"
      [4] "\033[47m aute cillum anim quis officia.         \033[49m"
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(`padding-right` = 1,
        `background-color` = "grey"))), width = 40)
    Output
      [1] "\033[47mLabore aliquip deserunt mollit sint     \033[49m"
      [2] "\033[47menim commodo cupidatat officia nulla    \033[49m"
      [3] "\033[47mid. Minim in adipisicing esse elit      \033[49m"
      [4] "\033[47maute cillum anim quis officia.          \033[49m"
    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(color = "grey"))),
      width = 40)
    Output
      [1] "\033[90mLabore aliquip deserunt mollit sint\033[39m     "
      [2] "\033[90menim commodo cupidatat officia nulla\033[39m    "
      [3] "\033[90mid. Minim in adipisicing esse elit aute\033[39m "
      [4] "\033[90mcillum anim quis officia.\033[39m               "

