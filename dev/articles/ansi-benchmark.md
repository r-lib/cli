# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55724c2f7830\>
\<environment: 0x55724ce23440\>

## Introduction

Often we can use the corresponding base R function as a baseline. We
also compare to the fansi package, where it is possible.

## Data

In cli the typical use case is short string scalars, but we run some
benchmarks longer strings and string vectors as well.

``` r

library(cli)
library(fansi)
options(cli.unicode = TRUE)
options(cli.num_colors = 256)
```

``` r

ansi <- format_inline(
  "{col_green(symbol$tick)} {.code print(x)} {.emph emphasised}"
)
```

``` r

plain <- ansi_strip(ansi)
```

``` r

vec_plain <- rep(plain, 100)
vec_ansi <- rep(ansi, 100)
vec_plain6 <- rep(plain, 6)
vec_ansi6 <- rep(plain, 6)
```

``` r

txt_plain <- paste(vec_plain, collapse = " ")
txt_ansi <- paste(vec_ansi, collapse = " ")
```

``` r

uni <- paste(
  "\U0001f477\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3fb",
  "\U0001f477\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3fb",
  "\U0001f477\U0001f3ff\u200d\u2640\ufe0f"
)
vec_uni <- rep(uni, 100)
txt_uni <- paste(vec_uni, collapse = " ")
```

## ANSI functions

### `ansi_align()`

``` r

bench::mark(
  ansi  = ansi_align(ansi, width = 20),
  plain = ansi_align(plain, width = 20), 
  base  = format(plain, width = 20),
  check = FALSE
)
```

``` fansi
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ansi         46.7µs   49.9µs    19362.    99.6KB     21.1
#> 2 plain        46.7µs   49.8µs    19389.        0B     22.0
#> 3 base         11.5µs   12.6µs    76931.    48.6KB     15.4
```

``` r

bench::mark(
  ansi  = ansi_align(ansi, width = 20, align = "right"),
  plain = ansi_align(plain, width = 20, align = "right"), 
  base  = format(plain, width = 20, justify = "right"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ansi         47.8µs   51.8µs    18566.        0B     21.4
#> 2 plain          48µs   51.7µs    18645.        0B     23.4
#> 3 base         13.4µs   14.6µs    65989.        0B     26.4
```

### `ansi_chartr()`

``` r

bench::mark(
  ansi  = ansi_chartr("abc", "XYZ", ansi),
  plain = ansi_chartr("abc", "XYZ", plain),
  base  = chartr("abc", "XYZ", plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ansi        118.3µs 125.77µs     7680.   77.03KB     14.6
#> 2 plain       94.08µs  99.81µs     9649.    8.91KB     14.6
#> 3 base         1.87µs   1.99µs   477471.        0B     47.8
```

### `ansi_columns()`

``` r

bench::mark(
  ansi  = ansi_columns(vec_ansi6, width = 120),
  plain = ansi_columns(vec_plain6, width = 120),
  check = FALSE
)
```

``` fansi
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ansi          350µs    374µs     2637.   33.24KB     19.1
#> 2 plain         352µs    374µs     2630.    1.09KB     19.2
```

### `ansi_has_any()`

``` r

bench::mark(
  cli_ansi        = ansi_has_any(ansi),
  fansi_ansi      = has_sgr(ansi),
  cli_plain       = ansi_has_any(plain),
  fansi_plain     = has_sgr(plain),
  cli_vec_ansi    = ansi_has_any(vec_ansi),
  fansi_vec_ansi  = has_sgr(vec_ansi),
  cli_vec_plain   = ansi_has_any(vec_plain),
  fansi_vec_plain = has_sgr(vec_plain),
  cli_txt_ansi    = ansi_has_any(txt_ansi),
  fansi_txt_ansi  = has_sgr(txt_ansi),
  cli_txt_plain   = ansi_has_any(txt_plain),
  fansi_txt_plain = has_sgr(vec_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 12 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi          5.93µs   6.53µs   147694.    9.27KB    29.5 
#>  2 fansi_ansi       31.57µs  34.56µs    27952.    4.18KB    22.4 
#>  3 cli_plain         5.79µs   6.43µs   149660.        0B    29.9 
#>  4 fansi_plain      30.83µs  33.13µs    28536.      688B    14.3 
#>  5 cli_vec_ansi      7.23µs   7.71µs   125584.      448B    12.6 
#>  6 fansi_vec_ansi    40.8µs  43.45µs    22024.    5.02KB    11.0 
#>  7 cli_vec_plain     7.87µs   8.34µs   116672.      448B    11.7 
#>  8 fansi_vec_plain  38.67µs  41.18µs    23402.    5.02KB     9.36
#>  9 cli_txt_ansi      5.79µs   6.19µs   155298.        0B    15.5 
#> 10 fansi_txt_ansi   30.87µs  32.94µs    29237.      688B    11.7 
#> 11 cli_txt_plain     6.65µs   7.08µs   137132.        0B    13.7 
#> 12 fansi_txt_plain  38.78µs  41.73µs    23213.    5.02KB     9.29
```

