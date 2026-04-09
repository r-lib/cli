# List all available spinners

List all available spinners

## Usage

``` r
list_spinners()
```

## Value

Character vector of all available spinner names.

## See also

Other spinners:
[`demo_spinners()`](https://cli.r-lib.org/reference/demo_spinners.md),
[`get_spinner()`](https://cli.r-lib.org/reference/get_spinner.md),
[`make_spinner()`](https://cli.r-lib.org/reference/make_spinner.md)

## Examples

``` r
list_spinners()
#>  [1] "dots"                "dots2"               "dots3"              
#>  [4] "dots4"               "dots5"               "dots6"              
#>  [7] "dots7"               "dots8"               "dots9"              
#> [10] "dots10"              "dots11"              "dots12"             
#> [13] "dots13"              "dots8Bit"            "sand"               
#> [16] "line"                "line2"               "pipe"               
#> [19] "simpleDots"          "simpleDotsScrolling" "star"               
#> [22] "star2"               "flip"                "hamburger"          
#> [25] "growVertical"        "growHorizontal"      "balloon"            
#> [28] "balloon2"            "noise"               "bounce"             
#> [31] "boxBounce"           "boxBounce2"          "triangle"           
#> [34] "arc"                 "circle"              "squareCorners"      
#> [37] "circleQuarters"      "circleHalves"        "squish"             
#> [40] "toggle"              "toggle2"             "toggle3"            
#> [43] "toggle4"             "toggle5"             "toggle6"            
#> [46] "toggle7"             "toggle8"             "toggle9"            
#> [49] "toggle10"            "toggle11"            "toggle12"           
#> [52] "toggle13"            "arrow"               "arrow2"             
#> [55] "arrow3"              "bouncingBar"         "bouncingBall"       
#> [58] "smiley"              "monkey"              "hearts"             
#> [61] "clock"               "earth"               "material"           
#> [64] "moon"                "runner"              "pong"               
#> [67] "shark"               "dqpb"                "weather"            
#> [70] "christmas"           "grenade"             "point"              
#> [73] "layer"               "betaWave"            "fingerDance"        
#> [76] "fistBump"            "soccerHeader"        "mindblown"          
#> [79] "speaker"             "orangePulse"         "bluePulse"          
#> [82] "orangeBluePulse"     "timeTravel"          "aesthetic"          
#> [85] "growVeriticalDotsLR" "growVeriticalDotsRL" "growVeriticalDotsLL"
#> [88] "growVeriticalDotsRR"
get_spinner(list_spinners()[1])
#> $name
#> [1] "dots"
#> 
#> $interval
#> [1] 80
#> 
#> $frames
#>  [1] "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
#> 
```
