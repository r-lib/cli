# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55e00b38ca40\>
\<environment: 0x55e00bedd830\>

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
#> 1 ansi         46.5µs   50.1µs    19324.    99.3KB     18.8
#> 2 plain        47.3µs   50.9µs    19000.        0B     17.3
#> 3 base         11.2µs   12.4µs    78243.    48.4KB     23.5
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
#> 1 ansi         49.1µs   52.9µs    18255.        0B     21.1
#> 2 plain        48.7µs   52.6µs    18367.        0B     21.2
#> 3 base         13.1µs   14.4µs    67081.        0B     20.1
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
#> 1 ansi        111.5µs 117.84µs     8211.   75.07KB     14.6
#> 2 plain        87.7µs  92.36µs    10456.    8.73KB     14.6
#> 3 base          1.8µs   1.93µs   496073.        0B      0
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
#> 1 ansi          339µs    366µs     2688.   33.17KB     16.8
#> 2 plain         340µs    364µs     2711.    1.09KB     19.0
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
#>  1 cli_ansi          5.96µs   6.62µs   145931.     9.2KB     29.2
#>  2 fansi_ansi       30.43µs  33.48µs    28656.    4.18KB     22.9
#>  3 cli_plain         6.03µs   6.53µs   147688.        0B     29.5
#>  4 fansi_plain      29.65µs  32.42µs    29928.      688B     24.0
#>  5 cli_vec_ansi      7.33µs   7.88µs   123732.      448B     24.8
#>  6 fansi_vec_ansi   39.49µs  41.35µs    23337.    5.02KB     18.7
#>  7 cli_vec_plain     7.99µs   8.48µs   114997.      448B     23.0
#>  8 fansi_vec_plain  37.31µs  39.25µs    24694.    5.02KB     19.8
#>  9 cli_txt_ansi      5.88µs   6.38µs   152241.        0B     30.5
#> 10 fansi_txt_ansi   29.95µs  31.67µs    30514.      688B     24.4
#> 11 cli_txt_plain     6.77µs   7.26µs   133649.        0B     26.7
#> 12 fansi_txt_plain  37.47µs  39.47µs    24546.    5.02KB     19.7
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
#> 1 cli          56.4µs   57.9µs    16873.    22.7KB    10.3 
#> 2 fansi       118.5µs  121.8µs     8035.    55.3KB     8.20
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
#>  1 cli_ansi          6.64µs   7.15µs   135343.        0B    27.1 
#>  2 fansi_ansi       89.97µs  94.76µs    10170.   38.83KB    16.7 
#>  3 base_ansi       832.02ns 872.07ns  1075149.        0B     0   
#>  4 cli_plain         6.69µs   7.26µs   103061.        0B    20.6 
#>  5 fansi_plain      89.31µs  94.21µs    10255.      688B    16.7 
#>  6 base_plain      771.02ns    812ns  1147262.        0B     0   
#>  7 cli_vec_ansi     28.32µs  29.13µs    33308.      448B     6.66
#>  8 fansi_vec_ansi  111.06µs 115.51µs     8383.    5.02KB    14.7 
#>  9 base_vec_ansi    14.67µs  14.77µs    66597.      448B     0   
#> 10 cli_vec_plain    26.53µs  27.28µs    35944.      448B     7.19
#> 11 fansi_vec_plain 101.44µs 106.06µs     9072.    5.02KB    14.7 
#> 12 base_vec_plain    8.74µs   8.85µs   110914.      448B     0   
#> 13 cli_txt_ansi     27.87µs  28.61µs    34280.        0B     6.86
#> 14 fansi_txt_ansi  102.69µs 107.36µs     8981.      688B    14.6 
#> 15 base_txt_ansi    14.26µs  14.32µs    68668.        0B     0   
#> 16 cli_txt_plain    26.07µs  26.72µs    36703.        0B     7.34
#> 17 fansi_txt_plain  92.09µs  97.26µs     9943.      688B    16.8 
#> 18 base_txt_plain     8.4µs   8.94µs   111815.        0B     0
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
#>  1 cli_ansi          8.36µs   8.92µs   108949.        0B    21.8 
#>  2 fansi_ansi       90.71µs  95.31µs    10014.      688B    16.7 
#>  3 base_ansi         1.16µs   1.21µs   658799.        0B     0   
#>  4 cli_plain         8.23µs   8.87µs   109284.        0B    32.8 
#>  5 fansi_plain      90.07µs  94.71µs    10186.      688B    16.8 
#>  6 base_plain      942.03ns 991.98ns   971132.        0B     0   
#>  7 cli_vec_ansi      34.6µs  35.27µs    27811.      448B     5.56
#>  8 fansi_vec_ansi  113.16µs 117.68µs     8216.    5.02KB    14.6 
#>  9 base_vec_ansi    42.55µs  42.82µs    23065.      448B     0   
#> 10 cli_vec_plain    32.93µs  33.73µs    29030.      448B     5.81
#> 11 fansi_vec_plain 102.68µs 107.11µs     9010.    5.02KB    14.6 
#> 12 base_vec_plain   22.24µs   22.5µs    43673.      448B     4.37
#> 13 cli_txt_ansi     34.59µs  35.33µs    27691.        0B     5.54
#> 14 fansi_txt_ansi  106.11µs 110.74µs     8712.      688B    14.5 
#> 15 base_txt_ansi    45.41µs   45.7µs    21537.        0B     0   
#> 16 cli_txt_plain    32.68µs   33.4µs    29350.        0B     5.87
#> 17 fansi_txt_plain  95.67µs 100.37µs     9637.      688B    16.7 
#> 18 base_txt_plain   23.91µs  24.58µs    40172.        0B     0
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
#> 1 cli_ansi        6.65µs   7.15µs   135246.        0B    27.1 
#> 2 cli_plain       6.31µs   6.77µs   143172.        0B    28.6 
#> 3 cli_vec_ansi   31.16µs  32.26µs    29684.      848B     2.97
#> 4 cli_vec_plain  10.13µs  10.68µs    91211.      848B    18.2 
#> 5 cli_txt_ansi   30.63µs  31.59µs    30948.        0B     6.19
#> 6 cli_txt_plain   7.06µs    7.6µs   127964.        0B    12.8
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
#>  1 cli_ansi          26.1µs   27.6µs    34949.        0B     28.0
#>  2 fansi_ansi          28µs   29.7µs    32593.    7.24KB     22.8
#>  3 cli_plain         25.5µs     27µs    35927.        0B     28.8
#>  4 fansi_plain       27.5µs   29.2µs    32976.      688B     26.4
#>  5 cli_vec_ansi      35.1µs   36.7µs    26403.      848B     21.1
#>  6 fansi_vec_ansi    53.4µs   55.7µs    17377.    5.41KB     14.7
#>  7 cli_vec_plain     28.5µs     30µs    32148.      848B     25.7
#>  8 fansi_vec_plain   36.3µs   38.3µs    25124.    4.59KB     17.6
#>  9 cli_txt_ansi      34.4µs     36µs    26873.        0B     21.5
#> 10 fansi_txt_ansi    43.9µs   45.8µs    19828.    5.12KB     14.8
#> 11 cli_txt_plain     26.4µs   27.7µs    34749.        0B     27.8
#> 12 fansi_txt_plain   28.7µs     30µs    32226.      688B     25.8
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
#>  1 cli_ansi        163.42µs  171.2µs     5655.  104.34KB    19.0 
#>  2 fansi_ansi      125.96µs 132.19µs     7339.  106.35KB    21.2 
#>  3 base_ansi         4.04µs   4.35µs   224478.      224B     0   
#>  4 cli_plain       162.57µs 170.12µs     5700.    8.09KB    18.9 
#>  5 fansi_plain     124.06µs  131.5µs     7381.    9.62KB    21.2 
#>  6 base_plain        3.49µs   3.77µs   255050.        0B     0   
#>  7 cli_vec_ansi      7.48ms    7.7ms      129.  823.77KB    29.0 
#>  8 fansi_vec_ansi    1.05ms   1.09ms      890.  846.81KB    17.3 
#>  9 base_vec_ansi   153.98µs 160.64µs     6109.    22.7KB     4.08
#> 10 cli_vec_plain     7.43ms   7.58ms      132.  823.77KB    25.4 
#> 11 fansi_vec_plain 997.22µs   1.04ms      945.  845.98KB    19.6 
#> 12 base_vec_plain  106.68µs 111.19µs     8834.      848B     4.06
#> 13 cli_txt_ansi      3.42ms   3.46ms      288.    63.6KB     0   
#> 14 fansi_txt_ansi    1.55ms   1.57ms      631.   35.05KB     2.02
#> 15 base_txt_ansi   136.16µs 146.63µs     6727.   18.47KB     2.03
#> 16 cli_txt_plain     2.39ms   2.42ms      412.    63.6KB     0   
#> 17 fansi_txt_plain 513.19µs 535.28µs     1834.    30.6KB     6.16
#> 18 base_txt_plain   87.92µs  89.28µs    10906.   11.05KB     2.04
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
#>  1 cli_ansi        144.39µs 154.16µs     6249.   33.84KB     23.2
#>  2 fansi_ansi       53.04µs  56.42µs    17044.   31.42KB     24.5
#>  3 base_ansi         1.03µs   1.08µs   893867.     4.2KB      0  
#>  4 cli_plain       141.61µs 148.43µs     6571.        0B     23.1
#>  5 fansi_plain      52.68µs  55.38µs    17476.      872B     23.5
#>  6 base_plain      951.11ns      1µs   944843.        0B     94.5
#>  7 cli_vec_ansi    272.33µs 282.35µs     3481.   16.73KB     12.5
#>  8 fansi_vec_ansi  115.69µs 119.26µs     8171.    5.59KB     12.5
#>  9 base_vec_ansi     36.3µs  37.23µs    26499.      848B      0  
#> 10 cli_vec_plain   229.12µs 237.22µs     4120.   16.73KB     14.7
#> 11 fansi_vec_plain 108.62µs  112.2µs     8688.    5.59KB     14.6
#> 12 base_vec_plain   30.41µs  30.74µs    32045.      848B      0  
#> 13 cli_txt_ansi    154.23µs 160.86µs     6033.        0B     21.0
#> 14 fansi_txt_ansi    53.3µs  56.23µs    17263.      872B     23.3
#> 15 base_txt_ansi     1.07µs   1.12µs   828758.        0B     82.9
#> 16 cli_txt_plain   143.37µs 151.35µs     6341.        0B     23.2
#> 17 fansi_txt_plain  52.92µs  56.35µs    17218.      872B     23.3
#> 18 base_txt_plain  981.15ns   1.03µs   906605.        0B      0
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
#>  1 cli_ansi        397.26µs 425.55µs    2332.         0B    21.3 
#>  2 fansi_ansi       96.83µs 102.33µs    9475.    97.32KB    21.0 
#>  3 base_ansi        38.32µs  40.63µs   23751.         0B    19.3 
#>  4 cli_plain       272.86µs 286.32µs    3426.         0B    10.3 
#>  5 fansi_plain      95.47µs 101.36µs    9541.       872B    12.4 
#>  6 base_plain       31.33µs   33.2µs   29128.         0B    11.7 
#>  7 cli_vec_ansi     42.01ms   42.2ms      23.6    2.48KB    16.9 
#>  8 fansi_vec_ansi  235.46µs 243.74µs    3999.     7.25KB     6.17
#>  9 base_vec_ansi     2.29ms   2.34ms     424.    48.18KB    12.8 
#> 10 cli_vec_plain    28.76ms  28.89ms      34.6    2.48KB    18.9 
#> 11 fansi_vec_plain 192.14µs 198.33µs    4928.     6.42KB     6.13
#> 12 base_vec_plain    1.63ms    1.7ms     588.     47.4KB    12.7 
#> 13 cli_txt_ansi     23.77ms  24.06ms      41.4  507.59KB     6.91
#> 14 fansi_txt_ansi  226.08µs 234.08µs    4194.     6.77KB     6.13
#> 15 base_txt_ansi     1.26ms   1.29ms     751.   582.06KB    11.0 
#> 16 cli_txt_plain     1.27ms   1.31ms     758.   369.84KB     8.56
#> 17 fansi_txt_plain 178.31µs  184.8µs    5276.     2.51KB     6.13
#> 18 base_txt_plain  860.87µs 891.18µs    1111.   367.31KB    11.1
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
#>  1 cli_ansi          6.64µs   7.29µs   131187.   24.83KB    13.1 
#>  2 fansi_ansi       78.06µs  82.48µs    11732.   28.48KB    12.5 
#>  3 base_ansi       972.07ns   1.02µs   894294.        0B     0   
#>  4 cli_plain          6.7µs   7.24µs   134381.        0B    13.4 
#>  5 fansi_plain      78.16µs  82.38µs    11759.    1.98KB    12.5 
#>  6 base_plain      942.03ns      1µs   915359.        0B     0   
#>  7 cli_vec_ansi     27.79µs  28.84µs    34001.     1.7KB     3.40
#>  8 fansi_vec_ansi  116.03µs 120.39µs     8064.    8.86KB     8.34
#>  9 base_vec_ansi     6.08µs   6.37µs   153518.      848B     0   
#> 10 cli_vec_plain    23.31µs  24.92µs    39079.     1.7KB     7.82
#> 11 fansi_vec_plain 109.76µs 114.45µs     8454.    8.86KB     8.30
#> 12 base_vec_plain    5.81µs   5.99µs   162792.      848B     0   
#> 13 cli_txt_ansi      6.65µs   7.28µs   132782.        0B    13.3 
#> 14 fansi_txt_ansi   78.56µs     83µs    11637.    1.98KB    10.4 
#> 15 base_txt_ansi     5.11µs    5.2µs   187367.        0B    18.7 
#> 16 cli_txt_plain     7.49µs   8.09µs   119805.        0B    12.0 
#> 17 fansi_txt_plain  77.81µs  83.27µs    11144.    1.98KB    10.5 
#> 18 base_txt_plain    3.35µs   3.41µs   281503.        0B     0
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
#>  1 cli_ansi        103.8µs 109.58µs    8827.    11.88KB     8.20
#>  2 base_ansi        1.27µs   1.32µs  720418.         0B     0   
#>  3 cli_plain       83.56µs  87.61µs   10992.     8.73KB     8.19
#>  4 base_plain     971.14ns   1.01µs  931719.         0B     0   
#>  5 cli_vec_ansi     4.04ms   4.18ms     239.   838.77KB    15.5 
#>  6 base_vec_ansi   71.89µs  72.19µs   13650.       848B     0   
#>  7 cli_vec_plain    2.26ms   2.33ms     428.    816.9KB    15.1 
#>  8 base_vec_plain  43.04µs  43.58µs   22570.       848B     0   
#>  9 cli_txt_ansi    13.43ms  13.52ms      73.9  114.42KB     4.22
#> 10 base_txt_ansi   73.67µs  73.97µs   13276.         0B     0   
#> 11 cli_txt_plain  259.27µs 266.53µs    3673.    18.16KB     4.05
#> 12 base_txt_plain  41.04µs  42.52µs   23193.         0B     0
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
#>  1 cli_ansi        108.3µs  112.4µs     8591.        0B    12.4 
#>  2 base_ansi        16.3µs   17.2µs    56168.        0B    11.2 
#>  3 cli_plain       106.6µs    111µs     8722.        0B    12.4 
#>  4 base_plain       16.2µs   17.3µs    55801.        0B    11.2 
#>  5 cli_vec_ansi    197.5µs  208.8µs     4664.     7.2KB     6.12
#>  6 base_vec_ansi    54.3µs     61µs    16170.    1.66KB     4.06
#>  7 cli_vec_plain   181.2µs  191.6µs     5083.     7.2KB     8.23
#>  8 base_vec_plain   49.3µs   55.1µs    17909.    1.66KB     2.01
#>  9 cli_txt_ansi    173.6µs  178.8µs     5444.        0B     8.18
#> 10 base_txt_ansi    38.2µs   39.5µs    24742.        0B     4.95
#> 11 cli_txt_plain   157.4µs  162.5µs     5979.        0B    10.2 
#> 12 base_txt_plain   33.6µs   34.7µs    28068.        0B     5.61
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
#> 1 cli          8.03µs   8.65µs   111549.        0B    11.2 
#> 2 base       811.07ns 861.12ns  1072676.        0B     0   
#> 3 cli_vec     23.31µs  24.11µs    40583.      448B     4.06
#> 4 base_vec    11.69µs   11.9µs    82411.      448B     8.24
#> 5 cli_txt     22.99µs  23.75µs    40937.        0B     4.09
#> 6 base_txt    12.27µs  12.38µs    79397.        0B     0
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
#> 1 cli          7.92µs   8.55µs   112623.        0B    11.3 
#> 2 base         1.25µs   1.31µs   719277.        0B     0   
#> 3 cli_vec     28.41µs   29.3µs    33230.      448B     6.65
#> 4 base_vec    51.39µs  51.96µs    19009.      448B     0   
#> 5 cli_txt     28.82µs   29.6µs    33073.        0B     3.31
#> 6 base_txt    87.46µs  88.36µs    11184.        0B     0
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
#> 1 cli          8.48µs   9.19µs   105723.        0B    21.1 
#> 2 base       821.08ns 872.07ns  1062016.        0B     0   
#> 3 cli_vec     19.73µs  20.47µs    47574.      448B     4.76
#> 4 base_vec    11.67µs   11.9µs    82683.      448B     0   
#> 5 cli_txt     20.02µs  20.68µs    47234.        0B     9.45
#> 6 base_txt    12.29µs  12.37µs    79514.        0B     0
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
#> 1 cli          6.36µs   6.91µs   140042.    22.1KB    14.0 
#> 2 base         1.01µs   1.07µs   864605.        0B    86.5 
#> 3 cli_vec     30.18µs  31.23µs    31372.     1.7KB     3.14
#> 4 base_vec     8.29µs   8.57µs   114708.      848B     0   
#> 5 cli_txt      6.27µs   6.82µs   141689.        0B    14.2 
#> 6 base_txt      5.4µs    5.5µs   169035.        0B     0
```

## Session info

``` r
sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.5.3 (2026-03-11)
#>  os       Ubuntu 24.04.4 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-03-31
#>  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.10.0     2026-01-26 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.5.9000 2026-03-31 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.5.3)
#>  desc          1.4.3      2023-12-10 [1] RSPM
#>  digest        0.6.39     2025-11-19 [1] RSPM
#>  evaluate      1.0.5      2025-08-27 [1] RSPM
#>  fansi       * 1.0.7      2025-11-19 [1] RSPM
#>  fastmap       1.2.0      2024-05-15 [1] RSPM
#>  fs            2.0.1      2026-03-24 [1] RSPM
#>  glue          1.8.0      2024-09-30 [1] RSPM
#>  htmltools     0.5.9      2025-12-04 [1] RSPM
#>  htmlwidgets   1.6.4      2023-12-06 [1] RSPM
#>  jquerylib     0.1.4      2021-04-26 [1] RSPM
#>  jsonlite      2.0.0      2025-03-27 [1] RSPM
#>  knitr         1.51       2025-12-20 [1] RSPM
#>  lifecycle     1.0.5      2026-01-08 [1] RSPM
#>  magrittr      2.0.4      2025-09-12 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.0      2025-11-06 [1] any (@2.2.0)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.1.7      2026-01-09 [1] RSPM
#>  rmarkdown     2.31       2026-03-26 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  sessioninfo   1.2.3      2025-02-05 [1] any (@1.2.3)
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.2      2026-03-21 [1] RSPM
#>  xfun          0.57       2026-03-20 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.5.3/lib/R/site-library
#>  [3] /opt/R/4.5.3/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