### `ansi_html()`

This is typically used with longer text.

``` r

bench::mark(
  cli   = ansi_html(txt_ansi),
  fansi = sgr_to_html(txt_ansi, classes = TRUE),
  check = FALSE
)
```

``` fansi
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli          56.7µs   58.2µs    16667.    22.7KB     4.04
#> 2 fansi       119.4µs  127.2µs     7780.    55.3KB     4.06
```

### `ansi_nchar()`

``` r

bench::mark(
  cli_ansi        = ansi_nchar(ansi),
  fansi_ansi      = nchar_sgr(ansi),
  base_ansi       = nchar(ansi),
  cli_plain       = ansi_nchar(plain),
  fansi_plain     = nchar_sgr(plain),
  base_plain      = nchar(plain),
  cli_vec_ansi    = ansi_nchar(vec_ansi),
  fansi_vec_ansi  = nchar_sgr(vec_ansi),
  base_vec_ansi   = nchar(vec_ansi),
  cli_vec_plain   = ansi_nchar(vec_plain),
  fansi_vec_plain = nchar_sgr(vec_plain),
  base_vec_plain  = nchar(vec_plain),
  cli_txt_ansi    = ansi_nchar(txt_ansi),
  fansi_txt_ansi  = nchar_sgr(txt_ansi),
  base_txt_ansi   = nchar(txt_ansi),
  cli_txt_plain   = ansi_nchar(txt_plain),
  fansi_txt_plain = nchar_sgr(txt_plain),
  base_txt_plain  = nchar(txt_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi          6.92µs   7.47µs   128652.        0B    12.9 
#>  2 fansi_ansi       92.82µs  97.74µs     9892.   38.84KB    10.3 
#>  3 base_ansi       901.05ns 951.11ns   991374.        0B     0   
#>  4 cli_plain         6.89µs   7.51µs   128978.        0B    12.9 
#>  5 fansi_plain       91.8µs  97.49µs     9914.      688B     8.21
#>  6 base_plain      821.08ns 862.05ns  1071325.        0B     0   
#>  7 cli_vec_ansi     29.41µs  30.29µs    32321.      448B     3.23
#>  8 fansi_vec_ansi  113.94µs 119.27µs     8094.    5.02KB     6.16
#>  9 base_vec_ansi    18.44µs  18.55µs    52864.      448B     5.29
#> 10 cli_vec_plain    28.13µs  28.94µs    33782.      448B     3.38
#> 11 fansi_vec_plain 104.67µs  110.5µs     8736.    5.02KB     6.17
#> 12 base_vec_plain   10.78µs  10.85µs    90001.      448B     0   
#> 13 cli_txt_ansi     29.43µs  30.11µs    32538.        0B     3.25
#> 14 fansi_txt_ansi  104.62µs 110.27µs     8764.      688B     8.21
#> 15 base_txt_ansi    18.21µs  18.27µs    53758.        0B     0   
#> 16 cli_txt_plain    27.76µs  28.43µs    34444.        0B     3.44
#> 17 fansi_txt_plain  94.33µs 100.05µs     9661.      688B     8.21
#> 18 base_txt_plain   10.58µs   10.7µs    91009.        0B     0
```

