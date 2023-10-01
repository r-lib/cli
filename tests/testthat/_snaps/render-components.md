# render

    Code
      render(cpt_div(cpt_text(txt)), width = 40)
    Output
      [1] "Labore aliquip deserunt mollit sint     "
      [2] "enim commodo cupidatat officia nulla    "
      [3] "id. Minim in adipisicing esse elit aute "
      [4] "cillum anim quis officia.               "
    Code
      render(cpt_span(cpt_text(txt)))
    Output
      <cli_ansi_string>
      [1] Labore aliquip deserunt mollit sint enim commodo cupidatat
                officia nulla id. Minim in adipisicing esse elit aute cillum
                anim quis officia.
    Code
      render(cpt_text(txt))
    Output
      <cli_ansi_string>
      [1] Labore aliquip deserunt mollit sint enim commodo cupidatat
                officia nulla id. Minim in adipisicing esse elit aute cillum
                anim quis officia.

---

    Code
      render(cpt)
    Condition
      Error in `render()`:
      ! Unknown component type: foobar

# preview

    Code
      preview(cpt_div(cpt_text(txt)), width = 40)
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               
    Code
      preview(cpt_span(cpt_text(txt)), width = 40)
    Output
      Labore aliquip deserunt mollit sint
      enim commodo cupidatat officia nulla
      id. Minim in adipisicing esse elit aute
      cillum anim quis officia.
    Code
      preview(cpt_text(txt), width = 40)
    Output
      Labore aliquip deserunt mollit sint
      enim commodo cupidatat officia nulla
      id. Minim in adipisicing esse elit aute
      cillum anim quis officia.

# preview_generic

    Code
      preview_generic(cpt_div(cpt_text(txt)), width = 40)
    Output
      Labore aliquip deserunt mollit sint     
      enim commodo cupidatat officia nulla    
      id. Minim in adipisicing esse elit aute 
      cillum anim quis officia.               

# preview_text

    Code
      preview_text(cpt_text(txt), width = 40)
    Output
      Labore aliquip deserunt mollit sint
      enim commodo cupidatat officia nulla
      id. Minim in adipisicing esse elit aute
      cillum anim quis officia.

# preview_span

    Code
      preview_span(cpt_span(cpt_text(txt)), width = 40)
    Output
      Labore aliquip deserunt mollit sint
      enim commodo cupidatat officia nulla
      id. Minim in adipisicing esse elit aute
      cillum anim quis officia.

