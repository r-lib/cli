# cli_progress_message

    Code
      capture_cli_messages(fun())
    Output
      [1] "Simplest progress 'bar', `fn()` 2 twos\n"

# cli_progress_message error

    Code
      callr::r(fun, stdout = outfile, stderr = outfile)
    Condition
      Error:
      ! in callr subprocess.
      Caused by error:
      ! oopsie

---

    Code
      readLines(outfile)
    Output
      [1] "Simplest progress 'bar', `fn()` 2 twos"
      [2] "Error in (function ()  : oopsie"       

---

    Code
      callr::r(fun2, stdout = outfile, stderr = outfile)
    Condition
      Error:
      ! in callr subprocess.
      Caused by error:
      ! oopsie

---

    Code
      win2unix(out)
    Output
      [1] "\033[?25l\rSimplest progress 'bar', `fn()` 2 twos\033[K\r\r\033[K\033[?25hError in (function ()  : oopsie\n"

# cli_progress_step

    Code
      msgs
    Output
      [1] "\ri First step\033[K\r"       "\rv First step [1s]\033[K\r" 
      [3] "\n"                           "\ri Second step\033[K\r"     
      [5] "\rv Second step [1s]\033[K\r" "\n"                          

# cli_progress_step ignores clear

    Code
      msgs
    Output
      [1] "\ri First step\033[K\r"       "\rv First step [1s]\033[K\r" 
      [3] "\n"                           "\ri Second step\033[K\r"     
      [5] "\rv Second step [1s]\033[K\r" "\n"                          

# cli_progress_step error

    Code
      callr::r(fun, stdout = outfile, stderr = "2>&1")
    Condition
      Error:
      ! in callr subprocess.
      Caused by error:
      ! oopsie

---

    Code
      win2unix(out)
    Output
      [1] "i First step\nv First step [1s]\n\ni Second step\nx Second step [1s]\n\nError in (function ()  : oopsie\n"