``` r

bench::mark(
  cli_ansi        = ansi_nchar(ansi, type = "width"),
  fansi_ansi      = nchar_sgr(ansi, type = "width"),
  base_ansi       = nchar(ansi, "width"),
  cli_plain       = ansi_nchar(plain, type = "width"),
  fansi_plain     = nchar_sgr(plain, type = "width"),
  base_plain      = nchar(plain, "width"),
  cli_vec_ansi    = ansi_nchar(vec_ansi, type = "width"),
  fansi_vec_ansi  = nchar_sgr(vec_ansi, type = "width"),
  base_vec_ansi   = nchar(vec_ansi, "width"),
  cli_vec_plain   = ansi_nchar(vec_plain, type = "width"),
  fansi_vec_plain = nchar_sgr(vec_plain, type = "width"),
  base_vec_plain  = nchar(vec_plain, "width"),
  cli_txt_ansi    = ansi_nchar(txt_ansi, type = "width"),
  fansi_txt_ansi  = nchar_sgr(txt_ansi, type = "width"),
  base_txt_ansi   = nchar(txt_ansi, "width"),
  cli_txt_plain   = ansi_nchar(txt_plain, type = "width"),
  fansi_txt_plain = nchar_sgr(txt_plain, type = "width"),
  base_txt_plain  = nchar(txt_plain, type = "width"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi          8.46µs   9.19µs   105282.        0B    10.5 
#>  2 fansi_ansi       92.47µs  97.93µs     9853.      688B     8.30
#>  3 base_ansi         1.23µs   1.28µs   731510.        0B     0   
#>  4 cli_plain         8.43µs   9.19µs   105010.        0B    10.5 
#>  5 fansi_plain      92.15µs  97.26µs     9919.      688B    10.3 
#>  6 base_plain        1.01µs   1.06µs   876982.        0B     0   
#>  7 cli_vec_ansi     34.74µs  35.63µs    27385.      448B     2.74
#>  8 fansi_vec_ansi  116.74µs 121.65µs     7894.    5.02KB     6.16
#>  9 base_vec_ansi    44.09µs  44.54µs    22060.      448B     0   
#> 10 cli_vec_plain    33.29µs  34.16µs    28101.      448B     5.62
#> 11 fansi_vec_plain 106.82µs 112.01µs     8597.    5.02KB     6.16
#> 12 base_vec_plain   23.03µs  23.29µs    42239.      448B     0   
#> 13 cli_txt_ansi     34.91µs  35.67µs    27175.        0B     5.44
#> 14 fansi_txt_ansi  107.28µs 113.34µs     8395.      688B     6.12
#> 15 base_txt_ansi    46.96µs  47.24µs    20878.        0B     0   
#> 16 cli_txt_plain     32.8µs  33.64µs    28992.        0B     5.80
#> 17 fansi_txt_plain  97.91µs 103.08µs     9324.      688B     8.20
#> 18 base_txt_plain   24.99µs  25.35µs    38949.        0B     0
```

### `ansi_simplify()`

Nothing to compare here.

``` r

bench::mark(
  cli_ansi      = ansi_simplify(ansi),
  cli_plain     = ansi_simplify(plain),
  cli_vec_ansi  = ansi_simplify(vec_ansi),
  cli_vec_plain = ansi_simplify(vec_plain),
  cli_txt_ansi  = ansi_simplify(txt_ansi),
  cli_txt_plain = ansi_simplify(txt_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 6 × 6
#>   expression         min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli_ansi         6.8µs   7.43µs   129184.        0B    12.9 
#> 2 cli_plain       6.41µs   6.98µs   138342.        0B    13.8 
#> 3 cli_vec_ansi   32.45µs  33.33µs    29378.      848B     2.94
#> 4 cli_vec_plain  10.41µs   11.1µs    87833.      848B     0   
#> 5 cli_txt_ansi   32.71µs  33.52µs    29160.        0B     2.92
#> 6 cli_txt_plain   7.27µs   7.85µs   123399.        0B    12.3
```

### `ansi_strip()`

``` r

bench::mark(
  cli_ansi        = ansi_strip(ansi),
  fansi_ansi      = strip_sgr(ansi),
  cli_plain       = ansi_strip(plain),
  fansi_plain     = strip_sgr(plain),
  cli_vec_ansi    = ansi_strip(vec_ansi),
  fansi_vec_ansi  = strip_sgr(vec_ansi),
  cli_vec_plain   = ansi_strip(vec_plain),
  fansi_vec_plain = strip_sgr(vec_plain),
  cli_txt_ansi    = ansi_strip(txt_ansi),
  fansi_txt_ansi  = strip_sgr(txt_ansi),
  cli_txt_plain   = ansi_strip(txt_plain),
  fansi_txt_plain = strip_sgr(txt_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 12 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi          26.4µs   27.8µs    34866.        0B    17.4 
#>  2 fansi_ansi        28.8µs   30.9µs    31256.    7.24KB    12.5 
#>  3 cli_plain         26.1µs   27.8µs    34649.        0B    13.9 
#>  4 fansi_plain       28.5µs   30.3µs    31876.      688B    12.8 
#>  5 cli_vec_ansi      35.4µs   37.1µs    26132.      848B    10.5 
#>  6 fansi_vec_ansi    55.9µs   58.8µs    16537.    5.41KB     8.31
#>  7 cli_vec_plain     28.6µs   30.4µs    31918.      848B    12.8 
#>  8 fansi_vec_plain   37.1µs   39.2µs    24608.    4.59KB     9.85
#>  9 cli_txt_ansi      34.3µs   35.8µs    26927.        0B    10.8 
#> 10 fansi_txt_ansi    44.4µs   45.9µs    21084.    5.12KB     8.44
#> 11 cli_txt_plain     26.6µs     28µs    34691.        0B    17.4 
#> 12 fansi_txt_plain   29.3µs   30.7µs    31595.      688B    12.6
```

