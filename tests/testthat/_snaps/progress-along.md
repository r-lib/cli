# interpolation uses the right env

    Code
      out
    Output
      [1] "\rx: 10\033[K\r" "\rx: 10\033[K\r" "\rx: 10\033[K\r" "\rx: 10\033[K\r"
      [5] "\r\033[K"       

# cli_progress_along

    Code
      lines
    Output
       [1] "2021-06-18T00:09:14+00:00 cli-36434-1 0/10 created"          
       [2] "2021-06-18T00:09:14+00:00 cli-36434-1 0/10 added"            
       [3] "2021-06-18T00:09:14+00:00 cli-36434-1 1/10 updated"          
       [4] "2021-06-18T00:09:14+00:00 cli-36434-1 2/10 updated"          
       [5] "2021-06-18T00:09:14+00:00 cli-36434-1 3/10 updated"          
       [6] "2021-06-18T00:09:14+00:00 cli-36434-1 4/10 updated"          
       [7] "2021-06-18T00:09:14+00:00 cli-36434-1 5/10 updated"          
       [8] "2021-06-18T00:09:14+00:00 cli-36434-1 6/10 updated"          
       [9] "2021-06-18T00:09:14+00:00 cli-36434-1 7/10 updated"          
      [10] "2021-06-18T00:09:14+00:00 cli-36434-1 8/10 updated"          
      [11] "2021-06-18T00:09:14+00:00 cli-36434-1 9/10 updated"          
      [12] "2021-06-18T00:09:14+00:00 cli-36434-1 9/10 terminated (done)"
      [13] " [1]  1  2  3  4  5  6  7  8  9 10"                          

# cli_progress_along error

    Code
      lines
    Output
      [1] "2021-06-18T00:09:14+00:00 cli-36434-1 0/10 created"            
      [2] "2021-06-18T00:09:14+00:00 cli-36434-1 0/10 added"              
      [3] "2021-06-18T00:09:14+00:00 cli-36434-1 1/10 updated"            
      [4] "2021-06-18T00:09:14+00:00 cli-36434-1 2/10 updated"            
      [5] "2021-06-18T00:09:14+00:00 cli-36434-1 3/10 updated"            
      [6] "2021-06-18T00:09:14+00:00 cli-36434-1 4/10 updated"            
      [7] "2021-06-18T00:09:14+00:00 cli-36434-1 4/10 terminated (failed)"
      [8] "Error in FUN(X[[i]], ...) : oops"                              

# error in handler is a single warning

    Code
      cli_with_ticks(fun())
    Condition
      Warning in `value[[3L]]()`:
      cli progress bar update failed: ! Could not evaluate cli `{}` expression: `1+''`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator
    Output
      [1] 1 2 3 4 5

