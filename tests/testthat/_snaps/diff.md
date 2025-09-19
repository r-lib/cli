# diff_chr

    Code
      d$lcs
    Output
        operation offset length old_offset new_offset
      1     match      0      8          8          8
      2    delete      8      1          9          8
      3    insert      8      1          9          9
      4     match      9      7         16         16
      5    insert     16      2         16         18
      6     match     16      1         17         19

---

    Code
      d$lcs
    Output
        operation offset length old_offset new_offset
      1     match      0      8          8          8
      2    delete      8      1          9          8
      3    insert      8      1          9          9
      4     match      9      7         16         16
      5    delete     16      2         18         16
      6     match     18      1         19         17

# diff_chr [plain]

    Code
      d
    Output
      @@ -6,7 +6,7 @@
       1
       1
       2
      -3
      +10
       4
       4
       4
      @@ -14,4 +14,6 @@
       4
       4
       4
      +6
      +7
       5

---

    Code
      d$lcs
    Output
        operation offset length old_offset new_offset
      1     match      0      8          8          8
      2    delete      8      1          9          8
      3    insert      8      1          9          9
      4     match      9      7         16         16
      5    insert     16      2         16         18
      6     match     16      1         17         19

# diff_chr [ansi]

    Code
      d
    Output
      @@ -6,7 +6,7 @@
       1
       1
       2
      [34m-3[39m
      [32m+10[39m
       4
       4
       4
      @@ -14,4 +14,6 @@
       4
       4
       4
      [32m+6[39m
      [32m+7[39m
       5

---

    Code
      d$lcs
    Output
        operation offset length old_offset new_offset
      1     match      0      8          8          8
      2    delete      8      1          9          8
      3    insert      8      1          9          9
      4     match      9      7         16         16
      5    insert     16      2         16         18
      6     match     16      1         17         19

# diff_chr edge cases

    Code
      diff_chr(character(), character())

---

    Code
      diff_chr(character(), character())$lcs
    Output
      [1] operation  offset     length     old_offset new_offset
      <0 rows> (or 0-length row.names)

---

    Code
      diff_chr("a", character())
    Output
      @@ -1 +0 @@
      -a

---

    Code
      diff_chr(character(), "b")
    Output
      @@ -0 +1 @@
      +b

---

    Code
      diff_chr("a", "a")

---

    Code
      diff_chr(letters, letters)

---

    Code
      diff_chr(c("a", NA, "a2"), "b")
    Output
      @@ -1,3 +1 @@
      -a
      -NA
      -a2
      +b

---

    Code
      diff_chr(NA_character_, "NA")
    Output
      @@ -1 +1 @@
      -NA
      +NA

# format.cli_diff_chr context

    Code
      print(d, context = 1)
    Output
      @@ -8,3 +8,3 @@
       2
      -3
      +10
       4
      @@ -16,2 +16,4 @@
       4
      +6
      +7
       5

---

    Code
      print(d, context = 0)
    Output
      @@ -9 +9 @@
      -3
      +10
      @@ -17,0 +17,2 @@
      +6
      +7

---

    Code
      print(d, context = Inf)
    Output
       1
       1
       1
       1
       1
       1
       1
       2
      -3
      +10
       4
       4
       4
       4
       4
       4
       4
      +6
      +7
       5

---

    Code
      print(d2, context = Inf)
    Output
       foo
       bar

# diff_str [plain]

    Code
      d
    Output
      {+PRE+}abcdefg[-hijklm-]{+MIDDLE+}nopqrstuvwxyz{+POST+}

# diff_str [ansi]

    Code
      d
    Output
      [42m[30mPRE[39m[49mabcdefg[44m[30mhijklm[39m[49m[42m[30mMIDDLE[39m[49mnopqrstuvwxyz[42m[30mPOST[39m[49m

# warnings and errors

    Code
      diff_chr(1:10, 1:10)
    Condition
      Error in `diff_chr()`:
      ! is.character(old) is not TRUE
    Code
      format(diff_chr("foo", "bar"), context = -1)
    Condition
      Error in `format.cli_diff_chr()`:
      ! context == Inf || is_count(context) is not TRUE
    Code
      format(diff_chr("foo", "bar"), what = 1, is = 2, this = 3)
    Condition
      Warning in `format.cli_diff_chr()`:
      Extra arguments were ignored in `format.cli_diff_chr()`.
    Output
      [1] "@@ -1 +1 @@" "-foo"        "+bar"       
    Code
      format(diff_str("foo", "bar"), what = 1, is = 2, this = 3)
    Condition
      Warning in `format.cli_diff_str()`:
      Extra arguments were ignored in `format.cli_diff_chr()`.
    Output
      [1] "[-foo-]{+bar+}"

# max_diff

    ! Diff edit distance is larger than the limit.
    i The edit distance limit is 0.

---

    ! Diff edit distance is larger than the limit.
    i The edit distance limit is 1.

