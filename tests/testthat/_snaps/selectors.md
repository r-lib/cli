# parse_selector

    Code
      parse_selector("tag")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      character(0)
      
      
    Code
      parse_selector(".class")
    Output
      [[1]]
      [[1]]$tag
      character(0)
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
    Code
      parse_selector("#id")
    Output
      [[1]]
      [[1]]$tag
      character(0)
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      [1] "id"
      
      
    Code
      parse_selector("tag.class")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag"
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
    Code
      parse_selector("tag subtag")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "subtag"
      
      [[2]]$class
      character(0)
      
      [[2]]$id
      character(0)
      
      
    Code
      parse_selector("tag#id")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      [1] "id"
      
      
    Code
      parse_selector("tag1 tag2 tag3")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag1"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "tag2"
      
      [[2]]$class
      character(0)
      
      [[2]]$id
      character(0)
      
      
      [[3]]
      [[3]]$tag
      [1] "tag3"
      
      [[3]]$class
      character(0)
      
      [[3]]$id
      character(0)
      
      
    Code
      parse_selector("tag1 tag2 tag3.class")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag1"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "tag2"
      
      [[2]]$class
      character(0)
      
      [[2]]$id
      character(0)
      
      
      [[3]]
      [[3]]$tag
      [1] "tag3"
      
      [[3]]$class
      [1] "class"
      
      [[3]]$id
      character(0)
      
      
    Code
      parse_selector("tag1 tag2.class tag3")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag1"
      
      [[1]]$class
      character(0)
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "tag2"
      
      [[2]]$class
      [1] "class"
      
      [[2]]$id
      character(0)
      
      
      [[3]]
      [[3]]$tag
      [1] "tag3"
      
      [[3]]$class
      character(0)
      
      [[3]]$id
      character(0)
      
      
    Code
      parse_selector("tag1.class tag2 tag3")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag1"
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "tag2"
      
      [[2]]$class
      character(0)
      
      [[2]]$id
      character(0)
      
      
      [[3]]
      [[3]]$tag
      [1] "tag3"
      
      [[3]]$class
      character(0)
      
      [[3]]$id
      character(0)
      
      
    Code
      parse_selector(".class .subclass")
    Output
      [[1]]
      [[1]]$tag
      character(0)
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      character(0)
      
      [[2]]$class
      [1] "subclass"
      
      [[2]]$id
      character(0)
      
      
    Code
      parse_selector(".class .subclass .subsubclass")
    Output
      [[1]]
      [[1]]$tag
      character(0)
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      character(0)
      
      [[2]]$class
      [1] "subclass"
      
      [[2]]$id
      character(0)
      
      
      [[3]]
      [[3]]$tag
      character(0)
      
      [[3]]$class
      [1] "subsubclass"
      
      [[3]]$id
      character(0)
      
      
    Code
      parse_selector("tag.class .subclass")
    Output
      [[1]]
      [[1]]$tag
      [1] "tag"
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      character(0)
      
      [[2]]$class
      [1] "subclass"
      
      [[2]]$id
      character(0)
      
      
    Code
      parse_selector(".class subtag.subclass")
    Output
      [[1]]
      [[1]]$tag
      character(0)
      
      [[1]]$class
      [1] "class"
      
      [[1]]$id
      character(0)
      
      
      [[2]]
      [[2]]$tag
      [1] "subtag"
      
      [[2]]$class
      [1] "subclass"
      
      [[2]]$id
      character(0)
      
      

