# c api #1

    Code
      out
    Output
       [1] "\r ===>---------------------------   10% |  ETA:  1s\033[K\r"
       [2] "\r ======>------------------------   20% |  ETA:  1s\033[K\r"
       [3] "\r =========>---------------------   30% |  ETA:  1s\033[K\r"
       [4] "\r ============>------------------   40% |  ETA:  1s\033[K\r"
       [5] "\r ===============>---------------   50% |  ETA:  1s\033[K\r"
       [6] "\r ==================>------------   60% |  ETA:  1s\033[K\r"
       [7] "\r =====================>---------   70% |  ETA:  1s\033[K\r"
       [8] "\r ========================>------   80% |  ETA:  1s\033[K\r"
       [9] "\r ===========================>---   90% |  ETA:  1s\033[K\r"
      [10] "\r\033[K"                                                    

---

    Code
      out
    Output
       [1] "\r1/10\033[K\r" "\r2/10\033[K\r" "\r3/10\033[K\r" "\r4/10\033[K\r"
       [5] "\r5/10\033[K\r" "\r6/10\033[K\r" "\r7/10\033[K\r" "\r8/10\033[K\r"
       [9] "\r9/10\033[K\r" "\r\033[K"      

---

    Code
      .Call(dll$clitest__progress_crud, list(123))
    Condition
      Error:
      ! Invalid cli progress bar configuration, list elements must be named.

---

    Code
      .Call(dll$clitest__progress_crud, 100L)
    Condition
      Error:
      ! Unknown cli progress bar configuration, see manual.

---

    Code
      out
    Output
       [1] "\rme llama 1\033[K\r" "\rme llama 2\033[K\r" "\rme llama 3\033[K\r"
       [4] "\rme llama 4\033[K\r" "\rme llama 5\033[K\r" "\rme llama 6\033[K\r"
       [7] "\rme llama 7\033[K\r" "\rme llama 8\033[K\r" "\rme llama 9\033[K\r"
      [10] "\r\033[K"            

---

    Code
      out
    Output
       [1] "\rnew name stats 1\033[K\r"  "\rnew name stats 2\033[K\r" 
       [3] "\rnew name stats 3\033[K\r"  "\rnew name stats 4\033[K\r" 
       [5] "\rnew name stats 5\033[K\r"  "\rnew name stats 6\033[K\r" 
       [7] "\rnew name stats 7\033[K\r"  "\rnew name stats 8\033[K\r" 
       [9] "\rnew name stats 9\033[K\r"  "\rnew name stats 10\033[K\r"
      [11] "\n"                         

---

    Code
      out
    Output
       [1] "\r 1\033[K\r" "\r 2\033[K\r" "\r 3\033[K\r" "\r 4\033[K\r" "\r 5\033[K\r"
       [6] "\r 6\033[K\r" "\r 7\033[K\r" "\r 8\033[K\r" "\r 9\033[K\r" "\r\033[K"    

---

    Code
      out
    Output
       [1] "\r 1\033[K\r" "\r 2\033[K\r" "\r 3\033[K\r" "\r 4\033[K\r" "\r 5\033[K\r"
       [6] "\r 6\033[K\r" "\r 7\033[K\r" "\r 8\033[K\r" "\r 9\033[K\r" "\r\033[K"    

---

    Code
      out
    Output
       [1] "\r 1\033[K\r" "\r 2\033[K\r" "\r 3\033[K\r" "\r 4\033[K\r" "\r 5\033[K\r"
       [6] "\r 6\033[K\r" "\r 7\033[K\r" "\r 8\033[K\r" "\r 9\033[K\r" "\r\033[K"    

---

    Code
      out
    Output
       [1] "\r 1\033[K\r" "\r 2\033[K\r" "\r 3\033[K\r" "\r 4\033[K\r" "\r 5\033[K\r"
       [6] "\r 6\033[K\r" "\r 7\033[K\r" "\r 8\033[K\r" "\r 9\033[K\r" "\r\033[K"    

---

    Code
      out
    Output
       [1] "2021-06-18T00:09:14+00:00 cli-36434-1 1/10 added"             
       [2] "2021-06-18T00:09:14+00:00 cli-36434-1 1/10 updated"           
       [3] "2021-06-18T00:09:14+00:00 cli-36434-1 2/10 updated"           
       [4] "2021-06-18T00:09:14+00:00 cli-36434-1 3/10 updated"           
       [5] "2021-06-18T00:09:14+00:00 cli-36434-1 4/10 updated"           
       [6] "2021-06-18T00:09:14+00:00 cli-36434-1 5/10 updated"           
       [7] "2021-06-18T00:09:14+00:00 cli-36434-1 6/10 updated"           
       [8] "2021-06-18T00:09:14+00:00 cli-36434-1 7/10 updated"           
       [9] "2021-06-18T00:09:14+00:00 cli-36434-1 8/10 updated"           
      [10] "2021-06-18T00:09:14+00:00 cli-36434-1 9/10 updated"           
      [11] "2021-06-18T00:09:14+00:00 cli-36434-1 10/10 terminated (done)"

---

    Code
      out
    Output
       [1] "\r1/10\033[K\r"               "\r2/10\033[K\r"              
       [3] "\r3/10\033[K\r"               "\r4/10\033[K\r"              
       [5] "\r5/10\033[K\r"               "\r6/10\033[K\r"              
       [7] "\r7/10\033[K\r"               "\r8/10\033[K\r"              
       [9] "\r9/10\033[K\r"               "\rJust did 10 steps.\033[K\r"
      [11] "\n"                          

# clic__find_var

    Code
      .Call(clic__find_var, env, as.symbol("x"))
    Condition
      Error:
      ! Cannot find variable `x`.

---

    Code
      .Call(clic__find_var, environment(), as.symbol(basename(tempfile())))
    Condition
      Error:
      ! Cannot find variable `<tmpfile>`.

