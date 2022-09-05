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
        lineno segmentno              segment attributes
      1      1         1                   12           
      2      1         1                   34      fg:1;
      3      1         1                   56 fg:1;bold;
      4      1         1                   78      bold;
      5      1         1         90                     
      6      2         1                                

---

    Code
      vt_output(style_bold("I'm bold"), width = 20, height = 2)
    Output
        lineno segmentno              segment attributes
      1      1         1             I'm bold      bold;
      2      1         1                                
      3      2         1                                

---

    Code
      vt_output(style_italic("I'm italic"), width = 20, height = 2)
    Output
        lineno segmentno              segment attributes
      1      1         1           I'm italic    italic;
      2      1         1                                
      3      2         1                                

---

    Code
      vt_output(style_underline("I'm underlined"), width = 20, height = 2)
    Output
        lineno segmentno              segment attributes
      1      1         1       I'm underlined underline;
      2      1         1                                
      3      2         1                                

---

    Code
      vt_output(style_strikethrough("I'm strikethrough"), width = 20, height = 2)
    Output
        lineno segmentno              segment     attributes
      1      1         1    I'm strikethrough strikethrough;
      2      1         1                                    
      3      2         1                                    

---

    Code
      vt_output(style_inverse("I'm inverse"), width = 20, height = 2)
    Output
        lineno segmentno              segment attributes
      1      1         1          I'm inverse   inverse;
      2      1         1                                
      3      2         1                                

