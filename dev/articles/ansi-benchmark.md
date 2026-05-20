# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x557ea064c2a0\>
\<environment: 0x557ea10f4a58\>

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
#> 1 ansi         46.5µs   50.1µs    19336.    99.6KB     19.0
#> 2 plain        46.6µs   49.8µs    19405.        0B     19.8
#> 3 base         11.5µs   12.6µs    76371.    48.6KB     22.9
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
#> 1 ansi         48.6µs   52.4µs    18402.        0B     23.7
#> 2 plain        48.2µs     52µs    18615.        0B     21.2
#> 3 base         13.3µs   14.8µs    65640.        0B     19.7
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
#> 1 ansi       114.38µs 121.03µs     8004.   76.15KB     14.7
#> 2 plain       89.61µs  94.42µs    10235.    8.73KB     16.8
#> 3 base         1.87µs   2.01µs   477993.        0B      0
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
#> 1 ansi          347µs    374µs     2634.   33.23KB     19.1
#> 2 plain         349µs    370µs     2663.    1.09KB     19.2
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
#>  1 cli_ansi          5.86µs   6.41µs   150582.    9.27KB    30.1 
#>  2 fansi_ansi       31.29µs   34.4µs    28096.    4.18KB    22.5 
#>  3 cli_plain         5.84µs   6.39µs   150472.        0B    30.1 
#>  4 fansi_plain      30.99µs  33.66µs    28203.      688B    16.9 
#>  5 cli_vec_ansi       7.3µs   7.78µs   123487.      448B    12.3 
#>  6 fansi_vec_ansi   40.93µs  43.41µs    22136.    5.02KB     8.86
#>  7 cli_vec_plain     7.85µs    8.3µs   117077.      448B    11.7 
#>  8 fansi_vec_plain  38.93µs  41.23µs    23511.    5.02KB     9.41
#>  9 cli_txt_ansi      5.73µs   6.14µs   157253.        0B    15.7 
#> 10 fansi_txt_ansi   30.75µs  32.81µs    29568.      688B    14.8 
#> 11 cli_txt_plain     6.61µs   7.01µs   138800.        0B    13.9 
#> 12 fansi_txt_plain  39.12µs  41.78µs    23206.    5.02KB     9.29
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
#> 1 cli            57µs   59.9µs    16334.    22.7KB     6.13
#> 2 fansi         119µs  126.4µs     7804.    55.3KB     4.06
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
#>  1 cli_ansi           7.2µs   7.82µs   123630.        0B    12.4 
#>  2 fansi_ansi       92.84µs  97.37µs     9957.   38.84KB     8.20
#>  3 base_ansi        902.1ns 952.04ns   968060.        0B    96.8 
#>  4 cli_plain         6.99µs    7.7µs   126252.        0B    12.6 
#>  5 fansi_plain      91.39µs  96.91µs    10000.      688B     8.20
#>  6 base_plain      830.97ns 881.15ns  1050970.        0B     0   
#>  7 cli_vec_ansi     29.73µs  30.58µs    32072.      448B     3.21
#>  8 fansi_vec_ansi  113.86µs 118.99µs     8125.    5.02KB     6.17
#>  9 base_vec_ansi     17.2µs  17.35µs    56612.      448B     5.66
#> 10 cli_vec_plain    27.75µs  28.58µs    34236.      448B     3.42
#> 11 fansi_vec_plain 103.14µs 109.09µs     8876.    5.02KB     6.15
#> 12 base_vec_plain   10.11µs  10.25µs    95248.      448B     9.53
#> 13 cli_txt_ansi        29µs  29.77µs    32872.        0B     3.29
#> 14 fansi_txt_ansi  104.79µs 110.05µs     8554.      688B     6.12
#> 15 base_txt_ansi    16.89µs     17µs    57975.        0B     0   
#> 16 cli_txt_plain    27.26µs  27.95µs    35057.        0B     3.51
#> 17 fansi_txt_plain  93.89µs  98.97µs     9777.      688B    10.3 
#> 18 base_txt_plain   10.33µs  10.39µs    94648.        0B     0
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
#>  1 cli_ansi          8.71µs   9.43µs   102769.        0B    10.3 
#>  2 fansi_ansi       93.06µs     98µs     9851.      688B     8.28
#>  3 base_ansi         1.23µs    1.3µs   715221.        0B    71.5 
#>  4 cli_plain          8.6µs   9.38µs   103415.        0B    10.3 
#>  5 fansi_plain      92.26µs  97.54µs     9935.      688B     8.21
#>  6 base_plain        1.02µs   1.07µs   866927.        0B     0   
#>  7 cli_vec_ansi     34.62µs  35.65µs    27184.      448B     2.72
#>  8 fansi_vec_ansi  116.21µs 121.43µs     7931.    5.02KB     8.26
#>  9 base_vec_ansi     41.1µs  41.44µs    23801.      448B     0   
#> 10 cli_vec_plain    33.18µs  34.06µs    28731.      448B     2.87
#> 11 fansi_vec_plain 106.68µs 111.03µs     8706.    5.02KB     8.27
#> 12 base_vec_plain   21.65µs  21.95µs    44909.      448B     0   
#> 13 cli_txt_ansi     34.43µs  35.22µs    27682.        0B     2.77
#> 14 fansi_txt_ansi  107.36µs 112.44µs     8598.      688B     8.20
#> 15 base_txt_ansi    43.71µs  44.08µs    22417.        0B     0   
#> 16 cli_txt_plain    32.52µs  33.34µs    29334.        0B     5.87
#> 17 fansi_txt_plain   97.4µs 102.28µs     9473.      688B     8.20
#> 18 base_txt_plain   22.98µs  23.83µs    41436.        0B     0
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
#> 1 cli_ansi        7.22µs   7.75µs   125043.        0B    12.5 
#> 2 cli_plain        6.7µs   7.24µs   133666.        0B    13.4 
#> 3 cli_vec_ansi   31.85µs  33.36µs    29359.      848B     2.94
#> 4 cli_vec_plain  10.65µs   11.3µs    86118.      848B     8.61
#> 5 cli_txt_ansi   31.02µs  32.13µs    30558.        0B     0   
#> 6 cli_txt_plain    7.5µs   8.07µs   120479.        0B    12.0
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
#>  1 cli_ansi          26.3µs   27.7µs    35094.        0B    14.0 
#>  2 fansi_ansi        29.2µs   31.2µs    30936.    7.24KB    12.4 
#>  3 cli_plain         25.7µs   27.2µs    35607.        0B    14.2 
#>  4 fansi_plain       28.8µs   30.6µs    31595.      688B    15.8 
#>  5 cli_vec_ansi      35.5µs   37.2µs    26061.      848B    10.4 
#>  6 fansi_vec_ansi    55.7µs   58.5µs    16618.    5.41KB     6.19
#>  7 cli_vec_plain     28.7µs   30.3µs    31977.      848B    16.0 
#>  8 fansi_vec_plain   37.7µs   39.7µs    24455.    4.59KB     9.79
#>  9 cli_txt_ansi      34.6µs   35.9µs    27141.        0B    10.9 
#> 10 fansi_txt_ansi    44.6µs   46.4µs    20944.    5.12KB     8.38
#> 11 cli_txt_plain     26.8µs   27.9µs    34755.        0B    13.9 
#> 12 fansi_txt_plain   29.6µs   31.3µs    30844.      688B    15.4
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
#>  1 cli_ansi        166.03µs 172.95µs     5608.  104.86KB    10.3 
#>  2 fansi_ansi      132.26µs  139.4µs     6952.  106.35KB    10.3 
#>  3 base_ansi         4.16µs   4.57µs   213114.      224B     0   
#>  4 cli_plain       165.56µs 172.36µs     5599.    8.09KB    10.3 
#>  5 fansi_plain     130.35µs 137.47µs     7065.    9.62KB    10.4 
#>  6 base_plain         3.7µs      4µs   243016.        0B     0   
#>  7 cli_vec_ansi      7.86ms   7.95ms      126.  823.77KB    13.7 
#>  8 fansi_vec_ansi    1.06ms    1.1ms      894.  846.81KB    17.3 
#>  9 base_vec_ansi    157.9µs 164.22µs     5956.    22.7KB     2.04
#> 10 cli_vec_plain     7.76ms   7.96ms      125.  823.77KB    11.4 
#> 11 fansi_vec_plain 992.34µs   1.03ms      921.  845.98KB    17.3 
#> 12 base_vec_plain  107.47µs 112.37µs     8644.      848B     4.06
#> 13 cli_txt_ansi      3.41ms   3.45ms      288.    63.6KB     0   
#> 14 fansi_txt_ansi    1.57ms   1.59ms      625.   35.05KB     0   
#> 15 base_txt_ansi   138.03µs 146.82µs     6751.   18.47KB     4.08
#> 16 cli_txt_plain     2.44ms   2.46ms      400.    63.6KB     0   
#> 17 fansi_txt_plain 522.23µs 558.06µs     1791.    30.6KB     2.02
#> 18 base_txt_plain   89.62µs  93.22µs    10543.   11.05KB     2.02
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
#>  1 cli_ansi        148.96µs 156.49µs     6198.   33.84KB    12.5 
#>  2 fansi_ansi       55.28µs  59.07µs    16274.   31.42KB    12.5 
#>  3 base_ansi         1.07µs   1.11µs   851266.     4.2KB     0   
#>  4 cli_plain       147.94µs 154.43µs     6257.        0B    12.4 
#>  5 fansi_plain      54.68µs  58.81µs    16368.      872B    10.3 
#>  6 base_plain      992.09ns   1.06µs   865739.        0B    86.6 
#>  7 cli_vec_ansi    273.61µs 283.61µs     3443.   16.73KB     6.17
#>  8 fansi_vec_ansi  116.21µs 121.06µs     7944.    5.59KB     6.29
#>  9 base_vec_ansi    36.49µs   37.4µs    26315.      848B     0   
#> 10 cli_vec_plain   232.45µs 241.66µs     4032.   16.73KB     8.30
#> 11 fansi_vec_plain 109.41µs 113.43µs     8558.    5.59KB     6.16
#> 12 base_vec_plain   30.78µs  31.75µs    31182.      848B     0   
#> 13 cli_txt_ansi    157.09µs 163.94µs     5905.        0B    12.5 
#> 14 fansi_txt_ansi   54.94µs  58.73µs    16484.      872B    13.3 
#> 15 base_txt_ansi      1.1µs   1.15µs   831264.        0B     0   
#> 16 cli_txt_plain   146.97µs 152.79µs     6362.        0B    12.4 
#> 17 fansi_txt_plain  53.72µs  56.11µs    17242.      872B    12.5 
#> 18 base_txt_plain    1.02µs   1.07µs   887769.        0B     0
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
#>  1 cli_ansi        407.74µs 430.19µs    2310.         0B    10.3 
#>  2 fansi_ansi      101.15µs 107.31µs    9024.    97.33KB    10.5 
#>  3 base_ansi        39.23µs  41.65µs   23184.         0B    11.6 
#>  4 cli_plain       277.47µs 290.97µs    3355.         0B    10.3 
#>  5 fansi_plain      98.95µs 104.58µs    9284.       872B    10.3 
#>  6 base_plain       32.17µs  34.01µs   27963.         0B    11.2 
#>  7 cli_vec_ansi     43.42ms  43.52ms      22.9    2.48KB    22.9 
#>  8 fansi_vec_ansi  240.96µs  249.9µs    3918.     7.25KB     6.14
#>  9 base_vec_ansi     2.28ms   2.35ms     424.    48.18KB    12.7 
#> 10 cli_vec_plain    29.64ms  29.87ms      33.3    2.48KB    13.9 
#> 11 fansi_vec_plain 194.19µs 201.83µs    4824.     6.42KB     6.15
#> 12 base_vec_plain    1.66ms   1.71ms     578.     47.4KB    12.8 
#> 13 cli_txt_ansi     25.37ms  25.48ms      39.1  507.59KB     6.90
#> 14 fansi_txt_ansi  228.03µs 235.96µs    4155.     6.77KB     4.06
#> 15 base_txt_ansi     1.26ms   1.29ms     768.   582.06KB    11.1 
#> 16 cli_txt_plain     1.28ms   1.33ms     745.   369.84KB    10.1 
#> 17 fansi_txt_plain 178.67µs 185.41µs    5274.     2.51KB     6.12
#> 18 base_txt_plain  852.45µs 893.85µs    1106.   367.31KB     8.76
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
#>  1 cli_ansi          6.89µs   7.45µs   129075.   25.09KB    12.9 
#>  2 fansi_ansi       81.45µs   86.4µs    11190.   28.48KB    10.4 
#>  3 base_ansi         1.04µs   1.11µs   827874.        0B     0   
#>  4 cli_plain         6.65µs   7.23µs   133219.        0B    13.3 
#>  5 fansi_plain      80.61µs  85.59µs    11320.    1.98KB    12.5 
#>  6 base_plain           1µs   1.06µs   875586.        0B     0   
#>  7 cli_vec_ansi     27.57µs  28.62µs    34181.     1.7KB     3.42
#>  8 fansi_vec_ansi  117.77µs 123.78µs     7849.    8.86KB     8.34
#>  9 base_vec_ansi     6.15µs   6.43µs   152618.      848B     0   
#> 10 cli_vec_plain    23.31µs  24.52µs    39917.     1.7KB     3.99
#> 11 fansi_vec_plain 112.81µs 118.53µs     8190.    8.86KB     8.36
#> 12 base_vec_plain     5.7µs   6.04µs   161601.      848B     0   
#> 13 cli_txt_ansi      6.66µs   7.26µs   131822.        0B    13.2 
#> 14 fansi_txt_ansi   80.49µs  85.37µs    11350.    1.98KB    12.5 
#> 15 base_txt_ansi     6.48µs   6.53µs   149744.        0B     0   
#> 16 cli_txt_plain      7.5µs   8.04µs   120734.        0B    12.1 
#> 17 fansi_txt_plain  80.13µs  85.37µs    11365.    1.98KB    10.4 
#> 18 base_txt_plain    4.12µs   4.19µs   228760.        0B     0
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
#>  1 cli_ansi       107.34µs 112.26µs    8588.    11.88KB     8.22
#>  2 base_ansi        1.32µs   1.37µs  688563.         0B     0   
#>  3 cli_plain       85.52µs  89.81µs   10729.     8.73KB     8.22
#>  4 base_plain       1.02µs   1.07µs  876099.         0B     0   
#>  5 cli_vec_ansi     4.31ms   4.46ms     223.   838.77KB    13.2 
#>  6 base_vec_ansi   71.88µs  72.19µs   13666.       848B     0   
#>  7 cli_vec_plain     2.4ms   2.47ms     401.    816.9KB    15.5 
#>  8 base_vec_plain  42.47µs  43.07µs   22946.       848B     0   
#>  9 cli_txt_ansi    14.41ms  14.53ms      68.7  114.42KB     4.16
#> 10 base_txt_ansi   73.21µs   73.7µs   13405.         0B     0   
#> 11 cli_txt_plain  273.47µs 281.72µs    3482.    18.16KB     2.02
#> 12 base_txt_plain  41.06µs   42.6µs   23341.         0B     0
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
#>  1 cli_ansi          110µs  116.2µs     8353.        0B    12.4 
#>  2 base_ansi        16.6µs   17.8µs    54213.        0B    10.8 
#>  3 cli_plain       109.8µs  115.1µs     8431.        0B    12.4 
#>  4 base_plain       16.5µs   17.7µs    54882.        0B    11.0 
#>  5 cli_vec_ansi    208.4µs  216.4µs     4510.     7.2KB     6.16
#>  6 base_vec_ansi    59.4µs   64.3µs    15160.    1.66KB     2.02
#>  7 cli_vec_plain   192.7µs  201.7µs     4843.     7.2KB     8.24
#>  8 base_vec_plain   51.9µs   57.4µs    16963.    1.66KB     2.01
#>  9 cli_txt_ansi    180.1µs  185.1µs     5263.        0B     8.19
#> 10 base_txt_ansi    40.6µs   41.5µs    23566.        0B     4.71
#> 11 cli_txt_plain   163.6µs  168.6µs     5778.        0B     8.18
#> 12 base_txt_plain     35µs   36.1µs    26938.        0B     5.39
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
#> 1 cli          8.39µs   9.06µs   106063.        0B    21.2 
#> 2 base       881.03ns 932.14ns  1003623.        0B     0   
#> 3 cli_vec     24.02µs  24.78µs    39524.      448B     3.95
#> 4 base_vec    11.66µs  11.92µs    82557.      448B     0   
#> 5 cli_txt     24.01µs  24.73µs    39420.        0B     3.94
#> 6 base_txt    12.63µs  12.71µs    77387.        0B     0
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
#> 1 cli          8.33µs   8.95µs   107871.        0B    10.8 
#> 2 base          1.3µs   1.35µs   701856.        0B     0   
#> 3 cli_vec     29.34µs  30.13µs    32533.      448B     3.25
#> 4 base_vec    50.71µs  51.31µs    19271.      448B     0   
#> 5 cli_txt      29.7µs  30.41µs    32230.        0B     3.22
#> 6 base_txt    86.48µs  87.56µs    11288.        0B     2.01
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
#> 1 cli           8.8µs   9.46µs   101941.        0B    10.2 
#> 2 base          881ns 931.09ns   987655.        0B     0   
#> 3 cli_vec        20µs  20.74µs    47099.      448B     9.42
#> 4 base_vec     11.7µs  11.97µs    82291.      448B     0   
#> 5 cli_txt      20.6µs  21.23µs    46129.        0B     4.61
#> 6 base_txt     12.6µs   12.7µs    77265.        0B     0
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
#> 1 cli          6.47µs      7µs   138211.    22.2KB    27.6 
#> 2 base         1.06µs   1.11µs   836959.        0B     0   
#> 3 cli_vec      30.5µs  31.34µs    31354.     1.7KB     3.14
#> 4 base_vec     8.41µs   8.64µs   113600.      848B     0   
#> 5 cli_txt      6.34µs   6.86µs   141973.        0B    14.2 
#> 6 base_txt     5.71µs    5.8µs   168555.        0B    16.9
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
#>  date     2026-05-20
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-20 [1] local
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
#>  sessioninfo   1.2.3      2025-02-05 [1] RSPM
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.57       2026-03-20 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.0/lib/R/site-library
#>  [3] /opt/R/4.6.0/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
