# empty label [plain]

    Code
      boxx("")
    Output
      +------+
      |      |
      |      |
      |      |
      +------+

# empty label [unicode]

    Code
      boxx("")
    Output
      ┌──────┐
      │      │
      │      │
      │      │
      └──────┘

# empty label 2 [plain]

    Code
      boxx(character())
    Output
      +------+
      |      |
      |      |
      +------+

# empty label 2 [unicode]

    Code
      boxx(character())
    Output
      ┌──────┐
      │      │
      │      │
      └──────┘

# label [plain]

    Code
      boxx("label")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# label [unicode]

    Code
      boxx("label")
    Output
      ┌───────────┐
      │           │
      │   label   │
      │           │
      └───────────┘

# label vector [plain]

    Code
      boxx(c("label", "l2"))
    Output
      +-----------+
      |           |
      |   label   |
      |   l2      |
      |           |
      +-----------+

# label vector [unicode]

    Code
      boxx(c("label", "l2"))
    Output
      ┌───────────┐
      │           │
      │   label   │
      │   l2      │
      │           │
      └───────────┘

# border style [plain]

    Code
      boxx("label", border_style = "classic")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# border style [unicode]

    Code
      boxx("label", border_style = "classic")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# padding [plain]

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

# padding [unicode]

    Code
      boxx("label", padding = 2)
    Output
      ┌─────────────────┐
      │                 │
      │                 │
      │      label      │
      │                 │
      │                 │
      └─────────────────┘

---

    Code
      boxx("label", padding = c(1, 2, 1, 2))
    Output
      ┌─────────┐
      │         │
      │  label  │
      │         │
      └─────────┘

---

    Code
      boxx("label", padding = c(1, 2, 0, 2))
    Output
      ┌─────────┐
      │  label  │
      │         │
      └─────────┘

---

    Code
      boxx("label", padding = c(1, 2, 0, 0))
    Output
      ┌───────┐
      │  label│
      │       │
      └───────┘

# margin [plain]

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

# margin [unicode]

    Code
      boxx("label", margin = 1)
    Output
      
         ┌───────────┐
         │           │
         │   label   │
         │           │
         └───────────┘
      

---

    Code
      boxx("label", margin = c(1, 2, 3, 4))
    Output
      
      
      
        ┌───────────┐
        │           │
        │   label   │
        │           │
        └───────────┘
      

---

    Code
      boxx("label", margin = c(0, 1, 2, 0))
    Output
      
      
       ┌───────────┐
       │           │
       │   label   │
       │           │
       └───────────┘

# float [plain]

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

# float [unicode]

    Code
      boxx("label", float = "center", width = 20)
    Output
          ┌───────────┐
          │           │
          │   label   │
          │           │
          └───────────┘

---

    Code
      boxx("label", float = "right", width = 20)
    Output
             ┌───────────┐
             │           │
             │   label   │
             │           │
             └───────────┘

# background_col [plain]

    Code
      boxx("label", background_col = "red")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

---

    Code
      boxx("label", background_col = col_red)
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# background_col [ansi]

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

# background_col [unicode]

    Code
      boxx("label", background_col = "red")
    Output
      ┌───────────┐
      │           │
      │   label   │
      │           │
      └───────────┘

---

    Code
      boxx("label", background_col = col_red)
    Output
      ┌───────────┐
      │           │
      │   label   │
      │           │
      └───────────┘

# background_col [fancy]

    Code
      boxx("label", background_col = "red")
    Output
      ┌───────────┐
      │[41m           [49m│
      │[41m   label   [49m│
      │[41m           [49m│
      └───────────┘

---

    Code
      boxx("label", background_col = col_red)
    Output
      ┌───────────┐
      │[31m           [39m│
      │[31m   label   [39m│
      │[31m           [39m│
      └───────────┘

# border_col [plain]

    Code
      boxx("label", border_col = "red")
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

---

    Code
      boxx("label", border_col = col_red)
    Output
      +-----------+
      |           |
      |   label   |
      |           |
      +-----------+

# border_col [ansi]

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

# border_col [unicode]

    Code
      boxx("label", border_col = "red")
    Output
      ┌───────────┐
      │           │
      │   label   │
      │           │
      └───────────┘

---

    Code
      boxx("label", border_col = col_red)
    Output
      ┌───────────┐
      │           │
      │   label   │
      │           │
      └───────────┘

# border_col [fancy]

    Code
      boxx("label", border_col = "red")
    Output
      [31m┌───────────┐[39m
      [31m│[39m           [31m│[39m
      [31m│[39m   label   [31m│[39m
      [31m│[39m           [31m│[39m
      [31m└───────────┘[39m

---

    Code
      boxx("label", border_col = col_red)
    Output
      [31m┌───────────┐[39m
      [31m│[39m           [31m│[39m
      [31m│[39m   label   [31m│[39m
      [31m│[39m           [31m│[39m
      [31m└───────────┘[39m

# align [plain]

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

# align [unicode]

    Code
      boxx(c("label", "l2"), align = "center")
    Output
      ┌───────────┐
      │           │
      │   label   │
      │     l2    │
      │           │
      └───────────┘

---

    Code
      boxx(c("label", "l2"), align = "right")
    Output
      ┌───────────┐
      │           │
      │   label   │
      │      l2   │
      │           │
      └───────────┘

# header [plain]

    Code
      boxx("foobar", header = "foo")
    Output
      + foo -------+
      |            |
      |   foobar   |
      |            |
      +------------+

# header [unicode]

    Code
      boxx("foobar", header = "foo")
    Output
      ┌ foo ───────┐
      │            │
      │   foobar   │
      │            │
      └────────────┘

# footer [plain]

    Code
      boxx("foobar", footer = "foo")
    Output
      +------------+
      |            |
      |   foobar   |
      |            |
      +------- foo +

# footer [unicode]

    Code
      boxx("foobar", footer = "foo")
    Output
      ┌────────────┐
      │            │
      │   foobar   │
      │            │
      └─────── foo ┘

