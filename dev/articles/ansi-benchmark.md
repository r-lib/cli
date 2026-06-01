# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55c9f163f2a0\>
\<environment: 0x55c9f20e7de8\>

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
#> 1 ansi         38.5µs   42.7µs    22884.    99.6KB     22.9
#> 2 plain        37.9µs   42.5µs    22591.        0B     22.6
#> 3 base         10.9µs   12.5µs    76909.    48.6KB     23.1
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
#> 1 ansi         40.4µs   45.1µs    21324.        0B     23.8
#> 2 plain        40.3µs   44.6µs    21814.        0B     26.2
#> 3 base         12.5µs   14.4µs    67480.        0B     27.0
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
#> 1 ansi       100.67µs 109.44µs     8834.   77.03KB     17.0
#> 2 plain          77µs  83.57µs    11333.    8.91KB     16.9
#> 3 base         1.84µs   2.08µs   455915.        0B     45.6
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
#> 1 ansi          288µs    313µs     3159.   33.23KB     23.8
#> 2 plain         289µs    313µs     3167.    1.09KB     21.5
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
#>  1 cli_ansi           5.6µs   6.45µs   148790.    9.27KB    29.8 
#>  2 fansi_ansi       27.39µs  30.84µs    30879.    4.18KB    15.4 
#>  3 cli_plain         5.61µs   6.19µs   154115.        0B    15.4 
#>  4 fansi_plain       27.8µs  30.02µs    32305.      688B    16.2 
#>  5 cli_vec_ansi      6.93µs   7.62µs   127368.      448B    12.7 
#>  6 fansi_vec_ansi   36.63µs  39.48µs    24515.    5.02KB     9.81
#>  7 cli_vec_plain     7.66µs   8.32µs   116492.      448B    11.7 
#>  8 fansi_vec_plain  35.63µs  38.21µs    25492.    5.02KB    12.8 
#>  9 cli_txt_ansi      5.55µs   6.14µs   158238.        0B     0   
#> 10 fansi_txt_ansi   27.47µs  30.07µs    32196.      688B    16.1 
#> 11 cli_txt_plain     6.54µs   7.17µs   135235.        0B    13.5 
#> 12 fansi_txt_plain  35.77µs  39.42µs    19646.    5.02KB     8.40
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
#> 1 cli          56.7µs     59µs    16389.    22.7KB     6.14
#> 2 fansi       111.5µs    117µs     8397.    55.3KB     4.06
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
#>  1 cli_ansi          6.42µs   7.25µs   133678.        0B    13.4 
#>  2 fansi_ansi       71.59µs  77.03µs    12662.   38.84KB    10.3 
#>  3 base_ansi       911.07ns   1.01µs   911228.        0B    91.1 
#>  4 cli_plain         6.53µs   7.25µs   133676.        0B    13.4 
#>  5 fansi_plain      71.24µs  76.92µs    12643.      688B    10.3 
#>  6 base_plain      811.07ns    912ns   990549.        0B     0   
#>  7 cli_vec_ansi     29.29µs  30.27µs    32457.      448B     3.25
#>  8 fansi_vec_ansi   93.06µs 100.09µs     9702.    5.02KB     8.28
#>  9 base_vec_ansi    18.88µs  19.06µs    51476.      448B     0   
#> 10 cli_vec_plain    27.24µs  28.17µs    34886.      448B     3.49
#> 11 fansi_vec_plain  82.58µs  88.47µs    10875.    5.02KB    10.4 
#> 12 base_vec_plain   10.83µs  11.05µs    88343.      448B     0   
#> 13 cli_txt_ansi     29.19µs  30.14µs    32580.        0B     3.26
#> 14 fansi_txt_ansi   83.57µs  90.66µs    10752.      688B    10.5 
#> 15 base_txt_ansi    18.85µs  18.98µs    51869.        0B     0   
#> 16 cli_txt_plain    26.75µs  27.64µs    35529.        0B     3.55
#> 17 fansi_txt_plain  74.18µs   80.5µs    12087.      688B    10.3 
#> 18 base_txt_plain   10.89µs  11.03µs    88937.        0B     0
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
#>  1 cli_ansi          8.06µs   8.96µs   108021.        0B    10.8 
#>  2 fansi_ansi       72.09µs  78.04µs    12408.      688B    12.5 
#>  3 base_ansi         1.19µs   1.31µs   725026.        0B     0   
#>  4 cli_plain         7.99µs    8.9µs   109316.        0B    10.9 
#>  5 fansi_plain      71.86µs  78.22µs    12440.      688B    10.3 
#>  6 base_plain      982.08ns    1.1µs   834866.        0B    83.5 
#>  7 cli_vec_ansi     34.62µs  35.88µs    27363.      448B     2.74
#>  8 fansi_vec_ansi   95.42µs 102.41µs     9388.    5.02KB     8.28
#>  9 base_vec_ansi    41.01µs  41.69µs    23521.      448B     0   
#> 10 cli_vec_plain    32.21µs  33.32µs    29442.      448B     2.94
#> 11 fansi_vec_plain  85.83µs  91.73µs    10607.    5.02KB    10.4 
#> 12 base_vec_plain   21.65µs  22.02µs    44680.      448B     0   
#> 13 cli_txt_ansi     34.56µs  35.61µs    27618.        0B     2.76
#> 14 fansi_txt_ansi   87.13µs  93.77µs    10388.      688B     8.21
#> 15 base_txt_ansi    43.09µs  43.72µs    22535.        0B     2.25
#> 16 cli_txt_plain    31.96µs  32.96µs    29783.        0B     2.98
#> 17 fansi_txt_plain  76.59µs  83.77µs    11536.      688B    10.4 
#> 18 base_txt_plain   22.97µs  23.25µs    42321.        0B     0
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
#> 1 cli_ansi        6.47µs   7.13µs   135154.        0B    13.5 
#> 2 cli_plain       6.07µs   6.74µs   142395.        0B    14.2 
#> 3 cli_vec_ansi   31.06µs  32.65µs    30068.      848B     3.01
#> 4 cli_vec_plain  10.12µs  10.91µs    89095.      848B     8.91
#> 5 cli_txt_ansi   29.89µs  31.34µs    31332.        0B     3.13
#> 6 cli_txt_plain   7.03µs   7.75µs   125199.        0B     0
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
#>  1 cli_ansi          24.2µs   26.1µs    37336.        0B    14.9 
#>  2 fansi_ansi        26.1µs   28.4µs    34297.    7.24KB    13.7 
#>  3 cli_plain         23.8µs     26µs    37256.        0B    18.6 
#>  4 fansi_plain       25.1µs   26.6µs    36661.      688B    14.7 
#>  5 cli_vec_ansi      33.1µs   35.2µs    27808.      848B    11.1 
#>  6 fansi_vec_ansi    51.6µs     54µs    18114.    5.41KB     8.39
#>  7 cli_vec_plain     26.7µs   28.2µs    34650.      848B    13.9 
#>  8 fansi_vec_plain     35µs   37.2µs    26246.    4.59KB    10.5 
#>  9 cli_txt_ansi      33.2µs   35.3µs    27759.        0B    11.1 
#> 10 fansi_txt_ansi    42.4µs   44.7µs    21860.    5.12KB     8.75
#> 11 cli_txt_plain     24.9µs   26.8µs    36370.        0B    18.2 
#> 12 fansi_txt_plain   26.3µs   28.8µs    33933.      688B    13.6
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
#>  1 cli_ansi        130.89µs 140.03µs     6950.  104.86KB    12.5 
#>  2 fansi_ansi      106.43µs 115.97µs     8468.  106.35KB    12.6 
#>  3 base_ansi         4.06µs    4.4µs   222281.      224B     0   
#>  4 cli_plain       129.31µs  138.1µs     7047.    8.09KB    12.5 
#>  5 fansi_plain     106.24µs  115.1µs     8530.    9.62KB    12.6 
#>  6 base_plain        3.51µs   3.78µs   255944.        0B     0   
#>  7 cli_vec_ansi      6.46ms   6.68ms      148.  823.77KB    16.5 
#>  8 fansi_vec_ansi    1.02ms   1.06ms      916.  846.81KB    17.5 
#>  9 base_vec_ansi   153.77µs 160.54µs     6091.    22.7KB     2.04
#> 10 cli_vec_plain     6.41ms   6.61ms      151.  823.77KB    13.7 
#> 11 fansi_vec_plain 968.24µs   1.01ms      979.  845.98KB    20.2 
#> 12 base_vec_plain  105.21µs  111.5µs     8845.      848B     2.02
#> 13 cli_txt_ansi      3.24ms   3.29ms      303.    63.6KB     2.02
#> 14 fansi_txt_ansi     1.6ms   1.64ms      608.   35.05KB     0   
#> 15 base_txt_ansi      143µs 153.71µs     6445.   18.47KB     2.03
#> 16 cli_txt_plain     2.45ms   2.48ms      401.    63.6KB     0   
#> 17 fansi_txt_plain 532.78µs 567.05µs     1757.    30.6KB     4.10
#> 18 base_txt_plain   91.65µs  94.89µs    10370.   11.05KB     2.02
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
#>  1 cli_ansi        127.51µs 136.48µs     7142.   33.84KB    15.0 
#>  2 fansi_ansi       49.35µs  53.52µs    18256.   31.42KB    12.5 
#>  3 base_ansi         1.04µs   1.15µs   819633.     4.2KB     0   
#>  4 cli_plain       128.06µs 135.56µs     7232.        0B    14.6 
#>  5 fansi_plain      49.09µs  53.44µs    18263.      872B    12.5 
#>  6 base_plain      971.02ns   1.08µs   858882.        0B     0   
#>  7 cli_vec_ansi    247.88µs 257.43µs     3791.   16.73KB     7.65
#>  8 fansi_vec_ansi  111.71µs 115.64µs     8487.    5.59KB     8.31
#>  9 base_vec_ansi     36.2µs  36.49µs    27016.      848B     0   
#> 10 cli_vec_plain   210.66µs 217.75µs     4513.   16.73KB     8.35
#> 11 fansi_vec_plain 103.33µs 107.52µs     9146.    5.59KB     6.19
#> 12 base_vec_plain   29.98µs  30.43µs    32420.      848B     0   
#> 13 cli_txt_ansi    135.02µs 141.14µs     6947.        0B    12.5 
#> 14 fansi_txt_ansi   48.22µs  53.34µs    18400.      872B    12.7 
#> 15 base_txt_ansi     1.07µs   1.19µs   795886.        0B    79.6 
#> 16 cli_txt_plain   128.25µs 136.06µs     7224.        0B    12.5 
#> 17 fansi_txt_plain  48.42µs  52.84µs    18556.      872B    14.7 
#> 18 base_txt_plain       1µs    1.1µs   845132.        0B     0
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
#>  1 cli_ansi        350.06µs  374.6µs    2646.     6.18KB    12.6 
#>  2 fansi_ansi       85.29µs  92.87µs   10548.    97.33KB    14.6 
#>  3 base_ansi        32.29µs  34.77µs   28056.         0B    11.2 
#>  4 cli_plain       219.14µs 234.29µs    4190.         0B    12.7 
#>  5 fansi_plain      85.79µs  93.41µs   10483.       872B    12.5 
#>  6 base_plain       26.57µs  28.53µs   34166.         0B    13.7 
#>  7 cli_vec_ansi     37.67ms  37.96ms      26.3   94.67KB    22.6 
#>  8 fansi_vec_ansi  234.72µs 245.35µs    4021.     7.25KB     6.17
#>  9 base_vec_ansi     2.21ms   2.31ms     432.    48.18KB    13.0 
#> 10 cli_vec_plain    23.29ms   23.6ms      42.3    2.48KB    21.1 
#> 11 fansi_vec_plain 183.69µs 194.46µs    5037.     6.42KB     6.16
#> 12 base_vec_plain    1.61ms   1.72ms     502.     47.4KB    10.9 
#> 13 cli_txt_ansi     27.63ms  30.58ms      30.7    4.27MB     7.08
#> 14 fansi_txt_ansi  227.77µs 237.19µs    4165.     6.77KB     4.06
#> 15 base_txt_ansi     1.28ms   1.32ms     747.   582.06KB    11.4 
#> 16 cli_txt_plain     1.26ms    1.3ms     754.   369.84KB     8.75
#> 17 fansi_txt_plain 174.35µs 183.94µs    5326.     2.51KB     6.16
#> 18 base_txt_plain  854.55µs 905.24µs    1088.   367.31KB    11.2
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
#>  1 cli_ansi          6.43µs   7.06µs   138302.   25.09KB    13.8 
#>  2 fansi_ansi       69.94µs  73.32µs    13272.   28.48KB    12.6 
#>  3 base_ansi         1.02µs   1.13µs   826184.        0B     0   
#>  4 cli_plain         6.47µs   7.11µs   135759.        0B    27.2 
#>  5 fansi_plain      69.76µs  73.19µs    13045.    1.98KB    10.4 
#>  6 base_plain           1µs    1.1µs   852225.        0B    85.2 
#>  7 cli_vec_ansi     27.17µs  28.49µs    34123.     1.7KB     3.41
#>  8 fansi_vec_ansi  106.18µs 111.18µs     8795.    8.86KB     8.54
#>  9 base_vec_ansi     6.24µs   6.77µs   144112.      848B     0   
#> 10 cli_vec_plain    23.11µs  24.79µs    39538.     1.7KB     3.95
#> 11 fansi_vec_plain 103.14µs  109.1µs     8940.    8.86KB     8.43
#> 12 base_vec_plain       6µs   6.46µs   149045.      848B    14.9 
#> 13 cli_txt_ansi      6.48µs   7.27µs   132834.        0B    13.3 
#> 14 fansi_txt_ansi   70.52µs  76.88µs    12782.    1.98KB    12.6 
#> 15 base_txt_ansi     7.06µs    7.2µs   136039.        0B     0   
#> 16 cli_txt_plain     7.38µs   8.19µs   118352.        0B    11.8 
#> 17 fansi_txt_plain  69.92µs   76.5µs    12851.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.52µs   214678.        0B     0
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
#>  1 cli_ansi        94.25µs 101.04µs    9628.     12.1KB     8.23
#>  2 base_ansi        1.28µs   1.36µs  686785.         0B     0   
#>  3 cli_plain       74.64µs  79.57µs   12201.     8.91KB    10.4 
#>  4 base_plain     991.04ns   1.07µs  900063.         0B     0   
#>  5 cli_vec_ansi     4.28ms   4.41ms     226.   838.95KB    13.1 
#>  6 base_vec_ansi   70.31µs  71.96µs   13709.       848B     0   
#>  7 cli_vec_plain    2.38ms   2.46ms     364.   817.08KB    13.2 
#>  8 base_vec_plain  41.69µs   43.1µs   22868.       848B     0   
#>  9 cli_txt_ansi    15.59ms  15.68ms      63.5   114.6KB     4.23
#> 10 base_txt_ansi   69.61µs  70.36µs   13977.         0B     0   
#> 11 cli_txt_plain  297.32µs  312.3µs    3151.    18.34KB     2.02
#> 12 base_txt_plain  40.17µs   40.5µs   24282.         0B     0
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
#>  1 cli_ansi         89.4µs     95µs    10286.        0B    14.6 
#>  2 base_ansi        15.3µs   16.5µs    58881.        0B    11.8 
#>  3 cli_plain          89µs   95.1µs    10242.        0B    14.7 
#>  4 base_plain       15.3µs   16.5µs    58826.        0B    11.8 
#>  5 cli_vec_ansi    189.8µs  200.8µs     4835.     7.2KB     8.26
#>  6 base_vec_ansi    55.3µs   61.8µs    15815.    1.66KB     2.02
#>  7 cli_vec_plain   175.5µs  186.4µs     5253.     7.2KB     8.32
#>  8 base_vec_plain   48.8µs   54.6µs    17848.    1.66KB     4.06
#>  9 cli_txt_ansi      168µs  175.2µs     5605.        0B     6.12
#> 10 base_txt_ansi      41µs   42.6µs    23033.        0B     4.61
#> 11 cli_txt_plain   152.4µs  159.2µs     6160.        0B    10.5 
#> 12 base_txt_plain     35µs   36.7µs    26741.        0B     5.35
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
#> 1 cli          7.73µs    8.6µs   112521.        0B    11.3 
#> 2 base       840.98ns  961.9ns   926494.        0B     0   
#> 3 cli_vec        23µs   24.1µs    40684.      448B     4.07
#> 4 base_vec    12.29µs   12.6µs    77825.      448B     7.78
#> 5 cli_txt     22.97µs   23.9µs    40990.        0B     4.10
#> 6 base_txt     13.4µs   13.9µs    70954.        0B     0
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
#> 1 cli          7.66µs   8.51µs   112283.        0B    11.2 
#> 2 base         1.32µs   1.42µs   653955.        0B     0   
#> 3 cli_vec     29.33µs   30.7µs    31634.      448B     6.33
#> 4 base_vec    54.34µs  55.13µs    17213.      448B     0   
#> 5 cli_txt     29.62µs   30.8µs    31948.        0B     3.20
#> 6 base_txt    89.41µs  90.51µs    10917.        0B     0
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
#> 1 cli          8.22µs   9.17µs   105362.        0B    21.1 
#> 2 base          851ns 961.01ns   968130.        0B     0   
#> 3 cli_vec     19.87µs     21µs    46746.      448B     4.68
#> 4 base_vec    12.28µs  12.58µs    77890.      448B     0   
#> 5 cli_txt     20.91µs  22.17µs    44153.        0B     8.83
#> 6 base_txt    13.42µs  13.82µs    71396.        0B     0
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
#> 1 cli          6.32µs    7.2µs   133931.    22.2KB    13.4 
#> 2 base         1.04µs   1.17µs   787356.        0B     0   
#> 3 cli_vec     30.31µs  32.52µs    30140.     1.7KB     6.03
#> 4 base_vec     8.66µs      9µs   107281.      848B     0   
#> 5 cli_txt      6.17µs   7.02µs   136834.        0B    13.7 
#> 6 base_txt     5.55µs   5.94µs   164806.        0B     0
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
