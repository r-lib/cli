# style_component_tree basic

    Code
      style_component_tree(theme_component_tree(tree))
    Output
      <cli_component_tree> (styled)
      <div>
        
      </div>
    Code
      style_component_tree(theme_component_tree(tree2))
    Output
      <cli_component_tree> (styled)
      <div>
        <div>
          
        </div>
      </div>
    Code
      style_component_tree(theme_component_tree(tree3))
    Output
      <cli_component_tree> (styled)
      <div>
        <text>
          txt: "foo "
          <span class="emph">
            <text>
              txt: "bar"
            </text>
          </span>
          txt: " "
          <span class="val">
            <text>
              sub: `1:5`
            </text>
          </span>
          txt: " end"
        </text>
      </div>

---

    Code
      style_component_tree(theme_component_tree(tree, list(div = list(color = "green"))))$
        style
    Output
      $color
      [1] "green"
      
    Code
      style_component_tree(theme_component_tree(tree2, list(`div div` = list(color = "green"))))$
        children[[1]]$style
    Output
      $color
      [1] "green"
      
    Code
      style_component_tree(theme_component_tree(tree3, list(span.val = list(color = "green"))))$
        children[[1]]$children[[4]]$style
    Output
      $color
      [1] "green"
      

---

    Code
      style_component_tree(1:10)
    Condition
      Error in `style_component_tree_node()`:
      ! `node` must be a `cli_component_tree` in `style_component_tree()`

---

    Code
      style_component_tree(tree)
    Condition
      Error in `style_component_tree_node()`:
      ! `node` is not themed yet, call `theme_component_tree()` first

# inherited_styles

    Code
      inherited_styles()
    Output
       [1] "class-map"       "collapse"        "digits"          "line-type"      
       [5] "list-style-type" "start"           "string-quote"    "text-exdent"    
       [9] "transform"       "vec-last"        "vec-sep"         "vec-sep2"       
      [13] "vec-trunc"       "vec-trunc-style"

# inherit_styles

    Code
      inherit_styles(NULL, NULL, "foo")
    Output
      list()
    Code
      inherit_styles(NULL, list(color = "red"))
    Output
      $color
      [1] "red"
      
    Code
      inherit_styles(list(color = "red"), NULL)
    Output
      list()
    Code
      inherit_styles(list(color = "red"), list(color = "green"))
    Output
      $color
      [1] "green"
      
    Code
      inherit_styles(NULL, list(collapse = "-"))
    Output
      $collapse
      [1] "-"
      
    Code
      inherit_styles(list(collapse = "|"), NULL)
    Output
      $collapse
      [1] "|"
      
    Code
      inherit_styles(list(collapse = "|"), list(collapse = "-"))
    Output
      $collapse
      [1] "-"
      
    Code
      inherit_styles(NULL, list(`class-map` = list(c = "foo")))
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      
    Code
      inherit_styles(list(`class-map` = list(c = "foo")), NULL)
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      
    Code
      inherit_styles(list(`class-map` = list(c = "foo"), d = "bar"), list(
        `class-map` = list(d = "baz")))
    Output
      $`class-map`
      $`class-map`$c
      [1] "foo"
      
      $`class-map`$d
      [1] "baz"
      
      

# style_component_tree classes

    Code
      style_component_tree(theme_component_tree(tree, list(.cl = list(color = "green"))))$
        style
    Output
      $color
      [1] "green"
      
    Code
      style_component_tree(theme_component_tree(tree2, list(`.cl div` = list(color = "green"))))$
        children[[1]]$style
    Output
      $color
      [1] "green"
      
    Code
      style_component_tree(theme_component_tree(tree3, list(`.cl span.val` = list(
        color = "green"))))$children[[1]]$children[[4]]$style
    Output
      $color
      [1] "green"
      

# style_component_tree styles

    Code
      ttree[["style"]]
    Output
      $color
      [1] "red"
      
      $custom2
      [1] "foo"
      
      $digits
      [1] 5
      
      $custom
      [1] "grey"
      
    Code
      ttree2[["children"]][[1]][["style"]]
    Output
      $color
      [1] "red"
      
      $custom2
      [1] "foo"
      
      $digits
      [1] 5
      
      $custom
      [1] "grey"
      
    Code
      ttree3[["children"]][[2]][["style"]]
    Output
      $color
      [1] "green"
      
      $`class-map`
      $`class-map`$rc2
      [1] "c2"
      
      $`class-map`$rclass
      [1] "cliclass"
      
      
      $digits
      [1] 10
      

