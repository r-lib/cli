# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5566cb13d768\>
\<environment: 0x5566cbbf8c18\>

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
#> 1 ansi         46.1µs   49.9µs    19253.    99.6KB     19.0
#> 2 plain        45.8µs     50µs    19237.        0B     19.8
#> 3 base         11.2µs   12.6µs    75609.    48.4KB     22.7
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
#> 1 ansi         47.1µs   51.9µs    18568.        0B     21.4
#> 2 plain          47µs   51.8µs    18561.        0B     21.5
#> 3 base         13.2µs   14.5µs    66235.        0B     19.9
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
#> 1 ansi        111.4µs 121.61µs     7994.   75.07KB     14.7
#> 2 plain       88.38µs  96.05µs    10098.    8.73KB     12.5
#> 3 base         1.82µs   1.97µs   476842.        0B     47.7
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
#> 1 ansi          336µs    365µs     2712.   33.24KB     19.2
#> 2 plain         338µs    366µs     2703.    1.09KB     19.3
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
#>  1 cli_ansi          5.76µs   6.31µs   151014.    9.27KB     30.2
#>  2 fansi_ansi        30.9µs  34.14µs    28188.    4.18KB     22.6
#>  3 cli_plain         5.71µs   6.27µs   152363.        0B     30.5
#>  4 fansi_plain      30.24µs  33.62µs    28774.      688B     23.0
#>  5 cli_vec_ansi      7.13µs   7.61µs   126459.      448B     25.3
#>  6 fansi_vec_ansi    39.9µs  42.61µs    22589.    5.02KB     18.1
#>  7 cli_vec_plain     7.75µs   8.22µs   117196.      448B     23.4
#>  8 fansi_vec_plain  37.62µs  40.41µs    23727.    5.02KB     19.0
#>  9 cli_txt_ansi      5.72µs   6.15µs   153676.        0B     30.7
#> 10 fansi_txt_ansi   30.42µs  32.63µs    29422.      688B     23.6
#> 11 cli_txt_plain     6.57µs   6.98µs   137577.        0B     27.5
#> 12 fansi_txt_plain  37.94µs  40.59µs    22948.    5.02KB     18.4
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
#> 1 cli          56.7µs   58.9µs    16476.    22.7KB    10.3 
#> 2 fansi       118.6µs  123.9µs     7919.    55.3KB     8.20
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
#>  1 cli_ansi          6.72µs   7.28µs   130955.        0B    26.2 
#>  2 fansi_ansi       90.22µs  97.21µs     9988.   38.83KB    16.8 
#>  3 base_ansi       840.98ns 891.04ns  1030515.        0B     0   
#>  4 cli_plain         6.64µs   7.24µs   132368.        0B    26.5 
#>  5 fansi_plain      90.47µs  97.34µs     9979.      688B    16.9 
#>  6 base_plain      772.07ns 822.01ns  1115532.        0B     0   
#>  7 cli_vec_ansi     29.32µs  30.22µs    32112.      448B     6.42
#>  8 fansi_vec_ansi  110.98µs 119.05µs     8180.    5.02KB    12.6 
#>  9 base_vec_ansi    14.69µs  14.79µs    65642.      448B     6.56
#> 10 cli_vec_plain    27.33µs  28.19µs    34418.      448B     3.44
#> 11 fansi_vec_plain 100.97µs 107.81µs     9006.    5.02KB    14.7 
#> 12 base_vec_plain    8.76µs   8.86µs   109445.      448B    10.9 
#> 13 cli_txt_ansi     28.66µs  30.32µs    32349.        0B     3.24
#> 14 fansi_txt_ansi  103.22µs 110.79µs     8718.      688B    14.6 
#> 15 base_txt_ansi    14.27µs  14.35µs    67693.        0B     6.77
#> 16 cli_txt_plain     26.9µs  27.72µs    34906.        0B     3.49
#> 17 fansi_txt_plain  92.12µs  99.42µs     9720.      688B    16.9 
#> 18 base_txt_plain    8.42µs   8.98µs   108341.        0B     0
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
#>  1 cli_ansi          8.34µs   8.98µs   106435.        0B    21.3 
#>  2 fansi_ansi       90.84µs  97.67µs     9896.      688B    16.8 
#>  3 base_ansi         1.18µs   1.23µs   746838.        0B     0   
#>  4 cli_plain         8.34µs   9.09µs   104956.        0B    21.0 
#>  5 fansi_plain      91.05µs  98.77µs     9831.      688B    17.2 
#>  6 base_plain      961.12ns   1.02µs   900246.        0B     0   
#>  7 cli_vec_ansi     34.43µs  35.39µs    27310.      448B     8.20
#>  8 fansi_vec_ansi  114.07µs 121.38µs     8003.    5.02KB    12.5 
#>  9 base_vec_ansi    42.58µs  43.51µs    22477.      448B     0   
#> 10 cli_vec_plain    32.65µs  33.73µs    28750.      448B     5.75
#> 11 fansi_vec_plain 103.94µs    111µs     8763.    5.02KB    12.5 
#> 12 base_vec_plain   22.18µs   22.6µs    43122.      448B     4.31
#> 13 cli_txt_ansi     34.26µs  35.12µs    27493.        0B     5.50
#> 14 fansi_txt_ansi  105.65µs 114.79µs     8510.      688B    14.6 
#> 15 base_txt_ansi    45.09µs  45.76µs    21277.        0B     0   
#> 16 cli_txt_plain    32.33µs  33.25µs    29119.        0B     5.83
#> 17 fansi_txt_plain  95.94µs 103.19µs     9438.      688B    16.8 
#> 18 base_txt_plain    23.8µs   24.6µs    39569.        0B     0
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
#> 1 cli_ansi         6.6µs   7.12µs   134694.        0B    26.9 
#> 2 cli_plain       6.29µs   6.75µs   142474.        0B    28.5 
#> 3 cli_vec_ansi   31.38µs  32.48µs    29824.      848B     2.98
#> 4 cli_vec_plain  10.13µs  10.75µs    89473.      848B    17.9 
#> 5 cli_txt_ansi   30.68µs  31.88µs    30387.        0B     3.04
#> 6 cli_txt_plain    7.1µs   7.62µs   126222.        0B    25.2
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
#>  1 cli_ansi          25.4µs     27µs    35544.        0B     28.5
#>  2 fansi_ansi        28.1µs   30.2µs    31791.    7.24KB     25.5
#>  3 cli_plain         25.2µs   26.7µs    35991.        0B     28.8
#>  4 fansi_plain       27.8µs   29.8µs    30836.      688B     24.7
#>  5 cli_vec_ansi      34.7µs   36.6µs    26314.      848B     21.1
#>  6 fansi_vec_ansi    53.7µs   56.9µs    17032.    5.41KB     12.6
#>  7 cli_vec_plain     28.2µs   29.9µs    32082.      848B     25.7
#>  8 fansi_vec_plain   36.7µs   39.5µs    24390.    4.59KB     19.5
#>  9 cli_txt_ansi      34.3µs   36.2µs    26645.        0B     21.3
#> 10 fansi_txt_ansi      44µs   46.9µs    20584.    5.12KB     17.4
#> 11 cli_txt_plain     26.1µs   27.6µs    34641.        0B     24.3
#> 12 fansi_txt_plain   28.8µs   30.7µs    31314.      688B     25.1
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
#>  1 cli_ansi        165.02µs 176.34µs     5517.  104.86KB    19.2 
#>  2 fansi_ansi      128.77µs 137.34µs     7086.  106.35KB    19.1 
#>  3 base_ansi         3.97µs   4.37µs   218428.      224B    21.8 
#>  4 cli_plain       162.73µs 174.93µs     5576.    8.09KB    19.1 
#>  5 fansi_plain     126.25µs 135.78µs     7163.    9.62KB    19.1 
#>  6 base_plain        3.44µs   3.75µs   255284.        0B     0   
#>  7 cli_vec_ansi      7.69ms   7.93ms      126.  823.77KB    25.7 
#>  8 fansi_vec_ansi    1.09ms   1.14ms      811.  846.81KB    17.4 
#>  9 base_vec_ansi    154.1µs 161.46µs     6082.    22.7KB     2.03
#> 10 cli_vec_plain     7.67ms   7.89ms      126.  823.77KB    26.2 
#> 11 fansi_vec_plain   1.04ms   1.08ms      894.  845.98KB    17.7 
#> 12 base_vec_plain  105.06µs 110.11µs     8887.      848B     4.07
#> 13 cli_txt_ansi      3.46ms   3.53ms      282.    63.6KB     2.03
#> 14 fansi_txt_ansi    1.56ms    1.6ms      623.   35.05KB     0   
#> 15 base_txt_ansi   136.33µs 145.68µs     6784.   18.47KB     4.08
#> 16 cli_txt_plain     2.48ms   2.53ms      393.    63.6KB     0   
#> 17 fansi_txt_plain  515.8µs 547.21µs     1809.    30.6KB     6.18
#> 18 base_txt_plain   88.06µs  91.24µs    10720.   11.05KB     2.02
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
#>  1 cli_ansi        147.28µs 159.58µs     6050.   33.84KB     23.8
#>  2 fansi_ansi       53.33µs  58.29µs    16426.   31.42KB     21.2
#>  3 base_ansi         1.03µs   1.09µs   849837.     4.2KB      0  
#>  4 cli_plain       143.26µs 154.32µs     6277.        0B     25.1
#>  5 fansi_plain      53.06µs  56.48µs    17086.      872B     21.2
#>  6 base_plain      962.06ns      1µs   945668.        0B     94.6
#>  7 cli_vec_ansi    269.91µs 286.45µs     3437.   16.73KB     12.6
#>  8 fansi_vec_ansi  115.85µs 122.34µs     7999.    5.59KB     12.5
#>  9 base_vec_ansi    36.36µs  38.03µs    25669.      848B      0  
#> 10 cli_vec_plain   229.73µs 244.32µs     4018.   16.73KB     14.8
#> 11 fansi_vec_plain 109.22µs 115.33µs     8476.    5.59KB     12.6
#> 12 base_vec_plain   30.31µs  30.74µs    31642.      848B      0  
#> 13 cli_txt_ansi    153.86µs 165.47µs     5898.        0B     21.3
#> 14 fansi_txt_ansi   53.82µs  57.99µs    16693.      872B     23.5
#> 15 base_txt_ansi     1.08µs   1.13µs   827893.        0B      0  
#> 16 cli_txt_plain   144.41µs 155.62µs     6194.        0B     23.6
#> 17 fansi_txt_plain   53.7µs  57.85µs    16693.      872B     21.3
#> 18 base_txt_plain  981.96ns   1.03µs   889858.        0B     89.0
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
#>  1 cli_ansi        400.15µs 432.89µs    2283.         0B    21.4 
#>  2 fansi_ansi       97.86µs 105.82µs    9145.    97.32KB    19.2 
#>  3 base_ansi        38.35µs   40.9µs   23194.         0B    20.9 
#>  4 cli_plain       272.84µs 293.13µs    3341.         0B    20.6 
#>  5 fansi_plain      95.28µs 103.62µs    9409.       872B    10.3 
#>  6 base_plain       30.91µs  33.13µs   28875.         0B    11.6 
#>  7 cli_vec_ansi      42.8ms  43.33ms      23.1    2.48KB    23.1 
#>  8 fansi_vec_ansi  235.79µs  250.3µs    3949.     7.25KB     4.06
#>  9 base_vec_ansi     2.26ms   2.36ms     422.    48.18KB    13.0 
#> 10 cli_vec_plain    29.12ms  29.37ms      33.9    2.48KB    18.5 
#> 11 fansi_vec_plain 192.07µs 203.23µs    4836.     6.42KB     6.14
#> 12 base_vec_plain    1.64ms   1.71ms     580.     47.4KB    12.8 
#> 13 cli_txt_ansi     24.52ms  24.65ms      40.5  507.59KB     7.14
#> 14 fansi_txt_ansi  226.91µs 240.86µs    4092.     6.77KB     4.06
#> 15 base_txt_ansi     1.25ms    1.3ms     759.   582.06KB    11.1 
#> 16 cli_txt_plain     1.28ms   1.33ms     742.   369.84KB     8.68
#> 17 fansi_txt_plain 180.73µs 189.86µs    5163.     2.51KB     8.25
#> 18 base_txt_plain  857.62µs 901.47µs    1096.   367.31KB     8.75
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
#>  1 cli_ansi          6.78µs   7.39µs   127631.   25.09KB    25.5 
#>  2 fansi_ansi       79.28µs  85.69µs    11327.   28.48KB    10.5 
#>  3 base_ansi       981.03ns   1.03µs   884629.        0B     0   
#>  4 cli_plain         6.68µs   7.29µs   130917.        0B    13.1 
#>  5 fansi_plain      79.39µs  85.42µs    11382.    1.98KB    12.5 
#>  6 base_plain      962.17ns   1.02µs   896370.        0B     0   
#>  7 cli_vec_ansi     28.27µs  29.39µs    33058.     1.7KB     3.31
#>  8 fansi_vec_ansi  115.56µs 122.88µs     7943.    8.86KB     8.35
#>  9 base_vec_ansi     6.03µs   6.27µs   154375.      848B     0   
#> 10 cli_vec_plain    23.76µs  24.95µs    38926.     1.7KB     3.89
#> 11 fansi_vec_plain 109.67µs 116.37µs     8373.    8.86KB     8.36
#> 12 base_vec_plain     5.7µs   6.04µs   159696.      848B     0   
#> 13 cli_txt_ansi       6.6µs   7.31µs   130401.        0B    26.1 
#> 14 fansi_txt_ansi   78.42µs  85.17µs    11387.    1.98KB    10.4 
#> 15 base_txt_ansi     5.13µs   5.21µs   184538.        0B     0   
#> 16 cli_txt_plain     7.47µs   8.11µs   118587.        0B    11.9 
#> 17 fansi_txt_plain  77.94µs  84.57µs    11367.    1.98KB    12.5 
#> 18 base_txt_plain    3.37µs   3.43µs   279877.        0B     0
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
#>  1 cli_ansi       104.31µs 112.56µs    8620.    11.88KB     8.23
#>  2 base_ansi        1.27µs   1.32µs  720680.         0B     0   
#>  3 cli_plain       84.84µs  90.78µs   10634.     8.73KB     8.32
#>  4 base_plain     961.01ns   1.01µs  937007.         0B     0   
#>  5 cli_vec_ansi     4.23ms   4.37ms     228.   838.77KB    13.3 
#>  6 base_vec_ansi   71.87µs  72.33µs   13513.       848B     0   
#>  7 cli_vec_plain    2.31ms   2.44ms     408.    816.9KB    15.3 
#>  8 base_vec_plain  43.08µs  43.75µs   22334.       848B     0   
#>  9 cli_txt_ansi    13.62ms  13.81ms      72.0  114.42KB     4.23
#> 10 base_txt_ansi   73.63µs  74.97µs   13039.         0B     0   
#> 11 cli_txt_plain  259.49µs 277.13µs    3566.    18.16KB     2.01
#> 12 base_txt_plain  40.82µs  41.53µs   23601.         0B     0
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
#>  1 cli_ansi        107.2µs  114.6µs     8467.        0B    12.2 
#>  2 base_ansi        16.3µs   17.2µs    55547.        0B    11.1 
#>  3 cli_plain       106.1µs  112.5µs     8650.        0B    12.4 
#>  4 base_plain       16.2µs   17.2µs    55763.        0B    11.2 
#>  5 cli_vec_ansi    198.6µs  212.4µs     4630.     7.2KB     6.16
#>  6 base_vec_ansi    54.5µs   62.4µs    15700.    1.66KB     4.07
#>  7 cli_vec_plain   183.3µs  197.9µs     4972.     7.2KB     6.20
#>  8 base_vec_plain   49.3µs   56.8µs    17313.    1.66KB     4.07
#>  9 cli_txt_ansi    172.8µs  183.8µs     5326.        0B     6.11
#> 10 base_txt_ansi    38.2µs   39.5µs    24478.        0B     7.35
#> 11 cli_txt_plain   157.4µs  166.8µs     5866.        0B     8.19
#> 12 base_txt_plain   33.8µs   35.1µs    27541.        0B     5.51
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
#> 1 cli          7.96µs   8.65µs   111024.        0B    11.1 
#> 2 base       822.01ns 882.08ns  1031147.        0B     0   
#> 3 cli_vec     23.36µs   24.4µs    39505.      448B     3.95
#> 4 base_vec    11.67µs  12.02µs    80800.      448B     8.08
#> 5 cli_txt     23.66µs  24.55µs    39387.        0B     3.94
#> 6 base_txt    12.31µs  12.39µs    78712.        0B     0
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
#> 1 cli          7.95µs   8.68µs   109640.        0B    11.0 
#> 2 base         1.26µs   1.33µs   693992.        0B    69.4 
#> 3 cli_vec     28.84µs  29.92µs    32351.      448B     3.24
#> 4 base_vec    51.59µs  52.21µs    18716.      448B     0   
#> 5 cli_txt      29.3µs  30.19µs    32159.        0B     3.22
#> 6 base_txt     88.3µs  90.22µs    10860.        0B     0
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
#> 1 cli          8.52µs   9.19µs   103975.        0B    20.8 
#> 2 base       830.97ns 882.08ns  1014708.        0B     0   
#> 3 cli_vec     19.66µs  20.62µs    46794.      448B     4.68
#> 4 base_vec    11.64µs  11.98µs    81595.      448B     0   
#> 5 cli_txt     20.05µs  20.77µs    46701.        0B     9.34
#> 6 base_txt    12.31µs  12.39µs    78527.        0B     0
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
#> 1 cli           6.4µs   6.99µs   136971.    22.2KB    13.7 
#> 2 base         1.01µs   1.07µs   836849.        0B    83.7 
#> 3 cli_vec     30.54µs  31.58µs    30678.     1.7KB     3.07
#> 4 base_vec     8.34µs   8.57µs   112896.      848B     0   
#> 5 cli_txt      6.35µs   6.96µs   138133.        0B    13.8 
#> 6 base_txt     5.43µs   5.51µs   175818.        0B     0
```

## Session info

``` r
sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.5.3 (2026-03-11)
#>  os       Ubuntu 24.04.4 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-04-09
#>  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.10.0     2026-01-26 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-04-09 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.5.3)
#>  desc          1.4.3      2023-12-10 [1] RSPM
#>  digest        0.6.39     2025-11-19 [1] RSPM
#>  evaluate      1.0.5      2025-08-27 [1] RSPM
#>  fansi       * 1.0.7      2025-11-19 [1] RSPM
#>  fastmap       1.2.0      2024-05-15 [1] RSPM
#>  fs            2.0.1      2026-03-24 [1] RSPM
#>  glue          1.8.0      2024-09-30 [1] RSPM
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
#>  vctrs         0.7.2      2026-03-21 [1] RSPM
#>  xfun          0.57       2026-03-20 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.5.3/lib/R/site-library
#>  [3] /opt/R/4.5.3/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
