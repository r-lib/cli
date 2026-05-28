# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x561a57af6028\>
\<environment: 0x561a58596f60\>

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
#> 1 ansi         46.8µs   50.7µs    19094.    99.6KB     18.9
#> 2 plain        47.2µs   50.6µs    19087.        0B     19.8
#> 3 base         11.7µs   12.9µs    74067.    48.6KB     22.2
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
#> 1 ansi         48.9µs   52.5µs    18382.        0B     21.2
#> 2 plain        48.3µs   52.2µs    18523.        0B     23.6
#> 3 base         13.5µs   14.9µs    64998.        0B     19.5
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
#> 1 ansi       112.62µs 120.06µs     8066.   76.15KB     14.6
#> 2 plain       88.82µs  94.33µs    10211.    8.73KB     14.6
#> 3 base         1.86µs   2.01µs   475785.        0B     47.6
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
#> 1 ansi          350µs    374µs     2638.   33.23KB     19.1
#> 2 plain         351µs    376µs     2630.    1.09KB     19.2
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
#>  1 cli_ansi          5.74µs   6.38µs   150674.    9.27KB    30.1 
#>  2 fansi_ansi       31.77µs  35.63µs    27073.    4.18KB    24.4 
#>  3 cli_plain         5.81µs   6.43µs   149317.        0B    29.9 
#>  4 fansi_plain      30.88µs  33.84µs    28130.      688B    16.9 
#>  5 cli_vec_ansi      7.18µs   7.68µs   124641.      448B    12.5 
#>  6 fansi_vec_ansi   41.06µs  43.68µs    21988.    5.02KB     8.80
#>  7 cli_vec_plain     7.71µs   8.23µs   118443.      448B    11.8 
#>  8 fansi_vec_plain  39.18µs  41.59µs    23311.    5.02KB     9.33
#>  9 cli_txt_ansi      5.72µs   6.14µs   157914.        0B    15.8 
#> 10 fansi_txt_ansi   31.02µs  33.39µs    29011.      688B    14.5 
#> 11 cli_txt_plain      6.6µs   7.01µs   138390.        0B    13.8 
#> 12 fansi_txt_plain  38.79µs  42.06µs    23027.    5.02KB     9.21
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
#> 1 cli          57.1µs     59µs    16586.    22.7KB     6.12
#> 2 fansi       119.5µs    127µs     7748.    55.3KB     4.05
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
#>  1 cli_ansi          7.13µs    7.8µs   123895.        0B    12.4 
#>  2 fansi_ansi       92.55µs   98.1µs     9863.   38.84KB     8.20
#>  3 base_ansi       921.08ns 962.06ns   966260.        0B     0   
#>  4 cli_plain          7.1µs   7.78µs   124310.        0B    12.4 
#>  5 fansi_plain      90.86µs  97.79µs     9909.      688B    10.3 
#>  6 base_plain      840.98ns 892.09ns  1031807.        0B     0   
#>  7 cli_vec_ansi     29.53µs  30.55µs    32099.      448B     3.21
#>  8 fansi_vec_ansi  113.48µs 119.27µs     8124.    5.02KB     6.15
#>  9 base_vec_ansi     17.2µs   17.3µs    56672.      448B     0   
#> 10 cli_vec_plain     27.8µs  28.64µs    34170.      448B     3.42
#> 11 fansi_vec_plain  103.1µs 109.66µs     8825.    5.02KB     8.26
#> 12 base_vec_plain   10.16µs  10.24µs    95800.      448B     0   
#> 13 cli_txt_ansi     28.87µs  29.74µs    32854.        0B     3.29
#> 14 fansi_txt_ansi  103.95µs 110.32µs     8707.      688B     8.19
#> 15 base_txt_ansi     16.9µs  16.97µs    57839.        0B     0   
#> 16 cli_txt_plain    27.28µs  28.04µs    34881.        0B     3.49
#> 17 fansi_txt_plain  94.93µs 100.25µs     9684.      688B     8.19
#> 18 base_txt_plain    9.86µs  10.39µs    95391.        0B     9.54
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
#>  1 cli_ansi          8.81µs   9.55µs   101673.        0B    10.2 
#>  2 fansi_ansi       92.76µs  98.53µs     9850.      688B     8.28
#>  3 base_ansi         1.22µs   1.28µs   732619.        0B     0   
#>  4 cli_plain         8.74µs   9.45µs   102933.        0B    20.6 
#>  5 fansi_plain      92.23µs  97.54µs     9923.      688B     8.20
#>  6 base_plain        1.02µs   1.07µs   861983.        0B     0   
#>  7 cli_vec_ansi     34.95µs  35.85µs    27325.      448B     2.73
#>  8 fansi_vec_ansi  115.35µs 121.67µs     7964.    5.02KB     8.25
#>  9 base_vec_ansi    41.09µs  41.34µs    23879.      448B     0   
#> 10 cli_vec_plain    33.11µs  34.09µs    28669.      448B     2.87
#> 11 fansi_vec_plain  106.4µs 111.97µs     8640.    5.02KB     8.26
#> 12 base_vec_plain   21.72µs  22.01µs    44781.      448B     0   
#> 13 cli_txt_ansi     34.48µs  35.36µs    27662.        0B     2.77
#> 14 fansi_txt_ansi  107.73µs 113.71µs     8520.      688B     8.20
#> 15 base_txt_ansi    43.19µs   44.1µs    22387.        0B     0   
#> 16 cli_txt_plain    32.63µs  33.51µs    29230.        0B     2.92
#> 17 fansi_txt_plain  97.12µs 102.95µs     9398.      688B     8.19
#> 18 base_txt_plain   23.67µs  23.89µs    41269.        0B     0
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
#> 1 cli_ansi         7.1µs   7.71µs   125876.        0B    12.6 
#> 2 cli_plain       6.55µs   7.17µs   135365.        0B     0   
#> 3 cli_vec_ansi   31.75µs  33.19µs    29471.      848B     2.95
#> 4 cli_vec_plain  10.57µs  11.26µs    86508.      848B     8.65
#> 5 cli_txt_ansi   30.98µs  32.22µs    30456.        0B     3.05
#> 6 cli_txt_plain   7.45µs   8.06µs   120554.        0B    12.1
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
#>  1 cli_ansi          25.9µs   27.4µs    35449.        0B    17.7 
#>  2 fansi_ansi        28.8µs   31.4µs    30764.    7.24KB    12.3 
#>  3 cli_plain         25.6µs   27.3µs    35369.        0B    14.2 
#>  4 fansi_plain       28.6µs   30.7µs    31525.      688B    12.6 
#>  5 cli_vec_ansi      35.8µs   37.6µs    25846.      848B    12.9 
#>  6 fansi_vec_ansi    55.8µs   58.6µs    16563.    5.41KB     6.18
#>  7 cli_vec_plain     28.3µs   30.1µs    32255.      848B    12.9 
#>  8 fansi_vec_plain   37.8µs   39.7µs    24463.    4.59KB     9.79
#>  9 cli_txt_ansi      34.1µs   35.4µs    27407.        0B    13.7 
#> 10 fansi_txt_ansi      45µs   46.7µs    20811.    5.12KB     8.33
#> 11 cli_txt_plain     26.4µs   27.7µs    35066.        0B    14.0 
#> 12 fansi_txt_plain   29.5µs   31.1µs    31028.      688B    12.4
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
#>  1 cli_ansi        164.43µs 172.69µs     5615.  104.86KB    10.3 
#>  2 fansi_ansi      130.94µs  139.5µs     6923.  106.35KB    10.3 
#>  3 base_ansi         4.07µs   4.52µs   214642.      224B    21.5 
#>  4 cli_plain       163.35µs 170.55µs     5692.    8.09KB    10.3 
#>  5 fansi_plain     129.06µs 137.57µs     7080.    9.62KB    10.4 
#>  6 base_plain        3.57µs   3.94µs   246048.        0B     0   
#>  7 cli_vec_ansi      7.73ms    7.9ms      126.  823.77KB    11.1 
#>  8 fansi_vec_ansi    1.06ms   1.09ms      896.  846.81KB    17.2 
#>  9 base_vec_ansi   156.34µs 162.78µs     5790.    22.7KB     4.12
#> 10 cli_vec_plain     7.68ms   7.92ms      126.  823.77KB    11.5 
#> 11 fansi_vec_plain 989.47µs   1.03ms      901.  845.98KB    17.5 
#> 12 base_vec_plain   107.3µs 111.47µs     8757.      848B     2.01
#> 13 cli_txt_ansi       3.4ms   3.52ms      285.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.56ms   1.58ms      628.   35.05KB     0   
#> 15 base_txt_ansi   137.51µs 146.42µs     6754.   18.47KB     2.02
#> 16 cli_txt_plain     2.46ms   2.49ms      400.    63.6KB     0   
#> 17 fansi_txt_plain 520.62µs 563.54µs     1774.    30.6KB     4.07
#> 18 base_txt_plain   88.62µs   90.8µs    10728.   11.05KB     2.02
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
#>  1 cli_ansi        148.67µs 156.01µs     6234.   33.84KB    12.4 
#>  2 fansi_ansi       55.55µs  59.72µs    16220.   31.42KB    12.5 
#>  3 base_ansi         1.09µs   1.14µs   840261.     4.2KB     0   
#>  4 cli_plain       147.02µs 154.19µs     6304.        0B    12.4 
#>  5 fansi_plain      54.98µs  59.03µs    16421.      872B    12.4 
#>  6 base_plain        1.01µs   1.05µs   882267.        0B     0   
#>  7 cli_vec_ansi    276.96µs 287.54µs     3410.   16.73KB     6.15
#>  8 fansi_vec_ansi  117.09µs 122.15µs     7977.    5.59KB     6.28
#>  9 base_vec_ansi    35.45µs  35.84µs    27534.      848B     0   
#> 10 cli_vec_plain   233.76µs 243.21µs     4010.   16.73KB     8.30
#> 11 fansi_vec_plain 110.29µs 114.67µs     8494.    5.59KB     6.16
#> 12 base_vec_plain   29.99µs  31.04µs    31897.      848B     3.19
#> 13 cli_txt_ansi    158.28µs 165.23µs     5889.        0B    10.3 
#> 14 fansi_txt_ansi    55.1µs  59.48µs    16318.      872B    13.5 
#> 15 base_txt_ansi     1.11µs   1.16µs   831630.        0B     0   
#> 16 cli_txt_plain   147.44µs 153.34µs     6339.        0B    12.4 
#> 17 fansi_txt_plain  54.28µs  56.93µs    17001.      872B    12.4 
#> 18 base_txt_plain    1.03µs   1.07µs   898394.        0B     0
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
#>  1 cli_ansi        418.24µs 444.25µs    2240.     6.18KB    10.3 
#>  2 fansi_ansi       98.28µs  107.1µs    9076.    97.33KB    12.6 
#>  3 base_ansi        39.27µs  41.37µs   23353.         0B     9.34
#>  4 cli_plain       275.88µs 287.65µs    3391.         0B    10.3 
#>  5 fansi_plain      98.59µs 104.94µs    9266.       872B    12.4 
#>  6 base_plain        31.9µs  33.76µs   28622.         0B     8.59
#>  7 cli_vec_ansi     44.57ms  44.87ms      22.3   94.67KB    26.7 
#>  8 fansi_vec_ansi   240.2µs 251.26µs    3822.     7.25KB     4.08
#>  9 base_vec_ansi     2.28ms   2.34ms     427.    48.18KB    12.8 
#> 10 cli_vec_plain    29.08ms   29.3ms      33.9    2.48KB    18.5 
#> 11 fansi_vec_plain 194.85µs 203.44µs    4800.     6.42KB     6.14
#> 12 base_vec_plain    1.66ms   1.72ms     581.     47.4KB    12.8 
#> 13 cli_txt_ansi     27.13ms  27.29ms      36.5    4.27MB     7.30
#> 14 fansi_txt_ansi  230.28µs 239.59µs    4102.     6.77KB     4.05
#> 15 base_txt_ansi     1.27ms    1.3ms     756.   582.06KB    11.2 
#> 16 cli_txt_plain     1.29ms   1.33ms     743.   369.84KB     8.66
#> 17 fansi_txt_plain 180.94µs 189.77µs    5140.     2.51KB     6.14
#> 18 base_txt_plain  852.66µs 892.47µs    1105.   367.31KB    11.1
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
#>  1 cli_ansi          6.67µs   7.31µs   130933.   25.09KB    13.1 
#>  2 fansi_ansi       80.41µs  86.16µs    11004.   28.48KB    10.3 
#>  3 base_ansi         1.03µs   1.09µs   859813.        0B     0   
#>  4 cli_plain         6.56µs   7.31µs   119549.        0B    23.9 
#>  5 fansi_plain      80.05µs  85.99µs    11259.    1.98KB    10.5 
#>  6 base_plain        1.01µs   1.07µs   868882.        0B     0   
#>  7 cli_vec_ansi     27.45µs  28.38µs    34493.     1.7KB     3.45
#>  8 fansi_vec_ansi  118.51µs 123.86µs     7829.    8.86KB     8.32
#>  9 base_vec_ansi     6.02µs   6.29µs   155531.      848B     0   
#> 10 cli_vec_plain    23.48µs   24.6µs    39813.     1.7KB     3.98
#> 11 fansi_vec_plain 113.31µs 118.47µs     8195.    8.86KB     8.33
#> 12 base_vec_plain    5.64µs   5.95µs   164371.      848B     0   
#> 13 cli_txt_ansi      6.67µs    7.3µs   131163.        0B    13.1 
#> 14 fansi_txt_ansi   80.36µs   85.5µs    11324.    1.98KB    12.5 
#> 15 base_txt_ansi     6.48µs   6.55µs   149486.        0B     0   
#> 16 cli_txt_plain     7.45µs      8µs   121068.        0B    12.1 
#> 17 fansi_txt_plain  78.55µs  82.33µs    11749.    1.98KB    12.4 
#> 18 base_txt_plain    4.11µs   4.17µs   233914.        0B     0
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
#>  1 cli_ansi       105.59µs 111.06µs    8302.    11.88KB     8.21
#>  2 base_ansi        1.32µs   1.37µs  703470.         0B     0   
#>  3 cli_plain       84.05µs  87.46µs   11035.     8.73KB     8.20
#>  4 base_plain       1.03µs   1.08µs  885871.         0B     0   
#>  5 cli_vec_ansi     4.13ms   4.23ms     235.   838.77KB    15.7 
#>  6 base_vec_ansi    71.8µs  72.14µs   13691.       848B     0   
#>  7 cli_vec_plain    2.34ms   2.41ms     413.    816.9KB    15.2 
#>  8 base_vec_plain  42.47µs     43µs   22949.       848B     0   
#>  9 cli_txt_ansi    14.38ms  14.47ms      68.9  114.42KB     2.03
#> 10 base_txt_ansi   72.53µs  73.88µs   13354.         0B     0   
#> 11 cli_txt_plain  270.82µs 279.94µs    3473.    18.16KB     4.05
#> 12 base_txt_plain     41µs  42.04µs   23431.         0B     0
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
#>  1 cli_ansi        108.7µs  113.7µs     8525.        0B    12.4 
#>  2 base_ansi        16.7µs   17.8µs    54471.        0B    10.9 
#>  3 cli_plain       107.8µs  113.2µs     8541.        0B    12.4 
#>  4 base_plain       16.6µs   17.6µs    54892.        0B    11.0 
#>  5 cli_vec_ansi    208.6µs  218.1µs     4477.     7.2KB     6.14
#>  6 base_vec_ansi    59.6µs   64.9µs    14989.    1.66KB     2.01
#>  7 cli_vec_plain   195.2µs  205.2µs     4753.     7.2KB     8.26
#>  8 base_vec_plain   52.1µs     58µs    16785.    1.66KB     2.02
#>  9 cli_txt_ansi    181.3µs  187.2µs     5194.        0B     8.20
#> 10 base_txt_ansi    40.9µs   42.3µs    23010.        0B     4.60
#> 11 cli_txt_plain   165.9µs  172.5µs     5640.        0B     8.28
#> 12 base_txt_plain   35.6µs   36.9µs    26351.        0B     5.27
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
#> 1 cli          8.37µs   9.03µs   107133.        0B    10.7 
#> 2 base       881.15ns 932.02ns   998389.        0B     0   
#> 3 cli_vec     23.95µs  24.77µs    39409.      448B     7.88
#> 4 base_vec    11.64µs   11.9µs    82655.      448B     0   
#> 5 cli_txt        24µs  24.73µs    39392.        0B     3.94
#> 6 base_txt    12.63µs   12.7µs    77396.        0B     0
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
#> 1 cli          8.28µs   8.97µs   107585.        0B    10.8 
#> 2 base         1.31µs   1.36µs   684285.        0B    68.4 
#> 3 cli_vec     29.19µs  30.06µs    32559.      448B     3.26
#> 4 base_vec    50.06µs  51.27µs    19285.      448B     0   
#> 5 cli_txt     29.69µs  30.46µs    32122.        0B     3.21
#> 6 base_txt    86.51µs  87.58µs    11229.        0B     0
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
#> 1 cli          8.84µs   9.52µs   101334.        0B    20.3 
#> 2 base       872.07ns 921.08ns  1021794.        0B     0   
#> 3 cli_vec     19.74µs  20.72µs    47101.      448B     4.71
#> 4 base_vec    11.61µs  11.87µs    82874.      448B     0   
#> 5 cli_txt     20.56µs   21.3µs    45775.        0B     9.16
#> 6 base_txt    12.61µs   12.7µs    77377.        0B     0
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
#> 1 cli          6.42µs   7.03µs   137563.    22.2KB    13.8 
#> 2 base         1.06µs   1.12µs   810742.        0B    81.1 
#> 3 cli_vec     30.52µs   31.4µs    31230.     1.7KB     3.12
#> 4 base_vec     8.36µs   8.67µs   112922.      848B     0   
#> 5 cli_txt       6.3µs    6.9µs   139853.        0B    14.0 
#> 6 base_txt     5.71µs   5.79µs   168744.        0B     0
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
#>  date     2026-05-28
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-28 [1] local
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
