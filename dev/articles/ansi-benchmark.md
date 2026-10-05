# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55903e7ab8a0\>
\<environment: 0x55903f2d74a0\>

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
#> 1 ansi         45.8µs   49.3µs    19565.    99.6KB     21.2
#> 2 plain        46.4µs   49.6µs    19307.        0B     22.2
#> 3 base         11.5µs   12.7µs    75643.    48.6KB     15.1
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
#> 1 ansi         47.9µs   51.2µs    18839.        0B     21.5
#> 2 plain        47.4µs   50.9µs    18940.        0B     23.5
#> 3 base         13.4µs   14.8µs    65243.        0B     26.1
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
#> 1 ansi       118.21µs 125.69µs     7662.   77.03KB     14.7
#> 2 plain        94.2µs 100.15µs     9623.    8.91KB     14.7
#> 3 base         1.89µs   2.02µs   471226.        0B     47.1
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
#> 1 ansi          345µs    370µs     2665.   33.24KB     19.2
#> 2 plain         347µs    370µs     2664.    1.09KB     19.2
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
#>  1 cli_ansi          5.92µs   6.52µs   147401.    9.27KB    29.5 
#>  2 fansi_ansi       31.52µs  34.56µs    27854.    4.18KB    25.1 
#>  3 cli_plain         5.86µs   6.49µs   148268.        0B    29.7 
#>  4 fansi_plain      30.65µs  33.11µs    28583.      688B    11.4 
#>  5 cli_vec_ansi      7.22µs   7.71µs   125555.      448B    12.6 
#>  6 fansi_vec_ansi   40.92µs  43.63µs    21784.    5.02KB    10.9 
#>  7 cli_vec_plain     7.84µs   8.37µs   116245.      448B    11.6 
#>  8 fansi_vec_plain  38.81µs  41.47µs    23326.    5.02KB     9.33
#>  9 cli_txt_ansi      5.85µs    6.3µs   152586.        0B    15.3 
#> 10 fansi_txt_ansi   31.15µs  33.25µs    28978.      688B    11.6 
#> 11 cli_txt_plain     6.64µs   7.12µs   136245.        0B    13.6 
#> 12 fansi_txt_plain  38.94µs  41.72µs    23051.    5.02KB    11.5
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
#> 1 cli          56.6µs   58.7µs    16507.    22.7KB     4.06
#> 2 fansi         119µs  125.2µs     7780.    55.3KB     4.06
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
#>  1 cli_ansi          6.95µs   7.57µs   127834.        0B     0   
#>  2 fansi_ansi        92.3µs  97.89µs     9860.   38.84KB    10.3 
#>  3 base_ansi       922.01ns 972.07ns   961727.        0B     0   
#>  4 cli_plain         6.87µs   7.56µs   128011.        0B    12.8 
#>  5 fansi_plain       92.1µs  97.31µs     9801.      688B     8.21
#>  6 base_plain      842.03ns 891.97ns  1031524.        0B     0   
#>  7 cli_vec_ansi     29.33µs   30.3µs    32349.      448B     3.24
#>  8 fansi_vec_ansi   113.5µs 119.37µs     8091.    5.02KB     6.17
#>  9 base_vec_ansi    18.47µs  18.61µs    52734.      448B     5.27
#> 10 cli_vec_plain     28.1µs  28.89µs    33895.      448B     3.39
#> 11 fansi_vec_plain  104.5µs 109.94µs     8789.    5.02KB     6.17
#> 12 base_vec_plain   10.81µs  10.89µs    90211.      448B     0   
#> 13 cli_txt_ansi     29.34µs  30.09µs    32555.        0B     3.26
#> 14 fansi_txt_ansi  104.89µs 110.58µs     8737.      688B     8.22
#> 15 base_txt_ansi    18.22µs  18.29µs    53803.        0B     0   
#> 16 cli_txt_plain    27.63µs  28.47µs    34418.        0B     3.44
#> 17 fansi_txt_plain  94.43µs 100.02µs     9655.      688B     8.22
#> 18 base_txt_plain   11.08µs  11.13µs    88256.        0B     0
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
#>  1 cli_ansi          8.55µs   9.31µs   104080.        0B    10.4 
#>  2 fansi_ansi       93.23µs  98.43µs     9820.      688B     8.32
#>  3 base_ansi         1.24µs    1.3µs   716974.        0B     0   
#>  4 cli_plain         8.57µs   9.34µs   103694.        0B    10.4 
#>  5 fansi_plain      92.55µs  97.61µs     9902.      688B    10.3 
#>  6 base_plain        1.02µs   1.07µs   865124.        0B     0   
#>  7 cli_vec_ansi     34.68µs  35.72µs    27376.      448B     2.74
#>  8 fansi_vec_ansi  116.28µs 121.55µs     7953.    5.02KB     6.15
#>  9 base_vec_ansi    44.06µs   44.5µs    22183.      448B     0   
#> 10 cli_vec_plain    33.32µs   34.3µs    28448.      448B     5.69
#> 11 fansi_vec_plain 106.66µs 111.84µs     8621.    5.02KB     6.16
#> 12 base_vec_plain   22.98µs  23.24µs    42444.      448B     0   
#> 13 cli_txt_ansi     34.98µs  35.85µs    27264.        0B     5.45
#> 14 fansi_txt_ansi  107.49µs 112.98µs     8548.      688B     6.12
#> 15 base_txt_ansi    46.92µs  47.23µs    20922.        0B     0   
#> 16 cli_txt_plain    32.82µs  33.71µs    28984.        0B     5.80
#> 17 fansi_txt_plain  97.74µs 103.19µs     9309.      688B     8.22
#> 18 base_txt_plain   24.89µs  25.34µs    38854.        0B     0
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
#> 1 cli_ansi        6.87µs   7.43µs   129324.        0B    12.9 
#> 2 cli_plain       6.39µs   6.95µs   138131.        0B    13.8 
#> 3 cli_vec_ansi   32.03µs  33.08µs    29550.      848B     2.96
#> 4 cli_vec_plain  10.38µs  11.14µs    87046.      848B     8.71
#> 5 cli_txt_ansi   31.45µs  32.85µs    29726.        0B     0   
#> 6 cli_txt_plain   7.21µs   7.88µs   122969.        0B    12.3
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
#>  1 cli_ansi          26.3µs   27.9µs    34641.        0B    13.9 
#>  2 fansi_ansi        28.9µs   30.8µs    31281.    7.24KB    12.5 
#>  3 cli_plain         25.9µs   27.6µs    34998.        0B    14.0 
#>  4 fansi_plain       28.2µs   30.4µs    31728.      688B    12.7 
#>  5 cli_vec_ansi      35.2µs   37.1µs    26101.      848B    10.4 
#>  6 fansi_vec_ansi    55.7µs   58.6µs    16575.    5.41KB     8.33
#>  7 cli_vec_plain     28.5µs   30.4µs    31774.      848B    12.7 
#>  8 fansi_vec_plain   37.6µs   39.5µs    24521.    4.59KB     9.89
#>  9 cli_txt_ansi      34.3µs   35.6µs    27243.        0B    10.9 
#> 10 fansi_txt_ansi    44.6µs   46.2µs    21042.    5.12KB     8.42
#> 11 cli_txt_plain     26.7µs   27.9µs    34764.        0B    17.4 
#> 12 fansi_txt_plain   29.4µs   30.8µs    31367.      688B    12.6
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
#>  1 cli_ansi        166.19µs 174.88µs     5534.  104.86KB    10.3 
#>  2 fansi_ansi      131.26µs 139.04µs     7002.  106.35KB     8.26
#>  3 base_ansi         4.23µs   4.59µs   212358.      224B    21.2 
#>  4 cli_plain        164.2µs 172.27µs     5614.    8.09KB    10.4 
#>  5 fansi_plain     128.98µs 137.17µs     7084.    9.62KB    10.4 
#>  6 base_plain        3.77µs      4µs   242957.        0B     0   
#>  7 cli_vec_ansi      7.85ms   8.04ms      124.  823.77KB    11.3 
#>  8 fansi_vec_ansi    1.09ms   1.12ms      861.  846.81KB    15.2 
#>  9 base_vec_ansi   156.67µs 163.96µs     5968.    22.7KB     4.12
#> 10 cli_vec_plain     7.78ms   7.95ms      126.  823.77KB    11.2 
#> 11 fansi_vec_plain   1.03ms   1.06ms      929.  845.98KB    18.0 
#> 12 base_vec_plain  106.26µs 110.45µs     8906.      848B     2.02
#> 13 cli_txt_ansi      3.35ms    3.4ms      293.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.56ms   1.61ms      580.   35.05KB     0   
#> 15 base_txt_ansi   133.61µs 139.19µs     6993.   18.47KB     2.02
#> 16 cli_txt_plain     2.54ms   2.58ms      386.    63.6KB     2.02
#> 17 fansi_txt_plain 516.78µs  543.6µs     1819.    30.6KB     2.03
#> 18 base_txt_plain   87.13µs  89.96µs    10845.   11.05KB     2.02
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
#>  1 cli_ansi        149.61µs 156.72µs     6147.   33.84KB    12.5 
#>  2 fansi_ansi       55.71µs  59.28µs    16253.   31.42KB    10.4 
#>  3 base_ansi         1.07µs   1.13µs   809826.     4.2KB     0   
#>  4 cli_plain       148.35µs  156.4µs     6171.        0B    12.5 
#>  5 fansi_plain       54.9µs  59.18µs    16184.      872B    12.5 
#>  6 base_plain      991.86ns   1.04µs   904400.        0B     0   
#>  7 cli_vec_ansi    278.07µs 290.78µs     3374.   16.73KB     6.19
#>  8 fansi_vec_ansi  123.88µs 128.61µs     7548.    5.59KB     6.19
#>  9 base_vec_ansi    36.47µs  37.12µs    26530.      848B     0   
#> 10 cli_vec_plain   234.96µs 245.67µs     3974.   16.73KB     8.54
#> 11 fansi_vec_plain 116.35µs 121.47µs     7947.    5.59KB     6.18
#> 12 base_vec_plain   30.19µs  31.04µs    31841.      848B     0   
#> 13 cli_txt_ansi    158.25µs 164.97µs     5864.        0B    12.5 
#> 14 fansi_txt_ansi   55.87µs  59.31µs    16301.      872B    10.4 
#> 15 base_txt_ansi     1.11µs   1.16µs   807120.        0B     0   
#> 16 cli_txt_plain   146.19µs 155.75µs     6227.        0B    12.4 
#> 17 fansi_txt_plain  54.45µs  56.89µs    16984.      872B    12.5 
#> 18 base_txt_plain    1.02µs   1.07µs   894331.        0B     0
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
#>  1 cli_ansi        428.16µs 458.62µs    2171.     6.18KB    10.4 
#>  2 fansi_ansi       98.33µs 104.38µs    9291.    97.33KB    12.5 
#>  3 base_ansi        39.29µs  41.71µs   22986.         0B     9.20
#>  4 cli_plain       280.49µs 293.78µs    3328.         0B    10.3 
#>  5 fansi_plain      97.73µs 104.67µs    9260.       872B    10.4 
#>  6 base_plain       32.05µs   34.2µs   28202.         0B    11.3 
#>  7 cli_vec_ansi     45.74ms  45.92ms      21.8   94.67KB    18.1 
#>  8 fansi_vec_ansi  240.23µs 250.47µs    3910.     7.25KB     6.16
#>  9 base_vec_ansi     2.33ms   2.41ms     413.    48.18KB    12.9 
#> 10 cli_vec_plain    29.47ms  29.91ms      33.4    2.48KB    13.9 
#> 11 fansi_vec_plain 193.06µs 201.37µs    4843.     6.42KB     6.16
#> 12 base_vec_plain    1.69ms   1.76ms     562.     47.4KB    13.1 
#> 13 cli_txt_ansi     28.25ms  28.41ms      35.1    4.27MB     4.39
#> 14 fansi_txt_ansi  232.69µs 242.06µs    4036.     6.77KB     6.16
#> 15 base_txt_ansi     1.31ms   1.34ms     733.   582.06KB     8.83
#> 16 cli_txt_plain     1.32ms   1.37ms     689.   369.84KB     8.80
#> 17 fansi_txt_plain 183.19µs 191.53µs    5090.     2.51KB     6.18
#> 18 base_txt_plain  880.07µs 917.99µs    1074.   367.31KB     8.72
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
#>  1 cli_ansi          6.84µs   7.68µs   126098.   25.09KB    12.6 
#>  2 fansi_ansi        80.6µs  86.04µs    11214.   28.48KB    10.4 
#>  3 base_ansi         1.06µs   1.12µs   833436.        0B     0   
#>  4 cli_plain         6.72µs   7.45µs   128470.        0B    12.8 
#>  5 fansi_plain      81.14µs  85.71µs    11252.    1.98KB    12.6 
#>  6 base_plain        1.02µs   1.08µs   853714.        0B     0   
#>  7 cli_vec_ansi     26.61µs  27.78µs    34536.     1.7KB     3.45
#>  8 fansi_vec_ansi  118.49µs 124.01µs     7754.    8.86KB     6.21
#>  9 base_vec_ansi     6.35µs   6.68µs   144338.      848B     0   
#> 10 cli_vec_plain    23.41µs  24.37µs    40126.     1.7KB     4.01
#> 11 fansi_vec_plain 110.46µs 114.94µs     8431.    8.86KB     8.38
#> 12 base_vec_plain    6.06µs   6.39µs   152904.      848B     0   
#> 13 cli_txt_ansi      6.72µs   7.26µs   133330.        0B    13.3 
#> 14 fansi_txt_ansi   78.71µs  82.53µs    11731.    1.98KB    10.4 
#> 15 base_txt_ansi     6.48µs   6.55µs   148449.        0B    14.8 
#> 16 cli_txt_plain     7.57µs   8.11µs   119678.        0B    12.0 
#> 17 fansi_txt_plain  79.31µs  82.48µs    11714.    1.98KB    10.4 
#> 18 base_txt_plain    4.14µs    4.2µs   230396.        0B     0
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
#>  1 cli_ansi       112.42µs 118.18µs    8172.     12.1KB     8.35
#>  2 base_ansi        1.35µs    1.4µs  690147.         0B     0   
#>  3 cli_plain       92.03µs  96.93µs    9606.     8.91KB     6.16
#>  4 base_plain       1.05µs   1.09µs  859226.         0B     0   
#>  5 cli_vec_ansi     4.39ms   4.61ms     216.   838.95KB    13.4 
#>  6 base_vec_ansi   75.48µs  76.33µs   12947.       848B     0   
#>  7 cli_vec_plain    2.46ms   2.53ms     392.   817.08KB    12.9 
#>  8 base_vec_plain  46.06µs  46.66µs   21111.       848B     2.11
#>  9 cli_txt_ansi    15.04ms  15.18ms      65.9   114.6KB     2.06
#> 10 base_txt_ansi   75.66µs  76.52µs   12910.         0B     0   
#> 11 cli_txt_plain  298.77µs 313.85µs    3136.    18.34KB     2.02
#> 12 base_txt_plain   42.3µs  43.16µs   22602.         0B     0
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
#>  1 cli_ansi        109.2µs  115.2µs     8355.        0B    10.4 
#>  2 base_ansi        16.8µs     18µs    53380.        0B    10.7 
#>  3 cli_plain       109.3µs  114.8µs     8360.        0B    12.5 
#>  4 base_plain       16.7µs   18.1µs    53465.        0B    10.7 
#>  5 cli_vec_ansi    212.5µs  221.1µs     4406.     7.2KB     6.16
#>  6 base_vec_ansi    59.3µs   66.2µs    14797.    1.66KB     2.02
#>  7 cli_vec_plain   197.2µs  209.2µs     4654.     7.2KB     6.24
#>  8 base_vec_plain   52.9µs   59.3µs    16600.    1.66KB     4.07
#>  9 cli_txt_ansi    184.6µs  191.1µs     5095.        0B     6.13
#> 10 base_txt_ansi    41.4µs   42.8µs    22720.        0B     4.54
#> 11 cli_txt_plain   168.9µs  175.4µs     5530.        0B     8.21
#> 12 base_txt_plain   35.5µs   36.7µs    26502.        0B     5.30
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
#> 1 cli          8.15µs   8.87µs   108684.        0B    21.7 
#> 2 base       880.91ns  931.9ns   991085.        0B     0   
#> 3 cli_vec     23.66µs  24.67µs    39399.      448B     3.94
#> 4 base_vec    11.49µs  11.71µs    83762.      448B     0   
#> 5 cli_txt     23.89µs  24.72µs    39297.        0B     3.93
#> 6 base_txt    12.53µs  12.61µs    77824.        0B     0
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
#> 1 cli          8.16µs   8.95µs   107653.        0B    10.8 
#> 2 base         1.31µs   1.37µs   680590.        0B     0   
#> 3 cli_vec     29.34µs  30.57µs    31896.      448B     3.19
#> 4 base_vec    50.67µs  51.11µs    19305.      448B     0   
#> 5 cli_txt     29.88µs  30.84µs    31517.        0B     3.15
#> 6 base_txt    86.09µs  86.88µs    11375.        0B     0
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
#> 1 cli          8.74µs   9.53µs   101256.        0B    10.1 
#> 2 base       891.04ns 942.03ns   969944.        0B     0   
#> 3 cli_vec     19.63µs  20.73µs    46972.      448B     4.70
#> 4 base_vec    11.49µs  11.75µs    83422.      448B     8.34
#> 5 cli_txt     20.44µs  21.38µs    45522.        0B     4.55
#> 6 base_txt    12.54µs  12.62µs    77814.        0B     0
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
#> 1 cli          6.43µs   7.11µs   135104.    22.2KB    13.5 
#> 2 base         1.08µs   1.14µs   797120.        0B    79.7 
#> 3 cli_vec     29.36µs  30.39µs    32159.     1.7KB     3.22
#> 4 base_vec     8.17µs   8.41µs   116593.      848B     0   
#> 5 cli_txt      6.23µs   7.01µs   136852.        0B    13.7 
#> 6 base_txt      5.5µs   5.57µs   174498.        0B     0
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
#>  date     2026-10-05
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-10-05 [1] local
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
#>  xfun          0.61       2026-09-16 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
