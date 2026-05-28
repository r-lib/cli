# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5642e6184028\>
\<environment: 0x5642e6c24f60\>

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
#> 1 ansi         37.9µs   42.8µs    22844.    99.6KB     22.9
#> 2 plain        38.1µs   42.9µs    22616.        0B     22.6
#> 3 base         10.7µs   12.7µs    76415.    48.6KB     22.9
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
#> 1 ansi         40.2µs   45.7µs    21334.        0B     26.4
#> 2 plain        40.8µs   45.7µs    21326.        0B     25.9
#> 3 base         12.8µs   14.9µs    65411.        0B     19.6
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
#> 1 ansi        94.07µs 104.46µs     9210.   76.15KB     17.0
#> 2 plain       71.76µs  79.56µs    12208.    8.73KB     19.2
#> 3 base         1.84µs   2.09µs   454789.        0B      0
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
#> 1 ansi          281µs    311µs     3177.   33.23KB     24.1
#> 2 plain         285µs    318µs     2941.    1.09KB     21.7
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
#>  1 cli_ansi          5.53µs    6.4µs   149628.    9.27KB    29.9 
#>  2 fansi_ansi       26.98µs  30.71µs    31095.    4.18KB    18.7 
#>  3 cli_plain         5.57µs   6.17µs   155440.        0B    15.5 
#>  4 fansi_plain       27.6µs  30.27µs    32203.      688B    12.9 
#>  5 cli_vec_ansi      6.85µs   7.56µs   128949.      448B    12.9 
#>  6 fansi_vec_ansi   36.81µs  39.88µs    24349.    5.02KB    12.2 
#>  7 cli_vec_plain     7.58µs   8.28µs   117744.      448B    11.8 
#>  8 fansi_vec_plain  35.88µs  38.65µs    25282.    5.02KB    10.1 
#>  9 cli_txt_ansi      5.48µs   6.16µs   156993.        0B    15.7 
#> 10 fansi_txt_ansi   27.37µs   30.5µs    32027.      688B    16.0 
#> 11 cli_txt_plain     6.52µs   7.17µs   135267.        0B    13.5 
#> 12 fansi_txt_plain  35.82µs  39.05µs    24966.    5.02KB     9.99
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
#> 1 cli          56.5µs   58.6µs    16615.    22.7KB     6.13
#> 2 fansi       110.7µs    116µs     8426.    55.3KB     4.07
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
#>  1 cli_ansi          6.58µs   7.42µs   130343.        0B    13.0 
#>  2 fansi_ansi       72.28µs  78.47µs    12433.   38.84KB    10.3 
#>  3 base_ansi       901.05ns      1µs   906273.        0B    90.6 
#>  4 cli_plain         6.56µs   7.33µs   131905.        0B    13.2 
#>  5 fansi_plain      71.87µs   77.9µs    12508.      688B    10.3 
#>  6 base_plain      820.96ns 911.88ns   997313.        0B     0   
#>  7 cli_vec_ansi     28.93µs  30.04µs    32650.      448B     3.27
#>  8 fansi_vec_ansi   92.48µs  99.23µs     9747.    5.02KB     8.29
#>  9 base_vec_ansi    18.92µs  19.02µs    51788.      448B     0   
#> 10 cli_vec_plain    25.75µs  27.54µs    35609.      448B     3.56
#> 11 fansi_vec_plain  83.02µs  89.77µs    10876.    5.02KB    10.5 
#> 12 base_vec_plain   10.97µs   11.1µs    88533.      448B     0   
#> 13 cli_txt_ansi     28.11µs  29.63µs    33174.        0B     3.32
#> 14 fansi_txt_ansi   84.84µs  91.69µs    10649.      688B     8.33
#> 15 base_txt_ansi    18.86µs  18.98µs    51911.        0B     5.19
#> 16 cli_txt_plain    25.11µs  26.85µs    36605.        0B     3.66
#> 17 fansi_txt_plain  74.01µs  80.37µs    12150.      688B    10.4 
#> 18 base_txt_plain   10.91µs  11.04µs    89142.        0B     0
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
#>  1 cli_ansi          8.06µs   8.97µs   108104.        0B    10.8 
#>  2 fansi_ansi       73.03µs  79.21µs    12277.      688B    12.5 
#>  3 base_ansi          1.2µs   1.31µs   719402.        0B     0   
#>  4 cli_plain         7.95µs   8.86µs   109244.        0B    10.9 
#>  5 fansi_plain      72.38µs  78.38µs    12442.      688B    10.3 
#>  6 base_plain      981.03ns    1.1µs   836733.        0B     0   
#>  7 cli_vec_ansi     33.82µs   35.3µs    27857.      448B     5.57
#>  8 fansi_vec_ansi   96.79µs 103.29µs     9446.    5.02KB     8.28
#>  9 base_vec_ansi    41.14µs  41.79µs    23591.      448B     0   
#> 10 cli_vec_plain    32.05µs  33.24µs    29598.      448B     2.96
#> 11 fansi_vec_plain  85.48µs  92.48µs    10540.    5.02KB    10.5 
#> 12 base_vec_plain   21.69µs   22.3µs    44145.      448B     0   
#> 13 cli_txt_ansi     34.49µs  35.59µs    27591.        0B     2.76
#> 14 fansi_txt_ansi   87.12µs  94.64µs    10291.      688B     8.22
#> 15 base_txt_ansi    43.22µs  44.05µs    22392.        0B     2.24
#> 16 cli_txt_plain       32µs  33.06µs    29743.        0B     2.97
#> 17 fansi_txt_plain  78.22µs  84.78µs    11491.      688B    10.5 
#> 18 base_txt_plain   23.02µs  23.26µs    42403.        0B     0
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
#> 1 cli_ansi        6.54µs   7.21µs   133946.        0B    13.4 
#> 2 cli_plain       6.08µs   6.83µs   141712.        0B    14.2 
#> 3 cli_vec_ansi   31.04µs   32.1µs    30629.      848B     3.06
#> 4 cli_vec_plain  10.18µs  11.01µs    88611.      848B     8.86
#> 5 cli_txt_ansi   29.93µs  31.43µs    31276.        0B     3.13
#> 6 cli_txt_plain   7.09µs   7.79µs   124852.        0B     0
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
#>  1 cli_ansi          24.1µs   26.3µs    37157.        0B    14.9 
#>  2 fansi_ansi        25.7µs   28.2µs    34490.    7.24KB    13.8 
#>  3 cli_plain         24.1µs   26.4µs    37022.        0B    14.8 
#>  4 fansi_plain       24.7µs   26.5µs    36687.      688B    18.4 
#>  5 cli_vec_ansi      33.5µs   35.9µs    27342.      848B    10.9 
#>  6 fansi_vec_ansi      51µs   53.7µs    18297.    5.41KB     8.39
#>  7 cli_vec_plain     26.7µs   28.3µs    34546.      848B    13.8 
#>  8 fansi_vec_plain   34.5µs   36.6µs    26603.    4.59KB    10.6 
#>  9 cli_txt_ansi      32.8µs   35.4µs    27505.        0B    11.0 
#> 10 fansi_txt_ansi    41.7µs   44.8µs    20719.    5.12KB     8.29
#> 11 cli_txt_plain     24.9µs     27µs    36129.        0B    18.1 
#> 12 fansi_txt_plain   26.8µs     29µs    33678.      688B    13.5
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
#>  1 cli_ansi        133.32µs 143.23µs     6786.  104.86KB    12.6 
#>  2 fansi_ansi      109.19µs 119.23µs     8213.  106.35KB    12.6 
#>  3 base_ansi         3.99µs   4.49µs   216954.      224B     0   
#>  4 cli_plain       132.82µs 142.58µs     6809.    8.09KB    12.6 
#>  5 fansi_plain     107.35µs 118.12µs     8303.    9.62KB    12.6 
#>  6 base_plain        3.56µs   3.95µs   245631.        0B     0   
#>  7 cli_vec_ansi      6.62ms   6.88ms      145.  823.77KB    13.8 
#>  8 fansi_vec_ansi    1.01ms   1.06ms      911.  846.81KB    17.6 
#>  9 base_vec_ansi    155.1µs 160.88µs     6076.    22.7KB     2.04
#> 10 cli_vec_plain     6.52ms   6.71ms      149.  823.77KB    13.7 
#> 11 fansi_vec_plain 978.88µs   1.02ms      966.  845.98KB    20.2 
#> 12 base_vec_plain   106.2µs    112µs     8711.      848B     2.02
#> 13 cli_txt_ansi      3.25ms   3.29ms      303.    63.6KB     0   
#> 14 fansi_txt_ansi    1.61ms   1.64ms      607.   35.05KB     2.02
#> 15 base_txt_ansi   141.45µs 150.19µs     6643.   18.47KB     2.02
#> 16 cli_txt_plain     2.38ms   2.42ms      411.    63.6KB     0   
#> 17 fansi_txt_plain 533.77µs 573.55µs     1737.    30.6KB     2.02
#> 18 base_txt_plain   91.81µs  94.72µs    10362.   11.05KB     2.02
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
#>  1 cli_ansi        128.01µs 135.83µs     7165.   33.84KB    14.7 
#>  2 fansi_ansi       49.05µs  53.55µs    18271.   31.42KB    12.9 
#>  3 base_ansi         1.06µs   1.15µs   803803.     4.2KB     0   
#>  4 cli_plain        128.3µs 136.25µs     7189.        0B    14.7 
#>  5 fansi_plain       48.8µs  53.58µs    18242.      872B    12.5 
#>  6 base_plain      962.06ns   1.07µs   861042.        0B     0   
#>  7 cli_vec_ansi    250.11µs 261.38µs     3778.   16.73KB     7.52
#>  8 fansi_vec_ansi  111.06µs 114.98µs     8541.    5.59KB     8.30
#>  9 base_vec_ansi    36.16µs   36.5µs    26965.      848B     0   
#> 10 cli_vec_plain   209.75µs 220.81µs     4254.   16.73KB     8.35
#> 11 fansi_vec_plain 103.37µs 106.77µs     9206.    5.59KB     6.17
#> 12 base_vec_plain   30.11µs  30.55µs    32277.      848B     3.23
#> 13 cli_txt_ansi    133.64µs 139.29µs     7044.        0B    12.5 
#> 14 fansi_txt_ansi   47.52µs  51.18µs    19164.      872B    14.8 
#> 15 base_txt_ansi     1.08µs   1.19µs   801233.        0B     0   
#> 16 cli_txt_plain   128.75µs 136.25µs     7218.        0B    14.6 
#> 17 fansi_txt_plain  48.48µs  52.85µs    18601.      872B    12.5 
#> 18 base_txt_plain       1µs    1.1µs   846563.        0B     0
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
#>  1 cli_ansi        349.46µs 375.29µs    2528.     6.18KB    12.5 
#>  2 fansi_ansi       85.36µs  93.07µs   10479.    97.33KB    12.5 
#>  3 base_ansi        31.76µs  34.01µs   28637.         0B    11.5 
#>  4 cli_plain       218.25µs  232.8µs    4208.         0B    12.7 
#>  5 fansi_plain      86.17µs  93.84µs   10408.       872B    12.5 
#>  6 base_plain       26.26µs  28.03µs   34755.         0B    13.9 
#>  7 cli_vec_ansi     37.46ms  37.59ms      26.6   94.67KB    22.8 
#>  8 fansi_vec_ansi   233.1µs  244.1µs    4051.     7.25KB     6.15
#>  9 base_vec_ansi      2.2ms   2.25ms     442.    48.18KB    15.2 
#> 10 cli_vec_plain    23.01ms   23.3ms      42.8    2.48KB    17.1 
#> 11 fansi_vec_plain 184.55µs 193.92µs    5073.     6.42KB     8.26
#> 12 base_vec_plain    1.57ms   1.65ms     602.     47.4KB    13.0 
#> 13 cli_txt_ansi     27.36ms  27.54ms      36.3    4.27MB     4.54
#> 14 fansi_txt_ansi  225.64µs 235.82µs    4189.     6.77KB     6.15
#> 15 base_txt_ansi     1.27ms   1.31ms     756.   582.06KB     8.82
#> 16 cli_txt_plain     1.26ms    1.3ms     758.   369.84KB    11.2 
#> 17 fansi_txt_plain  173.5µs 183.09µs    5382.     2.51KB     6.14
#> 18 base_txt_plain  840.64µs 892.18µs    1104.   367.31KB    10.9
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
#>  1 cli_ansi          6.45µs   7.09µs   137329.   25.09KB    13.7 
#>  2 fansi_ansi       69.46µs  73.03µs    13358.   28.48KB    12.6 
#>  3 base_ansi         1.03µs   1.15µs   808851.        0B     0   
#>  4 cli_plain         6.45µs   7.08µs   137035.        0B    27.4 
#>  5 fansi_plain      68.14µs  71.88µs    13580.    1.98KB    12.6 
#>  6 base_plain      981.03ns   1.09µs   868028.        0B     0   
#>  7 cli_vec_ansi     26.91µs  28.19µs    34916.     1.7KB     3.49
#>  8 fansi_vec_ansi   104.4µs 110.15µs     8890.    8.86KB     8.49
#>  9 base_vec_ansi     6.22µs    6.5µs   148642.      848B     0   
#> 10 cli_vec_plain    23.11µs  24.31µs    40339.     1.7KB     8.07
#> 11 fansi_vec_plain 100.89µs 107.72µs     9099.    8.86KB     8.38
#> 12 base_vec_plain    5.77µs    6.3µs   156441.      848B     0   
#> 13 cli_txt_ansi      6.49µs   7.32µs   132035.        0B    13.2 
#> 14 fansi_txt_ansi   69.75µs  76.66µs    12724.    1.98KB    12.6 
#> 15 base_txt_ansi     7.05µs   7.19µs   135624.        0B     0   
#> 16 cli_txt_plain     7.39µs   8.22µs   117470.        0B    11.7 
#> 17 fansi_txt_plain  70.26µs  76.33µs    12860.    1.98KB    12.6 
#> 18 base_txt_plain     4.4µs   4.52µs   214122.        0B    21.4
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
#>  1 cli_ansi        86.85µs  92.39µs   10514.    11.88KB    10.4 
#>  2 base_ansi        1.28µs   1.37µs  693588.         0B     0   
#>  3 cli_plain       67.51µs  71.82µs   13505.     8.73KB    10.4 
#>  4 base_plain     991.04ns   1.08µs  867193.         0B     0   
#>  5 cli_vec_ansi     4.12ms   4.29ms     233.   838.77KB    15.7 
#>  6 base_vec_ansi   70.17µs  71.83µs   13747.       848B     0   
#>  7 cli_vec_plain     2.3ms   2.38ms     413.    816.9KB    13.2 
#>  8 base_vec_plain  41.85µs   43.9µs   21003.       848B     0   
#>  9 cli_txt_ansi    15.43ms  15.56ms      64.2  114.42KB     4.28
#> 10 base_txt_ansi    68.4µs     70µs   14093.         0B     0   
#> 11 cli_txt_plain  264.03µs 275.22µs    3565.    18.16KB     2.01
#> 12 base_txt_plain  40.39µs  41.16µs   23989.         0B     0
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
#>  1 cli_ansi         87.6µs   93.8µs    10463.        0B    14.6 
#>  2 base_ansi          15µs   16.3µs    59953.        0B    12.0 
#>  3 cli_plain        88.9µs   94.2µs    10388.        0B    14.7 
#>  4 base_plain       15.3µs   16.5µs    57472.        0B    11.5 
#>  5 cli_vec_ansi    191.4µs  202.2µs     4860.     7.2KB     6.17
#>  6 base_vec_ansi    54.5µs   61.3µs    16138.    1.66KB     4.07
#>  7 cli_vec_plain   176.2µs  186.4µs     5276.     7.2KB     6.16
#>  8 base_vec_plain   48.4µs   54.6µs    18133.    1.66KB     4.07
#>  9 cli_txt_ansi    169.7µs  176.4µs     5574.        0B     8.22
#> 10 base_txt_ansi    41.3µs     43µs    22876.        0B     4.58
#> 11 cli_txt_plain     152µs  160.2µs     6140.        0B     8.33
#> 12 base_txt_plain   34.4µs     36µs    27295.        0B     5.46
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
#> 1 cli           7.8µs   8.57µs   112940.        0B    11.3 
#> 2 base          851ns 962.06ns   944866.        0B     0   
#> 3 cli_vec      23.3µs  24.48µs    40025.      448B     4.00
#> 4 base_vec     12.2µs  12.52µs    72284.      448B     0   
#> 5 cli_txt      23.3µs  24.87µs    37373.        0B     7.48
#> 6 base_txt     13.4µs  14.06µs    64396.        0B     0
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
#> 1 cli          7.76µs   8.73µs   110334.        0B    11.0 
#> 2 base         1.31µs   1.44µs   638992.        0B     0   
#> 3 cli_vec     29.61µs  31.12µs    31517.      448B     3.15
#> 4 base_vec    54.35µs  55.25µs    17877.      448B     2.02
#> 5 cli_txt      29.7µs  30.84µs    31879.        0B     3.19
#> 6 base_txt     90.4µs  91.42µs    10814.        0B     0
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
#> 1 cli          8.24µs   9.24µs   104899.        0B    10.5 
#> 2 base        841.1ns 961.12ns   937657.        0B    93.8 
#> 3 cli_vec     20.01µs  21.06µs    46543.      448B     4.65
#> 4 base_vec    12.25µs  12.59µs    78111.      448B     0   
#> 5 cli_txt     21.17µs   22.4µs    43812.        0B     4.38
#> 6 base_txt    13.41µs  13.91µs    70820.        0B     7.08
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
#> 1 cli          6.19µs   7.01µs   137228.    22.2KB    13.7 
#> 2 base         1.02µs   1.16µs   804723.        0B     0   
#> 3 cli_vec      30.8µs  32.06µs    30697.     1.7KB     3.07
#> 4 base_vec     8.65µs   8.93µs   109256.      848B    10.9 
#> 5 cli_txt      6.06µs    6.7µs   145609.        0B    14.6 
#> 6 base_txt     5.53µs   5.94µs   165753.        0B     0
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
