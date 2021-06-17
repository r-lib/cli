# cli_progress_message

    Code
      capture_cli_messages(fun())
    Output
      [1] "Simplest progress 'bar', `fn()` 2 twos\n"

# cli_progress_message error

    Code
      readLines(outfile)
    Output
      [1] "Simplest progress 'bar', `fn()` 2 twos"
      [2] "Error in (function ()  : oopsie"       

---

    Code
      rawToChar(readBin(outfile, "raw", 1000))
    Output
      [1] "\033[?25l\rSimplest progress 'bar', `fn()` 2 twos\033[K\r\r\033[K\033[?25hError in (function ()  : oopsie\n"

# cli_progress_step

    Code
      msgs
    Output
      [1] "\ri First step\033[K\r"  "\rv First step\033[K\r" 
      [3] "\n"                      "\ri Second step\033[K\r"
      [5] "\rv Second step\033[K\r" "\n"                     

# cli_progress_step error

    Code
      rawToChar(readBin(outfile, "raw", 1000))
    Output
      [1] "i First step\nv First step\n\ni Second step\nx Second step\n\nError in (function ()  : oopsie\n"

