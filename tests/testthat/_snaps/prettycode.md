# reserved [plain]

    Code
      cat(code_highlight("function () { }", list(reserved = "bold")))
    Output
      function () { }
    Code
      cat(code_highlight("if (1) NULL else NULL", list(reserved = "bold")))
    Output
      if (1) NULL else NULL
    Code
      cat(code_highlight("repeat {}", list(reserved = "bold")))
    Output
      repeat {}
    Code
      cat(code_highlight("while (1) {}", list(reserved = "bold")))
    Output
      while (1) {}
    Code
      cat(code_highlight("for (i in x) next", list(reserved = "bold")))
    Output
      for (i in x) next
    Code
      cat(code_highlight("for (i in x) break", list(reserved = "bold")))
    Output
      for (i in x) break

# reserved [ansi]

    Code
      cat(code_highlight("function () { }", list(reserved = "bold")))
    Output
      [1mfunction[22m () { }
    Code
      cat(code_highlight("if (1) NULL else NULL", list(reserved = "bold")))
    Output
      [1mif[22m (1) NULL [1melse[22m NULL
    Code
      cat(code_highlight("repeat {}", list(reserved = "bold")))
    Output
      [1mrepeat[22m {}
    Code
      cat(code_highlight("while (1) {}", list(reserved = "bold")))
    Output
      [1mwhile[22m (1) {}
    Code
      cat(code_highlight("for (i in x) next", list(reserved = "bold")))
    Output
      [1mfor[22m (i [1min[22m x) [1mnext[22m
    Code
      cat(code_highlight("for (i in x) break", list(reserved = "bold")))
    Output
      [1mfor[22m (i [1min[22m x) [1mbreak[22m

# number [plain]

    Code
      cat(code_highlight("1 + 1.0 + -1 + 2L + Inf", list(number = "bold")))
    Output
      1 + 1.0 + -1 + 2L + Inf
    Code
      cat(code_highlight("NA + NA_real_ + NA_integer_ + NA_character_", list(number = "bold")))
    Output
      NA + NA_real_ + NA_integer_ + NA_character_
    Code
      cat(code_highlight("TRUE + FALSE", list(number = "bold")))
    Output
      TRUE + FALSE

# number [ansi]

    Code
      cat(code_highlight("1 + 1.0 + -1 + 2L + Inf", list(number = "bold")))
    Output
      [1m1[22m + [1m1.0[22m + -[1m1[22m + [1m2L[22m + [1mInf[22m
    Code
      cat(code_highlight("NA + NA_real_ + NA_integer_ + NA_character_", list(number = "bold")))
    Output
      [1mNA[22m + [1mNA_real_[22m + [1mNA_integer_[22m + [1mNA_character_[22m
    Code
      cat(code_highlight("TRUE + FALSE", list(number = "bold")))
    Output
      [1mTRUE[22m + [1mFALSE[22m

# null [plain]

    Code
      cat(code_highlight("NULL", list(null = "bold")))
    Output
      NULL

# null [ansi]

    Code
      cat(code_highlight("NULL", list(null = "bold")))
    Output
      [1mNULL[22m

# operator [plain]

    Code
      cat(code_highlight("~ ! 1 - 2 + 3:4 * 5 / 6 ^ 7", list(operator = "bold")))
    Output
      ~ ! 1 - 2 + 3:4 * 5 / 6 ^ 7
    Code
      cat(code_highlight("? 1 %% 2 %+% 2 < 3 & 4 > 5 && 6 == 7 | 8 <= 9 || 10 >= 11",
        list(operator = "bold")))
    Output
      ? 1 %% 2 %+% 2 < 3 & 4 > 5 && 6 == 7 | 8 <= 9 || 10 >= 11
    Code
      cat(code_highlight("a <- 10; 20 -> b; c = 30; a$b; a@b", list(operator = "bold")))
    Output
      a <- 10; 20 -> b; c = 30; a$b; a@b

# operator [ansi]

    Code
      cat(code_highlight("~ ! 1 - 2 + 3:4 * 5 / 6 ^ 7", list(operator = "bold")))
    Output
      [1m~[22m [1m![22m 1 [1m-[22m 2 [1m+[22m 3[1m:[22m4 [1m*[22m 5 [1m/[22m 6 [1m^[22m 7
    Code
      cat(code_highlight("? 1 %% 2 %+% 2 < 3 & 4 > 5 && 6 == 7 | 8 <= 9 || 10 >= 11",
        list(operator = "bold")))
    Output
      [1m?[22m 1 [1m%%[22m 2 [1m%+%[22m 2 [1m<[22m 3 [1m&[22m 4 [1m>[22m 5 [1m&&[22m 6 [1m==[22m 7 [1m|[22m 8 [1m<=[22m 9 [1m||[22m 10 [1m>=[22m 11
    Code
      cat(code_highlight("a <- 10; 20 -> b; c = 30; a$b; a@b", list(operator = "bold")))
    Output
      a [1m<-[22m 10; 20 [1m->[22m b; c [1m=[22m 30; a[1m$[22mb; a[1m@[22mb

# call [plain]

    Code
      cat(code_highlight("ls(2)", list(call = "bold")))
    Output
      ls(2)

# call [ansi]

    Code
      cat(code_highlight("ls(2)", list(call = "bold")))
    Output
      [1mls[22m(2)

# string [plain]

    Code
      cat(code_highlight("'s' + \"s\"", list(string = "bold")))
    Output
      's' + "s"

# string [ansi]

    Code
      cat(code_highlight("'s' + \"s\"", list(string = "bold")))
    Output
      [1m's'[22m + [1m"s"[22m

# comment [plain]

    Code
      cat(code_highlight(c("# COM", " ls() ## ANOT"), list(comment = "bold")))
    Output
      # COM  ls() ## ANOT

# comment [ansi]

    Code
      cat(code_highlight(c("# COM", " ls() ## ANOT"), list(comment = "bold")))
    Output
      [1m# COM[22m  ls() [1m## ANOT[22m

# bracket [plain]

    Code
      cat(code_highlight("foo <- function(x){x}", list(bracket = list("bold"))))
    Output
      foo <- function(x){x}

# bracket [ansi]

    Code
      cat(code_highlight("foo <- function(x){x}", list(bracket = list("bold"))))
    Output
      foo <- function[1m([22mx[1m)[22m[1m{[22mx[1m}[22m

# code_theme_list

    Code
      code_theme_list()
    Output
       [1] "Ambiance"              "Chaos"                 "Chrome"               
       [4] "Clouds"                "Clouds Midnight"       "Cobalt"               
       [7] "Crimson Editor"        "Dawn"                  "Dracula"              
      [10] "Dreamweaver"           "Eclipse"               "Idle Fingers"         
      [13] "Katzenmilch"           "Kr Theme"              "Material"             
      [16] "Merbivore"             "Merbivore Soft"        "Mono Industrial"      
      [19] "Monokai"               "Pastel On Dark"        "Solarized Dark"       
      [22] "Solarized Light"       "Textmate (default)"    "Tomorrow"             
      [25] "Tomorrow Night"        "Tomorrow Night Blue"   "Tomorrow Night Bright"
      [28] "Tomorrow Night 80s"    "Twilight"              "Vibrant Ink"          
      [31] "Xcode"                

# new language features, raw strings [ansi]

    Code
      cat(code_highlight("\"old\" + r\"(\"new\"\"\")\"", list(string = "bold",
        reserved = "italic")))
    Output
      [1m"old"[22m + [3mr[23m[1m"("new""")"[22m

# new language features, pipe [ansi]

    Code
      cat(code_highlight("dir() |> toupper()", list(operator = "bold")))
    Output
      dir() [1m|>[22m toupper()

# new language features, lambda functions [ansi]

    Code
      cat(code_highlight("\\(x) x * 2", list(reserved = "bold")))
    Output
      [1m\[22m(x) x * 2

# strings with tabs [plain]

    Code
      code_highlight("x\t + 1")
    Output
      [1] "x\t + 1"

# strings with tabs [ansi]

    Code
      code_highlight("x\t + 1")
    Output
      [1] "x\t \033[33m+\033[39m \033[35m1\033[39m"

