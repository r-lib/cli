# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x574e2ec221f0\>
\<environment: 0x574e2f6b8450\>

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
#> 1 ansi         46.8µs   51.1µs    18884.    99.6KB     19.0
#> 2 plain        46.9µs   50.8µs    18897.        0B     20.0
#> 3 base         11.9µs     13µs    74053.    48.6KB     22.2
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
#> 1 ansi         49.3µs   53.3µs    18043.        0B     23.9
#> 2 plain        49.2µs   52.9µs    18149.        0B     21.3
#> 3 base         13.9µs   15.3µs    63111.        0B     25.3
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
#> 1 ansi       116.32µs 124.59µs     7729.   77.03KB     14.7
#> 2 plain       93.04µs  98.86µs     9788.    8.91KB     16.8
#> 3 base         1.61µs   1.76µs   543171.        0B      0
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
#> 1 ansi          354µs    381µs     2518.   33.23KB     19.2
#> 2 plain         350µs    374µs     2634.    1.09KB     19.2
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
#>  1 cli_ansi          5.96µs   6.68µs   137834.    9.27KB    27.6 
#>  2 fansi_ansi       31.47µs  34.84µs    27698.    4.18KB    22.2 
#>  3 cli_plain         5.92µs   6.54µs   147036.        0B    29.4 
#>  4 fansi_plain      30.87µs  33.53µs    28190.      688B    16.9 
#>  5 cli_vec_ansi      7.43µs   8.05µs   118688.      448B    11.9 
#>  6 fansi_vec_ansi   40.21µs  42.82µs    22448.    5.02KB     8.98
#>  7 cli_vec_plain     8.04µs   8.61µs   112828.      448B    11.3 
#>  8 fansi_vec_plain  39.14µs  41.89µs    22921.    5.02KB     9.17
#>  9 cli_txt_ansi      5.76µs   6.34µs   147438.        0B    14.7 
#> 10 fansi_txt_ansi   30.69µs  33.23µs    27779.      688B    13.9 
#> 11 cli_txt_plain     6.68µs   7.17µs   131231.        0B    13.1 
#> 12 fansi_txt_plain  39.45µs  42.27µs    22251.    5.02KB     8.90
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
#> 1 cli            53µs     55µs    17775.    22.7KB     6.13
#> 2 fansi         112µs    117µs     8158.    55.3KB     4.06
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
#>  1 cli_ansi          6.96µs   7.75µs   125575.        0B    12.6 
#>  2 fansi_ansi       91.69µs  97.76µs     9872.   38.84KB     8.23
#>  3 base_ansi       861.01ns  902.1ns  1017024.        0B     0   
#>  4 cli_plain         6.86µs   7.67µs   126648.        0B    12.7 
#>  5 fansi_plain      91.11µs  96.26µs    10114.      688B     8.21
#>  6 base_plain      801.05ns 852.04ns  1083352.        0B   108.  
#>  7 cli_vec_ansi     28.97µs  29.89µs    32821.      448B     3.28
#>  8 fansi_vec_ansi  113.92µs 118.81µs     8187.    5.02KB     6.17
#>  9 base_vec_ansi    14.59µs  14.69µs    66929.      448B     0   
#> 10 cli_vec_plain    27.65µs  28.52µs    33624.      448B     3.36
#> 11 fansi_vec_plain 101.45µs 107.99µs     8994.    5.02KB     8.29
#> 12 base_vec_plain    8.68µs   8.79µs   111600.      448B     0   
#> 13 cli_txt_ansi      29.1µs  30.09µs    31332.        0B     3.13
#> 14 fansi_txt_ansi  104.44µs 109.86µs     8849.      688B     8.20
#> 15 base_txt_ansi    14.24µs   14.3µs    69009.        0B     0   
#> 16 cli_txt_plain    27.13µs  28.01µs    35119.        0B     3.51
#> 17 fansi_txt_plain  94.24µs  99.16µs     9751.      688B     8.20
#> 18 base_txt_plain    8.78µs   8.93µs   110128.        0B     0
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
#>  1 cli_ansi          8.73µs   9.56µs   101934.        0B    10.2 
#>  2 fansi_ansi       91.75µs  97.56µs     9968.      688B    10.4 
#>  3 base_ansi         1.18µs   1.23µs   770197.        0B     0   
#>  4 cli_plain         8.62µs   9.34µs   104143.        0B    10.4 
#>  5 fansi_plain       92.1µs  96.96µs    10040.      688B     8.21
#>  6 base_plain      971.02ns   1.02µs   894596.        0B     0   
#>  7 cli_vec_ansi     35.51µs  36.42µs    27000.      448B     2.70
#>  8 fansi_vec_ansi  115.79µs 120.83µs     8036.    5.02KB     8.26
#>  9 base_vec_ansi    40.73µs   41.1µs    23971.      448B     0   
#> 10 cli_vec_plain    34.27µs  35.24µs    27823.      448B     2.78
#> 11 fansi_vec_plain 105.39µs 110.46µs     8739.    5.02KB     8.28
#> 12 base_vec_plain   20.96µs  21.35µs    46194.      448B     0   
#> 13 cli_txt_ansi     35.91µs  36.75µs    26705.        0B     2.67
#> 14 fansi_txt_ansi  107.73µs 112.67µs     8643.      688B     8.21
#> 15 base_txt_ansi    43.14µs  43.48µs    22721.        0B     0   
#> 16 cli_txt_plain    33.96µs  34.83µs    28160.        0B     2.82
#> 17 fansi_txt_plain  96.84µs 101.74µs     9573.      688B     8.21
#> 18 base_txt_plain   22.38µs  23.12µs    42670.        0B     0
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
#> 1 cli_ansi        6.96µs   7.62µs   127558.        0B     0   
#> 2 cli_plain       6.62µs   7.26µs   133740.        0B    13.4 
#> 3 cli_vec_ansi   30.61µs  31.52µs    31156.      848B     3.12
#> 4 cli_vec_plain  10.54µs  11.34µs    86103.      848B     8.61
#> 5 cli_txt_ansi    29.4µs  30.29µs    32260.        0B     3.23
#> 6 cli_txt_plain   7.48µs   8.23µs   117949.        0B    11.8
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
#>  1 cli_ansi          26.5µs   28.4µs    34166.        0B    13.7 
#>  2 fansi_ansi        29.2µs   31.4µs    30883.    7.24KB    12.4 
#>  3 cli_plain         26.2µs   28.3µs    34019.        0B    17.0 
#>  4 fansi_plain       28.3µs   30.6µs    31587.      688B    12.6 
#>  5 cli_vec_ansi      35.3µs   38.4µs    25541.      848B    10.2 
#>  6 fansi_vec_ansi    55.2µs   57.9µs    16825.    5.41KB     6.19
#>  7 cli_vec_plain     29.3µs     31µs    31320.      848B    12.5 
#>  8 fansi_vec_plain   38.3µs   40.4µs    23818.    4.59KB     9.83
#>  9 cli_txt_ansi      34.3µs   35.9µs    27135.        0B    13.6 
#> 10 fansi_txt_ansi    45.1µs   46.7µs    20826.    5.12KB     8.33
#> 11 cli_txt_plain     27.1µs   28.4µs    34293.        0B    13.7 
#> 12 fansi_txt_plain   29.8µs   31.4µs    30334.      688B    12.1
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
#>  1 cli_ansi         164.5µs 174.27µs     5595.  104.86KB    10.4 
#>  2 fansi_ansi      130.43µs  137.6µs     7091.  106.35KB    10.4 
#>  3 base_ansi         3.68µs      4µs   243492.      224B     0   
#>  4 cli_plain       163.31µs 170.98µs     5689.    8.09KB    10.3 
#>  5 fansi_plain     127.59µs 135.21µs     7221.    9.62KB    10.4 
#>  6 base_plain        3.35µs   3.56µs   273574.        0B     0   
#>  7 cli_vec_ansi      7.81ms   7.97ms      125.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.05ms   1.08ms      895.  846.81KB    17.4 
#>  9 base_vec_ansi      154µs 159.43µs     6142.    22.7KB     2.03
#> 10 cli_vec_plain     7.68ms   7.88ms      126.  823.77KB    14.0 
#> 11 fansi_vec_plain   1.01ms   1.04ms      952.  845.98KB    17.9 
#> 12 base_vec_plain  104.61µs 107.39µs     9150.      848B     4.04
#> 13 cli_txt_ansi      3.38ms   3.43ms      291.    63.6KB     0   
#> 14 fansi_txt_ansi    1.62ms   1.64ms      598.   35.05KB     0   
#> 15 base_txt_ansi    140.3µs 145.77µs     6770.   18.47KB     2.02
#> 16 cli_txt_plain     2.44ms   2.47ms      397.    63.6KB     2.02
#> 17 fansi_txt_plain 515.66µs 533.08µs     1858.    30.6KB     2.02
#> 18 base_txt_plain   90.91µs  94.33µs    10369.   11.05KB     2.02
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
#>  1 cli_ansi        151.46µs 161.28µs     6011.   33.84KB    12.5 
#>  2 fansi_ansi       54.98µs  58.87µs    16484.   31.42KB    10.4 
#>  3 base_ansi         1.02µs   1.08µs   848535.     4.2KB     0   
#>  4 cli_plain       150.12µs 157.06µs     6131.        0B    12.5 
#>  5 fansi_plain       54.6µs  58.43µs    16559.      872B    12.5 
#>  6 base_plain         951ns      1µs   945739.        0B     0   
#>  7 cli_vec_ansi    273.48µs 285.09µs     3425.   16.73KB     6.17
#>  8 fansi_vec_ansi  114.47µs 118.93µs     8176.    5.59KB     6.17
#>  9 base_vec_ansi    34.47µs   34.7µs    28337.      848B     0   
#> 10 cli_vec_plain   235.58µs 245.55µs     3974.   16.73KB     8.48
#> 11 fansi_vec_plain 105.38µs 110.36µs     8798.    5.59KB     6.17
#> 12 base_vec_plain   28.48µs  29.36µs    33754.      848B     0   
#> 13 cli_txt_ansi     161.6µs  168.4µs     5774.        0B    12.5 
#> 14 fansi_txt_ansi   54.75µs  58.56µs    16534.      872B    12.4 
#> 15 base_txt_ansi     1.05µs    1.1µs   852007.        0B     0   
#> 16 cli_txt_plain   151.17µs 158.14µs     6173.        0B    12.2 
#> 17 fansi_txt_plain  53.76µs  56.66µs    17114.      872B    10.3 
#> 18 base_txt_plain  952.04ns   1.01µs   934441.        0B     0
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
#>  1 cli_ansi        427.93µs 454.19µs    2183.     6.18KB    10.3 
#>  2 fansi_ansi       98.31µs 104.24µs    9293.    97.33KB    10.3 
#>  3 base_ansi        38.64µs  41.55µs   23147.         0B     9.26
#>  4 cli_plain       281.31µs 296.22µs    3303.         0B    10.3 
#>  5 fansi_plain      97.13µs 104.12µs    9334.       872B    12.5 
#>  6 base_plain       31.93µs  33.91µs   28390.         0B     8.52
#>  7 cli_vec_ansi     44.81ms  45.41ms      21.9   94.67KB    26.3 
#>  8 fansi_vec_ansi  231.61µs 241.09µs    4032.     7.25KB     4.07
#>  9 base_vec_ansi      2.3ms   2.36ms     418.    48.18KB    12.9 
#> 10 cli_vec_plain    29.68ms  30.46ms      32.9    2.48KB    14.9 
#> 11 fansi_vec_plain 188.89µs 198.58µs    4792.     6.42KB     6.15
#> 12 base_vec_plain    1.68ms   1.75ms     568.     47.4KB    13.0 
#> 13 cli_txt_ansi     24.84ms  25.22ms      39.5    4.27MB     6.97
#> 14 fansi_txt_ansi   221.4µs 230.88µs    4264.     6.77KB     4.06
#> 15 base_txt_ansi     1.25ms   1.29ms     766.   582.06KB    11.2 
#> 16 cli_txt_plain     1.28ms   1.31ms     746.   369.84KB     8.65
#> 17 fansi_txt_plain 173.22µs 180.43µs    5364.     2.51KB     6.14
#> 18 base_txt_plain  848.69µs 884.86µs    1112.   367.31KB    11.0
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
#>  1 cli_ansi          6.71µs   7.44µs   130180.   25.09KB    13.0 
#>  2 fansi_ansi       79.62µs  85.79µs    11292.   28.48KB    10.4 
#>  3 base_ansi         1.01µs   1.06µs   872726.        0B     0   
#>  4 cli_plain         6.63µs   7.46µs   128377.        0B    25.7 
#>  5 fansi_plain      80.68µs  85.71µs    11183.    1.98KB    10.4 
#>  6 base_plain      972.07ns   1.04µs   897916.        0B     0   
#>  7 cli_vec_ansi     27.55µs  28.89µs    33932.     1.7KB     3.39
#>  8 fansi_vec_ansi  114.66µs 121.01µs     8017.    8.86KB     8.48
#>  9 base_vec_ansi     5.87µs   6.05µs   162536.      848B     0   
#> 10 cli_vec_plain     23.5µs  24.66µs    39132.     1.7KB     3.91
#> 11 fansi_vec_plain 110.29µs 115.77µs     8377.    8.86KB     8.37
#> 12 base_vec_plain    5.71µs   5.89µs   165555.      848B     0   
#> 13 cli_txt_ansi      6.59µs   7.36µs   131334.        0B    13.1 
#> 14 fansi_txt_ansi   79.91µs  85.38µs    11366.    1.98KB    10.4 
#> 15 base_txt_ansi     5.14µs    5.2µs   187103.        0B     0   
#> 16 cli_txt_plain     7.51µs   8.29µs   116182.        0B    23.2 
#> 17 fansi_txt_plain  79.98µs  85.02µs    11407.    1.98KB    10.4 
#> 18 base_txt_plain    3.35µs   3.42µs   282919.        0B     0
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
#>  1 cli_ansi        109.5µs 114.87µs    8459.     12.1KB     7.28
#>  2 base_ansi        1.29µs   1.34µs  720524.         0B     0   
#>  3 cli_plain       87.97µs  91.43µs   10619.     8.91KB     8.22
#>  4 base_plain     981.03ns   1.02µs  940772.         0B     0   
#>  5 cli_vec_ansi     4.15ms   4.29ms     233.   838.95KB    13.2 
#>  6 base_vec_ansi   75.57µs  75.98µs   12994.       848B     0   
#>  7 cli_vec_plain    2.31ms   2.39ms     416.   817.08KB    15.2 
#>  8 base_vec_plain   44.5µs  44.93µs   21979.       848B     0   
#>  9 cli_txt_ansi    12.58ms  12.71ms      78.5   114.6KB     4.24
#> 10 base_txt_ansi   76.25µs  76.48µs   12907.         0B     0   
#> 11 cli_txt_plain  286.49µs 298.28µs    3285.    18.34KB     2.02
#> 12 base_txt_plain  43.04µs  44.32µs   22296.         0B     0
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
#>  1 cli_ansi        112.7µs  118.2µs     8187.        0B    12.5 
#>  2 base_ansi        17.3µs   18.5µs    52414.        0B    10.5 
#>  3 cli_plain       109.4µs  116.2µs     8330.        0B    10.3 
#>  4 base_plain       16.8µs   18.3µs    49777.        0B     9.96
#>  5 cli_vec_ansi    199.7µs  207.9µs     4688.     7.2KB     6.15
#>  6 base_vec_ansi    53.2µs   58.1µs    16736.    1.66KB     4.07
#>  7 cli_vec_plain   186.1µs  193.7µs     5026.     7.2KB     6.16
#>  8 base_vec_plain   50.5µs   52.4µs    18631.    1.66KB     4.07
#>  9 cli_txt_ansi    175.7µs  182.3µs     5346.        0B     8.21
#> 10 base_txt_ansi    38.6µs   40.1µs    24358.        0B     4.87
#> 11 cli_txt_plain   160.6µs  167.5µs     5536.        0B     6.11
#> 12 base_txt_plain   33.8µs   35.2µs    27191.        0B     5.44
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
#> 1 cli          8.38µs   9.13µs   106099.        0B    10.6 
#> 2 base       840.98ns  902.1ns  1028847.        0B     0   
#> 3 cli_vec     24.19µs  25.17µs    38821.      448B     3.88
#> 4 base_vec     11.6µs  11.78µs    83498.      448B     0   
#> 5 cli_txt     24.33µs  25.24µs    38675.        0B     3.87
#> 6 base_txt    12.49µs  12.59µs    77824.        0B     7.78
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
#> 1 cli          8.33µs   9.35µs   103781.        0B    10.4 
#> 2 base          1.3µs   1.37µs   688583.        0B     0   
#> 3 cli_vec     30.37µs  31.43µs    31114.      448B     3.11
#> 4 base_vec    50.02µs  50.62µs    19245.      448B     0   
#> 5 cli_txt     30.16µs  31.09µs    31400.        0B     3.14
#> 6 base_txt    86.61µs  87.37µs    11167.        0B     2.01
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
#> 1 cli          8.87µs   9.74µs    99711.        0B     9.97
#> 2 base          851ns  902.1ns  1019212.        0B     0   
#> 3 cli_vec     19.77µs   20.8µs    46922.      448B     9.39
#> 4 base_vec    11.61µs  11.81µs    83375.      448B     0   
#> 5 cli_txt     20.47µs  21.36µs    45857.        0B     4.59
#> 6 base_txt     12.5µs  12.61µs    75581.        0B     0
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
#> 1 cli           6.3µs   6.98µs   138073.    22.2KB    27.6 
#> 2 base         1.02µs   1.08µs   868551.        0B     0   
#> 3 cli_vec     29.15µs  30.18µs    32570.     1.7KB     3.26
#> 4 base_vec     7.76µs   7.96µs   123078.      848B     0   
#> 5 cli_txt      6.27µs   6.97µs   138982.        0B    13.9 
#> 6 base_txt     5.42µs   5.54µs   176527.        0B     0
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
#>  date     2026-11-27
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-27 [1] local
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
#>  otel          0.3.0      2026-11-07 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.1      2026-07-07 [1] any (@2.2.1)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.3.0      2026-07-05 [1] RSPM
#>  rmarkdown     2.32       2026-09-01 [1] RSPM
#>  sass          0.5.0      2026-11-20 [1] RSPM
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
#>  systemfonts   1.3.4      2026-11-21 [1] RSPM
#>  textshaping   1.1.0      2026-11-20 [1] RSPM
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
