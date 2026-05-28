# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55f19c196028\>
\<environment: 0x55f19cc36f60\>

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
#> 1 ansi         39.1µs   43.1µs    22648.    99.6KB     22.7
#> 2 plain          38µs   42.7µs    22789.        0B     22.8
#> 3 base         10.7µs   12.4µs    78390.    48.6KB     23.5
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
#> 1 ansi         40.5µs   45.3µs    21529.        0B     26.3
#> 2 plain        40.5µs   45.2µs    21568.        0B     25.9
#> 3 base         12.7µs   14.7µs    66329.        0B     26.5
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
#> 1 ansi         92.7µs 101.78µs     9563.   76.15KB     19.2
#> 2 plain       71.11µs  78.09µs    12429.    8.73KB     16.9
#> 3 base         1.87µs   2.12µs   446998.        0B     44.7
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
#> 1 ansi          283µs    312µs     3164.   33.23KB     24.1
#> 2 plain         288µs    313µs     3163.    1.09KB     21.6
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
#>  1 cli_ansi           5.6µs   6.46µs   148998.    9.27KB     14.9
#>  2 fansi_ansi       27.19µs  30.41µs    31274.    4.18KB     18.8
#>  3 cli_plain         5.52µs   6.14µs   154590.        0B     15.5
#>  4 fansi_plain      27.67µs  30.09µs    32462.      688B     13.0
#>  5 cli_vec_ansi      6.88µs   7.54µs   128802.      448B     12.9
#>  6 fansi_vec_ansi   36.85µs  39.93µs    24330.    5.02KB     12.2
#>  7 cli_vec_plain     7.57µs   8.27µs   117348.      448B     11.7
#>  8 fansi_vec_plain  35.64µs  38.38µs    25442.    5.02KB     10.2
#>  9 cli_txt_ansi      5.57µs   6.18µs   157029.        0B     15.7
#> 10 fansi_txt_ansi   27.76µs  30.64µs    31823.      688B     12.7
#> 11 cli_txt_plain     6.49µs    7.1µs   136050.        0B     13.6
#> 12 fansi_txt_plain  35.68µs  38.58µs    25290.    5.02KB     12.7
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
#> 1 cli          55.6µs   58.4µs    16793.    22.7KB     4.06
#> 2 fansi       110.8µs  116.4µs     8407.    55.3KB     6.13
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
#>  1 cli_ansi          6.68µs   7.54µs   127527.        0B    12.8 
#>  2 fansi_ansi       72.59µs  78.74µs    12400.   38.84KB    10.3 
#>  3 base_ansi       901.05ns   1.01µs   896195.        0B     0   
#>  4 cli_plain          6.6µs   7.39µs   130635.        0B    13.1 
#>  5 fansi_plain      72.46µs   78.7µs    12387.      688B    12.5 
#>  6 base_plain      822.01ns    912ns  1012842.        0B     0   
#>  7 cli_vec_ansi      27.6µs   29.5µs    33402.      448B     3.34
#>  8 fansi_vec_ansi   92.83µs 100.15µs     9770.    5.02KB     8.32
#>  9 base_vec_ansi    18.91µs  19.06µs    51610.      448B     0   
#> 10 cli_vec_plain    25.73µs  27.25µs    36007.      448B     3.60
#> 11 fansi_vec_plain  84.02µs  90.69µs     9491.    5.02KB     8.31
#> 12 base_vec_plain   11.01µs  11.13µs    88215.      448B     0   
#> 13 cli_txt_ansi     28.12µs  29.61µs    33366.        0B     3.34
#> 14 fansi_txt_ansi   85.51µs  91.95µs    10626.      688B    10.5 
#> 15 base_txt_ansi    18.87µs  18.98µs    51840.        0B     0   
#> 16 cli_txt_plain    25.17µs  26.75µs    36088.        0B     3.61
#> 17 fansi_txt_plain  75.04µs  81.13µs    11986.      688B    10.3 
#> 18 base_txt_plain   10.91µs  11.03µs    88622.        0B     0
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
#>  1 cli_ansi             8µs   9.08µs   105958.        0B    10.6 
#>  2 fansi_ansi        72.7µs  79.28µs    12301.      688B    12.5 
#>  3 base_ansi          1.2µs    1.3µs   721384.        0B     0   
#>  4 cli_plain         7.92µs   8.95µs   108075.        0B    10.8 
#>  5 fansi_plain      72.23µs  78.75µs    12395.      688B    10.3 
#>  6 base_plain      982.08ns   1.09µs   819089.        0B    81.9 
#>  7 cli_vec_ansi     34.21µs  35.56µs    27651.      448B     2.77
#>  8 fansi_vec_ansi   96.66µs 103.14µs     9447.    5.02KB     8.30
#>  9 base_vec_ansi     41.1µs  41.71µs    23470.      448B     0   
#> 10 cli_vec_plain    32.04µs  33.39µs    29439.      448B     2.94
#> 11 fansi_vec_plain  85.66µs  92.07µs    10578.    5.02KB    10.5 
#> 12 base_vec_plain   21.66µs  22.02µs    44528.      448B     0   
#> 13 cli_txt_ansi     34.47µs  35.66µs    27478.        0B     2.75
#> 14 fansi_txt_ansi   87.04µs  94.63µs    10307.      688B     8.22
#> 15 base_txt_ansi     43.2µs   43.8µs    22510.        0B     2.25
#> 16 cli_txt_plain    31.84µs  32.98µs    29381.        0B     2.94
#> 17 fansi_txt_plain   77.2µs  83.66µs    11606.      688B    10.5 
#> 18 base_txt_plain   23.02µs  23.25µs    42393.        0B     0
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
#> 1 cli_ansi        6.48µs   7.15µs   135321.        0B    13.5 
#> 2 cli_plain       6.09µs   6.79µs   141349.        0B    14.1 
#> 3 cli_vec_ansi   30.53µs  32.07µs    30701.      848B     3.07
#> 4 cli_vec_plain  10.13µs  11.02µs    88577.      848B     8.86
#> 5 cli_txt_ansi   29.73µs  31.34µs    31451.        0B     3.15
#> 6 cli_txt_plain   7.05µs   7.85µs   123411.        0B    12.3
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
#>  1 cli_ansi          23.5µs   25.9µs    37662.        0B    15.1 
#>  2 fansi_ansi        25.5µs   27.9µs    34927.    7.24KB    14.0 
#>  3 cli_plain         23.3µs   25.8µs    37757.        0B    18.9 
#>  4 fansi_plain       25.1µs   26.8µs    36461.      688B    14.6 
#>  5 cli_vec_ansi      33.4µs   35.5µs    27633.      848B    11.1 
#>  6 fansi_vec_ansi    51.1µs   53.8µs    18229.    5.41KB     8.38
#>  7 cli_vec_plain     26.5µs   28.4µs    34539.      848B    13.8 
#>  8 fansi_vec_plain   34.9µs   36.9µs    26557.    4.59KB    10.6 
#>  9 cli_txt_ansi      32.7µs   35.3µs    27786.        0B    11.1 
#> 10 fansi_txt_ansi    41.7µs   44.2µs    22242.    5.12KB     8.90
#> 11 cli_txt_plain     24.8µs   26.9µs    36434.        0B    18.2 
#> 12 fansi_txt_plain   26.3µs   28.8µs    33547.      688B    13.4
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
#>  1 cli_ansi        131.85µs 141.08µs     6902.  104.86KB    12.6 
#>  2 fansi_ansi      109.21µs 119.09µs     8143.  106.35KB    12.6 
#>  3 base_ansi         4.03µs    4.5µs   216325.      224B     0   
#>  4 cli_plain       131.12µs 142.73µs     6798.    8.09KB    12.6 
#>  5 fansi_plain     109.39µs 119.62µs     8090.    9.62KB    10.5 
#>  6 base_plain        3.55µs   4.08µs   231544.        0B    23.2 
#>  7 cli_vec_ansi      6.83ms   7.21ms      106.  823.77KB     9.03
#>  8 fansi_vec_ansi    1.03ms   1.08ms      897.  846.81KB    17.6 
#>  9 base_vec_ansi   155.17µs 164.79µs     5974.    22.7KB     2.03
#> 10 cli_vec_plain     6.68ms   6.94ms      143.  823.77KB    16.7 
#> 11 fansi_vec_plain      1ms   1.05ms      931.  845.98KB    18.2 
#> 12 base_vec_plain  105.83µs 110.36µs     8866.      848B     2.02
#> 13 cli_txt_ansi      3.25ms   3.33ms      300.    63.6KB     0   
#> 14 fansi_txt_ansi    1.61ms   1.65ms      601.   35.05KB     2.02
#> 15 base_txt_ansi   142.32µs 151.78µs     6455.   18.47KB     2.02
#> 16 cli_txt_plain     2.36ms    2.4ms      414.    63.6KB     0   
#> 17 fansi_txt_plain 533.48µs 557.45µs     1733.    30.6KB     2.03
#> 18 base_txt_plain   91.77µs  96.08µs    10241.   11.05KB     2.03
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
#>  1 cli_ansi        131.13µs 140.83µs     6579.   33.84KB    12.6 
#>  2 fansi_ansi       49.41µs  55.29µs    16137.   31.42KB    13.1 
#>  3 base_ansi         1.03µs   1.16µs   799950.     4.2KB     0   
#>  4 cli_plain          129µs 138.44µs     6913.        0B    12.5 
#>  5 fansi_plain      49.85µs  54.94µs    17404.      872B    12.6 
#>  6 base_plain      961.01ns   1.08µs   787268.        0B     0   
#>  7 cli_vec_ansi    253.28µs 266.85µs     3680.   16.73KB     8.35
#>  8 fansi_vec_ansi  114.41µs 120.85µs     7618.    5.59KB     7.07
#>  9 base_vec_ansi    36.33µs   36.8µs    26596.      848B     0   
#> 10 cli_vec_plain   210.24µs 219.09µs     4352.   16.73KB     8.36
#> 11 fansi_vec_plain 104.04µs 108.87µs     8338.    5.59KB     6.19
#> 12 base_vec_plain   30.14µs  30.47µs    32071.      848B     0   
#> 13 cli_txt_ansi    136.44µs 143.43µs     6194.        0B    12.5 
#> 14 fansi_txt_ansi   48.95µs  51.91µs    18080.      872B    12.5 
#> 15 base_txt_ansi     1.08µs    1.2µs   780308.        0B     0   
#> 16 cli_txt_plain   127.23µs 138.55µs     6926.        0B    14.8 
#> 17 fansi_txt_plain  49.42µs  54.28µs    17656.      872B    12.5 
#> 18 base_txt_plain  991.04ns   1.11µs   827891.        0B     0
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
#>  1 cli_ansi        352.52µs  385.7µs    2308.     6.18KB    12.7 
#>  2 fansi_ansi       86.72µs   95.5µs   10026.    97.33KB    10.5 
#>  3 base_ansi        32.38µs  35.05µs   27193.         0B    13.6 
#>  4 cli_plain       222.41µs 247.91µs    2960.         0B     8.27
#>  5 fansi_plain      86.18µs  95.44µs   10068.       872B    12.5 
#>  6 base_plain       25.96µs  28.57µs   33736.         0B    13.5 
#>  7 cli_vec_ansi     38.45ms  38.82ms      25.7   94.67KB    22.0 
#>  8 fansi_vec_ansi  233.34µs 246.46µs    4001.     7.25KB     6.17
#>  9 base_vec_ansi     2.22ms    2.3ms     431.    48.18KB    12.9 
#> 10 cli_vec_plain    23.61ms  23.96ms      41.4    2.48KB    17.7 
#> 11 fansi_vec_plain 186.67µs 197.67µs    4902.     6.42KB     8.31
#> 12 base_vec_plain    1.61ms   1.69ms     585.     47.4KB    13.0 
#> 13 cli_txt_ansi      27.8ms  28.18ms      35.4    4.27MB     4.43
#> 14 fansi_txt_ansi  227.36µs 239.43µs    3698.     6.77KB     6.18
#> 15 base_txt_ansi     1.29ms   1.33ms     735.   582.06KB     9.31
#> 16 cli_txt_plain     1.29ms   1.34ms     728.   369.84KB     8.86
#> 17 fansi_txt_plain 173.99µs 184.13µs    5300.     2.51KB     6.17
#> 18 base_txt_plain  869.87µs 917.35µs    1061.   367.31KB     8.82
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
#>  1 cli_ansi          6.45µs   7.44µs   129073.   25.09KB    12.9 
#>  2 fansi_ansi       71.28µs  78.26µs    12381.   28.48KB    12.7 
#>  3 base_ansi         1.03µs   1.15µs   777553.        0B     0   
#>  4 cli_plain          6.4µs    7.4µs   129215.        0B    12.9 
#>  5 fansi_plain      69.35µs  73.31µs    13050.    1.98KB    13.5 
#>  6 base_plain      971.02ns   1.09µs   847400.        0B     0   
#>  7 cli_vec_ansi     26.49µs  27.72µs    35459.     1.7KB     3.55
#>  8 fansi_vec_ansi  106.09µs  110.7µs     8753.    8.86KB     8.42
#>  9 base_vec_ansi     6.23µs   6.62µs   146703.      848B     0   
#> 10 cli_vec_plain    23.14µs  24.26µs    40194.     1.7KB     4.02
#> 11 fansi_vec_plain 100.31µs 105.08µs     9184.    8.86KB    10.6 
#> 12 base_vec_plain    5.72µs   6.15µs   159428.      848B     0   
#> 13 cli_txt_ansi      6.46µs   7.12µs   136413.        0B    13.6 
#> 14 fansi_txt_ansi   69.57µs  73.93µs    13066.    1.98KB    12.8 
#> 15 base_txt_ansi     7.07µs    7.2µs   134546.        0B     0   
#> 16 cli_txt_plain     7.21µs   8.18µs   117269.        0B    11.7 
#> 17 fansi_txt_plain  70.53µs  77.34µs    12539.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.54µs   209570.        0B     0
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
#>  1 cli_ansi        87.65µs  94.54µs   10236.    11.88KB    10.4 
#>  2 base_ansi        1.27µs   1.36µs  676904.         0B     0   
#>  3 cli_plain       68.08µs  73.41µs   13050.     8.73KB     8.24
#>  4 base_plain     982.08ns   1.07µs  871388.         0B     0   
#>  5 cli_vec_ansi     4.12ms   4.35ms     229.   838.77KB    15.9 
#>  6 base_vec_ansi   70.07µs  70.47µs   13995.       848B     0   
#>  7 cli_vec_plain    2.31ms   2.41ms     413.    816.9KB    12.9 
#>  8 base_vec_plain  41.86µs  43.16µs   22899.       848B     0   
#>  9 cli_txt_ansi    15.52ms  15.67ms      63.7  114.42KB     4.24
#> 10 base_txt_ansi   68.91µs  70.36µs   13974.         0B     0   
#> 11 cli_txt_plain  265.08µs 275.62µs    3569.    18.16KB     2.02
#> 12 base_txt_plain  40.12µs  40.39µs   24472.         0B     0
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
#>  1 cli_ansi         89.4µs   96.3µs    10056.        0B    14.6 
#>  2 base_ansi        15.4µs     17µs    57122.        0B    11.4 
#>  3 cli_plain          89µs   95.3µs    10276.        0B    14.6 
#>  4 base_plain       15.2µs   16.6µs    58512.        0B    11.7 
#>  5 cli_vec_ansi    188.4µs  199.5µs     4917.     7.2KB     6.18
#>  6 base_vec_ansi    54.4µs     61µs    16382.    1.66KB     4.07
#>  7 cli_vec_plain   174.7µs  186.7µs     5235.     7.2KB     6.17
#>  8 base_vec_plain   47.9µs   54.2µs    18306.    1.66KB     4.07
#>  9 cli_txt_ansi    167.3µs  175.3µs     5578.        0B     8.24
#> 10 base_txt_ansi    40.6µs   42.7µs    22834.        0B     4.57
#> 11 cli_txt_plain   151.6µs  159.2µs     6142.        0B     8.20
#> 12 base_txt_plain   34.1µs   36.3µs    26896.        0B     5.38
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
#> 1 cli          7.74µs   8.72µs   109445.        0B    21.9 
#> 2 base          851ns 951.11ns   959061.        0B     0   
#> 3 cli_vec     23.34µs  24.84µs    39425.      448B     3.94
#> 4 base_vec    12.26µs  12.54µs    78103.      448B     0   
#> 5 cli_txt     23.43µs  24.62µs    39703.        0B     3.97
#> 6 base_txt    13.39µs  13.98µs    69808.        0B     0
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
#> 1 cli           7.7µs    8.7µs   108611.        0B    10.9 
#> 2 base         1.31µs   1.42µs   651553.        0B     0   
#> 3 cli_vec     29.54µs  31.08µs    31266.      448B     3.13
#> 4 base_vec    54.03µs  55.16µs    17853.      448B     0   
#> 5 cli_txt     29.82µs  31.13µs    31116.        0B     3.11
#> 6 base_txt    89.36µs  90.49µs    10913.        0B     2.04
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
#> 1 cli          8.23µs   9.48µs   103219.        0B    10.3 
#> 2 base        841.1ns 952.04ns   926043.        0B     0   
#> 3 cli_vec      19.8µs  21.09µs    46293.      448B     9.26
#> 4 base_vec    12.23µs  12.59µs    78139.      448B     0   
#> 5 cli_txt     20.83µs  22.18µs    44169.        0B     4.42
#> 6 base_txt     13.4µs   13.8µs    71368.        0B     0
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
#> 1 cli          6.19µs   7.01µs   137299.    22.2KB    27.5 
#> 2 base         1.03µs   1.17µs   798727.        0B     0   
#> 3 cli_vec     30.48µs  31.98µs    30779.     1.7KB     3.08
#> 4 base_vec     8.59µs   8.84µs   110341.      848B     0   
#> 5 cli_txt      6.13µs   7.05µs   136445.        0B    13.6 
#> 6 base_txt     5.56µs   5.96µs   163665.        0B    16.4
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
