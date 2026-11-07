# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x646007bb93d8\>
\<environment: 0x64600864b918\>

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
#> 1 ansi         46.3µs     50µs    19459.    99.6KB     21.1
#> 2 plain          46µs   50.5µs    19218.        0B     22.0
#> 3 base         11.6µs   12.8µs    75626.    48.6KB     15.1
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
#> 1 ansi         48.3µs   51.9µs    18683.        0B     21.3
#> 2 plain          48µs   51.8µs    18734.        0B     23.3
#> 3 base         13.6µs     15µs    64433.        0B     25.8
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
#> 1 ansi       113.75µs  121.2µs     8002.   77.03KB     16.8
#> 2 plain       91.24µs  96.91µs     9993.    8.91KB     14.6
#> 3 base         1.62µs   1.71µs   555110.        0B      0
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
#> 1 ansi          347µs    371µs     2657.   33.23KB     19.1
#> 2 plain         345µs    369µs     2677.    1.09KB     21.3
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
#>  1 cli_ansi          5.82µs   6.51µs   148766.    9.27KB    29.8 
#>  2 fansi_ansi       31.43µs  34.44µs    28032.    4.18KB    25.3 
#>  3 cli_plain         5.82µs   6.47µs   149821.        0B    30.0 
#>  4 fansi_plain      30.69µs  32.86µs    28723.      688B    11.5 
#>  5 cli_vec_ansi      7.43µs      8µs   121263.      448B    12.1 
#>  6 fansi_vec_ansi    40.2µs  43.03µs    22321.    5.02KB     8.93
#>  7 cli_vec_plain     7.95µs   8.53µs   114433.      448B    11.4 
#>  8 fansi_vec_plain  39.39µs  41.72µs    23261.    5.02KB     9.31
#>  9 cli_txt_ansi      5.84µs   6.25µs   155539.        0B    15.6 
#> 10 fansi_txt_ansi   30.83µs  32.91µs    29422.      688B    14.7 
#> 11 cli_txt_plain      6.6µs   7.11µs   136438.        0B    13.6 
#> 12 fansi_txt_plain  39.54µs  42.16µs    22812.    5.02KB     9.13
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
#> 1 cli          53.2µs   55.1µs    17734.    22.7KB     6.12
#> 2 fansi       111.2µs  116.5µs     8368.    55.3KB     4.05
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
#>  1 cli_ansi          7.15µs   7.79µs   125200.        0B    12.5 
#>  2 fansi_ansi       91.37µs  95.93µs    10119.   38.84KB     8.18
#>  3 base_ansi       832.02ns 882.08ns  1059224.        0B   106.  
#>  4 cli_plain         7.12µs   7.72µs   125451.        0B    12.5 
#>  5 fansi_plain      90.17µs  95.37µs    10041.      688B     8.18
#>  6 base_plain      790.93ns 832.02ns  1111802.        0B     0   
#>  7 cli_vec_ansi     29.16µs  30.22µs    32419.      448B     3.24
#>  8 fansi_vec_ansi  111.83µs 118.03µs     8237.    5.02KB     6.13
#>  9 base_vec_ansi    14.58µs   14.7µs    66900.      448B     6.69
#> 10 cli_vec_plain    27.73µs  28.52µs    34356.      448B     3.44
#> 11 fansi_vec_plain 101.39µs 107.39µs     9051.    5.02KB     6.15
#> 12 base_vec_plain    8.66µs   8.76µs   111154.      448B    11.1 
#> 13 cli_txt_ansi     29.32µs  30.43µs    32235.        0B     3.22
#> 14 fansi_txt_ansi  104.48µs 109.94µs     8844.      688B     6.11
#> 15 base_txt_ansi    14.21µs  14.28µs    68779.        0B     0   
#> 16 cli_txt_plain     27.3µs  28.04µs    34960.        0B     3.50
#> 17 fansi_txt_plain  94.11µs   98.9µs     9813.      688B     8.19
#> 18 base_txt_plain    8.35µs   8.89µs   112587.        0B    11.3
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
#>  1 cli_ansi          8.69µs   9.44µs   102485.        0B    10.2 
#>  2 fansi_ansi       92.52µs  97.52µs     9957.      688B     8.27
#>  3 base_ansi         1.17µs   1.23µs   751962.        0B     0   
#>  4 cli_plain         8.88µs   9.55µs   101948.        0B    20.4 
#>  5 fansi_plain      90.77µs  96.27µs    10079.      688B     8.18
#>  6 base_plain      962.06ns   1.01µs   925575.        0B     0   
#>  7 cli_vec_ansi     35.33µs  36.29µs    26809.      448B     2.68
#>  8 fansi_vec_ansi  115.38µs 120.69µs     8048.    5.02KB     8.25
#>  9 base_vec_ansi    40.81µs  41.18µs    23946.      448B     0   
#> 10 cli_vec_plain    34.27µs  35.22µs    27838.      448B     2.78
#> 11 fansi_vec_plain 105.01µs 109.29µs     8879.    5.02KB     8.25
#> 12 base_vec_plain   20.86µs  21.38µs    46087.      448B     0   
#> 13 cli_txt_ansi     35.79µs  36.58µs    26785.        0B     2.68
#> 14 fansi_txt_ansi  107.68µs 112.54µs     8636.      688B     8.19
#> 15 base_txt_ansi    43.13µs  43.45µs    22718.        0B     0   
#> 16 cli_txt_plain    33.73µs  34.63µs    28298.        0B     2.83
#> 17 fansi_txt_plain   96.3µs 101.69µs     9540.      688B     8.18
#> 18 base_txt_plain   22.78µs  23.36µs    42337.        0B     0
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
#> 1 cli_ansi        6.85µs    7.5µs   129327.        0B     0   
#> 2 cli_plain       6.55µs   7.18µs   135013.        0B    13.5 
#> 3 cli_vec_ansi   30.99µs  31.92µs    30697.      848B     3.07
#> 4 cli_vec_plain  10.57µs  11.28µs    86367.      848B     8.64
#> 5 cli_txt_ansi   29.39µs  30.35µs    32210.        0B     3.22
#> 6 cli_txt_plain   7.24µs      8µs   119762.        0B    12.0
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
#>  1 cli_ansi          26.5µs   28.3µs    34367.        0B    13.8 
#>  2 fansi_ansi        28.8µs   30.9µs    31201.    7.24KB    12.5 
#>  3 cli_plain         26.5µs     28µs    34607.        0B    17.3 
#>  4 fansi_plain       28.3µs   30.3µs    31939.      688B    12.8 
#>  5 cli_vec_ansi      35.3µs   37.1µs    26231.      848B    10.5 
#>  6 fansi_vec_ansi    55.5µs     58µs    16771.    5.41KB     6.18
#>  7 cli_vec_plain     28.9µs   30.7µs    31675.      848B    15.8 
#>  8 fansi_vec_plain   38.2µs   39.9µs    24376.    4.59KB     9.75
#>  9 cli_txt_ansi      34.1µs   35.5µs    27410.        0B    11.0 
#> 10 fansi_txt_ansi      45µs   46.6µs    20891.    5.12KB     8.36
#> 11 cli_txt_plain     27.1µs   28.6µs    34069.        0B    13.6 
#> 12 fansi_txt_plain     30µs   31.5µs    30734.      688B    12.3
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
#>  1 cli_ansi        163.85µs 171.76µs     5641.  104.86KB     8.18
#>  2 fansi_ansi      128.15µs 135.11µs     7203.  106.35KB    10.3 
#>  3 base_ansi         3.79µs   3.95µs   246198.      224B    24.6 
#>  4 cli_plain       163.53µs 170.04µs     5722.    8.09KB    10.3 
#>  5 fansi_plain     126.98µs 133.83µs     7276.    9.62KB    10.4 
#>  6 base_plain        3.17µs   3.33µs   290599.        0B     0   
#>  7 cli_vec_ansi      7.55ms   7.73ms      129.  823.77KB    13.6 
#>  8 fansi_vec_ansi    1.05ms   1.08ms      906.  846.81KB    17.3 
#>  9 base_vec_ansi   152.01µs 156.24µs     6257.    22.7KB     2.03
#> 10 cli_vec_plain     7.42ms   7.74ms      129.  823.77KB    11.5 
#> 11 fansi_vec_plain 983.54µs   1.01ms      978.  845.98KB    19.6 
#> 12 base_vec_plain  102.96µs 106.92µs     9182.      848B     4.06
#> 13 cli_txt_ansi      3.27ms   3.31ms      301.    63.6KB     0   
#> 14 fansi_txt_ansi    1.63ms   1.65ms      601.   35.05KB     0   
#> 15 base_txt_ansi   137.57µs 145.49µs     6817.   18.47KB     2.02
#> 16 cli_txt_plain     2.42ms   2.45ms      406.    63.6KB     2.02
#> 17 fansi_txt_plain  512.5µs 528.96µs     1880.    30.6KB     2.02
#> 18 base_txt_plain   88.19µs  89.95µs    10975.   11.05KB     2.02
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
#>  1 cli_ansi        154.59µs 161.63µs     6026.   33.84KB    12.5 
#>  2 fansi_ansi       55.35µs  59.35µs    16347.   31.42KB    10.4 
#>  3 base_ansi         1.03µs   1.08µs   859054.     4.2KB     0   
#>  4 cli_plain        151.7µs 159.35µs     6106.        0B    12.5 
#>  5 fansi_plain      55.32µs  59.16µs    16392.      872B    12.5 
#>  6 base_plain      942.03ns 992.09ns   957322.        0B     0   
#>  7 cli_vec_ansi    276.57µs  288.2µs     3363.   16.73KB     6.17
#>  8 fansi_vec_ansi  115.47µs 120.19µs     8111.    5.59KB     6.31
#>  9 base_vec_ansi    34.83µs  35.04µs    28123.      848B     0   
#> 10 cli_vec_plain   238.62µs 248.01µs     3944.   16.73KB     8.31
#> 11 fansi_vec_plain 106.45µs 110.77µs     8797.    5.59KB     6.17
#> 12 base_vec_plain    28.4µs  29.74µs    33317.      848B     0   
#> 13 cli_txt_ansi    162.13µs 168.88µs     5770.        0B    12.5 
#> 14 fansi_txt_ansi   54.97µs  59.87µs    15078.      872B    10.4 
#> 15 base_txt_ansi     1.06µs   1.11µs   843212.        0B     0   
#> 16 cli_txt_plain   154.43µs 174.77µs     5433.        0B    10.1 
#> 17 fansi_txt_plain  54.14µs  57.32µs    16839.      872B    12.5 
#> 18 base_txt_plain  972.07ns   1.02µs   928089.        0B     0
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
#>  1 cli_ansi        429.84µs 456.41µs    2176.     6.18KB    10.3 
#>  2 fansi_ansi      100.38µs 106.87µs    9122.    97.33KB    12.7 
#>  3 base_ansi        38.96µs  41.49µs   23240.         0B     9.30
#>  4 cli_plain        284.6µs 300.88µs    3265.         0B    10.3 
#>  5 fansi_plain      99.19µs    106µs    9123.       872B    10.3 
#>  6 base_plain       31.58µs  33.85µs   28456.         0B    11.4 
#>  7 cli_vec_ansi     45.81ms  46.12ms      21.7   94.67KB    18.0 
#>  8 fansi_vec_ansi   234.9µs 244.28µs    4024.     7.25KB     6.15
#>  9 base_vec_ansi     2.31ms   2.39ms     417.    48.18KB    12.9 
#> 10 cli_vec_plain    29.95ms   30.4ms      32.4    2.48KB    10.8 
#> 11 fansi_vec_plain 189.09µs 196.87µs    4958.     6.42KB     8.35
#> 12 base_vec_plain    1.66ms   1.75ms     570.     47.4KB    10.6 
#> 13 cli_txt_ansi     25.13ms  25.59ms      39.1    4.27MB     6.90
#> 14 fansi_txt_ansi  222.09µs 232.03µs    4233.     6.77KB     6.14
#> 15 base_txt_ansi     1.25ms   1.29ms     762.   582.06KB    11.2 
#> 16 cli_txt_plain     1.28ms   1.32ms     750.   369.84KB     8.67
#> 17 fansi_txt_plain 173.12µs 181.48µs    5382.     2.51KB     6.13
#> 18 base_txt_plain  856.29µs 889.81µs    1110.   367.31KB     8.70
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
#>  1 cli_ansi          6.68µs   7.43µs   130177.   25.09KB    13.0 
#>  2 fansi_ansi       81.05µs   86.3µs    11198.   28.48KB    10.4 
#>  3 base_ansi       991.04ns   1.04µs   895748.        0B     0   
#>  4 cli_plain         6.67µs   7.42µs   129551.        0B    13.0 
#>  5 fansi_plain      81.15µs  86.33µs    11199.    1.98KB    10.4 
#>  6 base_plain      952.04ns   1.02µs   883473.        0B    88.4 
#>  7 cli_vec_ansi     27.26µs  28.39µs    34492.     1.7KB     3.45
#>  8 fansi_vec_ansi  115.36µs 121.65µs     8004.    8.86KB     6.21
#>  9 base_vec_ansi     5.74µs   6.07µs   159986.      848B    16.0 
#> 10 cli_vec_plain    23.56µs  24.71µs    39616.     1.7KB     3.96
#> 11 fansi_vec_plain 111.17µs 116.11µs     8339.    8.86KB     8.39
#> 12 base_vec_plain    5.42µs   5.74µs   170233.      848B     0   
#> 13 cli_txt_ansi      6.72µs   7.46µs   129539.        0B    13.0 
#> 14 fansi_txt_ansi   81.48µs  86.52µs    11208.    1.98KB    10.4 
#> 15 base_txt_ansi     5.12µs   5.19µs   187786.        0B     0   
#> 16 cli_txt_plain     7.57µs   8.28µs   116439.        0B    23.3 
#> 17 fansi_txt_plain   79.1µs  85.33µs    11396.    1.98KB     9.77
#> 18 base_txt_plain    3.34µs    3.4µs   288095.        0B     0
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
#>  1 cli_ansi       109.35µs 114.11µs    8502.     12.1KB     8.21
#>  2 base_ansi        1.29µs   1.34µs  719608.         0B     0   
#>  3 cli_plain       88.62µs  92.36µs   10396.     8.91KB     6.11
#>  4 base_plain     961.01ns      1µs  957685.         0B    95.8 
#>  5 cli_vec_ansi     4.16ms   4.23ms     236.   838.95KB    13.1 
#>  6 base_vec_ansi   74.71µs  75.19µs   13148.       848B     0   
#>  7 cli_vec_plain    2.33ms    2.4ms     414.   817.08KB    15.3 
#>  8 base_vec_plain  45.38µs  45.69µs   21641.       848B     0   
#>  9 cli_txt_ansi    12.57ms  12.66ms      78.9   114.6KB     4.27
#> 10 base_txt_ansi   76.77µs  77.04µs   12830.         0B     0   
#> 11 cli_txt_plain  285.23µs 295.79µs    3320.    18.34KB     2.01
#> 12 base_txt_plain  42.69µs  43.81µs   22705.         0B     0
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
#>  1 cli_ansi        115.1µs  120.7µs     8040.        0B    10.3 
#>  2 base_ansi        17.3µs   18.5µs    52542.        0B    10.5 
#>  3 cli_plain       112.2µs  119.1µs     8142.        0B    12.4 
#>  4 base_plain       17.3µs   18.4µs    52871.        0B    10.6 
#>  5 cli_vec_ansi    200.2µs    207µs     4724.     7.2KB     6.14
#>  6 base_vec_ansi    54.2µs   59.1µs    16512.    1.66KB     4.06
#>  7 cli_vec_plain   187.4µs  193.7µs     5036.     7.2KB     6.14
#>  8 base_vec_plain   50.9µs   52.5µs    18624.    1.66KB     4.06
#>  9 cli_txt_ansi    177.6µs  183.7µs     5315.        0B     8.19
#> 10 base_txt_ansi    38.9µs   40.4µs    24193.        0B     4.84
#> 11 cli_txt_plain   162.9µs  169.8µs     5744.        0B     8.17
#> 12 base_txt_plain   35.7µs     37µs    26354.        0B     5.27
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
#> 1 cli           8.2µs      9µs   101913.        0B    10.2 
#> 2 base        821.1ns  872.1ns  1026470.        0B     0   
#> 3 cli_vec      24.1µs     25µs    39125.      448B     3.91
#> 4 base_vec     11.6µs   11.8µs    83649.      448B     0   
#> 5 cli_txt      24.2µs     25µs    38984.        0B     7.80
#> 6 base_txt     12.5µs   12.6µs    78389.        0B     0
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
#> 1 cli          8.26µs   8.98µs   108314.        0B    10.8 
#> 2 base         1.28µs   1.35µs   705653.        0B     0   
#> 3 cli_vec     29.38µs  30.28µs    32359.      448B     3.24
#> 4 base_vec     49.9µs  50.78µs    19461.      448B     2.02
#> 5 cli_txt     29.96µs  30.79µs    31835.        0B     3.18
#> 6 base_txt    86.08µs  87.23µs    11341.        0B     0
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
#> 1 cli          8.73µs   9.58µs   101388.        0B    10.1 
#> 2 base       821.08ns 882.08ns  1056665.        0B     0   
#> 3 cli_vec     19.68µs  20.55µs    47519.      448B     9.51
#> 4 base_vec     11.6µs  11.77µs    83501.      448B     0   
#> 5 cli_txt     20.43µs   21.2µs    46153.        0B     4.62
#> 6 base_txt    12.49µs  12.57µs    78327.        0B     0
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
#> 1 cli          6.24µs   6.87µs   140440.    22.2KB    14.0 
#> 2 base            1µs   1.06µs   882368.        0B     0   
#> 3 cli_vec     29.05µs  29.96µs    32784.     1.7KB     3.28
#> 4 base_vec     7.36µs   7.57µs   129827.      848B     0   
#> 5 cli_txt      6.23µs   6.85µs   140272.        0B    28.1 
#> 6 base_txt     5.41µs   5.48µs   177314.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.2 (2026-10-29)
#>  os       Ubuntu 26.04.1 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-11-07
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-07 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.2)
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
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.62       2026-10-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.2/lib/R/site-library
#>  [3] /opt/R/4.6.2/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
