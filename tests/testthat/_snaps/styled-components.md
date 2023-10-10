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

