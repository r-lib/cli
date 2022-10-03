# re_table

    Code
      tbl2
    Output
            start end   length                                
      text1 "19"  "23"  "5"    "\033[31m"                     
      text2 "27"  "31"  "5"    "\033[39m"                     
      text3 "48"  "52"  "5"    "\033[32m"                     
      text4 "58"  "62"  "5"    "\033[39m"                     
      text5 "74"  "98"  "25"   "\033]8;;https://example.com\a"
      text6 "103" "108" "6"    "\033]8;;\a"                   

---

    Code
      non_matching(list(tbl), txt)
    Output
      [[1]]
           start end length
      [1,]     1  18     18
      [2,]    24  26      3
      [3,]    32  47     16
      [4,]    53  57      5
      [5,]    63  73     11
      [6,]    99 102      4
      

# re_table special cases

    Code
      tbl
    Output
           start end length

---

    Code
      non_matching(list(tbl), txt)
    Output
      [[1]]
           start end length
      [1,]     1   6      6
      

---

    Code
      non_matching(list(tbl), txt, empty = TRUE)
    Output
      [[1]]
           start end length
      [1,]     1   6      6
      

---

    Code
      tbl
    Output
           start end length
      [1,]     1   5      5
      [2,]    12  16      5

---

    Code
      non_matching(list(tbl), txt)
    Output
      [[1]]
           start end length
      [1,]     6  11      6
      

---

    Code
      non_matching(list(tbl), txt, empty = TRUE)
    Output
      [[1]]
           start end length
      [1,]     1   0      0
      [2,]     6  11      6
      [3,]    17  16      0
      

---

    Code
      tbl
    Output
           start end length
      [1,]     5   9      5
      [2,]    10  14      5

---

    Code
      non_matching(list(tbl), txt)
    Output
      [[1]]
           start end length
      [1,]     1   4      4
      [2,]    15  18      4
      

---

    Code
      non_matching(list(tbl), txt, empty = TRUE)
    Output
      [[1]]
           start end length
      [1,]     1   4      4
      [2,]    10   9      0
      [3,]    15  18      4
      

# myseq

    Code
      myseq(1, 5)
    Output
      [1] 1 2 3 4 5
    Code
      myseq(1, 1)
    Output
      [1] 1
    Code
      myseq(1, 0)
    Output
      integer(0)
    Code
      myseq(1, 5, 2)
    Output
      [1] 1 3 5
    Code
      myseq(1, 6, 2)
    Output
      [1] 1 3 5
    Code
      myseq(1, 1, 2)
    Output
      [1] 1
    Code
      myseq(1, 2, -1)
    Output
      integer(0)
    Code
      myseq(10, 1, -1)
    Output
       [1] 10  9  8  7  6  5  4  3  2  1
    Code
      myseq(10, 1, -2)
    Output
      [1] 10  8  6  4  2
    Code
      myseq(1, 5, -2)
    Output
      integer(0)

