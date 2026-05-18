# concurrent progress bars on ANSI terminal

    Code
      msgs
    Output
      [1] "\rbar1: 1\033[K\r"                        
      [2] "\rbar1: 1\033[K\n\rbar2: 1\033[K\r"       
      [3] "\033[1A\rbar1: 2\033[K\n\rbar2: 1\033[K\r"
      [4] "\033[1A\r\033[K\n\r\033[K\033[1A"         
      [5] "\rbar2: 1\033[K\r"                        
      [6] "\r\033[K"                                 

# bar completion while others remain (ANSI)

    Code
      msgs
    Output
      [1] "\rfirst: 1\033[K\r"                   
      [2] "\rfirst: 1\033[K\n\rsecond: 1\033[K\r"
      [3] "\033[1A\r\033[K\n\r\033[K\033[1A"     
      [4] "\rsecond: 1\033[K\r"                  
      [5] "\r\033[K"                             

# interleaved cli output with multiple active bars (ANSI)

    Code
      msgs
    Output
      [1] "\rdl: 1\033[K\r"                        
      [2] "\rdl: 1\033[K\n\rproc: 1\033[K\r"       
      [3] "\033[1A\r\033[K\n\r\033[K\033[1A"       
      [4] "i checkpoint\n"                         
      [5] "\rdl: 1\033[K\n\rproc: 1\033[K\r"       
      [6] "\033[1A\rdl: 2\033[K\n\rproc: 1\033[K\r"
      [7] "\033[1A\r\033[K\n\r\033[K\033[1A"       
      [8] "\rproc: 1\033[K\r"                      
      [9] "\r\033[K"                               

# multi-bar keep/done on ANSI

    Code
      msgs
    Output
      [1] "\ra: 1\033[K\r"                      "\ra: 1\033[K\n\rb: 1\033[K\r"       
      [3] "\033[1A\ra: 2\033[K\n\rb: 1\033[K\r" "\033[1A\r\033[K\n\r\033[K\033[1A"   
      [5] "a: 2\n"                              "\rb: 1\033[K\r"                     
      [7] "\rb: 2\033[K\r"                      "\n"                                 

