# parsing and formatting

    Code
      cpt_text("plain text")
    Output
      <text>
        txt: "plain text"
      </text>
    Code
      cpt_text("subs {1:6} titution")
    Output
      <text>
        txt: "subs "
        sub: `1:6`
        txt: " titution"
      </text>
    Code
      cpt_text("sty{.emph li}ng")
    Output
      <text>
        txt: "sty"
        <span class="emph">
          <text>
            txt: "li"
          </text>
        </span>
        txt: "ng"
      </text>
    Code
      cpt_text("styling {.plus {1:10}} subst")
    Output
      <text>
        txt: "styling "
        <span class="plus">
          <text>
            sub: `1:10`
          </text>
        </span>
        txt: " subst"
      </text>
    Code
      cpt_text("f {1:2}{4:5} {.bar plain}o{.foo {.bar {3:4}}}o")
    Output
      <text>
        txt: "f "
        sub: `1:2`
        sub: `4:5`
        txt: " "
        <span class="bar">
          <text>
            txt: "plain"
          </text>
        </span>
        txt: "o"
        <span class="foo">
          <text>
            <span class="bar">
              <text>
                sub: `3:4`
              </text>
            </span>
          </text>
        </span>
        txt: "o"
      </text>

# plurals

    Code
      cpt_text("Loaded {0} file{?s}.")
    Output
      <text>
        txt: "Loaded "
        sub: `0`
        txt: " file"
        txt: "s"
        txt: "."
      </text>
    Code
      cpt_text("Loaded {1} file{?s}.")
    Output
      <text>
        txt: "Loaded "
        sub: `1`
        txt: " file"
        txt: ""
        txt: "."
      </text>
    Code
      cpt_text("Loaded {2} file{?s}.")
    Output
      <text>
        txt: "Loaded "
        sub: `2`
        txt: " file"
        txt: "s"
        txt: "."
      </text>

# plurals postprocessing

    Code
      cpt_text("File{?s} loaded: {0}")
    Output
      <text>
        txt: "File"
        txt: "s"
        txt: " loaded: "
        sub: `0`
      </text>
    Code
      cpt_text("File{?s} loaded: {1}")
    Output
      <text>
        txt: "File"
        txt: ""
        txt: " loaded: "
        sub: `1`
      </text>
    Code
      cpt_text("File{?s} loaded: {2}")
    Output
      <text>
        txt: "File"
        txt: "s"
        txt: " loaded: "
        sub: `2`
      </text>

# inline styling errors

    Code
      cpt_text("foo {.not+this} bar")
    Condition
      Error:
      ! Invalid cli literal: `{.not+this}` starts with a dot.
      i Interpreted literals must not start with a dot in cli >= 3.4.0.
      i `{}` expressions starting with a dot are now only used for cli styles.
      i To avoid this error, put a space character after the starting `{` or use parentheses: `{(.not+this)}`.

