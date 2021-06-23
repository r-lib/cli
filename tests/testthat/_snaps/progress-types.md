# iterator

    Code
      out
    Output
      [1] "\r===============>---------------   50% | ETA:  1s\033[K\r"
      [2] "\r\033[K"                                                  

---

    Code
      out
    Output
      [1] "\r\\ 50 done (100/s) | 3ms\033[K\r" "\r\033[K"                          

# tasks

    Code
      out
    Output
      [1] "\r\\ 50/100 ETA:  1s | \033[K\r" "\r\033[K"                       

---

    Code
      out
    Output
      [1] "\r\\ 50 done (100/s) | 3ms\033[K\r" "\r\033[K"                          

# download

    Code
      out
    Output
      [1] "\r==>---------------------------- |  53 kB/1.0 MB ETA:  1s\033[K\r"
      [2] "\r\033[K"                                                          

---

    Code
      out
    Output
      [1] "\r\\  53 kB (8.5 MB/s) | 3ms\033[K\r"
      [2] "\r\033[K"                            

# customize with options, iterator

    Code
      capture_cli_messages(fun("iterator", 100))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("iterator", NA))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("iterator", 100))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("iterator", NA))
    Output
      [1] "\rnew too 50\033[K\r" "\r\033[K"            

# customize with options, tasks

    Code
      capture_cli_messages(fun("tasks", 100))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("tasks", NA))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("tasks", 100))
    Output
      [1] "\rnew format 50\033[K\r" "\r\033[K"               

---

    Code
      capture_cli_messages(fun("tasks", NA))
    Output
      [1] "\rnew too 50\033[K\r" "\r\033[K"            

# customize with options, download

    Code
      capture_cli_messages(fun("download", 1024 * 1024, 512 * 1024))
    Output
      [1] "\rnew format 524 kB\033[K\r" "\r\033[K"                   

---

    Code
      capture_cli_messages(fun("download", NA, 512 * 1024))
    Output
      [1] "\rnew format 524 kB\033[K\r" "\r\033[K"                   

---

    Code
      capture_cli_messages(fun("download", 1024 * 1024, 512 * 1024))
    Output
      [1] "\rnew format 524 kB\033[K\r" "\r\033[K"                   

---

    Code
      capture_cli_messages(fun("download", NA, 512 * 1024))
    Output
      [1] "\rnew too 524 kB\033[K\r" "\r\033[K"                

