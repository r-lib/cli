# theme_component_tree basic

    Code
      theme_component_tree(tree)
    Output
      <cli_component_tree> (themed)
      <div>
        
      </div>
    Code
      theme_component_tree(tree2)
    Output
      <cli_component_tree> (themed)
      <div>
        <div>
          
        </div>
      </div>
    Code
      theme_component_tree(tree3)
    Output
      <cli_component_tree> (themed)
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
      theme_component_tree(tree, list(div = list(color = "green")))$prestyle
    Output
      $color
      [1] "green"
      
    Code
      theme_component_tree(tree2, list(`div div` = list(color = "green")))$children[[
        1]]$prestyle
    Output
      $color
      [1] "green"
      
    Code
      theme_component_tree(tree3, list(span.val = list(color = "green")))$children[[
        1]]$children[[4]]$prestyle
    Output
      $color
      [1] "green"
      

---

    Code
      theme_component_tree(cpt)
    Condition
      Error in `theme_component_tree()`:
      ! `node` must be a `cli_component_tree` in `theme_component_tree()`

# theme_component_tree classes

    Code
      theme_component_tree(tree, list(.cl = list(color = "green")))$prestyle
    Output
      $color
      [1] "green"
      
    Code
      theme_component_tree(tree2, list(`.cl div` = list(color = "green")))$children[[
        1]]$prestyle
    Output
      $color
      [1] "green"
      
    Code
      theme_component_tree(tree3, list(`.cl span.val` = list(color = "green")))$
        children[[1]]$children[[4]]$prestyle
    Output
      $color
      [1] "green"
      

# theme_component_tree styles

    Code
      ttree[["prestyle"]]
    Output
      $color
      [1] "red"
      
      $custom2
      [1] "foo"
      
      $custom
      [1] "grey"
      
    Code
      ttree2[["children"]][[1]][["prestyle"]]
    Output
      $color
      [1] "red"
      
      $custom2
      [1] "foo"
      
      $custom
      [1] "grey"
      
    Code
      ttree3[["children"]][[2]][["prestyle"]]
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
      

