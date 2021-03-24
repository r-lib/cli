# empty label

    Code
      boxx("")
    Output
      +------+
      |      |
      |      |
      |      |
      +------+

# empty label 2

    Code
      boxx(character())
    Output
      +------+
      |      |
      |      |
      +------+

# label

    Code
      boxx("label")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# label vector

    Code
      boxx(c("label", "l2"))
    Output
      +-----------+
      |           |
      |   label   |
      |   l2      |
      |           |
      +-----------+

# border style

    Code
      boxx("label", border_style = "classic")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# padding

    Code
      boxx("label", padding = 2)
    Output
      +-----------------+
      |                 |
      |                 |
      |      label      |
      |                 |
      |                 |
      +-----------------+

---

    Code
      boxx("label", padding = c(1, 2, 1, 2))
    Output
      +---------+
      |         |
      |  label  |
      |         |
      +---------+

---

    Code
      boxx("label", padding = c(1, 2, 0, 2))
    Output
      +---------+
      |  label  |
      |         |
      +---------+

---

    Code
      boxx("label", padding = c(1, 2, 0, 0))
    Output
      +-------+
      |  label|
      |       |
      +-------+

# margin

    Code
      boxx("label", margin = 1)
    Output
      
         +-----------+
         |           |
         |   label   |
         |           |
         +-----------+
      

---

    Code
      boxx("label", margin = c(1, 2, 3, 4))
    Output
      
      
      
        +-----------+
        |           |
        |   label   |
        |           |
        +-----------+
      

---

    Code
      boxx("label", margin = c(0, 1, 2, 0))
    Output
      
      
       +-----------+
       |           |
       |   label   |
       |           |
       +-----------+

# float

    Code
      boxx("label", float = "center", width = 20)
    Output
          +-----------+
          |           |
          |   label   |
          |           |
          +-----------+

---

    Code
      boxx("label", float = "right", width = 20)
    Output
             +-----------+
             |           |
             |   label   |
             |           |
             +-----------+

# background_col

    Code
      boxx("label", background_col = "red")
    Output
      +-----------+
      |[41m           [49m|
      |[41m   label   [49m|
      |[41m           [49m|
      +-----------+

---

    Code
      boxx("label", background_col = col_red)
    Output
      +-----------+
      |[31m           [39m|
      |[31m   label   [39m|
      |[31m           [39m|
      +-----------+

# border_col

    Code
      boxx("label", border_col = "red")
    Output
      [31m+-----------+[39m
      [31m|[39m           [31m|[39m
      [31m|[39m   label   [31m|[39m
      [31m|[39m           [31m|[39m
      [31m+-----------+[39m

---

    Code
      boxx("label", border_col = col_red)
    Output
      [31m+-----------+[39m
      [31m|[39m           [31m|[39m
      [31m|[39m   label   [31m|[39m
      [31m|[39m           [31m|[39m
      [31m+-----------+[39m

# align

    Code
      boxx(c("label", "l2"), align = "center")
    Output
      +-----------+
      |           |
      |   label   |
      |     l2    |
      |           |
      +-----------+

---

    Code
      boxx(c("label", "l2"), align = "right")
    Output
      +-----------+
      |           |
      |   label   |
      |      l2   |
      |           |
      +-----------+

# header

    Code
      boxx("foobar", header = "foo")
    Output
      + foo -------+
      |            |
      |   foobar   |
      |            |
      +------------+

# footer

    Code
      boxx("foobar", footer = "foo")
    Output
      +------------+
      |            |
      |   foobar   |
      |            |
      +------- foo +

