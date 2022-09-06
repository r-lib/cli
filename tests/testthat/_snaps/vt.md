# empty input

    Code
      vt_output("", width = 20, height = 2)$segment
    Output
      [1] "                    " "                    "

# raw input

    Code
      vt_output(charToRaw("foobar"), width = 20, height = 2)$segment
    Output
      [1] "foobar              " "                    "

# overflow

    Code
      vt_output(strrep("1234567890", 2), width = 19, height = 2)$segment
    Output
      [1] "1234567890123456789" "0                  "

# control characters

    Code
      vt_output("foo\nbar", width = 20, height = 2)$segment
    Output
      [1] "foo                 " "bar                 "

---

    Code
      vt_output("foobar\rbaz", width = 20, height = 2)$segment
    Output
      [1] "bazbar              " "                    "

# scroll up

    Code
      vt_output(strrep("1234567890", 5), width = 20, height = 2)$segment
    Output
      [1] "12345678901234567890" "1234567890          "

---

    Code
      vt_output(paste0(1:10, "\n"), width = 10, height = 5)$segment
    Output
      [1] "7         " "8         " "9         " "10        " "          "

# ANSI SGR [ansi]

    Code
      vt_output("12\033[31m34\033[1m56\033[39m78\033[21m90", width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1                   12 FALSE  FALSE     FALSE         FALSE
      2      1         1                   34 FALSE  FALSE     FALSE         FALSE
      3      1         1                   56  TRUE  FALSE     FALSE         FALSE
      4      1         1                   78  TRUE  FALSE     FALSE         FALSE
      5      1         1         90           FALSE  FALSE     FALSE         FALSE
      6      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE     1             <NA> <NA>        <NA>
      3 FALSE   FALSE     1             <NA> <NA>        <NA>
      4 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      5 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      6 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      vt_output(style_bold("I'm bold"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1             I'm bold  TRUE  FALSE     FALSE         FALSE
      2      1         1                      FALSE  FALSE     FALSE         FALSE
      3      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      vt_output(style_italic("I'm italic"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1           I'm italic FALSE   TRUE     FALSE         FALSE
      2      1         1                      FALSE  FALSE     FALSE         FALSE
      3      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      vt_output(style_underline("I'm underlined"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1       I'm underlined FALSE  FALSE      TRUE         FALSE
      2      1         1                      FALSE  FALSE     FALSE         FALSE
      3      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      vt_output(style_strikethrough("I'm strikethrough"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1    I'm strikethrough FALSE  FALSE     FALSE          TRUE
      2      1         1                      FALSE  FALSE     FALSE         FALSE
      3      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      vt_output(style_inverse("I'm inverse"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1          I'm inverse FALSE  FALSE     FALSE         FALSE
      2      1         1                      FALSE  FALSE     FALSE         FALSE
      3      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE    TRUE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

# hyperlinks

    Code
      link <- style_hyperlink("text", "url")
      vt_output(c("pre ", st_from_bel(link), " post"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1                 pre  FALSE  FALSE     FALSE         FALSE
      2      1         1                 text FALSE  FALSE     FALSE         FALSE
      3      1         1          post        FALSE  FALSE     FALSE         FALSE
      4      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA>  url            
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      4 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

---

    Code
      link <- style_hyperlink("text", "url", params = c(f = "x", g = "y"))
      vt_output(c("pre ", st_from_bel(link), " post"), width = 20, height = 2)
    Output
        lineno segmentno              segment  bold italic underline strikethrough
      1      1         1                 pre  FALSE  FALSE     FALSE         FALSE
      2      1         1                 text FALSE  FALSE     FALSE         FALSE
      3      1         1          post        FALSE  FALSE     FALSE         FALSE
      4      2         1                      FALSE  FALSE     FALSE         FALSE
        blink inverse color background_color link link_params
      1 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      2 FALSE   FALSE  <NA>             <NA>  url f = x:g = y
      3 FALSE   FALSE  <NA>             <NA> <NA>        <NA>
      4 FALSE   FALSE  <NA>             <NA> <NA>        <NA>

