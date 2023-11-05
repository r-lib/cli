# render

    Code
      format(preview(cpt_div(cpt_txt(txt)), width = 40, theme = list()))
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
    Code
      format(preview(cpt_span(cpt_txt(txt)), theme = list()))
    Output
      [1] "Labore aliquip deserunt mollit sint enim commodo cupidatat officia nulla id.    "
      [2] "Minim in adipisicing esse elit aute cillum anim quis officia.                   "
    Code
      format(preview(cpt_txt(txt), theme = list()))
    Output
      [1] "Labore aliquip deserunt mollit sint enim commodo cupidatat officia nulla id.    "
      [2] "Minim in adipisicing esse elit aute cillum anim quis officia.                   "

---

    Code
      format(preview(cpt, theme = list()))
    Condition
      Error in `render_styled()`:
      ! Unknown component type: foobar

# preview

    Code
      preview(cpt_div(cpt_txt(txt)), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               
    Code
      preview(cpt_span(cpt_txt(txt)), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               
    Code
      preview(cpt_txt(txt), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               

# preview_generic

    Code
      preview(cpt_div(cpt_txt(txt)), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               

# preview_text

    Code
      preview(cpt_txt(txt), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               

# preview_span

    Code
      preview(cpt_span(cpt_txt(txt)), width = 40, theme = list())
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               

