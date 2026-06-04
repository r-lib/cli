# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x556c7d6276f8\>
\<environment: 0x556c7e161180\>

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
#> 1 ansi         36.5µs   40.6µs    24089.    99.6KB     24.1
#> 2 plain        37.5µs   40.9µs    23911.        0B     23.9
#> 3 base         10.8µs   12.2µs    79643.    48.6KB     23.9
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
#> 1 ansi         39.2µs   43.3µs    22635.        0B     24.9
#> 2 plain        39.1µs   42.7µs    22925.        0B     27.5
#> 3 base         12.4µs   13.7µs    71136.        0B     28.5
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
#> 1 ansi        97.75µs 105.11µs     9251.   77.03KB     19.0
#> 2 plain       75.91µs  81.54µs    11951.    8.91KB     16.8
#> 3 base         1.86µs   2.05µs   470543.        0B     47.1
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
#> 1 ansi          273µs    293µs     3389.   33.23KB     25.9
#> 2 plain         274µs    293µs     3383.    1.09KB     23.5
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
#>  1 cli_ansi          5.51µs   6.26µs   154651.    9.27KB     30.9
#>  2 fansi_ansi       27.11µs  29.73µs    32061.    4.18KB     12.8
#>  3 cli_plain         5.58µs   6.15µs   155160.        0B     15.5
#>  4 fansi_plain      27.05µs  29.44µs    33205.      688B     13.3
#>  5 cli_vec_ansi      7.05µs   7.64µs   127432.      448B     12.7
#>  6 fansi_vec_ansi   36.55µs  39.27µs    24814.    5.02KB     12.4
#>  7 cli_vec_plain     7.72µs   8.34µs   116764.      448B     11.7
#>  8 fansi_vec_plain   35.4µs  38.08µs    25692.    5.02KB     10.3
#>  9 cli_txt_ansi      5.57µs   6.14µs   157178.        0B     15.7
#> 10 fansi_txt_ansi   27.47µs  29.93µs    32766.      688B     13.1
#> 11 cli_txt_plain     6.53µs   7.06µs   137745.        0B     13.8
#> 12 fansi_txt_plain  35.34µs  38.22µs    25604.    5.02KB     12.8
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
#> 1 cli          56.6µs   58.7µs    16728.    22.7KB     4.05
#> 2 fansi         110µs  114.9µs     8521.    55.3KB     6.11
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
#>  1 cli_ansi           6.6µs   7.31µs   132306.        0B    13.2 
#>  2 fansi_ansi       72.45µs  77.69µs    12554.   38.84KB    10.3 
#>  3 base_ansi       891.97ns 992.09ns   925455.        0B     0   
#>  4 cli_plain         6.55µs   7.26µs   133089.        0B    13.3 
#>  5 fansi_plain      71.88µs  77.08µs    12646.      688B    12.4 
#>  6 base_plain      820.96ns 901.99ns  1028997.        0B     0   
#>  7 cli_vec_ansi     29.33µs   30.3µs    32479.      448B     3.25
#>  8 fansi_vec_ansi   93.47µs  98.97µs     9841.    5.02KB     8.26
#>  9 base_vec_ansi    18.97µs  19.09µs    51557.      448B     0   
#> 10 cli_vec_plain    27.11µs  28.09µs    34946.      448B     3.49
#> 11 fansi_vec_plain   83.2µs  88.53µs    11007.    5.02KB    10.4 
#> 12 base_vec_plain   10.93µs  11.06µs    88898.      448B     0   
#> 13 cli_txt_ansi     29.37µs  30.25µs    32452.        0B     3.25
#> 14 fansi_txt_ansi   85.48µs  91.29µs    10708.      688B     8.29
#> 15 base_txt_ansi    18.86µs  18.97µs    51880.        0B     5.19
#> 16 cli_txt_plain    26.74µs  27.61µs    35583.        0B     3.56
#> 17 fansi_txt_plain  74.58µs  80.13µs    12198.      688B    10.3 
#> 18 base_txt_plain    10.9µs  11.03µs    89241.        0B     0
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
#>  1 cli_ansi          7.98µs   8.83µs   110129.        0B    11.0 
#>  2 fansi_ansi       71.62µs  77.96µs    12485.      688B    12.4 
#>  3 base_ansi         1.21µs   1.31µs   724570.        0B     0   
#>  4 cli_plain         7.97µs   8.76µs   110740.        0B    11.1 
#>  5 fansi_plain      72.07µs  77.74µs    12498.      688B    10.3 
#>  6 base_plain      981.03ns   1.09µs   841189.        0B     0   
#>  7 cli_vec_ansi     33.87µs  35.02µs    27028.      448B     5.41
#>  8 fansi_vec_ansi   96.93µs 101.91µs     9562.    5.02KB     8.26
#>  9 base_vec_ansi    41.06µs  41.73µs    23658.      448B     0   
#> 10 cli_vec_plain     32.1µs  33.16µs    29668.      448B     2.97
#> 11 fansi_vec_plain  85.16µs  90.73µs    10669.    5.02KB    10.4 
#> 12 base_vec_plain   21.63µs  22.02µs    43115.      448B     0   
#> 13 cli_txt_ansi     34.45µs  35.45µs    27731.        0B     2.77
#> 14 fansi_txt_ansi   87.86µs  93.95µs    10394.      688B    10.3 
#> 15 base_txt_ansi    43.41µs  43.75µs    22555.        0B     0   
#> 16 cli_txt_plain    31.86µs  32.84µs    29950.        0B     3.00
#> 17 fansi_txt_plain  77.72µs  83.41µs    11630.      688B    10.4 
#> 18 base_txt_plain   22.96µs   23.2µs    42347.        0B     0
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
#> 1 cli_ansi        6.44µs   7.13µs   134943.        0B    13.5 
#> 2 cli_plain       6.12µs   6.76µs   141830.        0B    14.2 
#> 3 cli_vec_ansi   31.02µs  32.07µs    30696.      848B     3.07
#> 4 cli_vec_plain  10.14µs  10.95µs    87791.      848B     8.78
#> 5 cli_txt_ansi   30.21µs  31.36µs    31217.        0B     3.12
#> 6 cli_txt_plain   7.07µs   7.77µs   124438.        0B    12.4
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
#>  1 cli_ansi          23.9µs   26.1µs    34289.        0B    13.7 
#>  2 fansi_ansi        25.4µs   27.8µs    35010.    7.24KB    14.0 
#>  3 cli_plain         23.2µs   25.2µs    38706.        0B    19.4 
#>  4 fansi_plain         24µs   25.7µs    37645.      688B    15.1 
#>  5 cli_vec_ansi      32.7µs   34.6µs    28268.      848B    11.3 
#>  6 fansi_vec_ansi      51µs   52.9µs    18508.    5.41KB     8.32
#>  7 cli_vec_plain     26.2µs   27.5µs    35409.      848B    14.2 
#>  8 fansi_vec_plain     34µs   36.1µs    27082.    4.59KB    10.8 
#>  9 cli_txt_ansi      32.8µs   34.8µs    28076.        0B    11.2 
#> 10 fansi_txt_ansi    41.6µs   43.8µs    22315.    5.12KB     8.93
#> 11 cli_txt_plain     24.6µs   26.5µs    36529.        0B    18.3 
#> 12 fansi_txt_plain   26.3µs   28.3µs    34511.      688B    13.8
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
#>  1 cli_ansi        128.88µs 139.19µs     6980.  104.86KB    12.5 
#>  2 fansi_ansi      107.48µs 115.83µs     8439.  106.35KB    12.5 
#>  3 base_ansi         4.03µs   4.37µs   222184.      224B     0   
#>  4 cli_plain       129.31µs 137.07µs     7081.    8.09KB    12.4 
#>  5 fansi_plain     105.24µs 114.15µs     8586.    9.62KB    12.6 
#>  6 base_plain        3.44µs   3.72µs   260101.        0B    26.0 
#>  7 cli_vec_ansi      6.42ms   6.61ms      151.  823.77KB    13.5 
#>  8 fansi_vec_ansi       1ms   1.05ms      905.  846.81KB    17.3 
#>  9 base_vec_ansi   153.56µs 160.17µs     6097.    22.7KB     2.03
#> 10 cli_vec_plain     6.36ms   6.58ms      150.  823.77KB    16.4 
#> 11 fansi_vec_plain 961.77µs 996.86µs      995.  845.98KB    17.5 
#> 12 base_vec_plain  106.13µs 111.52µs     8768.      848B     4.06
#> 13 cli_txt_ansi      3.24ms   3.29ms      302.    63.6KB     0   
#> 14 fansi_txt_ansi    1.62ms   1.65ms      605.   35.05KB     2.00
#> 15 base_txt_ansi    142.4µs 152.78µs     6485.   18.47KB     2.02
#> 16 cli_txt_plain     2.43ms   2.46ms      404.    63.6KB     0   
#> 17 fansi_txt_plain 537.71µs 577.06µs     1726.    30.6KB     2.02
#> 18 base_txt_plain   93.23µs  96.02µs    10148.   11.05KB     2.02
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
#>  1 cli_ansi        124.58µs 134.15µs     7281.   33.84KB    15.0 
#>  2 fansi_ansi       47.46µs  51.43µs    19000.   31.42KB    12.5 
#>  3 base_ansi         1.05µs   1.16µs   810672.     4.2KB     0   
#>  4 cli_plain       122.64µs 129.73µs     7539.        0B    16.8 
#>  5 fansi_plain      46.48µs  51.38µs    19153.      872B    12.5 
#>  6 base_plain      961.01ns   1.06µs   889659.        0B     0   
#>  7 cli_vec_ansi    244.82µs 253.59µs     3885.   16.73KB     8.27
#>  8 fansi_vec_ansi  110.88µs 114.31µs     8579.    5.59KB     6.16
#>  9 base_vec_ansi    36.19µs  36.51µs    26968.      848B     0   
#> 10 cli_vec_plain   206.54µs 213.05µs     4613.   16.73KB    10.4 
#> 11 fansi_vec_plain 102.97µs 106.17µs     9262.    5.59KB     6.16
#> 12 base_vec_plain   30.01µs  30.42µs    32406.      848B     3.24
#> 13 cli_txt_ansi     130.8µs 138.09µs     7108.        0B    12.5 
#> 14 fansi_txt_ansi   46.91µs  51.05µs    19230.      872B    14.6 
#> 15 base_txt_ansi     1.06µs   1.17µs   812488.        0B     0   
#> 16 cli_txt_plain   124.53µs 131.71µs     7481.        0B    14.5 
#> 17 fansi_txt_plain  47.39µs  51.37µs    19125.      872B    14.6 
#> 18 base_txt_plain  991.04ns    1.1µs   873853.        0B     0
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
#>  1 cli_ansi        347.37µs  373.9µs    2659.     6.18KB    12.5 
#>  2 fansi_ansi       86.52µs  93.01µs   10576.    97.33KB    12.4 
#>  3 base_ansi        31.63µs  34.06µs   28647.         0B    14.3 
#>  4 cli_plain       218.85µs 230.94µs    4241.         0B    12.4 
#>  5 fansi_plain      85.84µs  92.78µs   10567.       872B    12.4 
#>  6 base_plain       25.88µs  27.68µs   35206.         0B    14.1 
#>  7 cli_vec_ansi     36.89ms  37.41ms      26.8   94.67KB    23.0 
#>  8 fansi_vec_ansi  231.81µs  241.2µs    4087.     7.25KB     6.13
#>  9 base_vec_ansi     2.17ms   2.23ms     446.    48.18KB    15.2 
#> 10 cli_vec_plain    22.88ms  23.05ms      43.3    2.48KB    17.3 
#> 11 fansi_vec_plain  182.5µs 191.84µs    5124.     6.42KB     8.34
#> 12 base_vec_plain    1.58ms   1.64ms     607.     47.4KB    12.8 
#> 13 cli_txt_ansi     26.98ms  27.34ms      36.6    4.27MB     4.58
#> 14 fansi_txt_ansi   223.6µs 233.48µs    4227.     6.77KB     6.13
#> 15 base_txt_ansi     1.26ms    1.3ms     763.   582.06KB    11.2 
#> 16 cli_txt_plain     1.25ms   1.29ms     769.   369.84KB     9.32
#> 17 fansi_txt_plain 170.34µs  175.4µs    5614.     2.51KB     6.11
#> 18 base_txt_plain  835.97µs 885.21µs    1123.   367.31KB    11.2
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
#>  1 cli_ansi          6.45µs   7.22µs   134498.   25.09KB    13.5 
#>  2 fansi_ansi       68.99µs  74.99µs    13119.   28.48KB    12.5 
#>  3 base_ansi         1.03µs   1.17µs   791594.        0B     0   
#>  4 cli_plain         6.47µs   7.14µs   135068.        0B    13.5 
#>  5 fansi_plain      69.28µs  75.17µs    13083.    1.98KB    12.5 
#>  6 base_plain      971.02ns   1.11µs   827534.        0B    82.8 
#>  7 cli_vec_ansi     26.47µs  27.69µs    35557.     1.7KB     3.56
#>  8 fansi_vec_ansi  108.33µs 113.97µs     8618.    8.86KB     8.34
#>  9 base_vec_ansi     6.18µs   6.74µs   146459.      848B     0   
#> 10 cli_vec_plain    23.12µs  24.22µs    40582.     1.7KB     4.06
#> 11 fansi_vec_plain 103.61µs 109.12µs     9010.    8.86KB     8.34
#> 12 base_vec_plain    5.79µs   6.18µs   158296.      848B    15.8 
#> 13 cli_txt_ansi      6.46µs   7.18µs   135158.        0B    13.5 
#> 14 fansi_txt_ansi   69.15µs   75.4µs    13029.    1.98KB    12.5 
#> 15 base_txt_ansi     7.06µs   7.19µs   136509.        0B     0   
#> 16 cli_txt_plain     7.24µs   8.03µs   120522.        0B    12.1 
#> 17 fansi_txt_plain  69.61µs  75.44µs    13048.    1.98KB    12.6 
#> 18 base_txt_plain    4.42µs   4.54µs   213288.        0B     0
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
#>  1 cli_ansi        91.93µs  97.72µs    9969.     12.1KB    10.3 
#>  2 base_ansi        1.27µs   1.36µs  708393.         0B     0   
#>  3 cli_plain       73.23µs  77.41µs   12587.     8.91KB     8.20
#>  4 base_plain     980.92ns   1.07µs  888351.         0B     0   
#>  5 cli_vec_ansi     4.21ms   4.34ms     230.   838.95KB    15.7 
#>  6 base_vec_ansi   70.18µs  72.37µs   13640.       848B     0   
#>  7 cli_vec_plain    2.33ms   2.42ms     413.   817.08KB    15.2 
#>  8 base_vec_plain  41.78µs  42.77µs   23113.       848B     0   
#>  9 cli_txt_ansi     15.4ms  15.51ms      64.4   114.6KB     2.08
#> 10 base_txt_ansi    69.3µs  70.23µs   14056.         0B     0   
#> 11 cli_txt_plain  294.17µs    311µs    3150.    18.34KB     2.01
#> 12 base_txt_plain  39.73µs  40.36µs   24489.         0B     0
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
#>  1 cli_ansi         89.5µs   94.9µs    10315.        0B    14.5 
#>  2 base_ansi        15.3µs   16.4µs    59407.        0B    11.9 
#>  3 cli_plain        86.7µs   93.6µs    10487.        0B    14.8 
#>  4 base_plain       15.1µs   16.2µs    60275.        0B    12.1 
#>  5 cli_vec_ansi    185.6µs  197.1µs     5013.     7.2KB     6.13
#>  6 base_vec_ansi    54.2µs   57.7µs    16898.    1.66KB     4.06
#>  7 cli_vec_plain   172.3µs  181.5µs     5444.     7.2KB     8.24
#>  8 base_vec_plain   47.7µs   51.6µs    18971.    1.66KB     4.06
#>  9 cli_txt_ansi    166.2µs  172.5µs     5717.        0B     7.32
#> 10 base_txt_ansi    40.8µs     42µs    23452.        0B     4.69
#> 11 cli_txt_plain   149.6µs  153.8µs     6405.        0B     8.18
#> 12 base_txt_plain   34.2µs   35.3µs    27814.        0B     5.56
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
#> 1 cli           7.7µs   8.23µs   118681.        0B    11.9 
#> 2 base        841.9ns 941.92ns  1002487.        0B     0   
#> 3 cli_vec      22.9µs   23.7µs    41588.      448B     4.16
#> 4 base_vec     12.3µs  12.51µs    78821.      448B     0   
#> 5 cli_txt      22.9µs  23.64µs    41560.        0B     4.16
#> 6 base_txt     13.4µs  13.98µs    70817.        0B     7.08
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
#> 1 cli          7.64µs   8.21µs   119265.        0B    11.9 
#> 2 base          1.3µs   1.41µs   681981.        0B     0   
#> 3 cli_vec     29.26µs   30.3µs    32564.      448B     3.26
#> 4 base_vec    54.07µs  54.89µs    17985.      448B     0   
#> 5 cli_txt     29.36µs   30.2µs    32626.        0B     6.53
#> 6 base_txt    89.47µs  90.39µs    10936.        0B     0
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
#> 1 cli           8.2µs   8.83µs   110662.        0B    11.1 
#> 2 base        851.9ns 950.88ns   992619.        0B     0   
#> 3 cli_vec      19.8µs  20.64µs    47608.      448B     9.52
#> 4 base_vec     12.3µs  12.53µs    78538.      448B     0   
#> 5 cli_txt      20.8µs  22.33µs    44192.        0B     4.42
#> 6 base_txt     13.4µs  13.88µs    71034.        0B     0
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
#> 1 cli          6.15µs   6.81µs   141923.    22.2KB    14.2 
#> 2 base         1.04µs   1.17µs   796266.        0B     0   
#> 3 cli_vec      30.4µs  31.72µs    31025.     1.7KB     3.10
#> 4 base_vec     8.58µs   8.85µs   110765.      848B     0   
#> 5 cli_txt      6.17µs   6.88µs   139689.        0B    27.9 
#> 6 base_txt     5.54µs   5.86µs   167308.        0B     0
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
#>  date     2026-06-04
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-06-04 [1] local
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
#>  xfun          0.58       2026-06-01 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.0/lib/R/site-library
#>  [3] /opt/R/4.6.0/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
