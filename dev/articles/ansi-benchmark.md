# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55dad8bd4e70\>
\<environment: 0x55dad97009a0\>

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
#> 1 ansi         30.9µs   37.4µs    25795.    99.6KB     25.8
#> 2 plain        31.3µs   37.4µs    25928.        0B     28.6
#> 3 base         10.2µs   11.8µs    82558.    48.6KB     16.5
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
#> 1 ansi           33µs   39.3µs    24724.        0B     29.7
#> 2 plain        32.9µs   38.9µs    24871.        0B     29.9
#> 3 base         11.9µs   13.7µs    70632.        0B     28.3
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
#> 1 ansi         83.4µs   95.4µs    10108.   77.03KB     21.3
#> 2 plain        64.2µs   73.9µs    13189.    8.91KB     19.1
#> 3 base          1.8µs    1.9µs   484462.        0B      0
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
#> 1 ansi          241µs    274µs     3605.   33.24KB     26.1
#> 2 plain         242µs    273µs     3597.    1.09KB     27.3
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
#>  1 cli_ansi          4.62µs   5.28µs   162867.    9.27KB     16.3
#>  2 fansi_ansi        23.5µs  26.15µs    36880.    4.18KB     14.8
#>  3 cli_plain         4.61µs   5.22µs   180732.        0B     18.1
#>  4 fansi_plain      23.32µs  26.24µs    37076.      688B     14.8
#>  5 cli_vec_ansi      6.04µs   6.83µs   139934.      448B     14.0
#>  6 fansi_vec_ansi   33.42µs  37.49µs    25966.    5.02KB     13.0
#>  7 cli_vec_plain     6.67µs   7.41µs   127404.      448B     12.7
#>  8 fansi_vec_plain  31.89µs  35.13µs    27715.    5.02KB     11.1
#>  9 cli_txt_ansi      4.54µs   5.35µs   175936.        0B     17.6
#> 10 fansi_txt_ansi   23.21µs   26.5µs    36696.      688B     14.7
#> 11 cli_txt_plain     5.51µs   6.16µs   153583.        0B     15.4
#> 12 fansi_txt_plain  31.98µs  35.54µs    27353.    5.02KB     13.7
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
#> 1 cli            55µs     58µs    16914.    22.7KB     4.05
#> 2 fansi         106µs    113µs     8748.    55.3KB     6.12
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
#>  1 cli_ansi          5.51µs   6.18µs   152408.        0B    15.2 
#>  2 fansi_ansi       59.41µs  67.14µs    14430.   38.84KB    12.5 
#>  3 base_ansi       744.13ns 770.09ns  1123564.        0B     0   
#>  4 cli_plain         5.52µs   6.14µs   153652.        0B    15.4 
#>  5 fansi_plain         59µs  66.71µs    14611.      688B    12.4 
#>  6 base_plain      667.99ns 692.09ns  1223828.        0B     0   
#>  7 cli_vec_ansi     24.32µs  27.79µs    35562.      448B     3.56
#>  8 fansi_vec_ansi   80.37µs  89.54µs    10856.    5.02KB    10.4 
#>  9 base_vec_ansi    15.79µs  18.51µs    53121.      448B     0   
#> 10 cli_vec_plain    22.87µs  24.86µs    39529.      448B     3.95
#> 11 fansi_vec_plain   71.7µs  80.08µs    12208.    5.02KB    10.5 
#> 12 base_vec_plain    9.74µs  10.78µs    90337.      448B     0   
#> 13 cli_txt_ansi     24.18µs  28.22µs    35034.        0B     3.50
#> 14 fansi_txt_ansi   70.89µs  79.79µs    11814.      688B    10.3 
#> 15 base_txt_ansi    16.12µs  18.79µs    52610.        0B     0   
#> 16 cli_txt_plain    21.26µs  22.77µs    43002.        0B     4.30
#> 17 fansi_txt_plain  62.19µs  69.89µs    13974.      688B    12.5 
#> 18 base_txt_plain    9.43µs  10.43µs    94046.        0B     0
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
#>  1 cli_ansi           6.6µs   7.52µs   126330.        0B    25.3 
#>  2 fansi_ansi        59.2µs  67.09µs    14543.      688B    12.5 
#>  3 base_ansi         1.06µs   1.11µs   831257.        0B     0   
#>  4 cli_plain         6.57µs   7.43µs   127654.        0B    12.8 
#>  5 fansi_plain      57.48µs  67.04µs    14562.      688B    12.5 
#>  6 base_plain      809.09ns 879.98ns   976081.        0B     0   
#>  7 cli_vec_ansi     27.91µs  31.57µs    30872.      448B     3.09
#>  8 fansi_vec_ansi   80.01µs  91.69µs    10444.    5.02KB    10.4 
#>  9 base_vec_ansi    40.93µs  43.86µs    22581.      448B     0   
#> 10 cli_vec_plain    27.57µs  29.55µs    33273.      448B     3.33
#> 11 fansi_vec_plain  73.54µs  82.73µs    11801.    5.02KB    10.4 
#> 12 base_vec_plain   21.63µs  22.81µs    43379.      448B     0   
#> 13 cli_txt_ansi     28.71µs  31.73µs    30584.        0B     6.12
#> 14 fansi_txt_ansi   73.36µs  82.85µs    11201.      688B     8.20
#> 15 base_txt_ansi    45.18µs   47.3µs    20983.        0B     0   
#> 16 cli_txt_plain    26.99µs  28.85µs    34035.        0B     6.81
#> 17 fansi_txt_plain  64.03µs  71.88µs    13557.      688B    10.3 
#> 18 base_txt_plain   24.73µs  25.88µs    38264.        0B     3.83
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
#> 1 cli_ansi        5.39µs   6.05µs   154231.        0B    15.4 
#> 2 cli_plain        5.1µs   5.76µs   162654.        0B    16.3 
#> 3 cli_vec_ansi   31.09µs  33.24µs    29602.      848B     0   
#> 4 cli_vec_plain   9.03µs   9.88µs    96171.      848B     9.62
#> 5 cli_txt_ansi   30.81µs   32.9µs    29917.        0B     2.99
#> 6 cli_txt_plain   5.91µs   6.63µs   142845.        0B    14.3
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
#>  1 cli_ansi          20.7µs   23.2µs    41538.        0B    20.8 
#>  2 fansi_ansi        21.4µs   23.5µs    41200.    7.24KB    16.5 
#>  3 cli_plain         20.6µs   21.9µs    44047.        0B    17.6 
#>  4 fansi_plain       21.5µs   23.2µs    41688.      688B    16.7 
#>  5 cli_vec_ansi      30.7µs   32.4µs    30151.      848B    12.1 
#>  6 fansi_vec_ansi    49.8µs   52.9µs    18544.    5.41KB     8.39
#>  7 cli_vec_plain     23.6µs   26.9µs    36194.      848B    14.5 
#>  8 fansi_vec_plain     32µs   35.3µs    27691.    4.59KB    11.1 
#>  9 cli_txt_ansi      29.9µs   33.4µs    29245.        0B    11.7 
#> 10 fansi_txt_ansi    38.4µs   42.5µs    23054.    5.12KB     9.23
#> 11 cli_txt_plain     21.3µs   24.4µs    40034.        0B    20.0 
#> 12 fansi_txt_plain   22.8µs   25.7µs    37770.      688B    15.1
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
#>  1 cli_ansi        110.43µs 124.37µs     7854.  104.86KB    14.6 
#>  2 fansi_ansi       91.86µs 105.41µs     9334.  106.35KB    12.6 
#>  3 base_ansi         3.63µs   4.09µs   234639.      224B     0   
#>  4 cli_plain       108.48µs 124.01µs     7894.    8.09KB    14.8 
#>  5 fansi_plain      90.54µs 104.73µs     9285.    9.62KB    12.5 
#>  6 base_plain        3.18µs   3.52µs   268712.        0B    26.9 
#>  7 cli_vec_ansi      5.63ms   6.02ms      168.  823.77KB    15.9 
#>  8 fansi_vec_ansi  954.41µs      1ms      956.  846.81KB    17.7 
#>  9 base_vec_ansi   135.91µs 154.11µs     6400.    22.7KB     2.04
#> 10 cli_vec_plain      5.6ms   5.96ms      169.  823.77KB    16.6 
#> 11 fansi_vec_plain 887.56µs 945.02µs     1042.  845.98KB    20.5 
#> 12 base_vec_plain   94.91µs  105.7µs     9328.      848B     4.06
#> 13 cli_txt_ansi      2.79ms   2.94ms      339.    63.6KB     0   
#> 14 fansi_txt_ansi    1.39ms   1.43ms      690.   35.05KB     2.02
#> 15 base_txt_ansi   115.72µs  132.8µs     7523.   18.47KB     2.02
#> 16 cli_txt_plain     1.96ms   2.04ms      487.    63.6KB     0   
#> 17 fansi_txt_plain 437.57µs 462.39µs     2130.    30.6KB     4.08
#> 18 base_txt_plain   76.77µs  90.28µs    10992.   11.05KB     2.02
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
#>  1 cli_ansi         109.8µs  121.5µs     8044.   33.84KB    14.6 
#>  2 fansi_ansi        41.2µs   46.8µs    20622.   31.42KB    15.9 
#>  3 base_ansi          905ns  937.1ns  1001670.     4.2KB     0   
#>  4 cli_plain        103.7µs  110.3µs     8743.        0B    16.7 
#>  5 fansi_plain       40.4µs   43.5µs    22171.      872B    15.5 
#>  6 base_plain       838.9ns  875.9ns  1025583.        0B   103.  
#>  7 cli_vec_ansi     231.9µs  241.6µs     4097.   16.73KB     6.18
#>  8 fansi_vec_ansi    97.6µs  104.5µs     9407.    5.59KB     8.45
#>  9 base_vec_ansi     32.1µs     36µs    27540.      848B     0   
#> 10 cli_vec_plain      189µs    207µs     4590.   16.73KB     8.31
#> 11 fansi_vec_plain   91.5µs   97.7µs    10041.    5.59KB     8.29
#> 12 base_vec_plain    26.7µs   29.4µs    33576.      848B     0   
#> 13 cli_txt_ansi     114.9µs  130.3µs     7573.        0B    16.7 
#> 14 fansi_txt_ansi      41µs   46.5µs    20851.      872B    14.7 
#> 15 base_txt_ansi    909.1ns  946.1ns   974772.        0B     0   
#> 16 cli_txt_plain    106.3µs  121.2µs     8079.        0B    14.5 
#> 17 fansi_txt_plain   40.9µs   46.4µs    21030.      872B    14.7 
#> 18 base_txt_plain     832ns    893ns   971539.        0B     0
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
#>  1 cli_ansi         302.2µs 343.45µs    2893.     6.18KB    12.5 
#>  2 fansi_ansi        73.6µs  82.53µs   11811.    97.33KB    14.6 
#>  3 base_ansi        26.61µs  29.62µs   32341.         0B    16.2 
#>  4 cli_plain       188.59µs 210.92µs    4643.         0B    14.7 
#>  5 fansi_plain       72.5µs  82.28µs   11770.       872B    12.5 
#>  6 base_plain       21.54µs  24.07µs   39830.         0B    15.9 
#>  7 cli_vec_ansi     34.34ms  35.07ms      28.3   94.67KB    28.3 
#>  8 fansi_vec_ansi  205.89µs 221.24µs    4460.     7.25KB     6.15
#>  9 base_vec_ansi     1.92ms   2.05ms     484.    48.18KB    15.1 
#> 10 cli_vec_plain     20.4ms  21.47ms      46.8    2.48KB    20.5 
#> 11 fansi_vec_plain 166.06µs 178.35µs    5530.     6.42KB     7.68
#> 12 base_vec_plain    1.36ms   1.41ms     703.     47.4KB    14.9 
#> 13 cli_txt_ansi     27.54ms  27.85ms      35.9    4.27MB     4.49
#> 14 fansi_txt_ansi  194.78µs 205.62µs    4808.     6.77KB     6.13
#> 15 base_txt_ansi     1.12ms    1.2ms     819.   582.06KB    11.1 
#> 16 cli_txt_plain     1.11ms   1.19ms     822.   369.84KB     8.68
#> 17 fansi_txt_plain 153.19µs 163.68µs    6017.     2.51KB     8.29
#> 18 base_txt_plain  739.86µs 828.11µs    1185.   367.31KB    11.0
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
#>  1 cli_ansi          5.43µs   6.29µs   147968.   25.09KB    29.6 
#>  2 fansi_ansi       59.53µs  67.29µs    14405.   28.48KB    12.6 
#>  3 base_ansi       829.11ns 903.97ns   961329.        0B     0   
#>  4 cli_plain         5.27µs   6.19µs   153149.        0B    15.3 
#>  5 fansi_plain      59.71µs  67.07µs    14386.    1.98KB    14.8 
#>  6 base_plain      803.03ns 853.09ns  1015105.        0B     0   
#>  7 cli_vec_ansi     25.17µs   27.8µs    35377.     1.7KB     3.54
#>  8 fansi_vec_ansi   95.01µs 102.52µs     9493.    8.86KB    10.4 
#>  9 base_vec_ansi     6.66µs   7.01µs   140406.      848B     0   
#> 10 cli_vec_plain    20.77µs  22.81µs    42846.     1.7KB     4.29
#> 11 fansi_vec_plain  90.47µs  97.83µs     9969.    8.86KB     8.35
#> 12 base_vec_plain    6.07µs   6.61µs   146355.      848B    14.6 
#> 13 cli_txt_ansi      5.42µs   6.17µs   152908.        0B    15.3 
#> 14 fansi_txt_ansi   60.93µs  67.93µs    14250.    1.98KB    12.7 
#> 15 base_txt_ansi     4.65µs   6.77µs   143816.        0B     0   
#> 16 cli_txt_plain     6.27µs   7.16µs   130105.        0B    26.0 
#> 17 fansi_txt_plain   60.5µs  67.14µs    14440.    1.98KB    12.6 
#> 18 base_txt_plain    3.32µs   4.21µs   229260.        0B     0
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
#>  1 cli_ansi        77.73µs   88.5µs   11015.     12.1KB    10.3 
#>  2 base_ansi        1.16µs    1.2µs  803955.         0B     0   
#>  3 cli_plain       61.95µs  70.66µs   13773.     8.91KB    10.3 
#>  4 base_plain      863.1ns 885.11ns 1068478.         0B     0   
#>  5 cli_vec_ansi     3.73ms      4ms     252.   838.95KB    15.6 
#>  6 base_vec_ansi   69.58µs  71.84µs   13778.       848B     0   
#>  7 cli_vec_plain    2.16ms   2.31ms     437.   817.08KB    15.2 
#>  8 base_vec_plain  41.48µs  44.48µs   22176.       848B     0   
#>  9 cli_txt_ansi    14.98ms  15.45ms      64.7   114.6KB     4.32
#> 10 base_txt_ansi   69.42µs  73.47µs   13500.         0B     0   
#> 11 cli_txt_plain  254.15µs 269.85µs    3677.    18.34KB     2.01
#> 12 base_txt_plain  37.33µs  38.81µs   25549.         0B     0
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
#>  1 cli_ansi         74.7µs   84.6µs    11482.        0B    17.1 
#>  2 base_ansi        12.9µs   14.8µs    65573.        0B    13.1 
#>  3 cli_plain        73.4µs   84.5µs    11494.        0B    16.7 
#>  4 base_plain       13.1µs   14.6µs    66168.        0B    13.2 
#>  5 cli_vec_ansi    175.2µs  189.3µs     5179.     7.2KB     6.15
#>  6 base_vec_ansi    50.8µs   57.4µs    17260.    1.66KB     5.14
#>  7 cli_vec_plain   159.5µs    168µs     5857.     7.2KB     8.28
#>  8 base_vec_plain   45.6µs   51.1µs    19233.    1.66KB     2.02
#>  9 cli_txt_ansi    149.2µs  156.9µs     6235.        0B    10.3 
#> 10 base_txt_ansi      37µs   39.3µs    25080.        0B     5.02
#> 11 cli_txt_plain   133.7µs  138.7µs     7055.        0B     8.17
#> 12 base_txt_plain     31µs   33.1µs    29677.        0B     5.94
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
#> 1 cli          6.43µs   6.98µs   136302.        0B    13.6 
#> 2 base       705.01ns 728.06ns  1205964.        0B     0   
#> 3 cli_vec     23.02µs  25.98µs    37862.      448B     3.79
#> 4 base_vec    12.02µs  12.33µs    79354.      448B     0   
#> 5 cli_txt      23.6µs  25.84µs    37948.        0B     3.80
#> 6 base_txt    13.74µs  14.11µs    69747.        0B     6.98
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
#> 1 cli          6.36µs   7.17µs   131329.        0B    13.1 
#> 2 base         1.15µs   1.19µs   752006.        0B     0   
#> 3 cli_vec     23.23µs  27.21µs    36312.      448B     3.63
#> 4 base_vec    48.51µs  51.75µs    19129.      448B     0   
#> 5 cli_txt     24.42µs  26.28µs    37240.        0B     7.45
#> 6 base_txt    82.09µs  86.75µs    11439.        0B     0
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
#> 1 cli          6.76µs   7.75µs   123425.        0B    12.3 
#> 2 base       710.13ns 735.98ns  1130188.        0B     0   
#> 3 cli_vec     18.39µs  19.53µs    49946.      448B     9.99
#> 4 base_vec    12.02µs  12.39µs    79541.      448B     0   
#> 5 cli_txt     19.78µs  21.25µs    46022.        0B     4.60
#> 6 base_txt    13.72µs  14.14µs    69586.        0B     0
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
#> 1 cli          5.09µs   5.84µs   158287.    22.2KB    31.7 
#> 2 base       839.94ns 891.97ns   999041.        0B     0   
#> 3 cli_vec     30.82µs  33.25µs    29638.     1.7KB     2.96
#> 4 base_vec     7.96µs   8.26µs   118277.      848B     0   
#> 5 cli_txt       5.1µs   5.96µs   157740.        0B    15.8 
#> 6 base_txt     5.01µs   5.59µs   171645.        0B    17.2
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
#>  date     2026-09-24
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-09-24 [1] local
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