### `ansi_strsplit()`

``` r

bench::mark(
  cli_ansi        = ansi_strsplit(ansi, "i"),
  fansi_ansi      = strsplit_sgr(ansi, "i"),
  base_ansi       = strsplit(ansi, "i"),
  cli_plain       = ansi_strsplit(plain, "i"),
  fansi_plain     = strsplit_sgr(plain, "i"),
  base_plain      = strsplit(plain, "i"),
  cli_vec_ansi    = ansi_strsplit(vec_ansi, "i"),
  fansi_vec_ansi  = strsplit_sgr(vec_ansi, "i"),
  base_vec_ansi   = strsplit(vec_ansi, "i"),
  cli_vec_plain   = ansi_strsplit(vec_plain, "i"),
  fansi_vec_plain = strsplit_sgr(vec_plain, "i"),
  base_vec_plain  = strsplit(vec_plain, "i"),
  cli_txt_ansi    = ansi_strsplit(txt_ansi, "i"),
  fansi_txt_ansi  = strsplit_sgr(txt_ansi, "i"),
  base_txt_ansi   = strsplit(txt_ansi, "i"),
  cli_txt_plain   = ansi_strsplit(txt_plain, "i"),
  fansi_txt_plain = strsplit_sgr(txt_plain, "i"),
  base_txt_plain  = strsplit(txt_plain, "i"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi        165.44µs 173.15µs     5606.  104.86KB    10.3 
#>  2 fansi_ansi      129.13µs 136.38µs     7081.  106.35KB    10.4 
#>  3 base_ansi         4.08µs   4.48µs   210595.      224B     0   
#>  4 cli_plain       163.06µs 169.76µs     5712.    8.09KB    10.3 
#>  5 fansi_plain     127.55µs 134.45µs     7216.    9.62KB    10.4 
#>  6 base_plain        3.61µs   3.91µs   248434.        0B     0   
#>  7 cli_vec_ansi      7.73ms   7.94ms      126.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.07ms    1.1ms      877.  846.81KB    17.4 
#>  9 base_vec_ansi   154.44µs 160.04µs     6102.    22.7KB     4.12
#> 10 cli_vec_plain     7.71ms    7.9ms      126.  823.77KB    11.3 
#> 11 fansi_vec_plain   1.01ms   1.05ms      947.  845.98KB    17.8 
#> 12 base_vec_plain  106.03µs 109.66µs     8970.      848B     4.06
#> 13 cli_txt_ansi      3.33ms   3.36ms      297.    63.6KB     0   
#> 14 fansi_txt_ansi    1.57ms   1.61ms      620.   35.05KB     0   
#> 15 base_txt_ansi   136.34µs 143.88µs     6908.   18.47KB     2.02
#> 16 cli_txt_plain      2.5ms   2.53ms      393.    63.6KB     2.02
#> 17 fansi_txt_plain 514.97µs 537.14µs     1852.    30.6KB     2.02
#> 18 base_txt_plain   87.32µs  106.1µs     9880.   11.05KB     2.02
```

### `ansi_strtrim()`

