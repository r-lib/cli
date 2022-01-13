# cli_progress_bar

    Code
      capture_cli_messages(fun())
    Output
      [1] "\\ name status 1\n"

# removes previous progress bar

    Code
      capture_cli_messages(fun())
    Output
      [1] "first\n"       "first done\n"  "\n"            "second\n"     
      [5] "second done\n" "\n"           

# cli_progress_update can update status

    Code
      capture_cli_messages(fun())
    Output
      [1] "\\ name status 1\n"    "| name new status 2\n"

# cli_progress_update can update extra data

    Code
      capture_cli_messages(fun())
    Output
      [1] "Extra: bar\n" "Extra: baz\n"

# update set

    Code
      capture_cli_messages(fun())
    Output
      [1] "name 1/100\n"  "name 50/100\n"

# format changes if we (un)learn total

    Code
      out
    Output
      [1] "\\ name 1 done (100/s) | 3ms\n"                         
      [2] "name ===============>---------------   50% | ETA:  1s\n"
      [3] "/ name 75 done (100/s) | 3ms\n"                         

# auto-terminate

    Code
      capture_cli_messages(fun())
    Output
      [1] "first\n"                 "first done\n"           
      [3] "\n"                      "First is done by now.\n"
      [5] "second\n"                "second done\n"          
      [7] "\n"                     

# cli_progress_output

    Code
      capture_cli_messages(fun())
    Output
      [1] "\rfirst\033[K\r" "\r\033[K"        "just 1 text\n"   "first\r"        
      [5] "\rfirst\033[K\r" "\r\033[K"       

---

    Code
      capture_cli_messages(fun())
    Output
      [1] "\rfirst\r"     "\r      \r"    "just 1 text\n" "first\r"      
      [5] "\rfirst\r"     "\r      \r"   

