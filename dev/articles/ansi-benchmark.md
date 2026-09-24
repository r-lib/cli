# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55e7b632a7c8\>
\<environment: 0x55e7b6dc0e68\>

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
#> 1 ansi         38.3µs   43.1µs    22660.    99.6KB     22.7
#> 2 plain        37.4µs   42.9µs    22703.        0B     25.1
#> 3 base         10.9µs   12.6µs    76881.    48.6KB     15.4
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
#> 1 ansi         39.5µs   44.7µs    21754.        0B     26.4
#> 2 plain        39.1µs   44.7µs    21779.        0B     26.2
#> 3 base         12.6µs   14.7µs    63802.        0B     19.1
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
#> 1 ansi       100.04µs  109.5µs     8869.   77.03KB     17.1
#> 2 plain       77.14µs  84.41µs    11456.    8.91KB     17.1
#> 3 base         1.86µs   2.07µs   456283.        0B     45.6
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
#> 1 ansi          285µs    311µs     3180.   33.24KB     24.0
#> 2 plain         281µs    310µs     3180.    1.09KB     23.9
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
#>  1 cli_ansi          5.51µs   6.46µs   147722.    9.27KB    29.6 
#>  2 fansi_ansi       26.23µs  29.88µs    31838.    4.18KB    15.9 
#>  3 cli_plain         5.44µs   6.11µs   155857.        0B    15.6 
#>  4 fansi_plain       26.6µs  29.73µs    32664.      688B    13.1 
#>  5 cli_vec_ansi      6.81µs   7.55µs   128550.      448B    12.9 
#>  6 fansi_vec_ansi   36.03µs  39.64µs    24502.    5.02KB    12.3 
#>  7 cli_vec_plain     7.57µs   8.31µs   115667.      448B    11.6 
#>  8 fansi_vec_plain   35.3µs  38.54µs    24267.    5.02KB     9.71
#>  9 cli_txt_ansi      5.41µs   6.48µs   112026.        0B    11.2 
#> 10 fansi_txt_ansi   26.78µs  29.93µs    31315.      688B    12.5 
#> 11 cli_txt_plain     6.38µs   7.07µs   136836.        0B    13.7 
#> 12 fansi_txt_plain  35.43µs  38.54µs    25380.    5.02KB    12.7
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
#> 1 cli          55.7µs     58µs    16878.    22.7KB     4.05
#> 2 fansi       111.5µs    117µs     8391.    55.3KB     4.06
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
#>  1 cli_ansi          6.47µs   7.26µs   132814.        0B    13.3 
#>  2 fansi_ansi        72.7µs  79.43µs    12243.   38.84KB    10.4 
#>  3 base_ansi       891.04ns 992.09ns   910314.        0B     0   
#>  4 cli_plain         6.35µs   7.23µs   131822.        0B    13.2 
#>  5 fansi_plain      72.29µs  78.72µs    12362.      688B    10.4 
#>  6 base_plain      810.95ns 890.93ns   993733.        0B     0   
#>  7 cli_vec_ansi     30.07µs  31.19µs    31364.      448B     3.14
#>  8 fansi_vec_ansi    93.8µs 100.62µs     9676.    5.02KB     8.31
#>  9 base_vec_ansi    20.32µs  20.44µs    48141.      448B     0   
#> 10 cli_vec_plain     27.9µs  28.95µs    33918.      448B     3.39
#> 11 fansi_vec_plain  83.77µs  90.48µs    10765.    5.02KB    10.5 
#> 12 base_vec_plain   11.72µs  11.85µs    82550.      448B     0   
#> 13 cli_txt_ansi     30.09µs  31.11µs    31642.        0B     3.16
#> 14 fansi_txt_ansi   85.57µs     93µs    10505.      688B     8.35
#> 15 base_txt_ansi    20.35µs  20.47µs    47960.        0B     0   
#> 16 cli_txt_plain    27.47µs  28.43µs    34617.        0B     3.46
#> 17 fansi_txt_plain  75.35µs  82.07µs    11880.      688B    10.4 
#> 18 base_txt_plain   11.73µs  11.88µs    82822.        0B     0
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
#>  1 cli_ansi          7.84µs   8.88µs   109330.        0B    10.9 
#>  2 fansi_ansi       73.27µs  79.67µs    12237.      688B    10.4 
#>  3 base_ansi         1.22µs   1.32µs   694902.        0B     0   
#>  4 cli_plain         7.81µs    8.9µs   108219.        0B    10.8 
#>  5 fansi_plain      72.45µs  79.57µs    12232.      688B    12.6 
#>  6 base_plain      991.98ns   1.09µs   846462.        0B     0   
#>  7 cli_vec_ansi     33.75µs   35.1µs    27906.      448B     2.79
#>  8 fansi_vec_ansi   97.06µs 104.01µs     9368.    5.02KB     8.32
#>  9 base_vec_ansi    44.99µs  45.87µs    21529.      448B     0   
#> 10 cli_vec_plain    32.15µs  33.42µs    29377.      448B     2.94
#> 11 fansi_vec_plain  87.06µs  94.17µs    10332.    5.02KB    10.4 
#> 12 base_vec_plain    23.5µs  23.85µs    41275.      448B     0   
#> 13 cli_txt_ansi     34.35µs  35.62µs    27456.        0B     2.75
#> 14 fansi_txt_ansi   88.22µs  95.21µs    10178.      688B     8.25
#> 15 base_txt_ansi    46.82µs  47.77µs    20689.        0B     0   
#> 16 cli_txt_plain    31.99µs  33.19µs    29586.        0B     5.92
#> 17 fansi_txt_plain  78.12µs  85.06µs    11433.      688B     8.35
#> 18 base_txt_plain   24.73µs  25.01µs    39301.        0B     0
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
#> 1 cli_ansi        6.37µs   7.12µs   135240.        0B    13.5 
#> 2 cli_plain       6.01µs   6.76µs   142797.        0B     0   
#> 3 cli_vec_ansi   30.56µs  31.72µs    31050.      848B     3.11
#> 4 cli_vec_plain   10.1µs  10.97µs    88641.      848B     8.86
#> 5 cli_txt_ansi   29.89µs  31.89µs    30915.        0B     3.09
#> 6 cli_txt_plain   7.04µs   7.78µs   124122.        0B    12.4
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
#>  1 cli_ansi            24µs   26.3µs    36803.        0B    14.7 
#>  2 fansi_ansi        25.1µs   27.9µs    34934.    7.24KB    17.5 
#>  3 cli_plain         23.9µs   26.1µs    37211.        0B    14.9 
#>  4 fansi_plain       24.2µs   26.7µs    36294.      688B    14.5 
#>  5 cli_vec_ansi      32.9µs   35.4µs    27690.      848B    11.1 
#>  6 fansi_vec_ansi    51.6µs   54.3µs    18076.    5.41KB     8.40
#>  7 cli_vec_plain     26.4µs   28.3µs    34413.      848B    13.8 
#>  8 fansi_vec_plain   34.1µs   36.5µs    26564.    4.59KB    10.6 
#>  9 cli_txt_ansi      32.2µs   34.8µs    28093.        0B    11.2 
#> 10 fansi_txt_ansi    41.4µs     44µs    22216.    5.12KB     8.89
#> 11 cli_txt_plain     24.7µs   26.9µs    36351.        0B    18.2 
#> 12 fansi_txt_plain     26µs   28.3µs    34446.      688B    13.8
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
#>  1 cli_ansi         131.6µs 141.98µs     6868.  104.86KB    12.6 
#>  2 fansi_ansi      106.98µs 117.44µs     8354.  106.35KB    10.4 
#>  3 base_ansi         3.94µs    4.5µs   216001.      224B    21.6 
#>  4 cli_plain        130.3µs 141.32µs     6852.    8.09KB    10.4 
#>  5 fansi_plain     105.62µs 116.19µs     8453.    9.62KB    12.6 
#>  6 base_plain        3.46µs   3.88µs   247454.        0B    24.7 
#>  7 cli_vec_ansi      6.58ms   6.81ms      147.  823.77KB    14.0 
#>  8 fansi_vec_ansi    1.04ms    1.1ms      886.  846.81KB    15.2 
#>  9 base_vec_ansi   157.09µs 165.77µs     5936.    22.7KB     4.14
#> 10 cli_vec_plain     6.53ms   6.83ms      147.  823.77KB    13.8 
#> 11 fansi_vec_plain   1.01ms   1.06ms      932.  845.98KB    18.0 
#> 12 base_vec_plain  107.27µs 112.81µs     8728.      848B     2.02
#> 13 cli_txt_ansi      3.44ms   3.51ms      284.    63.6KB     0   
#> 14 fansi_txt_ansi     1.6ms   1.62ms      613.   35.05KB     2.02
#> 15 base_txt_ansi    139.3µs 150.63µs     6668.   18.47KB     2.02
#> 16 cli_txt_plain     2.59ms   2.62ms      381.    63.6KB     0   
#> 17 fansi_txt_plain 534.58µs 571.74µs     1743.    30.6KB     4.09
#> 18 base_txt_plain    90.5µs  93.47µs    10521.   11.05KB     2.02
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
#>  1 cli_ansi        127.86µs 136.66µs     7090.   33.84KB    14.7 
#>  2 fansi_ansi       49.04µs  54.19µs    17759.   31.42KB    10.6 
#>  3 base_ansi         1.03µs   1.14µs   777545.     4.2KB    77.8 
#>  4 cli_plain       127.17µs 136.05µs     7185.        0B    12.5 
#>  5 fansi_plain      48.25µs  54.11µs    18040.      872B    14.7 
#>  6 base_plain      952.16ns   1.07µs   855752.        0B     0   
#>  7 cli_vec_ansi    254.32µs 266.24µs     3702.   16.73KB     6.20
#>  8 fansi_vec_ansi  113.29µs 119.25µs     8245.    5.59KB     7.85
#>  9 base_vec_ansi     36.8µs  37.23µs    26506.      848B     0   
#> 10 cli_vec_plain   208.93µs 218.56µs     4486.   16.73KB     8.35
#> 11 fansi_vec_plain 104.51µs 108.41µs     9049.    5.59KB     6.19
#> 12 base_vec_plain   30.55µs  31.03µs    31796.      848B     3.18
#> 13 cli_txt_ansi    132.95µs 139.03µs     7044.        0B    12.5 
#> 14 fansi_txt_ansi    47.5µs  50.81µs    19086.      872B    14.9 
#> 15 base_txt_ansi     1.05µs   1.16µs   806326.        0B     0   
#> 16 cli_txt_plain    127.9µs    137µs     7175.        0B    12.5 
#> 17 fansi_txt_plain  48.83µs  53.66µs    18286.      872B    14.7 
#> 18 base_txt_plain   970.9ns   1.07µs   871700.        0B     0
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
#>  1 cli_ansi        353.08µs 380.14µs    2596.     6.18KB    12.7 
#>  2 fansi_ansi       87.45µs  96.12µs   10132.    97.33KB    12.5 
#>  3 base_ansi        31.37µs  34.33µs   28207.         0B    11.3 
#>  4 cli_plain       220.89µs 237.87µs    4107.         0B    12.5 
#>  5 fansi_plain      85.71µs  94.78µs   10290.       872B    12.7 
#>  6 base_plain       25.53µs  27.98µs   34631.         0B    13.9 
#>  7 cli_vec_ansi     38.03ms  38.29ms      26.0   94.67KB    22.3 
#>  8 fansi_vec_ansi  235.51µs 248.09µs    3973.     7.25KB     6.17
#>  9 base_vec_ansi     2.22ms   2.28ms     435.    48.18KB    13.0 
#> 10 cli_vec_plain    23.66ms  23.82ms      41.9    2.48KB    18.0 
#> 11 fansi_vec_plain 185.47µs 196.59µs    4990.     6.42KB     6.17
#> 12 base_vec_plain     1.6ms   1.66ms     596.     47.4KB    12.9 
#> 13 cli_txt_ansi     28.63ms  28.91ms      34.6    4.27MB     4.61
#> 14 fansi_txt_ansi  225.41µs 237.14µs    4131.     6.77KB     6.23
#> 15 base_txt_ansi      1.3ms   1.34ms     735.   582.06KB     8.93
#> 16 cli_txt_plain     1.29ms   1.34ms     737.   369.84KB     8.91
#> 17 fansi_txt_plain 175.42µs 185.31µs    5289.     2.51KB     8.36
#> 18 base_txt_plain  875.75µs 910.77µs    1075.   367.31KB     8.96
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
#>  1 cli_ansi          6.38µs   7.36µs   127569.   25.09KB    12.8 
#>  2 fansi_ansi       69.41µs  77.93µs    12553.   28.48KB    13.4 
#>  3 base_ansi         1.04µs   1.13µs   772906.        0B     0   
#>  4 cli_plain          6.3µs   7.12µs    97510.        0B     9.75
#>  5 fansi_plain      69.97µs  73.84µs    12316.    1.98KB    12.6 
#>  6 base_plain      981.03ns   1.07µs   861893.        0B     0   
#>  7 cli_vec_ansi     26.34µs  27.63µs    35588.     1.7KB     3.56
#>  8 fansi_vec_ansi  106.31µs 110.97µs     8824.    8.86KB     8.44
#>  9 base_vec_ansi     6.62µs    7.2µs   136667.      848B     0   
#> 10 cli_vec_plain    23.11µs  24.35µs    40327.     1.7KB     4.03
#> 11 fansi_vec_plain 100.65µs 105.01µs     9296.    8.86KB     8.44
#> 12 base_vec_plain    6.19µs   6.58µs   148246.      848B    14.8 
#> 13 cli_txt_ansi      6.42µs   7.08µs   137459.        0B    13.7 
#> 14 fansi_txt_ansi   69.67µs  76.73µs    12810.    1.98KB    12.8 
#> 15 base_txt_ansi     7.05µs   7.18µs   135658.        0B     0   
#> 16 cli_txt_plain     7.38µs   8.22µs   116933.        0B    11.7 
#> 17 fansi_txt_plain  70.65µs  77.23µs    12690.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.51µs   214621.        0B     0
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
#>  1 cli_ansi        93.32µs 100.75µs    9659.     12.1KB    10.4 
#>  2 base_ansi        1.28µs   1.36µs  689173.         0B     0   
#>  3 cli_plain        73.1µs  78.55µs   12387.     8.91KB     8.26
#>  4 base_plain     981.03ns   1.06µs  883119.         0B     0   
#>  5 cli_vec_ansi     4.24ms   4.42ms     227.   838.95KB    15.7 
#>  6 base_vec_ansi   75.99µs  76.37µs   12931.       848B     0   
#>  7 cli_vec_plain    2.37ms   2.47ms     405.   817.08KB    12.9 
#>  8 base_vec_plain  46.37µs  47.25µs   20931.       848B     0   
#>  9 cli_txt_ansi    16.06ms  16.19ms      61.7   114.6KB     4.26
#> 10 base_txt_ansi   73.14µs  74.55µs   13239.         0B     0   
#> 11 cli_txt_plain  290.25µs 306.68µs    3219.    18.34KB     2.02
#> 12 base_txt_plain  42.37µs   42.6µs   23144.         0B     0
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
#>  1 cli_ansi         88.4µs   95.6µs    10271.        0B    14.9 
#>  2 base_ansi          15µs   16.5µs    59230.        0B    11.8 
#>  3 cli_plain          89µs   95.3µs    10268.        0B    14.6 
#>  4 base_plain       14.9µs   16.4µs    59589.        0B    11.9 
#>  5 cli_vec_ansi    191.7µs  205.9µs     4793.     7.2KB     6.16
#>  6 base_vec_ansi    54.8µs   62.8µs    16072.    1.66KB     4.07
#>  7 cli_vec_plain   177.3µs  191.3µs     5158.     7.2KB     6.17
#>  8 base_vec_plain   48.2µs   55.6µs    18066.    1.66KB     4.07
#>  9 cli_txt_ansi    172.6µs  180.4µs     5454.        0B     8.22
#> 10 base_txt_ansi    41.1µs   42.9µs    22916.        0B     4.58
#> 11 cli_txt_plain   156.9µs  164.2µs     5989.        0B     8.22
#> 12 base_txt_plain   34.4µs   36.3µs    27089.        0B     5.42
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
#> 1 cli          7.56µs   8.48µs   114127.        0B    11.4 
#> 2 base       831.09ns 922.13ns   963561.        0B     0   
#> 3 cli_vec     23.05µs  24.27µs    40478.      448B     4.05
#> 4 base_vec    12.05µs  12.49µs    78496.      448B     7.85
#> 5 cli_txt        23µs  24.07µs    40802.        0B     4.08
#> 6 base_txt    13.06µs  13.25µs    73813.        0B     0
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
#> 1 cli           7.6µs   8.54µs   113286.        0B    11.3 
#> 2 base          1.3µs   1.41µs   655115.        0B     0   
#> 3 cli_vec      29.3µs  30.81µs    31775.      448B     6.36
#> 4 base_vec     53.9µs   54.6µs    18086.      448B     0   
#> 5 cli_txt      29.7µs  31.18µs    31570.        0B     3.16
#> 6 base_txt     88.9µs  89.81µs    10742.        0B     0
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
#> 1 cli          8.05µs   9.21µs   105162.        0B    10.5 
#> 2 base       830.86ns 940.99ns   945246.        0B    94.5 
#> 3 cli_vec     19.58µs  20.93µs    46793.      448B     4.68
#> 4 base_vec    12.06µs  12.45µs    78922.      448B     0   
#> 5 cli_txt     20.24µs   21.5µs    45622.        0B     4.56
#> 6 base_txt    13.06µs  13.34µs    73365.        0B     7.34
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
#> 1 cli           6.1µs   6.96µs   137900.    22.2KB    13.8 
#> 2 base         1.02µs   1.13µs   803172.        0B     0   
#> 3 cli_vec     29.28µs  30.62µs    31965.     1.7KB     3.20
#> 4 base_vec     8.31µs   8.62µs   113105.      848B    11.3 
#> 5 cli_txt      6.05µs   6.95µs   138834.        0B    13.9 
#> 6 base_txt     5.18µs   5.56µs   177210.        0B     0
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
