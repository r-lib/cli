# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55f6831958b8\>
\<environment: 0x55f683ce6488\>

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
#> 1 ansi         37.8µs   41.2µs    23774.    99.3KB     23.8
#> 2 plain        37.8µs   41.3µs    23683.        0B     23.7
#> 3 base         10.8µs   12.1µs    80684.    48.4KB     24.2
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
#> 1 ansi           40µs   43.7µs    22358.        0B     26.9
#> 2 plain        39.3µs   43.3µs    22575.        0B     24.9
#> 3 base         12.4µs   13.8µs    70594.        0B     21.2
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
#> 1 ansi        92.95µs  99.73µs     9786.   75.07KB     16.8
#> 2 plain       71.05µs  76.33µs    12745.    8.73KB     19.0
#> 3 base         1.82µs   2.02µs   476778.        0B      0
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
#> 1 ansi          275µs    295µs     3354.   33.17KB     23.6
#> 2 plain         271µs    295µs     3360.    1.09KB     23.6
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
#>  1 cli_ansi          5.54µs   6.22µs   155206.     9.2KB     31.0
#>  2 fansi_ansi        26.1µs  28.56µs    34130.    4.18KB     27.3
#>  3 cli_plain         5.47µs   5.91µs   164743.        0B     33.0
#>  4 fansi_plain      26.25µs  27.77µs    35179.      688B     28.2
#>  5 cli_vec_ansi      6.85µs   7.32µs   133505.      448B     26.7
#>  6 fansi_vec_ansi      35µs  37.02µs    26397.    5.02KB     21.1
#>  7 cli_vec_plain     7.46µs   8.03µs   121476.      448B     24.3
#>  8 fansi_vec_plain  34.33µs  36.58µs    26714.    5.02KB     21.4
#>  9 cli_txt_ansi      5.49µs      6µs   161583.        0B     32.3
#> 10 fansi_txt_ansi   26.67µs  28.44µs    34285.      688B     27.4
#> 11 cli_txt_plain     6.39µs      7µs   138422.        0B     27.7
#> 12 fansi_txt_plain  34.27µs  36.74µs    26481.    5.02KB     21.2
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
#> 1 cli          55.8µs     58µs    16953.    22.7KB     8.17
#> 2 fansi       110.4µs    114µs     8646.    55.3KB    10.4
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
#>  1 cli_ansi          6.35µs   7.07µs   136633.        0B    27.3 
#>  2 fansi_ansi       71.14µs  75.93µs    12806.   38.83KB    21.2 
#>  3 base_ansi       831.09ns 922.13ns  1009575.        0B     0   
#>  4 cli_plain          6.4µs   7.05µs   137792.        0B    27.6 
#>  5 fansi_plain      71.08µs  75.83µs    12851.      688B    21.3 
#>  6 base_plain      781.03ns 861.12ns  1077751.        0B     0   
#>  7 cli_vec_ansi     27.27µs  28.69µs    34231.      448B     6.85
#>  8 fansi_vec_ansi   91.12µs  96.58µs    10081.    5.02KB    16.9 
#>  9 base_vec_ansi    14.62µs  14.75µs    66409.      448B     0   
#> 10 cli_vec_plain    25.28µs  26.22µs    35798.      448B     7.16
#> 11 fansi_vec_plain  81.46µs  86.96µs    11154.    5.02KB    17.1 
#> 12 base_vec_plain    8.68µs   8.78µs   111220.      448B     0   
#> 13 cli_txt_ansi     27.65µs  28.59µs    34409.        0B     3.44
#> 14 fansi_txt_ansi   83.94µs  88.58µs    11007.      688B    18.9 
#> 15 base_txt_ansi    14.45µs  14.55µs    67632.        0B     0   
#> 16 cli_txt_plain    24.85µs  25.57µs    38464.        0B     7.69
#> 17 fansi_txt_plain  73.13µs  77.57µs    12573.      688B    19.9 
#> 18 base_txt_plain    8.49µs   8.58µs   114384.        0B    11.4
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
#>  1 cli_ansi          7.87µs   8.47µs   115482.        0B    23.1 
#>  2 fansi_ansi       70.88µs  74.26µs    13072.      688B    21.1 
#>  3 base_ansi         1.18µs   1.27µs   743425.        0B    74.3 
#>  4 cli_plain         7.83µs   8.39µs   116285.        0B    23.3 
#>  5 fansi_plain      70.56µs     75µs    12951.      688B    21.2 
#>  6 base_plain         951ns   1.06µs   873411.        0B     0   
#>  7 cli_vec_ansi     33.82µs   34.7µs    28373.      448B     8.51
#>  8 fansi_vec_ansi   94.39µs  99.18µs     9837.    5.02KB    14.7 
#>  9 base_vec_ansi    41.59µs  42.04µs    23471.      448B     2.35
#> 10 cli_vec_plain    31.92µs  32.82µs    30011.      448B     6.00
#> 11 fansi_vec_plain  84.19µs  89.17µs    10281.    5.02KB    16.9 
#> 12 base_vec_plain   21.93µs  22.17µs    44263.      448B     0   
#> 13 cli_txt_ansi     34.47µs  35.37µs    27827.        0B     8.35
#> 14 fansi_txt_ansi   87.34µs  92.19µs    10604.      688B    16.8 
#> 15 base_txt_ansi     43.4µs  43.69µs    22611.        0B     0   
#> 16 cli_txt_plain    31.84µs  32.74µs    30074.        0B     6.02
#> 17 fansi_txt_plain  76.85µs  81.75µs    11802.      688B    21.3 
#> 18 base_txt_plain   23.11µs  23.27µs    42350.        0B     0
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
#> 1 cli_ansi        6.43µs   6.97µs   139627.        0B    27.9 
#> 2 cli_plain       6.03µs   6.58µs   147552.        0B    14.8 
#> 3 cli_vec_ansi   31.22µs  32.19µs    30621.      848B     6.13
#> 4 cli_vec_plain  10.09µs  10.72µs    91354.      848B    18.3 
#> 5 cli_txt_ansi   30.27µs  31.29µs    31514.        0B     3.15
#> 6 cli_txt_plain   6.92µs    7.5µs   129809.        0B    26.0
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
#>  1 cli_ansi          24.2µs   25.9µs    37590.        0B     30.1
#>  2 fansi_ansi        24.7µs   26.7µs    36407.    7.24KB     29.1
#>  3 cli_plain         24.1µs   25.7µs    37749.        0B     30.2
#>  4 fansi_plain       24.7µs   26.6µs    36629.      688B     29.3
#>  5 cli_vec_ansi      33.8µs   35.9µs    27206.      848B     21.8
#>  6 fansi_vec_ansi      50µs   52.6µs    18520.    5.41KB     15.2
#>  7 cli_vec_plain     26.6µs     28µs    34770.      848B     27.8
#>  8 fansi_vec_plain   33.3µs   35.1µs    26273.    4.59KB     18.4
#>  9 cli_txt_ansi      32.9µs   34.8µs    28021.        0B     22.4
#> 10 fansi_txt_ansi      41µs   43.1µs    22740.    5.12KB     18.2
#> 11 cli_txt_plain     24.5µs   26.3µs    37052.        0B     29.7
#> 12 fansi_txt_plain   25.9µs   27.6µs    35316.      688B     28.3
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
#>  1 cli_ansi        129.74µs 139.12µs     7007.  104.34KB    23.4 
#>  2 fansi_ansi      104.78µs 112.89µs     8661.  106.35KB    23.9 
#>  3 base_ansi         3.93µs   4.29µs   227921.      224B     0   
#>  4 cli_plain       129.12µs 137.89µs     6966.    8.09KB    23.5 
#>  5 fansi_plain     102.89µs 110.77µs     8795.    9.62KB    25.9 
#>  6 base_plain        3.62µs   3.89µs   248818.        0B     0   
#>  7 cli_vec_ansi       6.4ms   6.58ms      151.  823.77KB    30.8 
#>  8 fansi_vec_ansi    1.02ms   1.06ms      911.  846.81KB    19.8 
#>  9 base_vec_ansi   152.05µs 158.23µs     6164.    22.7KB     2.04
#> 10 cli_vec_plain     6.43ms    6.6ms      150.  823.77KB    31.4 
#> 11 fansi_vec_plain 955.87µs   1.01ms      984.  845.98KB    19.9 
#> 12 base_vec_plain  102.77µs 108.85µs     9036.      848B     4.06
#> 13 cli_txt_ansi      3.25ms    3.3ms      302.    63.6KB     0   
#> 14 fansi_txt_ansi     1.6ms   1.63ms      612.   35.05KB     2.02
#> 15 base_txt_ansi   138.43µs 151.85µs     6518.   18.47KB     2.03
#> 16 cli_txt_plain     2.35ms   2.39ms      417.    63.6KB     0   
#> 17 fansi_txt_plain 524.18µs 558.24µs     1793.    30.6KB     6.18
#> 18 base_txt_plain   89.94µs  92.75µs    10533.   11.05KB     2.02
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
#>  1 cli_ansi        125.51µs 134.59µs     7253.   33.84KB     26.3
#>  2 fansi_ansi       47.89µs  51.59µs    18874.   31.42KB     25.9
#>  3 base_ansi         1.06µs   1.15µs   805176.     4.2KB      0  
#>  4 cli_plain        125.4µs  132.6µs     7376.        0B     25.7
#>  5 fansi_plain      47.48µs  51.49µs    18934.      872B     26.0
#>  6 base_plain      981.03ns   1.07µs   861768.        0B      0  
#>  7 cli_vec_ansi    248.77µs 259.74µs     3783.   16.73KB     14.8
#>  8 fansi_vec_ansi   112.4µs 116.84µs     8358.    5.59KB     12.6
#>  9 base_vec_ansi     36.3µs  36.73µs    26854.      848B      0  
#> 10 cli_vec_plain   209.95µs 218.82µs     4490.   16.73KB     17.1
#> 11 fansi_vec_plain 102.75µs 107.55µs     9111.    5.59KB     14.8
#> 12 base_vec_plain   30.25µs   30.6µs    32248.      848B      0  
#> 13 cli_txt_ansi    135.48µs 142.37µs     6872.        0B     25.8
#> 14 fansi_txt_ansi   47.54µs   51.1µs    19062.      872B     25.9
#> 15 base_txt_ansi     1.09µs   1.18µs   804171.        0B      0  
#> 16 cli_txt_plain   125.11µs 132.54µs     7414.        0B     28.6
#> 17 fansi_txt_plain  47.08µs  49.73µs    19661.      872B     25.9
#> 18 base_txt_plain  992.09ns   1.08µs   882375.        0B      0
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
#>  1 cli_ansi        331.08µs 352.73µs    2800.         0B    26.0 
#>  2 fansi_ansi       85.98µs  91.78µs   10567.    97.32KB    23.7 
#>  3 base_ansi        32.37µs  34.55µs   27772.         0B    25.0 
#>  4 cli_plain       218.16µs 233.04µs    4155.         0B    23.6 
#>  5 fansi_plain      85.47µs  92.13µs   10504.       872B    23.6 
#>  6 base_plain       26.28µs   28.1µs   34220.         0B    24.0 
#>  7 cli_vec_ansi     35.49ms  35.54ms      28.1    2.48KB   155.  
#>  8 fansi_vec_ansi  231.21µs 241.15µs    4061.     7.25KB    12.5 
#>  9 base_vec_ansi     2.19ms   2.27ms     436.    48.18KB    25.4 
#> 10 cli_vec_plain     23.1ms  23.19ms      42.8    2.48KB    52.3 
#> 11 fansi_vec_plain 184.36µs 193.09µs    5066.     6.42KB    12.6 
#> 12 base_vec_plain    1.57ms   1.65ms     605.     47.4KB    12.7 
#> 13 cli_txt_ansi     23.33ms  23.68ms      42.3  507.59KB     7.04
#> 14 fansi_txt_ansi  223.69µs 232.55µs    4258.     6.77KB     4.06
#> 15 base_txt_ansi     1.27ms   1.31ms     756.   582.06KB    11.4 
#> 16 cli_txt_plain     1.26ms    1.3ms     761.   369.84KB     8.73
#> 17 fansi_txt_plain 173.28µs 181.29µs    5440.     2.51KB     8.29
#> 18 base_txt_plain  865.87µs 897.91µs    1100.   367.31KB     8.77
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
#>  1 cli_ansi          6.51µs   7.24µs   132115.   24.83KB    26.4 
#>  2 fansi_ansi       69.22µs  74.86µs    13083.   28.48KB    12.6 
#>  3 base_ansi        970.9ns   1.07µs   859759.        0B     0   
#>  4 cli_plain         6.49µs   7.28µs   133140.        0B    13.3 
#>  5 fansi_plain      68.61µs  74.68µs    13055.    1.98KB    12.7 
#>  6 base_plain         951ns   1.05µs   861396.        0B     0   
#>  7 cli_vec_ansi     26.25µs  27.48µs    35694.     1.7KB     7.14
#>  8 fansi_vec_ansi  104.05µs  109.9µs     8904.    8.86KB     8.38
#>  9 base_vec_ansi     6.04µs   6.51µs   151627.      848B     0   
#> 10 cli_vec_plain    23.14µs  24.32µs    39935.     1.7KB     3.99
#> 11 fansi_vec_plain  98.46µs 104.42µs     9378.    8.86KB    10.6 
#> 12 base_vec_plain    5.78µs   6.17µs   160721.      848B     0   
#> 13 cli_txt_ansi      6.58µs   7.34µs   131993.        0B    13.2 
#> 14 fansi_txt_ansi    69.2µs  74.49µs    13139.    1.98KB    12.6 
#> 15 base_txt_ansi     5.53µs   5.67µs   172162.        0B     0   
#> 16 cli_txt_plain     7.43µs   8.25µs   116561.        0B    23.3 
#> 17 fansi_txt_plain  69.08µs  74.17µs    13178.    1.98KB    12.6 
#> 18 base_txt_plain    3.54µs   3.67µs   264812.        0B     0
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
#>  1 cli_ansi        86.08µs  92.62µs   10524.    11.88KB    10.4 
#>  2 base_ansi        1.24µs   1.33µs  727306.         0B     0   
#>  3 cli_plain       67.68µs  72.78µs   13178.     8.73KB    10.4 
#>  4 base_plain     951.11ns   1.03µs  928171.         0B     0   
#>  5 cli_vec_ansi     3.98ms   4.17ms     239.   838.77KB    13.3 
#>  6 base_vec_ansi   71.45µs  72.91µs   13525.       848B     0   
#>  7 cli_vec_plain    2.26ms   2.35ms     423.    816.9KB    15.2 
#>  8 base_vec_plain  42.43µs   43.2µs   22832.       848B     0   
#>  9 cli_txt_ansi    13.82ms   13.9ms      71.9  114.42KB     4.23
#> 10 base_txt_ansi   70.82µs  71.23µs   13843.         0B     0   
#> 11 cli_txt_plain  243.07µs 252.43µs    3908.    18.16KB     4.06
#> 12 base_txt_plain  40.61µs  40.88µs   24152.         0B     0
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
#>  1 cli_ansi           89µs   94.6µs    10379.        0B    16.4 
#>  2 base_ansi        15.1µs     16µs    61068.        0B    12.2 
#>  3 cli_plain          87µs   90.9µs    10767.        0B    14.5 
#>  4 base_plain       15.2µs     16µs    61020.        0B    12.2 
#>  5 cli_vec_ansi    174.7µs    185µs     5318.     7.2KB     8.26
#>  6 base_vec_ansi    51.6µs   57.7µs    17169.    1.66KB     2.02
#>  7 cli_vec_plain   161.7µs  170.7µs     5765.     7.2KB     8.27
#>  8 base_vec_plain   46.8µs   53.1µs    18589.    1.66KB     4.11
#>  9 cli_txt_ansi    155.1µs  161.4µs     6092.        0B    10.3 
#> 10 base_txt_ansi    38.3µs   40.4µs    24429.        0B     4.89
#> 11 cli_txt_plain     140µs  145.9µs     6754.        0B     8.18
#> 12 base_txt_plain   33.2µs   35.8µs    27532.        0B     5.51
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
#> 1 cli          7.71µs   8.48µs   114832.        0B    11.5 
#> 2 base       821.08ns 922.01ns   999296.        0B     0   
#> 3 cli_vec     23.07µs  24.07µs    40847.      448B     4.09
#> 4 base_vec    12.11µs  12.47µs    78700.      448B     0   
#> 5 cli_txt     22.99µs  23.92µs    40948.        0B     8.19
#> 6 base_txt    12.93µs  13.06µs    75402.        0B     0
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
#> 1 cli          7.69µs    8.5µs   112013.        0B    11.2 
#> 2 base         1.28µs    1.4µs   669660.        0B     0   
#> 3 cli_vec     30.09µs   31.4µs    31345.      448B     6.27
#> 4 base_vec    54.43µs   55.1µs    17902.      448B     0   
#> 5 cli_txt     30.27µs   31.9µs    30913.        0B     3.09
#> 6 base_txt    88.91µs   89.6µs    11029.        0B     0
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
#> 1 cli          8.37µs   9.27µs   104803.        0B    10.5 
#> 2 base       831.09ns 940.99ns   970633.        0B    97.1 
#> 3 cli_vec     20.03µs  21.17µs    46360.      448B     4.64
#> 4 base_vec    12.14µs  12.46µs    79121.      448B     0   
#> 5 cli_txt      20.4µs  21.41µs    45824.        0B     9.17
#> 6 base_txt    12.93µs  13.08µs    74627.        0B     0
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
#> 1 cli          6.23µs   6.97µs   139043.    22.1KB    13.9 
#> 2 base       982.08ns   1.11µs   828229.        0B     0   
#> 3 cli_vec     30.63µs  31.82µs    30834.     1.7KB     6.17
#> 4 base_vec     8.68µs   8.93µs   110177.      848B     0   
#> 5 cli_txt      6.21µs   6.91µs   139836.        0B    14.0 
#> 6 base_txt     5.05µs   5.19µs   186793.        0B     0
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