``` r

bench::mark(
  cli_ansi        = ansi_strtrim(ansi, 10),
  fansi_ansi      = strtrim_sgr(ansi, 10),
  base_ansi       = strtrim(ansi, 10),
  cli_plain       = ansi_strtrim(plain, 10),
  fansi_plain     = strtrim_sgr(plain, 10),
  base_plain      = strtrim(plain, 10),
  cli_vec_ansi    = ansi_strtrim(vec_ansi, 10),
  fansi_vec_ansi  = strtrim_sgr(vec_ansi, 10),
  base_vec_ansi   = strtrim(vec_ansi, 10),
  cli_vec_plain   = ansi_strtrim(vec_plain, 10),
  fansi_vec_plain = strtrim_sgr(vec_plain, 10),
  base_vec_plain  = strtrim(vec_plain, 10),
  cli_txt_ansi    = ansi_strtrim(txt_ansi, 10),
  fansi_txt_ansi  = strtrim_sgr(txt_ansi, 10),
  base_txt_ansi   = strtrim(txt_ansi, 10),
  cli_txt_plain   = ansi_strtrim(txt_plain, 10),
  fansi_txt_plain = strtrim_sgr(txt_plain, 10),
  base_txt_plain  = strtrim(txt_plain, 10),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi        151.33µs 158.03µs     6119.   33.84KB    12.4 
#>  2 fansi_ansi       54.92µs  59.22µs    16318.   31.42KB    10.3 
#>  3 base_ansi         1.05µs    1.1µs   846282.     4.2KB     0   
#>  4 cli_plain       146.82µs 154.04µs     6267.        0B    12.4 
#>  5 fansi_plain      54.99µs  58.78µs    16443.      872B    12.5 
#>  6 base_plain      981.03ns   1.02µs   908738.        0B     0   
#>  7 cli_vec_ansi    278.91µs 290.84µs     3361.   16.73KB     6.16
#>  8 fansi_vec_ansi  117.26µs 121.67µs     7991.    5.59KB     6.16
#>  9 base_vec_ansi    36.73µs  37.36µs    26319.      848B     2.63
#> 10 cli_vec_plain   235.75µs 245.39µs     3979.   16.73KB     6.17
#> 11 fansi_vec_plain 109.49µs 113.95µs     8515.    5.59KB     8.28
#> 12 base_vec_plain   30.36µs  31.26µs    31632.      848B     0   
#> 13 cli_txt_ansi    158.41µs 165.28µs     5868.        0B    10.3 
#> 14 fansi_txt_ansi   55.42µs  58.93µs    16434.      872B    12.5 
#> 15 base_txt_ansi     1.09µs   1.13µs   836648.        0B     0   
#> 16 cli_txt_plain   147.23µs 155.27µs     6270.        0B    12.0 
#> 17 fansi_txt_plain  53.95µs  56.53µs    17168.      872B    12.4 
#> 18 base_txt_plain       1µs   1.04µs   911636.        0B     0
```

### `ansi_strwrap()`

This function is most useful for longer text, but it is often called for
short text in cli, so it makes sense to benchmark that as well.

``` r

bench::mark(
  cli_ansi        = ansi_strwrap(ansi, 30),
  fansi_ansi      = strwrap_sgr(ansi, 30),
  base_ansi       = strwrap(ansi, 30),
  cli_plain       = ansi_strwrap(plain, 30),
  fansi_plain     = strwrap_sgr(plain, 30),
  base_plain      = strwrap(plain, 30),
  cli_vec_ansi    = ansi_strwrap(vec_ansi, 30),
  fansi_vec_ansi  = strwrap_sgr(vec_ansi, 30),
  base_vec_ansi   = strwrap(vec_ansi, 30),
  cli_vec_plain   = ansi_strwrap(vec_plain, 30),
  fansi_vec_plain = strwrap_sgr(vec_plain, 30),
  base_vec_plain  = strwrap(vec_plain, 30),
  cli_txt_ansi    = ansi_strwrap(txt_ansi, 30),
  fansi_txt_ansi  = strwrap_sgr(txt_ansi, 30),
  base_txt_ansi   = strwrap(txt_ansi, 30),
  cli_txt_plain   = ansi_strwrap(txt_plain, 30),
  fansi_txt_plain = strwrap_sgr(txt_plain, 30),
  base_txt_plain  = strwrap(txt_plain, 30),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi        431.28µs 459.06µs    2173.     6.18KB    12.5 
#>  2 fansi_ansi       97.91µs  103.7µs    9344.    97.33KB    10.5 
#>  3 base_ansi        39.49µs  41.67µs   23195.         0B     9.28
#>  4 cli_plain       286.14µs 299.92µs    3257.         0B    10.3 
#>  5 fansi_plain      97.39µs 103.54µs    9382.       872B    12.5 
#>  6 base_plain       32.04µs  33.95µs   28368.         0B     8.51
#>  7 cli_vec_ansi     48.59ms  48.93ms      20.4   94.67KB    20.4 
#>  8 fansi_vec_ansi  240.49µs 249.24µs    3924.     7.25KB     6.14
#>  9 base_vec_ansi     2.34ms   2.43ms     410.    48.18KB    12.8 
#> 10 cli_vec_plain    30.09ms  30.29ms      32.9    2.48KB    13.7 
#> 11 fansi_vec_plain 191.82µs 199.93µs    4893.     6.42KB     6.15
#> 12 base_vec_plain     1.7ms   1.76ms     562.     47.4KB    12.9 
#> 13 cli_txt_ansi     27.96ms  28.19ms      35.5    4.27MB     4.43
#> 14 fansi_txt_ansi  230.32µs 240.24µs    4086.     6.77KB     6.14
#> 15 base_txt_ansi     1.31ms   1.34ms     737.   582.06KB     8.78
#> 16 cli_txt_plain     1.32ms   1.37ms     724.   369.84KB     8.70
#> 17 fansi_txt_plain 183.04µs 190.42µs    5124.     2.51KB     6.17
#> 18 base_txt_plain  884.92µs 921.32µs    1063.   367.31KB    11.0
```

