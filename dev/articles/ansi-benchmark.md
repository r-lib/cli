# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55989483b038\>
\<environment: 0x5598952dbf70\>

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
#> 1 ansi        20.24µs  21.83µs    45063.    99.6KB     45.1
#> 2 plain       19.95µs   21.5µs    45669.        0B     45.7
#> 3 base         5.91µs   6.44µs   152217.    48.6KB     45.7
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
#> 1 ansi        20.82µs  22.62µs    43280.        0B     52.0
#> 2 plain       20.76µs  22.18µs    44423.        0B     53.4
#> 3 base         6.72µs   7.35µs   133687.        0B     53.5
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
#> 1 ansi           47µs  50.57µs    19100.   76.15KB     37.7
#> 2 plain        36.1µs  38.48µs    25492.    8.73KB     38.3
#> 3 base          1.2µs   1.27µs   756764.        0B      0
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
#> 1 ansi          140µs    152µs     6447.   33.23KB     36.3
#> 2 plain         144µs    154µs     6454.    1.09KB     24.9
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
#>  1 cli_ansi          3.21µs   3.62µs   267186.    9.27KB     26.7
#>  2 fansi_ansi       15.27µs  16.79µs    57644.    4.18KB     23.1
#>  3 cli_plain         3.21µs   3.71µs   254593.        0B     25.5
#>  4 fansi_plain      15.19µs  16.75µs    58516.      688B     29.3
#>  5 cli_vec_ansi      3.95µs   4.39µs   221577.      448B     22.2
#>  6 fansi_vec_ansi   19.79µs  21.68µs    45125.    5.02KB     18.1
#>  7 cli_vec_plain     4.11µs    4.5µs   215598.      448B     21.6
#>  8 fansi_vec_plain   19.2µs  20.89µs    47101.    5.02KB     18.8
#>  9 cli_txt_ansi      3.13µs    3.5µs   280028.        0B     28.0
#> 10 fansi_txt_ansi   15.01µs  16.36µs    60038.      688B     30.0
#> 11 cli_txt_plain     3.77µs   4.09µs   239579.        0B     24.0
#> 12 fansi_txt_plain  19.57µs  21.01µs    46698.    5.02KB     18.7
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
#> 1 cli          32.5µs   33.7µs    29238.    22.7KB     8.77
#> 2 fansi        60.5µs   63.4µs    15555.    55.3KB    10.2
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
#>  1 cli_ansi          3.63µs   4.15µs   235617.        0B    23.6 
#>  2 fansi_ansi       37.16µs  40.33µs    24408.   38.84KB    22.0 
#>  3 base_ansi       550.99ns 610.95ns  1548282.        0B     0   
#>  4 cli_plain         3.65µs    4.1µs   237999.        0B    23.8 
#>  5 fansi_plain      37.37µs  40.27µs    24473.      688B    22.0 
#>  6 base_plain      481.03ns  541.1ns  1729149.        0B     0   
#>  7 cli_vec_ansi     14.19µs  14.81µs    66812.      448B     6.68
#>  8 fansi_vec_ansi    48.2µs  52.81µs    18696.    5.02KB    16.6 
#>  9 base_vec_ansi     8.46µs  10.87µs    91818.      448B     0   
#> 10 cli_vec_plain    13.92µs   14.5µs    68190.      448B     6.82
#> 11 fansi_vec_plain  43.02µs  46.55µs    21153.    5.02KB    19.1 
#> 12 base_vec_plain    5.03µs   5.83µs   169878.      448B     0   
#> 13 cli_txt_ansi     14.31µs  14.89µs    66418.        0B     6.64
#> 14 fansi_txt_ansi   44.37µs  47.22µs    20849.      688B    16.7 
#> 15 base_txt_ansi     8.19µs   10.4µs    94701.        0B     9.47
#> 16 cli_txt_plain    13.83µs  14.66µs    67766.        0B     6.78
#> 17 fansi_txt_plain  38.89µs  41.99µs    23475.      688B    18.8 
#> 18 base_txt_plain     4.9µs   5.95µs   165975.        0B    16.6
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
#>  1 cli_ansi          4.36µs   4.99µs   196700.        0B    19.7 
#>  2 fansi_ansi       37.24µs  40.35µs    24420.      688B    22.0 
#>  3 base_ansi        741.1ns  841.1ns  1143598.        0B     0   
#>  4 cli_plain         4.36µs   4.87µs   201465.        0B    20.1 
#>  5 fansi_plain      36.83µs   39.4µs    24901.      688B    22.4 
#>  6 base_plain      620.96ns 691.04ns  1359163.        0B     0   
#>  7 cli_vec_ansi     17.65µs  18.35µs    53460.      448B     5.35
#>  8 fansi_vec_ansi   49.41µs  51.98µs    18941.    5.02KB    16.5 
#>  9 base_vec_ansi    24.56µs  26.75µs    37005.      448B     3.70
#> 10 cli_vec_plain    18.02µs  19.01µs    52109.      448B     5.21
#> 11 fansi_vec_plain  44.14µs  47.71µs    20684.    5.02KB    18.8 
#> 12 base_vec_plain    14.1µs  14.68µs    67373.      448B     0   
#> 13 cli_txt_ansi     18.06µs  18.65µs    53044.        0B     5.30
#> 14 fansi_txt_ansi   45.68µs   48.9µs    20133.      688B    18.5 
#> 15 base_txt_ansi    26.99µs  28.58µs    34647.        0B     0   
#> 16 cli_txt_plain    17.71µs  18.32µs    54021.        0B     5.40
#> 17 fansi_txt_plain  39.76µs  42.53µs    23187.      688B    20.9 
#> 18 base_txt_plain   15.03µs  15.96µs    61990.        0B     0
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
#> 1 cli_ansi        3.58µs   4.05µs   240629.        0B    24.1 
#> 2 cli_plain       3.33µs    3.8µs   257194.        0B    25.7 
#> 3 cli_vec_ansi   16.61µs   17.3µs    57225.      848B     5.72
#> 4 cli_vec_plain   5.47µs   5.99µs   163496.      848B    16.4 
#> 5 cli_txt_ansi   17.23µs  18.02µs    54707.        0B     5.47
#> 6 cli_txt_plain   3.95µs   4.37µs   224704.        0B     0
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
#>  1 cli_ansi          13.3µs   14.6µs    67092.        0B     26.8
#>  2 fansi_ansi          14µs   15.4µs    63512.    7.24KB     25.4
#>  3 cli_plain         13.1µs   14.4µs    67866.        0B     27.2
#>  4 fansi_plain       13.8µs   15.1µs    64846.      688B     32.4
#>  5 cli_vec_ansi      18.3µs   19.7µs    49859.      848B     20.0
#>  6 fansi_vec_ansi    27.9µs   29.6µs    33367.    5.41KB     13.4
#>  7 cli_vec_plain     14.7µs   15.9µs    61798.      848B     24.7
#>  8 fansi_vec_plain   19.3µs   20.6µs    47630.    4.59KB     23.8
#>  9 cli_txt_ansi        19µs   20.4µs    48053.        0B     19.2
#> 10 fansi_txt_ansi    23.1µs   24.5µs    40185.    5.12KB     16.1
#> 11 cli_txt_plain     13.6µs   14.8µs    66237.        0B     26.5
#> 12 fansi_txt_plain   14.4µs   15.7µs    62104.      688B     24.9
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
#>  1 cli_ansi         64.96µs  70.38µs    13966.  104.86KB    24.8 
#>  2 fansi_ansi       57.77µs  61.87µs    15930.  106.35KB    24.4 
#>  3 base_ansi         2.32µs   2.48µs   393886.      224B     0   
#>  4 cli_plain        64.44µs  68.67µs    14283.    8.09KB    24.8 
#>  5 fansi_plain      56.72µs  61.33µs    16089.    9.62KB    25.2 
#>  6 base_plain        2.06µs   2.23µs   436297.        0B     0   
#>  7 cli_vec_ansi      3.52ms    3.6ms      277.  823.77KB    27.5 
#>  8 fansi_vec_ansi   541.3µs 575.61µs     1642.  846.81KB    28.3 
#>  9 base_vec_ansi    84.81µs  88.17µs    11119.    22.7KB     6.24
#> 10 cli_vec_plain     3.54ms   3.64ms      272.  823.77KB    25.4 
#> 11 fansi_vec_plain 504.69µs  535.9µs     1856.  845.98KB    34.9 
#> 12 base_vec_plain   53.85µs  57.95µs    16962.      848B     6.09
#> 13 cli_txt_ansi      1.66ms   1.71ms      576.    63.6KB     0   
#> 14 fansi_txt_ansi  868.86µs 885.45µs     1126.   35.05KB     2.02
#> 15 base_txt_ansi    71.74µs  77.95µs    12827.   18.47KB     4.06
#> 16 cli_txt_plain     1.25ms   1.28ms      775.    63.6KB     2.01
#> 17 fansi_txt_plain 272.66µs 279.68µs     3549.    30.6KB     6.11
#> 18 base_txt_plain   45.05µs  46.41µs    21272.   11.05KB     4.26
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
#>  1 cli_ansi          69.2µs   74.5µs    13143.   33.84KB     25.1
#>  2 fansi_ansi        26.7µs   29.1µs    33701.   31.42KB     27.0
#>  3 base_ansi        610.9ns  690.9ns  1393003.     4.2KB      0  
#>  4 cli_plain         68.6µs   74.5µs    13288.        0B     26.9
#>  5 fansi_plain       25.9µs   28.3µs    34524.      872B     24.2
#>  6 base_plain       570.9ns    641ns  1498608.        0B      0  
#>  7 cli_vec_ansi     133.1µs    141µs     7049.   16.73KB     14.4
#>  8 fansi_vec_ansi    62.3µs   64.7µs    15246.    5.59KB     12.3
#>  9 base_vec_ansi     20.2µs   20.6µs    47716.      848B      0  
#> 10 cli_vec_plain    113.5µs  118.8µs     8294.   16.73KB     16.8
#> 11 fansi_vec_plain     56µs   58.4µs    16886.    5.59KB     12.3
#> 12 base_vec_plain    16.7µs   17.3µs    57504.      848B      0  
#> 13 cli_txt_ansi      73.5µs   77.8µs    12710.        0B     27.1
#> 14 fansi_txt_ansi    26.1µs   28.7µs    34263.      872B     24.0
#> 15 base_txt_ansi      631ns  701.1ns  1351860.        0B      0  
#> 16 cli_txt_plain     68.6µs   72.7µs    13548.        0B     27.2
#> 17 fansi_txt_plain   26.5µs   28.6µs    34388.      872B     24.1
#> 18 base_txt_plain     571ns  660.9ns  1454394.        0B      0
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
#>  1 cli_ansi        188.43µs 196.91µs    5024.     6.18KB     25.3
#>  2 fansi_ansi       47.56µs  52.29µs   18867.    97.33KB     22.8
#>  3 base_ansi        16.93µs  18.26µs   53727.         0B     26.9
#>  4 cli_plain       115.31µs 123.13µs    8017.         0B     25.0
#>  5 fansi_plain      46.48µs  51.01µs   19372.       872B     21.8
#>  6 base_plain        13.9µs  15.02µs   65394.         0B     26.2
#>  7 cli_vec_ansi     19.39ms  19.64ms      50.7   94.67KB     46.8
#>  8 fansi_vec_ansi  123.48µs  128.8µs    7646.     7.25KB     12.5
#>  9 base_vec_ansi     1.17ms   1.21ms     821.    48.18KB     23.5
#> 10 cli_vec_plain    12.22ms   12.4ms      80.5    2.48KB     35.8
#> 11 fansi_vec_plain 100.59µs 105.88µs    9337.     6.42KB     14.4
#> 12 base_vec_plain  845.88µs 877.17µs    1133.     47.4KB     23.7
#> 13 cli_txt_ansi      13.3ms  13.61ms      73.0    4.27MB     11.8
#> 14 fansi_txt_ansi  121.39µs 126.26µs    7850.     6.77KB     10.2
#> 15 base_txt_ansi   658.79µs 694.91µs    1422.   582.06KB     18.1
#> 16 cli_txt_plain   649.11µs 677.76µs    1457.   369.84KB     17.8
#> 17 fansi_txt_plain  96.18µs 100.91µs    9799.     2.51KB     12.3
#> 18 base_txt_plain  454.43µs 478.88µs    2051.   367.31KB     20.5
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
#>  1 cli_ansi          3.59µs   4.18µs   229323.   25.09KB    22.9 
#>  2 fansi_ansi        37.9µs  43.01µs    23016.   28.48KB    23.0 
#>  3 base_ansi       610.95ns 661.01ns  1405723.        0B     0   
#>  4 cli_plain         3.56µs   4.08µs   239570.        0B    24.0 
#>  5 fansi_plain      38.18µs  42.85µs    23109.    1.98KB    23.4 
#>  6 base_plain      591.04ns 631.09ns  1472273.        0B     0   
#>  7 cli_vec_ansi     13.94µs  14.63µs    67588.     1.7KB     6.76
#>  8 fansi_vec_ansi   57.23µs  60.08µs    16446.    8.86KB    14.5 
#>  9 base_vec_ansi      3.5µs   3.91µs   253361.      848B    25.3 
#> 10 cli_vec_plain    12.64µs  13.22µs    74765.     1.7KB     7.48
#> 11 fansi_vec_plain  53.99µs   57.2µs    17249.    8.86KB    16.7 
#> 12 base_vec_plain    3.44µs   3.82µs   261049.      848B     0   
#> 13 cli_txt_ansi      3.56µs   3.96µs   246609.        0B    24.7 
#> 14 fansi_txt_ansi   37.58µs  42.26µs    23490.    1.98KB    23.5 
#> 15 base_txt_ansi      2.6µs   2.73µs   335222.        0B     0   
#> 16 cli_txt_plain     4.17µs   4.72µs   206672.        0B    20.7 
#> 17 fansi_txt_plain  37.58µs  42.24µs    23486.    1.98KB    23.5 
#> 18 base_txt_plain    1.85µs   1.91µs   485472.        0B     0
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
#>  1 cli_ansi        45.35µs   48.4µs    20373.   11.88KB    20.6 
#>  2 base_ansi      801.05ns    851ns  1143503.        0B     0   
#>  3 cli_plain       35.61µs  37.99µs    25916.    8.73KB    18.2 
#>  4 base_plain     601.05ns  641.1ns  1497025.        0B   150.  
#>  5 cli_vec_ansi     2.27ms   2.35ms      424.  838.77KB    24.4 
#>  6 base_vec_ansi   43.83µs   44.3µs    22423.      848B     0   
#>  7 cli_vec_plain    1.27ms   1.32ms      754.   816.9KB    28.4 
#>  8 base_vec_plain  23.82µs  24.73µs    40214.      848B     0   
#>  9 cli_txt_ansi     7.91ms   7.98ms      125.  114.42KB     6.37
#> 10 base_txt_ansi   45.54µs     46µs    21415.        0B     0   
#> 11 cli_txt_plain  136.48µs 140.77µs     7039.   18.16KB     4.04
#> 12 base_txt_plain  26.02µs  26.67µs    37306.        0B     0
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
#>  1 cli_ansi        48.04µs  52.04µs    18882.        0B    24.7 
#>  2 base_ansi        8.16µs   9.02µs   108499.        0B    32.6 
#>  3 cli_plain       48.21µs   51.8µs    18985.        0B    25.1 
#>  4 base_plain       8.15µs   9.01µs   108923.        0B    21.8 
#>  5 cli_vec_ansi    96.93µs 102.78µs     9646.     7.2KB    14.4 
#>  6 base_vec_ansi   28.83µs   31.7µs    31629.    1.66KB     6.33
#>  7 cli_vec_plain   90.26µs  94.39µs    10483.     7.2KB    14.3 
#>  8 base_vec_plain  26.04µs  28.96µs    34560.    1.66KB     6.91
#>  9 cli_txt_ansi    85.32µs  88.79µs    11125.        0B    16.3 
#> 10 base_txt_ansi   19.38µs  20.27µs    48704.        0B     9.74
#> 11 cli_txt_plain   75.11µs  79.32µs    12450.        0B    16.5 
#> 12 base_txt_plain  17.19µs  18.06µs    54636.        0B    10.9
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
#> 1 cli          4.22µs   4.77µs   205450.        0B    20.5 
#> 2 base       560.89ns 591.04ns  1546455.        0B     0   
#> 3 cli_vec     12.05µs  12.72µs    77637.      448B     7.76
#> 4 base_vec     7.03µs   7.66µs   129797.      448B     0   
#> 5 cli_txt     12.97µs   13.5µs    73173.        0B     7.32
#> 6 base_txt     7.82µs   8.08µs   122509.        0B     0
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
#> 1 cli          4.17µs   4.79µs   204728.        0B    20.5 
#> 2 base       781.03ns 831.09ns  1133468.        0B     0   
#> 3 cli_vec     14.41µs  15.13µs    65318.      448B     6.53
#> 4 base_vec    28.34µs  29.17µs    34025.      448B     3.40
#> 5 cli_txt     15.12µs   15.7µs    62996.        0B     6.30
#> 6 base_txt    51.23µs  52.11µs    19080.        0B     0
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
#> 1 cli          4.54µs   5.14µs   190733.        0B    19.1 
#> 2 base       540.05ns 581.03ns  1589235.        0B   159.  
#> 3 cli_vec     10.95µs  11.62µs    84954.      448B     8.50
#> 4 base_vec     6.98µs   7.64µs   130544.      448B     0   
#> 5 cli_txt     11.96µs  12.57µs    78549.        0B     7.86
#> 6 base_txt     7.79µs   8.05µs   122710.        0B    12.3
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
#> 1 cli          3.46µs   3.91µs   248410.    22.2KB    24.8 
#> 2 base       601.05ns 661.12ns  1395759.        0B     0   
#> 3 cli_vec     15.97µs  16.75µs    58977.     1.7KB     5.90
#> 4 base_vec      4.8µs   4.94µs   198224.      848B    19.8 
#> 5 cli_txt      3.46µs   3.93µs   248657.        0B    24.9 
#> 6 base_txt     2.93µs    3.2µs   305095.        0B     0
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
