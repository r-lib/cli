# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x64dba1207a60\>
\<environment: 0x64dba1c9dcc0\>

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
#> 1 ansi        31.38µs   37.4µs    25933.    99.6KB     28.6
#> 2 plain       30.97µs   37.4µs    25894.        0B     28.5
#> 3 base         9.04µs     11µs    87932.    48.6KB     26.4
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
#> 1 ansi         31.9µs   39.6µs    24325.        0B     29.2
#> 2 plain        32.1µs   39.1µs    24693.        0B     29.7
#> 3 base         10.4µs   12.6µs    76418.        0B     30.6
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
#> 1 ansi        80.73µs  92.62µs    10486.   77.03KB     21.3
#> 2 plain       62.34µs  71.83µs    13539.    8.91KB     19.0
#> 3 base         1.35µs   1.52µs   596927.        0B     59.7
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
#> 1 ansi          229µs    272µs     3636.   33.23KB     26.0
#> 2 plain         223µs    268µs     3693.    1.09KB     26.4
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
#>  1 cli_ansi          4.49µs   5.21µs   167251.    9.27KB     16.7
#>  2 fansi_ansi       22.36µs  26.25µs    36695.    4.18KB     18.4
#>  3 cli_plain         4.53µs   5.17µs   181270.        0B     18.1
#>  4 fansi_plain      22.44µs  26.03µs    37074.      688B     14.8
#>  5 cli_vec_ansi      6.26µs   7.13µs   133642.      448B     13.4
#>  6 fansi_vec_ansi   32.97µs  37.41µs    25977.    5.02KB     10.4
#>  7 cli_vec_plain     6.57µs   7.43µs   127018.      448B     12.7
#>  8 fansi_vec_plain  32.05µs  36.45µs    26742.    5.02KB     10.7
#>  9 cli_txt_ansi      4.52µs   5.18µs   179865.        0B     18.0
#> 10 fansi_txt_ansi   22.59µs  26.37µs    36607.      688B     18.3
#> 11 cli_txt_plain     5.29µs   6.12µs   153494.        0B     15.4
#> 12 fansi_txt_plain  32.42µs  36.65µs    26507.    5.02KB     10.6
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
#> 1 cli          52.7µs     57µs    17330.    22.7KB     6.12
#> 2 fansi       100.4µs    108µs     9107.    55.3KB     4.06
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
#>  1 cli_ansi          5.29µs   6.15µs   152455.        0B    15.2 
#>  2 fansi_ansi       56.38µs  64.16µs    15175.   38.84KB    14.6 
#>  3 base_ansi          717ns  758.1ns  1167344.        0B     0   
#>  4 cli_plain         5.41µs   6.14µs   153102.        0B    15.3 
#>  5 fansi_plain      55.52µs  63.77µs    15250.      688B    12.5 
#>  6 base_plain      637.02ns 698.03ns  1201410.        0B     0   
#>  7 cli_vec_ansi     24.29µs  27.96µs    35342.      448B     3.53
#>  8 fansi_vec_ansi   75.69µs  85.18µs    11491.    5.02KB    10.4 
#>  9 base_vec_ansi    12.76µs  14.43µs    67761.      448B     0   
#> 10 cli_vec_plain    21.89µs  24.39µs    39941.      448B     3.99
#> 11 fansi_vec_plain  67.94µs  77.44µs    12579.    5.02KB    10.6 
#> 12 base_vec_plain    7.54µs   8.19µs   116988.      448B     0   
#> 13 cli_txt_ansi     23.16µs  28.12µs    34156.        0B     3.42
#> 14 fansi_txt_ansi   66.82µs  76.28µs    12870.      688B    12.4 
#> 15 base_txt_ansi    13.34µs  14.42µs    68546.        0B     0   
#> 16 cli_txt_plain    20.75µs  22.56µs    43400.        0B     4.34
#> 17 fansi_txt_plain  58.71µs   67.3µs    14525.      688B    12.5 
#> 18 base_txt_plain    7.45µs   7.92µs   124030.        0B     0
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
#>  1 cli_ansi          6.31µs   7.53µs   126887.        0B    12.7 
#>  2 fansi_ansi       55.75µs   64.2µs    15166.      688B    14.6 
#>  3 base_ansi       984.06ns   1.09µs   845494.        0B     0   
#>  4 cli_plain         6.29µs   7.39µs   128877.        0B    12.9 
#>  5 fansi_plain      55.45µs  63.85µs    15232.      688B    12.5 
#>  6 base_plain      788.01ns 875.09ns   984950.        0B     0   
#>  7 cli_vec_ansi     27.75µs  30.93µs    31483.      448B     6.30
#>  8 fansi_vec_ansi   78.41µs  87.49µs    11160.    5.02KB     8.28
#>  9 base_vec_ansi    38.61µs  43.67µs    22779.      448B     0   
#> 10 cli_vec_plain    27.06µs   29.8µs    32889.      448B     6.58
#> 11 fansi_vec_plain  71.02µs  79.49µs    12256.    5.02KB    10.5 
#> 12 base_vec_plain   19.69µs  20.91µs    46204.      448B     0   
#> 13 cli_txt_ansi     27.61µs  30.97µs    30867.        0B     3.09
#> 14 fansi_txt_ansi    69.5µs  78.64µs    12317.      688B    10.3 
#> 15 base_txt_ansi     42.1µs  44.48µs    22261.        0B     0   
#> 16 cli_txt_plain    26.01µs  28.57µs    34370.        0B     6.88
#> 17 fansi_txt_plain  60.59µs  70.55µs    11556.      688B     8.20
#> 18 base_txt_plain   22.16µs  23.41µs    41298.        0B     4.13
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
#> 1 cli_ansi        5.06µs   5.96µs   157203.        0B    15.7 
#> 2 cli_plain       4.83µs   5.68µs   165400.        0B    16.5 
#> 3 cli_vec_ansi   29.64µs  32.26µs    30461.      848B     0   
#> 4 cli_vec_plain   8.81µs   9.84µs    97063.      848B     9.71
#> 5 cli_txt_ansi   30.18µs  32.92µs    29698.        0B     2.97
#> 6 cli_txt_plain   5.76µs   6.56µs   143684.        0B    14.4
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
#>  1 cli_ansi          19.8µs   22.1µs    42891.        0B    17.2 
#>  2 fansi_ansi        21.3µs   23.3µs    41255.    7.24KB    20.6 
#>  3 cli_plain         19.7µs   21.9µs    40776.        0B    16.3 
#>  4 fansi_plain       20.8µs     23µs    41894.      688B    16.8 
#>  5 cli_vec_ansi      29.3µs   31.6µs    30784.      848B    12.3 
#>  6 fansi_vec_ansi    46.6µs   51.4µs    19041.    5.41KB     8.41
#>  7 cli_vec_plain     22.5µs   26.6µs    36302.      848B    14.5 
#>  8 fansi_vec_plain   32.4µs   36.5µs    26698.    4.59KB    10.7 
#>  9 cli_txt_ansi      28.7µs   32.8µs    29765.        0B    11.9 
#> 10 fansi_txt_ansi    36.4µs   40.8µs    23751.    5.12KB     9.50
#> 11 cli_txt_plain     20.4µs   24.3µs    40018.        0B    16.0 
#> 12 fansi_txt_plain   22.8µs   26.2µs    37035.      688B    14.8
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
#>  1 cli_ansi         103.3µs 119.59µs     8098.  104.86KB    14.6 
#>  2 fansi_ansi       88.46µs  99.91µs     9760.  106.35KB    14.7 
#>  3 base_ansi         3.13µs   3.59µs   266108.      224B     0   
#>  4 cli_plain       105.16µs 119.37µs     8179.    8.09KB    14.8 
#>  5 fansi_plain      85.76µs  99.91µs     9813.    9.62KB    14.7 
#>  6 base_plain        2.66µs   2.96µs   318623.        0B     0   
#>  7 cli_vec_ansi       5.6ms      6ms      168.  823.77KB    15.9 
#>  8 fansi_vec_ansi  914.58µs 974.85µs      989.  846.81KB    20.2 
#>  9 base_vec_ansi   130.86µs 148.89µs     6619.    22.7KB     2.05
#> 10 cli_vec_plain     5.49ms   5.99ms      168.  823.77KB    16.3 
#> 11 fansi_vec_plain 858.35µs 925.46µs     1070.  845.98KB    20.5 
#> 12 base_vec_plain   91.49µs 101.46µs     9678.      848B     2.01
#> 13 cli_txt_ansi      2.83ms   2.97ms      336.    63.6KB     0   
#> 14 fansi_txt_ansi    1.26ms   1.34ms      738.   35.05KB     0   
#> 15 base_txt_ansi   115.71µs 133.48µs     7460.   18.47KB     4.07
#> 16 cli_txt_plain      1.9ms   2.02ms      482.    63.6KB     0   
#> 17 fansi_txt_plain 420.24µs 448.37µs     2213.    30.6KB     4.08
#> 18 base_txt_plain   73.71µs   86.7µs    11447.   11.05KB     2.02
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
#>  1 cli_ansi         104.6µs  120.5µs     8107.   33.84KB    14.6 
#>  2 fansi_ansi        39.4µs   43.8µs    21909.   31.42KB    15.8 
#>  3 base_ansi        806.1ns    898ns  1030508.     4.2KB     0   
#>  4 cli_plain        102.3µs  109.6µs     8808.        0B    18.9 
#>  5 fansi_plain       39.3µs   42.9µs    22483.      872B    15.7 
#>  6 base_plain         768ns    832ns  1126449.        0B     0   
#>  7 cli_vec_ansi     219.5µs  240.8µs     4088.   16.73KB     6.29
#>  8 fansi_vec_ansi    93.5µs  103.5µs     9515.    5.59KB     8.30
#>  9 base_vec_ansi     28.1µs   30.1µs    32820.      848B     0   
#> 10 cli_vec_plain    184.6µs  204.8µs     4680.   16.73KB    10.5 
#> 11 fansi_vec_plain   87.5µs   95.8µs    10256.    5.59KB     8.29
#> 12 base_vec_plain    24.2µs   26.1µs    37848.      848B     0   
#> 13 cli_txt_ansi     112.8µs  129.2µs     7414.        0B    14.6 
#> 14 fansi_txt_ansi    40.5µs   45.9µs    21214.      872B    14.9 
#> 15 base_txt_ansi      843ns    907ns  1028885.        0B     0   
#> 16 cli_txt_plain      104µs  120.2µs     8165.        0B    14.5 
#> 17 fansi_txt_plain   39.4µs   45.9µs    21192.      872B    14.8 
#> 18 base_txt_plain     780ns  836.1ns  1010524.        0B     0
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
#>  1 cli_ansi        296.86µs 337.42µs    2919.     6.18KB    12.5 
#>  2 fansi_ansi        71.4µs  80.72µs   12004.    97.33KB    14.6 
#>  3 base_ansi        25.37µs  29.11µs   33098.         0B    16.6 
#>  4 cli_plain       182.51µs 208.72µs    4668.         0B    14.6 
#>  5 fansi_plain      70.66µs  80.35µs   12044.       872B    12.5 
#>  6 base_plain       20.61µs  23.67µs   40138.         0B    16.1 
#>  7 cli_vec_ansi      33.8ms  34.26ms      28.9   94.67KB    28.9 
#>  8 fansi_vec_ansi  192.38µs 207.47µs    4753.     7.25KB     6.15
#>  9 base_vec_ansi     1.84ms   2.03ms     494.    48.18KB    15.1 
#> 10 cli_vec_plain    20.21ms  21.23ms      47.0    2.48KB    20.6 
#> 11 fansi_vec_plain 152.66µs 163.85µs    5962.     6.42KB     8.25
#> 12 base_vec_plain    1.34ms   1.41ms     700.     47.4KB    14.9 
#> 13 cli_txt_ansi      23.6ms   24.6ms      40.8    4.27MB     6.80
#> 14 fansi_txt_ansi  179.65µs 191.05µs    5131.     6.77KB     6.12
#> 15 base_txt_ansi     1.11ms   1.18ms     824.   582.06KB    11.2 
#> 16 cli_txt_plain     1.13ms   1.22ms     813.   369.84KB     8.62
#> 17 fansi_txt_plain 138.09µs 153.19µs    6438.     2.51KB     8.25
#> 18 base_txt_plain   761.2µs  847.7µs    1167.   367.31KB    11.0
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
#>  1 cli_ansi          5.27µs   6.14µs   152669.   25.09KB    15.3 
#>  2 fansi_ansi       58.57µs  66.14µs    14630.   28.48KB    14.8 
#>  3 base_ansi       807.92ns 873.93ns  1026997.        0B     0   
#>  4 cli_plain         5.23µs   6.04µs   154714.        0B    15.5 
#>  5 fansi_plain      58.45µs  66.08µs    14713.    1.98KB    12.6 
#>  6 base_plain      786.04ns 876.02ns   996476.        0B    99.7 
#>  7 cli_vec_ansi     25.14µs  28.15µs    34851.     1.7KB     3.49
#>  8 fansi_vec_ansi   91.89µs 100.54µs     9563.    8.86KB     8.34
#>  9 base_vec_ansi     6.12µs   6.61µs   148569.      848B     0   
#> 10 cli_vec_plain    20.25µs  22.55µs    43210.     1.7KB     8.64
#> 11 fansi_vec_plain  86.86µs  96.07µs    10133.    8.86KB     8.34
#> 12 base_vec_plain    5.61µs   6.44µs   152098.      848B     0   
#> 13 cli_txt_ansi      5.12µs   6.53µs   145243.        0B    29.1 
#> 14 fansi_txt_ansi   57.88µs  65.97µs    14715.    1.98KB    12.6 
#> 15 base_txt_ansi      4.2µs    4.7µs   206871.        0B     0   
#> 16 cli_txt_plain     6.01µs   7.08µs   130360.        0B    13.0 
#> 17 fansi_txt_plain   58.8µs  65.62µs    14788.    1.98KB    14.7 
#> 18 base_txt_plain       3µs    3.4µs   282927.        0B     0
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
#>  1 cli_ansi        73.37µs  83.98µs   11561.     12.1KB    10.4 
#>  2 base_ansi        1.07µs   1.13µs  840919.         0B     0   
#>  3 cli_plain       58.76µs  66.86µs   14526.     8.91KB    10.3 
#>  4 base_plain     781.03ns 832.02ns 1137523.         0B     0   
#>  5 cli_vec_ansi     3.58ms   3.86ms     261.   838.95KB    15.6 
#>  6 base_vec_ansi   64.92µs  69.55µs   14235.       848B     0   
#>  7 cli_vec_plain    2.05ms   2.22ms     450.   817.08KB    15.2 
#>  8 base_vec_plain  39.81µs  41.73µs   23767.       848B     0   
#>  9 cli_txt_ansi    12.36ms  12.68ms      78.6   114.6KB     4.25
#> 10 base_txt_ansi   69.53µs  74.84µs   13331.         0B     0   
#> 11 cli_txt_plain  226.26µs 245.07µs    4020.    18.34KB     2.01
#> 12 base_txt_plain  37.79µs   39.9µs   24729.         0B     0
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
#>  1 cli_ansi         73.6µs   83.7µs    11443.        0B    16.7 
#>  2 base_ansi        12.8µs   14.7µs    65727.        0B    13.1 
#>  3 cli_plain        74.4µs   83.8µs    11319.        0B    16.7 
#>  4 base_plain       12.8µs     14µs    68409.        0B    13.7 
#>  5 cli_vec_ansi      154µs  162.7µs     6026.     7.2KB     8.25
#>  6 base_vec_ansi    46.1µs   50.8µs    19285.    1.66KB     4.03
#>  7 cli_vec_plain   139.9µs  149.4µs     6570.     7.2KB     8.25
#>  8 base_vec_plain   41.9µs   44.8µs    21911.    1.66KB     4.38
#>  9 cli_txt_ansi    132.2µs  143.1µs     6859.        0B     8.18
#> 10 base_txt_ansi    31.5µs   33.5µs    29267.        0B     5.85
#> 11 cli_txt_plain   119.9µs  131.7µs     7469.        0B    10.4 
#> 12 base_txt_plain   28.1µs   30.7µs    31931.        0B     6.39
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
#> 1 cli          6.09µs   7.12µs   131979.        0B    13.2 
#> 2 base       689.06ns  758.1ns  1136748.        0B     0   
#> 3 cli_vec     21.83µs  24.83µs    39745.      448B     3.97
#> 4 base_vec     11.6µs  12.31µs    79837.      448B     0   
#> 5 cli_txt     22.16µs  24.55µs    39994.        0B     4.00
#> 6 base_txt    13.06µs  13.98µs    70495.        0B     7.05
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
#> 1 cli           6.2µs   7.08µs   133048.        0B    13.3 
#> 2 base         1.11µs   1.18µs   748756.        0B     0   
#> 3 cli_vec     23.32µs  26.93µs    36608.      448B     3.66
#> 4 base_vec    45.34µs  50.16µs    19868.      448B     0   
#> 5 cli_txt     23.76µs  26.69µs    36758.        0B     3.68
#> 6 base_txt     79.6µs  83.18µs    11896.        0B     2.01
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
#> 1 cli          6.49µs   7.66µs   124678.        0B    12.5 
#> 2 base       708.15ns 761.01ns  1099554.        0B     0   
#> 3 cli_vec     17.86µs  19.51µs    50099.      448B    10.0 
#> 4 base_vec    11.57µs  12.29µs    80177.      448B     0   
#> 5 cli_txt     19.32µs  21.05µs    46493.        0B     4.65
#> 6 base_txt    13.19µs  13.95µs    70772.        0B     0
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
#> 1 cli          4.87µs   5.86µs   159211.    22.2KB    31.8 
#> 2 base       813.04ns 911.07ns   992158.        0B     0   
#> 3 cli_vec     26.51µs  29.93µs    33041.     1.7KB     3.30
#> 4 base_vec     6.77µs   7.15µs   136915.      848B     0   
#> 5 cli_txt      4.94µs   5.88µs   158623.        0B    15.9 
#> 6 base_txt     4.74µs   5.37µs   182355.        0B     0
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
#>  date     2026-11-25
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-25 [1] local
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
