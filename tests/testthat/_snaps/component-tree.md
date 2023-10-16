# map_component_tree

    Code
      map_component_tree(cpt)
    Output
      <cli_component_tree>
      <div>
        
      </div>
    Code
      map_component_tree(cpt2)
    Output
      <cli_component_tree>
      <div>
        <div>
          
        </div>
      </div>
    Code
      map_component_tree(cpt3)
    Output
      <cli_component_tree>
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
      map_component_tree(cpt2)$children[[1]]
    Output
      <cli_component_tree>
      <div>
        
      </div>
    Code
      map_component_tree(cpt3)$children[[1]]$children
    Output
      [[1]]
      [1] "foo "
      
      [[2]]
      <cli_component_tree>
      <span>
        <text>
          txt: "bar"
        </text>
      </span>
      
      [[3]]
      [1] " "
      
      [[4]]
      <cli_component_tree>
      <span>
        <text>
          sub: `1:5`
        </text>
      </span>
      
      [[5]]
      [1] " end"
      

---

    Code
      map_component_tree(1:10)
    Condition
      Error in `map_component_tree()`:
      ! `cpt` must be a `cli_component` in `map_component_tree()`

# parse_class_attr

    Code
      parse_class_attr(NULL)
    Output
      character(0)
    Code
      parse_class_attr(character())
    Output
      character(0)
    Code
      parse_class_attr("")
    Output
      character(0)
    Code
      parse_class_attr("foo")
    Output
      [1] "foo"
    Code
      parse_class_attr(" foo")
    Output
      [1] "foo"
    Code
      parse_class_attr("  foo")
    Output
      [1] "foo"
    Code
      parse_class_attr("foo ")
    Output
      [1] "foo"
    Code
      parse_class_attr("foo  ")
    Output
      [1] "foo"
    Code
      parse_class_attr("foo bar")
    Output
      [1] "foo" "bar"
    Code
      parse_class_attr("foo  bar")
    Output
      [1] "foo" "bar"

