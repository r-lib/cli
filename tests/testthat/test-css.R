
test_that("parse_selector_node", {

  empty <- list(tag = character(), class = character(), id = character())

  cases <- list(
    list("", empty),
    list("tag", list(tag = "tag")),
    list(".class", list(class = "class")),
    list("#id", list(id = "id")),
    list("tag.class", list(tag = "tag", class = "class")),
    list("tag.c1.c2.c3", list(tag = "tag", class = c("c1", "c2", "c3"))),
    list("tag#id", list(tag = "tag", id = "id")),
    list("tag#id.class", list(tag = "tag", class = "class", id = "id")),
    list("tag.class#id", list(tag = "tag", class = "class", id = "id")),
    list("#id.class", list(class = "class", id = "id")),
    list("#id.c1.c2", list(class = c("c1", "c2"), id = "id")),
    list("#id1#id2", list(id = c("id1", "id2")))
  )

  for (c in cases) {
    exp <- modifyList(empty, c[[2]])
    expect_identical(parse_selector_node(c[[1]]), exp, info = c[[1]])
  }
})

test_that("parse_selector", {

  empty <- list(tag = character(), class = character(), id = character())

  cases <- list(
    list("", list()),
    list("foo", list(list(tag = "foo"))),
    list("foo bar", list(list(tag = "foo"), list(tag = "bar"))),
    list("foo.c1 bar.c2",
         list(list(tag = "foo", class = "c1"),
              list(tag = "bar", class = "c2"))),
    list("#i1 tag #i2 .cl",
         list(list(id = "i1"), list(tag = "tag"), list(id = "i2"),
              list(class = "cl")))
  )

  for (c in cases) {
    exp <- lapply(c[[2]], function(x) modifyList(empty, x))
    expect_identical(parse_selector(c[[1]]), exp, info = c[[1]])
  }
})

test_that("match_selector_node", {

  default <- list(tag = "mytag", class = character(), id = "myid")

  pos <- list(
    list("foo", list(tag = "foo", class = "class"), id = "id"),
    list(".class", list(tag = "foo", class = "class"), id = "id"),
    list("foo.class", list(tag = "foo", class = "class", id = "id")),
    list("#id", list(tag = "foo", class = "class", id = "id")),
    list(".c", list(class = c("c", "d", "e")))
  )

  for (c in pos) {
    sel <- parse_selector_node(c[[1]])
    cnt <- modifyList(default, c[[2]])
    expect_true(match_selector_node(sel, cnt), info = c[[1]])
  }

  neg <- list(
    list("foo", list()),
    list(".class", list()),
    list("#id", list()),
    list("foo.class", list()),
    list("foo.c1.c2", list(tag = "foo", class = c("c1", "c3")))
  )

  for (c in neg) {
    sel <- parse_selector_node(c[[1]])
    cnt <- modifyList(default, c[[2]])
    expect_false(match_selector_node(sel, cnt), info = c[[1]])
  }
  
})

test_that("match_selector", {

  default <- list(tag = "mytag", class = character(), id = "myid")

  pos <- list(
    list("foo bar", list(list(tag = "foo"), list(tag = "bar"))),
    list("bar", list(list(tag = "foo"), list(tag = "bar"))),
    list(".class", list(list(tag = "x"), list(class = "class"))),
    list(".c1",
         list(list(tag = "x"), list(class = "c"), list(class = "c1")))
  )

  for (c in pos) {
    sels <- parse_selector(c[[1]])
    cnts <- lapply(c[[2]], function(x) modifyList(default, x))
    expect_true(match_selector(sels, cnts), info = c[[1]])
  }
  
  neg <- list(
    list("foo bar", list(list(tag = "foo"), list(tag = "ba"))),
    list("foo bar", list(list(tag = "foo"), list(class = "bar"))),
    list(".class", list(list(tag = "x"), list(class = "class1"))),
    list(".c1", list(list(tag = "x"), list(class = "c")))
  )

  for (c in neg) {
    sels <- parse_selector(c[[1]])
    cnts <- lapply(c[[2]], function(x) modifyList(default, x))
    expect_false(match_selector(sels, cnts), info = c[[1]])
  }
})
