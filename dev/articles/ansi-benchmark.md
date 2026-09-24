# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x56086fc91a60\>
\<environment: 0x5608707286c0\>

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
#> 1 ansi           46µs   50.7µs    18980.    99.6KB     19.0
#> 2 plain        46.8µs   50.8µs    18947.        0B     20.4
#> 3 base         11.4µs   12.9µs    74463.    48.6KB     22.3
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
#> 1 ansi         48.4µs   53.3µs    18120.        0B     21.4
#> 2 plain        47.1µs   51.5µs    18707.        0B     23.7
#> 3 base         13.5µs   15.7µs    60586.        0B     18.2
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
#> 1 ansi       119.23µs  129.1µs     7479.   77.03KB     14.7
#> 2 plain       96.39µs    104µs     9276.    8.91KB     14.7
#> 3 base         1.91µs    2.1µs   452492.        0B      0
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
#> 1 ansi          349µs    377µs     2621.   33.24KB     19.2
#> 2 plain         354µs    391µs     2514.    1.09KB     19.5
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
#>  1 cli_ansi          5.88µs   6.63µs   143705.    9.27KB    28.7 
#>  2 fansi_ansi        31.2µs  35.15µs    27323.    4.18KB    24.6 
#>  3 cli_plain         5.92µs   6.72µs   141192.        0B    28.2 
#>  4 fansi_plain      30.15µs  33.97µs    27805.      688B    16.7 
#>  5 cli_vec_ansi      7.34µs   7.96µs   121048.      448B    12.1 
#>  6 fansi_vec_ansi   40.74µs  44.83µs    21266.    5.02KB     8.51
#>  7 cli_vec_plain     7.86µs   8.54µs   113745.      448B    11.4 
#>  8 fansi_vec_plain   38.3µs   41.4µs    23315.    5.02KB    11.7 
#>  9 cli_txt_ansi      5.78µs   6.28µs   153568.        0B    15.4 
#> 10 fansi_txt_ansi   30.17µs  33.41µs    28550.      688B    11.4 
#> 11 cli_txt_plain     6.76µs   7.35µs   130496.        0B    13.1 
#> 12 fansi_txt_plain  38.57µs  41.83µs    23072.    5.02KB     9.23
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
#> 1 cli          59.8µs   62.9µs    15515.    22.7KB     4.06
#> 2 fansi       119.9µs  128.9µs     7643.    55.3KB     4.07
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
#>  1 cli_ansi          7.02µs   8.01µs   117402.        0B    11.7 
#>  2 fansi_ansi       93.08µs 100.89µs     9178.   38.84KB     8.27
#>  3 base_ansi       901.99ns 952.04ns   958728.        0B     0   
#>  4 cli_plain         6.78µs   7.65µs   126821.        0B    12.7 
#>  5 fansi_plain      92.91µs  99.81µs     9637.      688B     8.26
#>  6 base_plain      831.09ns 872.07ns  1035986.        0B     0   
#>  7 cli_vec_ansi     28.13µs  29.23µs    33375.      448B     3.34
#>  8 fansi_vec_ansi  115.33µs 125.32µs     7767.    5.02KB     6.21
#>  9 base_vec_ansi    18.46µs   18.7µs    52129.      448B     5.21
#> 10 cli_vec_plain    26.73µs  27.73µs    35075.      448B     3.51
#> 11 fansi_vec_plain 104.71µs 113.11µs     8479.    5.02KB     6.20
#> 12 base_vec_plain   10.82µs  10.98µs    89002.      448B     0   
#> 13 cli_txt_ansi     27.99µs  28.87µs    33400.        0B     3.34
#> 14 fansi_txt_ansi  105.87µs 113.64µs     8518.      688B     8.24
#> 15 base_txt_ansi    18.21µs   18.5µs    53022.        0B     0   
#> 16 cli_txt_plain    26.33µs  27.14µs    35892.        0B     3.59
#> 17 fansi_txt_plain  94.89µs  102.5µs     9443.      688B     8.23
#> 18 base_txt_plain   10.84µs  11.23µs    86298.        0B     0
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
#>  1 cli_ansi          8.53µs   9.46µs   101719.        0B    20.3 
#>  2 fansi_ansi       93.71µs 100.82µs     9440.      688B     8.36
#>  3 base_ansi         1.24µs   1.29µs   727449.        0B     0   
#>  4 cli_plain         8.57µs   9.71µs   100656.        0B    10.1 
#>  5 fansi_plain         93µs   99.3µs     9699.      688B     8.22
#>  6 base_plain           1µs   1.05µs   867615.        0B     0   
#>  7 cli_vec_ansi     34.53µs  36.78µs    25999.      448B     2.60
#>  8 fansi_vec_ansi  116.47µs 123.49µs     7822.    5.02KB     8.29
#>  9 base_vec_ansi    44.01µs  44.88µs    21888.      448B     0   
#> 10 cli_vec_plain    33.37µs  34.49µs    28370.      448B     2.84
#> 11 fansi_vec_plain 107.31µs  113.1µs     8567.    5.02KB     8.29
#> 12 base_vec_plain   22.95µs  23.39µs    41868.      448B     0   
#> 13 cli_txt_ansi     34.85µs  35.83µs    27304.        0B     2.73
#> 14 fansi_txt_ansi  108.83µs 115.65µs     8371.      688B     8.25
#> 15 base_txt_ansi    46.91µs  47.56µs    20680.        0B     0   
#> 16 cli_txt_plain    33.09µs  34.96µs    27674.        0B     2.77
#> 17 fansi_txt_plain  98.67µs 104.57µs     9264.      688B     8.21
#> 18 base_txt_plain   24.99µs   25.4µs    38282.        0B     0
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
#> 1 cli_ansi        6.89µs   7.61µs   124872.        0B    12.5 
#> 2 cli_plain       6.44µs   7.16µs   132394.        0B    13.2 
#> 3 cli_vec_ansi   32.72µs  33.78µs    28955.      848B     2.90
#> 4 cli_vec_plain  10.43µs  11.31µs    85643.      848B     8.57
#> 5 cli_txt_ansi   32.43µs  33.71µs    28876.        0B     2.89
#> 6 cli_txt_plain   7.37µs   8.24µs   117143.        0B    11.7
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
#>  1 cli_ansi          26.3µs   28.4µs    33970.        0B    13.6 
#>  2 fansi_ansi        28.3µs   31.3µs    30093.    7.24KB    12.0 
#>  3 cli_plain         25.9µs   28.2µs    34168.        0B    13.7 
#>  4 fansi_plain       27.9µs   30.3µs    31624.      688B    12.7 
#>  5 cli_vec_ansi      35.8µs   38.2µs    25372.      848B    12.7 
#>  6 fansi_vec_ansi      56µs     60µs    16163.    5.41KB     6.22
#>  7 cli_vec_plain     29.1µs     31µs    31171.      848B    12.5 
#>  8 fansi_vec_plain   37.1µs   40.2µs    23937.    4.59KB    10.2 
#>  9 cli_txt_ansi        35µs   36.6µs    26404.        0B    10.6 
#> 10 fansi_txt_ansi    44.3µs   46.6µs    20705.    5.12KB     8.29
#> 11 cli_txt_plain     27.2µs   28.7µs    33723.        0B    16.9 
#> 12 fansi_txt_plain     29µs   30.9µs    31234.      688B    12.5
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
#>  1 cli_ansi        167.66µs 177.68µs     5471.  104.86KB     8.32
#>  2 fansi_ansi      131.78µs 141.38µs     6862.  106.35KB    10.4 
#>  3 base_ansi         4.13µs   4.52µs   214140.      224B     0   
#>  4 cli_plain       166.14µs 177.54µs     5421.    8.09KB    10.4 
#>  5 fansi_plain     130.23µs 140.62µs     6815.    9.62KB    10.5 
#>  6 base_plain        3.52µs   3.89µs   248070.        0B     0   
#>  7 cli_vec_ansi      8.05ms   8.21ms      121.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.09ms   1.13ms      862.  846.81KB    17.6 
#>  9 base_vec_ansi    158.4µs 163.71µs     5973.    22.7KB     2.04
#> 10 cli_vec_plain     7.92ms    8.1ms      122.  823.77KB    11.6 
#> 11 fansi_vec_plain   1.03ms   1.08ms      913.  845.98KB    18.2 
#> 12 base_vec_plain   107.4µs 114.13µs     8644.      848B     2.02
#> 13 cli_txt_ansi      3.25ms   3.42ms      292.    63.6KB     0   
#> 14 fansi_txt_ansi    1.56ms   1.59ms      624.   35.05KB     2.03
#> 15 base_txt_ansi   136.13µs 144.93µs     6860.   18.47KB     2.03
#> 16 cli_txt_plain     2.48ms   2.58ms      386.    63.6KB     0   
#> 17 fansi_txt_plain 525.17µs 584.58µs     1670.    30.6KB     2.02
#> 18 base_txt_plain   89.84µs  93.14µs    10554.   11.05KB     2.02
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
#>  1 cli_ansi        150.81µs 160.85µs     5961.   33.84KB    10.5 
#>  2 fansi_ansi       55.63µs   60.3µs    15914.   31.42KB    12.6 
#>  3 base_ansi         1.08µs   1.16µs   797212.     4.2KB     0   
#>  4 cli_plain       148.46µs 159.15µs     5994.        0B    12.6 
#>  5 fansi_plain      55.14µs   59.9µs    16063.      872B    10.4 
#>  6 base_plain        1.01µs   1.07µs   852784.        0B     0   
#>  7 cli_vec_ansi    276.21µs  295.2µs     3329.   16.73KB     6.19
#>  8 fansi_vec_ansi  116.53µs    122µs     7959.    5.59KB     6.21
#>  9 base_vec_ansi    35.74µs  37.24µs    26089.      848B     2.61
#> 10 cli_vec_plain   234.63µs 248.03µs     3919.   16.73KB     6.21
#> 11 fansi_vec_plain 110.43µs 116.27µs     8349.    5.59KB     8.51
#> 12 base_vec_plain   30.08µs   30.9µs    31967.      848B     0   
#> 13 cli_txt_ansi    160.41µs 169.38µs     5729.        0B    10.4 
#> 14 fansi_txt_ansi   55.98µs  60.44µs    15962.      872B    10.4 
#> 15 base_txt_ansi      1.1µs   1.15µs   794105.        0B    79.4 
#> 16 cli_txt_plain   149.84µs 157.58µs     6167.        0B    10.3 
#> 17 fansi_txt_plain   54.3µs   59.9µs    16073.      872B    12.7 
#> 18 base_txt_plain    1.02µs   1.07µs   880243.        0B     0
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
#>  1 cli_ansi        426.78µs  457.2µs    2177.     6.18KB    10.4 
#>  2 fansi_ansi        98.5µs 104.74µs    9271.    97.33KB    12.5 
#>  3 base_ansi        39.21µs  41.44µs   23253.         0B     9.31
#>  4 cli_plain       277.24µs 297.56µs    3298.         0B    10.5 
#>  5 fansi_plain      98.33µs 106.26µs    9072.       872B    10.4 
#>  6 base_plain       32.22µs  34.52µs   27871.         0B    11.2 
#>  7 cli_vec_ansi     45.79ms  46.03ms      21.7   94.67KB    18.1 
#>  8 fansi_vec_ansi  239.69µs 250.13µs    3920.     7.25KB     6.16
#>  9 base_vec_ansi     2.32ms   2.42ms     413.    48.18KB    13.0 
#> 10 cli_vec_plain    29.78ms  30.51ms      32.8    2.48KB    10.9 
#> 11 fansi_vec_plain 193.23µs 201.64µs    4842.     6.42KB     8.27
#> 12 base_vec_plain    1.69ms   1.76ms     565.     47.4KB    10.6 
#> 13 cli_txt_ansi      28.2ms  28.58ms      34.9    4.27MB     7.48
#> 14 fansi_txt_ansi  227.24µs 237.19µs    4131.     6.77KB     4.12
#> 15 base_txt_ansi      1.3ms   1.34ms     735.   582.06KB    11.4 
#> 16 cli_txt_plain     1.33ms   1.38ms     717.   369.84KB     8.80
#> 17 fansi_txt_plain 179.37µs 188.14µs    5198.     2.51KB     6.15
#> 18 base_txt_plain  876.24µs 922.59µs    1061.   367.31KB     8.84
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
#>  1 cli_ansi          6.77µs   7.59µs   125395.   25.09KB    25.1 
#>  2 fansi_ansi       81.02µs  87.72µs    10977.   28.48KB    10.5 
#>  3 base_ansi         1.05µs   1.11µs   828516.        0B     0   
#>  4 cli_plain          6.8µs   7.68µs   124698.        0B    12.5 
#>  5 fansi_plain      80.47µs   86.9µs    11122.    1.98KB    10.4 
#>  6 base_plain        1.02µs   1.07µs   865964.        0B     0   
#>  7 cli_vec_ansi     26.65µs  27.94µs    34941.     1.7KB     3.49
#>  8 fansi_vec_ansi  119.04µs 125.42µs     7737.    8.86KB     8.38
#>  9 base_vec_ansi      6.4µs   6.73µs   144545.      848B     0   
#> 10 cli_vec_plain    23.21µs  24.42µs    39813.     1.7KB     3.98
#> 11 fansi_vec_plain 112.64µs 119.39µs     8118.    8.86KB     8.40
#> 12 base_vec_plain    6.08µs   6.39µs   152571.      848B     0   
#> 13 cli_txt_ansi      6.78µs   7.66µs   125698.        0B    12.6 
#> 14 fansi_txt_ansi   80.89µs  87.17µs    11109.    1.98KB    10.6 
#> 15 base_txt_ansi     6.49µs   6.56µs   148220.        0B    14.8 
#> 16 cli_txt_plain     7.67µs   8.43µs   114583.        0B    11.5 
#> 17 fansi_txt_plain   80.3µs  86.79µs    11146.    1.98KB    10.4 
#> 18 base_txt_plain    4.13µs   4.28µs   228744.        0B     0
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
#>  1 cli_ansi       113.62µs 120.59µs    8013.     12.1KB     6.13
#>  2 base_ansi        1.36µs   1.44µs  645464.         0B    64.6 
#>  3 cli_plain       92.35µs   97.5µs    9887.     8.91KB     6.13
#>  4 base_plain       1.03µs   1.07µs  875389.         0B     0   
#>  5 cli_vec_ansi     4.28ms    4.4ms     226.   838.95KB    13.3 
#>  6 base_vec_ansi   75.53µs  77.11µs   12825.       848B     0   
#>  7 cli_vec_plain    2.38ms   2.48ms     403.   817.08KB    15.3 
#>  8 base_vec_plain  44.91µs  46.07µs   21370.       848B     0   
#>  9 cli_txt_ansi    15.05ms  15.27ms      65.4   114.6KB     2.04
#> 10 base_txt_ansi   76.51µs  77.99µs   12609.         0B     0   
#> 11 cli_txt_plain  295.56µs 311.65µs    3153.    18.34KB     4.06
#> 12 base_txt_plain  42.96µs  43.47µs   22408.         0B     0
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
#>  1 cli_ansi        110.1µs  115.4µs     8390.        0B    12.4 
#>  2 base_ansi        17.2µs   18.3µs    52688.        0B    10.5 
#>  3 cli_plain       111.1µs  117.8µs     8202.        0B    10.3 
#>  4 base_plain       17.2µs   18.7µs    51535.        0B    10.3 
#>  5 cli_vec_ansi    209.9µs  224.1µs     4357.     7.2KB     6.15
#>  6 base_vec_ansi    60.2µs   66.2µs    14953.    1.66KB     4.03
#>  7 cli_vec_plain   198.1µs  210.1µs     4635.     7.2KB     6.18
#>  8 base_vec_plain   53.6µs   59.9µs    16540.    1.66KB     2.02
#>  9 cli_txt_ansi    188.8µs  198.2µs     4907.        0B     8.23
#> 10 base_txt_ansi    41.5µs   44.4µs    21839.        0B     4.37
#> 11 cli_txt_plain   170.6µs  179.6µs     5408.        0B     6.11
#> 12 base_txt_plain   36.1µs   37.9µs    25597.        0B     5.12
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
#> 1 cli          8.22µs    9.1µs   105379.        0B    21.1 
#> 2 base       871.02ns  912.1ns   975039.        0B     0   
#> 3 cli_vec     23.15µs   24.4µs    39880.      448B     3.99
#> 4 base_vec    11.46µs   11.7µs    83917.      448B     0   
#> 5 cli_txt     23.39µs   24.3µs    40081.        0B     4.01
#> 6 base_txt    12.51µs     13µs    75777.        0B     0
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
#> 1 cli          8.23µs   9.04µs   106981.        0B    10.7 
#> 2 base         1.31µs   1.36µs   679112.        0B     0   
#> 3 cli_vec     28.65µs  29.86µs    32628.      448B     3.26
#> 4 base_vec    50.51µs  51.04µs    19248.      448B     0   
#> 5 cli_txt     29.11µs  30.08µs    32393.        0B     3.24
#> 6 base_txt    86.41µs  87.27µs    11312.        0B     2.01
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
#> 1 cli          8.69µs    9.6µs   100519.        0B    10.1 
#> 2 base       861.01ns  902.1ns   985427.        0B     0   
#> 3 cli_vec     19.51µs   20.8µs    46827.      448B     9.37
#> 4 base_vec    11.49µs   11.7µs    83848.      448B     0   
#> 5 cli_txt     20.35µs   21.5µs    45291.        0B     4.53
#> 6 base_txt    12.53µs     13µs    75317.        0B     0
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
#> 1 cli           6.4µs   7.14µs   133323.    22.2KB    26.7 
#> 2 base         1.07µs   1.14µs   814453.        0B     0   
#> 3 cli_vec     28.95µs  30.28µs    32289.     1.7KB     3.23
#> 4 base_vec     8.12µs   8.41µs   116476.      848B     0   
#> 5 cli_txt       6.4µs    7.2µs   133360.        0B    13.3 
#> 6 base_txt     5.49µs   5.55µs   174036.        0B     0
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
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
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
