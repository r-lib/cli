# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55e7a213de18\>
\<environment: 0x55e7a2c6d568\>

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
#> 1 ansi         44.8µs   48.4µs    20001.    99.2KB     21.0
#> 2 plain        44.5µs   48.4µs    20014.        0B     22.1
#> 3 base         11.4µs   12.4µs    78594.    48.6KB     15.7
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
#> 1 ansi           47µs   50.5µs    19168.        0B     21.3
#> 2 plain        46.7µs   49.8µs    19401.        0B     23.3
#> 3 base         13.2µs   14.5µs    66612.        0B     26.7
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
#> 1 ansi       110.71µs 117.48µs     8228.   76.09KB     16.8
#> 2 plain       88.14µs  92.86µs    10371.    8.73KB     14.6
#> 3 base         1.86µs   1.99µs   479327.        0B      0
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
#> 1 ansi          337µs    360µs     2713.   33.16KB     21.3
#> 2 plain         333µs    358µs     2749.    1.09KB     19.1
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
#>  1 cli_ansi           5.8µs   6.39µs   151049.    9.19KB    30.2 
#>  2 fansi_ansi       30.94µs   33.9µs    28555.    4.18KB    25.7 
#>  3 cli_plain         5.84µs   6.35µs   151067.        0B    30.2 
#>  4 fansi_plain       30.4µs  32.66µs    29048.      688B    14.5 
#>  5 cli_vec_ansi       7.2µs   7.67µs   124844.      448B    12.5 
#>  6 fansi_vec_ansi   40.66µs  43.17µs    22289.    5.02KB     8.92
#>  7 cli_vec_plain     7.78µs   8.22µs   118410.      448B    11.8 
#>  8 fansi_vec_plain  38.38µs  40.89µs    23777.    5.02KB     9.51
#>  9 cli_txt_ansi      5.77µs   6.17µs   157513.        0B    15.8 
#> 10 fansi_txt_ansi   30.32µs  32.67µs    29709.      688B    14.9 
#> 11 cli_txt_plain     6.63µs   7.08µs   136298.        0B    13.6 
#> 12 fansi_txt_plain  38.44µs  41.29µs    22826.    5.02KB     9.13
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
#> 1 cli          56.5µs   58.4µs    16752.    22.6KB     4.05
#> 2 fansi       118.2µs  124.1µs     7831.    55.3KB     4.06
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
#>  1 cli_ansi          6.77µs   7.37µs   128915.        0B    12.9 
#>  2 fansi_ansi       93.06µs  97.88µs     9886.   38.84KB    10.3 
#>  3 base_ansi       901.99ns 961.01ns   973447.        0B     0   
#>  4 cli_plain         6.83µs   7.42µs   130990.        0B    13.1 
#>  5 fansi_plain      91.92µs  96.99µs     9907.      688B     8.20
#>  6 base_plain      811.07ns 862.05ns  1068054.        0B     0   
#>  7 cli_vec_ansi     29.14µs  30.09µs    32495.      448B     3.25
#>  8 fansi_vec_ansi  113.63µs    119µs     8105.    5.02KB     8.26
#>  9 base_vec_ansi    18.47µs  18.57µs    52348.      448B     0   
#> 10 cli_vec_plain    27.48µs  28.29µs    34501.      448B     3.45
#> 11 fansi_vec_plain    104µs 108.76µs     8896.    5.02KB     8.28
#> 12 base_vec_plain   10.81µs  10.89µs    90305.      448B     0   
#> 13 cli_txt_ansi     28.71µs  29.48µs    33141.        0B     3.31
#> 14 fansi_txt_ansi  105.37µs 110.38µs     8524.      688B     8.21
#> 15 base_txt_ansi    18.21µs  18.28µs    53911.        0B     0   
#> 16 cli_txt_plain    27.07µs  27.78µs    35268.        0B     3.53
#> 17 fansi_txt_plain  95.19µs  99.99µs     9676.      688B     8.21
#> 18 base_txt_plain   10.58µs  11.11µs    88607.        0B     0
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
#>  1 cli_ansi          8.47µs   9.24µs   104490.        0B    20.9 
#>  2 fansi_ansi       92.85µs   98.3µs     9839.      688B     8.20
#>  3 base_ansi         1.23µs   1.28µs   741283.        0B     0   
#>  4 cli_plain         8.46µs   9.23µs   104960.        0B    10.5 
#>  5 fansi_plain      92.62µs  97.78µs     9887.      688B    10.3 
#>  6 base_plain        1.01µs   1.07µs   876857.        0B     0   
#>  7 cli_vec_ansi     34.49µs  35.43µs    27349.      448B     2.74
#>  8 fansi_vec_ansi  116.22µs 122.12µs     7916.    5.02KB     6.16
#>  9 base_vec_ansi    44.08µs  44.53µs    21987.      448B     2.20
#> 10 cli_vec_plain    32.89µs   33.8µs    28839.      448B     2.88
#> 11 fansi_vec_plain 106.79µs  112.4µs     8573.    5.02KB     8.29
#> 12 base_vec_plain   22.97µs  23.25µs    42269.      448B     0   
#> 13 cli_txt_ansi     34.16µs  34.98µs    27675.        0B     2.77
#> 14 fansi_txt_ansi  107.15µs 112.64µs     8578.      688B     8.21
#> 15 base_txt_ansi    46.46µs  47.19µs    20951.        0B     0   
#> 16 cli_txt_plain    32.44µs  33.22µs    29510.        0B     2.95
#> 17 fansi_txt_plain  96.83µs 102.16µs     9483.      688B     8.21
#> 18 base_txt_plain   24.45µs  25.33µs    38999.        0B     0
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
#> 1 cli_ansi        6.75µs   7.29µs   132931.        0B    13.3 
#> 2 cli_plain       6.34µs   6.87µs   140931.        0B     0   
#> 3 cli_vec_ansi   31.27µs  32.44µs    30281.      848B     3.03
#> 4 cli_vec_plain   10.3µs  10.92µs    89364.      848B     8.94
#> 5 cli_txt_ansi   30.65µs  31.85µs    30800.        0B     3.08
#> 6 cli_txt_plain   7.18µs    7.7µs   126288.        0B    12.6
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
#>  1 cli_ansi            26µs   27.7µs    35093.        0B    17.6 
#>  2 fansi_ansi        28.5µs   30.6µs    31572.    7.24KB    12.6 
#>  3 cli_plain         25.8µs   27.4µs    35442.        0B    14.2 
#>  4 fansi_plain         28µs   29.8µs    32537.      688B    13.0 
#>  5 cli_vec_ansi      35.1µs   36.9µs    26435.      848B    13.2 
#>  6 fansi_vec_ansi    55.4µs     59µs    16512.    5.41KB     6.18
#>  7 cli_vec_plain     28.5µs   29.9µs    32513.      848B    16.3 
#>  8 fansi_vec_plain   37.1µs   38.8µs    24980.    4.59KB    10.00
#>  9 cli_txt_ansi      34.1µs   35.5µs    27520.        0B    11.0 
#> 10 fansi_txt_ansi    43.8µs   45.5µs    21350.    5.12KB     8.54
#> 11 cli_txt_plain     26.3µs   27.6µs    35072.        0B    17.5 
#> 12 fansi_txt_plain   28.9µs   30.6µs    31664.      688B    12.7
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
#>  1 cli_ansi        163.69µs 170.82µs     5692.  104.31KB    10.3 
#>  2 fansi_ansi      128.34µs    136µs     7151.  106.35KB    10.4 
#>  3 base_ansi         4.04µs   4.39µs   221070.      224B     0   
#>  4 cli_plain       162.98µs 170.15µs     5689.    8.09KB    10.3 
#>  5 fansi_plain     126.38µs 134.24µs     7245.    9.62KB    12.5 
#>  6 base_plain        3.67µs   3.92µs   247283.        0B     0   
#>  7 cli_vec_ansi      7.54ms   7.73ms      129.  823.77KB    13.6 
#>  8 fansi_vec_ansi    1.06ms   1.09ms      882.  846.81KB    17.2 
#>  9 base_vec_ansi   155.82µs  162.5µs     6001.    22.7KB     2.04
#> 10 cli_vec_plain     7.56ms   7.69ms      130.  823.77KB    11.4 
#> 11 fansi_vec_plain 982.95µs   1.02ms      978.  845.98KB    19.6 
#> 12 base_vec_plain  106.59µs 110.42µs     8717.      848B     4.06
#> 13 cli_txt_ansi      3.41ms   3.45ms      289.    63.6KB     0   
#> 14 fansi_txt_ansi    1.57ms   1.59ms      626.   35.05KB     0   
#> 15 base_txt_ansi   133.61µs 143.19µs     6769.   18.47KB     2.02
#> 16 cli_txt_plain     2.44ms   2.46ms      405.    63.6KB     2.02
#> 17 fansi_txt_plain 520.97µs 558.47µs     1796.    30.6KB     2.02
#> 18 base_txt_plain   87.23µs  89.89µs    10713.   11.05KB     2.02
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
#>  1 cli_ansi        147.08µs 154.64µs     6282.   33.81KB    12.5 
#>  2 fansi_ansi       54.91µs  58.49µs    16534.   31.42KB    12.5 
#>  3 base_ansi         1.05µs    1.1µs   863976.     4.2KB     0   
#>  4 cli_plain       144.72µs 151.54µs     6418.        0B    12.4 
#>  5 fansi_plain      54.16µs  57.85µs    16707.      872B    12.7 
#>  6 base_plain      981.03ns   1.02µs   909381.        0B     0   
#>  7 cli_vec_ansi    272.53µs 283.56µs     3461.   16.73KB     6.16
#>  8 fansi_vec_ansi  115.58µs    120µs     8104.    5.59KB     6.16
#>  9 base_vec_ansi    36.79µs  37.66µs    26280.      848B     0   
#> 10 cli_vec_plain   232.43µs 241.95µs     4035.   16.73KB     8.29
#> 11 fansi_vec_plain  108.4µs 112.78µs     8630.    5.59KB     6.17
#> 12 base_vec_plain   30.34µs  31.19µs    31628.      848B     0   
#> 13 cli_txt_ansi     155.3µs 162.72µs     5974.        0B    12.5 
#> 14 fansi_txt_ansi   53.81µs  56.01µs    17199.      872B    12.1 
#> 15 base_txt_ansi     1.08µs   1.13µs   841489.        0B     0   
#> 16 cli_txt_plain   145.48µs 151.23µs     6253.        0B    14.6 
#> 17 fansi_txt_plain  53.61µs   56.2µs    17182.      872B    12.5 
#> 18 base_txt_plain  992.09ns   1.04µs   915830.        0B     0
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
#>  1 cli_ansi        410.94µs 437.28µs    2272.         0B    10.5 
#>  2 fansi_ansi       97.94µs 105.26µs    9211.    97.33KB    10.3 
#>  3 base_ansi        38.58µs  40.98µs   23565.         0B    11.8 
#>  4 cli_plain       276.95µs 288.83µs    3373.         0B    10.3 
#>  5 fansi_plain       97.4µs 104.03µs    9272.       872B    10.3 
#>  6 base_plain       31.41µs  33.47µs   28595.         0B    11.4 
#>  7 cli_vec_ansi     42.75ms  43.06ms      23.2    2.48KB    23.2 
#>  8 fansi_vec_ansi   238.7µs 248.17µs    3956.     7.25KB     6.15
#>  9 base_vec_ansi     2.29ms   2.37ms     420.    48.18KB    13.0 
#> 10 cli_vec_plain    29.06ms  29.41ms      34.0    2.48KB    14.1 
#> 11 fansi_vec_plain 191.58µs 200.33µs    4841.     6.42KB     8.26
#> 12 base_vec_plain    1.65ms   1.72ms     581.     47.4KB    10.5 
#> 13 cli_txt_ansi     25.97ms  26.16ms      38.0  507.59KB     7.12
#> 14 fansi_txt_ansi  226.23µs 234.86µs    4171.     6.77KB     6.15
#> 15 base_txt_ansi     1.28ms   1.32ms     749.   582.06KB     8.73
#> 16 cli_txt_plain      1.3ms   1.34ms     739.   369.84KB    10.8 
#> 17 fansi_txt_plain 178.83µs 186.26µs    5237.     2.51KB     6.13
#> 18 base_txt_plain  868.77µs 909.57µs    1083.   367.31KB     8.68
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
#>  1 cli_ansi          6.89µs   7.58µs   127019.   24.81KB    12.7 
#>  2 fansi_ansi       79.24µs  85.09µs    11398.   28.48KB    10.5 
#>  3 base_ansi         1.04µs    1.1µs   850099.        0B     0   
#>  4 cli_plain         6.76µs    7.4µs   129124.        0B    25.8 
#>  5 fansi_plain      79.66µs  84.54µs    11446.    1.98KB    10.4 
#>  6 base_plain      991.98ns   1.05µs   892080.        0B     0   
#>  7 cli_vec_ansi     27.86µs  28.87µs    33897.     1.7KB     3.39
#>  8 fansi_vec_ansi  117.14µs 122.55µs     7918.    8.86KB     8.35
#>  9 base_vec_ansi     6.34µs   6.67µs   146477.      848B     0   
#> 10 cli_vec_plain    23.84µs  25.19µs    38768.     1.7KB     7.76
#> 11 fansi_vec_plain 111.29µs 116.41µs     8312.    8.86KB     8.31
#> 12 base_vec_plain    6.05µs   6.38µs   152723.      848B     0   
#> 13 cli_txt_ansi      6.63µs   7.41µs   131127.        0B    13.1 
#> 14 fansi_txt_ansi   78.14µs  81.54µs    11894.    1.98KB    10.3 
#> 15 base_txt_ansi     6.46µs   6.54µs   145925.        0B    14.6 
#> 16 cli_txt_plain     7.43µs   7.96µs   118451.        0B    11.8 
#> 17 fansi_txt_plain  77.82µs  81.28µs    11937.    1.98KB    10.3 
#> 18 base_txt_plain    4.11µs   4.17µs   233979.        0B    23.4
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
#>  1 cli_ansi       104.86µs 108.98µs    8855.    11.85KB    10.3 
#>  2 base_ansi        1.33µs   1.38µs  706958.         0B     0   
#>  3 cli_plain       84.08µs  88.04µs   10957.     8.73KB     8.31
#>  4 base_plain       1.02µs   1.07µs  899147.         0B     0   
#>  5 cli_vec_ansi     4.15ms   4.26ms     233.   838.77KB    13.1 
#>  6 base_vec_ansi   75.43µs  76.18µs   12968.       848B     0   
#>  7 cli_vec_plain    2.33ms   2.37ms     419.    816.9KB    15.1 
#>  8 base_vec_plain  45.55µs  46.51µs   21232.       848B     0   
#>  9 cli_txt_ansi     14.9ms     15ms      66.5  114.42KB     4.29
#> 10 base_txt_ansi   75.14µs  76.54µs   12894.         0B     0   
#> 11 cli_txt_plain  265.66µs 275.04µs    3565.    18.16KB     2.01
#> 12 base_txt_plain  42.86µs  43.81µs   22691.         0B     0
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
#>  1 cli_ansi        109.6µs  114.1µs     8491.        0B    10.3 
#>  2 base_ansi        16.9µs   18.1µs    53204.        0B    16.0 
#>  3 cli_plain       108.2µs  112.8µs     8557.        0B    10.3 
#>  4 base_plain       16.7µs   17.9µs    53835.        0B    16.2 
#>  5 cli_vec_ansi    212.4µs  221.3µs     4400.     7.2KB     6.16
#>  6 base_vec_ansi    59.7µs   66.9µs    14620.    1.66KB     2.02
#>  7 cli_vec_plain   198.5µs    207µs     4703.     7.2KB     6.15
#>  8 base_vec_plain   53.2µs     60µs    16367.    1.66KB     4.11
#>  9 cli_txt_ansi    183.4µs  189.8µs     5126.        0B     8.20
#> 10 base_txt_ansi    41.4µs   42.6µs    22876.        0B     4.58
#> 11 cli_txt_plain     168µs  173.6µs     5601.        0B     8.19
#> 12 base_txt_plain   35.7µs   36.9µs    26413.        0B     5.28
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
#> 1 cli          8.18µs   8.85µs   109426.        0B    10.9 
#> 2 base       862.17ns 921.08ns   987175.        0B     0   
#> 3 cli_vec      23.7µs  24.59µs    39711.      448B     3.97
#> 4 base_vec    11.47µs   11.7µs    83426.      448B     8.34
#> 5 cli_txt     23.86µs  24.56µs    39461.        0B     3.95
#> 6 base_txt     12.5µs   12.6µs    77928.        0B     0
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
#> 1 cli          8.09µs   8.78µs   109967.        0B    11.0 
#> 2 base          1.3µs   1.35µs   695860.        0B     0   
#> 3 cli_vec     28.92µs  29.99µs    32511.      448B     6.50
#> 4 base_vec    50.44µs  50.88µs    19376.      448B     0   
#> 5 cli_txt     29.46µs  30.24µs    32283.        0B     3.23
#> 6 base_txt    86.54µs  87.39µs    11254.        0B     0
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
#> 1 cli           8.7µs   9.39µs   103007.        0B    20.6 
#> 2 base          881ns 940.99ns  1001519.        0B     0   
#> 3 cli_vec      19.6µs  20.49µs    47668.      448B     4.77
#> 4 base_vec     11.5µs  11.68µs    84038.      448B     0   
#> 5 cli_txt      20.4µs  21.26µs    45966.        0B     9.19
#> 6 base_txt     12.5µs  12.59µs    78183.        0B     0
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
#> 1 cli          6.53µs    7.1µs   136583.    22.1KB    13.7 
#> 2 base         1.06µs   1.12µs   839201.        0B     0   
#> 3 cli_vec     29.38µs  30.26µs    32389.     1.7KB     6.48
#> 4 base_vec     8.11µs   8.38µs   117459.      848B     0   
#> 5 cli_txt      6.36µs   6.95µs   139425.        0B    13.9 
#> 6 base_txt     5.48µs   5.55µs   175894.        0B     0
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
#>  date     2026-10-01
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version date (UTC) lib source
#>  bench         1.1.4   2025-01-16 [1] RSPM
#>  bslib         0.12.0  2026-08-04 [1] RSPM
#>  cachem        1.1.0   2024-05-16 [1] RSPM
#>  cli         * 3.6.6   2026-10-01 [1] local
#>  codetools     0.2-20  2024-03-31 [3] CRAN (R 4.6.1)
#>  desc          1.4.3   2023-12-10 [1] RSPM
#>  digest        0.6.39  2025-11-19 [1] RSPM
#>  evaluate      1.0.5   2025-08-27 [1] RSPM
#>  fansi       * 1.0.7   2025-11-19 [1] RSPM
#>  fastmap       1.2.0   2024-05-15 [1] RSPM
#>  fs            2.1.0   2026-04-18 [1] RSPM
#>  glue          1.8.1   2026-04-17 [1] RSPM
#>  htmltools     0.5.9   2025-12-04 [1] RSPM
#>  htmlwidgets   1.6.4   2023-12-06 [1] RSPM
#>  jquerylib     0.1.4   2021-04-26 [1] RSPM
#>  jsonlite      2.0.0   2025-03-27 [1] RSPM
#>  knitr         1.52    2026-09-06 [1] RSPM
#>  lifecycle     1.0.5   2026-01-08 [1] RSPM
#>  magrittr      2.0.5   2026-04-04 [1] RSPM
#>  otel          0.2.0   2025-08-29 [1] RSPM
#>  pillar        1.11.1  2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3   2019-09-22 [1] RSPM
#>  pkgdown       2.2.1   2026-07-07 [1] any (@2.2.1)
#>  profmem       0.7.0   2025-05-02 [1] RSPM
#>  R6            2.6.1   2025-02-15 [1] RSPM
#>  ragg          1.5.2   2026-03-23 [1] RSPM
#>  rlang         1.3.0   2026-07-05 [1] RSPM
#>  rmarkdown     2.32    2026-09-01 [1] RSPM
#>  sass          0.4.10  2025-04-11 [1] RSPM
#>  sessioninfo   1.2.4   2026-06-04 [1] any (@1.2.4)
#>  systemfonts   1.3.2   2026-03-05 [1] RSPM
#>  textshaping   1.0.5   2026-03-06 [1] RSPM
#>  tibble        3.3.1   2026-01-11 [1] RSPM
#>  utf8          1.2.6   2025-06-08 [1] RSPM
#>  vctrs         0.7.3   2026-04-11 [1] RSPM
#>  xfun          0.61    2026-09-16 [1] RSPM
#>  yaml          2.3.12  2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
