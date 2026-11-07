# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5713d7ae7060\>
\<environment: 0x5713d8579850\>

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
#> 1 ansi         48.8µs   53.8µs    17930.    99.6KB     19.3
#> 2 plain        47.8µs   54.3µs    17618.        0B     20.9
#> 3 base         12.2µs     14µs    68559.    48.6KB     13.7
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
#> 1 ansi         50.5µs   55.7µs    17308.        0B     21.7
#> 2 plain        50.3µs   55.5µs    17274.        0B     19.6
#> 3 base         14.2µs   16.3µs    58805.        0B     23.5
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
#> 1 ansi       122.61µs 135.44µs     7090.   77.03KB     15.0
#> 2 plain       97.85µs 109.17µs     8700.    8.91KB     12.8
#> 3 base         1.63µs   1.96µs   446923.        0B      0
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
#> 1 ansi          372µs    416µs     2346.   33.23KB     17.4
#> 2 plain         363µs    404µs     2409.    1.09KB     17.4
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
#>  1 cli_ansi          5.91µs   6.74µs   142006.    9.27KB    28.4 
#>  2 fansi_ansi       32.91µs  39.24µs    23409.    4.18KB    21.1 
#>  3 cli_plain         6.06µs   7.44µs   123211.        0B    24.6 
#>  4 fansi_plain      32.56µs  37.86µs    24874.      688B    24.1 
#>  5 cli_vec_ansi       7.6µs   8.74µs   101968.      448B     0   
#>  6 fansi_vec_ansi   41.77µs  46.92µs    20157.    5.02KB    10.7 
#>  7 cli_vec_plain      8.1µs   9.07µs   104842.      448B     0   
#>  8 fansi_vec_plain  40.98µs  45.83µs    20390.    5.02KB    10.7 
#>  9 cli_txt_ansi      5.88µs   6.61µs   143420.        0B    14.3 
#> 10 fansi_txt_ansi   32.01µs   36.6µs    25411.      688B    10.2 
#> 11 cli_txt_plain     6.93µs   8.15µs   115025.        0B    11.5 
#> 12 fansi_txt_plain  41.84µs  47.56µs    19543.    5.02KB     8.45
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
#> 1 cli          54.5µs   59.1µs    16473.    22.7KB     4.13
#> 2 fansi       113.5µs  125.4µs     7699.    55.3KB     4.08
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
#>  1 cli_ansi          7.22µs    8.6µs   108018.        0B    10.8 
#>  2 fansi_ansi       97.73µs 108.66µs     8786.   38.84KB     6.17
#>  3 base_ansi       891.04ns   1.08µs   750498.        0B     0   
#>  4 cli_plain         7.12µs    8.9µs   104161.        0B    10.4 
#>  5 fansi_plain      95.69µs 116.71µs     8331.      688B     8.34
#>  6 base_plain       802.1ns 972.07ns   810380.        0B     0   
#>  7 cli_vec_ansi     29.36µs  31.52µs    30785.      448B     3.08
#>  8 fansi_vec_ansi  115.69µs 124.71µs     7721.    5.02KB     6.19
#>  9 base_vec_ansi    14.61µs  15.14µs    64279.      448B     0   
#> 10 cli_vec_plain    28.41µs  30.21µs    32224.      448B     3.22
#> 11 fansi_vec_plain 107.73µs 117.62µs     8112.    5.02KB     8.41
#> 12 base_vec_plain    8.86µs    9.1µs   106035.      448B     0   
#> 13 cli_txt_ansi     29.73µs  31.79µs    30387.        0B     3.04
#> 14 fansi_txt_ansi  109.44µs 119.78µs     7872.      688B     6.17
#> 15 base_txt_ansi    14.59µs     15µs    65396.        0B     0   
#> 16 cli_txt_plain    27.45µs  29.34µs    33239.        0B     3.32
#> 17 fansi_txt_plain   97.4µs 105.39µs     9106.      688B     8.26
#> 18 base_txt_plain    8.57µs   9.18µs   106852.        0B     0
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
#>  1 cli_ansi          8.73µs  10.07µs    92465.        0B    18.5 
#>  2 fansi_ansi       94.64µs 104.36µs     9224.      688B     8.26
#>  3 base_ansi         1.24µs   1.31µs   684437.        0B     0   
#>  4 cli_plain         9.01µs  10.07µs    95937.        0B     9.59
#>  5 fansi_plain      95.32µs  104.4µs     9156.      688B     8.43
#>  6 base_plain        1.01µs   1.08µs   831253.        0B     0   
#>  7 cli_vec_ansi      36.4µs   39.5µs    24566.      448B     2.46
#>  8 fansi_vec_ansi  119.03µs 130.04µs     7388.    5.02KB     6.21
#>  9 base_vec_ansi    40.85µs  42.13µs    23346.      448B     0   
#> 10 cli_vec_plain    34.34µs  37.04µs    26091.      448B     2.61
#> 11 fansi_vec_plain 109.56µs 123.12µs     7793.    5.02KB     8.39
#> 12 base_vec_plain   20.81µs  21.66µs    45230.      448B     0   
#> 13 cli_txt_ansi     35.81µs  37.77µs    25807.        0B     2.58
#> 14 fansi_txt_ansi  110.75µs 122.63µs     7767.      688B     6.17
#> 15 base_txt_ansi    43.27µs  44.54µs    22192.        0B     0   
#> 16 cli_txt_plain     33.9µs  36.01µs    26936.        0B     5.39
#> 17 fansi_txt_plain  99.92µs 109.29µs     8809.      688B     6.17
#> 18 base_txt_plain    22.8µs  23.62µs    41758.        0B     4.18
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
#> 1 cli_ansi        6.98µs   7.91µs   121791.        0B    12.2 
#> 2 cli_plain       6.66µs   7.61µs   125614.        0B    12.6 
#> 3 cli_vec_ansi   30.95µs  32.78µs    29794.      848B     0   
#> 4 cli_vec_plain  10.69µs  11.99µs    80640.      848B     8.06
#> 5 cli_txt_ansi   29.74µs  31.66µs    30862.        0B     3.09
#> 6 cli_txt_plain   7.63µs    8.6µs   111640.        0B    11.2
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
#>  1 cli_ansi          27.4µs   30.3µs    31794.        0B    15.9 
#>  2 fansi_ansi        29.5µs   33.1µs    28593.    7.24KB    11.4 
#>  3 cli_plain         27.3µs     30µs    32107.        0B    12.8 
#>  4 fansi_plain       29.2µs   32.9µs    28927.      688B    11.6 
#>  5 cli_vec_ansi      35.2µs     39µs    24789.      848B     9.92
#>  6 fansi_vec_ansi    56.3µs   60.5µs    15844.    5.41KB     6.27
#>  7 cli_vec_plain     29.7µs   32.6µs    29573.      848B    14.8 
#>  8 fansi_vec_plain   39.1µs   42.8µs    22438.    4.59KB     8.98
#>  9 cli_txt_ansi      34.8µs   37.6µs    25658.        0B    10.3 
#> 10 fansi_txt_ansi    45.6µs   49.6µs    19366.    5.12KB     8.03
#> 11 cli_txt_plain     27.7µs   29.6µs    32686.        0B    13.1 
#> 12 fansi_txt_plain   30.1µs   32.4µs    29852.      688B    11.9
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
#>  1 cli_ansi        169.35µs 180.08µs     5385.  104.86KB    10.5 
#>  2 fansi_ansi      132.74µs 144.17µs     6722.  106.35KB     8.31
#>  3 base_ansi         3.62µs   3.93µs   246478.      224B    24.7 
#>  4 cli_plain       167.92µs 180.55µs     5372.    8.09KB     8.40
#>  5 fansi_plain     132.64µs 144.12µs     6720.    9.62KB    10.5 
#>  6 base_plain        3.29µs   3.54µs   269906.        0B     0   
#>  7 cli_vec_ansi      8.05ms   8.53ms      117.  823.77KB    11.3 
#>  8 fansi_vec_ansi    1.07ms   1.13ms      844.  846.81KB    15.3 
#>  9 base_vec_ansi   151.77µs 157.87µs     6194.    22.7KB     4.17
#> 10 cli_vec_plain     8.06ms   8.34ms      119.  823.77KB    11.5 
#> 11 fansi_vec_plain   1.02ms   1.06ms      930.  845.98KB    17.9 
#> 12 base_vec_plain  103.64µs  107.6µs     9187.      848B     2.02
#> 13 cli_txt_ansi      3.27ms   3.32ms      300.    63.6KB     0   
#> 14 fansi_txt_ansi    1.63ms   1.65ms      602.   35.05KB     2.03
#> 15 base_txt_ansi   143.85µs 151.79µs     6512.   18.47KB     2.03
#> 16 cli_txt_plain     2.46ms   2.51ms      397.    63.6KB     0   
#> 17 fansi_txt_plain 518.87µs 540.44µs     1834.    30.6KB     2.02
#> 18 base_txt_plain   90.22µs  92.34µs    10652.   11.05KB     4.09
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
#>  1 cli_ansi         157.3µs 167.48µs     5806.   33.84KB    10.7 
#>  2 fansi_ansi       55.35µs  59.88µs    16138.   31.42KB    12.6 
#>  3 base_ansi         1.04µs   1.09µs   858697.     4.2KB     0   
#>  4 cli_plain       154.27µs 163.13µs     5952.        0B    10.4 
#>  5 fansi_plain      54.97µs  59.91µs    16140.      872B    12.6 
#>  6 base_plain      962.06ns   1.02µs   903037.        0B     0   
#>  7 cli_vec_ansi    280.61µs 296.06µs     3322.   16.73KB     6.19
#>  8 fansi_vec_ansi  116.25µs 121.31µs     8032.    5.59KB     6.19
#>  9 base_vec_ansi    34.87µs  35.35µs    27972.      848B     0   
#> 10 cli_vec_plain   242.16µs  259.4µs     3775.   16.73KB     8.36
#> 11 fansi_vec_plain 107.69µs 113.97µs     8548.    5.59KB     6.20
#> 12 base_vec_plain   28.34µs  28.59µs    34303.      848B     0   
#> 13 cli_txt_ansi     164.7µs 174.97µs     5562.        0B    10.4 
#> 14 fansi_txt_ansi   55.06µs  59.59µs    16179.      872B    12.7 
#> 15 base_txt_ansi     1.08µs   1.13µs   818360.        0B     0   
#> 16 cli_txt_plain   155.33µs 164.23µs     5919.        0B    12.5 
#> 17 fansi_txt_plain  54.79µs  59.57µs    16288.      872B    10.4 
#> 18 base_txt_plain  981.96ns   1.04µs   879697.        0B     0
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
#>  1 cli_ansi        428.43µs 460.88µs    2146.     6.18KB    10.2 
#>  2 fansi_ansi       99.53µs  105.3µs    9235.    97.33KB    12.5 
#>  3 base_ansi        38.41µs  40.68µs   23714.         0B     9.49
#>  4 cli_plain       280.75µs 300.49µs    3247.         0B    10.4 
#>  5 fansi_plain      98.42µs 104.17µs    9344.       872B    10.3 
#>  6 base_plain       31.23µs  33.51µs   28657.         0B    11.5 
#>  7 cli_vec_ansi     45.01ms   46.1ms      21.7   94.67KB    18.1 
#>  8 fansi_vec_ansi   232.7µs 242.51µs    4064.     7.25KB     6.15
#>  9 base_vec_ansi     2.29ms   2.37ms     420.    48.18KB    12.9 
#> 10 cli_vec_plain    29.95ms  30.65ms      32.6    2.48KB    14.8 
#> 11 fansi_vec_plain 192.25µs 201.32µs    4848.     6.42KB     6.16
#> 12 base_vec_plain    1.68ms   1.75ms     566.     47.4KB    10.7 
#> 13 cli_txt_ansi     25.09ms  25.72ms      38.9    4.27MB     7.29
#> 14 fansi_txt_ansi  222.41µs  232.1µs    4222.     6.77KB     6.14
#> 15 base_txt_ansi     1.27ms   1.31ms     743.   582.06KB     8.90
#> 16 cli_txt_plain     1.29ms   1.36ms     721.   369.84KB     8.93
#> 17 fansi_txt_plain 174.86µs 184.05µs    5317.     2.51KB     6.19
#> 18 base_txt_plain  876.28µs 912.52µs    1072.   367.31KB    11.1
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
#>  1 cli_ansi          6.56µs   7.45µs   129799.   25.09KB    13.0 
#>  2 fansi_ansi       81.13µs  87.59µs    11076.   28.48KB    10.4 
#>  3 base_ansi            1µs   1.06µs   842034.        0B     0   
#>  4 cli_plain         6.81µs   7.64µs   125775.        0B    12.6 
#>  5 fansi_plain      81.08µs  87.46µs    11078.    1.98KB    10.6 
#>  6 base_plain      961.94ns   1.02µs   855172.        0B     0   
#>  7 cli_vec_ansi     27.05µs  28.27µs    34337.     1.7KB     6.87
#>  8 fansi_vec_ansi  115.55µs 122.34µs     7956.    8.86KB     6.22
#>  9 base_vec_ansi     5.83µs   5.99µs   163046.      848B     0   
#> 10 cli_vec_plain     23.5µs  24.67µs    39517.     1.7KB     7.91
#> 11 fansi_vec_plain 110.79µs 117.48µs     8265.    8.86KB     6.22
#> 12 base_vec_plain    5.51µs   5.82µs   165182.      848B    16.5 
#> 13 cli_txt_ansi      6.75µs   7.54µs   127981.        0B    12.8 
#> 14 fansi_txt_ansi   80.89µs  87.04µs    11116.    1.98KB    10.4 
#> 15 base_txt_ansi     5.12µs    5.2µs   187222.        0B     0   
#> 16 cli_txt_plain     7.54µs   8.37µs   115854.        0B    11.6 
#> 17 fansi_txt_plain  79.93µs  85.83µs    11351.    1.98KB    10.1 
#> 18 base_txt_plain    3.35µs   3.43µs   283062.        0B    28.3
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
#>  1 cli_ansi       109.13µs 115.48µs    8390.     12.1KB     8.25
#>  2 base_ansi        1.29µs   1.34µs  712827.         0B     0   
#>  3 cli_plain       89.07µs   94.1µs   10289.     8.91KB     8.24
#>  4 base_plain     981.03ns   1.02µs  929594.         0B     0   
#>  5 cli_vec_ansi      4.3ms   4.46ms     223.   838.95KB    13.4 
#>  6 base_vec_ansi   74.75µs  75.41µs   13101.       848B     0   
#>  7 cli_vec_plain    2.38ms   2.48ms     400.   817.08KB    13.2 
#>  8 base_vec_plain  44.81µs  45.82µs   21552.       848B     0   
#>  9 cli_txt_ansi    12.75ms  12.89ms      77.4   114.6KB     4.18
#> 10 base_txt_ansi   76.46µs  76.72µs   12859.         0B     0   
#> 11 cli_txt_plain  285.95µs 299.37µs    3268.    18.34KB     2.02
#> 12 base_txt_plain  42.66µs  43.02µs   22843.         0B     0
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
#>  1 cli_ansi        114.3µs  121.5µs     7981.        0B    10.3 
#>  2 base_ansi        17.2µs   18.7µs    51910.        0B    10.4 
#>  3 cli_plain       114.2µs  121.5µs     7981.        0B    10.4 
#>  4 base_plain         17µs   18.4µs    52577.        0B    10.5 
#>  5 cli_vec_ansi    202.4µs  212.6µs     4586.     7.2KB     6.18
#>  6 base_vec_ansi    54.1µs   59.2µs    16530.    1.66KB     4.07
#>  7 cli_vec_plain     190µs  198.4µs     4908.     7.2KB     6.17
#>  8 base_vec_plain   51.9µs   53.9µs    18093.    1.66KB     4.07
#>  9 cli_txt_ansi      178µs    187µs     5208.        0B     8.25
#> 10 base_txt_ansi    39.3µs   41.1µs    23609.        0B     4.72
#> 11 cli_txt_plain   165.6µs  174.8µs     5571.        0B     6.14
#> 12 base_txt_plain   34.7µs   36.6µs    26499.        0B     5.30
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
#> 1 cli          8.21µs   9.11µs   105763.        0B    10.6 
#> 2 base       840.98ns 901.99ns   982945.        0B     0   
#> 3 cli_vec     23.89µs  25.32µs    38463.      448B     3.85
#> 4 base_vec    11.61µs  11.78µs    83304.      448B     0   
#> 5 cli_txt     24.12µs  25.24µs    38347.        0B     3.84
#> 6 base_txt    12.51µs  12.69µs    77283.        0B     7.73
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
#> 1 cli          7.92µs   9.09µs   105874.        0B    10.6 
#> 2 base         1.27µs   1.35µs   661632.        0B     0   
#> 3 cli_vec     29.18µs  30.55µs    31879.      448B     3.19
#> 4 base_vec    49.96µs  50.65µs    19490.      448B     0   
#> 5 cli_txt     29.89µs  30.96µs    31465.        0B     6.29
#> 6 base_txt     85.4µs  86.46µs    11442.        0B     0
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
#> 1 cli          8.77µs   9.67µs   100276.        0B    10.0 
#> 2 base       831.09ns 892.09ns  1007045.        0B     0   
#> 3 cli_vec     19.69µs  20.83µs    46634.      448B     9.33
#> 4 base_vec    11.61µs   11.8µs    83057.      448B     0   
#> 5 cli_txt     20.37µs  21.34µs    45729.        0B     4.57
#> 6 base_txt    12.51µs  12.63µs    77864.        0B     0
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
#> 1 cli          6.34µs   7.16µs   133406.    22.2KB    26.7 
#> 2 base         1.01µs   1.08µs   854826.        0B     0   
#> 3 cli_vec     29.11µs  30.29µs    32319.     1.7KB     3.23
#> 4 base_vec     7.29µs   7.62µs   128274.      848B     0   
#> 5 cli_txt       6.3µs   7.15µs   133734.        0B    13.4 
#> 6 base_txt     5.43µs   5.56µs   173762.        0B    17.4
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.2 (2026-10-29)
#>  os       Ubuntu 26.04.1 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-11-07
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-07 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.2)
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
#>  xfun          0.62       2026-10-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.2/lib/R/site-library
#>  [3] /opt/R/4.6.2/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
