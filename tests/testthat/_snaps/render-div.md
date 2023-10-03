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

# render_div children [plain]

    Code
      writeLines(render_div(cpt_div(cpt_div(cpt_text(txt), attr = list(style = list(
        color = "magenta"))), attr = list(style = list(`background-color` = "grey",
        `padding-left` = 2L, `padding-right` = 2L, `padding-top` = 2L,
        `padding-bottom` = 2L, `margin-left` = 1L, `margin-right` = 1L, `margin-top` = 1L,
        `margin-bottom` = 1L)))))
    Output
      
                                              
                                              
         Labore aliquip deserunt mollit       
         sint enim commodo cupidatat          
         officia nulla id. Minim in           
         adipisicing esse elit aute cillum    
         anim quis officia.                   
                                              
                                              
      

# render_div children [ansi]

    Code
      writeLines(render_div(cpt_div(cpt_div(cpt_text(txt), attr = list(style = list(
        color = "magenta"))), attr = list(style = list(`background-color` = "grey",
        `padding-left` = 2L, `padding-right` = 2L, `padding-top` = 2L,
        `padding-bottom` = 2L, `margin-left` = 1L, `margin-right` = 1L, `margin-top` = 1L,
        `margin-bottom` = 1L)))))
    Output
      
       [47m                                      [49m 
       [47m                                      [49m 
       [47m  [35mLabore aliquip deserunt mollit[39m      [49m 
       [47m  [35msint enim commodo cupidatat[39m         [49m 
       [47m  [35mofficia nulla id. Minim in[39m          [49m 
       [47m  [35madipisicing esse elit aute cillum[39m   [49m 
       [47m  [35manim quis officia.[39m                  [49m 
       [47m                                      [49m 
       [47m                                      [49m 
      

# render_div can turn off bg color [ansi]

    Code
      writeLines(render_div(cpt_div(cpt_div(cpt_text(txt), attr = list(style = list(
        color = "magenta", `background-color` = NULL))), attr = list(style = list(
        `background-color` = "grey", `padding-left` = 2L, `padding-right` = 2L,
        `padding-top` = 2L, `padding-bottom` = 2L, `margin-left` = 1L,
        `margin-right` = 1L, `margin-top` = 1L, `margin-bottom` = 1L)))))
    Output
      
       [47m                                      [49m 
       [47m                                      [49m 
       [47m  [0m[22m[23m[24m[27m[28m[29m[39m[35mLabore aliquip deserunt mollit[39m    [47m  [49m 
       [47m  [0m[22m[23m[24m[27m[28m[29m[39m[35msint enim commodo cupidatat[39m       [47m  [49m 
       [47m  [0m[22m[23m[24m[27m[28m[29m[39m[35mofficia nulla id. Minim in[39m        [47m  [49m 
       [47m  [0m[22m[23m[24m[27m[28m[29m[39m[35madipisicing esse elit aute cillum[39m [47m  [49m 
       [47m  [0m[22m[23m[24m[27m[28m[29m[39m[35manim quis officia.[39m                [47m  [49m 
       [47m                                      [49m 
       [47m                                      [49m 
      

# render_div with fmt callback

    Code
      render(div, width = 40)
    Output
      [1] "-- This is a headline ------------------"

# render_div after, before

    Code
      render_div(cpt_div(cpt_text(txt), attr = list(style = list(before = "<<",
        after = ">>"))), width = 40)
    Output
      [1] "<<Labore aliquip deserunt mollit sint   "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.>>             "

