# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x557e2be806a0\>
\<environment: 0x557e2c924f78\>

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
#> 1 ansi         46.1µs   50.3µs    19283.    99.6KB     21.0
#> 2 plain        46.1µs   49.6µs    19476.        0B     19.5
#> 3 base         11.6µs   12.7µs    76370.    48.6KB     22.9
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
#> 1 ansi         47.5µs   51.8µs    18653.        0B     21.2
#> 2 plain        47.5µs   51.2µs    18865.        0B     23.2
#> 3 base         13.3µs   14.4µs    66974.        0B     20.1
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
#> 1 ansi       115.95µs 123.78µs     7799.   77.03KB     14.6
#> 2 plain       93.81µs  98.83µs     9755.    8.91KB     14.6
#> 3 base         1.86µs   1.97µs   484151.        0B      0
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
#> 1 ansi          345µs    368µs     2672.   33.23KB     19.0
#> 2 plain         339µs    365µs     2711.    1.09KB     19.0
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
#>  1 cli_ansi          5.86µs   6.38µs   150682.    9.27KB    30.1 
#>  2 fansi_ansi        31.7µs  34.39µs    28079.    4.18KB    25.3 
#>  3 cli_plain          5.8µs   6.33µs   152867.        0B    15.3 
#>  4 fansi_plain      31.06µs  33.23µs    28410.      688B    14.2 
#>  5 cli_vec_ansi      7.24µs   7.66µs   126687.      448B    12.7 
#>  6 fansi_vec_ansi   41.23µs  43.58µs    22008.    5.02KB    11.0 
#>  7 cli_vec_plain     7.88µs   8.31µs   117394.      448B    11.7 
#>  8 fansi_vec_plain  39.28µs  41.39µs    23385.    5.02KB     9.36
#>  9 cli_txt_ansi      5.76µs   6.15µs   158248.        0B    15.8 
#> 10 fansi_txt_ansi   31.46µs  33.44µs    29051.      688B    11.6 
#> 11 cli_txt_plain     6.58µs   6.97µs   139609.        0B    14.0 
#> 12 fansi_txt_plain  39.35µs  41.85µs    23192.    5.02KB    11.6
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
#> 1 cli            60µs   61.8µs    15796.    22.7KB     4.05
#> 2 fansi         119µs    126µs     7801.    55.3KB     4.05
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
#>  1 cli_ansi           7.1µs   7.79µs   124353.        0B    12.4 
#>  2 fansi_ansi        91.8µs  97.49µs     9915.   38.84KB     8.19
#>  3 base_ansi       911.07ns 971.02ns   959052.        0B     0   
#>  4 cli_plain         7.05µs   7.62µs   127213.        0B    12.7 
#>  5 fansi_plain       91.4µs  96.31µs    10050.      688B     8.18
#>  6 base_plain      831.09ns 891.97ns  1046774.        0B     0   
#>  7 cli_vec_ansi     28.35µs  29.16µs    33538.      448B     3.35
#>  8 fansi_vec_ansi     113µs 118.35µs     8167.    5.02KB     8.25
#>  9 base_vec_ansi    17.22µs   17.3µs    56903.      448B     0   
#> 10 cli_vec_plain    27.01µs  27.81µs    35158.      448B     3.52
#> 11 fansi_vec_plain 103.17µs 108.58µs     8876.    5.02KB     8.25
#> 12 base_vec_plain   10.16µs  10.25µs    95761.      448B     0   
#> 13 cli_txt_ansi     28.22µs  28.95µs    33632.        0B     3.36
#> 14 fansi_txt_ansi  104.47µs 109.58µs     8800.      688B     8.19
#> 15 base_txt_ansi     16.9µs  16.96µs    58051.        0B     0   
#> 16 cli_txt_plain    26.47µs  27.24µs    35973.        0B     3.60
#> 17 fansi_txt_plain  94.21µs  99.48µs     9715.      688B     8.19
#> 18 base_txt_plain    9.85µs   9.92µs    98390.        0B     0
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
#>  1 cli_ansi          8.67µs   9.44µs   102269.        0B    20.5 
#>  2 fansi_ansi       92.48µs  97.62µs     9872.      688B     8.30
#>  3 base_ansi         1.22µs   1.28µs   730336.        0B     0   
#>  4 cli_plain         8.72µs   9.43µs   102669.        0B    10.3 
#>  5 fansi_plain      92.63µs  97.65µs     9876.      688B     8.19
#>  6 base_plain        1.01µs   1.08µs   872565.        0B    87.3 
#>  7 cli_vec_ansi     34.62µs  35.53µs    27511.      448B     2.75
#>  8 fansi_vec_ansi  115.94µs 121.12µs     7991.    5.02KB     6.14
#>  9 base_vec_ansi    40.86µs  41.28µs    23878.      448B     0   
#> 10 cli_vec_plain    33.62µs  34.53µs    28319.      448B     5.66
#> 11 fansi_vec_plain 105.92µs 110.97µs     8714.    5.02KB     6.14
#> 12 base_vec_plain   21.61µs  21.88µs    44935.      448B     4.49
#> 13 cli_txt_ansi     35.06µs  35.88µs    27278.        0B     2.73
#> 14 fansi_txt_ansi  107.62µs 112.45µs     8618.      688B     8.17
#> 15 base_txt_ansi    43.16µs  44.07µs    22438.        0B     0   
#> 16 cli_txt_plain    33.22µs  34.05µs    28736.        0B     2.87
#> 17 fansi_txt_plain  97.21µs 102.34µs     9449.      688B     8.20
#> 18 base_txt_plain   23.59µs  23.85µs    41283.        0B     0
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
#> 1 cli_ansi        6.97µs   7.58µs   127707.        0B    12.8 
#> 2 cli_plain        6.6µs   7.17µs   134463.        0B    13.4 
#> 3 cli_vec_ansi   33.27µs  34.27µs    28559.      848B     2.86
#> 4 cli_vec_plain  10.58µs   11.3µs    85864.      848B     8.59
#> 5 cli_txt_ansi   32.63µs   33.7µs    29023.        0B     2.90
#> 6 cli_txt_plain   7.49µs   8.14µs   118485.        0B    11.8
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
#>  1 cli_ansi          25.9µs   27.7µs    34425.        0B    13.8 
#>  2 fansi_ansi        29.5µs   31.8µs    30383.    7.24KB    12.2 
#>  3 cli_plain         25.7µs   27.5µs    35196.        0B    17.6 
#>  4 fansi_plain       28.4µs     31µs    31200.      688B    12.5 
#>  5 cli_vec_ansi      35.5µs   37.2µs    26149.      848B    10.5 
#>  6 fansi_vec_ansi    56.1µs   58.6µs    16567.    5.41KB     6.16
#>  7 cli_vec_plain     28.5µs     30µs    32252.      848B    16.1 
#>  8 fansi_vec_plain   37.7µs   39.5µs    24423.    4.59KB     9.77
#>  9 cli_txt_ansi      34.3µs   35.6µs    27250.        0B    10.9 
#> 10 fansi_txt_ansi    44.9µs   46.4µs    20780.    5.12KB     8.32
#> 11 cli_txt_plain     26.3µs   27.5µs    35241.        0B    17.6 
#> 12 fansi_txt_plain   29.5µs   31.3µs    30854.      688B    12.3
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
#>    expression            min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>       <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 cli_ansi         163.71µs 171.27µs     5656.  104.86KB    10.3 
#>  2 fansi_ansi          131µs  137.9µs     7015.  106.35KB    10.3 
#>  3 base_ansi          4.12µs   4.44µs   219206.      224B     0   
#>  4 cli_plain        161.18µs 168.97µs     5742.    8.09KB    10.3 
#>  5 fansi_plain      128.82µs 135.67µs     7168.    9.62KB    10.4 
#>  6 base_plain         3.59µs   3.82µs   253552.        0B     0   
#>  7 cli_vec_ansi       7.63ms   7.78ms      128.  823.77KB    13.7 
#>  8 fansi_vec_ansi     1.06ms   1.09ms      902.  846.81KB    17.2 
#>  9 base_vec_ansi    156.01µs 162.67µs     6055.    22.7KB     2.04
#> 10 cli_vec_plain       7.6ms   7.75ms      129.  823.77KB    11.3 
#> 11 fansi_vec_plain  999.76µs   1.03ms      968.  845.98KB    19.5 
#> 12 base_vec_plain   107.04µs 113.56µs     8571.      848B     4.05
#> 13 cli_txt_ansi       3.18ms   3.21ms      311.    63.6KB     0   
#> 14 fansi_txt_ansi     1.57ms   1.59ms      627.   35.05KB     0   
#> 15 base_txt_ansi    137.46µs 145.97µs     6793.   18.47KB     2.02
#> 16 cli_txt_plain      2.35ms   2.38ms      419.    63.6KB     2.01
#> 17 fansi_txt_plain  515.89µs 535.35µs     1861.    30.6KB     2.02
#> 18 base_txt_plain    88.27µs  90.77µs    10829.   11.05KB     2.02
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
#>  1 cli_ansi        148.89µs 155.31µs     6259.   33.84KB    12.4 
#>  2 fansi_ansi       55.17µs  58.55µs    16520.   31.42KB    12.4 
#>  3 base_ansi         1.06µs   1.11µs   866330.     4.2KB     0   
#>  4 cli_plain       147.31µs 153.22µs     6332.        0B    12.4 
#>  5 fansi_plain      55.23µs   58.5µs    16565.      872B    12.4 
#>  6 base_plain      991.04ns   1.03µs   893382.        0B     0   
#>  7 cli_vec_ansi    273.48µs 285.08µs     3440.   16.73KB     6.27
#>  8 fansi_vec_ansi  116.72µs 121.08µs     7996.    5.59KB     6.15
#>  9 base_vec_ansi     35.5µs  35.86µs    27480.      848B     0   
#> 10 cli_vec_plain   229.79µs 240.41µs     4057.   16.73KB     8.27
#> 11 fansi_vec_plain 109.68µs 113.68µs     8551.    5.59KB     8.27
#> 12 base_vec_plain   29.95µs  31.12µs    31841.      848B     0   
#> 13 cli_txt_ansi    156.36µs 163.68µs     5911.        0B    10.3 
#> 14 fansi_txt_ansi   54.99µs  58.37µs    16565.      872B    11.9 
#> 15 base_txt_ansi     1.09µs   1.15µs   823192.        0B     0   
#> 16 cli_txt_plain   146.84µs 151.89µs     6383.        0B    14.5 
#> 17 fansi_txt_plain     54µs  56.26µs    17069.      872B    10.3 
#> 18 base_txt_plain    1.01µs   1.05µs   914582.        0B    91.5
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
#>  1 cli_ansi        415.81µs 443.25µs    2243.     6.18KB    10.5 
#>  2 fansi_ansi       100.5µs 106.13µs    9104.    97.33KB    10.3 
#>  3 base_ansi        38.86µs  41.03µs   23389.         0B    11.7 
#>  4 cli_plain       274.15µs 286.58µs    3395.         0B    10.3 
#>  5 fansi_plain      99.19µs 105.57µs    9135.       872B    10.3 
#>  6 base_plain       31.72µs  33.51µs   28700.         0B    11.5 
#>  7 cli_vec_ansi     44.65ms  44.94ms      22.3   94.67KB    18.5 
#>  8 fansi_vec_ansi  240.22µs 248.86µs    3937.     7.25KB     6.13
#>  9 base_vec_ansi     2.31ms   2.36ms     422.    48.18KB    12.8 
#> 10 cli_vec_plain    29.03ms  29.28ms      33.9    2.48KB    14.1 
#> 11 fansi_vec_plain 192.65µs 200.76µs    4863.     6.42KB     8.22
#> 12 base_vec_plain    1.67ms   1.73ms     575.     47.4KB    12.8 
#> 13 cli_txt_ansi     26.77ms  26.97ms      36.9    4.27MB     4.35
#> 14 fansi_txt_ansi  227.32µs 236.33µs    4150.     6.77KB     6.13
#> 15 base_txt_ansi     1.26ms   1.29ms     767.   582.06KB    11.1 
#> 16 cli_txt_plain     1.28ms   1.33ms     749.   369.84KB     9.00
#> 17 fansi_txt_plain 178.54µs 186.05µs    5263.     2.51KB     6.10
#> 18 base_txt_plain   842.4µs 875.56µs    1135.   367.31KB    10.9
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
#>  1 cli_ansi          6.68µs   7.17µs   130243.   25.09KB    13.0 
#>  2 fansi_ansi       79.97µs  84.09µs    11540.   28.48KB    10.3 
#>  3 base_ansi         1.04µs    1.1µs   855644.        0B    85.6 
#>  4 cli_plain         6.68µs   7.18µs   135325.        0B    13.5 
#>  5 fansi_plain      79.51µs  84.32µs    11532.    1.98KB    10.4 
#>  6 base_plain           1µs   1.06µs   887576.        0B     0   
#>  7 cli_vec_ansi     26.34µs   27.2µs    36013.     1.7KB     3.60
#>  8 fansi_vec_ansi  118.43µs 123.01µs     7911.    8.86KB     8.31
#>  9 base_vec_ansi      6.1µs   6.37µs   153521.      848B     0   
#> 10 cli_vec_plain    22.76µs  23.59µs    41446.     1.7KB     4.14
#> 11 fansi_vec_plain 112.67µs 117.31µs     8294.    8.86KB     8.31
#> 12 base_vec_plain    5.65µs   5.94µs   164460.      848B     0   
#> 13 cli_txt_ansi      6.69µs   7.24µs   133301.        0B    26.7 
#> 14 fansi_txt_ansi   80.61µs  84.75µs    11426.    1.98KB    10.3 
#> 15 base_txt_ansi     6.47µs   6.54µs   149657.        0B     0   
#> 16 cli_txt_plain     7.52µs   8.11µs   119568.        0B    12.0 
#> 17 fansi_txt_plain  80.18µs  84.66µs    11428.    1.98KB    12.5 
#> 18 base_txt_plain     4.1µs   4.17µs   232162.        0B     0
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
#>  1 cli_ansi       111.86µs  117.2µs    8236.     12.1KB     8.20
#>  2 base_ansi        1.32µs   1.37µs  706044.         0B     0   
#>  3 cli_plain       90.26µs  94.28µs   10202.     8.91KB     8.20
#>  4 base_plain       1.02µs   1.07µs  885850.         0B     0   
#>  5 cli_vec_ansi     4.31ms   4.39ms     227.   838.95KB    15.6 
#>  6 base_vec_ansi   71.88µs  72.19µs   13670.       848B     0   
#>  7 cli_vec_plain    2.38ms   2.46ms     403.   817.08KB    13.0 
#>  8 base_vec_plain  42.57µs  43.11µs   22888.       848B     0   
#>  9 cli_txt_ansi    14.44ms  14.54ms      68.7   114.6KB     4.29
#> 10 base_txt_ansi   73.62µs  73.83µs   13354.         0B     0   
#> 11 cli_txt_plain  307.01µs 316.87µs    3080.    18.34KB     2.01
#> 12 base_txt_plain     41µs   41.9µs   23674.         0B     0
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
#>  1 cli_ansi        108.8µs  114.3µs     8395.        0B    12.4 
#>  2 base_ansi        16.7µs   17.8µs    54293.        0B    10.9 
#>  3 cli_plain       108.1µs  113.4µs     8525.        0B    12.4 
#>  4 base_plain       16.8µs   17.7µs    54592.        0B    10.9 
#>  5 cli_vec_ansi    207.7µs  217.9µs     4473.     7.2KB     6.12
#>  6 base_vec_ansi      60µs   65.2µs    14898.    1.66KB     4.06
#>  7 cli_vec_plain   189.1µs  202.3µs     4817.     7.2KB     6.13
#>  8 base_vec_plain   52.8µs     58µs    16754.    1.66KB     4.05
#>  9 cli_txt_ansi    182.1µs  188.5µs     5155.        0B     6.10
#> 10 base_txt_ansi    41.5µs   42.6µs    22755.        0B     4.55
#> 11 cli_txt_plain   165.7µs  172.5µs     5642.        0B     8.26
#> 12 base_txt_plain   35.9µs   37.3µs    26193.        0B     5.24
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
#> 1 cli          8.41µs   9.06µs   106005.        0B    21.2 
#> 2 base       881.03ns 922.13ns  1015089.        0B     0   
#> 3 cli_vec     23.43µs   24.2µs    40395.      448B     4.04
#> 4 base_vec    11.63µs   11.9µs    82636.      448B     0   
#> 5 cli_txt     23.48µs  24.26µs    39851.        0B     3.99
#> 6 base_txt    12.63µs  12.73µs    77328.        0B     0
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
#> 1 cli          8.48µs    9.1µs   106104.        0B    10.6 
#> 2 base          1.3µs   1.37µs   696096.        0B     0   
#> 3 cli_vec     29.16µs  30.07µs    32552.      448B     3.26
#> 4 base_vec    50.08µs  50.99µs    19423.      448B     0   
#> 5 cli_txt     29.59µs  30.38µs    32160.        0B     6.43
#> 6 base_txt    86.99µs  87.73µs    11269.        0B     0
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
#> 1 cli          8.92µs   9.62µs   100272.        0B    10.0 
#> 2 base       881.03ns 931.09ns   991152.        0B     0   
#> 3 cli_vec     19.97µs  20.84µs    46816.      448B     9.37
#> 4 base_vec    11.64µs  11.89µs    82734.      448B     0   
#> 5 cli_txt     20.56µs  21.37µs    45663.        0B     4.57
#> 6 base_txt    12.63µs  12.73µs    77314.        0B     0
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
#> 1 cli          6.42µs   7.05µs   136453.    22.2KB    27.3 
#> 2 base         1.05µs   1.13µs   838434.        0B     0   
#> 3 cli_vec     30.61µs  31.61µs    31001.     1.7KB     3.10
#> 4 base_vec     8.34µs   8.64µs   113743.      848B     0   
#> 5 cli_txt      6.31µs   6.98µs   138843.        0B    27.8 
#> 6 base_txt     5.71µs   5.78µs   162600.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.0 (2026-04-24)
#>  os       Ubuntu 24.04.4 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-06-05
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-06-05 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.0)
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
#>  knitr         1.51       2025-12-20 [1] RSPM
#>  lifecycle     1.0.5      2026-01-08 [1] RSPM
#>  magrittr      2.0.5      2026-04-04 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.0      2025-11-06 [1] any (@2.2.0)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.2.0      2026-04-06 [1] RSPM
#>  rmarkdown     2.31       2026-03-26 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  sessioninfo   1.2.3      2025-02-05 [1] any (@1.2.3)
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.58       2026-06-01 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.0/lib/R/site-library
#>  [3] /opt/R/4.6.0/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
