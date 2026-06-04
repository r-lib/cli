# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x555e7a492c10\>
\<environment: 0x555e7af37908\>

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
#> 1 ansi         44.1µs   47.6µs    20444.    99.6KB     20.9
#> 2 plain        43.9µs     47µs    20385.        0B     19.6
#> 3 base         11.5µs   12.5µs    77761.    48.6KB     15.6
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
#> 1 ansi         46.4µs   49.5µs    19475.        0B     23.2
#> 2 plain        46.2µs   49.2µs    19722.        0B     23.1
#> 3 base         13.2µs   14.2µs    68433.        0B     20.5
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
#> 1 ansi       114.12µs 121.34µs     7995.   77.03KB     16.6
#> 2 plain       91.82µs  97.11µs     9982.    8.91KB     14.5
#> 3 base         1.83µs   1.96µs   497673.        0B      0
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
#> 1 ansi          326µs    350µs     2820.   33.23KB     21.0
#> 2 plain         328µs    350µs     2830.    1.09KB     21.1
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
#>  1 cli_ansi          5.67µs   6.19µs   156112.    9.27KB    31.2 
#>  2 fansi_ansi       30.44µs  33.38µs    29154.    4.18KB    26.3 
#>  3 cli_plain          5.6µs   6.05µs   141934.        0B    14.2 
#>  4 fansi_plain      30.21µs  32.02µs    30231.      688B    12.1 
#>  5 cli_vec_ansi      7.17µs   7.57µs   128812.      448B    12.9 
#>  6 fansi_vec_ansi   40.38µs  42.57µs    22699.    5.02KB     9.08
#>  7 cli_vec_plain     7.64µs   8.06µs   120850.      448B    12.1 
#>  8 fansi_vec_plain  37.95µs  40.13µs    24084.    5.02KB    12.0 
#>  9 cli_txt_ansi      5.54µs   5.89µs   165075.        0B    16.5 
#> 10 fansi_txt_ansi   29.97µs  31.98µs    30116.      688B    12.1 
#> 11 cli_txt_plain     6.42µs   6.82µs   140462.        0B    14.0 
#> 12 fansi_txt_plain  37.77µs  40.01µs    24302.    5.02KB     9.72
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
#> 1 cli          58.9µs   60.6µs    16159.    22.7KB     4.04
#> 2 fansi       118.2µs    125µs     7879.    55.3KB     4.05
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
#>  1 cli_ansi          7.05µs   7.64µs   127137.        0B    12.7 
#>  2 fansi_ansi        90.1µs  94.52µs    10261.   38.84KB    10.2 
#>  3 base_ansi       882.08ns 940.99ns  1008123.        0B     0   
#>  4 cli_plain         6.91µs   7.43µs   130670.        0B    13.1 
#>  5 fansi_plain      89.28µs  94.22µs    10324.      688B     8.17
#>  6 base_plain      811.07ns 861.01ns  1082404.        0B   108.  
#>  7 cli_vec_ansi     28.08µs  28.92µs    33863.      448B     3.39
#>  8 fansi_vec_ansi  110.52µs  115.3µs     8430.    5.02KB     6.13
#>  9 base_vec_ansi     17.2µs  17.26µs    57053.      448B     0   
#> 10 cli_vec_plain    26.89µs  27.54µs    35590.      448B     3.56
#> 11 fansi_vec_plain 100.66µs 105.49µs     9156.    5.02KB     8.23
#> 12 base_vec_plain   10.13µs  10.19µs    96520.      448B     0   
#> 13 cli_txt_ansi     28.08µs  28.76µs    34050.        0B     3.41
#> 14 fansi_txt_ansi  102.13µs 107.26µs     9064.      688B     8.18
#> 15 base_txt_ansi    16.88µs  16.94µs    58135.        0B     0   
#> 16 cli_txt_plain    26.21µs   26.9µs    36326.        0B     3.63
#> 17 fansi_txt_plain  92.02µs  96.38µs    10055.      688B    10.4 
#> 18 base_txt_plain   10.31µs  10.36µs    95067.        0B     0
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
#>  1 cli_ansi           8.6µs   9.45µs   102705.        0B    10.3 
#>  2 fansi_ansi       90.51µs  95.12µs    10195.      688B    10.3 
#>  3 base_ansi          1.2µs   1.25µs   765564.        0B     0   
#>  4 cli_plain         8.54µs    9.2µs   106017.        0B    10.6 
#>  5 fansi_plain      89.37µs  94.22µs    10301.      688B     8.16
#>  6 base_plain           1µs   1.04µs   905500.        0B    90.6 
#>  7 cli_vec_ansi      34.4µs  35.13µs    27936.      448B     2.79
#>  8 fansi_vec_ansi  113.31µs 117.95µs     8221.    5.02KB     6.13
#>  9 base_vec_ansi    40.98µs  41.32µs    23693.      448B     2.37
#> 10 cli_vec_plain    33.27µs  34.15µs    28690.      448B     2.87
#> 11 fansi_vec_plain 102.86µs  108.1µs     8863.    5.02KB     8.23
#> 12 base_vec_plain   21.66µs     22µs    44804.      448B     0   
#> 13 cli_txt_ansi      34.8µs   35.6µs    27439.        0B     2.74
#> 14 fansi_txt_ansi  105.18µs 110.36µs     8796.      688B     8.18
#> 15 base_txt_ansi     43.2µs  44.09µs    22397.        0B     0   
#> 16 cli_txt_plain    32.92µs  33.73µs    29037.        0B     2.90
#> 17 fansi_txt_plain  94.82µs   99.8µs     9667.      688B     8.17
#> 18 base_txt_plain   23.15µs  23.82µs    41277.        0B     0
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
#> 1 cli_ansi        6.86µs   7.44µs   127952.        0B    12.8 
#> 2 cli_plain       6.36µs   6.91µs   140599.        0B     0   
#> 3 cli_vec_ansi   33.08µs  33.87µs    28935.      848B     2.89
#> 4 cli_vec_plain  10.47µs  11.08µs    87860.      848B     8.79
#> 5 cli_txt_ansi    32.4µs  33.16µs    29541.        0B     2.95
#> 6 cli_txt_plain   7.31µs   7.83µs   124018.        0B    12.4
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
#>  1 cli_ansi          25.2µs   27.2µs    35783.        0B    17.9 
#>  2 fansi_ansi        28.2µs   30.1µs    32185.    7.24KB    12.9 
#>  3 cli_plain           25µs   26.6µs    36620.        0B    14.7 
#>  4 fansi_plain       27.8µs   29.5µs    32860.      688B    13.1 
#>  5 cli_vec_ansi      34.5µs   36.2µs    26822.      848B    10.7 
#>  6 fansi_vec_ansi    55.1µs   57.4µs    16954.    5.41KB     9.44
#>  7 cli_vec_plain     27.6µs   28.9µs    33516.      848B    13.4 
#>  8 fansi_vec_plain   36.8µs   38.5µs    25218.    4.59KB    10.1 
#>  9 cli_txt_ansi      33.4µs   34.8µs    27788.        0B    11.1 
#> 10 fansi_txt_ansi    43.9µs   45.2µs    21437.    5.12KB     8.58
#> 11 cli_txt_plain     25.6µs   26.8µs    36311.        0B    18.2 
#> 12 fansi_txt_plain   28.9µs   30.5µs    31810.      688B    12.7
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
#>  1 cli_ansi        156.38µs 167.26µs     5722.  104.86KB    10.3 
#>  2 fansi_ansi      126.26µs 133.06µs     7280.  106.35KB    10.3 
#>  3 base_ansi         4.05µs   4.39µs   222757.      224B     0   
#>  4 cli_plain       159.36µs 166.72µs     5839.    8.09KB    10.3 
#>  5 fansi_plain     125.81µs 132.34µs     7336.    9.62KB    12.5 
#>  6 base_plain        3.49µs   3.72µs   261917.        0B     0   
#>  7 cli_vec_ansi      7.47ms    7.6ms      131.  823.77KB    13.6 
#>  8 fansi_vec_ansi    1.03ms   1.06ms      921.  846.81KB    17.1 
#>  9 base_vec_ansi   157.81µs 162.11µs     6035.    22.7KB     2.03
#> 10 cli_vec_plain     7.43ms   7.63ms      131.  823.77KB    11.5 
#> 11 fansi_vec_plain 959.05µs 994.64µs      952.  845.98KB    19.3 
#> 12 base_vec_plain  107.03µs  111.9µs     8755.      848B     4.05
#> 13 cli_txt_ansi      3.18ms   3.22ms      310.    63.6KB     0   
#> 14 fansi_txt_ansi    1.57ms   1.58ms      630.   35.05KB     0   
#> 15 base_txt_ansi   137.76µs  145.6µs     6759.   18.47KB     2.02
#> 16 cli_txt_plain     2.35ms   2.37ms      421.    63.6KB     2.00
#> 17 fansi_txt_plain 512.18µs 530.64µs     1878.    30.6KB     2.02
#> 18 base_txt_plain   89.59µs  92.34µs    10645.   11.05KB     2.02
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
#>  1 cli_ansi        147.15µs 153.45µs     6334.   33.84KB    12.4 
#>  2 fansi_ansi       54.45µs  57.95µs    16759.   31.42KB    12.4 
#>  3 base_ansi         1.05µs   1.09µs   861435.     4.2KB     0   
#>  4 cli_plain       142.56µs 150.84µs     6451.        0B    12.4 
#>  5 fansi_plain      52.65µs   56.8µs    16837.      872B    12.7 
#>  6 base_plain      971.02ns   1.02µs   919022.        0B     0   
#>  7 cli_vec_ansi    268.55µs 277.98µs     3526.   16.73KB     6.13
#>  8 fansi_vec_ansi  113.67µs 117.41µs     8324.    5.59KB     8.24
#>  9 base_vec_ansi     35.7µs   36.3µs    27153.      848B     0   
#> 10 cli_vec_plain   228.03µs 236.68µs     4143.   16.73KB     8.26
#> 11 fansi_vec_plain 106.91µs 110.78µs     8807.    5.59KB     6.13
#> 12 base_vec_plain   30.16µs  31.49µs    31421.      848B     3.14
#> 13 cli_txt_ansi    153.95µs 161.74µs     6017.        0B    11.8 
#> 14 fansi_txt_ansi   52.77µs     55µs    17646.      872B    12.4 
#> 15 base_txt_ansi     1.08µs   1.12µs   862571.        0B     0   
#> 16 cli_txt_plain   143.23µs 148.95µs     6548.        0B    12.3 
#> 17 fansi_txt_plain  52.77µs  55.06µs    17662.      872B    12.4 
#> 18 base_txt_plain  991.16ns   1.04µs   920932.        0B     0
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
#>  1 cli_ansi        412.61µs 436.79µs    2279.     6.18KB    10.3 
#>  2 fansi_ansi       97.38µs 102.91µs    9470.    97.33KB    12.4 
#>  3 base_ansi        38.24µs  40.66µs   23907.         0B     9.57
#>  4 cli_plain       267.07µs 280.85µs    3479.         0B    12.4 
#>  5 fansi_plain      95.39µs 101.78µs    9562.       872B    10.3 
#>  6 base_plain       31.54µs  33.39µs   28932.         0B    11.6 
#>  7 cli_vec_ansi     43.12ms   43.5ms      23.0   94.67KB    23.0 
#>  8 fansi_vec_ansi  235.81µs 244.31µs    4008.     7.25KB     6.13
#>  9 base_vec_ansi     2.19ms   2.28ms     435.    48.18KB    12.9 
#> 10 cli_vec_plain    28.07ms  28.14ms      35.3    2.48KB    13.6 
#> 11 fansi_vec_plain 190.48µs 196.88µs    4973.     6.42KB     8.21
#> 12 base_vec_plain    1.64ms    1.7ms     586.     47.4KB    12.8 
#> 13 cli_txt_ansi     26.89ms  27.11ms      36.8    4.27MB     4.33
#> 14 fansi_txt_ansi  226.31µs 235.24µs    4169.     6.77KB     6.13
#> 15 base_txt_ansi     1.25ms   1.28ms     768.   582.06KB    11.2 
#> 16 cli_txt_plain     1.27ms   1.31ms     749.   369.84KB     8.66
#> 17 fansi_txt_plain 177.37µs 185.16µs    5284.     2.51KB     6.13
#> 18 base_txt_plain  831.23µs 865.58µs    1135.   367.31KB    10.9
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
#>  1 cli_ansi           6.6µs   7.34µs   131142.   25.09KB    13.1 
#>  2 fansi_ansi       78.42µs  83.19µs    11649.   28.48KB    12.5 
#>  3 base_ansi         1.02µs   1.07µs   888046.        0B     0   
#>  4 cli_plain         6.58µs   7.15µs   134672.        0B    13.5 
#>  5 fansi_plain      78.08µs  83.25µs    11661.    1.98KB    10.3 
#>  6 base_plain      972.07ns   1.04µs   878925.        0B    87.9 
#>  7 cli_vec_ansi     26.41µs  27.34µs    35767.     1.7KB     3.58
#>  8 fansi_vec_ansi  114.75µs 120.04µs     8102.    8.86KB     8.29
#>  9 base_vec_ansi     6.05µs    6.3µs   155893.      848B     0   
#> 10 cli_vec_plain    22.83µs  23.63µs    41321.     1.7KB     4.13
#> 11 fansi_vec_plain  107.7µs 113.01µs     8626.    8.86KB     7.11
#> 12 base_vec_plain    5.67µs      6µs   163112.      848B    16.3 
#> 13 cli_txt_ansi      6.54µs   6.97µs   139738.        0B    14.0 
#> 14 fansi_txt_ansi   76.49µs  79.81µs    12166.    1.98KB    10.3 
#> 15 base_txt_ansi     6.45µs    6.5µs   150765.        0B    15.1 
#> 16 cli_txt_plain     7.38µs   7.79µs   125064.        0B    12.5 
#> 17 fansi_txt_plain  76.74µs  79.54µs    12222.    1.98KB    12.4 
#> 18 base_txt_plain     4.1µs   4.14µs   236263.        0B     0
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
#>  1 cli_ansi       109.28µs 113.57µs    8503.     12.1KB     8.20
#>  2 base_ansi         1.3µs   1.34µs  722672.         0B     0   
#>  3 cli_plain       88.55µs  92.53µs   10445.     8.91KB     8.28
#>  4 base_plain     991.98ns   1.04µs  915631.         0B     0   
#>  5 cli_vec_ansi     4.13ms   4.27ms     234.   838.95KB    15.5 
#>  6 base_vec_ansi   71.85µs  72.09µs   13688.       848B     0   
#>  7 cli_vec_plain    2.33ms   2.38ms     417.   817.08KB    15.0 
#>  8 base_vec_plain  42.45µs  42.99µs   22918.       848B     0   
#>  9 cli_txt_ansi    14.33ms  14.41ms      69.3   114.6KB     2.04
#> 10 base_txt_ansi    72.2µs  73.92µs   13225.         0B     0   
#> 11 cli_txt_plain  304.37µs 312.47µs    3138.    18.34KB     4.05
#> 12 base_txt_plain  39.85µs  41.73µs   23671.         0B     0
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
#>  1 cli_ansi          106µs  111.7µs     8683.        0B    12.4 
#>  2 base_ansi        16.2µs   17.3µs    56165.        0B    11.2 
#>  3 cli_plain       105.1µs  110.3µs     8764.        0B    12.4 
#>  4 base_plain         16µs   17.2µs    56440.        0B    11.3 
#>  5 cli_vec_ansi    204.3µs  211.5µs     4615.     7.2KB     6.11
#>  6 base_vec_ansi    59.2µs   64.1µs    15381.    1.66KB     4.05
#>  7 cli_vec_plain     189µs  199.5µs     4903.     7.2KB     6.21
#>  8 base_vec_plain     52µs   57.2µs    17314.    1.66KB     4.06
#>  9 cli_txt_ansi    177.4µs  183.4µs     5320.        0B     6.09
#> 10 base_txt_ansi    40.4µs   41.5µs    23570.        0B     4.72
#> 11 cli_txt_plain   161.8µs    167µs     5831.        0B     8.16
#> 12 base_txt_plain   34.9µs   36.1µs    26682.        0B     5.34
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
#> 1 cli           8.2µs    8.8µs   110485.        0B    11.0 
#> 2 base          851ns  901.1ns  1032605.        0B     0   
#> 3 cli_vec      23.2µs   23.9µs    41037.      448B     4.10
#> 4 base_vec     11.7µs   11.8µs    83204.      448B     0   
#> 5 cli_txt      23.4µs     24µs    40800.        0B     8.16
#> 6 base_txt     12.6µs   12.7µs    77730.        0B     0
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
#> 1 cli          8.11µs   8.79µs   110497.        0B    11.1 
#> 2 base         1.28µs   1.33µs   718149.        0B     0   
#> 3 cli_vec     28.57µs  29.43µs    33286.      448B     3.33
#> 4 base_vec     50.7µs  51.36µs    19249.      448B     2.02
#> 5 cli_txt     28.92µs  29.76µs    32906.        0B     3.29
#> 6 base_txt    86.47µs  87.82µs    11283.        0B     0
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
#> 1 cli          8.84µs   9.47µs   102669.        0B    10.3 
#> 2 base       861.01ns  902.1ns  1017298.        0B   102.  
#> 3 cli_vec     19.78µs  20.54µs    47616.      448B     4.76
#> 4 base_vec    11.62µs  11.85µs    83036.      448B     0   
#> 5 cli_txt     20.53µs  21.18µs    46258.        0B     4.63
#> 6 base_txt    12.58µs  12.68µs    77497.        0B     7.75
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
#> 1 cli          6.32µs   6.83µs   141891.    22.2KB    14.2 
#> 2 base         1.03µs   1.08µs   871165.        0B     0   
#> 3 cli_vec     30.39µs  31.26µs    31225.     1.7KB     3.12
#> 4 base_vec      8.3µs   8.54µs   114929.      848B    11.5 
#> 5 cli_txt      6.23µs   6.72µs   144837.        0B    14.5 
#> 6 base_txt     5.69µs   5.76µs   170466.        0B     0
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
