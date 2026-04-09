# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x56091f502a18\>
\<environment: 0x560920055338\>

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
#> 1 ansi         37.8µs   41.9µs    23080.    99.3KB     23.1
#> 2 plain        38.5µs   41.8µs    23340.        0B     23.4
#> 3 base         10.9µs   12.2µs    79306.    48.4KB     23.8
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
#> 1 ansi         39.7µs   43.9µs    22274.        0B     26.8
#> 2 plain        39.9µs     44µs    22162.        0B     24.4
#> 3 base         12.6µs   14.2µs    68545.        0B     20.6
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
#> 1 ansi        92.87µs 100.84µs     9638.   75.07KB     16.9
#> 2 plain       72.03µs  77.69µs    12523.    8.73KB     16.9
#> 3 base         1.82µs   2.07µs   462662.        0B     46.3
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
#> 1 ansi          277µs    302µs     3256.   33.17KB     21.5
#> 2 plain         281µs    303µs     3281.    1.09KB     23.7
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
#>  1 cli_ansi          5.53µs   6.31µs   149846.     9.2KB     30.0
#>  2 fansi_ansi        26.4µs  29.61µs    32950.    4.18KB     26.4
#>  3 cli_plain         5.57µs      6µs   162125.        0B     32.4
#>  4 fansi_plain      26.44µs   28.2µs    34611.      688B     27.7
#>  5 cli_vec_ansi      6.93µs   7.46µs   131019.      448B     26.2
#>  6 fansi_vec_ansi   35.38µs  37.58µs    25984.    5.02KB     20.8
#>  7 cli_vec_plain      7.6µs   8.23µs   118311.      448B     23.7
#>  8 fansi_vec_plain  34.56µs  36.88µs    26494.    5.02KB     21.2
#>  9 cli_txt_ansi      5.56µs   6.07µs   160164.        0B     32.0
#> 10 fansi_txt_ansi   26.55µs  28.57µs    34129.      688B     27.3
#> 11 cli_txt_plain      6.5µs   7.03µs   138251.        0B     27.7
#> 12 fansi_txt_plain  34.29µs  36.94µs    26462.    5.02KB     21.2
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
#> 1 cli          56.3µs   58.2µs    16900.    22.7KB     8.18
#> 2 fansi       110.3µs  113.4µs     8675.    55.3KB    10.3
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
#>  1 cli_ansi          6.41µs   7.02µs   137071.        0B    27.4 
#>  2 fansi_ansi       71.87µs  76.67µs    12643.   38.83KB    21.3 
#>  3 base_ansi       851.11ns 942.03ns  1000569.        0B     0   
#>  4 cli_plain         6.41µs   7.04µs   137868.        0B    27.6 
#>  5 fansi_plain       72.2µs  76.59µs    12594.      688B    19.1 
#>  6 base_plain      771.02ns 872.07ns  1019955.        0B   102.  
#>  7 cli_vec_ansi     28.34µs  29.66µs    33204.      448B     3.32
#>  8 fansi_vec_ansi    92.7µs  98.13µs     9878.    5.02KB    17.0 
#>  9 base_vec_ansi    14.65µs  14.79µs    66332.      448B     0   
#> 10 cli_vec_plain    25.77µs  27.29µs    35968.      448B     7.20
#> 11 fansi_vec_plain  82.67µs  87.39µs    11084.    5.02KB    19.3 
#> 12 base_vec_plain     8.7µs   8.84µs   110807.      448B     0   
#> 13 cli_txt_ansi     28.01µs  29.32µs    32878.        0B     6.58
#> 14 fansi_txt_ansi   84.99µs  90.11µs    10733.      688B    16.8 
#> 15 base_txt_ansi    14.43µs  14.56µs    67533.        0B     0   
#> 16 cli_txt_plain    25.85µs  26.65µs    36832.        0B     7.37
#> 17 fansi_txt_plain  74.39µs  79.34µs    12210.      688B    20.4 
#> 18 base_txt_plain    8.48µs   8.58µs   114385.        0B     0
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
#>  1 cli_ansi          7.77µs   8.46µs   114756.        0B    23.0 
#>  2 fansi_ansi       71.19µs  75.67µs    12786.      688B    21.3 
#>  3 base_ansi          1.2µs   1.28µs   732278.        0B     0   
#>  4 cli_plain          7.9µs   8.56µs   113461.        0B    34.0 
#>  5 fansi_plain      71.95µs  76.08µs    12735.      688B    19.2 
#>  6 base_plain      981.03ns   1.06µs   849412.        0B    84.9 
#>  7 cli_vec_ansi     33.76µs  35.07µs    28018.      448B     5.60
#>  8 fansi_vec_ansi   94.96µs 100.53µs     9656.    5.02KB    14.8 
#>  9 base_vec_ansi    41.59µs   42.1µs    23378.      448B     2.34
#> 10 cli_vec_plain    32.04µs     33µs    29733.      448B     5.95
#> 11 fansi_vec_plain  84.49µs  89.82µs     9057.    5.02KB    14.9 
#> 12 base_vec_plain   21.92µs  22.25µs    37856.      448B     0   
#> 13 cli_txt_ansi     34.73µs  36.06µs    22632.        0B     6.79
#> 14 fansi_txt_ansi   88.81µs  95.09µs     9965.      688B    14.8 
#> 15 base_txt_ansi    43.56µs  44.01µs    22288.        0B     2.23
#> 16 cli_txt_plain    31.95µs  32.86µs    29852.        0B     5.97
#> 17 fansi_txt_plain  77.57µs  81.89µs    11833.      688B    19.1 
#> 18 base_txt_plain   23.14µs  23.29µs    42319.        0B     0
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
#> 1 cli_ansi         6.4µs   6.94µs   139756.        0B    14.0 
#> 2 cli_plain       5.98µs   6.48µs   149447.        0B    29.9 
#> 3 cli_vec_ansi   31.09µs  31.93µs    30733.      848B     6.15
#> 4 cli_vec_plain  10.06µs  10.69µs    91488.      848B     9.15
#> 5 cli_txt_ansi   30.07µs  31.27µs    31512.        0B     6.30
#> 6 cli_txt_plain   6.92µs   7.48µs   129670.        0B    25.9
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
#>  1 cli_ansi          24.2µs   25.7µs    37761.        0B     30.2
#>  2 fansi_ansi          25µs   26.7µs    36236.    7.24KB     29.0
#>  3 cli_plain         23.8µs   25.7µs    37451.        0B     30.0
#>  4 fansi_plain       24.5µs   26.5µs    36307.      688B     29.1
#>  5 cli_vec_ansi      33.8µs   35.9µs    27025.      848B     21.6
#>  6 fansi_vec_ansi    50.3µs   52.7µs    18516.    5.41KB     12.7
#>  7 cli_vec_plain     26.8µs   28.4µs    34337.      848B     27.5
#>  8 fansi_vec_plain   33.5µs   35.5µs    27501.    4.59KB     22.0
#>  9 cli_txt_ansi      33.3µs   34.9µs    27955.        0B     22.4
#> 10 fansi_txt_ansi    41.1µs   43.2µs    22671.    5.12KB     18.2
#> 11 cli_txt_plain     24.8µs   26.6µs    36651.        0B     29.3
#> 12 fansi_txt_plain   25.8µs   27.6µs    35353.      688B     24.8
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
#>  1 cli_ansi        131.01µs  139.5µs     6975.  104.34KB    23.6 
#>  2 fansi_ansi      104.88µs 112.69µs     8678.  106.35KB    24.0 
#>  3 base_ansi         3.99µs   4.46µs   218079.      224B     0   
#>  4 cli_plain       129.81µs 137.96µs     7026.    8.09KB    23.6 
#>  5 fansi_plain     105.06µs 112.08µs     8701.    9.62KB    23.8 
#>  6 base_plain        3.45µs   3.75µs   255382.        0B    25.5 
#>  7 cli_vec_ansi      6.66ms   6.83ms      146.  823.77KB    28.2 
#>  8 fansi_vec_ansi    1.03ms   1.08ms      887.  846.81KB    17.6 
#>  9 base_vec_ansi   151.94µs 159.69µs     6095.    22.7KB     4.14
#> 10 cli_vec_plain     6.63ms   6.82ms      143.  823.77KB    28.7 
#> 11 fansi_vec_plain 968.56µs   1.03ms      965.  845.98KB    19.1 
#> 12 base_vec_plain  103.33µs  107.6µs     9165.      848B     4.07
#> 13 cli_txt_ansi      3.18ms   3.29ms      303.    63.6KB     0   
#> 14 fansi_txt_ansi     1.6ms   1.62ms      613.   35.05KB     2.02
#> 15 base_txt_ansi   139.61µs 151.78µs     6505.   18.47KB     2.03
#> 16 cli_txt_plain     2.36ms    2.4ms      413.    63.6KB     0   
#> 17 fansi_txt_plain 527.65µs 560.37µs     1776.    30.6KB     6.19
#> 18 base_txt_plain   89.79µs  92.29µs    10458.   11.05KB     2.02
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
#>  1 cli_ansi        124.55µs 131.68µs     7420.   33.84KB     28.7
#>  2 fansi_ansi       47.56µs  50.94µs    19124.   31.42KB     26.0
#>  3 base_ansi         1.07µs   1.15µs   829813.     4.2KB      0  
#>  4 cli_plain        124.5µs 131.17µs     7463.        0B     28.2
#>  5 fansi_plain      46.49µs  50.61µs    19196.      872B     26.0
#>  6 base_plain      971.02ns   1.05µs   852044.        0B      0  
#>  7 cli_vec_ansi    247.68µs 257.96µs     3778.   16.73KB     12.6
#>  8 fansi_vec_ansi  112.11µs 116.71µs     8373.    5.59KB     14.8
#>  9 base_vec_ansi     36.3µs  36.61µs    26936.      848B      0  
#> 10 cli_vec_plain   209.17µs 219.54µs     4472.   16.73KB     17.2
#> 11 fansi_vec_plain 103.49µs 107.68µs     9100.    5.59KB     12.6
#> 12 base_vec_plain   29.96µs  30.49µs    32285.      848B      0  
#> 13 cli_txt_ansi    133.84µs 140.44µs     6983.        0B     25.9
#> 14 fansi_txt_ansi    47.2µs  50.83µs    19209.      872B     26.0
#> 15 base_txt_ansi     1.09µs   1.18µs   787126.        0B     78.7
#> 16 cli_txt_plain   125.28µs 132.59µs     7402.        0B     26.2
#> 17 fansi_txt_plain  46.93µs  49.69µs    19644.      872B     26.0
#> 18 base_txt_plain       1µs   1.08µs   876834.        0B      0
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
#>  1 cli_ansi        330.97µs  355.2µs    2756.         0B    23.8 
#>  2 fansi_ansi       85.62µs  91.82µs   10504.    97.32KB    23.6 
#>  3 base_ansi        32.57µs  34.79µs   27522.         0B    24.8 
#>  4 cli_plain       221.32µs 235.91µs    4093.         0B    23.6 
#>  5 fansi_plain      85.41µs  91.88µs   10471.       872B    23.7 
#>  6 base_plain       26.59µs  28.38µs   33810.         0B    23.7 
#>  7 cli_vec_ansi     35.45ms  35.94ms      27.8    2.48KB   153.  
#>  8 fansi_vec_ansi  231.81µs 242.07µs    4029.     7.25KB    10.4 
#>  9 base_vec_ansi     2.22ms   2.29ms     430.    48.18KB    25.3 
#> 10 cli_vec_plain    23.35ms  23.64ms      42.2    2.48KB    63.3 
#> 11 fansi_vec_plain 184.86µs  193.5µs    5022.     6.42KB    14.7 
#> 12 base_vec_plain    1.56ms   1.64ms     609.     47.4KB    15.3 
#> 13 cli_txt_ansi     23.28ms  23.59ms      42.3  507.59KB     4.45
#> 14 fansi_txt_ansi  224.16µs 234.17µs    4226.     6.77KB     6.14
#> 15 base_txt_ansi     1.25ms   1.31ms     755.   582.06KB    11.2 
#> 16 cli_txt_plain     1.23ms   1.27ms     779.   369.84KB     8.71
#> 17 fansi_txt_plain 173.23µs 182.19µs    5407.     2.51KB     6.22
#> 18 base_txt_plain  853.62µs 895.32µs    1106.   367.31KB    11.1
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
#>  1 cli_ansi          6.52µs   7.23µs   132830.   24.83KB    26.6 
#>  2 fansi_ansi       68.83µs  74.36µs    13193.   28.48KB    12.5 
#>  3 base_ansi       982.08ns   1.08µs   858646.        0B     0   
#>  4 cli_plain         6.59µs   7.29µs   133399.        0B    13.3 
#>  5 fansi_plain       69.2µs  74.81µs    13118.    1.98KB    12.5 
#>  6 base_plain         951ns   1.06µs   867127.        0B     0   
#>  7 cli_vec_ansi     26.57µs  27.74µs    35394.     1.7KB     7.08
#>  8 fansi_vec_ansi  105.08µs  110.3µs     8900.    8.86KB     8.36
#>  9 base_vec_ansi     6.09µs    6.3µs   154518.      848B     0   
#> 10 cli_vec_plain    23.02µs  24.18µs    40488.     1.7KB     4.05
#> 11 fansi_vec_plain  99.39µs 105.03µs     9339.    8.86KB    10.6 
#> 12 base_vec_plain    5.73µs   5.92µs   165044.      848B     0   
#> 13 cli_txt_ansi      6.53µs   7.29µs   133006.        0B    13.3 
#> 14 fansi_txt_ansi   69.48µs  74.95µs    13088.    1.98KB    12.5 
#> 15 base_txt_ansi     5.57µs   5.69µs   171503.        0B     0   
#> 16 cli_txt_plain     7.46µs   8.19µs   118748.        0B    23.8 
#> 17 fansi_txt_plain  69.44µs  74.59µs    13145.    1.98KB    12.7 
#> 18 base_txt_plain    3.56µs   3.67µs   264889.        0B     0
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
#>  1 cli_ansi        86.93µs  92.76µs   10523.    11.88KB    10.3 
#>  2 base_ansi        1.25µs   1.33µs  725108.         0B     0   
#>  3 cli_plain        68.5µs  72.77µs   13363.     8.73KB    10.3 
#>  4 base_plain     961.12ns   1.03µs  930840.         0B     0   
#>  5 cli_vec_ansi     4.02ms   4.18ms     239.   838.77KB    13.2 
#>  6 base_vec_ansi   71.47µs  72.89µs   13520.       848B     0   
#>  7 cli_vec_plain    2.25ms   2.33ms     428.    816.9KB    17.5 
#>  8 base_vec_plain  42.37µs   43.3µs   22777.       848B     0   
#>  9 cli_txt_ansi    13.77ms  13.87ms      72.0  114.42KB     2.06
#> 10 base_txt_ansi   70.42µs  71.35µs   13826.         0B     0   
#> 11 cli_txt_plain  245.28µs 253.16µs    3888.    18.16KB     4.06
#> 12 base_txt_plain  40.64µs  40.91µs   24123.         0B     0
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
#>  1 cli_ansi         88.6µs   94.2µs    10384.        0B    14.6 
#>  2 base_ansi        15.3µs   16.6µs    58546.        0B    17.6 
#>  3 cli_plain        89.3µs   94.4µs    10312.        0B    14.6 
#>  4 base_plain       15.3µs   16.5µs    59235.        0B    11.8 
#>  5 cli_vec_ansi    174.3µs    187µs     5263.     7.2KB     6.16
#>  6 base_vec_ansi    51.9µs   55.8µs    17565.    1.66KB     4.06
#>  7 cli_vec_plain   161.7µs    174µs     5301.     7.2KB     8.31
#>  8 base_vec_plain   46.4µs   49.8µs    19504.    1.66KB     4.95
#>  9 cli_txt_ansi    154.2µs  159.3µs     6173.        0B     8.20
#> 10 base_txt_ansi    38.3µs   39.4µs    24991.        0B     5.00
#> 11 cli_txt_plain   138.1µs  142.9µs     6881.        0B    10.3 
#> 12 base_txt_plain   32.5µs   33.6µs    29270.        0B     5.86
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
#> 1 cli          7.66µs   8.28µs   117797.        0B    11.8 
#> 2 base       821.08ns 942.03ns   989385.        0B     0   
#> 3 cli_vec     23.04µs  23.88µs    41090.      448B     8.22
#> 4 base_vec    12.02µs  12.31µs    80166.      448B     0   
#> 5 cli_txt     23.48µs  24.17µs    40779.        0B     4.08
#> 6 base_txt    12.93µs  13.08µs    75088.        0B     0
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
#> 1 cli          7.56µs   8.23µs   113930.        0B    11.4 
#> 2 base         1.29µs    1.4µs   662871.        0B    66.3 
#> 3 cli_vec      29.4µs  30.47µs    32374.      448B     3.24
#> 4 base_vec    53.96µs  54.56µs    18106.      448B     0   
#> 5 cli_txt        30µs  31.11µs    31594.        0B     3.16
#> 6 base_txt    89.06µs  89.87µs    10988.        0B     0
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
#> 1 cli          8.16µs   8.89µs   109287.        0B    21.9 
#> 2 base       821.08ns 932.14ns   964494.        0B     0   
#> 3 cli_vec     19.52µs  20.48µs    48016.      448B     4.80
#> 4 base_vec    12.03µs  12.31µs    79831.      448B     7.98
#> 5 cli_txt     20.27µs  21.06µs    46651.        0B     4.67
#> 6 base_txt    12.93µs  13.09µs    74868.        0B     0
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
#> 1 cli          6.31µs   7.03µs   137581.    22.1KB    13.8 
#> 2 base       991.86ns   1.09µs   822391.        0B    82.2 
#> 3 cli_vec      30.8µs  31.96µs    30823.     1.7KB     3.08
#> 4 base_vec     8.63µs   8.81µs   111128.      848B     0   
#> 5 cli_txt      6.25µs   6.97µs   139020.        0B    13.9 
#> 6 base_txt     5.06µs   5.23µs   185946.        0B     0
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
#>  date     2026-04-09
#>  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.10.0     2026-01-26 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-04-09 [1] local
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
