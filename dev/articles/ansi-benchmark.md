# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5649f12cc048\>
\<environment: 0x5649f1d6cf80\>

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
#> 1 ansi         44.4µs   47.9µs    20217.    99.6KB     21.0
#> 2 plain          45µs   48.1µs    20131.        0B     19.5
#> 3 base         11.2µs   12.2µs    79328.    48.6KB     23.8
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
#> 1 ansi         46.9µs   50.4µs    19221.        0B     23.4
#> 2 plain        46.3µs   49.7µs    19473.        0B     23.2
#> 3 base           13µs   14.3µs    67766.        0B     27.1
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
#> 1 ansi       114.95µs 121.64µs     7960.   77.03KB     16.7
#> 2 plain       91.18µs  96.43µs    10018.    8.91KB     14.5
#> 3 base         1.83µs   1.96µs   491866.        0B      0
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
#> 1 ansi          335µs    358µs     2758.   33.23KB     21.1
#> 2 plain         333µs    358µs     2758.    1.09KB     19.0
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
#>  1 cli_ansi          5.72µs   6.22µs   154700.    9.27KB    30.9 
#>  2 fansi_ansi        30.2µs  32.62µs    29727.    4.18KB    23.8 
#>  3 cli_plain         5.56µs   5.98µs   161325.        0B    32.3 
#>  4 fansi_plain       30.3µs  32.16µs    29424.      688B    11.8 
#>  5 cli_vec_ansi         7µs   7.41µs   131324.      448B    13.1 
#>  6 fansi_vec_ansi   40.17µs  42.31µs    22715.    5.02KB    11.4 
#>  7 cli_vec_plain      7.6µs   8.04µs   120125.      448B    12.0 
#>  8 fansi_vec_plain  38.29µs  40.35µs    24076.    5.02KB     9.63
#>  9 cli_txt_ansi      5.65µs   6.01µs   161914.        0B    16.2 
#> 10 fansi_txt_ansi   30.32µs  32.11µs    30249.      688B    12.1 
#> 11 cli_txt_plain     6.38µs   7.25µs   111621.        0B    11.2 
#> 12 fansi_txt_plain  38.07µs  40.55µs    23827.    5.02KB    11.9
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
#> 1 cli          55.6µs   57.9µs    16932.    22.7KB     4.05
#> 2 fansi       118.8µs  122.9µs     7927.    55.3KB     6.11
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
#>  1 cli_ansi          6.91µs   7.48µs   129564.        0B    13.0 
#>  2 fansi_ansi        90.1µs  94.77µs    10227.   38.84KB     8.19
#>  3 base_ansi       881.15ns 932.02ns  1003114.        0B     0   
#>  4 cli_plain         6.91µs   7.44µs   130543.        0B    13.1 
#>  5 fansi_plain      88.98µs  93.67µs    10336.      688B    10.3 
#>  6 base_plain      811.07ns 852.04ns  1105846.        0B     0   
#>  7 cli_vec_ansi     28.65µs  29.48µs    33270.      448B     3.33
#>  8 fansi_vec_ansi  111.04µs 115.62µs     8393.    5.02KB     8.23
#>  9 base_vec_ansi    17.19µs  17.28µs    57040.      448B     0   
#> 10 cli_vec_plain    27.48µs  28.16µs    34825.      448B     3.48
#> 11 fansi_vec_plain 101.65µs    106µs     9133.    5.02KB     8.24
#> 12 base_vec_plain    10.1µs  10.18µs    96083.      448B     0   
#> 13 cli_txt_ansi     28.71µs  29.36µs    33409.        0B     3.34
#> 14 fansi_txt_ansi  102.12µs 106.65µs     9075.      688B     8.18
#> 15 base_txt_ansi    16.88µs  16.93µs    57784.        0B     0   
#> 16 cli_txt_plain    27.01µs  27.65µs    35493.        0B     3.55
#> 17 fansi_txt_plain  92.38µs   96.6µs    10049.      688B     8.18
#> 18 base_txt_plain    9.84µs  10.35µs    95693.        0B     0
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
#>  1 cli_ansi          8.46µs   9.29µs   104774.        0B    10.5 
#>  2 fansi_ansi       89.83µs  94.02µs    10289.      688B     8.17
#>  3 base_ansi          1.2µs   1.25µs   615363.        0B     0   
#>  4 cli_plain         8.43µs   9.06µs   107306.        0B    21.5 
#>  5 fansi_plain      88.73µs  93.83µs    10346.      688B     8.18
#>  6 base_plain      992.09ns   1.04µs   901875.        0B     0   
#>  7 cli_vec_ansi     34.42µs  35.31µs    27787.      448B     2.78
#>  8 fansi_vec_ansi  113.37µs 118.15µs     8185.    5.02KB     8.22
#>  9 base_vec_ansi    40.92µs  41.25µs    23951.      448B     0   
#> 10 cli_vec_plain    33.36µs  34.14µs    28657.      448B     2.87
#> 11 fansi_vec_plain 103.73µs  108.2µs     8892.    5.02KB     8.24
#> 12 base_vec_plain   21.65µs  21.98µs    44956.      448B     0   
#> 13 cli_txt_ansi     34.91µs  35.63µs    27497.        0B     5.50
#> 14 fansi_txt_ansi  104.87µs 109.38µs     8882.      688B     6.10
#> 15 base_txt_ansi    43.24µs  44.18µs    22393.        0B     2.24
#> 16 cli_txt_plain    32.95µs  33.69µs    29132.        0B     2.91
#> 17 fansi_txt_plain  94.73µs  99.54µs     9730.      688B     8.18
#> 18 base_txt_plain   23.62µs  23.82µs    41489.        0B     0
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
#> 1 cli_ansi        6.92µs   7.49µs   129316.        0B    12.9 
#> 2 cli_plain       6.37µs   6.91µs   139883.        0B    14.0 
#> 3 cli_vec_ansi   31.61µs   32.8µs    29946.      848B     2.99
#> 4 cli_vec_plain  10.39µs  11.05µs    88301.      848B     8.83
#> 5 cli_txt_ansi   30.51µs  31.31µs    31361.        0B     3.14
#> 6 cli_txt_plain   7.24µs   7.93µs   122560.        0B    12.3
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
#>  1 cli_ansi          25.1µs   27.1µs    35629.        0B    14.3 
#>  2 fansi_ansi        28.5µs   30.1µs    32196.    7.24KB    16.1 
#>  3 cli_plain         24.9µs   26.4µs    36842.        0B    14.7 
#>  4 fansi_plain       27.9µs   29.6µs    32698.      688B    13.1 
#>  5 cli_vec_ansi      34.3µs   35.9µs    27173.      848B    10.9 
#>  6 fansi_vec_ansi    54.7µs   57.2µs    17063.    5.41KB     8.98
#>  7 cli_vec_plain     27.8µs   28.9µs    33649.      848B    13.5 
#>  8 fansi_vec_plain   37.1µs   38.5µs    25281.    4.59KB    10.1 
#>  9 cli_txt_ansi      33.6µs   34.7µs    28106.        0B    11.2 
#> 10 fansi_txt_ansi      44µs   45.5µs    21401.    5.12KB     8.56
#> 11 cli_txt_plain       26µs   27.1µs    35978.        0B    18.0 
#> 12 fansi_txt_plain   29.2µs   30.8µs    31460.      688B    12.6
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
#>  1 cli_ansi         161.4µs 168.14µs     5774.  104.86KB    10.3 
#>  2 fansi_ansi      126.57µs 133.22µs     7306.  106.35KB    10.3 
#>  3 base_ansi          4.1µs   4.45µs   219330.      224B    21.9 
#>  4 cli_plain       160.33µs 167.57µs     5800.    8.09KB    10.3 
#>  5 fansi_plain      125.2µs 132.18µs     7356.    9.62KB    10.3 
#>  6 base_plain        3.55µs   3.82µs   255568.        0B     0   
#>  7 cli_vec_ansi      7.54ms   7.63ms      131.  823.77KB    13.5 
#>  8 fansi_vec_ansi    1.02ms   1.06ms      906.  846.81KB    17.1 
#>  9 base_vec_ansi   156.02µs  160.1µs     6111.    22.7KB     2.03
#> 10 cli_vec_plain     7.45ms   7.59ms      131.  823.77KB    13.8 
#> 11 fansi_vec_plain 944.69µs 985.64µs     1009.  845.98KB    19.3 
#> 12 base_vec_plain  106.35µs 110.43µs     8930.      848B     2.01
#> 13 cli_txt_ansi      3.23ms   3.27ms      303.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.54ms   1.56ms      639.   35.05KB     0   
#> 15 base_txt_ansi   137.29µs 146.74µs     6727.   18.47KB     2.02
#> 16 cli_txt_plain     2.42ms   2.46ms      406.    63.6KB     0   
#> 17 fansi_txt_plain 511.95µs 531.27µs     1873.    30.6KB     4.07
#> 18 base_txt_plain   88.75µs  90.79µs    10630.   11.05KB     2.01
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
#>  1 cli_ansi        147.19µs 152.97µs     6334.   33.84KB    12.4 
#>  2 fansi_ansi       54.21µs  57.67µs    16801.   31.42KB    12.4 
#>  3 base_ansi         1.06µs    1.1µs   848641.     4.2KB     0   
#>  4 cli_plain       142.67µs 149.27µs     6520.        0B    12.4 
#>  5 fansi_plain       53.7µs  57.08µs    16987.      872B    12.7 
#>  6 base_plain      991.04ns   1.03µs   911525.        0B     0   
#>  7 cli_vec_ansi    270.27µs  280.3µs     3486.   16.73KB     8.24
#>  8 fansi_vec_ansi  115.76µs 119.64µs     8152.    5.59KB     6.14
#>  9 base_vec_ansi    35.57µs  36.13µs    27348.      848B     0   
#> 10 cli_vec_plain   228.16µs 235.86µs     4151.   16.73KB     8.26
#> 11 fansi_vec_plain 108.37µs 111.99µs     8701.    5.59KB     6.15
#> 12 base_vec_plain   30.18µs  30.69µs    32063.      848B     3.21
#> 13 cli_txt_ansi    154.06µs  160.8µs     6046.        0B    11.9 
#> 14 fansi_txt_ansi   53.45µs  55.74µs    17404.      872B    12.4 
#> 15 base_txt_ansi     1.09µs   1.14µs   849409.        0B     0   
#> 16 cli_txt_plain   143.45µs 148.04µs     6573.        0B    12.3 
#> 17 fansi_txt_plain  52.97µs  55.03µs    16811.      872B    12.4 
#> 18 base_txt_plain  982.08ns   1.02µs   939854.        0B     0
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
#>  1 cli_ansi        413.94µs 437.06µs    2278.     6.18KB    12.4 
#>  2 fansi_ansi       97.07µs 102.03µs    9554.    97.33KB    10.3 
#>  3 base_ansi        38.51µs  40.57µs   23830.         0B    11.9 
#>  4 cli_plain       270.94µs 282.08µs    3470.         0B    10.3 
#>  5 fansi_plain      95.76µs 101.31µs    9590.       872B    12.4 
#>  6 base_plain       31.49µs   33.4µs   28914.         0B    11.6 
#>  7 cli_vec_ansi     43.39ms  43.73ms      22.8   94.67KB    22.8 
#>  8 fansi_vec_ansi     237µs 245.05µs    4014.     7.25KB     4.06
#>  9 base_vec_ansi     2.25ms   2.31ms     431.    48.18KB    12.9 
#> 10 cli_vec_plain    28.57ms  28.74ms      34.8    2.48KB    19.0 
#> 11 fansi_vec_plain 191.41µs  197.6µs    4943.     6.42KB     6.13
#> 12 base_vec_plain    1.63ms   1.68ms     591.     47.4KB    12.7 
#> 13 cli_txt_ansi     26.47ms  26.78ms      37.2    4.27MB     6.98
#> 14 fansi_txt_ansi  225.67µs 233.22µs    4211.     6.77KB     6.11
#> 15 base_txt_ansi     1.24ms   1.26ms     784.   582.06KB    10.9 
#> 16 cli_txt_plain     1.26ms    1.3ms     761.   369.84KB     8.55
#> 17 fansi_txt_plain 178.16µs 184.29µs    5305.     2.51KB     6.12
#> 18 base_txt_plain  833.37µs 868.01µs    1138.   367.31KB    11.0
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
#>  1 cli_ansi          6.73µs    7.4µs   130160.   25.09KB    13.0 
#>  2 fansi_ansi       78.63µs  83.13µs    11655.   28.48KB    12.5 
#>  3 base_ansi         1.03µs   1.08µs   867338.        0B     0   
#>  4 cli_plain         6.58µs    7.2µs   134334.        0B    13.4 
#>  5 fansi_plain       78.7µs  83.36µs    11633.    1.98KB    12.5 
#>  6 base_plain           1µs   1.05µs   898470.        0B     0   
#>  7 cli_vec_ansi      26.5µs  27.35µs    35856.     1.7KB     3.59
#>  8 fansi_vec_ansi  116.72µs 121.51µs     8006.    8.86KB     8.30
#>  9 base_vec_ansi     6.01µs   6.27µs   156477.      848B     0   
#> 10 cli_vec_plain    22.85µs  23.66µs    41382.     1.7KB     4.14
#> 11 fansi_vec_plain 108.65µs 112.64µs     8640.    8.86KB     9.63
#> 12 base_vec_plain    5.64µs   5.93µs   165703.      848B     0   
#> 13 cli_txt_ansi      6.68µs   7.03µs   138957.        0B    13.9 
#> 14 fansi_txt_ansi   76.62µs  79.83µs    12109.    1.98KB    12.4 
#> 15 base_txt_ansi     6.46µs    6.5µs   151120.        0B     0   
#> 16 cli_txt_plain     7.52µs   7.88µs   123803.        0B    12.4 
#> 17 fansi_txt_plain  76.65µs  80.02µs    12123.    1.98KB    12.4 
#> 18 base_txt_plain     4.1µs   4.16µs   235861.        0B     0
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
#>  1 cli_ansi       109.89µs 115.08µs    8407.     12.1KB     8.29
#>  2 base_ansi        1.31µs   1.34µs  711237.         0B     0   
#>  3 cli_plain        89.4µs  93.06µs   10384.     8.91KB     8.21
#>  4 base_plain       1.01µs   1.05µs  903954.         0B     0   
#>  5 cli_vec_ansi     4.11ms   4.24ms     236.   838.95KB    15.6 
#>  6 base_vec_ansi   71.86µs  72.13µs   13686.       848B     0   
#>  7 cli_vec_plain    2.32ms   2.37ms     420.   817.08KB    15.1 
#>  8 base_vec_plain  42.43µs  42.69µs   23095.       848B     0   
#>  9 cli_txt_ansi    14.36ms  14.44ms      69.2   114.6KB     2.04
#> 10 base_txt_ansi   72.64µs  73.92µs   13367.         0B     2.01
#> 11 cli_txt_plain  304.86µs 312.72µs    3139.    18.34KB     2.02
#> 12 base_txt_plain  40.94µs  41.94µs   23568.         0B     0
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
#>  1 cli_ansi        107.5µs  112.6µs     8568.        0B    12.4 
#>  2 base_ansi        16.8µs   17.8µs    54451.        0B    10.9 
#>  3 cli_plain       105.9µs  110.8µs     8741.        0B    12.4 
#>  4 base_plain       16.5µs   17.7µs    53958.        0B    10.8 
#>  5 cli_vec_ansi    204.2µs  214.3µs     4568.     7.2KB     6.12
#>  6 base_vec_ansi    59.3µs   64.9µs    15203.    1.66KB     4.11
#>  7 cli_vec_plain   191.4µs  201.2µs     4876.     7.2KB     6.13
#>  8 base_vec_plain   51.8µs   57.4µs    17292.    1.66KB     4.05
#>  9 cli_txt_ansi    178.6µs  184.2µs     5294.        0B     6.10
#> 10 base_txt_ansi    41.2µs   42.5µs    22931.        0B     4.59
#> 11 cli_txt_plain   162.9µs  168.5µs     5781.        0B     8.17
#> 12 base_txt_plain   34.9µs   36.2µs    27014.        0B     5.40
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
#> 1 cli          8.15µs   8.77µs   109868.        0B    11.0 
#> 2 base          851ns 901.05ns  1040125.        0B     0   
#> 3 cli_vec     25.45µs  27.08µs    36091.      448B     3.61
#> 4 base_vec    11.67µs  11.83µs    81366.      448B     0   
#> 5 cli_txt     26.11µs  27.08µs    36099.        0B     7.22
#> 6 base_txt    12.57µs  12.68µs    77753.        0B     0
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
#> 1 cli          8.15µs   8.76µs   110893.        0B    11.1 
#> 2 base         1.27µs   1.32µs   725628.        0B     0   
#> 3 cli_vec      29.2µs     30µs    32642.      448B     3.26
#> 4 base_vec    49.98µs  50.84µs    19421.      448B     2.01
#> 5 cli_txt     29.49µs  30.31µs    32323.        0B     3.23
#> 6 base_txt    86.57µs  87.57µs    11294.        0B     0
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
#> 1 cli          8.67µs   9.33µs   103720.        0B    10.4 
#> 2 base       851.11ns  902.1ns  1017213.        0B   102.  
#> 3 cli_vec     19.73µs  20.55µs    47501.      448B     4.75
#> 4 base_vec    11.62µs  11.84µs    83120.      448B     0   
#> 5 cli_txt     20.31µs   21.1µs    46367.        0B     4.64
#> 6 base_txt    12.58µs  12.69µs    77437.        0B     7.74
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
#> 1 cli          6.26µs   6.81µs   141183.    22.2KB    14.1 
#> 2 base         1.04µs   1.09µs   861653.        0B     0   
#> 3 cli_vec     33.24µs  34.08µs    28844.     1.7KB     2.88
#> 4 base_vec     8.36µs   8.59µs   113967.      848B    11.4 
#> 5 cli_txt      6.31µs   6.82µs   142146.        0B    14.2 
#> 6 base_txt     5.68µs   5.75µs   169869.        0B     0
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
