# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5583734510d0\>
\<environment: 0x558373f06840\>

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
#> 1 ansi         36.5µs   40.5µs    24129.    99.3KB     24.2
#> 2 plain        36.2µs   40.5µs    24149.        0B     24.2
#> 3 base         10.2µs   11.4µs    85786.    48.4KB     25.7
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
#> 1 ansi         38.3µs   42.8µs    22795.        0B     27.4
#> 2 plain        38.1µs   42.5µs    22897.        0B     25.2
#> 3 base         11.5µs   13.1µs    74257.        0B     22.3
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
#> 1 ansi         89.6µs   99.4µs     9875.   75.07KB     16.8
#> 2 plain       69.64µs   76.6µs    12713.    8.73KB     19.0
#> 3 base         1.85µs      2µs   474837.        0B      0
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
#> 1 ansi          267µs    294µs     3369.   33.17KB     23.6
#> 2 plain         263µs    290µs     3409.    1.09KB     23.4
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
#>  1 cli_ansi          5.29µs   6.18µs   156307.     9.2KB     31.3
#>  2 fansi_ansi       26.03µs  28.33µs    34132.    4.18KB     27.3
#>  3 cli_plain         5.25µs    5.7µs   170215.        0B     34.0
#>  4 fansi_plain      25.77µs     27µs    35916.      688B     28.8
#>  5 cli_vec_ansi      6.35µs   6.98µs   139630.      448B     27.9
#>  6 fansi_vec_ansi   34.23µs  36.04µs    26942.    5.02KB     21.6
#>  7 cli_vec_plain     6.94µs   7.58µs   127522.      448B     12.8
#>  8 fansi_vec_plain  33.08µs  35.16µs    27655.    5.02KB     24.9
#>  9 cli_txt_ansi      5.18µs   5.75µs   167463.        0B     16.7
#> 10 fansi_txt_ansi   26.13µs  27.76µs    34791.      688B     31.3
#> 11 cli_txt_plain     5.98µs   6.57µs   146247.        0B     14.6
#> 12 fansi_txt_plain  33.09µs  35.31µs    27470.    5.02KB     24.7
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
#> 1 cli          52.5µs   54.3µs    18168.    22.7KB     10.3
#> 2 fansi       101.5µs  105.6µs     9370.    55.3KB     10.3
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
#>  1 cli_ansi          6.13µs   6.57µs   145428.        0B    29.1 
#>  2 fansi_ansi       71.22µs  77.97µs    12572.   38.83KB    21.2 
#>  3 base_ansi        819.1ns 849.02ns  1082286.        0B     0   
#>  4 cli_plain         6.15µs   6.57µs   146013.        0B    29.2 
#>  5 fansi_plain      70.29µs  75.76µs    12873.      688B    21.2 
#>  6 base_plain      772.88ns 800.94ns  1135180.        0B     0   
#>  7 cli_vec_ansi     24.66µs  25.77µs    38282.      448B     7.66
#>  8 fansi_vec_ansi   90.92µs  99.94µs     9816.    5.02KB    14.7 
#>  9 base_vec_ansi    12.54µs  12.72µs    77307.      448B     7.73
#> 10 cli_vec_plain    23.69µs  24.73µs    39865.      448B     3.99
#> 11 fansi_vec_plain  82.16µs  90.52µs    10819.    5.02KB    19.1 
#> 12 base_vec_plain    7.49µs   7.59µs   129670.      448B     0   
#> 13 cli_txt_ansi     24.88µs  25.92µs    38110.        0B     7.62
#> 14 fansi_txt_ansi   82.55µs  88.57µs    11045.      688B    18.9 
#> 15 base_txt_ansi    13.26µs  13.43µs    73913.        0B     0   
#> 16 cli_txt_plain    23.04µs  24.02µs    40958.        0B     8.19
#> 17 fansi_txt_plain  73.24µs  77.85µs    12492.      688B    19.1 
#> 18 base_txt_plain    7.15µs    7.2µs   136437.        0B     0
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
#>  1 cli_ansi          7.42µs    7.8µs   124319.        0B    24.9 
#>  2 fansi_ansi       70.31µs   74.5µs    13079.      688B    21.0 
#>  3 base_ansi         1.15µs   1.21µs   776573.        0B    77.7 
#>  4 cli_plain         7.39µs   7.82µs   122157.        0B    24.4 
#>  5 fansi_plain      70.21µs  75.31µs    12939.      688B    21.1 
#>  6 base_plain      949.95ns      1µs   887596.        0B     0   
#>  7 cli_vec_ansi     30.47µs  31.58µs    31265.      448B     9.38
#>  8 fansi_vec_ansi   93.01µs 101.24µs     9716.    5.02KB    14.6 
#>  9 base_vec_ansi     37.7µs  40.76µs    24412.      448B     2.44
#> 10 cli_vec_plain    29.46µs  30.87µs    31985.      448B     6.40
#> 11 fansi_vec_plain  83.56µs  92.36µs    10601.    5.02KB    16.8 
#> 12 base_vec_plain   19.55µs  21.55µs    46390.      448B     0   
#> 13 cli_txt_ansi     30.61µs  31.71µs    31109.        0B     9.34
#> 14 fansi_txt_ansi   84.49µs  90.29µs    10838.      688B    16.7 
#> 15 base_txt_ansi    39.46µs   42.2µs    23608.        0B     2.36
#> 16 cli_txt_plain     29.1µs  30.56µs    32344.        0B     6.47
#> 17 fansi_txt_plain  75.84µs  81.11µs    12035.      688B    18.8 
#> 18 base_txt_plain   21.27µs  22.95µs    43356.        0B     4.34
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
#> 1 cli_ansi        6.03µs   6.52µs   146250.        0B    29.3 
#> 2 cli_plain       5.74µs   6.17µs   155878.        0B    15.6 
#> 3 cli_vec_ansi   29.57µs  30.51µs    32297.      848B     6.46
#> 4 cli_vec_plain   9.24µs   9.91µs    97904.      848B    19.6 
#> 5 cli_txt_ansi   29.23µs  30.29µs    32509.        0B     3.25
#> 6 cli_txt_plain   6.58µs   7.04µs   136348.        0B    27.3
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
#>  1 cli_ansi          22.9µs   24.4µs    39538.        0B     31.7
#>  2 fansi_ansi        24.7µs   26.2µs    36791.    7.24KB     29.5
#>  3 cli_plain         22.3µs   24.2µs    39563.        0B     31.7
#>  4 fansi_plain         24µs   25.6µs    37659.      688B     30.2
#>  5 cli_vec_ansi      31.1µs     33µs    29542.      848B     23.7
#>  6 fansi_vec_ansi    48.4µs   50.5µs    19326.    5.41KB     14.3
#>  7 cli_vec_plain     24.9µs   26.2µs    36996.      848B     29.6
#>  8 fansi_vec_plain   32.5µs   34.3µs    28423.    4.59KB     22.8
#>  9 cli_txt_ansi      30.8µs   32.7µs    28459.        0B     22.8
#> 10 fansi_txt_ansi    39.6µs   42.1µs    23120.    5.12KB     18.5
#> 11 cli_txt_plain     23.4µs   24.9µs    38864.        0B     27.2
#> 12 fansi_txt_plain     25µs   26.4µs    36635.      688B     25.7
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
#>  1 cli_ansi        130.04µs  140.9µs     6905.  104.34KB    23.4 
#>  2 fansi_ansi         104µs 114.06µs     8417.  106.35KB    23.5 
#>  3 base_ansi          3.9µs   4.23µs   229380.      224B    22.9 
#>  4 cli_plain       128.21µs 138.33µs     7004.    8.09KB    23.3 
#>  5 fansi_plain      102.2µs 111.56µs     8784.    9.62KB    23.5 
#>  6 base_plain         3.5µs   3.67µs   259876.        0B     0   
#>  7 cli_vec_ansi       6.3ms   6.37ms      155.  823.77KB    30.5 
#>  8 fansi_vec_ansi  976.17µs   1.03ms      951.  846.81KB    19.7 
#>  9 base_vec_ansi    142.9µs 151.38µs     6341.    22.7KB     2.04
#> 10 cli_vec_plain     6.23ms   6.41ms      153.  823.77KB    22.7 
#> 11 fansi_vec_plain 916.41µs 962.69µs     1014.  845.98KB    17.4 
#> 12 base_vec_plain   100.7µs 105.88µs     9323.      848B     4.06
#> 13 cli_txt_ansi      2.91ms   2.96ms      337.    63.6KB     0   
#> 14 fansi_txt_ansi    1.42ms   1.44ms      690.   35.05KB     0   
#> 15 base_txt_ansi   119.54µs 128.17µs     7767.   18.47KB     4.08
#> 16 cli_txt_plain     2.04ms   2.07ms      478.    63.6KB     0   
#> 17 fansi_txt_plain 486.08µs 509.46µs     1951.    30.6KB     2.02
#> 18 base_txt_plain   79.25µs  83.31µs    11830.   11.05KB     2.02
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
#>  1 cli_ansi        119.46µs 131.18µs     7527.   33.84KB    14.9 
#>  2 fansi_ansi        45.1µs   49.7µs    19714.   31.42KB    14.6 
#>  3 base_ansi         1.02µs   1.05µs   859585.     4.2KB     0   
#>  4 cli_plain       117.92µs 129.36µs     7623.        0B    16.7 
#>  5 fansi_plain      44.87µs  49.47µs    19819.      872B    14.6 
#>  6 base_plain      942.03ns 981.03ns   903796.        0B     0   
#>  7 cli_vec_ansi    235.65µs 250.27µs     3957.   16.73KB     8.28
#>  8 fansi_vec_ansi  100.28µs 106.04µs     9301.    5.59KB     8.27
#>  9 base_vec_ansi    33.26µs  34.54µs    28666.      848B     0   
#> 10 cli_vec_plain   194.42µs 207.34µs     4763.   16.73KB     8.30
#> 11 fansi_vec_plain  92.48µs  97.94µs    10054.    5.59KB    10.5 
#> 12 base_vec_plain   28.69µs  29.98µs    33043.      848B     0   
#> 13 cli_txt_ansi    127.71µs 139.45µs     7075.        0B    14.6 
#> 14 fansi_txt_ansi   45.23µs  49.88µs    19645.      872B    14.6 
#> 15 base_txt_ansi     1.05µs   1.08µs   879375.        0B     0   
#> 16 cli_txt_plain   120.08µs 131.11µs     7518.        0B    14.5 
#> 17 fansi_txt_plain  44.97µs  49.55µs    19775.      872B    14.6 
#> 18 base_txt_plain  972.07ns   1.01µs   883154.        0B     0
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
#>  1 cli_ansi        339.25µs  363.9µs    2728.         0B    14.6 
#>  2 fansi_ansi       80.69µs  88.12µs   11130.    97.32KB    12.6 
#>  3 base_ansi        32.99µs  35.44µs   27592.         0B    13.8 
#>  4 cli_plain       217.67µs 237.28µs    4178.         0B    12.4 
#>  5 fansi_plain      79.99µs  87.03µs   11286.       872B    14.6 
#>  6 base_plain       27.14µs  28.09µs   34567.         0B    13.8 
#>  7 cli_vec_ansi     34.42ms  34.65ms      28.8    2.48KB    28.8 
#>  8 fansi_vec_ansi  205.37µs  212.4µs    4648.     7.25KB     6.14
#>  9 base_vec_ansi     2.13ms   2.18ms     457.    48.18KB    15.0 
#> 10 cli_vec_plain     22.4ms  23.59ms      42.6    2.48KB    17.0 
#> 11 fansi_vec_plain  165.1µs 174.84µs    5638.     6.42KB     8.23
#> 12 base_vec_plain    1.56ms   1.66ms     603.     47.4KB    12.7 
#> 13 cli_txt_ansi     21.66ms  22.23ms      45.2  507.59KB     6.78
#> 14 fansi_txt_ansi   194.3µs 203.79µs    4854.     6.77KB     6.12
#> 15 base_txt_ansi     1.23ms   1.31ms     758.   582.06KB    10.8 
#> 16 cli_txt_plain      1.2ms   1.26ms     783.   369.84KB     8.56
#> 17 fansi_txt_plain 151.12µs 160.06µs    6154.     2.51KB     8.24
#> 18 base_txt_plain  822.77µs 892.13µs    1110.   367.31KB    10.9
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
#>  1 cli_ansi           6.3µs   7.03µs   134564.   24.83KB    13.5 
#>  2 fansi_ansi       65.45µs  71.46µs    13681.   28.48KB    14.9 
#>  3 base_ansi       957.05ns 991.98ns   931857.        0B     0   
#>  4 cli_plain         6.18µs   6.89µs   137513.        0B    13.8 
#>  5 fansi_plain      65.71µs  71.22µs    13729.    1.98KB    12.5 
#>  6 base_plain      925.04ns 964.03ns   926618.        0B    92.7 
#>  7 cli_vec_ansi     24.27µs  27.18µs    36739.     1.7KB     3.67
#>  8 fansi_vec_ansi   98.07µs 104.32µs     9345.    8.86KB     8.30
#>  9 base_vec_ansi     6.01µs    6.3µs   153985.      848B    15.4 
#> 10 cli_vec_plain    20.53µs  21.64µs    45376.     1.7KB     4.54
#> 11 fansi_vec_plain  92.38µs   98.3µs     9912.    8.86KB    10.5 
#> 12 base_vec_plain    5.22µs   5.42µs   180515.      848B     0   
#> 13 cli_txt_ansi      6.35µs      7µs   136746.        0B    13.7 
#> 14 fansi_txt_ansi   65.95µs  71.35µs    13630.    1.98KB    12.5 
#> 15 base_txt_ansi     4.84µs   4.92µs   196136.        0B    19.6 
#> 16 cli_txt_plain     6.98µs    7.7µs   124499.        0B    12.5 
#> 17 fansi_txt_plain  65.88µs  71.03µs    13707.    1.98KB    12.5 
#> 18 base_txt_plain    3.18µs   3.23µs   296524.        0B     0
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
#>  1 cli_ansi        83.83µs  95.99µs   10366.    11.88KB    10.3 
#>  2 base_ansi        1.15µs   1.21µs  774612.         0B    77.5 
#>  3 cli_plain       66.79µs  72.26µs   13541.     8.73KB     8.20
#>  4 base_plain     900.01ns 930.97ns  992374.         0B    99.2 
#>  5 cli_vec_ansi     3.88ms   4.18ms     243.   838.77KB    15.4 
#>  6 base_vec_ansi   61.39µs   64.8µs   15367.       848B     0   
#>  7 cli_vec_plain    2.18ms   2.27ms     434.    816.9KB    15.0 
#>  8 base_vec_plain  37.64µs  39.35µs   25242.       848B     0   
#>  9 cli_txt_ansi    12.47ms  12.56ms      79.5  114.42KB     4.18
#> 10 base_txt_ansi    64.4µs     66µs   14976.         0B     0   
#> 11 cli_txt_plain  217.57µs 229.14µs    4332.    18.16KB     2.01
#> 12 base_txt_plain  33.16µs  35.76µs   27946.         0B     2.79
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
#>  1 cli_ansi         85.4µs   88.6µs    10931.        0B    14.5 
#>  2 base_ansi        14.8µs   15.4µs    62878.        0B    18.9 
#>  3 cli_plain        85.2µs   89.9µs    10762.        0B    14.7 
#>  4 base_plain       14.7µs     16µs    61236.        0B    12.2 
#>  5 cli_vec_ansi    167.7µs    179µs     5525.     7.2KB     8.24
#>  6 base_vec_ansi    51.7µs   56.1µs    17665.    1.66KB     4.06
#>  7 cli_vec_plain   155.3µs  166.2µs     5946.     7.2KB     8.25
#>  8 base_vec_plain   47.1µs   51.5µs    19212.    1.66KB     4.06
#>  9 cli_txt_ansi      144µs  152.6µs     6486.        0B     8.19
#> 10 base_txt_ansi    34.5µs   35.9µs    27513.        0B     8.26
#> 11 cli_txt_plain   128.6µs    137µs     7219.        0B    10.3 
#> 12 base_txt_plain   30.1µs   31.5µs    31330.        0B     6.27
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
#> 1 cli          7.21µs   7.93µs   121617.        0B    12.2 
#> 2 base       816.07ns 862.05ns   951544.        0B     0   
#> 3 cli_vec     21.41µs   22.7µs    43158.      448B     8.63
#> 4 base_vec       11µs  11.26µs    87730.      448B     0   
#> 5 cli_txt     21.36µs  22.26µs    44150.        0B     4.42
#> 6 base_txt    11.81µs  12.16µs    80961.        0B     0
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
#> 1 cli          7.15µs   7.93µs   120940.        0B    24.2 
#> 2 base         1.28µs   1.35µs   694286.        0B     0   
#> 3 cli_vec     23.79µs  24.94µs    39418.      448B     3.94
#> 4 base_vec    51.53µs  52.03µs    19031.      448B     0   
#> 5 cli_txt     23.96µs  24.94µs    39481.        0B     3.95
#> 6 base_txt    84.66µs  85.31µs    11631.        0B     0
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
#> 1 cli          7.52µs   8.29µs   116155.        0B    11.6 
#> 2 base       821.89ns 868.92ns   949877.        0B     0   
#> 3 cli_vec     17.95µs  19.29µs    51081.      448B     5.11
#> 4 base_vec    10.99µs  11.26µs    87331.      448B     8.73
#> 5 cli_txt     18.73µs  19.58µs    50233.        0B     5.02
#> 6 base_txt    11.87µs  12.17µs    81038.        0B     0
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
#> 1 cli          5.93µs    6.6µs   143982.    22.1KB    28.8 
#> 2 base       990.93ns   1.03µs   902682.        0B     0   
#> 3 cli_vec     27.87µs  29.15µs    33789.     1.7KB     3.38
#> 4 base_vec     7.77µs   8.03µs   122545.      848B     0   
#> 5 cli_txt      5.95µs   6.66µs   143759.        0B    28.8 
#> 6 base_txt     5.05µs   5.18µs   189394.        0B     0
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
#>  date     2026-04-08
#>  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.10.0     2026-01-26 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.5.9000 2026-04-08 [1] local
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
