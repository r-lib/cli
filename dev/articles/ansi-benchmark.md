# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5642a8a1fba8\>
\<environment: 0x5642a95724c8\>

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
#> 1 ansi         38.9µs   42.7µs    22888.    99.3KB     22.9
#> 2 plain        38.3µs   42.4µs    23002.        0B     23.0
#> 3 base         10.8µs   12.3µs    78556.    48.4KB     23.6
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
#> 1 ansi         40.5µs   44.6µs    21807.        0B     26.2
#> 2 plain        39.4µs   44.2µs    22082.        0B     24.3
#> 3 base         12.7µs   14.3µs    67979.        0B     20.4
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
#> 1 ansi        91.64µs  100.5µs     9707.   75.07KB     17.0
#> 2 plain       71.39µs  76.89µs    12603.    8.73KB     17.0
#> 3 base         1.83µs   2.03µs   463299.        0B     46.3
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
#> 1 ansi          282µs    305µs     3237.   33.17KB     21.6
#> 2 plain         284µs    309µs     2852.    1.09KB     21.6
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
#>  1 cli_ansi          5.53µs   6.32µs   151794.     9.2KB     30.4
#>  2 fansi_ansi       27.67µs  31.77µs    30799.    4.18KB     24.7
#>  3 cli_plain         5.55µs   6.08µs   159860.        0B     32.0
#>  4 fansi_plain      27.86µs  29.71µs    32762.      688B     26.2
#>  5 cli_vec_ansi      6.89µs   7.51µs   129395.      448B     25.9
#>  6 fansi_vec_ansi   36.59µs  39.08µs    24950.    5.02KB     20.0
#>  7 cli_vec_plain     7.62µs   8.28µs   117013.      448B     23.4
#>  8 fansi_vec_plain  35.75µs  38.24µs    25529.    5.02KB     20.4
#>  9 cli_txt_ansi      5.51µs   6.08µs   159986.        0B     32.0
#> 10 fansi_txt_ansi   27.86µs  29.89µs    32632.      688B     26.1
#> 11 cli_txt_plain     6.44µs   7.04µs   138190.        0B     27.6
#> 12 fansi_txt_plain  35.69µs  38.15µs    25315.    5.02KB     20.3
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
#> 1 cli          56.4µs   58.4µs    16823.    22.7KB    10.3 
#> 2 fansi       110.6µs  114.2µs     8532.    55.3KB     8.23
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
#>  1 cli_ansi          6.48µs    7.1µs   135873.        0B    27.2 
#>  2 fansi_ansi       74.44µs  79.51µs    12190.   38.83KB    21.5 
#>  3 base_ansi       840.98ns 940.99ns   990750.        0B     0   
#>  4 cli_plain         6.41µs   7.11µs   130265.        0B    26.1 
#>  5 fansi_plain      74.47µs  79.56µs    12239.      688B    19.1 
#>  6 base_plain      791.04ns 871.02ns  1041944.        0B     0   
#>  7 cli_vec_ansi     29.18µs  30.21µs    32532.      448B     6.51
#>  8 fansi_vec_ansi   95.11µs 101.06µs     9610.    5.02KB    17.0 
#>  9 base_vec_ansi     14.6µs  14.76µs    66624.      448B     0   
#> 10 cli_vec_plain    26.44µs  28.61µs    34503.      448B     6.90
#> 11 fansi_vec_plain  85.39µs  90.98µs    10658.    5.02KB    17.1 
#> 12 base_vec_plain     8.7µs    8.8µs   111004.      448B     0   
#> 13 cli_txt_ansi     28.75µs  29.75µs    32983.        0B     6.60
#> 14 fansi_txt_ansi   86.84µs  92.93µs    10480.      688B    16.9 
#> 15 base_txt_ansi    14.47µs  14.56µs    67330.        0B     0   
#> 16 cli_txt_plain    25.91µs  26.72µs    36789.        0B     7.36
#> 17 fansi_txt_plain  77.38µs  82.66µs    11751.      688B    19.1 
#> 18 base_txt_plain    8.47µs    8.6µs   113351.        0B     0
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
#>  1 cli_ansi          7.95µs   8.61µs   112739.        0B    22.6 
#>  2 fansi_ansi       73.96µs  78.15µs    12323.      688B    21.3 
#>  3 base_ansi         1.19µs   1.28µs   736865.        0B     0   
#>  4 cli_plain         7.97µs   8.62µs   112715.        0B    22.5 
#>  5 fansi_plain      74.03µs  78.44µs    12366.      688B    21.4 
#>  6 base_plain      981.03ns   1.07µs   868528.        0B     0   
#>  7 cli_vec_ansi     33.86µs  34.88µs    28215.      448B     5.64
#>  8 fansi_vec_ansi   98.88µs 104.61µs     9276.    5.02KB    14.8 
#>  9 base_vec_ansi    41.59µs  42.01µs    23489.      448B     2.35
#> 10 cli_vec_plain    32.08µs  33.15µs    29634.      448B     5.93
#> 11 fansi_vec_plain  88.71µs  94.16µs    10306.    5.02KB    17.1 
#> 12 base_vec_plain   21.98µs  22.19µs    44341.      448B     0   
#> 13 cli_txt_ansi     34.51µs  35.48µs    27672.        0B     8.30
#> 14 fansi_txt_ansi   90.42µs  95.54µs    10205.      688B    16.8 
#> 15 base_txt_ansi     43.8µs  44.17µs    22362.        0B     0   
#> 16 cli_txt_plain     32.2µs  33.15µs    29665.        0B     5.93
#> 17 fansi_txt_plain  80.02µs  85.14µs    11422.      688B    19.1 
#> 18 base_txt_plain   23.12µs  23.27µs    42334.        0B     0
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
#> 1 cli_ansi        6.56µs   7.13µs   136001.        0B    13.6 
#> 2 cli_plain       5.98µs   6.66µs   142609.        0B    28.5 
#> 3 cli_vec_ansi   30.97µs  31.84µs    30887.      848B     3.09
#> 4 cli_vec_plain  10.16µs  10.84µs    90078.      848B    18.0 
#> 5 cli_txt_ansi   30.14µs  31.36µs    31084.        0B     6.22
#> 6 cli_txt_plain   6.95µs   7.55µs   128748.        0B    12.9
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
#>  1 cli_ansi          24.5µs   26.3µs    37015.        0B     29.6
#>  2 fansi_ansi        25.3µs   27.4µs    35279.    7.24KB     28.2
#>  3 cli_plain         24.1µs   26.1µs    37170.        0B     29.8
#>  4 fansi_plain       24.8µs   27.1µs    35711.      688B     25.0
#>  5 cli_vec_ansi        34µs   36.1µs    27008.      848B     21.6
#>  6 fansi_vec_ansi    50.4µs   53.1µs    18388.    5.41KB     14.9
#>  7 cli_vec_plain     26.9µs   28.8µs    33845.      848B     27.1
#>  8 fansi_vec_plain   33.9µs   36.1µs    27122.    4.59KB     21.7
#>  9 cli_txt_ansi      33.2µs     35µs    27926.        0B     22.4
#> 10 fansi_txt_ansi    41.9µs     44µs    22221.    5.12KB     15.6
#> 11 cli_txt_plain       25µs   26.8µs    36256.        0B     29.0
#> 12 fansi_txt_plain   26.2µs   28.4µs    34343.      688B     27.5
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
#>  1 cli_ansi        131.51µs 140.31µs     6892.  104.34KB    23.6 
#>  2 fansi_ansi      106.75µs 114.51µs     8519.  106.35KB    24.1 
#>  3 base_ansi         3.98µs   4.34µs   224316.      224B     0   
#>  4 cli_plain       129.44µs 139.61µs     6928.    8.09KB    23.6 
#>  5 fansi_plain     105.26µs 112.82µs     8637.    9.62KB    23.9 
#>  6 base_plain        3.48µs   3.73µs   258684.        0B     0   
#>  7 cli_vec_ansi       6.5ms   6.71ms      149.  823.77KB    31.3 
#>  8 fansi_vec_ansi    1.02ms    1.1ms      873.  846.81KB    19.8 
#>  9 base_vec_ansi   151.34µs 160.79µs     6091.    22.7KB     2.05
#> 10 cli_vec_plain     6.43ms   6.71ms      147.  823.77KB    31.5 
#> 11 fansi_vec_plain 966.09µs   1.02ms      959.  845.98KB    18.7 
#> 12 base_vec_plain  101.84µs 106.95µs     9205.      848B     4.06
#> 13 cli_txt_ansi       3.3ms   3.43ms      292.    63.6KB     0   
#> 14 fansi_txt_ansi    1.59ms   1.62ms      612.   35.05KB     2.02
#> 15 base_txt_ansi   138.78µs 150.44µs     6600.   18.47KB     2.03
#> 16 cli_txt_plain     2.44ms   2.49ms      401.    63.6KB     0   
#> 17 fansi_txt_plain 526.85µs 561.85µs     1780.    30.6KB     6.19
#> 18 base_txt_plain   90.12µs  92.93µs    10484.   11.05KB     2.02
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
#>  1 cli_ansi        125.71µs 133.76µs     7317.   33.84KB    28.6 
#>  2 fansi_ansi       47.56µs  51.53µs    18968.   31.42KB    25.7 
#>  3 base_ansi         1.06µs   1.14µs   822647.     4.2KB     0   
#>  4 cli_plain       124.54µs 133.51µs     7357.        0B    25.7 
#>  5 fansi_plain      47.61µs  51.34µs    18979.      872B    25.8 
#>  6 base_plain      981.03ns   1.06µs   863386.        0B    86.3 
#>  7 cli_vec_ansi     248.7µs 260.96µs     3780.   16.73KB    12.6 
#>  8 fansi_vec_ansi  110.67µs 117.57µs     8262.    5.59KB    12.6 
#>  9 base_vec_ansi    36.49µs   36.8µs    26763.      848B     2.68
#> 10 cli_vec_plain   211.73µs 221.62µs     4418.   16.73KB    14.8 
#> 11 fansi_vec_plain 103.06µs 108.12µs     9049.    5.59KB    14.8 
#> 12 base_vec_plain   30.29µs  30.57µs    32243.      848B     0   
#> 13 cli_txt_ansi    134.66µs 143.63µs     6826.        0B    25.8 
#> 14 fansi_txt_ansi   47.22µs  51.56µs    18848.      872B    25.9 
#> 15 base_txt_ansi     1.09µs   1.17µs   805515.        0B     0   
#> 16 cli_txt_plain   126.26µs 135.12µs     7273.        0B    25.7 
#> 17 fansi_txt_plain  46.94µs  49.71µs    19612.      872B    28.6 
#> 18 base_txt_plain       1µs   1.08µs   879674.        0B     0
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
#>  1 cli_ansi        331.95µs 356.77µs    2756.         0B    23.9 
#>  2 fansi_ansi       85.33µs  92.48µs   10402.    97.32KB    23.5 
#>  3 base_ansi        32.29µs  34.77µs   27489.         0B    24.8 
#>  4 cli_plain        215.6µs 233.05µs    4158.         0B    23.5 
#>  5 fansi_plain      85.17µs  91.94µs   10418.       872B    23.6 
#>  6 base_plain       25.99µs   28.2µs   33967.         0B    23.8 
#>  7 cli_vec_ansi     35.77ms  35.77ms      28.0    2.48KB   336.  
#>  8 fansi_vec_ansi  231.11µs 242.08µs    4032.     7.25KB    10.4 
#>  9 base_vec_ansi     2.21ms    2.3ms     429.    48.18KB    25.3 
#> 10 cli_vec_plain    23.36ms  23.43ms      42.4    2.48KB    51.8 
#> 11 fansi_vec_plain 184.69µs  194.6µs    4994.     6.42KB    14.7 
#> 12 base_vec_plain    1.58ms   1.66ms     593.     47.4KB    18.3 
#> 13 cli_txt_ansi     23.54ms  23.86ms      41.7  507.59KB     6.96
#> 14 fansi_txt_ansi  222.77µs 232.66µs    4255.     6.77KB     4.06
#> 15 base_txt_ansi     1.27ms   1.32ms     754.   582.06KB    11.3 
#> 16 cli_txt_plain     1.23ms   1.28ms     768.   369.84KB     8.70
#> 17 fansi_txt_plain 172.37µs 180.68µs    5415.     2.51KB     8.31
#> 18 base_txt_plain  852.22µs  908.8µs    1087.   367.31KB     8.87
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
#>  1 cli_ansi          6.54µs   7.27µs   132781.   24.83KB    13.3 
#>  2 fansi_ansi       68.66µs  74.93µs    13058.   28.48KB    12.6 
#>  3 base_ansi       990.93ns   1.08µs   852711.        0B     0   
#>  4 cli_plain         6.56µs    7.3µs   132796.        0B    13.3 
#>  5 fansi_plain      69.05µs  75.06µs    13025.    1.98KB    12.6 
#>  6 base_plain         951ns   1.05µs   860730.        0B    86.1 
#>  7 cli_vec_ansi     26.42µs   27.7µs    35467.     1.7KB     3.55
#>  8 fansi_vec_ansi  104.52µs 110.95µs     8754.    8.86KB     8.40
#>  9 base_vec_ansi      6.1µs   6.69µs   147541.      848B     0   
#> 10 cli_vec_plain    23.27µs  24.37µs    40135.     1.7KB     4.01
#> 11 fansi_vec_plain  99.41µs 105.34µs     9279.    8.86KB    10.6 
#> 12 base_vec_plain    5.64µs   6.21µs   160451.      848B     0   
#> 13 cli_txt_ansi       6.5µs   7.24µs   133684.        0B    13.4 
#> 14 fansi_txt_ansi    68.9µs  74.67µs    13091.    1.98KB    12.6 
#> 15 base_txt_ansi     5.58µs   5.69µs   171331.        0B     0   
#> 16 cli_txt_plain     7.46µs   8.18µs   118086.        0B    23.6 
#> 17 fansi_txt_plain  68.54µs  74.92µs    13051.    1.98KB    12.7 
#> 18 base_txt_plain    3.58µs   3.67µs   263567.        0B     0
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
#>  1 cli_ansi        84.14µs  91.11µs   10709.    11.88KB    10.4 
#>  2 base_ansi        1.25µs   1.34µs  720556.         0B     0   
#>  3 cli_plain       67.01µs  71.62µs   13601.     8.73KB    10.4 
#>  4 base_plain     961.01ns   1.04µs  923943.         0B     0   
#>  5 cli_vec_ansi     4.01ms   4.26ms     234.   838.77KB    13.1 
#>  6 base_vec_ansi   71.39µs   72.9µs   13476.       848B     2.02
#>  7 cli_vec_plain    2.24ms   2.33ms     430.    816.9KB    15.2 
#>  8 base_vec_plain   42.5µs  43.42µs   22768.       848B     0   
#>  9 cli_txt_ansi    13.81ms  13.92ms      71.8  114.42KB     2.05
#> 10 base_txt_ansi   70.75µs  71.27µs   13859.         0B     0   
#> 11 cli_txt_plain  242.73µs    252µs    3880.    18.16KB     4.06
#> 12 base_txt_plain  40.61µs  40.83µs   24188.         0B     0
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
#>  1 cli_ansi         87.3µs   93.8µs    10434.        0B    14.6 
#>  2 base_ansi        15.1µs   16.4µs    59272.        0B    17.8 
#>  3 cli_plain        87.1µs   93.9µs    10392.        0B    14.8 
#>  4 base_plain       15.1µs   16.3µs    59570.        0B    11.9 
#>  5 cli_vec_ansi    174.7µs  185.9µs     5308.     7.2KB     6.14
#>  6 base_vec_ansi    51.5µs   56.7µs    17659.    1.66KB     4.06
#>  7 cli_vec_plain   159.7µs  170.9µs     5774.     7.2KB     8.25
#>  8 base_vec_plain   46.2µs   51.3µs    19510.    1.66KB     4.06
#>  9 cli_txt_ansi    153.7µs  160.1µs     6148.        0B     9.81
#> 10 base_txt_ansi    38.1µs   39.3µs    25078.        0B     5.02
#> 11 cli_txt_plain   137.8µs    142µs     6911.        0B    10.3 
#> 12 base_txt_plain   33.1µs   34.3µs    28749.        0B     5.75
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
#> 1 cli          7.72µs   8.29µs   117876.        0B    11.8 
#> 2 base       821.08ns 940.99ns  1004968.        0B     0   
#> 3 cli_vec      23.1µs   23.8µs    41336.      448B     8.27
#> 4 base_vec     12.2µs  12.44µs    79164.      448B     0   
#> 5 cli_txt      23.2µs  23.84µs    41339.        0B     4.13
#> 6 base_txt    12.93µs  13.06µs    75353.        0B     0
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
#> 1 cli          7.61µs   8.15µs   119655.        0B    23.9 
#> 2 base         1.28µs   1.39µs   687959.        0B     0   
#> 3 cli_vec     29.23µs  30.21µs    32032.      448B     3.20
#> 4 base_vec    53.69µs  54.55µs    18097.      448B     0   
#> 5 cli_txt     29.74µs  30.75µs    32059.        0B     3.21
#> 6 base_txt    88.82µs  89.57µs    11038.        0B     0
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
#> 1 cli          8.22µs   8.83µs   109894.        0B    11.0 
#> 2 base       831.09ns 921.08ns   949401.        0B     0   
#> 3 cli_vec     19.75µs  20.81µs    47302.      448B     4.73
#> 4 base_vec    12.02µs  12.31µs    79786.      448B     7.98
#> 5 cli_txt     20.45µs   21.2µs    46344.        0B     4.63
#> 6 base_txt    12.92µs  13.08µs    73896.        0B     0
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
#> 1 cli          6.24µs   6.86µs   140216.    22.1KB    28.0 
#> 2 base       992.09ns   1.09µs   864460.        0B     0   
#> 3 cli_vec        31µs  31.93µs    30827.     1.7KB     3.08
#> 4 base_vec     8.66µs   8.89µs   109750.      848B     0   
#> 5 cli_txt      6.24µs   6.93µs   139296.        0B    13.9 
#> 6 base_txt     5.06µs   5.19µs   186824.        0B    18.7
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
#>  date     2026-04-08
#>  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.10.0     2026-01-26 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.5.9000 2026-04-08 [1] local
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
