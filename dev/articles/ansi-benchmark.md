# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5638ea0b9650\>
\<environment: 0x5638eab62178\>

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
#> 1 ansi         45.6µs   49.2µs    19647.    99.6KB     21.1
#> 2 plain        46.6µs   50.4µs    18995.        0B     19.8
#> 3 base         11.4µs   12.6µs    77018.    48.6KB     23.1
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
#> 1 ansi         48.8µs   52.4µs    18432.        0B     23.7
#> 2 plain        48.7µs   52.3µs    18508.        0B     21.1
#> 3 base         13.3µs   14.7µs    65985.        0B     19.8
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
#> 1 ansi        111.3µs 119.61µs     8062.   76.15KB     14.7
#> 2 plain        88.5µs  93.84µs    10277.    8.73KB     16.9
#> 3 base          1.9µs   2.06µs   460970.        0B      0
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
#> 1 ansi          347µs    371µs     2656.   33.23KB     19.1
#> 2 plain         345µs    369µs     2672.    1.09KB     19.1
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
#>  1 cli_ansi          5.74µs   6.34µs   152315.    9.27KB    30.5 
#>  2 fansi_ansi       31.39µs  35.05µs    26923.    4.18KB    21.6 
#>  3 cli_plain         5.79µs   6.39µs   151256.        0B    30.3 
#>  4 fansi_plain      31.36µs  33.87µs    27992.      688B    16.8 
#>  5 cli_vec_ansi      7.21µs   7.71µs   124292.      448B    12.4 
#>  6 fansi_vec_ansi   41.16µs  43.74µs    21994.    5.02KB     8.80
#>  7 cli_vec_plain      7.8µs   8.28µs   117378.      448B    11.7 
#>  8 fansi_vec_plain  39.33µs  41.74µs    23211.    5.02KB    11.6 
#>  9 cli_txt_ansi      5.76µs   6.16µs   155957.        0B    15.6 
#> 10 fansi_txt_ansi   31.21µs  33.39µs    28986.      688B    11.6 
#> 11 cli_txt_plain     6.61µs   7.04µs   137927.        0B    13.8 
#> 12 fansi_txt_plain  39.51µs  42.28µs    22701.    5.02KB     9.08
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
#> 1 cli          56.8µs   58.9µs    16602.    22.7KB     4.05
#> 2 fansi       119.7µs  127.3µs     7753.    55.3KB     4.06
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
#>  1 cli_ansi          6.93µs    7.6µs   126618.        0B    12.7 
#>  2 fansi_ansi       91.08µs  97.53µs     9924.   38.84KB    10.3 
#>  3 base_ansi        941.1ns 992.09ns   959332.        0B     0   
#>  4 cli_plain         6.94µs   7.52µs   127708.        0B    12.8 
#>  5 fansi_plain      90.91µs  97.34µs     9479.      688B     8.21
#>  6 base_plain      851.11ns 901.99ns  1029010.        0B     0   
#>  7 cli_vec_ansi      29.5µs  30.36µs    32210.      448B     3.22
#>  8 fansi_vec_ansi  112.61µs 118.58µs     8180.    5.02KB     6.16
#>  9 base_vec_ansi    17.22µs  17.36µs    56562.      448B     5.66
#> 10 cli_vec_plain    27.66µs  28.38µs    34514.      448B     3.45
#> 11 fansi_vec_plain 101.89µs 108.45µs     8938.    5.02KB     6.16
#> 12 base_vec_plain   10.18µs  10.28µs    95558.      448B     0   
#> 13 cli_txt_ansi     28.85µs  29.58µs    33138.        0B     3.31
#> 14 fansi_txt_ansi  103.62µs 109.65µs     8836.      688B     8.21
#> 15 base_txt_ansi    16.93µs     17µs    57922.        0B     0   
#> 16 cli_txt_plain    27.19µs  27.86µs    35158.        0B     3.52
#> 17 fansi_txt_plain  94.26µs   99.6µs     9616.      688B    10.3 
#> 18 base_txt_plain    9.89µs  10.41µs    94633.        0B     0
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
#>  1 cli_ansi          8.46µs   9.22µs   105033.        0B    10.5 
#>  2 fansi_ansi       91.85µs  97.63µs     9905.      688B     8.31
#>  3 base_ansi         1.24µs   1.31µs   711280.        0B    71.1 
#>  4 cli_plain         8.51µs   9.15µs   106092.        0B    10.6 
#>  5 fansi_plain      91.58µs  96.87µs    10015.      688B     8.21
#>  6 base_plain        1.04µs   1.09µs   849019.        0B     0   
#>  7 cli_vec_ansi     34.37µs  35.53µs    27507.      448B     2.75
#>  8 fansi_vec_ansi  114.94µs 120.79µs     7961.    5.02KB     8.28
#>  9 base_vec_ansi     40.8µs  41.44µs    23749.      448B     0   
#> 10 cli_vec_plain    32.94µs  33.87µs    28722.      448B     2.87
#> 11 fansi_vec_plain 105.09µs 110.89µs     8721.    5.02KB     8.28
#> 12 base_vec_plain   21.65µs  21.97µs    44796.      448B     0   
#> 13 cli_txt_ansi     34.42µs  35.17µs    27821.        0B     2.78
#> 14 fansi_txt_ansi  106.35µs 112.56µs     8543.      688B     8.21
#> 15 base_txt_ansi     43.4µs  44.17µs    22357.        0B     0   
#> 16 cli_txt_plain    32.48µs  33.33µs    29286.        0B     2.93
#> 17 fansi_txt_plain  96.87µs 102.35µs     9469.      688B    10.3 
#> 18 base_txt_plain   23.64µs  23.89µs    41269.        0B     0
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
#> 1 cli_ansi        7.06µs   7.61µs   126903.        0B    12.7 
#> 2 cli_plain       6.47µs   7.05µs   136763.        0B    13.7 
#> 3 cli_vec_ansi   31.72µs  33.19µs    29467.      848B     2.95
#> 4 cli_vec_plain  10.54µs  11.26µs    86624.      848B     0   
#> 5 cli_txt_ansi   30.84µs  31.98µs    30489.        0B     3.05
#> 6 cli_txt_plain   7.38µs   7.99µs   121317.        0B    12.1
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
#>  1 cli_ansi          25.8µs   27.4µs    35410.        0B    14.2 
#>  2 fansi_ansi        29.1µs   31.4µs    30779.    7.24KB    12.3 
#>  3 cli_plain         25.5µs   27.3µs    35414.        0B    14.2 
#>  4 fansi_plain       28.5µs   30.7µs    31543.      688B    12.6 
#>  5 cli_vec_ansi      35.7µs   37.5µs    25855.      848B    12.9 
#>  6 fansi_vec_ansi      56µs   58.6µs    16596.    5.41KB     6.20
#>  7 cli_vec_plain     28.2µs   30.1µs    32242.      848B    12.9 
#>  8 fansi_vec_plain   37.9µs   39.9µs    24297.    4.59KB    12.2 
#>  9 cli_txt_ansi      34.4µs   35.7µs    27227.        0B    10.9 
#> 10 fansi_txt_ansi    44.7µs   46.5µs    20861.    5.12KB     8.35
#> 11 cli_txt_plain     26.5µs   27.7µs    35007.        0B    14.0 
#> 12 fansi_txt_plain   29.7µs   31.4µs    30721.      688B    12.3
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
#>  1 cli_ansi        165.29µs 171.12µs     5640.  104.86KB    10.3 
#>  2 fansi_ansi      132.03µs 140.98µs     6885.  106.35KB     8.27
#>  3 base_ansi         4.25µs   4.62µs   208718.      224B    20.9 
#>  4 cli_plain       164.18µs 172.03µs     5617.    8.09KB    10.3 
#>  5 fansi_plain        131µs 139.62µs     6931.    9.62KB    10.4 
#>  6 base_plain        3.78µs   4.01µs   242727.        0B     0   
#>  7 cli_vec_ansi      7.92ms   8.05ms      124.  823.77KB    11.3 
#>  8 fansi_vec_ansi    1.08ms   1.11ms      878.  846.81KB    17.5 
#>  9 base_vec_ansi    156.8µs 162.13µs     6034.    22.7KB     2.04
#> 10 cli_vec_plain     7.72ms   7.87ms      127.  823.77KB    11.3 
#> 11 fansi_vec_plain   1.02ms   1.05ms      940.  845.98KB    17.8 
#> 12 base_vec_plain  107.37µs 111.61µs     8822.      848B     4.06
#> 13 cli_txt_ansi      3.45ms   3.57ms      280.    63.6KB     0   
#> 14 fansi_txt_ansi    1.56ms   1.59ms      624.   35.05KB     2.02
#> 15 base_txt_ansi   137.94µs  147.5µs     6722.   18.47KB     2.02
#> 16 cli_txt_plain     2.45ms   2.49ms      401.    63.6KB     0   
#> 17 fansi_txt_plain 522.41µs 564.88µs     1752.    30.6KB     2.02
#> 18 base_txt_plain   90.08µs  93.14µs    10553.   11.05KB     2.02
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
#>  1 cli_ansi        149.78µs 157.59µs     6150.   33.84KB    12.5 
#>  2 fansi_ansi       56.05µs  60.08µs    16068.   31.42KB    10.4 
#>  3 base_ansi          1.1µs   1.16µs   788437.     4.2KB    78.9 
#>  4 cli_plain       148.11µs  155.9µs     6212.        0B    12.4 
#>  5 fansi_plain      55.84µs  59.72µs    16106.      872B    10.4 
#>  6 base_plain        1.03µs   1.08µs   861696.        0B     0   
#>  7 cli_vec_ansi    277.18µs 289.29µs     3381.   16.73KB     8.30
#>  8 fansi_vec_ansi  116.76µs 121.46µs     7736.    5.59KB     6.31
#>  9 base_vec_ansi    35.44µs  36.29µs    26230.      848B     0   
#> 10 cli_vec_plain   231.75µs 244.47µs     3952.   16.73KB     6.17
#> 11 fansi_vec_plain 110.52µs 116.76µs     8317.    5.59KB     8.31
#> 12 base_vec_plain      30µs  30.98µs    31981.      848B     0   
#> 13 cli_txt_ansi    157.98µs 166.16µs     5785.        0B    10.3 
#> 14 fansi_txt_ansi   55.17µs  59.38µs    16289.      872B    12.5 
#> 15 base_txt_ansi     1.14µs    1.2µs   780441.        0B     0   
#> 16 cli_txt_plain   145.81µs 154.85µs     6172.        0B    12.2 
#> 17 fansi_txt_plain  54.13µs   56.7µs    17010.      872B    12.5 
#> 18 base_txt_plain    1.04µs    1.1µs   863095.        0B     0
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
#>  1 cli_ansi        421.02µs 448.19µs    2215.     6.18KB    10.4 
#>  2 fansi_ansi       100.2µs 107.11µs    9052.    97.33KB    10.5 
#>  3 base_ansi        39.59µs  41.93µs   22981.         0B    11.5 
#>  4 cli_plain       277.45µs 291.26µs    3347.         0B    10.4 
#>  5 fansi_plain      99.49µs 107.12µs    9034.       872B    10.4 
#>  6 base_plain       31.96µs  34.31µs   28023.         0B    11.2 
#>  7 cli_vec_ansi     45.17ms  45.66ms      21.9   94.67KB    18.2 
#>  8 fansi_vec_ansi  241.76µs 258.28µs    3682.     7.25KB     6.18
#>  9 base_vec_ansi     2.31ms   2.39ms     416.    48.18KB    10.7 
#> 10 cli_vec_plain    29.53ms   29.7ms      33.6    2.48KB    18.3 
#> 11 fansi_vec_plain 198.24µs 208.69µs    4689.     6.42KB     6.22
#> 12 base_vec_plain    1.68ms   1.75ms     569.     47.4KB    12.8 
#> 13 cli_txt_ansi      27.1ms  27.39ms      36.2    4.27MB     4.53
#> 14 fansi_txt_ansi  230.05µs 240.93µs    4069.     6.77KB     6.14
#> 15 base_txt_ansi     1.26ms   1.29ms     761.   582.06KB    11.1 
#> 16 cli_txt_plain     1.28ms   1.33ms     741.   369.84KB     8.69
#> 17 fansi_txt_plain 180.94µs 190.16µs    5128.     2.51KB     6.21
#> 18 base_txt_plain  855.21µs  893.9µs    1100.   367.31KB     8.75
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
#>  1 cli_ansi          6.84µs   7.52µs   128145.   25.09KB    12.8 
#>  2 fansi_ansi       80.91µs  86.82µs    11022.   28.48KB    10.4 
#>  3 base_ansi         1.07µs   1.14µs   824287.        0B     0   
#>  4 cli_plain          6.7µs    7.4µs   130555.        0B    13.1 
#>  5 fansi_plain       81.6µs  86.74µs    11130.    1.98KB    10.4 
#>  6 base_plain        1.04µs   1.11µs   813821.        0B    81.4 
#>  7 cli_vec_ansi     27.48µs  28.52µs    34247.     1.7KB     3.43
#>  8 fansi_vec_ansi  117.26µs 121.68µs     7976.    8.86KB     8.37
#>  9 base_vec_ansi     6.08µs   6.37µs   153788.      848B     0   
#> 10 cli_vec_plain    23.34µs  24.53µs    39918.     1.7KB     3.99
#> 11 fansi_vec_plain 111.97µs 116.32µs     8351.    8.86KB     8.36
#> 12 base_vec_plain    5.74µs   6.04µs   161998.      848B     0   
#> 13 cli_txt_ansi      6.73µs   7.18µs   135601.        0B    13.6 
#> 14 fansi_txt_ansi   79.59µs  83.33µs    11609.    1.98KB    10.4 
#> 15 base_txt_ansi     6.51µs   6.58µs   148127.        0B    14.8 
#> 16 cli_txt_plain     7.51µs   7.99µs   122084.        0B    12.2 
#> 17 fansi_txt_plain  79.47µs  84.23µs    11483.    1.98KB    10.5 
#> 18 base_txt_plain    4.15µs   4.23µs   230334.        0B     0
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
#>  1 cli_ansi       105.81µs 110.59µs    8701.    11.88KB     8.22
#>  2 base_ansi        1.35µs    1.4µs  680431.         0B     0   
#>  3 cli_plain       84.35µs  89.17µs   10791.     8.73KB     8.23
#>  4 base_plain       1.06µs   1.11µs  855087.         0B     0   
#>  5 cli_vec_ansi     4.25ms   4.39ms     228.   838.77KB    13.1 
#>  6 base_vec_ansi   71.94µs  72.25µs   13652.       848B     2.02
#>  7 cli_vec_plain    2.34ms   2.41ms     414.    816.9KB    12.9 
#>  8 base_vec_plain  42.58µs  43.11µs   22888.       848B     0   
#>  9 cli_txt_ansi     14.4ms  14.52ms      68.8  114.42KB     4.30
#> 10 base_txt_ansi   72.44µs  74.02µs   13146.         0B     0   
#> 11 cli_txt_plain  272.32µs 281.58µs    3482.    18.16KB     2.01
#> 12 base_txt_plain  41.07µs  41.41µs   23732.         0B     0
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
#>  1 cli_ansi        109.7µs  115.9µs     8336.        0B    10.3 
#>  2 base_ansi        16.9µs     18µs    53639.        0B    10.7 
#>  3 cli_plain       108.9µs  114.7µs     8433.        0B    12.4 
#>  4 base_plain       16.9µs   18.1µs    53308.        0B    10.7 
#>  5 cli_vec_ansi    209.1µs    220µs     4436.     7.2KB     6.15
#>  6 base_vec_ansi    59.3µs   64.4µs    15280.    1.66KB     4.07
#>  7 cli_vec_plain   191.8µs  203.4µs     4676.     7.2KB     6.16
#>  8 base_vec_plain   51.9µs   57.7µs    17146.    1.66KB     4.06
#>  9 cli_txt_ansi    181.8µs  188.6µs     5164.        0B     6.12
#> 10 base_txt_ansi    41.1µs   42.5µs    22888.        0B     4.58
#> 11 cli_txt_plain   165.2µs  172.1µs     5652.        0B     8.20
#> 12 base_txt_plain   35.5µs     37µs    26306.        0B     5.26
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
#> 1 cli          8.12µs   8.79µs   109361.        0B    21.9 
#> 2 base       901.05ns 952.04ns   989085.        0B     0   
#> 3 cli_vec     23.82µs  24.69µs    39519.      448B     3.95
#> 4 base_vec    11.66µs  11.92µs    82474.      448B     0   
#> 5 cli_txt     23.93µs  24.67µs    39529.        0B     3.95
#> 6 base_txt    12.66µs  12.78µs    77012.        0B     0
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
#> 1 cli          8.29µs   9.01µs   107474.        0B    10.7 
#> 2 base         1.32µs   1.37µs   681717.        0B     0   
#> 3 cli_vec     29.14µs  30.13µs    32440.      448B     3.24
#> 4 base_vec    50.55µs  51.18µs    19278.      448B     0   
#> 5 cli_txt     29.54µs  30.38µs    32054.        0B     6.41
#> 6 base_txt    86.56µs  87.22µs    11318.        0B     0
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
#> 1 cli           8.7µs   9.47µs   101983.        0B    10.2 
#> 2 base        902.1ns 952.04ns   966709.        0B     0   
#> 3 cli_vec      19.7µs   20.7µs    46520.      448B     9.31
#> 4 base_vec     11.6µs  11.88µs    82693.      448B     0   
#> 5 cli_txt      20.5µs  21.34µs    45720.        0B     4.57
#> 6 base_txt     12.7µs  12.74µs    76974.        0B     0
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
#> 1 cli          6.31µs   6.87µs   139121.    22.2KB    27.8 
#> 2 base         1.08µs   1.16µs   809722.        0B     0   
#> 3 cli_vec      30.5µs  31.46µs    31110.     1.7KB     3.11
#> 4 base_vec      8.4µs   8.64µs   113831.      848B     0   
#> 5 cli_txt      6.37µs   6.98µs   137731.        0B    27.6 
#> 6 base_txt     5.76µs   5.83µs   167993.        0B     0
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
#>  date     2026-05-27
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-27 [1] local
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
