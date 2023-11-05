# cpt_div

    Code
      cpt_div()
    Output
      <div>
      </div>
    Code
      cpt_div(cpt_div())
    Output
      <div>
        <div>
        </div>
      </div>
    Code
      cpt_div(cpt_div(), cpt_div())
    Output
      <div>
        <div>
        </div>
        <div>
        </div>
      </div>

# cpt_span

    Code
      cpt_span()
    Output
      <span>
      </span>
    Code
      cpt_span(cpt_span())
    Output
      <span>
        <span>
        </span>
      </span>
    Code
      cpt_span(cpt_span(), cpt_span())
    Output
      <span>
        <span>
        </span>
        <span>
        </span>
      </span>
    Code
      cpt_span(cpt_txt("foobar"))
    Output
      <span>
        <text>
          txt: "foobar"
        </text>
      </span>

# cpt_h1

    Code
      cpt_h1("foobar")
    Output
      <h1>
        <text>
          txt: "foobar"
        </text>
      </h1>
    Code
      cpt_h1(cpt_txt("foo"))
    Output
      <h1>
        <text>
          txt: "foo"
        </text>
      </h1>
    Code
      cpt_h1(cpt_span())
    Output
      <h1>
        <span>
        </span>
      </h1>

# cpt_h2

    Code
      cpt_h2("foobar")
    Output
      <h2>
        <text>
          txt: "foobar"
        </text>
      </h2>
    Code
      cpt_h2(cpt_txt("foo"))
    Output
      <h2>
        <text>
          txt: "foo"
        </text>
      </h2>
    Code
      cpt_h2(cpt_span())
    Output
      <h2>
        <span>
        </span>
      </h2>

# cpt_h3

    Code
      cpt_h3("foobar")
    Output
      <h3>
        <text>
          txt: "foobar"
        </text>
      </h3>
    Code
      cpt_h3(cpt_txt("foo"))
    Output
      <h3>
        <text>
          txt: "foo"
        </text>
      </h3>
    Code
      cpt_h3(cpt_span())
    Output
      <h3>
        <span>
        </span>
      </h3>

