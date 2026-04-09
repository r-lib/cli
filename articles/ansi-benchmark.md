# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5623313fd8d0\>
\<environment: 0x562331eb2da0\>

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
#> 1 ansi         38.5µs   42.2µs    23176.    99.2KB     23.2
#> 2 plain        37.8µs   41.9µs    23277.        0B     23.3
#> 3 base         10.9µs   12.2µs    79411.    48.4KB     23.8
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
#> 1 ansi         40.4µs   44.3µs    21992.        0B     26.4
#> 2 plain        40.2µs   44.1µs    22145.        0B     24.4
#> 3 base         12.7µs   14.3µs    68286.        0B     20.5
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
#> 1 ansi         93.7µs 101.43µs     9623.   75.01KB     16.9
#> 2 plain       72.58µs  78.02µs    12435.    8.73KB     16.9
#> 3 base         1.82µs   2.04µs   467640.        0B     46.8
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
#> 1 ansi          281µs    303µs     3276.   33.16KB     21.5
#> 2 plain         280µs    304µs     3266.    1.09KB     23.7
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
#>  1 cli_ansi           5.6µs   6.36µs   151243.    9.19KB     30.3
#>  2 fansi_ansi       26.02µs  29.33µs    33242.    4.18KB     26.6
#>  3 cli_plain         5.51µs   5.99µs   162268.        0B     32.5
#>  4 fansi_plain      26.04µs     28µs    34790.      688B     27.9
#>  5 cli_vec_ansi      6.85µs   7.42µs   131536.      448B     26.3
#>  6 fansi_vec_ansi   35.18µs  37.37µs    26116.    5.02KB     20.9
#>  7 cli_vec_plain     7.49µs    8.1µs   120218.      448B     24.0
#>  8 fansi_vec_plain  34.14µs  36.53µs    26768.    5.02KB     21.4
#>  9 cli_txt_ansi      5.46µs   6.01µs   157010.        0B     31.4
#> 10 fansi_txt_ansi   26.54µs  28.42µs    34327.      688B     27.5
#> 11 cli_txt_plain     6.43µs   6.99µs   139269.        0B     27.9
#> 12 fansi_txt_plain  34.32µs  36.47µs    26724.    5.02KB     21.4
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
#> 1 cli          56.1µs     58µs    16997.    22.6KB     8.18
#> 2 fansi       110.2µs    114µs     8653.    55.3KB    10.3
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
#>  1 cli_ansi          6.47µs   7.12µs   135386.        0B    27.1 
#>  2 fansi_ansi       70.59µs  75.86µs    12719.   38.83KB    21.2 
#>  3 base_ansi       842.03ns 922.01ns  1013375.        0B     0   
#>  4 cli_plain         6.48µs   7.11µs   136440.        0B    27.3 
#>  5 fansi_plain      71.07µs  75.87µs    12806.      688B    21.2 
#>  6 base_plain      781.03ns 861.12ns  1085174.        0B     0   
#>  7 cli_vec_ansi     27.81µs  29.26µs    33626.      448B     6.73
#>  8 fansi_vec_ansi   90.82µs  96.76µs    10063.    5.02KB    16.9 
#>  9 base_vec_ansi    14.66µs   14.8µs    66477.      448B     0   
#> 10 cli_vec_plain    26.37µs  27.39µs    35852.      448B     7.17
#> 11 fansi_vec_plain  81.61µs  87.67µs    11090.    5.02KB    17.1 
#> 12 base_vec_plain    8.68µs   8.78µs   111254.      448B     0   
#> 13 cli_txt_ansi     27.89µs  29.12µs    33851.        0B     6.77
#> 14 fansi_txt_ansi   84.75µs  90.26µs    10769.      688B    19.0 
#> 15 base_txt_ansi    14.47µs  14.56µs    67552.        0B     0   
#> 16 cli_txt_plain    25.16µs  28.06µs    35127.        0B     7.03
#> 17 fansi_txt_plain  74.06µs  79.08µs    12253.      688B    20.4 
#> 18 base_txt_plain     8.5µs   8.58µs   114276.        0B     0
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
#>  1 cli_ansi          7.87µs   8.55µs   114098.        0B    34.2 
#>  2 fansi_ansi       71.65µs  75.47µs    12849.      688B    21.2 
#>  3 base_ansi         1.17µs   1.26µs   749634.        0B     0   
#>  4 cli_plain          7.9µs   8.61µs   113282.        0B    22.7 
#>  5 fansi_plain      71.23µs  76.14µs    12745.      688B    21.4 
#>  6 base_plain      962.06ns   1.06µs   866738.        0B     0   
#>  7 cli_vec_ansi     33.96µs  35.32µs    27881.      448B     5.58
#>  8 fansi_vec_ansi   96.17µs 101.24µs     9615.    5.02KB    17.0 
#>  9 base_vec_ansi    41.55µs  41.95µs    23539.      448B     0   
#> 10 cli_vec_plain    32.12µs  33.11µs    29716.      448B     5.94
#> 11 fansi_vec_plain  85.97µs  91.17µs    10629.    5.02KB    19.3 
#> 12 base_vec_plain   21.95µs  22.17µs    44425.      448B     0   
#> 13 cli_txt_ansi     34.52µs  35.46µs    27753.        0B     5.55
#> 14 fansi_txt_ansi   87.91µs  93.33µs    10417.      688B    16.8 
#> 15 base_txt_ansi    43.55µs  43.88µs    22368.        0B     2.24
#> 16 cli_txt_plain    32.08µs  32.97µs    29833.        0B     5.97
#> 17 fansi_txt_plain  78.01µs  83.17µs    11702.      688B    19.1 
#> 18 base_txt_plain    23.1µs  23.28µs    42267.        0B     0
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
#> 1 cli_ansi        6.33µs   6.94µs   139588.        0B    14.0 
#> 2 cli_plain       5.99µs   6.55µs   147766.        0B    29.6 
#> 3 cli_vec_ansi    30.6µs  31.86µs    30775.      848B     6.16
#> 4 cli_vec_plain  10.03µs  10.74µs    91079.      848B     9.11
#> 5 cli_txt_ansi   30.58µs  31.68µs    29376.        0B     5.88
#> 6 cli_txt_plain   6.97µs   7.72µs   124469.        0B    12.4
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
#>  1 cli_ansi          24.4µs   26.3µs    36893.        0B     29.5
#>  2 fansi_ansi          25µs   27.1µs    35598.    7.24KB     28.5
#>  3 cli_plain           24µs   25.9µs    37488.        0B     30.0
#>  4 fansi_plain       24.6µs   26.7µs    36237.      688B     25.4
#>  5 cli_vec_ansi      33.9µs   36.2µs    26909.      848B     21.5
#>  6 fansi_vec_ansi    50.1µs   52.8µs    18508.    5.41KB     16.9
#>  7 cli_vec_plain     26.5µs   28.4µs    33686.      848B     23.6
#>  8 fansi_vec_plain   33.2µs   35.4µs    27416.    4.59KB     22.0
#>  9 cli_txt_ansi        33µs   34.9µs    27914.        0B     22.3
#> 10 fansi_txt_ansi    41.1µs   43.6µs    22437.    5.12KB     18.0
#> 11 cli_txt_plain     24.7µs   26.6µs    36621.        0B     29.3
#> 12 fansi_txt_plain   25.6µs   27.7µs    35247.      688B     24.7
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
#>  1 cli_ansi         132.3µs 141.93µs     6879.  104.31KB    23.5 
#>  2 fansi_ansi      105.85µs 114.02µs     8585.  106.35KB    23.8 
#>  3 base_ansi         4.01µs   4.46µs   219840.      224B     0   
#>  4 cli_plain       130.49µs 140.01µs     6947.    8.09KB    23.7 
#>  5 fansi_plain     104.87µs 112.26µs     8683.    9.62KB    23.8 
#>  6 base_plain        3.45µs   3.68µs   262195.        0B     0   
#>  7 cli_vec_ansi      6.64ms   6.86ms      145.  823.77KB    32.2 
#>  8 fansi_vec_ansi    1.04ms   1.09ms      883.  846.81KB    17.6 
#>  9 base_vec_ansi   151.28µs 157.13µs     6215.    22.7KB     2.04
#> 10 cli_vec_plain     6.57ms   6.69ms      148.  823.77KB    32.9 
#> 11 fansi_vec_plain 959.72µs      1ms      993.  845.98KB    17.6 
#> 12 base_vec_plain  102.84µs 107.42µs     9093.      848B     2.02
#> 13 cli_txt_ansi      3.22ms   3.25ms      306.    63.6KB     0   
#> 14 fansi_txt_ansi    1.59ms   1.61ms      617.   35.05KB     2.02
#> 15 base_txt_ansi   138.72µs 150.59µs     6583.   18.47KB     2.03
#> 16 cli_txt_plain     2.35ms   2.38ms      419.    63.6KB     0   
#> 17 fansi_txt_plain 523.24µs 564.57µs     1741.    30.6KB     2.02
#> 18 base_txt_plain   89.68µs   92.6µs    10641.   11.05KB     2.02
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
#>  1 cli_ansi        125.34µs 133.25µs     7387.   33.81KB    14.6 
#>  2 fansi_ansi       47.79µs  51.92µs    18906.   31.42KB    15.0 
#>  3 base_ansi         1.06µs   1.15µs   829131.     4.2KB     0   
#>  4 cli_plain       125.72µs 133.44µs     7373.        0B    14.6 
#>  5 fansi_plain      47.75µs  51.87µs    18943.      872B    14.7 
#>  6 base_plain      981.03ns   1.06µs   876723.        0B     0   
#>  7 cli_vec_ansi    248.94µs 258.72µs     3809.   16.73KB     8.29
#>  8 fansi_vec_ansi  113.48µs 118.99µs     8110.    5.59KB     6.18
#>  9 base_vec_ansi    36.26µs  36.62µs    26876.      848B     0   
#> 10 cli_vec_plain   211.29µs 220.01µs     4448.   16.73KB    10.4 
#> 11 fansi_vec_plain 103.12µs 107.59µs     9133.    5.59KB     6.17
#> 12 base_vec_plain    30.2µs  30.54µs    32305.      848B     0   
#> 13 cli_txt_ansi    135.66µs 143.75µs     6816.        0B    14.8 
#> 14 fansi_txt_ansi    48.2µs  52.74µs    17629.      872B    12.5 
#> 15 base_txt_ansi     1.09µs   1.19µs   786284.        0B     0   
#> 16 cli_txt_plain   127.04µs 137.85µs     6638.        0B    14.6 
#> 17 fansi_txt_plain  47.69µs  52.14µs    18790.      872B    14.7 
#> 18 base_txt_plain  991.98ns   1.09µs   871552.        0B     0
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
#>  1 cli_ansi        332.13µs 355.26µs    2782.         0B    12.5 
#>  2 fansi_ansi       85.11µs  92.65µs   10570.    97.32KB    12.5 
#>  3 base_ansi        32.12µs  34.72µs   28130.         0B    14.1 
#>  4 cli_plain       219.51µs 234.72µs    4151.         0B    14.9 
#>  5 fansi_plain      85.21µs  92.14µs   10521.       872B    12.5 
#>  6 base_plain       26.42µs  28.42µs   34319.         0B    13.7 
#>  7 cli_vec_ansi     35.68ms  36.01ms      27.7    2.48KB    23.7 
#>  8 fansi_vec_ansi  228.94µs 236.75µs    4164.     7.25KB     6.14
#>  9 base_vec_ansi     2.16ms   2.22ms     449.    48.18KB    12.8 
#> 10 cli_vec_plain    22.42ms  22.85ms      41.8    2.48KB    20.9 
#> 11 fansi_vec_plain 182.24µs 189.01µs    5210.     6.42KB     8.25
#> 12 base_vec_plain    1.57ms   1.64ms     606.     47.4KB    12.9 
#> 13 cli_txt_ansi     23.58ms  23.76ms      42.0  507.59KB     7.00
#> 14 fansi_txt_ansi  231.56µs  241.2µs    4073.     6.77KB     4.06
#> 15 base_txt_ansi     1.25ms   1.31ms     756.   582.06KB    11.2 
#> 16 cli_txt_plain     1.24ms   1.28ms     775.   369.84KB     8.73
#> 17 fansi_txt_plain 179.18µs 187.44µs    5249.     2.51KB     8.31
#> 18 base_txt_plain  849.29µs 893.84µs    1099.   367.31KB     8.72
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
#>  1 cli_ansi          6.57µs   7.35µs   131368.   24.81KB    13.1 
#>  2 fansi_ansi       69.01µs  74.85µs    13068.   28.48KB    12.5 
#>  3 base_ansi       961.12ns   1.09µs   832779.        0B     0   
#>  4 cli_plain         6.51µs   7.33µs   130329.        0B    26.1 
#>  5 fansi_plain      67.63µs  74.18µs    13202.    1.98KB    12.7 
#>  6 base_plain      932.14ns   1.04µs   879742.        0B     0   
#>  7 cli_vec_ansi     26.49µs  27.78µs    34728.     1.7KB     3.47
#>  8 fansi_vec_ansi  104.37µs 110.53µs     8850.    8.86KB     8.36
#>  9 base_vec_ansi     6.03µs   6.32µs   153419.      848B    15.3 
#> 10 cli_vec_plain    23.09µs  24.28µs    40455.     1.7KB     4.05
#> 11 fansi_vec_plain  98.99µs 104.87µs     9345.    8.86KB     8.37
#> 12 base_vec_plain     5.7µs    5.9µs   165465.      848B     0   
#> 13 cli_txt_ansi      6.57µs   7.37µs   129380.        0B    25.9 
#> 14 fansi_txt_ansi   69.44µs  74.81µs    13080.    1.98KB    12.6 
#> 15 base_txt_ansi     5.55µs   5.68µs   171181.        0B     0   
#> 16 cli_txt_plain     7.51µs   8.28µs   116743.        0B    11.7 
#> 17 fansi_txt_plain  69.04µs  74.28µs    13137.    1.98KB    12.5 
#> 18 base_txt_plain    3.56µs   3.66µs   262536.        0B    26.3
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
#>  1 cli_ansi        87.44µs  92.88µs   10445.    11.85KB    10.3 
#>  2 base_ansi        1.25µs   1.34µs  711621.         0B     0   
#>  3 cli_plain       67.79µs  72.35µs   13406.     8.73KB    10.3 
#>  4 base_plain        951ns   1.05µs  900298.         0B     0   
#>  5 cli_vec_ansi     3.99ms   4.15ms     240.   838.77KB    15.9 
#>  6 base_vec_ansi   71.22µs  71.67µs   13767.       848B     0   
#>  7 cli_vec_plain    2.24ms   2.33ms     428.    816.9KB    15.3 
#>  8 base_vec_plain  42.36µs   42.8µs   22921.       848B     0   
#>  9 cli_txt_ansi    13.77ms  13.86ms      71.9  114.42KB     4.23
#> 10 base_txt_ansi   69.97µs  71.26µs   13504.         0B     0   
#> 11 cli_txt_plain  244.05µs 255.84µs    3548.    18.16KB     4.06
#> 12 base_txt_plain  40.71µs  41.19µs   23943.         0B     0
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
#>  1 cli_ansi         88.2µs     94µs    10409.        0B    16.2 
#>  2 base_ansi          15µs     16µs    61017.        0B    12.2 
#>  3 cli_plain          87µs   91.1µs    10709.        0B    14.5 
#>  4 base_plain       14.9µs   15.9µs    61556.        0B    12.3 
#>  5 cli_vec_ansi    174.1µs  183.6µs     5352.     7.2KB     8.25
#>  6 base_vec_ansi    52.1µs   58.4µs    17001.    1.66KB     4.06
#>  7 cli_vec_plain   158.6µs  170.6µs     5760.     7.2KB     8.36
#>  8 base_vec_plain   45.9µs   52.6µs    18846.    1.66KB     2.02
#>  9 cli_txt_ansi    154.3µs    161µs     6112.        0B     8.18
#> 10 base_txt_ansi    37.8µs   39.2µs    25073.        0B     5.02
#> 11 cli_txt_plain   138.7µs  144.9µs     6656.        0B    10.3 
#> 12 base_txt_plain   32.5µs   34.1µs    28883.        0B     5.78
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
#> 1 cli           7.7µs   8.49µs   114537.        0B    11.5 
#> 2 base          812ns 932.14ns   968347.        0B     0   
#> 3 cli_vec      23.1µs  24.19µs    40633.      448B     4.06
#> 4 base_vec       12µs   12.3µs    79825.      448B     7.98
#> 5 cli_txt      23.5µs  24.64µs    39006.        0B     3.90
#> 6 base_txt     12.9µs  13.08µs    74882.        0B     0
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
#> 1 cli          7.59µs   8.46µs   114729.        0B    11.5 
#> 2 base         1.29µs   1.41µs   660025.        0B    66.0 
#> 3 cli_vec     29.52µs  30.79µs    31800.      448B     3.18
#> 4 base_vec    54.03µs   54.6µs    18080.      448B     0   
#> 5 cli_txt     29.91µs  31.01µs    31640.        0B     3.16
#> 6 base_txt    88.79µs  89.58µs    11027.        0B     0
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
#> 1 cli          8.16µs   8.96µs   107836.        0B    21.6 
#> 2 base       810.95ns 930.86ns   979868.        0B     0   
#> 3 cli_vec     19.65µs  20.69µs    47448.      448B     4.75
#> 4 base_vec    12.11µs  12.35µs    79638.      448B     0   
#> 5 cli_txt     20.34µs  21.23µs    46228.        0B     9.25
#> 6 base_txt    12.92µs  13.08µs    75080.        0B     0
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
#> 1 cli          6.17µs   6.91µs   139955.    22.1KB    14.0 
#> 2 base       991.98ns   1.08µs   843857.        0B    84.4 
#> 3 cli_vec     30.94µs  32.06µs    30683.     1.7KB     3.07
#> 4 base_vec     8.72µs   8.91µs   109925.      848B     0   
#> 5 cli_txt      6.16µs   6.89µs   140681.        0B    14.1 
#> 6 base_txt     5.05µs   5.19µs   186958.        0B    18.7
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
#>  package     * version date (UTC) lib source
#>  bench         1.1.4   2025-01-16 [1] RSPM
#>  bslib         0.10.0  2026-01-26 [1] RSPM
#>  cachem        1.1.0   2024-05-16 [1] RSPM
#>  cli         * 3.6.6   2026-04-09 [1] local
#>  codetools     0.2-20  2024-03-31 [3] CRAN (R 4.5.3)
#>  desc          1.4.3   2023-12-10 [1] RSPM
#>  digest        0.6.39  2025-11-19 [1] RSPM
#>  evaluate      1.0.5   2025-08-27 [1] RSPM
#>  fansi       * 1.0.7   2025-11-19 [1] RSPM
#>  fastmap       1.2.0   2024-05-15 [1] RSPM
#>  fs            2.0.1   2026-03-24 [1] RSPM
#>  glue          1.8.0   2024-09-30 [1] RSPM
#>  htmltools     0.5.9   2025-12-04 [1] RSPM
#>  htmlwidgets   1.6.4   2023-12-06 [1] RSPM
#>  jquerylib     0.1.4   2021-04-26 [1] RSPM
#>  jsonlite      2.0.0   2025-03-27 [1] RSPM
#>  knitr         1.51    2025-12-20 [1] RSPM
#>  lifecycle     1.0.5   2026-01-08 [1] RSPM
#>  magrittr      2.0.5   2026-04-04 [1] RSPM
#>  pillar        1.11.1  2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3   2019-09-22 [1] RSPM
#>  pkgdown       2.2.0   2025-11-06 [1] any (@2.2.0)
#>  profmem       0.7.0   2025-05-02 [1] RSPM
#>  R6            2.6.1   2025-02-15 [1] RSPM
#>  ragg          1.5.2   2026-03-23 [1] RSPM
#>  rlang         1.2.0   2026-04-06 [1] RSPM
#>  rmarkdown     2.31    2026-03-26 [1] RSPM
#>  sass          0.4.10  2025-04-11 [1] RSPM
#>  sessioninfo   1.2.3   2025-02-05 [1] any (@1.2.3)
#>  systemfonts   1.3.2   2026-03-05 [1] RSPM
#>  textshaping   1.0.5   2026-03-06 [1] RSPM
#>  tibble        3.3.1   2026-01-11 [1] RSPM
#>  utf8          1.2.6   2025-06-08 [1] RSPM
#>  vctrs         0.7.2   2026-03-21 [1] RSPM
#>  xfun          0.57    2026-03-20 [1] RSPM
#>  yaml          2.3.12  2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.5.3/lib/R/site-library
#>  [3] /opt/R/4.5.3/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
