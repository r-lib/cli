# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5644cb18fb98\>
\<environment: 0x5644cbc30b10\>

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
#> 1 ansi         38.9µs     44µs    19598.    99.6KB     21.2
#> 2 plain          38µs     43µs    22735.        0B     22.8
#> 3 base         10.9µs   12.4µs    78474.    48.6KB     23.5
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
#> 1 ansi         40.7µs   46.3µs    21056.        0B     23.9
#> 2 plain        40.9µs   46.9µs    20638.        0B     26.0
#> 3 base         12.8µs   14.8µs    65836.        0B     19.8
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
#> 1 ansi        93.76µs  103.3µs     9363.   76.15KB     19.2
#> 2 plain       71.78µs   78.3µs    12403.    8.73KB     19.1
#> 3 base         1.85µs    2.1µs   451006.        0B      0
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
#> 1 ansi          288µs    316µs     2915.   33.23KB     21.6
#> 2 plain         283µs    310µs     3154.    1.09KB     23.7
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
#>  1 cli_ansi          5.62µs   6.47µs   148637.    9.27KB    29.7 
#>  2 fansi_ansi       27.23µs  31.07µs    30430.    4.18KB    21.3 
#>  3 cli_plain          5.6µs   6.18µs   153044.        0B    15.3 
#>  4 fansi_plain      27.53µs  30.67µs    31456.      688B    12.6 
#>  5 cli_vec_ansi      7.06µs   7.81µs   123421.      448B    12.3 
#>  6 fansi_vec_ansi   37.15µs  40.46µs    23797.    5.02KB     9.52
#>  7 cli_vec_plain     7.68µs   8.41µs   115336.      448B    11.5 
#>  8 fansi_vec_plain  36.01µs     39µs    24965.    5.02KB    12.5 
#>  9 cli_txt_ansi      5.67µs   6.29µs   153907.        0B    15.4 
#> 10 fansi_txt_ansi   27.72µs  30.78µs    31411.      688B    12.6 
#> 11 cli_txt_plain     6.66µs   7.31µs   132618.        0B    13.3 
#> 12 fansi_txt_plain  35.62µs  38.85µs    25111.    5.02KB    12.6
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
#> 1 cli          56.3µs   58.6µs    16529.    22.7KB     4.05
#> 2 fansi       111.3µs  117.4µs     8349.    55.3KB     4.06
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
#>  1 cli_ansi          6.72µs   7.59µs   127227.        0B    12.7 
#>  2 fansi_ansi       74.45µs  81.38µs    11768.   38.84KB    10.4 
#>  3 base_ansi       911.07ns      1µs   908617.        0B     0   
#>  4 cli_plain         6.61µs   7.47µs   128529.        0B    12.9 
#>  5 fansi_plain      73.58µs  80.46µs    12094.      688B    10.4 
#>  6 base_plain      820.96ns 910.95ns   973134.        0B     0   
#>  7 cli_vec_ansi     29.05µs  30.26µs    32475.      448B     3.25
#>  8 fansi_vec_ansi   94.44µs 101.77µs     9565.    5.02KB     8.32
#>  9 base_vec_ansi     18.9µs  19.04µs    51518.      448B     0   
#> 10 cli_vec_plain    26.19µs  27.72µs    35413.      448B     3.54
#> 11 fansi_vec_plain  84.09µs   90.7µs    10693.    5.02KB    10.5 
#> 12 base_vec_plain   11.02µs  11.16µs    87923.      448B     0   
#> 13 cli_txt_ansi     28.85µs  29.91µs    32821.        0B     3.28
#> 14 fansi_txt_ansi   86.23µs  92.84µs    10491.      688B     8.22
#> 15 base_txt_ansi    18.86µs  18.99µs    51710.        0B     5.17
#> 16 cli_txt_plain       26µs  27.27µs    36167.        0B     3.62
#> 17 fansi_txt_plain  74.68µs  82.06µs    11886.      688B    10.4 
#> 18 base_txt_plain   10.91µs  11.02µs    89149.        0B     0
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
#>  1 cli_ansi          8.16µs    9.2µs   105217.        0B    10.5 
#>  2 fansi_ansi       74.34µs   81.2µs    11995.      688B    10.4 
#>  3 base_ansi          1.2µs   1.31µs   701791.        0B     0   
#>  4 cli_plain         8.12µs   9.08µs   106514.        0B    21.3 
#>  5 fansi_plain      73.98µs   80.9µs    11867.      688B    10.4 
#>  6 base_plain      992.09ns   1.09µs   845262.        0B     0   
#>  7 cli_vec_ansi     34.33µs   35.7µs    27545.      448B     2.75
#>  8 fansi_vec_ansi   97.07µs 105.45µs     9208.    5.02KB     8.33
#>  9 base_vec_ansi    41.31µs  41.69µs    23549.      448B     0   
#> 10 cli_vec_plain    32.27µs  33.54µs    29310.      448B     2.93
#> 11 fansi_vec_plain   87.1µs  94.54µs    10273.    5.02KB    10.5 
#> 12 base_vec_plain   21.64µs  21.97µs    44861.      448B     0   
#> 13 cli_txt_ansi     34.95µs  36.19µs    27153.        0B     2.72
#> 14 fansi_txt_ansi   88.61µs  96.03µs    10053.      688B     8.24
#> 15 base_txt_ansi    43.44µs  44.36µs    21519.        0B     2.15
#> 16 cli_txt_plain    32.05µs   33.5µs    29348.        0B     2.94
#> 17 fansi_txt_plain  78.05µs  85.92µs    11350.      688B    10.5 
#> 18 base_txt_plain   22.99µs  23.23µs    42406.        0B     0
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
#> 1 cli_ansi        6.53µs   7.32µs   132576.        0B    13.3 
#> 2 cli_plain       6.15µs   6.89µs   139996.        0B    14.0 
#> 3 cli_vec_ansi   31.01µs  32.19µs    30544.      848B     3.05
#> 4 cli_vec_plain  10.22µs   11.1µs    87798.      848B     8.78
#> 5 cli_txt_ansi   30.42µs  31.46µs    31233.        0B     3.12
#> 6 cli_txt_plain   7.11µs   7.86µs   123510.        0B     0
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
#>  1 cli_ansi          24.5µs   26.8µs    36361.        0B    14.6 
#>  2 fansi_ansi        26.4µs   29.3µs    32859.    7.24KB    13.1 
#>  3 cli_plain           24µs   26.8µs    36302.        0B    14.5 
#>  4 fansi_plain       25.4µs   27.8µs    34926.      688B    17.5 
#>  5 cli_vec_ansi      33.5µs     36µs    27202.      848B    10.9 
#>  6 fansi_vec_ansi    51.9µs   54.7µs    17930.    5.41KB     8.33
#>  7 cli_vec_plain     27.1µs   28.9µs    33817.      848B    13.5 
#>  8 fansi_vec_plain   35.3µs   37.7µs    25920.    4.59KB    10.4 
#>  9 cli_txt_ansi      32.5µs   35.5µs    27503.        0B    11.0 
#> 10 fansi_txt_ansi    42.5µs   45.2µs    21648.    5.12KB     8.66
#> 11 cli_txt_plain     25.3µs   27.5µs    35502.        0B    17.8 
#> 12 fansi_txt_plain   27.4µs   29.8µs    32667.      688B    13.1
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
#>  1 cli_ansi        135.07µs 145.07µs     6714.  104.86KB    12.5 
#>  2 fansi_ansi      110.38µs 121.42µs     8067.  106.35KB    10.4 
#>  3 base_ansi         4.05µs   4.54µs   213532.      224B    21.4 
#>  4 cli_plain       131.59µs 143.29µs     6791.    8.09KB    12.5 
#>  5 fansi_plain     108.11µs 119.53µs     8174.    9.62KB    10.4 
#>  6 base_plain         3.5µs    3.9µs   246537.        0B    24.7 
#>  7 cli_vec_ansi      6.72ms   6.95ms      143.  823.77KB    13.9 
#>  8 fansi_vec_ansi    1.05ms   1.09ms      891.  846.81KB    17.4 
#>  9 base_vec_ansi    155.3µs 161.47µs     6028.    22.7KB     2.05
#> 10 cli_vec_plain     6.57ms   6.88ms      145.  823.77KB    13.8 
#> 11 fansi_vec_plain   1.01ms   1.06ms      936.  845.98KB    18.1 
#> 12 base_vec_plain  106.01µs  110.1µs     8924.      848B     2.02
#> 13 cli_txt_ansi      3.17ms   3.26ms      305.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.61ms   1.64ms      609.   35.05KB     0   
#> 15 base_txt_ansi   143.06µs 154.87µs     6366.   18.47KB     2.03
#> 16 cli_txt_plain     2.36ms   2.41ms      415.    63.6KB     0   
#> 17 fansi_txt_plain  535.4µs 565.33µs     1760.    30.6KB     4.09
#> 18 base_txt_plain    91.4µs  94.24µs    10423.   11.05KB     2.02
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
#>  1 cli_ansi        128.34µs 139.38µs     6964.   33.84KB    14.7 
#>  2 fansi_ansi       48.24µs  54.48µs    17827.   31.42KB    12.9 
#>  3 base_ansi         1.02µs   1.13µs   827601.     4.2KB     0   
#>  4 cli_plain       130.33µs 139.14µs     7027.        0B    12.5 
#>  5 fansi_plain      49.51µs  54.94µs    17791.      872B    14.7 
#>  6 base_plain      952.04ns   1.07µs   866495.        0B     0   
#>  7 cli_vec_ansi    254.96µs 265.97µs     3702.   16.73KB     6.18
#>  8 fansi_vec_ansi  113.96µs 119.58µs     8190.    5.59KB     7.78
#>  9 base_vec_ansi    36.21µs  36.56µs    26899.      848B     0   
#> 10 cli_vec_plain   212.96µs 220.78µs     4470.   16.73KB     8.34
#> 11 fansi_vec_plain 104.67µs 108.44µs     9056.    5.59KB     8.33
#> 12 base_vec_plain   30.09µs  30.45µs    32447.      848B     0   
#> 13 cli_txt_ansi    137.25µs 143.33µs     6834.        0B    12.5 
#> 14 fansi_txt_ansi   49.11µs  52.36µs    18502.      872B    14.8 
#> 15 base_txt_ansi     1.05µs   1.17µs   811212.        0B     0   
#> 16 cli_txt_plain   132.13µs 140.49µs     6993.        0B    12.5 
#> 17 fansi_txt_plain  49.52µs  54.84µs    17888.      872B    14.7 
#> 18 base_txt_plain  981.03ns    1.1µs   849749.        0B     0
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
#>  1 cli_ansi        339.24µs 367.57µs    2641.         0B    12.6 
#>  2 fansi_ansi       88.32µs  96.99µs   10096.    97.33KB    10.4 
#>  3 base_ansi        32.86µs  35.65µs   27212.         0B    13.6 
#>  4 cli_plain       225.21µs 240.89µs    4049.         0B    12.5 
#>  5 fansi_plain      87.13µs  96.26µs   10165.       872B    12.7 
#>  6 base_plain       26.38µs  28.77µs   33829.         0B    13.5 
#>  7 cli_vec_ansi      36.6ms  36.83ms      27.1    2.48KB    20.3 
#>  8 fansi_vec_ansi  238.07µs 250.26µs    3937.     7.25KB     6.17
#>  9 base_vec_ansi     2.22ms   2.35ms     373.    48.18KB    10.7 
#> 10 cli_vec_plain    23.69ms   23.9ms      41.7    2.48KB    17.9 
#> 11 fansi_vec_plain 186.75µs 199.12µs    4933.     6.42KB     8.28
#> 12 base_vec_plain    1.63ms   1.71ms     581.     47.4KB    12.9 
#> 13 cli_txt_ansi     25.93ms  26.23ms      38.1  507.59KB     4.48
#> 14 fansi_txt_ansi  227.68µs 239.84µs    4112.     6.77KB     6.24
#> 15 base_txt_ansi     1.32ms   1.37ms     717.   582.06KB     9.05
#> 16 cli_txt_plain     1.31ms   1.36ms     723.   369.84KB     8.90
#> 17 fansi_txt_plain 174.86µs 185.23µs    5311.     2.51KB     6.18
#> 18 base_txt_plain  875.49µs  917.3µs    1067.   367.31KB    11.4
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
#>  1 cli_ansi          6.68µs   7.41µs   130488.   25.09KB    13.1 
#>  2 fansi_ansi       70.45µs   75.1µs    12970.   28.48KB    12.8 
#>  3 base_ansi         1.02µs   1.12µs   773044.        0B     0   
#>  4 cli_plain         6.61µs   7.66µs   125633.        0B    12.6 
#>  5 fansi_plain      70.64µs  77.76µs    12566.    1.98KB    12.6 
#>  6 base_plain      991.04ns   1.09µs   830864.        0B     0   
#>  7 cli_vec_ansi     26.51µs  27.97µs    35066.     1.7KB     7.01
#>  8 fansi_vec_ansi  108.42µs 115.45µs     8378.    8.86KB     6.23
#>  9 base_vec_ansi     6.26µs   6.61µs   146895.      848B    14.7 
#> 10 cli_vec_plain     23.3µs  24.51µs    40024.     1.7KB     4.00
#> 11 fansi_vec_plain 101.73µs 109.47µs     8948.    8.86KB     8.42
#> 12 base_vec_plain    6.01µs    6.3µs   155090.      848B     0   
#> 13 cli_txt_ansi      6.62µs   7.56µs   127535.        0B    12.8 
#> 14 fansi_txt_ansi   70.09µs  77.91µs    12377.    1.98KB    12.6 
#> 15 base_txt_ansi     7.04µs   7.19µs   134389.        0B     0   
#> 16 cli_txt_plain     7.46µs   8.44µs   114285.        0B    11.4 
#> 17 fansi_txt_plain  71.24µs  78.45µs    12524.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.53µs   213320.        0B     0
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
#>  1 cli_ansi        88.72µs  95.83µs   10135.    11.88KB    10.4 
#>  2 base_ansi        1.27µs   1.36µs  708526.         0B     0   
#>  3 cli_plain       69.62µs  74.99µs   12950.     8.73KB     8.38
#>  4 base_plain     991.04ns   1.06µs  861230.         0B     0   
#>  5 cli_vec_ansi     4.25ms   4.46ms     225.   838.77KB    15.9 
#>  6 base_vec_ansi   70.37µs  71.95µs   13722.       848B     0   
#>  7 cli_vec_plain    2.36ms   2.44ms     409.    816.9KB    13.0 
#>  8 base_vec_plain  41.86µs  43.22µs   22870.       848B     0   
#>  9 cli_txt_ansi    15.47ms  15.65ms      63.8  114.42KB     4.25
#> 10 base_txt_ansi   68.78µs  70.23µs   14041.         0B     0   
#> 11 cli_txt_plain  264.97µs 275.95µs    3568.    18.16KB     2.02
#> 12 base_txt_plain  39.69µs  40.35µs   24455.         0B     0
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
#>  1 cli_ansi         90.2µs   98.6µs     9727.        0B    12.5 
#>  2 base_ansi        14.9µs   16.6µs    58030.        0B    11.6 
#>  3 cli_plain        90.6µs   97.3µs     9921.        0B    14.7 
#>  4 base_plain       15.1µs   16.6µs    57987.        0B    11.6 
#>  5 cli_vec_ansi    193.7µs  205.2µs     4757.     7.2KB     6.17
#>  6 base_vec_ansi    54.8µs   62.4µs    15925.    1.66KB     4.08
#>  7 cli_vec_plain   176.8µs  189.6µs     5146.     7.2KB     6.27
#>  8 base_vec_plain   48.2µs   54.7µs    17049.    1.66KB     4.07
#>  9 cli_txt_ansi    169.8µs  178.8µs     5367.        0B     8.23
#> 10 base_txt_ansi    41.2µs     43µs    22728.        0B     4.55
#> 11 cli_txt_plain   154.2µs  161.6µs     6068.        0B     8.22
#> 12 base_txt_plain   34.3µs   36.3µs    26935.        0B     5.39
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
#> 1 cli           7.8µs   8.74µs   109705.        0B    21.9 
#> 2 base        851.9ns 960.89ns   962258.        0B     0   
#> 3 cli_vec      23.6µs  25.04µs    39169.      448B     3.92
#> 4 base_vec     12.3µs  12.57µs    77908.      448B     0   
#> 5 cli_txt      23.5µs  24.63µs    39433.        0B     3.94
#> 6 base_txt     13.4µs  14.02µs    70389.        0B     0
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
#> 1 cli           7.7µs   8.68µs   110690.        0B    11.1 
#> 2 base         1.32µs   1.43µs   642152.        0B     0   
#> 3 cli_vec     29.55µs  30.98µs    30896.      448B     3.09
#> 4 base_vec    54.31µs  55.07µs    17906.      448B     0   
#> 5 cli_txt     29.75µs  30.96µs    31551.        0B     6.31
#> 6 base_txt    90.58µs  91.56µs    10788.        0B     0
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
#> 1 cli          8.23µs   8.97µs   108350.        0B    10.8 
#> 2 base       840.98ns 951.11ns   965024.        0B     0   
#> 3 cli_vec     19.96µs  20.88µs    46920.      448B     9.39
#> 4 base_vec    12.24µs  12.53µs    78407.      448B     0   
#> 5 cli_txt     20.95µs  22.13µs    44471.        0B     4.45
#> 6 base_txt     13.4µs  13.87µs    70973.        0B     0
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
#> 1 cli          6.26µs   6.92µs   139060.    22.2KB    27.8 
#> 2 base         1.04µs   1.16µs   806179.        0B     0   
#> 3 cli_vec     30.64µs  31.87µs    30808.     1.7KB     3.08
#> 4 base_vec     8.61µs   8.82µs   110933.      848B     0   
#> 5 cli_txt      6.28µs   6.92µs   139158.        0B    13.9 
#> 6 base_txt     5.81µs   6.15µs   160834.        0B    16.1
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
#>  date     2026-05-20
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-05-20 [1] local
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
