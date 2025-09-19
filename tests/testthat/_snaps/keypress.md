# control characters

    Code
      for (code in c(1:2, 4:6, 8:14, 16L, 20L, 21L, 23L, 27L, 127L)) {
        p$write_input("cli::keypress()\n")
        Sys.sleep(0.1)
        p$write_input(as.raw(code))
        p$poll_io(1000)
        cat(p$read_output())
      }
    Output
      [1] "ctrl-a"
      [1] "ctrl-b"
      [1] "ctrl-d"
      [1] "ctrl-e"
      [1] "ctrl-f"
      [1] "ctrl-h"
      [1] "tab"
      [1] "enter"
      [1] "ctrl-k"
      [1] "ctrl-l"
      [1] "enter"
      [1] "ctrl-n"
      [1] "ctrl-p"
      [1] "ctrl-t"
      [1] "ctrl-u"
      [1] "ctrl-w"
      [1] "escape"
      [1] "backspace"

# write ahead

    Code
      p$write_input("{ Sys.sleep(0.5); cli::keypress() }\nX")
      p$poll_io(1000)
    Output
        output    error  process 
       "ready" "nopipe" "silent" 
    Code
      cat(p$read_output())
    Output
      [1] "X"

# arrows, etc

    Code
      for (key in keys) {
        p$write_input("cli::keypress()\n")
        p$write_input(key)
        p$poll_io(1000)
        cat(p$read_output())
      }
    Output
      [1] "up"
      [1] "right"
      [1] "left"
      [1] "end"
      [1] "home"
      [1] "-"
      [1] "up"
      [1] "down"
      [1] "right"
      [1] "left"
      [1] "end"
      [1] "home"
      [1] "-"
      [1] "home"
      [1] "insert"
      [1] "delete"
      [1] "end"
      [1] "pageup"
      [1] "pagedown"
      [1] "-"
      [1] "pageup"
      [1] "pagedown"
      [1] "-"
      [1] "home"
      [1] "end"
      [1] "-"
      [1] "f1"
      [1] "f2"
      [1] "f3"
      [1] "f4"
      [1] "-"
      [1] "f5"
      [1] "f6"
      [1] "f7"
      [1] "f8"
      [1] "f9"
      [1] "f10"
      [1] "f11"
      [1] "f12"
      [1] "-"
      [1] "f1"
      [1] "f2"
      [1] "f3"
      [1] "f4"
      [1] "-"
      [1] "escape"

# nonblocking

    Code
      p$write_input("cli::keypress(block = FALSE)\n")
      p$poll_io(1000)
    Output
        output    error  process 
       "ready" "nopipe" "silent" 
    Code
      cat(p$read_output())
    Output
      [1] NA

---

    Code
      p$write_input("{ Sys.sleep(0.5); cli::keypress() }\nX")
      p$poll_io(1000)
    Output
        output    error  process 
       "ready" "nopipe" "silent" 
    Code
      cat(p$read_output())
    Output
      [1] "X"

