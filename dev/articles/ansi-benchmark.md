# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55d0986df458\>
\<environment: 0x55d099177c88\>

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
#> 1 ansi        21.35µs  24.36µs    40182.    99.6KB     40.2
#> 2 plain       21.92µs  24.62µs    39494.        0B     43.5
#> 3 base         6.24µs   7.29µs   131909.    48.6KB     39.6
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
#> 1 ansi         22.8µs  26.05µs    36355.        0B     43.7
#> 2 plain       21.93µs  25.65µs    37770.        0B     45.4
#> 3 base         6.94µs   8.42µs   114701.        0B     45.9
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
#> 1 ansi         53.5µs  60.07µs    16201.   77.03KB     32.6
#> 2 plain       41.78µs  46.85µs    20735.    8.91KB     30.3
#> 3 base         1.22µs   1.31µs   684362.        0B     68.4
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
#> 1 ansi          154µs    171µs     5718.   33.24KB     36.7
#> 2 plain         151µs    163µs     6070.    1.09KB     23.2
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
#>  1 cli_ansi          3.25µs   3.74µs   244370.    9.27KB     24.4
#>  2 fansi_ansi        15.4µs  17.86µs    45813.    4.18KB     18.3
#>  3 cli_plain         3.19µs   3.63µs   267846.        0B     26.8
#>  4 fansi_plain      15.46µs  17.41µs    55688.      688B     27.9
#>  5 cli_vec_ansi      3.99µs   4.65µs   208669.      448B     20.9
#>  6 fansi_vec_ansi   20.67µs   23.3µs    41919.    5.02KB     16.8
#>  7 cli_vec_plain     4.17µs    4.7µs   207943.      448B     20.8
#>  8 fansi_vec_plain  19.96µs  22.42µs    43609.    5.02KB     17.5
#>  9 cli_txt_ansi      3.17µs   3.67µs   266419.        0B     26.6
#> 10 fansi_txt_ansi    15.9µs  18.05µs    54088.      688B     21.6
#> 11 cli_txt_plain     3.92µs    4.4µs   222394.        0B     22.2
#> 12 fansi_txt_plain  19.95µs  22.56µs    43238.    5.02KB     21.6
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
#> 1 cli          31.5µs   33.5µs    29402.    22.7KB     8.82
#> 2 fansi        60.2µs   65.3µs    15075.    55.3KB     8.19
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
#>  1 cli_ansi           3.6µs   4.25µs   226646.        0B    22.7 
#>  2 fansi_ansi       38.58µs  43.66µs    22479.   38.84KB    20.2 
#>  3 base_ansi       551.11ns 631.09ns  1441585.        0B     0   
#>  4 cli_plain          3.7µs   4.36µs   222316.        0B    22.2 
#>  5 fansi_plain      38.67µs  42.44µs    23012.      688B    20.7 
#>  6 base_plain      490.11ns 531.09ns  1726186.        0B     0   
#>  7 cli_vec_ansi     14.23µs  15.49µs    63007.      448B     6.30
#>  8 fansi_vec_ansi   49.98µs   55.2µs    17794.    5.02KB    14.7 
#>  9 base_vec_ansi     9.04µs  11.63µs    86612.      448B     0   
#> 10 cli_vec_plain    14.35µs   15.7µs    62469.      448B     6.25
#> 11 fansi_vec_plain  44.69µs  48.84µs    20034.    5.02KB    16.9 
#> 12 base_vec_plain    5.06µs   5.96µs   165515.      448B    16.6 
#> 13 cli_txt_ansi     14.91µs  15.87µs    61625.        0B     6.16
#> 14 fansi_txt_ansi   45.64µs  49.32µs    19807.      688B    16.7 
#> 15 base_txt_ansi     8.66µs  10.49µs    94528.        0B     0   
#> 16 cli_txt_plain    13.89µs  14.62µs    67196.        0B     6.72
#> 17 fansi_txt_plain  39.92µs  43.33µs    22609.      688B    18.1 
#> 18 base_txt_plain     4.9µs   5.89µs   167290.        0B    16.7
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
#>  1 cli_ansi          4.37µs   5.18µs   187783.        0B    18.8 
#>  2 fansi_ansi        38.7µs  42.59µs    22956.      688B    20.7 
#>  3 base_ansi       731.09ns 831.09ns  1109622.        0B     0   
#>  4 cli_plain         4.32µs    5.1µs   191211.        0B    19.1 
#>  5 fansi_plain      38.48µs  41.51µs    23546.      688B    20.4 
#>  6 base_plain      610.95ns 691.04ns  1339685.        0B     0   
#>  7 cli_vec_ansi     17.63µs  19.23µs    51596.      448B    10.3 
#>  8 fansi_vec_ansi   50.96µs  55.16µs    17751.    5.02KB    14.7 
#>  9 base_vec_ansi    25.92µs  28.85µs    34480.      448B     0   
#> 10 cli_vec_plain    17.73µs  18.94µs    52200.      448B     5.22
#> 11 fansi_vec_plain  45.45µs  48.97µs    19963.    5.02KB    17.0 
#> 12 base_vec_plain   14.32µs  14.99µs    65860.      448B     6.59
#> 13 cli_txt_ansi     17.83µs  19.35µs    51043.        0B     5.10
#> 14 fansi_txt_ansi   47.02µs  50.78µs    19290.      688B    16.7 
#> 15 base_txt_ansi    28.45µs  31.12µs    31712.        0B     0   
#> 16 cli_txt_plain    18.13µs  19.13µs    51532.        0B     5.15
#> 17 fansi_txt_plain  41.88µs   45.5µs    21553.      688B    19.4 
#> 18 base_txt_plain   15.77µs  16.16µs    61165.        0B     0
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
#> 1 cli_ansi        3.55µs   4.19µs   231889.        0B    23.2 
#> 2 cli_plain        3.5µs   4.07µs   238711.        0B    23.9 
#> 3 cli_vec_ansi    17.6µs  18.72µs    52691.      848B     5.27
#> 4 cli_vec_plain   5.61µs   6.31µs   155126.      848B    15.5 
#> 5 cli_txt_ansi      17µs  17.86µs    55320.        0B     5.53
#> 6 cli_txt_plain   4.13µs   4.68µs   208480.        0B     0
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
#>  1 cli_ansi          14.3µs   15.9µs    61431.        0B     24.6
#>  2 fansi_ansi        14.6µs   16.6µs    58883.    7.24KB     23.6
#>  3 cli_plain         14.3µs   16.1µs    60492.        0B     24.2
#>  4 fansi_plain       14.8µs   16.6µs    58512.      688B     23.4
#>  5 cli_vec_ansi      19.9µs     22µs    44332.      848B     22.2
#>  6 fansi_vec_ansi    29.4µs   31.9µs    30656.    5.41KB     12.3
#>  7 cli_vec_plain     15.7µs   17.5µs    55674.      848B     22.3
#>  8 fansi_vec_plain   20.4µs   22.5µs    43384.    4.59KB     17.4
#>  9 cli_txt_ansi      18.8µs   20.6µs    47497.        0B     19.0
#> 10 fansi_txt_ansi    23.2µs   25.4µs    38518.    5.12KB     15.4
#> 11 cli_txt_plain     14.3µs     16µs    60763.        0B     30.4
#> 12 fansi_txt_plain   14.6µs   16.5µs    58804.      688B     23.5
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
#>  1 cli_ansi         69.66µs  76.08µs    12822.  104.86KB    23.5 
#>  2 fansi_ansi       60.57µs  67.82µs    14399.  106.35KB    19.1 
#>  3 base_ansi         2.39µs   2.66µs   362037.      224B    36.2 
#>  4 cli_plain        71.05µs  76.52µs    12720.    8.09KB    23.1 
#>  5 fansi_plain      62.21µs  66.17µs    14512.    9.62KB    19.1 
#>  6 base_plain        2.08µs   2.28µs   418725.        0B    41.9 
#>  7 cli_vec_ansi      3.88ms   4.02ms      247.  823.77KB    23.1 
#>  8 fansi_vec_ansi  612.85µs 652.75µs     1503.  846.81KB    27.5 
#>  9 base_vec_ansi    85.35µs   91.8µs    10693.    22.7KB     4.16
#> 10 cli_vec_plain     3.92ms   4.08ms      243.  823.77KB    23.8 
#> 11 fansi_vec_plain 573.93µs 636.77µs     1517.  845.98KB    27.5 
#> 12 base_vec_plain   57.16µs  61.55µs    15995.      848B     6.10
#> 13 cli_txt_ansi      1.76ms   1.81ms      547.    63.6KB     0   
#> 14 fansi_txt_ansi  929.39µs 947.02µs     1041.   35.05KB     2.02
#> 15 base_txt_ansi    72.12µs  80.25µs    12411.   18.47KB     4.07
#> 16 cli_txt_plain     1.27ms   1.34ms      736.    63.6KB     2.05
#> 17 fansi_txt_plain 279.28µs 300.59µs     2786.    30.6KB     2.06
#> 18 base_txt_plain   45.71µs  48.77µs    20255.   11.05KB     4.07
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
#>  1 cli_ansi          71.4µs   78.9µs    12244.   33.84KB     23.2
#>  2 fansi_ansi        26.9µs   30.8µs    31239.   31.42KB     21.9
#>  3 base_ansi        621.1ns  671.1ns  1380816.     4.2KB      0  
#>  4 cli_plain         71.6µs   80.4µs    11967.        0B     25.4
#>  5 fansi_plain       27.3µs   30.4µs    31461.      872B     22.0
#>  6 base_plain         541ns    591ns  1568356.        0B      0  
#>  7 cli_vec_ansi     139.9µs  149.9µs     6530.   16.73KB     12.7
#>  8 fansi_vec_ansi      65µs   69.4µs    12880.    5.59KB     10.4
#>  9 base_vec_ansi     20.2µs   22.5µs    44256.      848B      0  
#> 10 cli_vec_plain    123.1µs  132.1µs     7367.   16.73KB     14.8
#> 11 fansi_vec_plain   59.8µs   64.3µs    15200.    5.59KB     12.7
#> 12 base_vec_plain    16.9µs   17.5µs    56421.      848B      0  
#> 13 cli_txt_ansi      79.3µs   84.7µs    11562.        0B     21.0
#> 14 fansi_txt_ansi    28.5µs     31µs    31405.      872B     22.0
#> 15 base_txt_ansi      671ns  732.1ns  1238545.        0B    124. 
#> 16 cli_txt_plain     74.9µs   80.2µs    12236.        0B     23.5
#> 17 fansi_txt_plain   28.2µs   31.5µs    31048.      872B     21.7
#> 18 base_txt_plain     581ns    641ns  1426756.        0B      0
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
#>  1 cli_ansi        196.88µs 212.86µs    4621.     6.18KB    23.6 
#>  2 fansi_ansi       49.86µs  56.13µs   17404.    97.33KB    18.9 
#>  3 base_ansi        17.16µs   19.1µs   51028.         0B    25.5 
#>  4 cli_plain       121.49µs    129µs    7636.         0B    23.2 
#>  5 fansi_plain      50.17µs  56.22µs   17158.       872B    21.2 
#>  6 base_plain       14.57µs  16.27µs   59985.         0B    18.0 
#>  7 cli_vec_ansi     21.29ms  21.77ms      46.0   94.67KB    46.0 
#>  8 fansi_vec_ansi  133.45µs 140.83µs    6970.     7.25KB    10.4 
#>  9 base_vec_ansi     1.26ms   1.32ms     750.    48.18KB    21.9 
#> 10 cli_vec_plain    13.36ms   13.5ms      73.5    2.48KB    33.7 
#> 11 fansi_vec_plain 106.52µs 113.14µs    8571.     6.42KB    12.5 
#> 12 base_vec_plain  902.86µs 945.19µs    1047.     47.4KB    21.6 
#> 13 cli_txt_ansi     14.62ms  15.13ms      66.0    4.27MB     9.43
#> 14 fansi_txt_ansi  127.48µs 134.69µs    7329.     6.77KB    10.4 
#> 15 base_txt_ansi   713.03µs 763.86µs    1276.   582.06KB    16.2 
#> 16 cli_txt_plain   672.68µs 730.64µs    1336.   369.84KB    15.7 
#> 17 fansi_txt_plain  99.65µs 108.97µs    8426.     2.51KB    10.5 
#> 18 base_txt_plain  478.09µs 521.47µs    1864.   367.31KB    15.9
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
#>  1 cli_ansi          3.79µs   4.43µs   213098.   25.09KB    42.6 
#>  2 fansi_ansi       42.39µs   47.6µs    20599.   28.48KB    19.1 
#>  3 base_ansi       621.08ns 661.12ns  1347855.        0B     0   
#>  4 cli_plain         3.58µs   4.37µs   218875.        0B    21.9 
#>  5 fansi_plain      41.08µs  47.44µs    20708.    1.98KB    19.1 
#>  6 base_plain      581.14ns 640.98ns  1354006.        0B   135.  
#>  7 cli_vec_ansi     14.72µs  15.82µs    62127.     1.7KB     6.21
#>  8 fansi_vec_ansi   62.83µs  68.37µs    13551.    8.86KB    12.7 
#>  9 base_vec_ansi     3.63µs   4.09µs   241601.      848B     0   
#> 10 cli_vec_plain    13.71µs  14.78µs    66418.     1.7KB     6.64
#> 11 fansi_vec_plain  58.81µs  65.93µs    14790.    8.86KB    15.0 
#> 12 base_vec_plain     3.5µs   3.89µs   251539.      848B     0   
#> 13 cli_txt_ansi      3.68µs   4.36µs   222565.        0B    22.3 
#> 14 fansi_txt_ansi   40.77µs  47.03µs    20829.    1.98KB    19.1 
#> 15 base_txt_ansi     2.85µs      3µs   312040.        0B    31.2 
#> 16 cli_txt_plain     4.38µs   5.05µs   188258.        0B    18.8 
#> 17 fansi_txt_plain  41.47µs  47.53µs    20560.    1.98KB    19.3 
#> 18 base_txt_plain    1.92µs      2µs   472813.        0B     0
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
#>  1 cli_ansi        50.95µs  55.87µs    17532.    12.1KB    16.7 
#>  2 base_ansi      791.16ns 852.04ns  1122937.        0B     0   
#>  3 cli_plain       40.81µs  44.57µs    21924.    8.91KB    15.4 
#>  4 base_plain     591.16ns 651.11ns  1468762.        0B     0   
#>  5 cli_vec_ansi     2.47ms   2.65ms      374.  838.95KB    24.9 
#>  6 base_vec_ansi    46.4µs  48.55µs    20383.      848B     0   
#>  7 cli_vec_plain    1.38ms   1.44ms      692.  817.08KB    24.2 
#>  8 base_vec_plain  25.27µs  26.62µs    36277.      848B     0   
#>  9 cli_txt_ansi     8.19ms   8.37ms      119.   114.6KB     4.18
#> 10 base_txt_ansi   47.21µs  48.96µs    20250.        0B     0   
#> 11 cli_txt_plain  151.32µs 161.04µs     6127.   18.34KB     6.10
#> 12 base_txt_plain  24.85µs  25.51µs    38607.        0B     0
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
#>  1 cli_ansi        50.29µs  55.94µs    17405.        0B    23.2 
#>  2 base_ansi        8.36µs    9.8µs    97954.        0B    19.6 
#>  3 cli_plain          50µs  55.21µs    17568.        0B    25.4 
#>  4 base_plain       8.19µs   9.37µs   103077.        0B    20.6 
#>  5 cli_vec_ansi   101.43µs 109.14µs     9002.     7.2KB    12.5 
#>  6 base_vec_ansi   29.24µs     34µs    29315.    1.66KB     5.86
#>  7 cli_vec_plain   91.48µs 100.26µs     9785.     7.2KB    12.6 
#>  8 base_vec_plain  26.37µs  30.49µs    32802.    1.66KB     6.56
#>  9 cli_txt_ansi    87.54µs   93.5µs    10518.        0B    14.5 
#> 10 base_txt_ansi   19.74µs  21.05µs    46618.        0B     9.33
#> 11 cli_txt_plain   78.05µs  85.16µs    10523.        0B    14.5 
#> 12 base_txt_plain   17.8µs  19.23µs    50852.        0B    10.2
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
#> 1 cli          4.32µs   5.15µs   187648.        0B    18.8 
#> 2 base       521.08ns 591.16ns  1520440.        0B     0   
#> 3 cli_vec     12.46µs  13.65µs    71764.      448B     7.18
#> 4 base_vec     6.76µs   7.37µs   134083.      448B     0   
#> 5 cli_txt     13.29µs  14.38µs    67789.        0B    13.6 
#> 6 base_txt     7.52µs   7.76µs   126408.        0B     0
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
#> 1 cli           4.5µs   5.39µs   179771.        0B    18.0 
#> 2 base          791ns 881.15ns  1062305.        0B     0   
#> 3 cli_vec      15.3µs  16.61µs    59127.      448B     5.91
#> 4 base_vec     28.1µs  28.92µs    34218.      448B     3.42
#> 5 cli_txt      15.3µs  16.29µs    58014.        0B     5.80
#> 6 base_txt     50.9µs  53.22µs    18652.        0B     0
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
#> 1 cli           4.5µs   5.34µs   181260.        0B    18.1 
#> 2 base       519.91ns 581.03ns  1564047.        0B     0   
#> 3 cli_vec     10.85µs  11.84µs    81454.      448B    16.3 
#> 4 base_vec     6.81µs   7.34µs   133770.      448B     0   
#> 5 cli_txt     11.62µs  12.46µs    78767.        0B     7.88
#> 6 base_txt     7.51µs   7.69µs   128112.        0B     0
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
#> 1 cli          3.42µs   4.05µs   236275.    22.2KB    23.6 
#> 2 base       620.96ns 671.02ns  1296326.        0B     0   
#> 3 cli_vec     16.62µs  17.99µs    54372.     1.7KB     5.44
#> 4 base_vec     4.55µs   4.71µs   208674.      848B     0   
#> 5 cli_txt      3.46µs   4.08µs   229622.        0B    45.9 
#> 6 base_txt     2.64µs   2.81µs   343356.        0B     0
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
#>  date     2026-10-19
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-10-19 [1] local
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
#>  xfun          0.62       2026-10-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
