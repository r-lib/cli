# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x560aa67d6ae8\>
\<environment: 0x560aa726cee8\>

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
#> 1 ansi           45µs     48µs    20242.    99.6KB     20.9
#> 2 plain        44.8µs   47.9µs    20276.        0B     21.7
#> 3 base         11.3µs   12.5µs    77507.    48.6KB     23.3
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
#> 1 ansi         46.7µs   50.3µs    19276.        0B     23.4
#> 2 plain        46.3µs   49.5µs    19588.        0B     23.1
#> 3 base         13.3µs   14.3µs    67886.        0B     27.2
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
#> 1 ansi       115.17µs 122.62µs     7933.   77.03KB     16.7
#> 2 plain       92.94µs   97.5µs     9936.    8.91KB     14.5
#> 3 base         1.88µs   2.01µs   478364.        0B     47.8
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
#> 1 ansi          336µs    357µs     2749.   33.24KB     21.1
#> 2 plain         332µs    353µs     2796.    1.09KB     18.9
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
#>  1 cli_ansi          5.93µs   6.46µs   149883.    9.27KB    30.0 
#>  2 fansi_ansi       30.38µs  33.09µs    29294.    4.18KB    23.5 
#>  3 cli_plain         5.84µs   6.25µs   137572.        0B    13.8 
#>  4 fansi_plain      30.32µs     32µs    30042.      688B    12.0 
#>  5 cli_vec_ansi      7.27µs   7.64µs   127739.      448B    12.8 
#>  6 fansi_vec_ansi   40.55µs  43.05µs    22344.    5.02KB    11.2 
#>  7 cli_vec_plain     7.92µs   8.38µs   116367.      448B    11.6 
#>  8 fansi_vec_plain  38.37µs  40.78µs    23861.    5.02KB     9.55
#>  9 cli_txt_ansi      5.84µs   6.22µs   155692.        0B    15.6 
#> 10 fansi_txt_ansi   30.09µs  32.21µs    30195.      688B    12.1 
#> 11 cli_txt_plain     6.63µs   7.01µs   137951.        0B    13.8 
#> 12 fansi_txt_plain  38.61µs  40.74µs    23897.    5.02KB     9.56
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
#> 1 cli          57.1µs   58.4µs    16601.    22.7KB     4.04
#> 2 fansi       119.7µs    126µs     7832.    55.3KB     4.05
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
#>  1 cli_ansi          6.92µs   7.49µs   129312.        0B    12.9 
#>  2 fansi_ansi       92.91µs  97.58µs     9968.   38.84KB    10.3 
#>  3 base_ansi       911.07ns 952.16ns   998196.        0B     0   
#>  4 cli_plain         6.75µs   7.39µs   131622.        0B    13.2 
#>  5 fansi_plain      91.82µs  96.59µs    10057.      688B     8.20
#>  6 base_plain      811.07ns 861.12ns  1088420.        0B     0   
#>  7 cli_vec_ansi     29.44µs   30.2µs    32503.      448B     3.25
#>  8 fansi_vec_ansi  113.02µs 117.72µs     8246.    5.02KB     8.24
#>  9 base_vec_ansi    18.45µs  18.57µs    53031.      448B     0   
#> 10 cli_vec_plain       28µs  28.81µs    34029.      448B     3.40
#> 11 fansi_vec_plain 103.54µs 107.97µs     8977.    5.02KB     6.13
#> 12 base_vec_plain    10.8µs  10.88µs    90027.      448B     9.00
#> 13 cli_txt_ansi     29.34µs  30.05µs    32389.        0B     3.24
#> 14 fansi_txt_ansi  104.64µs 109.69µs     8853.      688B     6.11
#> 15 base_txt_ansi    18.21µs  18.29µs    53856.        0B     0   
#> 16 cli_txt_plain    27.65µs  28.33µs    34627.        0B     3.46
#> 17 fansi_txt_plain  95.17µs  99.84µs     9724.      688B     8.19
#> 18 base_txt_plain   10.55µs  10.89µs    88677.        0B     8.87
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
#>  1 cli_ansi          8.45µs   9.29µs   104534.        0B    10.5 
#>  2 fansi_ansi       93.42µs  98.16µs     9883.      688B     8.18
#>  3 base_ansi         1.23µs   1.29µs   731553.        0B     0   
#>  4 cli_plain         8.55µs   9.18µs   105822.        0B    21.2 
#>  5 fansi_plain      92.58µs  97.67µs     9915.      688B     8.20
#>  6 base_plain        1.01µs   1.06µs   892392.        0B     0   
#>  7 cli_vec_ansi     34.63µs  35.59µs    27538.      448B     2.75
#>  8 fansi_vec_ansi  115.88µs 120.58µs     8055.    5.02KB     8.23
#>  9 base_vec_ansi    44.02µs  44.43µs    22263.      448B     0   
#> 10 cli_vec_plain    33.33µs  34.23µs    28637.      448B     2.86
#> 11 fansi_vec_plain 106.55µs  111.1µs     8747.    5.02KB     8.24
#> 12 base_vec_plain   22.98µs  23.75µs    41765.      448B     0   
#> 13 cli_txt_ansi     35.01µs  35.75µs    27438.        0B     2.74
#> 14 fansi_txt_ansi  107.44µs 112.81µs     8618.      688B     8.19
#> 15 base_txt_ansi    46.91µs  47.12µs    20980.        0B     0   
#> 16 cli_txt_plain    32.89µs   33.7µs    29072.        0B     2.91
#> 17 fansi_txt_plain  97.74µs 102.65µs     9457.      688B     8.19
#> 18 base_txt_plain   24.33µs   25.3µs    39082.        0B     0
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
#> 1 cli_ansi        6.84µs   7.36µs   131323.        0B    13.1 
#> 2 cli_plain       6.39µs   6.93µs   139720.        0B    14.0 
#> 3 cli_vec_ansi   32.24µs  33.37µs    29407.      848B     2.94
#> 4 cli_vec_plain  10.45µs  11.11µs    87645.      848B     8.77
#> 5 cli_txt_ansi   32.46µs  33.63µs    29156.        0B     2.92
#> 6 cli_txt_plain   7.26µs   7.79µs   124624.        0B    12.5
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
#>  1 cli_ansi          26.2µs   27.8µs    35020.        0B    14.0 
#>  2 fansi_ansi        28.6µs   30.7µs    31589.    7.24KB    12.6 
#>  3 cli_plain           26µs   27.5µs    35319.        0B    17.7 
#>  4 fansi_plain       28.2µs     30µs    32459.      688B    13.0 
#>  5 cli_vec_ansi      35.1µs   36.8µs    26434.      848B    10.6 
#>  6 fansi_vec_ansi    55.8µs   58.5µs    16666.    5.41KB     6.16
#>  7 cli_vec_plain     28.7µs   30.1µs    32191.      848B    12.9 
#>  8 fansi_vec_plain   37.2µs     39µs    24988.    4.59KB    10.00
#>  9 cli_txt_ansi      33.8µs   35.3µs    27426.        0B    13.7 
#> 10 fansi_txt_ansi    44.2µs   45.7µs    21243.    5.12KB     8.50
#> 11 cli_txt_plain     26.2µs   27.7µs    34973.        0B    14.0 
#> 12 fansi_txt_plain   29.1µs   30.5µs    31623.      688B    12.7
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
#>  1 cli_ansi        162.65µs  169.7µs     5729.  104.86KB    10.3 
#>  2 fansi_ansi      127.54µs 134.76µs     7218.  106.35KB    10.3 
#>  3 base_ansi         4.11µs   4.42µs   220636.      224B     0   
#>  4 cli_plain       162.08µs 169.26µs     5748.    8.09KB    10.3 
#>  5 fansi_plain     127.52µs 133.92µs     7275.    9.62KB    10.3 
#>  6 base_plain        3.61µs   3.85µs   252789.        0B    25.3 
#>  7 cli_vec_ansi      7.58ms    7.7ms      130.  823.77KB    11.0 
#>  8 fansi_vec_ansi    1.05ms   1.07ms      911.  846.81KB    19.3 
#>  9 base_vec_ansi   154.59µs 160.11µs     6096.    22.7KB     2.04
#> 10 cli_vec_plain     7.52ms   7.69ms      129.  823.77KB    11.4 
#> 11 fansi_vec_plain 986.59µs   1.01ms      982.  845.98KB    19.4 
#> 12 base_vec_plain  105.54µs 109.15µs     8927.      848B     2.01
#> 13 cli_txt_ansi      3.38ms   3.42ms      292.    63.6KB     2.01
#> 14 fansi_txt_ansi    1.56ms   1.58ms      630.   35.05KB     0   
#> 15 base_txt_ansi   139.14µs 146.25µs     6780.   18.47KB     2.02
#> 16 cli_txt_plain      2.5ms   2.54ms      393.    63.6KB     2.01
#> 17 fansi_txt_plain 510.96µs 548.73µs     1827.    30.6KB     2.02
#> 18 base_txt_plain   86.27µs  88.42µs    11094.   11.05KB     2.02
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
#>  1 cli_ansi        145.02µs 151.57µs     6420.   33.84KB    12.4 
#>  2 fansi_ansi       54.66µs  58.42µs    16583.   31.42KB    12.4 
#>  3 base_ansi         1.06µs   1.12µs   852017.     4.2KB     0   
#>  4 cli_plain       144.02µs  150.7µs     6451.        0B    12.4 
#>  5 fansi_plain      54.58µs  58.45µs    16598.      872B    12.4 
#>  6 base_plain      982.08ns   1.04µs   917321.        0B     0   
#>  7 cli_vec_ansi    278.64µs 291.39µs     3371.   16.73KB     6.28
#>  8 fansi_vec_ansi  116.05µs 120.16µs     8111.    5.59KB     6.15
#>  9 base_vec_ansi    36.35µs   37.1µs    26545.      848B     0   
#> 10 cli_vec_plain   233.31µs 242.11µs     4029.   16.73KB     8.30
#> 11 fansi_vec_plain 108.33µs 112.57µs     8665.    5.59KB     6.14
#> 12 base_vec_plain   30.14µs  31.01µs    31893.      848B     0   
#> 13 cli_txt_ansi    154.16µs 161.97µs     5992.        0B    12.5 
#> 14 fansi_txt_ansi   53.71µs  57.68µs    16909.      872B    12.0 
#> 15 base_txt_ansi     1.09µs   1.14µs   834156.        0B     0   
#> 16 cli_txt_plain   144.08µs 150.49µs     6460.        0B    12.4 
#> 17 fansi_txt_plain  53.57µs  55.86µs    17371.      872B    12.4 
#> 18 base_txt_plain       1µs   1.05µs   903594.        0B     0
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
#>  1 cli_ansi        417.02µs 446.88µs    2238.     6.18KB    10.4 
#>  2 fansi_ansi       98.83µs 104.69µs    9295.    97.33KB    10.3 
#>  3 base_ansi        38.17µs  39.98µs   24234.         0B    12.1 
#>  4 cli_plain       273.44µs 284.34µs    3435.         0B    10.3 
#>  5 fansi_plain      97.42µs 103.52µs    9376.       872B    10.3 
#>  6 base_plain       30.91µs   32.9µs   29331.         0B    11.7 
#>  7 cli_vec_ansi     44.18ms   44.5ms      22.4   94.67KB    18.7 
#>  8 fansi_vec_ansi  237.28µs 246.43µs    3982.     7.25KB     6.13
#>  9 base_vec_ansi     2.27ms   2.33ms     428.    48.18KB    12.8 
#> 10 cli_vec_plain     28.6ms  28.89ms      34.5    2.48KB    14.4 
#> 11 fansi_vec_plain 191.67µs 199.12µs    4910.     6.42KB     6.13
#> 12 base_vec_plain    1.65ms   1.71ms     583.     47.4KB    12.7 
#> 13 cli_txt_ansi     27.36ms  27.68ms      36.1    4.27MB     7.21
#> 14 fansi_txt_ansi   225.8µs 234.53µs    4189.     6.77KB     4.05
#> 15 base_txt_ansi     1.28ms   1.31ms     759.   582.06KB    11.0 
#> 16 cli_txt_plain     1.31ms   1.34ms     741.   369.84KB     8.57
#> 17 fansi_txt_plain 178.73µs 185.59µs    5270.     2.51KB     6.14
#> 18 base_txt_plain  865.49µs 899.71µs    1094.   367.31KB    10.9
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
#>  1 cli_ansi          6.88µs    7.5µs   128223.   25.09KB    12.8 
#>  2 fansi_ansi        80.4µs  84.42µs    11502.   28.48KB    10.3 
#>  3 base_ansi         1.06µs   1.13µs   803654.        0B    80.4 
#>  4 cli_plain         6.81µs    7.4µs   130820.        0B    13.1 
#>  5 fansi_plain      79.51µs     84µs    11547.    1.98KB    10.5 
#>  6 base_plain        1.02µs   1.08µs   878914.        0B     0   
#>  7 cli_vec_ansi     27.45µs  28.28µs    34667.     1.7KB     3.47
#>  8 fansi_vec_ansi  117.56µs 122.42µs     7931.    8.86KB     8.32
#>  9 base_vec_ansi     6.35µs   6.65µs   147476.      848B     0   
#> 10 cli_vec_plain    23.54µs  24.37µs    40172.     1.7KB     4.02
#> 11 fansi_vec_plain  110.9µs 116.77µs     8273.    8.86KB     8.34
#> 12 base_vec_plain    6.19µs   6.41µs   152950.      848B     0   
#> 13 cli_txt_ansi      6.79µs    7.4µs   126669.        0B    25.3 
#> 14 fansi_txt_ansi   79.65µs  84.24µs    11541.    1.98KB    11.0 
#> 15 base_txt_ansi     6.47µs   6.54µs   149666.        0B     0   
#> 16 cli_txt_plain     7.55µs   7.98µs   122482.        0B    12.2 
#> 17 fansi_txt_plain  77.83µs  80.78µs    12034.    1.98KB    10.3 
#> 18 base_txt_plain    4.13µs   4.19µs   232000.        0B    23.2
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
#>  1 cli_ansi       109.92µs 113.71µs    8530.     12.1KB     8.18
#>  2 base_ansi        1.33µs   1.37µs  707739.         0B     0   
#>  3 cli_plain       89.15µs  92.48µs   10469.     8.91KB     8.19
#>  4 base_plain       1.03µs   1.06µs  916150.         0B     0   
#>  5 cli_vec_ansi     4.17ms   4.25ms     234.   838.95KB    13.2 
#>  6 base_vec_ansi   75.56µs   76.3µs   12948.       848B     0   
#>  7 cli_vec_plain    2.37ms   2.42ms     412.   817.08KB    15.2 
#>  8 base_vec_plain  45.88µs  46.55µs   21217.       848B     0   
#>  9 cli_txt_ansi    14.91ms  14.98ms      66.7   114.6KB     4.30
#> 10 base_txt_ansi   75.17µs  76.49µs   12883.         0B     0   
#> 11 cli_txt_plain  293.47µs  304.5µs    3215.    18.34KB     2.01
#> 12 base_txt_plain   42.3µs  43.76µs   22589.         0B     0
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
#>  1 cli_ansi        106.5µs  111.4µs     8714.        0B    12.3 
#>  2 base_ansi        16.5µs   17.4µs    55859.        0B    11.2 
#>  3 cli_plain       106.1µs  110.7µs     8746.        0B    12.4 
#>  4 base_plain       16.5µs   17.4µs    55647.        0B    11.1 
#>  5 cli_vec_ansi    209.9µs  216.9µs     4502.     7.2KB     6.12
#>  6 base_vec_ansi      59µs   65.4µs    15072.    1.66KB     4.06
#>  7 cli_vec_plain   195.6µs  203.8µs     4789.     7.2KB     6.12
#>  8 base_vec_plain   52.4µs   58.2µs    16871.    1.66KB     2.02
#>  9 cli_txt_ansi    181.3µs  187.3µs     5188.        0B     8.19
#> 10 base_txt_ansi    41.2µs   42.4µs    23008.        0B     4.60
#> 11 cli_txt_plain   166.2µs  173.3µs     5620.        0B     8.27
#> 12 base_txt_plain   35.1µs   36.4µs    26836.        0B     5.37
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
#> 1 cli          8.18µs   8.81µs   110188.        0B    11.0 
#> 2 base       861.01ns    912ns  1011597.        0B     0   
#> 3 cli_vec     23.81µs  24.54µs    39864.      448B     3.99
#> 4 base_vec    11.47µs  11.72µs    83724.      448B     8.37
#> 5 cli_txt     23.89µs  24.53µs    39903.        0B     3.99
#> 6 base_txt    12.52µs   12.6µs    78117.        0B     0
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
#> 1 cli          8.16µs   8.79µs   110274.        0B    11.0 
#> 2 base          1.3µs   1.35µs   695596.        0B     0   
#> 3 cli_vec     29.12µs  30.04µs    32567.      448B     6.51
#> 4 base_vec    50.47µs  50.97µs    19399.      448B     0   
#> 5 cli_txt     29.43µs  30.32µs    32247.        0B     3.23
#> 6 base_txt    86.07µs  86.75µs    11395.        0B     0
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
#> 1 cli          8.69µs   9.43µs   102982.        0B    10.3 
#> 2 base       861.01ns 922.13ns   982332.        0B    98.2 
#> 3 cli_vec     19.54µs  20.46µs    47796.      448B     4.78
#> 4 base_vec    11.46µs  11.71µs    83989.      448B     0   
#> 5 cli_txt     20.29µs  21.14µs    46235.        0B     4.62
#> 6 base_txt    12.52µs  12.63µs    77905.        0B     7.79
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
#> 1 cli          6.35µs   6.97µs   138439.    22.2KB    13.8 
#> 2 base         1.05µs   1.11µs   841043.        0B     0   
#> 3 cli_vec     29.39µs  30.32µs    32334.     1.7KB     3.23
#> 4 base_vec     8.14µs   8.37µs   116428.      848B    11.6 
#> 5 cli_txt      6.38µs   6.95µs   139187.        0B    13.9 
#> 6 base_txt     5.47µs   5.55µs   176206.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.1 (2026-06-24)
#>  os       Ubuntu 24.04.5 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-10-19
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-10-19 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.1)
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
#>  knitr         1.52       2026-09-06 [1] RSPM
#>  lifecycle     1.0.5      2026-01-08 [1] RSPM
#>  magrittr      2.0.5      2026-04-04 [1] RSPM
#>  otel          0.2.0      2025-08-29 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.1      2026-07-07 [1] any (@2.2.1)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.3.0      2026-07-05 [1] RSPM
#>  rmarkdown     2.32       2026-09-01 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  sessioninfo   1.2.4      2026-06-04 [1] any (@1.2.4)
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.62       2026-10-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
