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

# ansi_html_style

    Code
      ansi_html_style(colors = 8)
    Output
      .ansi-bold        { font-weight: bold;             }
      .ansi-italic      { font-style: italic;            }
      .ansi-underline   { text-decoration: underline;    }
      .ansi-blink       { text-decoration: blink;        }
      .ansi-hide        { visibility: hidden;            }
      .ansi-crossedout  { text-decoration: line-through; }
      .ansi-link:hover  { text-decoration: underline;    }
      .ansi-color-0     { color: #000000 }
      .ansi-color-1     { color: #cd3131 }
      .ansi-color-2     { color: #0dbc79 }
      .ansi-color-3     { color: #e5e510 }
      .ansi-color-4     { color: #2472c8 }
      .ansi-color-5     { color: #bc3fbc }
      .ansi-color-6     { color: #11a8cd }
      .ansi-color-7     { color: #e5e5e5 }
      .ansi-color-8     { color: #666666 }
      .ansi-color-9     { color: #f14c4c }
      .ansi-color-10    { color: #23d18b }
      .ansi-color-11    { color: #f5f543 }
      .ansi-color-12    { color: #3b8eea }
      .ansi-color-13    { color: #d670d6 }
      .ansi-color-14    { color: #29b8db }
      .ansi-color-15    { color: #e5e5e5 }
      .ansi-bg-color-0  { background-color: #000000 }
      .ansi-bg-color-1  { background-color: #cd3131 }
      .ansi-bg-color-2  { background-color: #0dbc79 }
      .ansi-bg-color-3  { background-color: #e5e510 }
      .ansi-bg-color-4  { background-color: #2472c8 }
      .ansi-bg-color-5  { background-color: #bc3fbc }
      .ansi-bg-color-6  { background-color: #11a8cd }
      .ansi-bg-color-7  { background-color: #e5e5e5 }
      .ansi-bg-color-8  { background-color: #666666 }
      .ansi-bg-color-9  { background-color: #f14c4c }
      .ansi-bg-color-10 { background-color: #23d18b }
      .ansi-bg-color-11 { background-color: #f5f543 }
      .ansi-bg-color-12 { background-color: #3b8eea }
      .ansi-bg-color-13 { background-color: #d670d6 }
      .ansi-bg-color-14 { background-color: #29b8db }
      .ansi-bg-color-15 { background-color: #e5e5e5 }

---

    Code
      ansi_html_style(colors = 256, palette = "ubuntu")
    Output
      .ansi-bold         { font-weight: bold;             }
      .ansi-italic       { font-style: italic;            }
      .ansi-underline    { text-decoration: underline;    }
      .ansi-blink        { text-decoration: blink;        }
      .ansi-hide         { visibility: hidden;            }
      .ansi-crossedout   { text-decoration: line-through; }
      .ansi-link:hover   { text-decoration: underline;    }
      .ansi-color-0      { color: #010101 }
      .ansi-color-1      { color: #de382b }
      .ansi-color-2      { color: #39b54a }
      .ansi-color-3      { color: #ffc706 }
      .ansi-color-4      { color: #006fb8 }
      .ansi-color-5      { color: #762671 }
      .ansi-color-6      { color: #2cb5e9 }
      .ansi-color-7      { color: #cccccc }
      .ansi-color-8      { color: #808080 }
      .ansi-color-9      { color: #ff0000 }
      .ansi-color-10     { color: #00ff00 }
      .ansi-color-11     { color: #ffff00 }
      .ansi-color-12     { color: #0000ff }
      .ansi-color-13     { color: #ff00ff }
      .ansi-color-14     { color: #00ffff }
      .ansi-color-15     { color: #ffffff }
      .ansi-bg-color-0   { background-color: #010101 }
      .ansi-bg-color-1   { background-color: #de382b }
      .ansi-bg-color-2   { background-color: #39b54a }
      .ansi-bg-color-3   { background-color: #ffc706 }
      .ansi-bg-color-4   { background-color: #006fb8 }
      .ansi-bg-color-5   { background-color: #762671 }
      .ansi-bg-color-6   { background-color: #2cb5e9 }
      .ansi-bg-color-7   { background-color: #cccccc }
      .ansi-bg-color-8   { background-color: #808080 }
      .ansi-bg-color-9   { background-color: #ff0000 }
      .ansi-bg-color-10  { background-color: #00ff00 }
      .ansi-bg-color-11  { background-color: #ffff00 }
      .ansi-bg-color-12  { background-color: #0000ff }
      .ansi-bg-color-13  { background-color: #ff00ff }
      .ansi-bg-color-14  { background-color: #00ffff }
      .ansi-bg-color-15  { background-color: #ffffff }
      .ansi-color-16     { color: #000000 }
      .ansi-color-52     { color: #330000 }
      .ansi-color-88     { color: #660000 }
      .ansi-color-124    { color: #990000 }
      .ansi-color-160    { color: #cc0000 }
      .ansi-color-196    { color: #ff0000 }
      .ansi-color-22     { color: #003300 }
      .ansi-color-58     { color: #333300 }
      .ansi-color-94     { color: #663300 }
      .ansi-color-130    { color: #993300 }
      .ansi-color-166    { color: #cc3300 }
      .ansi-color-202    { color: #ff3300 }
      .ansi-color-28     { color: #006600 }
      .ansi-color-64     { color: #336600 }
      .ansi-color-100    { color: #666600 }
      .ansi-color-136    { color: #996600 }
      .ansi-color-172    { color: #cc6600 }
      .ansi-color-208    { color: #ff6600 }
      .ansi-color-34     { color: #009900 }
      .ansi-color-70     { color: #339900 }
      .ansi-color-106    { color: #669900 }
      .ansi-color-142    { color: #999900 }
      .ansi-color-178    { color: #cc9900 }
      .ansi-color-214    { color: #ff9900 }
      .ansi-color-40     { color: #00cc00 }
      .ansi-color-76     { color: #33cc00 }
      .ansi-color-112    { color: #66cc00 }
      .ansi-color-148    { color: #99cc00 }
      .ansi-color-184    { color: #cccc00 }
      .ansi-color-220    { color: #ffcc00 }
      .ansi-color-46     { color: #00ff00 }
      .ansi-color-82     { color: #33ff00 }
      .ansi-color-118    { color: #66ff00 }
      .ansi-color-154    { color: #99ff00 }
      .ansi-color-190    { color: #ccff00 }
      .ansi-color-226    { color: #ffff00 }
      .ansi-color-17     { color: #000033 }
      .ansi-color-53     { color: #330033 }
      .ansi-color-89     { color: #660033 }
      .ansi-color-125    { color: #990033 }
      .ansi-color-161    { color: #cc0033 }
      .ansi-color-197    { color: #ff0033 }
      .ansi-color-23     { color: #003333 }
      .ansi-color-59     { color: #333333 }
      .ansi-color-95     { color: #663333 }
      .ansi-color-131    { color: #993333 }
      .ansi-color-167    { color: #cc3333 }
      .ansi-color-203    { color: #ff3333 }
      .ansi-color-29     { color: #006633 }
      .ansi-color-65     { color: #336633 }
      .ansi-color-101    { color: #666633 }
      .ansi-color-137    { color: #996633 }
      .ansi-color-173    { color: #cc6633 }
      .ansi-color-209    { color: #ff6633 }
      .ansi-color-35     { color: #009933 }
      .ansi-color-71     { color: #339933 }
      .ansi-color-107    { color: #669933 }
      .ansi-color-143    { color: #999933 }
      .ansi-color-179    { color: #cc9933 }
      .ansi-color-215    { color: #ff9933 }
      .ansi-color-41     { color: #00cc33 }
      .ansi-color-77     { color: #33cc33 }
      .ansi-color-113    { color: #66cc33 }
      .ansi-color-149    { color: #99cc33 }
      .ansi-color-185    { color: #cccc33 }
      .ansi-color-221    { color: #ffcc33 }
      .ansi-color-47     { color: #00ff33 }
      .ansi-color-83     { color: #33ff33 }
      .ansi-color-119    { color: #66ff33 }
      .ansi-color-155    { color: #99ff33 }
      .ansi-color-191    { color: #ccff33 }
      .ansi-color-227    { color: #ffff33 }
      .ansi-color-18     { color: #000066 }
      .ansi-color-54     { color: #330066 }
      .ansi-color-90     { color: #660066 }
      .ansi-color-126    { color: #990066 }
      .ansi-color-162    { color: #cc0066 }
      .ansi-color-198    { color: #ff0066 }
      .ansi-color-24     { color: #003366 }
      .ansi-color-60     { color: #333366 }
      .ansi-color-96     { color: #663366 }
      .ansi-color-132    { color: #993366 }
      .ansi-color-168    { color: #cc3366 }
      .ansi-color-204    { color: #ff3366 }
      .ansi-color-30     { color: #006666 }
      .ansi-color-66     { color: #336666 }
      .ansi-color-102    { color: #666666 }
      .ansi-color-138    { color: #996666 }
      .ansi-color-174    { color: #cc6666 }
      .ansi-color-210    { color: #ff6666 }
      .ansi-color-36     { color: #009966 }
      .ansi-color-72     { color: #339966 }
      .ansi-color-108    { color: #669966 }
      .ansi-color-144    { color: #999966 }
      .ansi-color-180    { color: #cc9966 }
      .ansi-color-216    { color: #ff9966 }
      .ansi-color-42     { color: #00cc66 }
      .ansi-color-78     { color: #33cc66 }
      .ansi-color-114    { color: #66cc66 }
      .ansi-color-150    { color: #99cc66 }
      .ansi-color-186    { color: #cccc66 }
      .ansi-color-222    { color: #ffcc66 }
      .ansi-color-48     { color: #00ff66 }
      .ansi-color-84     { color: #33ff66 }
      .ansi-color-120    { color: #66ff66 }
      .ansi-color-156    { color: #99ff66 }
      .ansi-color-192    { color: #ccff66 }
      .ansi-color-228    { color: #ffff66 }
      .ansi-color-19     { color: #000099 }
      .ansi-color-55     { color: #330099 }
      .ansi-color-91     { color: #660099 }
      .ansi-color-127    { color: #990099 }
      .ansi-color-163    { color: #cc0099 }
      .ansi-color-199    { color: #ff0099 }
      .ansi-color-25     { color: #003399 }
      .ansi-color-61     { color: #333399 }
      .ansi-color-97     { color: #663399 }
      .ansi-color-133    { color: #993399 }
      .ansi-color-169    { color: #cc3399 }
      .ansi-color-205    { color: #ff3399 }
      .ansi-color-31     { color: #006699 }
      .ansi-color-67     { color: #336699 }
      .ansi-color-103    { color: #666699 }
      .ansi-color-139    { color: #996699 }
      .ansi-color-175    { color: #cc6699 }
      .ansi-color-211    { color: #ff6699 }
      .ansi-color-37     { color: #009999 }
      .ansi-color-73     { color: #339999 }
      .ansi-color-109    { color: #669999 }
      .ansi-color-145    { color: #999999 }
      .ansi-color-181    { color: #cc9999 }
      .ansi-color-217    { color: #ff9999 }
      .ansi-color-43     { color: #00cc99 }
      .ansi-color-79     { color: #33cc99 }
      .ansi-color-115    { color: #66cc99 }
      .ansi-color-151    { color: #99cc99 }
      .ansi-color-187    { color: #cccc99 }
      .ansi-color-223    { color: #ffcc99 }
      .ansi-color-49     { color: #00ff99 }
      .ansi-color-85     { color: #33ff99 }
      .ansi-color-121    { color: #66ff99 }
      .ansi-color-157    { color: #99ff99 }
      .ansi-color-193    { color: #ccff99 }
      .ansi-color-229    { color: #ffff99 }
      .ansi-color-20     { color: #0000cc }
      .ansi-color-56     { color: #3300cc }
      .ansi-color-92     { color: #6600cc }
      .ansi-color-128    { color: #9900cc }
      .ansi-color-164    { color: #cc00cc }
      .ansi-color-200    { color: #ff00cc }
      .ansi-color-26     { color: #0033cc }
      .ansi-color-62     { color: #3333cc }
      .ansi-color-98     { color: #6633cc }
      .ansi-color-134    { color: #9933cc }
      .ansi-color-170    { color: #cc33cc }
      .ansi-color-206    { color: #ff33cc }
      .ansi-color-32     { color: #0066cc }
      .ansi-color-68     { color: #3366cc }
      .ansi-color-104    { color: #6666cc }
      .ansi-color-140    { color: #9966cc }
      .ansi-color-176    { color: #cc66cc }
      .ansi-color-212    { color: #ff66cc }
      .ansi-color-38     { color: #0099cc }
      .ansi-color-74     { color: #3399cc }
      .ansi-color-110    { color: #6699cc }
      .ansi-color-146    { color: #9999cc }
      .ansi-color-182    { color: #cc99cc }
      .ansi-color-218    { color: #ff99cc }
      .ansi-color-44     { color: #00cccc }
      .ansi-color-80     { color: #33cccc }
      .ansi-color-116    { color: #66cccc }
      .ansi-color-152    { color: #99cccc }
      .ansi-color-188    { color: #cccccc }
      .ansi-color-224    { color: #ffcccc }
      .ansi-color-50     { color: #00ffcc }
      .ansi-color-86     { color: #33ffcc }
      .ansi-color-122    { color: #66ffcc }
      .ansi-color-158    { color: #99ffcc }
      .ansi-color-194    { color: #ccffcc }
      .ansi-color-230    { color: #ffffcc }
      .ansi-color-21     { color: #0000ff }
      .ansi-color-57     { color: #3300ff }
      .ansi-color-93     { color: #6600ff }
      .ansi-color-129    { color: #9900ff }
      .ansi-color-165    { color: #cc00ff }
      .ansi-color-201    { color: #ff00ff }
      .ansi-color-27     { color: #0033ff }
      .ansi-color-63     { color: #3333ff }
      .ansi-color-99     { color: #6633ff }
      .ansi-color-135    { color: #9933ff }
      .ansi-color-171    { color: #cc33ff }
      .ansi-color-207    { color: #ff33ff }
      .ansi-color-33     { color: #0066ff }
      .ansi-color-69     { color: #3366ff }
      .ansi-color-105    { color: #6666ff }
      .ansi-color-141    { color: #9966ff }
      .ansi-color-177    { color: #cc66ff }
      .ansi-color-213    { color: #ff66ff }
      .ansi-color-39     { color: #0099ff }
      .ansi-color-75     { color: #3399ff }
      .ansi-color-111    { color: #6699ff }
      .ansi-color-147    { color: #9999ff }
      .ansi-color-183    { color: #cc99ff }
      .ansi-color-219    { color: #ff99ff }
      .ansi-color-45     { color: #00ccff }
      .ansi-color-81     { color: #33ccff }
      .ansi-color-117    { color: #66ccff }
      .ansi-color-153    { color: #99ccff }
      .ansi-color-189    { color: #ccccff }
      .ansi-color-225    { color: #ffccff }
      .ansi-color-51     { color: #00ffff }
      .ansi-color-87     { color: #33ffff }
      .ansi-color-123    { color: #66ffff }
      .ansi-color-159    { color: #99ffff }
      .ansi-color-195    { color: #ccffff }
      .ansi-color-231    { color: #ffffff }
      .ansi-color-232    { color: #0a0a0a }
      .ansi-color-233    { color: #141414 }
      .ansi-color-234    { color: #1f1f1f }
      .ansi-color-235    { color: #292929 }
      .ansi-color-236    { color: #333333 }
      .ansi-color-237    { color: #3d3d3d }
      .ansi-color-238    { color: #474747 }
      .ansi-color-239    { color: #525252 }
      .ansi-color-240    { color: #5c5c5c }
      .ansi-color-241    { color: #666666 }
      .ansi-color-242    { color: #707070 }
      .ansi-color-243    { color: #7a7a7a }
      .ansi-color-244    { color: #858585 }
      .ansi-color-245    { color: #8f8f8f }
      .ansi-color-246    { color: #999999 }
      .ansi-color-247    { color: #a3a3a3 }
      .ansi-color-248    { color: #adadad }
      .ansi-color-249    { color: #b8b8b8 }
      .ansi-color-250    { color: #c2c2c2 }
      .ansi-color-251    { color: #cccccc }
      .ansi-color-252    { color: #d6d6d6 }
      .ansi-color-253    { color: #e0e0e0 }
      .ansi-color-254    { color: #ebebeb }
      .ansi-color-255    { color: #f5f5f5 }
      .ansi-bg-color-16  { background-color: #000000 }
      .ansi-bg-color-52  { background-color: #330000 }
      .ansi-bg-color-88  { background-color: #660000 }
      .ansi-bg-color-124 { background-color: #990000 }
      .ansi-bg-color-160 { background-color: #cc0000 }
      .ansi-bg-color-196 { background-color: #ff0000 }
      .ansi-bg-color-22  { background-color: #003300 }
      .ansi-bg-color-58  { background-color: #333300 }
      .ansi-bg-color-94  { background-color: #663300 }
      .ansi-bg-color-130 { background-color: #993300 }
      .ansi-bg-color-166 { background-color: #cc3300 }
      .ansi-bg-color-202 { background-color: #ff3300 }
      .ansi-bg-color-28  { background-color: #006600 }
      .ansi-bg-color-64  { background-color: #336600 }
      .ansi-bg-color-100 { background-color: #666600 }
      .ansi-bg-color-136 { background-color: #996600 }
      .ansi-bg-color-172 { background-color: #cc6600 }
      .ansi-bg-color-208 { background-color: #ff6600 }
      .ansi-bg-color-34  { background-color: #009900 }
      .ansi-bg-color-70  { background-color: #339900 }
      .ansi-bg-color-106 { background-color: #669900 }
      .ansi-bg-color-142 { background-color: #999900 }
      .ansi-bg-color-178 { background-color: #cc9900 }
      .ansi-bg-color-214 { background-color: #ff9900 }
      .ansi-bg-color-40  { background-color: #00cc00 }
      .ansi-bg-color-76  { background-color: #33cc00 }
      .ansi-bg-color-112 { background-color: #66cc00 }
      .ansi-bg-color-148 { background-color: #99cc00 }
      .ansi-bg-color-184 { background-color: #cccc00 }
      .ansi-bg-color-220 { background-color: #ffcc00 }
      .ansi-bg-color-46  { background-color: #00ff00 }
      .ansi-bg-color-82  { background-color: #33ff00 }
      .ansi-bg-color-118 { background-color: #66ff00 }
      .ansi-bg-color-154 { background-color: #99ff00 }
      .ansi-bg-color-190 { background-color: #ccff00 }
      .ansi-bg-color-226 { background-color: #ffff00 }
      .ansi-bg-color-17  { background-color: #000033 }
      .ansi-bg-color-53  { background-color: #330033 }
      .ansi-bg-color-89  { background-color: #660033 }
      .ansi-bg-color-125 { background-color: #990033 }
      .ansi-bg-color-161 { background-color: #cc0033 }
      .ansi-bg-color-197 { background-color: #ff0033 }
      .ansi-bg-color-23  { background-color: #003333 }
      .ansi-bg-color-59  { background-color: #333333 }
      .ansi-bg-color-95  { background-color: #663333 }
      .ansi-bg-color-131 { background-color: #993333 }
      .ansi-bg-color-167 { background-color: #cc3333 }
      .ansi-bg-color-203 { background-color: #ff3333 }
      .ansi-bg-color-29  { background-color: #006633 }
      .ansi-bg-color-65  { background-color: #336633 }
      .ansi-bg-color-101 { background-color: #666633 }
      .ansi-bg-color-137 { background-color: #996633 }
      .ansi-bg-color-173 { background-color: #cc6633 }
      .ansi-bg-color-209 { background-color: #ff6633 }
      .ansi-bg-color-35  { background-color: #009933 }
      .ansi-bg-color-71  { background-color: #339933 }
      .ansi-bg-color-107 { background-color: #669933 }
      .ansi-bg-color-143 { background-color: #999933 }
      .ansi-bg-color-179 { background-color: #cc9933 }
      .ansi-bg-color-215 { background-color: #ff9933 }
      .ansi-bg-color-41  { background-color: #00cc33 }
      .ansi-bg-color-77  { background-color: #33cc33 }
      .ansi-bg-color-113 { background-color: #66cc33 }
      .ansi-bg-color-149 { background-color: #99cc33 }
      .ansi-bg-color-185 { background-color: #cccc33 }
      .ansi-bg-color-221 { background-color: #ffcc33 }
      .ansi-bg-color-47  { background-color: #00ff33 }
      .ansi-bg-color-83  { background-color: #33ff33 }
      .ansi-bg-color-119 { background-color: #66ff33 }
      .ansi-bg-color-155 { background-color: #99ff33 }
      .ansi-bg-color-191 { background-color: #ccff33 }
      .ansi-bg-color-227 { background-color: #ffff33 }
      .ansi-bg-color-18  { background-color: #000066 }
      .ansi-bg-color-54  { background-color: #330066 }
      .ansi-bg-color-90  { background-color: #660066 }
      .ansi-bg-color-126 { background-color: #990066 }
      .ansi-bg-color-162 { background-color: #cc0066 }
      .ansi-bg-color-198 { background-color: #ff0066 }
      .ansi-bg-color-24  { background-color: #003366 }
      .ansi-bg-color-60  { background-color: #333366 }
      .ansi-bg-color-96  { background-color: #663366 }
      .ansi-bg-color-132 { background-color: #993366 }
      .ansi-bg-color-168 { background-color: #cc3366 }
      .ansi-bg-color-204 { background-color: #ff3366 }
      .ansi-bg-color-30  { background-color: #006666 }
      .ansi-bg-color-66  { background-color: #336666 }
      .ansi-bg-color-102 { background-color: #666666 }
      .ansi-bg-color-138 { background-color: #996666 }
      .ansi-bg-color-174 { background-color: #cc6666 }
      .ansi-bg-color-210 { background-color: #ff6666 }
      .ansi-bg-color-36  { background-color: #009966 }
      .ansi-bg-color-72  { background-color: #339966 }
      .ansi-bg-color-108 { background-color: #669966 }
      .ansi-bg-color-144 { background-color: #999966 }
      .ansi-bg-color-180 { background-color: #cc9966 }
      .ansi-bg-color-216 { background-color: #ff9966 }
      .ansi-bg-color-42  { background-color: #00cc66 }
      .ansi-bg-color-78  { background-color: #33cc66 }
      .ansi-bg-color-114 { background-color: #66cc66 }
      .ansi-bg-color-150 { background-color: #99cc66 }
      .ansi-bg-color-186 { background-color: #cccc66 }
      .ansi-bg-color-222 { background-color: #ffcc66 }
      .ansi-bg-color-48  { background-color: #00ff66 }
      .ansi-bg-color-84  { background-color: #33ff66 }
      .ansi-bg-color-120 { background-color: #66ff66 }
      .ansi-bg-color-156 { background-color: #99ff66 }
      .ansi-bg-color-192 { background-color: #ccff66 }
      .ansi-bg-color-228 { background-color: #ffff66 }
      .ansi-bg-color-19  { background-color: #000099 }
      .ansi-bg-color-55  { background-color: #330099 }
      .ansi-bg-color-91  { background-color: #660099 }
      .ansi-bg-color-127 { background-color: #990099 }
      .ansi-bg-color-163 { background-color: #cc0099 }
      .ansi-bg-color-199 { background-color: #ff0099 }
      .ansi-bg-color-25  { background-color: #003399 }
      .ansi-bg-color-61  { background-color: #333399 }
      .ansi-bg-color-97  { background-color: #663399 }
      .ansi-bg-color-133 { background-color: #993399 }
      .ansi-bg-color-169 { background-color: #cc3399 }
      .ansi-bg-color-205 { background-color: #ff3399 }
      .ansi-bg-color-31  { background-color: #006699 }
      .ansi-bg-color-67  { background-color: #336699 }
      .ansi-bg-color-103 { background-color: #666699 }
      .ansi-bg-color-139 { background-color: #996699 }
      .ansi-bg-color-175 { background-color: #cc6699 }
      .ansi-bg-color-211 { background-color: #ff6699 }
      .ansi-bg-color-37  { background-color: #009999 }
      .ansi-bg-color-73  { background-color: #339999 }
      .ansi-bg-color-109 { background-color: #669999 }
      .ansi-bg-color-145 { background-color: #999999 }
      .ansi-bg-color-181 { background-color: #cc9999 }
      .ansi-bg-color-217 { background-color: #ff9999 }
      .ansi-bg-color-43  { background-color: #00cc99 }
      .ansi-bg-color-79  { background-color: #33cc99 }
      .ansi-bg-color-115 { background-color: #66cc99 }
      .ansi-bg-color-151 { background-color: #99cc99 }
      .ansi-bg-color-187 { background-color: #cccc99 }
      .ansi-bg-color-223 { background-color: #ffcc99 }
      .ansi-bg-color-49  { background-color: #00ff99 }
      .ansi-bg-color-85  { background-color: #33ff99 }
      .ansi-bg-color-121 { background-color: #66ff99 }
      .ansi-bg-color-157 { background-color: #99ff99 }
      .ansi-bg-color-193 { background-color: #ccff99 }
      .ansi-bg-color-229 { background-color: #ffff99 }
      .ansi-bg-color-20  { background-color: #0000cc }
      .ansi-bg-color-56  { background-color: #3300cc }
      .ansi-bg-color-92  { background-color: #6600cc }
      .ansi-bg-color-128 { background-color: #9900cc }
      .ansi-bg-color-164 { background-color: #cc00cc }
      .ansi-bg-color-200 { background-color: #ff00cc }
      .ansi-bg-color-26  { background-color: #0033cc }
      .ansi-bg-color-62  { background-color: #3333cc }
      .ansi-bg-color-98  { background-color: #6633cc }
      .ansi-bg-color-134 { background-color: #9933cc }
      .ansi-bg-color-170 { background-color: #cc33cc }
      .ansi-bg-color-206 { background-color: #ff33cc }
      .ansi-bg-color-32  { background-color: #0066cc }
      .ansi-bg-color-68  { background-color: #3366cc }
      .ansi-bg-color-104 { background-color: #6666cc }
      .ansi-bg-color-140 { background-color: #9966cc }
      .ansi-bg-color-176 { background-color: #cc66cc }
      .ansi-bg-color-212 { background-color: #ff66cc }
      .ansi-bg-color-38  { background-color: #0099cc }
      .ansi-bg-color-74  { background-color: #3399cc }
      .ansi-bg-color-110 { background-color: #6699cc }
      .ansi-bg-color-146 { background-color: #9999cc }
      .ansi-bg-color-182 { background-color: #cc99cc }
      .ansi-bg-color-218 { background-color: #ff99cc }
      .ansi-bg-color-44  { background-color: #00cccc }
      .ansi-bg-color-80  { background-color: #33cccc }
      .ansi-bg-color-116 { background-color: #66cccc }
      .ansi-bg-color-152 { background-color: #99cccc }
      .ansi-bg-color-188 { background-color: #cccccc }
      .ansi-bg-color-224 { background-color: #ffcccc }
      .ansi-bg-color-50  { background-color: #00ffcc }
      .ansi-bg-color-86  { background-color: #33ffcc }
      .ansi-bg-color-122 { background-color: #66ffcc }
      .ansi-bg-color-158 { background-color: #99ffcc }
      .ansi-bg-color-194 { background-color: #ccffcc }
      .ansi-bg-color-230 { background-color: #ffffcc }
      .ansi-bg-color-21  { background-color: #0000ff }
      .ansi-bg-color-57  { background-color: #3300ff }
      .ansi-bg-color-93  { background-color: #6600ff }
      .ansi-bg-color-129 { background-color: #9900ff }
      .ansi-bg-color-165 { background-color: #cc00ff }
      .ansi-bg-color-201 { background-color: #ff00ff }
      .ansi-bg-color-27  { background-color: #0033ff }
      .ansi-bg-color-63  { background-color: #3333ff }
      .ansi-bg-color-99  { background-color: #6633ff }
      .ansi-bg-color-135 { background-color: #9933ff }
      .ansi-bg-color-171 { background-color: #cc33ff }
      .ansi-bg-color-207 { background-color: #ff33ff }
      .ansi-bg-color-33  { background-color: #0066ff }
      .ansi-bg-color-69  { background-color: #3366ff }
      .ansi-bg-color-105 { background-color: #6666ff }
      .ansi-bg-color-141 { background-color: #9966ff }
      .ansi-bg-color-177 { background-color: #cc66ff }
      .ansi-bg-color-213 { background-color: #ff66ff }
      .ansi-bg-color-39  { background-color: #0099ff }
      .ansi-bg-color-75  { background-color: #3399ff }
      .ansi-bg-color-111 { background-color: #6699ff }
      .ansi-bg-color-147 { background-color: #9999ff }
      .ansi-bg-color-183 { background-color: #cc99ff }
      .ansi-bg-color-219 { background-color: #ff99ff }
      .ansi-bg-color-45  { background-color: #00ccff }
      .ansi-bg-color-81  { background-color: #33ccff }
      .ansi-bg-color-117 { background-color: #66ccff }
      .ansi-bg-color-153 { background-color: #99ccff }
      .ansi-bg-color-189 { background-color: #ccccff }
      .ansi-bg-color-225 { background-color: #ffccff }
      .ansi-bg-color-51  { background-color: #00ffff }
      .ansi-bg-color-87  { background-color: #33ffff }
      .ansi-bg-color-123 { background-color: #66ffff }
      .ansi-bg-color-159 { background-color: #99ffff }
      .ansi-bg-color-195 { background-color: #ccffff }
      .ansi-bg-color-231 { background-color: #ffffff }
      .ansi-bg-color-232 { background-color: #0a0a0a }
      .ansi-bg-color-233 { background-color: #141414 }
      .ansi-bg-color-234 { background-color: #1f1f1f }
      .ansi-bg-color-235 { background-color: #292929 }
      .ansi-bg-color-236 { background-color: #333333 }
      .ansi-bg-color-237 { background-color: #3d3d3d }
      .ansi-bg-color-238 { background-color: #474747 }
      .ansi-bg-color-239 { background-color: #525252 }
      .ansi-bg-color-240 { background-color: #5c5c5c }
      .ansi-bg-color-241 { background-color: #666666 }
      .ansi-bg-color-242 { background-color: #707070 }
      .ansi-bg-color-243 { background-color: #7a7a7a }
      .ansi-bg-color-244 { background-color: #858585 }
      .ansi-bg-color-245 { background-color: #8f8f8f }
      .ansi-bg-color-246 { background-color: #999999 }
      .ansi-bg-color-247 { background-color: #a3a3a3 }
      .ansi-bg-color-248 { background-color: #adadad }
      .ansi-bg-color-249 { background-color: #b8b8b8 }
      .ansi-bg-color-250 { background-color: #c2c2c2 }
      .ansi-bg-color-251 { background-color: #cccccc }
      .ansi-bg-color-252 { background-color: #d6d6d6 }
      .ansi-bg-color-253 { background-color: #e0e0e0 }
      .ansi-bg-color-254 { background-color: #ebebeb }
      .ansi-bg-color-255 { background-color: #f5f5f5 }

