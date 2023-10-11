# new_styled_component

    Code
      sdiv
    Output
      <div> (styled)
        <text>
          txt: "foo"
        </text>
      </div>

# as_component

    Code
      as_component(1:10)
    Condition
      Error in `as_component()`:
      ! Cannot convert integer to cli_component

# as_styled_component

    Code
      get_style(as_styled_component(div))
    Output
      $color
      [1] "red"
      

---

    Code
      as_styled_component(1:10)
    Condition
      Error in `as_styled_component()`:
      ! Cannot convert integer to cli_styled_component

# inherited_styles

    Code
      inherited_styles()
    Output
       [1] "class-map"       "collapse"        "digits"          "line-type"      
       [5] "list-style-type" "start"           "string-quote"    "text-exdent"    
       [9] "transform"       "vec-last"        "vec-sep"         "vec-sep2"       
      [13] "vec-trunc"       "vec-trunc-style"

# merge_styles

    Code
      merge_styles(NULL, NULL, "foo")
    Output
      list()
    Code
      merge_styles(NULL, list(color = "red"))
    Output
      $color
      [1] "red"
      
    Code
      merge_styles(list(color = "red"), NULL)
    Output
      list()
    Code
      merge_styles(list(color = "red"), list(color = "green"))
    Output
      $color
      [1] "green"
      
    Code
      merge_styles(NULL, list(collapse = "-"))
    Output
      $collapse
      [1] "-"
      
    Code
      merge_styles(list(collapse = "|"), NULL)
    Output
      $collapse
      [1] "|"
      
    Code
      merge_styles(list(collapse = "|"), list(collapse = "-"))
    Output
      $collapse
      [1] "-"
      
    Code
      merge_styles(NULL, list(`class-map` = list(c = "foo")))
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      
    Code
      merge_styles(list(`class-map` = list(c = "foo")), NULL)
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      
    Code
      merge_styles(list(`class-map` = list(c = "foo"), d = "bar"), list(`class-map` = list(
        d = "baz")))
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      $`class-map`$d
      [1] "baz"
      
      

# inherit_style

    Code
      get_style(sdiv)
    Output
      $`class-map`
      $`class-map`$c
      [1] "bar"
      
      $`class-map`$e
      [1] "baz"
      
      $`class-map`$d
      [1] "bar"
      
      
      $color
      [1] "red"
      
      $collapse
      [1] "|"
      
      $`vec-sep`
      [1] ";"
      

---

    Code
      attr(spc1, "style")
    Output
      $collapse
      [1] "|"
      

---

    Code
      spc2
    Output
      $value
      [1] 1 2 3 4 5
      
      $code
      [1] "1:5"
      
      $style
      $style$collapse
      [1] "|"
      
      
      attr(,"class")
      [1] "cli_sub"

