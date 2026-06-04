# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x560a45cb3ce8\>
\<environment: 0x560a4675a740\>

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
#> 1 ansi         45.2µs   49.8µs    19436.    99.6KB     21.1
#> 2 plain        45.5µs   49.4µs    19563.        0B     19.7
#> 3 base         11.4µs   12.6µs    77219.    48.6KB     23.2
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
#> 1 ansi         48.7µs   52.5µs    18377.        0B     21.5
#> 2 plain        47.1µs   51.5µs    18743.        0B     21.2
#> 3 base         13.4µs   14.7µs    65676.        0B     26.3
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
#> 1 ansi       117.44µs  124.7µs     7770.   77.03KB     16.8
#> 2 plain       93.81µs   99.7µs     9663.    8.91KB     14.6
#> 3 base         1.87µs      2µs   477370.        0B      0
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
#> 1 ansi          345µs    374µs     2642.   33.23KB     19.1
#> 2 plain         342µs    369µs     2675.    1.09KB     19.2
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
#>  1 cli_ansi           5.8µs    6.4µs   150681.    9.27KB    30.1 
#>  2 fansi_ansi       30.72µs  33.63µs    28731.    4.18KB    25.9 
#>  3 cli_plain         5.71µs   6.31µs   144472.        0B    14.4 
#>  4 fansi_plain      30.54µs  33.08µs    28489.      688B    17.1 
#>  5 cli_vec_ansi      7.25µs   7.72µs   124401.      448B    12.4 
#>  6 fansi_vec_ansi   40.74µs  43.36µs    22167.    5.02KB     8.87
#>  7 cli_vec_plain     7.87µs   8.31µs   116988.      448B    11.7 
#>  8 fansi_vec_plain  38.56µs  40.96µs    23570.    5.02KB    11.8 
#>  9 cli_txt_ansi      5.75µs   6.13µs   158553.        0B    15.9 
#> 10 fansi_txt_ansi   30.69µs  32.65µs    29660.      688B    11.9 
#> 11 cli_txt_plain     6.56µs   6.96µs   139336.        0B    13.9 
#> 12 fansi_txt_plain  38.66µs  41.61µs    23292.    5.02KB     9.32
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
#> 1 cli          59.4µs     61µs    16036.    22.7KB     4.04
#> 2 fansi       119.3µs    127µs     7806.    55.3KB     4.05
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
#>  1 cli_ansi          6.97µs   7.63µs   126519.        0B    12.7 
#>  2 fansi_ansi       91.99µs  97.91µs     9873.   38.84KB     8.18
#>  3 base_ansi       911.07ns 962.17ns   939907.        0B    94.0 
#>  4 cli_plain         6.87µs   7.53µs   128424.        0B    12.8 
#>  5 fansi_plain      91.65µs  97.45µs     9951.      688B     8.19
#>  6 base_plain      831.09ns 882.08ns  1039981.        0B     0   
#>  7 cli_vec_ansi     28.07µs  29.05µs    33681.      448B     3.37
#>  8 fansi_vec_ansi  112.65µs 118.95µs     8150.    5.02KB     6.14
#>  9 base_vec_ansi    17.21µs  17.34µs    56748.      448B     5.68
#> 10 cli_vec_plain    26.84µs  27.61µs    35427.      448B     3.54
#> 11 fansi_vec_plain 103.18µs  108.8µs     8858.    5.02KB     6.14
#> 12 base_vec_plain   10.11µs  10.22µs    95818.      448B     9.58
#> 13 cli_txt_ansi     28.16µs  28.89µs    33889.        0B     3.39
#> 14 fansi_txt_ansi  104.67µs 110.24µs     8800.      688B     6.11
#> 15 base_txt_ansi     16.9µs  16.98µs    57933.        0B     0   
#> 16 cli_txt_plain    26.33µs  27.05µs    36099.        0B     3.61
#> 17 fansi_txt_plain  94.74µs 100.07µs     9639.      688B    10.3 
#> 18 base_txt_plain    9.86µs   10.4µs    81348.        0B     0
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
#>  1 cli_ansi          8.51µs    9.3µs   104231.        0B    10.4 
#>  2 fansi_ansi       92.74µs  98.22µs     9841.      688B     8.28
#>  3 base_ansi         1.23µs   1.28µs   728571.        0B     0   
#>  4 cli_plain         8.46µs   9.15µs   103338.        0B    20.7 
#>  5 fansi_plain       91.4µs  96.91µs     9955.      688B     8.20
#>  6 base_plain        1.02µs   1.07µs   878580.        0B     0   
#>  7 cli_vec_ansi     34.46µs  35.37µs    27698.      448B     2.77
#>  8 fansi_vec_ansi  116.32µs 121.66µs     7939.    5.02KB     8.25
#>  9 base_vec_ansi     40.7µs  42.42µs    23216.      448B     0   
#> 10 cli_vec_plain    33.34µs  34.27µs    28476.      448B     2.85
#> 11 fansi_vec_plain 106.13µs 111.28µs     8677.    5.02KB     8.26
#> 12 base_vec_plain   21.62µs  21.92µs    42739.      448B     0   
#> 13 cli_txt_ansi      34.9µs  35.75µs    27297.        0B     2.73
#> 14 fansi_txt_ansi  107.91µs 113.82µs     8462.      688B     8.20
#> 15 base_txt_ansi     43.6µs  44.63µs    22123.        0B     0   
#> 16 cli_txt_plain       33µs  33.82µs    28953.        0B     2.90
#> 17 fansi_txt_plain  97.45µs 102.73µs     9402.      688B     8.19
#> 18 base_txt_plain   23.14µs  23.86µs    41333.        0B     0
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
#> 1 cli_ansi        7.01µs   7.62µs   126898.        0B    12.7 
#> 2 cli_plain       6.54µs   7.14µs   135734.        0B     0   
#> 3 cli_vec_ansi   32.97µs     34µs    28811.      848B     2.88
#> 4 cli_vec_plain  10.43µs  11.15µs    86990.      848B     8.70
#> 5 cli_txt_ansi   32.58µs  33.41µs    29337.        0B     2.93
#> 6 cli_txt_plain   7.36µs   7.96µs   121899.        0B    12.2
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
#>  1 cli_ansi          25.9µs   27.6µs    35083.        0B    17.6 
#>  2 fansi_ansi        28.4µs   30.7µs    31485.    7.24KB    12.6 
#>  3 cli_plain         25.8µs   27.3µs    35514.        0B    14.2 
#>  4 fansi_plain       28.2µs   30.3µs    31849.      688B    12.7 
#>  5 cli_vec_ansi        35µs   36.9µs    26362.      848B    10.5 
#>  6 fansi_vec_ansi    55.2µs     58µs    16722.    5.41KB     8.31
#>  7 cli_vec_plain     28.2µs   30.1µs    32223.      848B    12.9 
#>  8 fansi_vec_plain   37.4µs   39.3µs    24508.    4.59KB     9.81
#>  9 cli_txt_ansi        34µs   35.4µs    27396.        0B    11.0 
#> 10 fansi_txt_ansi    44.2µs     46µs    21121.    5.12KB     8.45
#> 11 cli_txt_plain     26.3µs   27.6µs    35004.        0B    14.0 
#> 12 fansi_txt_plain   29.2µs   30.9µs    31362.      688B    12.5
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
#>  1 cli_ansi         164.8µs 172.51µs     5624.  104.86KB     8.18
#>  2 fansi_ansi      129.51µs 138.84µs     7003.  106.35KB    10.3 
#>  3 base_ansi         4.24µs   4.55µs   214059.      224B    21.4 
#>  4 cli_plain       162.73µs 171.05µs     5666.    8.09KB    10.3 
#>  5 fansi_plain     128.95µs 137.71µs     7072.    9.62KB    10.4 
#>  6 base_plain        3.64µs   3.93µs   246761.        0B     0   
#>  7 cli_vec_ansi      7.73ms   7.91ms      126.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.06ms    1.1ms      875.  846.81KB    17.6 
#>  9 base_vec_ansi   157.47µs 163.56µs     5997.    22.7KB     4.13
#> 10 cli_vec_plain     7.65ms   7.84ms      127.  823.77KB    11.1 
#> 11 fansi_vec_plain  996.1µs   1.03ms      912.  845.98KB    17.6 
#> 12 base_vec_plain  107.42µs 111.21µs     8800.      848B     4.06
#> 13 cli_txt_ansi      3.19ms   3.22ms      310.    63.6KB     0   
#> 14 fansi_txt_ansi    1.57ms   1.59ms      609.   35.05KB     0   
#> 15 base_txt_ansi   138.07µs 146.38µs     6767.   18.47KB     2.02
#> 16 cli_txt_plain     2.36ms   2.39ms      418.    63.6KB     2.02
#> 17 fansi_txt_plain 516.02µs 535.67µs     1858.    30.6KB     2.02
#> 18 base_txt_plain   88.45µs  91.15µs    10743.   11.05KB     2.02
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
#>  1 cli_ansi        152.02µs 159.68µs     6059.   33.84KB    12.4 
#>  2 fansi_ansi       55.97µs  59.65µs    16170.   31.42KB    10.6 
#>  3 base_ansi         1.09µs   1.14µs   823568.     4.2KB     0   
#>  4 cli_plain       150.18µs 157.27µs     6157.        0B    12.4 
#>  5 fansi_plain      54.47µs  58.75µs    16417.      872B    12.5 
#>  6 base_plain           1µs   1.05µs   890705.        0B     0   
#>  7 cli_vec_ansi    275.33µs 287.12µs     3415.   16.73KB     6.15
#>  8 fansi_vec_ansi  117.11µs 121.93µs     7972.    5.59KB     7.19
#>  9 base_vec_ansi    35.49µs  35.88µs    27515.      848B     0   
#> 10 cli_vec_plain   232.24µs  240.6µs     4062.   16.73KB     8.26
#> 11 fansi_vec_plain 107.83µs 111.39µs     8743.    5.59KB     8.27
#> 12 base_vec_plain   30.15µs  31.34µs    31634.      848B     0   
#> 13 cli_txt_ansi    158.55µs 164.95µs     5901.        0B    10.3 
#> 14 fansi_txt_ansi   54.27µs  57.01µs    16961.      872B    12.4 
#> 15 base_txt_ansi     1.11µs   1.16µs   822674.        0B     0   
#> 16 cli_txt_plain   149.81µs 157.58µs     6187.        0B    12.5 
#> 17 fansi_txt_plain  54.28µs  58.15µs    16678.      872B    12.4 
#> 18 base_txt_plain    1.04µs   1.09µs   869704.        0B     0
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
#>  1 cli_ansi         425.7µs 455.01µs    2189.     6.18KB    10.3 
#>  2 fansi_ansi      100.14µs 107.08µs    9074.    97.33KB    12.5 
#>  3 base_ansi         38.8µs   41.3µs   23280.         0B     9.32
#>  4 cli_plain       276.32µs 291.71µs    3344.         0B    10.3 
#>  5 fansi_plain      98.62µs 106.15µs    9138.       872B    12.4 
#>  6 base_plain       31.86µs  33.98µs   28379.         0B     8.52
#>  7 cli_vec_ansi     45.53ms  45.75ms      21.8   94.67KB    26.2 
#>  8 fansi_vec_ansi  238.21µs 248.23µs    3964.     7.25KB     6.14
#>  9 base_vec_ansi     2.27ms   2.34ms     426.    48.18KB    10.5 
#> 10 cli_vec_plain    29.33ms  29.51ms      33.9    2.48KB    14.1 
#> 11 fansi_vec_plain 192.64µs 201.66µs    4848.     6.42KB     6.14
#> 12 base_vec_plain    1.64ms    1.7ms     586.     47.4KB    12.7 
#> 13 cli_txt_ansi     26.79ms  27.04ms      36.9    4.27MB     6.91
#> 14 fansi_txt_ansi  227.58µs 237.92µs    4135.     6.77KB     4.05
#> 15 base_txt_ansi     1.24ms   1.28ms     774.   582.06KB    11.1 
#> 16 cli_txt_plain     1.27ms   1.32ms     751.   369.84KB     8.76
#> 17 fansi_txt_plain  180.4µs 188.59µs    5189.     2.51KB     6.16
#> 18 base_txt_plain  855.68µs 887.88µs    1113.   367.31KB    11.0
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
#>  1 cli_ansi          6.84µs   7.52µs   125599.   25.09KB    25.1 
#>  2 fansi_ansi       81.01µs  86.17µs    11254.   28.48KB    10.4 
#>  3 base_ansi         1.04µs   1.11µs   842420.        0B     0   
#>  4 cli_plain         6.62µs   7.24µs   133906.        0B    13.4 
#>  5 fansi_plain      79.08µs   85.5µs    11345.    1.98KB    12.2 
#>  6 base_plain        1.01µs   1.06µs   894151.        0B     0   
#>  7 cli_vec_ansi     26.15µs  27.08µs    36231.     1.7KB     3.62
#>  8 fansi_vec_ansi  116.42µs 120.78µs     8032.    8.86KB     8.33
#>  9 base_vec_ansi     6.08µs   6.35µs   154649.      848B     0   
#> 10 cli_vec_plain    22.76µs   23.5µs    41699.     1.7KB     4.17
#> 11 fansi_vec_plain 110.45µs 114.89µs     8406.    8.86KB     8.33
#> 12 base_vec_plain    5.86µs      6µs   163437.      848B     0   
#> 13 cli_txt_ansi      6.79µs   7.29µs   132024.        0B    13.2 
#> 14 fansi_txt_ansi   79.49µs  83.19µs    11631.    1.98KB    12.5 
#> 15 base_txt_ansi     6.48µs   6.54µs   149632.        0B     0   
#> 16 cli_txt_plain     7.47µs   7.92µs   122766.        0B    12.3 
#> 17 fansi_txt_plain  79.25µs  84.39µs    11524.    1.98KB    10.4 
#> 18 base_txt_plain    4.12µs   4.19µs   231243.        0B     0
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
#>  1 cli_ansi       112.16µs 117.84µs    8201.     12.1KB     8.21
#>  2 base_ansi        1.34µs   1.39µs  691695.         0B     0   
#>  3 cli_plain       90.63µs  94.77µs   10209.     8.91KB     8.21
#>  4 base_plain       1.04µs   1.08µs  888508.         0B     0   
#>  5 cli_vec_ansi     4.26ms   4.41ms     227.   838.95KB    13.1 
#>  6 base_vec_ansi   71.93µs   72.2µs   13689.       848B     0   
#>  7 cli_vec_plain    2.38ms   2.46ms     404.   817.08KB    15.1 
#>  8 base_vec_plain  42.48µs  43.02µs   22992.       848B     0   
#>  9 cli_txt_ansi    14.44ms   14.5ms      68.8   114.6KB     2.02
#> 10 base_txt_ansi   73.33µs  73.84µs   13365.         0B     2.01
#> 11 cli_txt_plain  306.16µs 316.15µs    3096.    18.34KB     2.01
#> 12 base_txt_plain  40.17µs  41.77µs   23852.         0B     0
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
#>  1 cli_ansi        110.6µs    116µs     8319.        0B    12.4 
#>  2 base_ansi        16.7µs   17.8µs    54422.        0B    10.9 
#>  3 cli_plain       108.8µs  114.6µs     8436.        0B    10.3 
#>  4 base_plain       16.7µs   17.9µs    53661.        0B    16.1 
#>  5 cli_vec_ansi    207.1µs  217.4µs     4503.     7.2KB     6.13
#>  6 base_vec_ansi    59.3µs   64.5µs    15301.    1.66KB     2.01
#>  7 cli_vec_plain   192.4µs  203.1µs     4812.     7.2KB     6.13
#>  8 base_vec_plain   51.7µs   57.4µs    17095.    1.66KB     4.06
#>  9 cli_txt_ansi      182µs  188.8µs     5170.        0B     8.18
#> 10 base_txt_ansi    41.1µs   42.4µs    22917.        0B     4.58
#> 11 cli_txt_plain   165.9µs  172.1µs     5663.        0B     8.18
#> 12 base_txt_plain   35.4µs   36.6µs    26585.        0B     5.32
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
#> 1 cli          8.24µs   8.91µs   108669.        0B    10.9 
#> 2 base       872.07ns 932.02ns   985879.        0B     0   
#> 3 cli_vec     23.23µs  24.07µs    40597.      448B     4.06
#> 4 base_vec    11.64µs  11.91µs    82501.      448B     8.25
#> 5 cli_txt     23.39µs  24.09µs    40545.        0B     4.05
#> 6 base_txt    12.63µs  12.72µs    77021.        0B     0
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
#> 1 cli          8.19µs   8.87µs   109067.        0B    10.9 
#> 2 base         1.31µs   1.36µs   693175.        0B     0   
#> 3 cli_vec     28.69µs  29.61µs    33038.      448B     6.61
#> 4 base_vec    50.91µs  51.31µs    19236.      448B     0   
#> 5 cli_txt     29.04µs  29.85µs    32825.        0B     3.28
#> 6 base_txt    86.91µs  87.62µs    11279.        0B     0
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
#> 1 cli          8.81µs   9.49µs   102083.        0B    20.4 
#> 2 base       872.07ns 922.13ns  1023159.        0B     0   
#> 3 cli_vec     19.94µs  20.74µs    47139.      448B     4.71
#> 4 base_vec    11.62µs  11.87µs    82855.      448B     0   
#> 5 cli_txt      20.6µs  21.38µs    45630.        0B     9.13
#> 6 base_txt    12.63µs  12.72µs    77300.        0B     0
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
#> 1 cli           6.4µs   6.98µs   138752.    22.2KB    13.9 
#> 2 base         1.07µs   1.15µs   808035.        0B     0   
#> 3 cli_vec     30.85µs  31.81µs    30878.     1.7KB     6.18
#> 4 base_vec     8.36µs   8.66µs   113675.      848B     0   
#> 5 cli_txt      6.32µs   6.88µs   140847.        0B    14.1 
#> 6 base_txt     5.72µs   5.79µs   167995.        0B     0
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