### `ansi_substr()`

``` r

bench::mark(
  cli_ansi        = ansi_substr(ansi, 2, 10),
  fansi_ansi      = substr_sgr(ansi, 2, 10),
  base_ansi       = substr(ansi, 2, 10),
  cli_plain       = ansi_substr(plain, 2, 10),
  fansi_plain     = substr_sgr(plain, 2, 10),
  base_plain      = substr(plain, 2, 10),
  cli_vec_ansi    = ansi_substr(vec_ansi, 2, 10),
  fansi_vec_ansi  = substr_sgr(vec_ansi, 2, 10),
  base_vec_ansi   = substr(vec_ansi, 2, 10),
  cli_vec_plain   = ansi_substr(vec_plain, 2, 10),
  fansi_vec_plain = substr_sgr(vec_plain, 2, 10),
  base_vec_plain  = substr(vec_plain, 2, 10),
  cli_txt_ansi    = ansi_substr(txt_ansi, 2, 10),
  fansi_txt_ansi  = substr_sgr(txt_ansi, 2, 10),
  base_txt_ansi   = substr(txt_ansi, 2, 10),
  cli_txt_plain   = ansi_substr(txt_plain, 2, 10),
  fansi_txt_plain = substr_sgr(txt_plain, 2, 10),
  base_txt_plain  = substr(txt_plain, 2, 10),
  check = FALSE
)
```

``` fansi
#> # A tibble: 18 × 6
#>    expression           min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi          6.85µs   7.51µs   127322.   25.09KB    12.7 
#>  2 fansi_ansi       79.54µs  84.62µs    11393.   28.48KB    10.4 
#>  3 base_ansi         1.03µs   1.12µs   810302.        0B    81.0 
#>  4 cli_plain         6.74µs   7.41µs   129964.        0B    13.0 
#>  5 fansi_plain         80µs  84.85µs    11386.    1.98KB    10.4 
#>  6 base_plain           1µs   1.06µs   879480.        0B     0   
#>  7 cli_vec_ansi     27.17µs  28.19µs    34400.     1.7KB     3.44
#>  8 fansi_vec_ansi  117.71µs 124.14µs     7786.    8.86KB     8.46
#>  9 base_vec_ansi     6.34µs   6.66µs   147204.      848B     0   
#> 10 cli_vec_plain    23.34µs  24.35µs    40112.     1.7KB     4.01
#> 11 fansi_vec_plain 112.19µs 117.69µs     8202.    8.86KB     8.35
#> 12 base_vec_plain    6.09µs    6.4µs   152400.      848B     0   
#> 13 cli_txt_ansi      6.77µs   7.42µs   128859.        0B    12.9 
#> 14 fansi_txt_ansi   79.84µs  84.62µs    11389.    1.98KB    12.5 
#> 15 base_txt_ansi     6.46µs   6.54µs   149099.        0B     0   
#> 16 cli_txt_plain     7.65µs   8.31µs   116304.        0B    11.6 
#> 17 fansi_txt_plain  80.22µs  84.93µs    11399.    1.98KB    10.4 
#> 18 base_txt_plain    4.11µs   4.18µs   232285.        0B     0
```

### `ansi_tolower()` , `ansi_toupper()`

