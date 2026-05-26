# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55a04ff43b98\>
\<environment: 0x55a0509e4b10\>

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
#> 1 ansi         38.7µs   43.3µs    22628.    99.6KB     22.7
#> 2 plain        38.1µs   43.1µs    22575.        0B     22.7
#> 3 base         10.8µs   12.9µs    71480.    48.6KB     21.5
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
#> 1 ansi         40.4µs   46.1µs    21063.        0B     26.5
#> 2 plain        40.2µs   45.5µs    21266.        0B     23.8
#> 3 base         12.7µs   15.1µs    57147.        0B     22.9
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
#> 1 ansi        95.45µs 104.74µs     9315.   76.15KB     19.3
#> 2 plain       71.93µs  79.96µs    12072.    8.73KB     17.0
#> 3 base         1.85µs   2.09µs   449565.        0B      0
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
#> 1 ansi          287µs    315µs     3143.   33.23KB     21.7
#> 2 plain         290µs    316µs     3138.    1.09KB     24.0
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
#>  1 cli_ansi          5.61µs   6.66µs   142451.    9.27KB    28.5 
#>  2 fansi_ansi       27.71µs  32.22µs    27903.    4.18KB    16.8 
#>  3 cli_plain          5.5µs   6.24µs   151214.        0B    15.1 
#>  4 fansi_plain      27.26µs  30.55µs    31771.      688B    15.9 
#>  5 cli_vec_ansi      6.91µs    7.7µs   125217.      448B    12.5 
#>  6 fansi_vec_ansi   36.86µs  40.33µs    23267.    5.02KB     9.31
#>  7 cli_vec_plain     7.65µs   8.39µs   115657.      448B    11.6 
#>  8 fansi_vec_plain  35.77µs  39.88µs    21279.    5.02KB     8.51
#>  9 cli_txt_ansi      5.59µs   6.36µs   136323.        0B    13.6 
#> 10 fansi_txt_ansi   27.52µs  30.68µs    31841.      688B    15.9 
#> 11 cli_txt_plain     6.53µs   7.26µs   130416.        0B    13.0 
#> 12 fansi_txt_plain  35.79µs  39.47µs    24385.    5.02KB     9.76
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
#> 1 cli          56.6µs   58.9µs    16547.    22.7KB     6.14
#> 2 fansi       110.3µs  116.6µs     8415.    55.3KB     4.06
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
#>  1 cli_ansi          6.64µs   7.54µs   124548.        0B    12.5 
#>  2 fansi_ansi       72.28µs  79.31µs    12314.   38.84KB    10.4 
#>  3 base_ansi       901.87ns      1µs   912702.        0B    91.3 
#>  4 cli_plain         6.53µs   7.36µs   131251.        0B    13.1 
#>  5 fansi_plain       72.6µs  78.95µs    12373.      688B    10.4 
#>  6 base_plain      830.97ns    912ns   985371.        0B     0   
#>  7 cli_vec_ansi     28.09µs   29.8µs    32960.      448B     3.30
#>  8 fansi_vec_ansi   94.86µs 101.47µs     9606.    5.02KB     8.33
#>  9 base_vec_ansi    18.95µs  19.06µs    51541.      448B     0   
#> 10 cli_vec_plain    25.83µs  27.72µs    35416.      448B     3.54
#> 11 fansi_vec_plain  84.05µs  91.42µs    10640.    5.02KB    10.5 
#> 12 base_vec_plain   10.99µs  11.12µs    87992.      448B     0   
#> 13 cli_txt_ansi     28.09µs  29.66µs    33141.        0B     3.31
#> 14 fansi_txt_ansi   85.02µs  92.51µs    10547.      688B     8.36
#> 15 base_txt_ansi    18.86µs  18.95µs    51370.        0B     0   
#> 16 cli_txt_plain    26.04µs   27.1µs    36255.        0B     3.63
#> 17 fansi_txt_plain  74.99µs  81.82µs    11968.      688B    10.4 
#> 18 base_txt_plain   10.92µs  11.03µs    88610.        0B     8.86
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
#>  1 cli_ansi          7.99µs      9µs   107502.        0B    10.8 
#>  2 fansi_ansi       72.39µs  79.57µs    12300.      688B    10.4 
#>  3 base_ansi         1.21µs   1.31µs   687504.        0B     0   
#>  4 cli_plain         7.92µs   8.99µs   107551.        0B    21.5 
#>  5 fansi_plain      72.71µs   79.8µs    12233.      688B    10.4 
#>  6 base_plain      991.04ns   1.09µs   814775.        0B     0   
#>  7 cli_vec_ansi     34.52µs  36.15µs    27185.      448B     2.72
#>  8 fansi_vec_ansi   96.93µs 104.47µs     9342.    5.02KB     8.32
#>  9 base_vec_ansi    40.92µs  41.61µs    23728.      448B     0   
#> 10 cli_vec_plain    32.01µs  33.35µs    29434.      448B     5.89
#> 11 fansi_vec_plain  87.23µs  94.66µs    10294.    5.02KB     8.34
#> 12 base_vec_plain   21.62µs  21.99µs    44751.      448B     0   
#> 13 cli_txt_ansi     35.44µs  36.65µs    26744.        0B     2.67
#> 14 fansi_txt_ansi   89.29µs  96.65µs    10059.      688B    10.4 
#> 15 base_txt_ansi    43.23µs  44.52µs    22226.        0B     0   
#> 16 cli_txt_plain    32.04µs  33.74µs    29261.        0B     2.93
#> 17 fansi_txt_plain  78.57µs  86.28µs    11305.      688B    10.5 
#> 18 base_txt_plain   22.96µs  23.23µs    42352.        0B     0
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
#> 1 cli_ansi        6.51µs   7.24µs   133287.        0B    13.3 
#> 2 cli_plain       6.07µs   6.82µs   141189.        0B    14.1 
#> 3 cli_vec_ansi   30.88µs  32.23µs    30353.      848B     3.04
#> 4 cli_vec_plain  10.15µs  11.05µs    88103.      848B     8.81
#> 5 cli_txt_ansi   30.39µs  31.46µs    31334.        0B     3.13
#> 6 cli_txt_plain   7.06µs   7.89µs   122937.        0B    12.3
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
#>  1 cli_ansi          24.3µs   26.7µs    36588.        0B    14.6 
#>  2 fansi_ansi          26µs   28.7µs    34002.    7.24KB    13.6 
#>  3 cli_plain         24.1µs   26.6µs    36720.        0B    18.4 
#>  4 fansi_plain       25.2µs   27.3µs    35519.      688B    14.2 
#>  5 cli_vec_ansi      33.8µs     36µs    27239.      848B    10.9 
#>  6 fansi_vec_ansi    51.4µs   54.2µs    18112.    5.41KB     8.42
#>  7 cli_vec_plain     26.4µs   28.5µs    34347.      848B    13.7 
#>  8 fansi_vec_plain   34.8µs   37.2µs    26255.    4.59KB    10.5 
#>  9 cli_txt_ansi      33.2µs   35.8µs    27284.        0B    10.9 
#> 10 fansi_txt_ansi    42.2µs   44.8µs    21766.    5.12KB     8.71
#> 11 cli_txt_plain     24.9µs   27.4µs    35670.        0B    17.8 
#> 12 fansi_txt_plain     27µs   29.3µs    33321.      688B    13.3
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
#>  1 cli_ansi        133.83µs 144.58µs     6711.  104.86KB    12.6 
#>  2 fansi_ansi      109.55µs 120.11µs     8130.  106.35KB    12.6 
#>  3 base_ansi         4.09µs   4.55µs   214026.      224B     0   
#>  4 cli_plain       130.41µs 142.21µs     6741.    8.09KB    12.6 
#>  5 fansi_plain      108.9µs 119.18µs     8220.    9.62KB    10.4 
#>  6 base_plain        3.65µs   4.04µs   237566.        0B    23.8 
#>  7 cli_vec_ansi      6.79ms      7ms      142.  823.77KB    14.0 
#>  8 fansi_vec_ansi    1.05ms   1.09ms      894.  846.81KB    17.4 
#>  9 base_vec_ansi   155.39µs 164.14µs     5976.    22.7KB     2.05
#> 10 cli_vec_plain      6.7ms   6.94ms      142.  823.77KB    13.8 
#> 11 fansi_vec_plain 995.43µs   1.04ms      954.  845.98KB    18.0 
#> 12 base_vec_plain  106.51µs 111.87µs     8830.      848B     2.02
#> 13 cli_txt_ansi      3.18ms   3.28ms      304.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.62ms   1.64ms      607.   35.05KB     0   
#> 15 base_txt_ansi   145.79µs 156.37µs     6323.   18.47KB     2.03
#> 16 cli_txt_plain     2.38ms   2.41ms      414.    63.6KB     0   
#> 17 fansi_txt_plain 533.12µs  573.3µs     1736.    30.6KB     4.09
#> 18 base_txt_plain   92.48µs  95.32µs    10298.   11.05KB     2.02
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
#>  1 cli_ansi        128.62µs 138.99µs     6999.   33.84KB    14.8 
#>  2 fansi_ansi       49.36µs  54.69µs    17760.   31.42KB    12.9 
#>  3 base_ansi         1.03µs   1.14µs   807693.     4.2KB     0   
#>  4 cli_plain       128.39µs 137.17µs     7134.        0B    12.5 
#>  5 fansi_plain      49.33µs  54.92µs    17228.      872B    12.6 
#>  6 base_plain      972.07ns   1.09µs   802683.        0B    80.3 
#>  7 cli_vec_ansi    254.56µs 268.65µs     3532.   16.73KB     6.20
#>  8 fansi_vec_ansi  112.02µs 118.49µs     6816.    5.59KB     5.67
#>  9 base_vec_ansi    36.45µs  36.78µs    26795.      848B     0   
#> 10 cli_vec_plain   211.71µs 220.77µs     4287.   16.73KB     8.38
#> 11 fansi_vec_plain 104.51µs 109.12µs     8117.    5.59KB     6.21
#> 12 base_vec_plain    30.4µs   30.7µs    32122.      848B     0   
#> 13 cli_txt_ansi    135.94µs 142.43µs     6878.        0B    14.7 
#> 14 fansi_txt_ansi   48.29µs  51.79µs    18755.      872B    12.8 
#> 15 base_txt_ansi     1.07µs   1.16µs   775904.        0B     0   
#> 16 cli_txt_plain   129.62µs 139.57µs     6874.        0B    14.7 
#> 17 fansi_txt_plain  48.73µs   54.2µs    18044.      872B    12.6 
#> 18 base_txt_plain  991.98ns   1.09µs   834575.        0B     0
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
#>  1 cli_ansi         338.3µs 365.71µs    2686.         0B    12.7 
#>  2 fansi_ansi       85.83µs  95.37µs   10227.    97.33KB    12.5 
#>  3 base_ansi        31.65µs  34.87µs   27673.         0B    13.8 
#>  4 cli_plain       223.47µs 237.84µs    4102.         0B    12.5 
#>  5 fansi_plain      86.37µs  95.86µs   10181.       872B    12.7 
#>  6 base_plain       26.26µs  28.61µs   33952.         0B    10.2 
#>  7 cli_vec_ansi     36.57ms  36.88ms      27.1    2.48KB    23.3 
#>  8 fansi_vec_ansi  234.02µs 246.05µs    4002.     7.25KB     6.17
#>  9 base_vec_ansi     2.21ms   2.31ms     432.    48.18KB    13.0 
#> 10 cli_vec_plain    23.62ms  23.73ms      42.0    2.48KB    18.0 
#> 11 fansi_vec_plain 186.79µs 196.74µs    4978.     6.42KB     8.30
#> 12 base_vec_plain    1.61ms   1.69ms     589.     47.4KB    13.0 
#> 13 cli_txt_ansi     25.87ms  26.26ms      38.1  507.59KB     4.48
#> 14 fansi_txt_ansi  224.87µs 237.69µs    4146.     6.77KB     6.26
#> 15 base_txt_ansi     1.31ms   1.36ms     717.   582.06KB     8.96
#> 16 cli_txt_plain     1.29ms   1.34ms     734.   369.84KB     8.84
#> 17 fansi_txt_plain 174.76µs 185.29µs    5303.     2.51KB     8.28
#> 18 base_txt_plain  872.61µs 923.56µs    1059.   367.31KB     8.97
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
#>  1 cli_ansi          6.58µs   7.59µs   124390.   25.09KB    12.4 
#>  2 fansi_ansi       69.57µs  77.63µs    12635.   28.48KB    13.5 
#>  3 base_ansi            1µs   1.13µs   825180.        0B     0   
#>  4 cli_plain         6.48µs   7.18µs   136017.        0B    13.6 
#>  5 fansi_plain      70.03µs  73.45µs    13315.    1.98KB    12.6 
#>  6 base_plain      991.98ns   1.12µs   814000.        0B     0   
#>  7 cli_vec_ansi     26.46µs  27.74µs    35364.     1.7KB     7.07
#>  8 fansi_vec_ansi  105.21µs 110.15µs     8904.    8.86KB     8.42
#>  9 base_vec_ansi     6.22µs   6.64µs   147969.      848B     0   
#> 10 cli_vec_plain    23.05µs  24.08µs    40753.     1.7KB     4.08
#> 11 fansi_vec_plain  98.88µs  104.1µs     9398.    8.86KB     8.43
#> 12 base_vec_plain    5.93µs   6.49µs   150018.      848B    15.0 
#> 13 cli_txt_ansi      6.36µs    7.2µs   135166.        0B    13.5 
#> 14 fansi_txt_ansi   70.19µs  76.41µs    12772.    1.98KB    12.6 
#> 15 base_txt_ansi     7.06µs   7.19µs   135478.        0B     0   
#> 16 cli_txt_plain     7.44µs    8.3µs   116786.        0B    11.7 
#> 17 fansi_txt_plain  70.34µs  76.94µs    12751.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.52µs   214672.        0B     0
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
#>  1 cli_ansi        87.61µs  94.01µs   10353.    11.88KB     8.26
#>  2 base_ansi         1.3µs   1.37µs  701064.         0B    70.1 
#>  3 cli_plain       68.05µs  72.79µs   13025.     8.73KB     8.27
#>  4 base_plain     991.04ns   1.07µs  865839.         0B     0   
#>  5 cli_vec_ansi     4.22ms   4.39ms     228.   838.77KB    15.8 
#>  6 base_vec_ansi   72.42µs  74.17µs   13371.       848B     0   
#>  7 cli_vec_plain    2.32ms   2.41ms     415.    816.9KB    12.9 
#>  8 base_vec_plain  44.46µs  45.73µs   21551.       848B     0   
#>  9 cli_txt_ansi    15.56ms   15.7ms      63.2  114.42KB     4.22
#> 10 base_txt_ansi    68.8µs  70.31µs   13989.         0B     0   
#> 11 cli_txt_plain  264.15µs 275.08µs    3561.    18.16KB     2.02
#> 12 base_txt_plain  39.67µs  40.37µs   23867.         0B     0
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
#>  1 cli_ansi         89.3µs   96.2µs    10169.        0B    12.7 
#>  2 base_ansi        15.4µs   16.9µs    57808.        0B    11.6 
#>  3 cli_plain        89.8µs     96µs    10216.        0B    14.7 
#>  4 base_plain       15.3µs   16.7µs    58240.        0B    11.7 
#>  5 cli_vec_ansi      190µs  201.8µs     4866.     7.2KB     8.29
#>  6 base_vec_ansi    54.6µs   61.1µs    16229.    1.66KB     2.02
#>  7 cli_vec_plain   175.7µs  187.4µs     5239.     7.2KB     8.33
#>  8 base_vec_plain   48.1µs   54.4µs    18282.    1.66KB     4.07
#>  9 cli_txt_ansi    168.7µs    177µs     5554.        0B     8.24
#> 10 base_txt_ansi      41µs   42.9µs    22811.        0B     4.56
#> 11 cli_txt_plain   151.8µs    160µs     6135.        0B     8.23
#> 12 base_txt_plain   34.6µs   36.4µs    26979.        0B     5.40
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
#> 1 cli          7.72µs    8.7µs   110731.        0B    11.1 
#> 2 base          851ns    952ns   920509.        0B     0   
#> 3 cli_vec     23.23µs   24.6µs    39832.      448B     7.97
#> 4 base_vec    12.29µs   12.6µs    77963.      448B     0   
#> 5 cli_txt     23.39µs   24.5µs    39958.        0B     4.00
#> 6 base_txt    13.43µs     14µs    70058.        0B     0
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
#> 1 cli          7.64µs    8.7µs   111625.        0B    11.2 
#> 2 base         1.32µs   1.44µs   631848.        0B    63.2 
#> 3 cli_vec     29.41µs  30.91µs    31807.      448B     3.18
#> 4 base_vec    54.49µs  55.18µs    17865.      448B     0   
#> 5 cli_txt     29.74µs  31.06µs    31643.        0B     3.16
#> 6 base_txt    89.29µs  90.31µs    10945.        0B     0
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
#> 1 cli          8.14µs   9.23µs   104653.        0B    20.9 
#> 2 base       841.92ns    951ns   952985.        0B     0   
#> 3 cli_vec     19.83µs  21.12µs    46356.      448B     4.64
#> 4 base_vec     12.3µs  12.56µs    78093.      448B     0   
#> 5 cli_txt     20.76µs  22.21µs    44078.        0B     8.82
#> 6 base_txt    13.39µs  13.88µs    70870.        0B     0
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
#> 1 cli          6.24µs   7.21µs   133158.    22.2KB    13.3 
#> 2 base         1.04µs   1.16µs   762430.        0B     0   
#> 3 cli_vec     30.52µs  32.09µs    30088.     1.7KB     6.02
#> 4 base_vec     8.96µs   9.23µs   104871.      848B     0   
#> 5 cli_txt      6.18µs   7.22µs   129660.        0B    13.0 
#> 6 base_txt     5.53µs   6.17µs   158557.        0B     0
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
#>  date     2026-05-26
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-26 [1] local
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
