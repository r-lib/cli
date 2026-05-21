# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x562b60517b98\>
\<environment: 0x562b60fb8b10\>

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
#> 1 ansi         47.5µs   51.4µs    18722.    99.6KB     19.0
#> 2 plain        47.4µs   51.2µs    18830.        0B     20.0
#> 3 base         11.7µs     13µs    74362.    48.6KB     14.9
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
#> 1 ansi         48.7µs   53.1µs    18173.        0B     21.3
#> 2 plain        49.3µs   53.2µs    18108.        0B     21.6
#> 3 base         13.6µs     15µs    64223.        0B     19.3
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
#> 1 ansi       114.36µs 121.07µs     7998.   76.15KB     14.7
#> 2 plain        90.1µs     96µs    10027.    8.73KB     14.7
#> 3 base         1.88µs   2.04µs   464169.        0B     46.4
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
#> 1 ansi          357µs    382µs     2582.   33.23KB     19.2
#> 2 plain         358µs    381µs     2587.    1.09KB     19.2
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
#>  1 cli_ansi           5.8µs   6.39µs   149625.    9.27KB    29.9 
#>  2 fansi_ansi        31.6µs  35.19µs    27323.    4.18KB    24.6 
#>  3 cli_plain         5.81µs   6.37µs   151117.        0B    15.1 
#>  4 fansi_plain      31.08µs  34.34µs    27583.      688B    19.3 
#>  5 cli_vec_ansi       7.2µs   7.75µs   123960.      448B    12.4 
#>  6 fansi_vec_ansi   41.09µs  44.32µs    21648.    5.02KB     8.66
#>  7 cli_vec_plain     7.86µs    8.4µs   115669.      448B    11.6 
#>  8 fansi_vec_plain  39.51µs   42.1µs    22942.    5.02KB    11.5 
#>  9 cli_txt_ansi       5.8µs   6.25µs   154955.        0B    15.5 
#> 10 fansi_txt_ansi   31.22µs  33.85µs    28538.      688B    11.4 
#> 11 cli_txt_plain     6.65µs   7.06µs   137736.        0B    13.8 
#> 12 fansi_txt_plain  39.74µs  42.36µs    22800.    5.02KB     9.12
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
#> 1 cli          57.1µs   59.2µs    16426.    22.7KB     4.05
#> 2 fansi       119.9µs  128.2µs     7705.    55.3KB     4.06
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
#>  1 cli_ansi          7.12µs    7.8µs   123676.        0B    12.4 
#>  2 fansi_ansi       92.82µs  98.52µs     9828.   38.84KB    10.3 
#>  3 base_ansi       911.07ns 952.04ns   974010.        0B     0   
#>  4 cli_plain         7.05µs   7.78µs   124348.        0B    12.4 
#>  5 fansi_plain      92.42µs  97.95µs     9850.      688B     8.21
#>  6 base_plain      831.09ns 872.07ns  1052093.        0B     0   
#>  7 cli_vec_ansi     29.56µs  30.58µs    31798.      448B     3.18
#>  8 fansi_vec_ansi  113.84µs 120.04µs     8064.    5.02KB     6.16
#>  9 base_vec_ansi    17.21µs  17.36µs    56280.      448B     5.63
#> 10 cli_vec_plain    27.65µs  28.62µs    33977.      448B     3.40
#> 11 fansi_vec_plain 104.19µs 110.42µs     8732.    5.02KB     6.16
#> 12 base_vec_plain   10.16µs  10.25µs    95771.      448B     0   
#> 13 cli_txt_ansi     29.04µs  29.87µs    32591.        0B     3.26
#> 14 fansi_txt_ansi  105.41µs 111.76µs     8647.      688B     8.21
#> 15 base_txt_ansi     16.9µs  16.97µs    57957.        0B     0   
#> 16 cli_txt_plain    27.23µs  28.03µs    34809.        0B     3.48
#> 17 fansi_txt_plain  95.26µs 101.19µs     9543.      688B     8.21
#> 18 base_txt_plain    9.86µs  10.38µs    95845.        0B     9.59
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
#>  1 cli_ansi          8.66µs   9.48µs   101583.        0B    10.2 
#>  2 fansi_ansi       93.92µs  99.78µs     9679.      688B     8.30
#>  3 base_ansi         1.24µs   1.29µs   727768.        0B     0   
#>  4 cli_plain         8.58µs   9.44µs   102311.        0B    20.5 
#>  5 fansi_plain      92.88µs  98.34µs     9792.      688B     8.21
#>  6 base_plain        1.01µs   1.07µs   865563.        0B     0   
#>  7 cli_vec_ansi     34.62µs  35.81µs    27213.      448B     2.72
#>  8 fansi_vec_ansi   116.7µs 123.58µs     7811.    5.02KB     8.27
#>  9 base_vec_ansi    41.02µs  41.56µs    23616.      448B     0   
#> 10 cli_vec_plain    32.94µs  34.04µs    28555.      448B     2.86
#> 11 fansi_vec_plain 107.15µs 113.13µs     8543.    5.02KB     8.27
#> 12 base_vec_plain   21.68µs  22.05µs    44622.      448B     0   
#> 13 cli_txt_ansi     34.33µs  35.27µs    27655.        0B     2.77
#> 14 fansi_txt_ansi  107.82µs  114.3µs     8475.      688B     8.21
#> 15 base_txt_ansi    43.24µs  44.11µs    22250.        0B     0   
#> 16 cli_txt_plain    32.46µs  33.43µs    28907.        0B     2.89
#> 17 fansi_txt_plain  98.49µs 104.23µs     9266.      688B     8.20
#> 18 base_txt_plain   23.59µs  23.86µs    41077.        0B     0
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
#> 1 cli_ansi        6.98µs   7.64µs   125903.        0B    12.6 
#> 2 cli_plain       6.62µs   7.27µs   132719.        0B    13.3 
#> 3 cli_vec_ansi   31.98µs  33.49µs    29137.      848B     2.91
#> 4 cli_vec_plain  10.61µs  11.41µs    84913.      848B     8.49
#> 5 cli_txt_ansi    31.1µs  32.26µs    30273.        0B     3.03
#> 6 cli_txt_plain    7.4µs   8.12µs   119405.        0B    11.9
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
#>  1 cli_ansi          26.1µs     28µs    34676.        0B    13.9 
#>  2 fansi_ansi        29.2µs   31.4µs    30714.    7.24KB    15.4 
#>  3 cli_plain           26µs     28µs    34522.        0B    13.8 
#>  4 fansi_plain       28.6µs   30.8µs    31355.      688B    12.5 
#>  5 cli_vec_ansi      35.6µs   37.6µs    25794.      848B    10.3 
#>  6 fansi_vec_ansi      56µs     59µs    16438.    5.41KB     8.33
#>  7 cli_vec_plain     28.5µs   30.6µs    31681.      848B    12.7 
#>  8 fansi_vec_plain   37.7µs   40.3µs    23959.    4.59KB     9.95
#>  9 cli_txt_ansi      34.6µs   36.1µs    26791.        0B    10.7 
#> 10 fansi_txt_ansi    45.1µs   46.9µs    20652.    5.12KB     8.26
#> 11 cli_txt_plain     26.6µs     28µs    34625.        0B    17.3 
#> 12 fansi_txt_plain   29.5µs   31.2µs    31051.      688B    12.4
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
#>  1 cli_ansi        169.48µs 178.85µs     5407.  104.86KB    10.4 
#>  2 fansi_ansi      130.56µs 140.43µs     6896.  106.35KB    10.4 
#>  3 base_ansi         4.07µs   4.51µs   213151.      224B     0   
#>  4 cli_plain       167.21µs 177.13µs     5478.    8.09KB    10.4 
#>  5 fansi_plain     129.94µs 139.04µs     6789.    9.62KB     8.24
#>  6 base_plain        3.62µs   4.01µs   238862.        0B    23.9 
#>  7 cli_vec_ansi      7.95ms   8.12ms      121.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.07ms   1.11ms      863.  846.81KB    15.1 
#>  9 base_vec_ansi   158.35µs 165.48µs     5860.    22.7KB     4.12
#> 10 cli_vec_plain     7.89ms   8.08ms      123.  823.77KB    11.2 
#> 11 fansi_vec_plain   1.01ms   1.06ms      940.  845.98KB    17.8 
#> 12 base_vec_plain  107.66µs 112.54µs     8649.      848B     4.06
#> 13 cli_txt_ansi       3.4ms   3.44ms      289.    63.6KB     0   
#> 14 fansi_txt_ansi    1.55ms   1.58ms      630.   35.05KB     0   
#> 15 base_txt_ansi   137.73µs 145.63µs     6814.   18.47KB     2.02
#> 16 cli_txt_plain     2.45ms   2.48ms      400.    63.6KB     2.02
#> 17 fansi_txt_plain 516.68µs 536.24µs     1857.    30.6KB     2.02
#> 18 base_txt_plain   88.45µs  92.37µs    10574.   11.05KB     2.02
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
#>  1 cli_ansi        154.02µs 161.53µs     6004.   33.84KB    12.5 
#>  2 fansi_ansi       55.92µs  60.16µs    16005.   31.42KB    10.4 
#>  3 base_ansi         1.08µs   1.14µs   822254.     4.2KB     0   
#>  4 cli_plain       151.95µs 159.81µs     6062.        0B    12.5 
#>  5 fansi_plain      55.59µs  60.01µs    16051.      872B    12.5 
#>  6 base_plain           1µs   1.06µs   895387.        0B     0   
#>  7 cli_vec_ansi    280.05µs 292.38µs     3353.   16.73KB     6.18
#>  8 fansi_vec_ansi  116.47µs 121.45µs     8000.    5.59KB     6.18
#>  9 base_vec_ansi    35.45µs  35.95µs    27461.      848B     0   
#> 10 cli_vec_plain   238.66µs 251.08µs     3898.   16.73KB     8.52
#> 11 fansi_vec_plain 109.29µs 114.81µs     8456.    5.59KB     6.18
#> 12 base_vec_plain   29.77µs  30.89µs    31298.      848B     3.13
#> 13 cli_txt_ansi       163µs 169.71µs     5709.        0B    10.3 
#> 14 fansi_txt_ansi   55.73µs   59.8µs    16148.      872B    12.5 
#> 15 base_txt_ansi      1.1µs   1.15µs   821101.        0B     0   
#> 16 cli_txt_plain   151.26µs 161.14µs     6026.        0B    12.3 
#> 17 fansi_txt_plain  54.84µs  57.73µs    16706.      872B    10.3 
#> 18 base_txt_plain    1.01µs   1.06µs   896118.        0B    89.6
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
#>  1 cli_ansi        410.05µs 436.82µs    2226.         0B    10.3 
#>  2 fansi_ansi      101.12µs 106.89µs    8936.    97.33KB    10.3 
#>  3 base_ansi        40.01µs  42.57µs   22618.         0B     9.05
#>  4 cli_plain       282.09µs 295.93µs    3310.         0B    10.3 
#>  5 fansi_plain      99.79µs 106.82µs    9048.       872B    12.5 
#>  6 base_plain       32.72µs  34.85µs   27726.         0B     8.32
#>  7 cli_vec_ansi     43.58ms  44.11ms      22.6    2.48KB    27.2 
#>  8 fansi_vec_ansi  241.45µs 251.34µs    3915.     7.25KB     4.07
#>  9 base_vec_ansi     2.31ms   2.39ms     416.    48.18KB    12.9 
#> 10 cli_vec_plain     29.7ms  29.93ms      33.3    2.48KB    18.2 
#> 11 fansi_vec_plain 194.76µs 203.86µs    4794.     6.42KB     6.15
#> 12 base_vec_plain    1.67ms   1.76ms     562.     47.4KB    12.9 
#> 13 cli_txt_ansi     25.69ms  26.17ms      38.3  507.59KB     4.50
#> 14 fansi_txt_ansi   228.9µs  238.6µs    4103.     6.77KB     6.13
#> 15 base_txt_ansi     1.26ms   1.31ms     756.   582.06KB     8.79
#> 16 cli_txt_plain     1.29ms   1.34ms     735.   369.84KB     8.70
#> 17 fansi_txt_plain 180.07µs 189.99µs    5084.     2.51KB     8.31
#> 18 base_txt_plain  853.39µs 892.35µs    1101.   367.31KB     8.74
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
#>  1 cli_ansi          6.79µs   7.58µs   123913.   25.09KB    24.8 
#>  2 fansi_ansi       81.94µs  87.16µs    11056.   28.48KB    10.4 
#>  3 base_ansi         1.05µs    1.1µs   845285.        0B     0   
#>  4 cli_plain         6.72µs   7.51µs   127789.        0B    12.8 
#>  5 fansi_plain      81.26µs  86.97µs    11094.    1.98KB    10.4 
#>  6 base_plain        1.02µs   1.07µs   856073.        0B     0   
#>  7 cli_vec_ansi     27.65µs  28.92µs    31717.     1.7KB     6.34
#>  8 fansi_vec_ansi  118.45µs 124.39µs     7777.    8.86KB     6.29
#>  9 base_vec_ansi     6.04µs   6.31µs   154831.      848B     0   
#> 10 cli_vec_plain    23.47µs  25.16µs    38741.     1.7KB     7.75
#> 11 fansi_vec_plain 113.89µs 119.69µs     8121.    8.86KB     6.21
#> 12 base_vec_plain    5.68µs    6.1µs   157268.      848B    15.7 
#> 13 cli_txt_ansi       6.8µs   7.59µs   126961.        0B    12.7 
#> 14 fansi_txt_ansi   82.55µs  88.87µs    10780.    1.98KB    10.4 
#> 15 base_txt_ansi     6.48µs   6.54µs   148600.        0B     0   
#> 16 cli_txt_plain     7.63µs   8.51µs   112868.        0B    11.3 
#> 17 fansi_txt_plain  82.56µs   88.8µs    10786.    1.98KB    10.4 
#> 18 base_txt_plain    4.12µs   4.19µs   229598.        0B     0
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
#>  1 cli_ansi        108.9µs 115.83µs    8326.    11.88KB     7.53
#>  2 base_ansi        1.32µs   1.37µs  702079.         0B     0   
#>  3 cli_plain       86.27µs   90.7µs   10560.     8.73KB     8.24
#>  4 base_plain       1.03µs   1.07µs  896660.         0B     0   
#>  5 cli_vec_ansi     4.27ms   4.39ms     226.   838.77KB    13.2 
#>  6 base_vec_ansi   71.89µs  72.25µs   13620.       848B     2.02
#>  7 cli_vec_plain    2.33ms    2.4ms     414.    816.9KB    12.8 
#>  8 base_vec_plain  42.47µs  43.11µs   22812.       848B     0   
#>  9 cli_txt_ansi    14.46ms  14.61ms      68.2  114.42KB     4.26
#> 10 base_txt_ansi   72.36µs  73.84µs   13339.         0B     0   
#> 11 cli_txt_plain  275.27µs 283.81µs    3448.    18.16KB     2.02
#> 12 base_txt_plain  40.44µs  41.82µs   23576.         0B     0
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
#>  1 cli_ansi        109.8µs    117µs     8234.        0B    10.3 
#>  2 base_ansi        16.8µs     18µs    53522.        0B    10.7 
#>  3 cli_plain       110.6µs    116µs     8319.        0B    12.4 
#>  4 base_plain       16.9µs     18µs    53773.        0B    10.8 
#>  5 cli_vec_ansi    209.8µs  219.8µs     4437.     7.2KB     6.15
#>  6 base_vec_ansi    60.2µs   65.2µs    14902.    1.66KB     2.02
#>  7 cli_vec_plain   196.7µs  206.2µs     4727.     7.2KB     8.29
#>  8 base_vec_plain     53µs   58.5µs    16555.    1.66KB     2.02
#>  9 cli_txt_ansi    182.5µs  189.5µs     5143.        0B     8.21
#> 10 base_txt_ansi    41.4µs   42.8µs    22664.        0B     4.53
#> 11 cli_txt_plain   167.6µs  174.3µs     5586.        0B     8.20
#> 12 base_txt_plain   35.8µs   37.1µs    26190.        0B     5.24
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
#> 1 cli          8.29µs   9.06µs   106778.        0B    10.7 
#> 2 base       881.03ns 932.14ns   986195.        0B     0   
#> 3 cli_vec     23.96µs  24.83µs    39186.      448B     7.84
#> 4 base_vec    11.68µs  11.92µs    82473.      448B     0   
#> 5 cli_txt     23.95µs  24.77µs    39327.        0B     3.93
#> 6 base_txt    12.63µs  12.71µs    76876.        0B     0
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
#> 1 cli          8.29µs   9.18µs   105078.        0B    10.5 
#> 2 base         1.32µs   1.39µs   670147.        0B    67.0 
#> 3 cli_vec     29.27µs  30.28µs    32236.      448B     3.22
#> 4 base_vec    50.69µs  51.29µs    19213.      448B     0   
#> 5 cli_txt     29.59µs  30.54µs    31866.        0B     3.19
#> 6 base_txt    86.34µs  87.46µs    11271.        0B     0
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
#> 1 cli           8.9µs   9.69µs    99027.        0B    19.8 
#> 2 base          881ns 932.14ns   980219.        0B     0   
#> 3 cli_vec      19.9µs  20.91µs    46556.      448B     4.66
#> 4 base_vec     11.7µs  11.89µs    82633.      448B     0   
#> 5 cli_txt      20.6µs  21.48µs    45273.        0B     9.06
#> 6 base_txt     12.6µs  12.72µs    77318.        0B     0
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
#> 1 cli           6.4µs   7.09µs   135992.    22.2KB    13.6 
#> 2 base         1.07µs   1.12µs   826928.        0B     0   
#> 3 cli_vec     30.81µs  31.76µs    30860.     1.7KB     6.17
#> 4 base_vec     8.44µs   8.62µs   114002.      848B     0   
#> 5 cli_txt      6.41µs   7.04µs   136451.        0B    13.6 
#> 6 base_txt     5.71µs   5.81µs   167791.        0B     0
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
#>  date     2026-05-21
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-21 [1] local
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
