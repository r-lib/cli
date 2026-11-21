# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5ef9bf6e1b48\>
\<environment: 0x5ef9c0179da8\>

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
#> 1 ansi           47µs   50.4µs    19330.    99.6KB     21.1
#> 2 plain        46.9µs   50.4µs    19219.        0B     22.0
#> 3 base           12µs   13.3µs    73012.    48.6KB     14.6
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
#> 1 ansi           48µs   52.1µs    18684.        0B     23.6
#> 2 plain        47.9µs   51.6µs    18834.        0B     21.1
#> 3 base         13.8µs   15.3µs    62756.        0B     25.1
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
#> 1 ansi        114.3µs 122.14µs     7959.   77.03KB     16.8
#> 2 plain        92.1µs  97.64µs     9924.    8.91KB     14.6
#> 3 base          1.6µs   1.74µs   549180.        0B     54.9
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
#> 1 ansi          353µs    377µs     2630.   33.23KB     19.2
#> 2 plain         355µs    375µs     2639.    1.09KB     19.2
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
#>  1 cli_ansi          5.95µs   6.57µs   147021.    9.27KB    29.4 
#>  2 fansi_ansi       31.81µs  34.77µs    27928.    4.18KB    25.2 
#>  3 cli_plain         5.78µs   6.44µs   150106.        0B    30.0 
#>  4 fansi_plain      31.38µs  33.32µs    28434.      688B    11.4 
#>  5 cli_vec_ansi      7.53µs   8.06µs   119809.      448B    12.0 
#>  6 fansi_vec_ansi   40.87µs  43.13µs    22236.    5.02KB     8.90
#>  7 cli_vec_plain     8.07µs    8.6µs   113652.      448B    11.4 
#>  8 fansi_vec_plain  39.92µs  42.13µs    23148.    5.02KB     9.26
#>  9 cli_txt_ansi      5.89µs   6.34µs   153937.        0B    15.4 
#> 10 fansi_txt_ansi   31.09µs   33.2µs    29293.      688B    14.7 
#> 11 cli_txt_plain     6.68µs   7.14µs   136296.        0B    13.6 
#> 12 fansi_txt_plain  40.24µs  43.06µs    22627.    5.02KB     9.05
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
#> 1 cli            53µs   54.7µs    17844.    22.7KB     6.12
#> 2 fansi         111µs  117.1µs     8340.    55.3KB     4.05
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
#>  1 cli_ansi          7.02µs   7.76µs   119499.        0B    12.0 
#>  2 fansi_ansi       91.88µs  96.85µs    10041.   38.84KB     8.18
#>  3 base_ansi       851.11ns 901.05ns  1028002.        0B     0   
#>  4 cli_plain          7.1µs   7.82µs   124835.        0B    12.5 
#>  5 fansi_plain      91.09µs  96.68µs     9951.      688B    10.3 
#>  6 base_plain      791.04ns 832.14ns  1131611.        0B     0   
#>  7 cli_vec_ansi     28.99µs  30.25µs    32491.      448B     3.25
#>  8 fansi_vec_ansi  112.75µs 118.29µs     8228.    5.02KB     6.14
#>  9 base_vec_ansi     14.6µs  14.68µs    67026.      448B     0   
#> 10 cli_vec_plain    27.93µs  28.77µs    34130.      448B     3.41
#> 11 fansi_vec_plain 102.61µs 107.73µs     8960.    5.02KB     8.25
#> 12 base_vec_plain    8.69µs   8.76µs   111955.      448B     0   
#> 13 cli_txt_ansi     29.33µs  30.37µs    32402.        0B     3.24
#> 14 fansi_txt_ansi   104.7µs 110.13µs     8851.      688B     8.19
#> 15 base_txt_ansi    14.22µs  14.28µs    68642.        0B     0   
#> 16 cli_txt_plain    27.25µs  28.06µs    34925.        0B     3.49
#> 17 fansi_txt_plain  94.26µs  99.38µs     9796.      688B     8.19
#> 18 base_txt_plain    8.35µs    8.9µs   111308.        0B     0
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
#>  1 cli_ansi           8.8µs   9.78µs    99268.        0B    19.9 
#>  2 fansi_ansi       92.55µs  97.83µs     9948.      688B     8.29
#>  3 base_ansi         1.18µs   1.23µs   753341.        0B     0   
#>  4 cli_plain          8.8µs   9.71µs    96490.        0B     9.65
#>  5 fansi_plain      92.47µs  97.06µs    10037.      688B     8.19
#>  6 base_plain      961.01ns   1.02µs   905957.        0B    90.6 
#>  7 cli_vec_ansi     40.71µs  41.89µs    23435.      448B     2.34
#>  8 fansi_vec_ansi  115.77µs 120.72µs     8074.    5.02KB     6.14
#>  9 base_vec_ansi    40.74µs  41.08µs    24046.      448B     0   
#> 10 cli_vec_plain    38.09µs  40.44µs    24245.      448B     4.85
#> 11 fansi_vec_plain 104.61µs 109.83µs     8854.    5.02KB     6.15
#> 12 base_vec_plain   20.85µs   21.3µs    46085.      448B     0   
#> 13 cli_txt_ansi     42.57µs  44.22µs    22233.        0B     4.45
#> 14 fansi_txt_ansi  107.81µs 112.32µs     8617.      688B     6.10
#> 15 base_txt_ansi    43.11µs  43.42µs    22769.        0B     0   
#> 16 cli_txt_plain     38.7µs  39.95µs    24596.        0B     4.92
#> 17 fansi_txt_plain  96.79µs 101.61µs     9570.      688B     8.18
#> 18 base_txt_plain   22.71µs  23.15µs    42599.        0B     0
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
#> 1 cli_ansi        6.77µs   7.55µs   128476.        0B    12.8 
#> 2 cli_plain       6.48µs   7.15µs   129370.        0B    12.9 
#> 3 cli_vec_ansi   30.66µs  31.54µs    31125.      848B     3.11
#> 4 cli_vec_plain  10.51µs  11.28µs    86547.      848B     8.66
#> 5 cli_txt_ansi   29.43µs  30.29µs    32412.        0B     0   
#> 6 cli_txt_plain   7.44µs   8.12µs   119907.        0B    12.0
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
#>  1 cli_ansi          26.6µs   28.3µs    34371.        0B    13.8 
#>  2 fansi_ansi        29.4µs   31.6µs    30739.    7.24KB    12.3 
#>  3 cli_plain         26.7µs   28.3µs    33857.        0B    13.5 
#>  4 fansi_plain       29.1µs     31µs    31400.      688B    12.6 
#>  5 cli_vec_ansi      35.2µs   37.3µs    26164.      848B    10.5 
#>  6 fansi_vec_ansi    55.8µs   58.3µs    16564.    5.41KB     8.31
#>  7 cli_vec_plain     29.2µs   31.2µs    31203.      848B    12.5 
#>  8 fansi_vec_plain   38.7µs   40.7µs    23521.    4.59KB     9.41
#>  9 cli_txt_ansi      34.2µs   35.6µs    27447.        0B    11.0 
#> 10 fansi_txt_ansi    45.2µs     47µs    20546.    5.12KB     8.22
#> 11 cli_txt_plain     27.1µs   28.4µs    34362.        0B    13.8 
#> 12 fansi_txt_plain   30.4µs   31.8µs    30650.      688B    12.3
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
#>  1 cli_ansi        165.55µs 172.02µs     5662.  104.86KB    10.3 
#>  2 fansi_ansi      128.68µs 136.09µs     7055.  106.35KB    10.3 
#>  3 base_ansi         3.71µs   3.98µs   244300.      224B     0   
#>  4 cli_plain       165.02µs  171.7µs     5591.    8.09KB    10.3 
#>  5 fansi_plain     127.12µs 134.21µs     7186.    9.62KB    10.4 
#>  6 base_plain        3.24µs   3.47µs   281105.        0B     0   
#>  7 cli_vec_ansi      7.63ms   7.77ms      129.  823.77KB    11.1 
#>  8 fansi_vec_ansi    1.05ms    1.1ms      828.  846.81KB    17.5 
#>  9 base_vec_ansi   153.79µs  158.1µs     6201.    22.7KB     2.04
#> 10 cli_vec_plain     7.52ms   7.72ms      128.  823.77KB    11.2 
#> 11 fansi_vec_plain 997.89µs   1.03ms      963.  845.98KB    20.0 
#> 12 base_vec_plain  105.49µs 107.87µs     9054.      848B     2.02
#> 13 cli_txt_ansi      3.26ms   3.29ms      303.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.62ms   1.63ms      611.   35.05KB     0   
#> 15 base_txt_ansi   143.04µs 146.93µs     6673.   18.47KB     2.02
#> 16 cli_txt_plain     2.42ms   2.44ms      404.    63.6KB     0   
#> 17 fansi_txt_plain 512.43µs 534.01µs     1855.    30.6KB     4.08
#> 18 base_txt_plain   90.93µs  95.72µs    10184.   11.05KB     2.02
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
#>  1 cli_ansi        154.57µs 162.19µs     6013.   33.84KB    12.5 
#>  2 fansi_ansi       55.48µs   58.9µs    16421.   31.42KB    10.4 
#>  3 base_ansi         1.02µs   1.08µs   868782.     4.2KB     0   
#>  4 cli_plain       152.19µs 159.57µs     6098.        0B    12.4 
#>  5 fansi_plain         55µs  58.58µs    16434.      872B    12.5 
#>  6 base_plain      952.04ns      1µs   955145.        0B     0   
#>  7 cli_vec_ansi    285.62µs 295.85µs     3327.   16.73KB     6.15
#>  8 fansi_vec_ansi  117.08µs 121.48µs     8022.    5.59KB     6.29
#>  9 base_vec_ansi    34.55µs  34.87µs    28241.      848B     0   
#> 10 cli_vec_plain   246.24µs 255.73µs     3806.   16.73KB     8.30
#> 11 fansi_vec_plain 108.25µs 112.24µs     8698.    5.59KB     6.16
#> 12 base_vec_plain   28.51µs  28.95µs    33381.      848B     0   
#> 13 cli_txt_ansi    161.63µs 168.92µs     5772.        0B    12.5 
#> 14 fansi_txt_ansi   55.63µs  59.21µs    16297.      872B    10.4 
#> 15 base_txt_ansi     1.07µs   1.12µs   834039.        0B     0   
#> 16 cli_txt_plain   151.78µs 160.19µs     6123.        0B    12.2 
#> 17 fansi_txt_plain  54.03µs   56.8µs    16733.      872B    12.4 
#> 18 base_txt_plain  972.07ns   1.02µs   939474.        0B     0
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
#>  1 cli_ansi        426.27µs  448.7µs    2222.     6.18KB    10.3 
#>  2 fansi_ansi       99.52µs 105.13µs    9298.    97.33KB    10.4 
#>  3 base_ansi        39.26µs  41.38µs   23346.         0B    11.7 
#>  4 cli_plain       286.02µs 298.57µs    3288.         0B    10.3 
#>  5 fansi_plain      98.03µs 104.61µs    9276.       872B    10.3 
#>  6 base_plain       32.18µs  34.23µs   28220.         0B    11.3 
#>  7 cli_vec_ansi     44.74ms  45.07ms      22.1   94.67KB    18.4 
#>  8 fansi_vec_ansi  235.93µs  244.1µs    4024.     7.25KB     6.15
#>  9 base_vec_ansi      2.3ms   2.37ms     420.    48.18KB    12.9 
#> 10 cli_vec_plain    29.37ms  29.85ms      33.5    2.48KB    14.0 
#> 11 fansi_vec_plain 190.78µs 198.04µs    4941.     6.42KB     6.14
#> 12 base_vec_plain    1.67ms   1.73ms     574.     47.4KB    12.9 
#> 13 cli_txt_ansi     24.61ms  24.93ms      40.0    4.27MB     4.45
#> 14 fansi_txt_ansi     223µs 231.78µs    4246.     6.77KB     4.06
#> 15 base_txt_ansi     1.26ms    1.3ms     761.   582.06KB    11.1 
#> 16 cli_txt_plain     1.27ms   1.31ms     752.   369.84KB     8.64
#> 17 fansi_txt_plain 175.79µs 183.09µs    5338.     2.51KB     6.15
#> 18 base_txt_plain  858.21µs 886.66µs    1111.   367.31KB    11.0
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
#>  1 cli_ansi          6.69µs   7.43µs   129548.   25.09KB    13.0 
#>  2 fansi_ansi       81.14µs  85.98µs    11301.   28.48KB    10.4 
#>  3 base_ansi       991.98ns   1.06µs   875165.        0B     0   
#>  4 cli_plain         6.64µs   7.46µs   127513.        0B    25.5 
#>  5 fansi_plain      80.54µs  85.62µs    11347.    1.98KB    10.4 
#>  6 base_plain      971.02ns   1.03µs   908495.        0B     0   
#>  7 cli_vec_ansi     27.67µs  28.75µs    34167.     1.7KB     3.42
#>  8 fansi_vec_ansi  115.67µs 121.33µs     8021.    8.86KB     8.44
#>  9 base_vec_ansi     5.97µs    6.1µs   160558.      848B     0   
#> 10 cli_vec_plain    23.55µs  24.62µs    39808.     1.7KB     3.98
#> 11 fansi_vec_plain 111.17µs 115.81µs     8397.    8.86KB     8.34
#> 12 base_vec_plain    5.54µs   5.76µs   169320.      848B     0   
#> 13 cli_txt_ansi      6.67µs    7.4µs   130023.        0B    13.0 
#> 14 fansi_txt_ansi   80.89µs  85.96µs    11283.    1.98KB    10.4 
#> 15 base_txt_ansi     5.13µs   5.21µs   184314.        0B    18.4 
#> 16 cli_txt_plain      7.5µs   8.25µs   117409.        0B    11.7 
#> 17 fansi_txt_plain  80.23µs  85.05µs    11433.    1.98KB    11.2 
#> 18 base_txt_plain    3.35µs    3.4µs   285926.        0B     0
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
#>  1 cli_ansi       109.74µs 113.78µs    8534.     12.1KB     8.22
#>  2 base_ansi         1.3µs   1.36µs  713921.         0B     0   
#>  3 cli_plain        89.1µs  92.27µs   10515.     8.91KB     8.21
#>  4 base_plain     991.04ns   1.04µs  906636.         0B     0   
#>  5 cli_vec_ansi     4.11ms    4.2ms     237.   838.95KB    15.5 
#>  6 base_vec_ansi   75.65µs  76.07µs   12996.       848B     0   
#>  7 cli_vec_plain    2.32ms   2.37ms     418.   817.08KB    13.0 
#>  8 base_vec_plain   44.5µs  45.19µs   21899.       848B     0   
#>  9 cli_txt_ansi    12.54ms  12.63ms      79.0   114.6KB     4.27
#> 10 base_txt_ansi   76.18µs  76.42µs   12939.         0B     0   
#> 11 cli_txt_plain  285.59µs 297.13µs    3308.    18.34KB     2.01
#> 12 base_txt_plain  42.82µs  43.02µs   22971.         0B     0
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
#>  1 cli_ansi        112.5µs  117.5µs     8261.        0B    10.3 
#>  2 base_ansi        17.6µs   18.9µs    51395.        0B    10.3 
#>  3 cli_plain       111.5µs  116.6µs     8316.        0B    12.4 
#>  4 base_plain       17.6µs   18.7µs    51935.        0B    10.4 
#>  5 cli_vec_ansi      199µs  205.2µs     4763.     7.2KB     6.14
#>  6 base_vec_ansi    53.9µs   58.4µs    16712.    1.66KB     4.06
#>  7 cli_vec_plain   187.8µs  193.8µs     5036.     7.2KB     6.15
#>  8 base_vec_plain   51.4µs   53.1µs    18420.    1.66KB     4.06
#>  9 cli_txt_ansi    176.3µs  181.8µs     5362.        0B     6.11
#> 10 base_txt_ansi    39.8µs   41.2µs    23712.        0B     4.74
#> 11 cli_txt_plain     161µs    167µs     5845.        0B     8.19
#> 12 base_txt_plain   35.2µs   36.5µs    26754.        0B     5.35
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
#> 1 cli          8.45µs   9.19µs   105442.        0B    10.5 
#> 2 base       840.98ns 891.04ns  1052550.        0B     0   
#> 3 cli_vec     24.33µs  25.47µs    38535.      448B     3.85
#> 4 base_vec     11.6µs  11.77µs    83580.      448B     0   
#> 5 cli_txt     24.37µs  25.23µs    38791.        0B     3.88
#> 6 base_txt    12.49µs   12.6µs    78178.        0B     0
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
#> 1 cli          8.34µs   9.15µs   106305.        0B    10.6 
#> 2 base         1.28µs   1.35µs   699102.        0B     0   
#> 3 cli_vec     29.63µs  30.55µs    31984.      448B     3.20
#> 4 base_vec    49.88µs  50.64µs    19527.      448B     0   
#> 5 cli_txt     30.08µs  31.05µs    31529.        0B     3.15
#> 6 base_txt    86.42µs  87.16µs    11245.        0B     2.01
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
#> 1 cli          9.05µs   9.82µs    99136.        0B     9.91
#> 2 base       840.98ns 892.09ns  1035087.        0B     0   
#> 3 cli_vec     20.03µs  20.94µs    46725.      448B     4.67
#> 4 base_vec    11.62µs  11.79µs    83102.      448B     8.31
#> 5 cli_txt     20.68µs  21.53µs    45452.        0B     4.55
#> 6 base_txt     12.5µs  12.59µs    76147.        0B     0
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
#> 1 cli           6.4µs   7.03µs   137170.    22.2KB    13.7 
#> 2 base         1.01µs   1.08µs   849164.        0B    84.9 
#> 3 cli_vec     29.44µs  30.36µs    32340.     1.7KB     3.23
#> 4 base_vec      7.4µs   7.59µs   128797.      848B     0   
#> 5 cli_txt      6.33µs   7.03µs   137758.        0B    13.8 
#> 6 base_txt     5.45µs   5.53µs   176244.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.2 (2026-10-29)
#>  os       Ubuntu 26.04.1 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-11-21
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-21 [1] local
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.2)
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
#>  otel          0.3.0      2026-11-07 [1] RSPM
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.1      2026-07-07 [1] any (@2.2.1)
#>  profmem       0.7.0      2025-05-02 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rlang         1.3.0      2026-07-05 [1] RSPM
#>  rmarkdown     2.32       2026-09-01 [1] RSPM
#>  sass          0.5.0      2026-11-20 [1] RSPM
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
#>  systemfonts   1.3.3      2026-11-16 [1] RSPM
#>  textshaping   1.1.0      2026-11-20 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.62       2026-10-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.2/lib/R/site-library
#>  [3] /opt/R/4.6.2/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
