# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5590685252a0\>
\<environment: 0x559068fce038\>

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
#> 1 ansi         37.3µs   41.7µs    23438.    99.6KB     23.5
#> 2 plain        36.8µs   41.5µs    21252.        0B     22.4
#> 3 base         10.7µs   12.1µs    80000.    48.6KB     24.0
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
#> 1 ansi         39.6µs     44µs    22241.        0B     26.7
#> 2 plain        39.8µs   45.2µs    21637.        0B     26.0
#> 3 base         12.6µs   14.5µs    66975.        0B     20.1
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
#> 1 ansi        99.27µs 108.44µs     8987.   77.03KB     17.0
#> 2 plain       77.22µs  84.08µs    11536.    8.91KB     17.0
#> 3 base         1.86µs   2.06µs   461678.        0B      0
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
#> 1 ansi          284µs    309µs     3200.   33.23KB     23.7
#> 2 plain         285µs    309µs     2924.    1.09KB     19.3
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
#>  1 cli_ansi          5.62µs   6.41µs   150019.    9.27KB     30.0
#>  2 fansi_ansi       26.22µs  29.82µs    32203.    4.18KB     19.3
#>  3 cli_plain         5.56µs   6.16µs   155258.        0B     15.5
#>  4 fansi_plain      27.31µs  29.88µs    32712.      688B     13.1
#>  5 cli_vec_ansi         7µs   7.61µs   127556.      448B     12.8
#>  6 fansi_vec_ansi   36.91µs  39.71µs    24484.    5.02KB     12.2
#>  7 cli_vec_plain     7.65µs   8.32µs   117305.      448B     11.7
#>  8 fansi_vec_plain  35.53µs  38.38µs    25449.    5.02KB     10.2
#>  9 cli_txt_ansi       5.6µs   6.21µs   153602.        0B     15.4
#> 10 fansi_txt_ansi   27.44µs  30.38µs    32181.      688B     16.1
#> 11 cli_txt_plain     6.46µs   7.13µs   135924.        0B      0  
#> 12 fansi_txt_plain  35.85µs  38.54µs    25112.    5.02KB     12.6
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
#> 1 cli          56.8µs   59.3µs    16523.    22.7KB     4.06
#> 2 fansi       110.6µs  116.1µs     8454.    55.3KB     6.12
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
#>  1 cli_ansi           6.7µs   7.47µs   128703.        0B    12.9 
#>  2 fansi_ansi       73.13µs  79.18µs    12347.   38.84KB    10.4 
#>  3 base_ansi       901.99ns      1µs   907543.        0B     0   
#>  4 cli_plain         6.64µs   7.46µs   126841.        0B    12.7 
#>  5 fansi_plain      72.66µs  78.78µs    12392.      688B    12.5 
#>  6 base_plain      811.07ns 911.07ns  1029822.        0B     0   
#>  7 cli_vec_ansi     29.25µs  30.36µs    32419.      448B     3.24
#>  8 fansi_vec_ansi   94.23µs 101.08µs     9675.    5.02KB     8.33
#>  9 base_vec_ansi    18.98µs  19.12µs    51481.      448B     0   
#> 10 cli_vec_plain    27.09µs  28.04µs    35052.      448B     3.51
#> 11 fansi_vec_plain  84.83µs  90.99µs    10737.    5.02KB     8.32
#> 12 base_vec_plain   10.94µs   11.1µs    87874.      448B     8.79
#> 13 cli_txt_ansi     29.29µs  30.26µs    32409.        0B     3.24
#> 14 fansi_txt_ansi   84.69µs  91.53µs    10692.      688B     8.33
#> 15 base_txt_ansi    18.85µs  18.96µs    51758.        0B     0   
#> 16 cli_txt_plain    26.63µs  27.61µs    35667.        0B     3.57
#> 17 fansi_txt_plain  74.83µs  81.79µs    11898.      688B    10.4 
#> 18 base_txt_plain   10.93µs  11.05µs    88800.        0B     0
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
#>  1 cli_ansi          7.95µs   8.81µs   109805.        0B    11.0 
#>  2 fansi_ansi       72.34µs   78.3µs    12472.      688B    10.4 
#>  3 base_ansi          1.2µs   1.31µs   704078.        0B     0   
#>  4 cli_plain         8.03µs   8.96µs   108133.        0B    21.6 
#>  5 fansi_plain      73.09µs  79.06µs    12372.      688B    10.4 
#>  6 base_plain      991.16ns    1.1µs   829576.        0B     0   
#>  7 cli_vec_ansi     33.88µs  35.14µs    27994.      448B     2.80
#>  8 fansi_vec_ansi   97.21µs 103.74µs     9393.    5.02KB     8.31
#>  9 base_vec_ansi    41.14µs  41.78µs    23573.      448B     0   
#> 10 cli_vec_plain    32.58µs  33.83µs    28975.      448B     5.80
#> 11 fansi_vec_plain  86.38µs  92.85µs    10506.    5.02KB     8.33
#> 12 base_vec_plain   21.65µs  22.08µs    44497.      448B     0   
#> 13 cli_txt_ansi     34.42µs  35.59µs    27628.        0B     2.76
#> 14 fansi_txt_ansi   86.59µs   93.5µs    10440.      688B    10.4 
#> 15 base_txt_ansi     43.2µs   43.8µs    22497.        0B     0   
#> 16 cli_txt_plain    31.98µs  33.15µs    29640.        0B     2.96
#> 17 fansi_txt_plain  78.06µs  84.69µs    11518.      688B    10.5 
#> 18 base_txt_plain      23µs  23.26µs    42299.        0B     0
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
#> 1 cli_ansi        6.46µs   7.13µs   135211.        0B    13.5 
#> 2 cli_plain       6.11µs   6.83µs   140752.        0B    14.1 
#> 3 cli_vec_ansi   30.93µs   32.1µs    30630.      848B     3.06
#> 4 cli_vec_plain  10.12µs  10.94µs    88931.      848B     8.89
#> 5 cli_txt_ansi   30.06µs  31.37µs    31306.        0B     3.13
#> 6 cli_txt_plain   7.03µs   7.78µs   124617.        0B    12.5
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
#>  1 cli_ansi          24.1µs   26.4µs    37022.        0B    14.8 
#>  2 fansi_ansi        25.8µs   28.4µs    34270.    7.24KB    17.1 
#>  3 cli_plain         24.1µs   26.3µs    37163.        0B    14.9 
#>  4 fansi_plain       24.8µs   26.6µs    36467.      688B    14.6 
#>  5 cli_vec_ansi      32.9µs   35.4µs    27698.      848B    11.1 
#>  6 fansi_vec_ansi    51.5µs   53.7µs    18222.    5.41KB     8.34
#>  7 cli_vec_plain     26.7µs   28.3µs    34568.      848B    13.8 
#>  8 fansi_vec_plain   34.7µs   36.7µs    26721.    4.59KB    10.7 
#>  9 cli_txt_ansi      32.8µs   35.3µs    27788.        0B    13.9 
#> 10 fansi_txt_ansi      42µs   44.3µs    22184.    5.12KB     8.88
#> 11 cli_txt_plain     24.9µs   26.9µs    36374.        0B    14.6 
#> 12 fansi_txt_plain   26.7µs   28.8µs    33912.      688B    13.6
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
#>  1 cli_ansi        131.49µs 141.32µs     6754.  104.86KB    12.5 
#>  2 fansi_ansi      108.72µs 118.33µs     8308.  106.35KB    12.6 
#>  3 base_ansi         4.08µs   4.44µs   219264.      224B     0   
#>  4 cli_plain        131.3µs 140.74µs     6926.    8.09KB    12.5 
#>  5 fansi_plain      106.9µs 117.09µs     8397.    9.62KB    12.6 
#>  6 base_plain        3.56µs   3.86µs   250681.        0B     0   
#>  7 cli_vec_ansi      6.45ms   6.74ms      148.  823.77KB    16.5 
#>  8 fansi_vec_ansi    1.02ms   1.06ms      918.  846.81KB    17.5 
#>  9 base_vec_ansi   153.44µs 160.71µs     6102.    22.7KB     2.04
#> 10 cli_vec_plain     6.41ms   6.68ms      150.  823.77KB    13.6 
#> 11 fansi_vec_plain 993.06µs   1.03ms      958.  845.98KB    20.4 
#> 12 base_vec_plain  107.54µs  112.4µs     8718.      848B     2.01
#> 13 cli_txt_ansi      3.27ms   3.32ms      300.    63.6KB     0   
#> 14 fansi_txt_ansi    1.61ms   1.64ms      605.   35.05KB     2.02
#> 15 base_txt_ansi   142.66µs 152.91µs     6527.   18.47KB     2.03
#> 16 cli_txt_plain     2.44ms   2.47ms      404.    63.6KB     0   
#> 17 fansi_txt_plain 534.13µs 558.73µs     1771.    30.6KB     2.03
#> 18 base_txt_plain   91.53µs  94.56µs    10267.   11.05KB     2.02
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
#>  1 cli_ansi         128.5µs 136.89µs     7129.   33.84KB    14.6 
#>  2 fansi_ansi       49.38µs  54.19µs    18044.   31.42KB    12.9 
#>  3 base_ansi         1.04µs   1.15µs   811686.     4.2KB     0   
#>  4 cli_plain       128.88µs 136.24µs     7187.        0B    14.6 
#>  5 fansi_plain       49.3µs  53.98µs    18111.      872B    12.5 
#>  6 base_plain       970.9ns   1.07µs   864729.        0B     0   
#>  7 cli_vec_ansi    250.07µs 263.14µs     3472.   16.73KB     7.68
#>  8 fansi_vec_ansi  113.36µs 174.79µs     6227.    5.59KB     4.10
#>  9 base_vec_ansi    36.62µs  36.94µs    26710.      848B     0   
#> 10 cli_vec_plain   209.54µs  216.3µs     4543.   16.73KB    10.5 
#> 11 fansi_vec_plain 104.09µs 107.58µs     9150.    5.59KB     6.17
#> 12 base_vec_plain   30.53µs  30.82µs    32025.      848B     0   
#> 13 cli_txt_ansi    133.89µs 139.43µs     7026.        0B    14.6 
#> 14 fansi_txt_ansi   48.21µs  51.74µs    18494.      872B    12.6 
#> 15 base_txt_ansi     1.06µs    1.2µs   742668.        0B     0   
#> 16 cli_txt_plain   127.14µs 135.39µs     7287.        0B    14.6 
#> 17 fansi_txt_plain  47.97µs  52.84µs    18625.      872B    14.7 
#> 18 base_txt_plain  982.08ns   1.11µs   854366.        0B     0
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
#>  1 cli_ansi        348.82µs 375.08µs    2626.     6.18KB    12.6 
#>  2 fansi_ansi       87.63µs  95.21µs   10245.    97.33KB    12.5 
#>  3 base_ansi        32.41µs  34.73µs   27871.         0B    13.9 
#>  4 cli_plain       221.91µs 237.38µs    4088.         0B    12.6 
#>  5 fansi_plain      86.77µs  94.84µs   10329.       872B    12.5 
#>  6 base_plain       26.07µs  28.09µs   34677.         0B    10.4 
#>  7 cli_vec_ansi     37.89ms  38.06ms      26.2   94.67KB    30.6 
#>  8 fansi_vec_ansi  233.85µs 246.52µs    4008.     7.25KB     6.17
#>  9 base_vec_ansi     2.21ms   2.28ms     437.    48.18KB    12.9 
#> 10 cli_vec_plain    23.54ms  23.83ms      42.0    2.48KB    18.0 
#> 11 fansi_vec_plain 185.63µs 195.53µs    5018.     6.42KB     8.28
#> 12 base_vec_plain    1.61ms   1.69ms     586.     47.4KB    10.6 
#> 13 cli_txt_ansi     27.18ms  27.66ms      36.1    4.27MB     7.22
#> 14 fansi_txt_ansi  227.21µs 238.69µs    4136.     6.77KB     6.15
#> 15 base_txt_ansi     1.29ms   1.33ms     745.   582.06KB     8.97
#> 16 cli_txt_plain     1.27ms   1.32ms     744.   369.84KB     8.81
#> 17 fansi_txt_plain 174.41µs 184.39µs    5330.     2.51KB     6.19
#> 18 base_txt_plain  871.86µs 915.23µs    1072.   367.31KB    11.3
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
#>  1 cli_ansi           6.3µs   7.17µs   133179.   25.09KB    13.3 
#>  2 fansi_ansi       69.09µs  72.86µs    13370.   28.48KB    12.6 
#>  3 base_ansi         1.03µs   1.15µs   809697.        0B     0   
#>  4 cli_plain         6.36µs   6.99µs   138771.        0B    27.8 
#>  5 fansi_plain      69.68µs  73.61µs    13273.    1.98KB    12.6 
#>  6 base_plain           1µs   1.11µs   855552.        0B     0   
#>  7 cli_vec_ansi     26.31µs  27.52µs    35835.     1.7KB     3.58
#>  8 fansi_vec_ansi  105.61µs 110.61µs     8877.    8.86KB     8.38
#>  9 base_vec_ansi      6.2µs   6.47µs   151103.      848B     0   
#> 10 cli_vec_plain    23.25µs  24.36µs    40351.     1.7KB     8.07
#> 11 fansi_vec_plain 102.26µs 109.16µs     8959.    8.86KB     8.39
#> 12 base_vec_plain    5.86µs   6.22µs   157669.      848B     0   
#> 13 cli_txt_ansi      6.39µs    7.2µs   133811.        0B    13.4 
#> 14 fansi_txt_ansi    70.5µs  77.55µs    12701.    1.98KB    12.6 
#> 15 base_txt_ansi     7.06µs   7.21µs   135662.        0B     0   
#> 16 cli_txt_plain     7.44µs   8.31µs   116734.        0B    11.7 
#> 17 fansi_txt_plain  70.75µs  77.56µs    12693.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.53µs   213935.        0B     0
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
#>  1 cli_ansi        92.91µs   99.7µs    9780.     12.1KB     8.25
#>  2 base_ansi        1.27µs   1.36µs  692499.         0B     0   
#>  3 cli_plain        72.9µs  78.38µs   12433.     8.91KB    10.4 
#>  4 base_plain     991.04ns   1.07µs  892251.         0B     0   
#>  5 cli_vec_ansi     4.21ms   4.44ms     226.   838.95KB    13.3 
#>  6 base_vec_ansi   70.29µs   71.7µs   13817.       848B     0   
#>  7 cli_vec_plain    2.33ms   2.46ms     406.   817.08KB    15.3 
#>  8 base_vec_plain  41.61µs  43.05µs   23056.       848B     0   
#>  9 cli_txt_ansi     15.6ms   15.7ms      63.5   114.6KB     2.05
#> 10 base_txt_ansi   68.75µs  70.32µs   13972.         0B     0   
#> 11 cli_txt_plain  296.22µs 315.06µs    2997.    18.34KB     2.01
#> 12 base_txt_plain  39.64µs  40.26µs   24508.         0B     2.45
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
#>  1 cli_ansi         88.8µs   95.2µs    10289.        0B    14.6 
#>  2 base_ansi        15.1µs   16.7µs    58239.        0B    11.7 
#>  3 cli_plain        89.3µs   95.5µs    10268.        0B    14.6 
#>  4 base_plain       15.1µs   16.5µs    59035.        0B    11.8 
#>  5 cli_vec_ansi    191.1µs  201.2µs     4894.     7.2KB     6.17
#>  6 base_vec_ansi    54.6µs   61.8µs    16008.    1.66KB     4.08
#>  7 cli_vec_plain   176.9µs  186.4µs     5282.     7.2KB     6.18
#>  8 base_vec_plain   47.9µs   54.8µs    17884.    1.66KB     4.08
#>  9 cli_txt_ansi    169.9µs  176.5µs     5565.        0B     8.23
#> 10 base_txt_ansi    40.8µs   42.6µs    23034.        0B     4.61
#> 11 cli_txt_plain   152.3µs  159.5µs     6159.        0B     8.22
#> 12 base_txt_plain   34.6µs   36.3µs    26985.        0B     5.40
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
#> 1 cli          7.73µs   8.59µs   112521.        0B    22.5 
#> 2 base          851ns 960.89ns   976011.        0B     0   
#> 3 cli_vec     22.95µs  24.02µs    40852.      448B     4.09
#> 4 base_vec    12.28µs  12.59µs    77996.      448B     0   
#> 5 cli_txt     23.04µs  23.99µs    40856.        0B     4.09
#> 6 base_txt    13.68µs  13.95µs    70558.        0B     0
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
#> 1 cli          7.57µs   8.41µs   115267.        0B    11.5 
#> 2 base          1.3µs   1.43µs   656425.        0B     0   
#> 3 cli_vec     29.96µs   31.5µs    31258.      448B     3.13
#> 4 base_vec    54.32µs  55.12µs    17897.      448B     0   
#> 5 cli_txt     30.29µs  32.11µs    30673.        0B     3.07
#> 6 base_txt    89.51µs  90.45µs    10927.        0B     2.01
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
#> 1 cli          8.29µs   9.22µs   104974.        0B    10.5 
#> 2 base       860.89ns 952.04ns   945886.        0B     0   
#> 3 cli_vec     19.98µs   21.1µs    46433.      448B     9.29
#> 4 base_vec     12.3µs  12.57µs    78252.      448B     0   
#> 5 cli_txt     20.79µs  22.16µs    44278.        0B     4.43
#> 6 base_txt    13.41µs  13.83µs    71088.        0B     0
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
#> 1 cli          6.15µs    7.1µs   135493.    22.2KB    27.1 
#> 2 base         1.05µs   1.18µs   789612.        0B     0   
#> 3 cli_vec     30.43µs  31.99µs    30725.     1.7KB     3.07
#> 4 base_vec     8.57µs   8.86µs   110553.      848B     0   
#> 5 cli_txt      6.14µs   7.06µs   136720.        0B    13.7 
#> 6 base_txt     5.55µs   6.04µs   160353.        0B    16.0
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
#>  date     2026-06-01
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-06-01 [1] local
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