``` r

bench::mark(
  cli_ansi        = ansi_tolower(ansi),
  base_ansi       = tolower(ansi),
  cli_plain       = ansi_tolower(plain),
  base_plain      = tolower(plain),
  cli_vec_ansi    = ansi_tolower(vec_ansi),
  base_vec_ansi   = tolower(vec_ansi),
  cli_vec_plain   = ansi_tolower(vec_plain),
  base_vec_plain  = tolower(vec_plain),
  cli_txt_ansi    = ansi_tolower(txt_ansi),
  base_txt_ansi   = tolower(txt_ansi),
  cli_txt_plain   = ansi_tolower(txt_plain),
  base_txt_plain  = tolower(txt_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 12 × 6
#>    expression          min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi       113.51µs 118.54µs    8138.     12.1KB     8.22
#>  2 base_ansi        1.33µs   1.37µs  705177.         0B     0   
#>  3 cli_plain       90.58µs  95.46µs    9565.     8.91KB     6.12
#>  4 base_plain          1µs   1.05µs  825913.         0B     0   
#>  5 cli_vec_ansi     4.34ms   4.45ms     216.   838.95KB    13.1 
#>  6 base_vec_ansi   75.62µs  76.44µs   12912.       848B     0   
#>  7 cli_vec_plain     2.4ms   2.46ms     406.   817.08KB    15.1 
#>  8 base_vec_plain  45.91µs  46.67µs   21182.       848B     0   
#>  9 cli_txt_ansi    15.11ms  15.27ms      65.4   114.6KB     2.04
#> 10 base_txt_ansi   75.19µs  76.53µs   12868.         0B     2.01
#> 11 cli_txt_plain  297.08µs 309.32µs    3153.    18.34KB     2.01
#> 12 base_txt_plain  42.47µs  43.44µs   22609.         0B     0
```

### `ansi_trimws()`

``` r

bench::mark(
  cli_ansi        = ansi_trimws(ansi),
  base_ansi       = trimws(ansi),
  cli_plain       = ansi_trimws(plain),
  base_plain      = trimws(plain),
  cli_vec_ansi    = ansi_trimws(vec_ansi),
  base_vec_ansi   = trimws(vec_ansi),
  cli_vec_plain   = ansi_trimws(vec_plain),
  base_vec_plain  = trimws(vec_plain),
  cli_txt_ansi    = ansi_trimws(txt_ansi),
  base_txt_ansi   = trimws(txt_ansi),
  cli_txt_plain   = ansi_trimws(txt_plain),
  base_txt_plain  = trimws(txt_plain),
  check = FALSE
)
```

``` fansi
#> # A tibble: 12 × 6
#>    expression          min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi        109.2µs  114.6µs     8433.        0B    12.4 
#>  2 base_ansi        16.7µs   17.8µs    52729.        0B    10.5 
#>  3 cli_plain       108.5µs  113.7µs     8499.        0B    10.3 
#>  4 base_plain       16.7µs   17.6µs    54816.        0B    11.0 
#>  5 cli_vec_ansi    210.6µs  218.7µs     4456.     7.2KB     6.12
#>  6 base_vec_ansi      59µs   65.6µs    15024.    1.66KB     4.06
#>  7 cli_vec_plain   196.5µs    206µs     4724.     7.2KB     6.14
#>  8 base_vec_plain   52.4µs   58.7µs    16749.    1.66KB     4.06
#>  9 cli_txt_ansi    183.5µs  190.4µs     5105.        0B     6.10
#> 10 base_txt_ansi    41.1µs   42.4µs    22976.        0B     4.60
#> 11 cli_txt_plain   168.1µs  173.8µs     5569.        0B     8.17
#> 12 base_txt_plain   35.3µs   36.6µs    26563.        0B     5.31
```

## UTF-8 functions

### `utf8_nchar()`

``` r

bench::mark(
  cli        = utf8_nchar(uni, type = "chars"),
  base       = nchar(uni, "chars"),
  cli_vec    = utf8_nchar(vec_uni, type = "chars"),
  base_vec   = nchar(vec_uni, "chars"),
  cli_txt    = utf8_nchar(txt_uni, type = "chars"),
  base_txt   = nchar(txt_uni, "chars"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 6 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli          8.18µs   8.82µs   108399.        0B    10.8 
#> 2 base       871.14ns 922.13ns   966394.        0B    96.6 
#> 3 cli_vec     23.67µs  24.56µs    39403.      448B     3.94
#> 4 base_vec    11.48µs  11.74µs    83769.      448B     0   
#> 5 cli_txt     23.89µs  24.62µs    39482.        0B     3.95
#> 6 base_txt    12.51µs  12.59µs    77825.        0B     0
```

