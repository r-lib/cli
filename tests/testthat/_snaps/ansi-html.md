# ansi_html

    Code
      ansi_html(str)
    Output
       [1] "<span class=\"ansi ansi-bold\">bold</span>"                          
       [2] "<span class=\"ansi ansi-faint\">faint</span>"                        
       [3] "<span class=\"ansi ansi-italic\">italic</span>"                      
       [4] "<span class=\"ansi ansi-underline\">underline</span>"                
       [5] "<span class=\"ansi ansi-blink\">blink</span>"                        
       [6] "<span class=\"ansi ansi-inverse\">inverse</span>"                    
       [7] "<span class=\"ansi ansi-hide\">hide</span>"                          
       [8] "<span class=\"ansi ansi-crossedout\">crossedout</span>"              
       [9] "<span class=\"ansi ansi-color-0\">black</span>"                      
      [10] "<span class=\"ansi ansi-color-1\">red</span>"                        
      [11] "<span class=\"ansi ansi-color-2\">green</span>"                      
      [12] "<span class=\"ansi ansi-color-3\">yellow</span>"                     
      [13] "<span class=\"ansi ansi-color-4\">blue</span>"                       
      [14] "<span class=\"ansi ansi-color-5\">magenta</span>"                    
      [15] "<span class=\"ansi ansi-color-6\">cyan</span>"                       
      [16] "<span class=\"ansi ansi-color-7\">white</span>"                      
      [17] "<span class=\"ansi ansi-color-0\">bblack</span>"                     
      [18] "<span class=\"ansi ansi-color-1\">bred</span>"                       
      [19] "<span class=\"ansi ansi-color-2\">bgreen</span>"                     
      [20] "<span class=\"ansi ansi-color-3\">byellow</span>"                    
      [21] "<span class=\"ansi ansi-color-4\">bblue</span>"                      
      [22] "<span class=\"ansi ansi-color-5\">bmagenta</span>"                   
      [23] "<span class=\"ansi ansi-color-6\">bcyan</span>"                      
      [24] "<span class=\"ansi ansi-color-7\">bwhite</span>"                     
      [25] "<span class=\"ansi ansi-color-156\">color-156</span>"                
      [26] "<span class=\"ansi ansi-color-1-22-255\">color-1-22-255</span>"      
      [27] "<span class=\"ansi ansi-bg-color-0\">bg-black</span>"                
      [28] "<span class=\"ansi ansi-bg-color-1\">bg-red</span>"                  
      [29] "<span class=\"ansi ansi-bg-color-2\">bg-green</span>"                
      [30] "<span class=\"ansi ansi-bg-color-3\">bg-yellow</span>"               
      [31] "<span class=\"ansi ansi-bg-color-4\">bg-blue</span>"                 
      [32] "<span class=\"ansi ansi-bg-color-5\">bg-magenta</span>"              
      [33] "<span class=\"ansi ansi-bg-color-6\">bg-cyan</span>"                 
      [34] "<span class=\"ansi ansi-bg-color-7\">bg-white</span>"                
      [35] "<span class=\"ansi ansi-bg-color-0\">bg-bblack</span>"               
      [36] "<span class=\"ansi ansi-bg-color-1\">bg-bred</span>"                 
      [37] "<span class=\"ansi ansi-bg-color-2\">bg-bgreen</span>"               
      [38] "<span class=\"ansi ansi-bg-color-3\">bg-byellow</span>"              
      [39] "<span class=\"ansi ansi-bg-color-4\">bg-bblue</span>"                
      [40] "<span class=\"ansi ansi-bg-color-5\">bg-bmagenta</span>"             
      [41] "<span class=\"ansi ansi-bg-color-6\">bg-bcyan</span>"                
      [42] "<span class=\"ansi ansi-bg-color-7\">bg-bwhite</span>"               
      [43] "<span class=\"ansi ansi-bg-color-156\">bg-color-156</span>"          
      [44] "<span class=\"ansi ansi-bg-color-1-22-255\">bg-color-1-22-255</span>"

# multiple styles

    Code
      ansi_html("\033[1;2;35;45mmultiple")
    Output
      [1] "<span class=\"ansi ansi-bold ansi-faint ansi-color-5 ansi-bg-color-5\">multiple</span>"