``` r

bench::mark(
  cli        = utf8_nchar(uni, type = "width"),
  base       = nchar(uni, "width"),
  cli_vec    = utf8_nchar(vec_uni, type = "width"),
  base_vec   = nchar(vec_uni, "width"),
  cli_txt    = utf8_nchar(txt_uni, type = "width"),
  base_txt   = nchar(txt_uni, "width"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 6 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli          8.11µs    8.8µs   108456.        0B    21.7 
#> 2 base          1.3µs   1.35µs   703170.        0B     0   
#> 3 cli_vec     29.12µs  30.07µs    32506.      448B     3.25
#> 4 base_vec    50.43µs  50.91µs    19395.      448B     0   
#> 5 cli_txt     29.52µs  30.35µs    32152.        0B     3.22
#> 6 base_txt    86.73µs   87.3µs    11328.        0B     0
```

``` r

bench::mark(
  cli        = utf8_nchar(uni, type = "codepoints"),
  base       = nchar(uni, "chars"),
  cli_vec    = utf8_nchar(vec_uni, type = "codepoints"),
  base_vec   = nchar(vec_uni, "chars"),
  cli_txt    = utf8_nchar(txt_uni, type = "codepoints"),
  base_txt   = nchar(txt_uni, "chars"),
  check = FALSE
)
```

``` fansi
#> # A tibble: 6 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli          8.69µs   9.46µs   101759.        0B    20.4 
#> 2 base       871.02ns 922.13ns   999147.        0B     0   
#> 3 cli_vec     19.67µs  20.61µs    47345.      448B     4.73
#> 4 base_vec    11.51µs  11.74µs    83767.      448B     0   
#> 5 cli_txt     20.51µs  21.37µs    45634.        0B     9.13
#> 6 base_txt    12.53µs  12.61µs    77996.        0B     0
```

### `utf8_substr()`

``` r

bench::mark(
  cli        = utf8_substr(uni, 2, 10),
  base       = substr(uni, 2, 10),
  cli_vec    = utf8_substr(vec_uni, 2, 10),
  base_vec   = substr(vec_uni, 2, 10),
  cli_txt    = utf8_substr(txt_uni, 2, 10),
  base_txt   = substr(txt_uni, 2, 10),
  check = FALSE
)
```

``` fansi
#> # A tibble: 6 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cli          6.48µs   7.05µs   135877.    22.2KB    13.6 
#> 2 base         1.06µs   1.13µs   820138.        0B     0   
#> 3 cli_vec     29.39µs  30.35µs    32268.     1.7KB     6.45
#> 4 base_vec     8.14µs   8.41µs   116832.      848B     0   
#> 5 cli_txt      6.45µs   7.04µs   137103.        0B    13.7 
#> 6 base_txt     5.49µs   5.56µs   175205.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.1 (2026-06-24)
#>  os       Ubuntu 24.04.5 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-09-27
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-09-27 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.1)
#>  desc          1.4.3      2023-12-10 [1] RSPM
#>  digest        0.6.39     2025-11-19 [1] RSPM
#>  evaluate      1.0.5      2025-08-27 [1] RSPM
#>  fansi       * 1.0.7      2025-11-19 [1] RSPM
#>  fastmap       1.2.0      2024-05-15 [1] RSPM
#>  fs            2.1.0      2026-04-18 [1] RSPM
#>  glue          1.8.1      2026-04-17 [1] RSPM
#>  htmltools     0.5.9      2025-12-04 [1] RSPM
#>  htmlwidgets   1.6.4      2023-12-06 [1] RSPM
#>  jquerylib     0.1.4      2021-04-26 [1] RSPM
#>  jsonlite      2.0.0      2025-03-27 [1] RSPM
#>  knitr         1.52       2026-09-06 [1] RSPM
#>  lifecycle     1.0.5      2026-01-08 [1] RSPM
#>  magrittr      2.0.5      2026-04-04 [1] RSPM
#>  otel          0.2.0      2025-08-29 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.1      2026-07-07 [1] any (@2.2.1)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.3.0      2026-07-05 [1] RSPM
#>  rmarkdown     2.32       2026-09-01 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  sessioninfo   1.2.4      2026-06-04 [1] any (@1.2.4)
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.61       2026-09-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
