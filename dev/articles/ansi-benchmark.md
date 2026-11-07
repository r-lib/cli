# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5bbe02f0c650\>
\<environment: 0x5bbe0399ed80\>

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
#> 1 ansi        29.24µs   32.7µs    29993.    99.6KB     33.0
#> 2 plain       29.21µs  32.36µs    30294.        0B     33.4
#> 3 base         8.38µs   9.49µs   102526.    48.6KB     30.8
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
#> 1 ansi        30.58µs   34.2µs    28600.        0B     34.4
#> 2 plain       30.44µs     34µs    28815.        0B     34.6
#> 3 base         9.63µs     11µs    88082.        0B     35.2
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
#> 1 ansi        75.54µs   82.5µs    11844.   77.03KB     25.6
#> 2 plain       59.34µs   64.7µs    15119.    8.91KB     21.1
#> 3 base         1.23µs    1.4µs   667320.        0B     66.7
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
#> 1 ansi          216µs    237µs     4189.   33.23KB     30.2
#> 2 plain         208µs    231µs     4228.    1.09KB     22.3
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
#>  1 cli_ansi          4.28µs    4.8µs   201566.    9.27KB     20.2
#>  2 fansi_ansi       21.36µs  23.66µs    41128.    4.18KB     20.6
#>  3 cli_plain         4.29µs   4.83µs   201392.        0B     20.1
#>  4 fansi_plain      21.31µs  23.59µs    41582.      688B     16.6
#>  5 cli_vec_ansi      5.45µs   6.04µs   161623.      448B     16.2
#>  6 fansi_vec_ansi   28.56µs  31.25µs    31198.    5.02KB     12.5
#>  7 cli_vec_plain     5.95µs   6.58µs   148150.      448B     14.8
#>  8 fansi_vec_plain  28.39µs  31.35µs    31310.    5.02KB     15.7
#>  9 cli_txt_ansi       4.3µs   4.85µs   199751.        0B      0  
#> 10 fansi_txt_ansi   21.57µs  23.83µs    41133.      688B     20.6
#> 11 cli_txt_plain     5.07µs    5.6µs   174177.        0B     17.4
#> 12 fansi_txt_plain  28.65µs   31.5µs    31115.    5.02KB     12.5
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
#> 1 cli          41.8µs   44.1µs    22393.    22.7KB     6.72
#> 2 fansi        83.2µs   87.5µs    11218.    55.3KB     6.11
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
#>  1 cli_ansi          5.06µs   5.75µs   168938.        0B    16.9 
#>  2 fansi_ansi       55.42µs   60.8µs    16101.   38.84KB    14.6 
#>  3 base_ansi       650.88ns 740.98ns  1234419.        0B     0   
#>  4 cli_plain         5.08µs   5.78µs   168162.        0B    16.8 
#>  5 fansi_plain      55.87µs  60.81µs    16080.      688B    14.6 
#>  6 base_plain      591.04ns 671.13ns  1346087.        0B     0   
#>  7 cli_vec_ansi     21.64µs  22.58µs    43566.      448B     4.36
#>  8 fansi_vec_ansi   71.85µs  77.23µs    12681.    5.02KB    10.5 
#>  9 base_vec_ansi    12.37µs  12.46µs    78830.      448B     0   
#> 10 cli_vec_plain    19.98µs  21.23µs    46471.      448B     4.65
#> 11 fansi_vec_plain  64.28µs  69.86µs    14017.    5.02KB    12.6 
#> 12 base_vec_plain     7.2µs   7.32µs   134014.      448B     0   
#> 13 cli_txt_ansi     21.88µs  23.12µs    42626.        0B     4.26
#> 14 fansi_txt_ansi   66.17µs  71.48µs    13717.      688B    12.4 
#> 15 base_txt_ansi    12.35µs  12.44µs    79113.        0B     0   
#> 16 cli_txt_plain    19.48µs  21.04µs    47127.        0B     4.71
#> 17 fansi_txt_plain  57.92µs  63.12µs    15518.      688B    14.6 
#> 18 base_txt_plain    7.19µs   7.28µs   134797.        0B     0
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
#>  1 cli_ansi          6.17µs   7.07µs   137560.        0B    13.8 
#>  2 fansi_ansi       56.09µs  61.33µs    15948.      688B    14.6 
#>  3 base_ansi       901.05ns  991.1ns   936701.        0B     0   
#>  4 cli_plain         6.16µs   7.05µs   137711.        0B    13.8 
#>  5 fansi_plain      55.64µs  60.77µs    16089.      688B    14.6 
#>  6 base_plain      731.09ns 821.08ns  1111930.        0B     0   
#>  7 cli_vec_ansi     26.63µs  27.64µs    35595.      448B     3.56
#>  8 fansi_vec_ansi   73.91µs     81µs    11740.    5.02KB    10.5 
#>  9 base_vec_ansi    32.38µs  33.21µs    29877.      448B     0   
#> 10 cli_vec_plain    25.32µs  26.41µs    37238.      448B     3.72
#> 11 fansi_vec_plain  65.12µs  71.26µs    13726.    5.02KB    12.6 
#> 12 base_vec_plain   16.95µs  17.23µs    57257.      448B     0   
#> 13 cli_txt_ansi     26.96µs  28.01µs    35186.        0B     3.52
#> 14 fansi_txt_ansi   68.67µs  73.72µs    13319.      688B    12.4 
#> 15 base_txt_ansi    33.96µs  34.34µs    28792.        0B     0   
#> 16 cli_txt_plain    25.21µs  26.24µs    37548.        0B     3.76
#> 17 fansi_txt_plain  58.63µs   64.1µs    15307.      688B    14.8 
#> 18 base_txt_plain   18.02µs  18.25µs    54167.        0B     0
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
#> 1 cli_ansi        4.84µs   5.33µs   183545.        0B    18.4 
#> 2 cli_plain        4.6µs   5.08µs   192117.        0B    19.2 
#> 3 cli_vec_ansi   22.93µs  23.82µs    41379.      848B     4.14
#> 4 cli_vec_plain   7.66µs   8.25µs   118752.      848B    11.9 
#> 5 cli_txt_ansi   22.86µs  23.72µs    41656.        0B     4.17
#> 6 cli_txt_plain   5.29µs   5.81µs   168624.        0B     0
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
#>  1 cli_ansi          18.8µs   20.2µs    48316.        0B     19.3
#>  2 fansi_ansi          20µs   21.5µs    45523.    7.24KB     18.2
#>  3 cli_plain         18.7µs   20.1µs    48704.        0B     19.5
#>  4 fansi_plain       19.8µs   21.8µs    44582.      688B     17.8
#>  5 cli_vec_ansi      25.4µs   27.4µs    35828.      848B     14.3
#>  6 fansi_vec_ansi    40.3µs   42.7µs    23007.    5.41KB     11.5
#>  7 cli_vec_plain     20.8µs   22.7µs    43248.      848B     17.3
#>  8 fansi_vec_plain   27.9µs   30.2µs    32486.    4.59KB     13.0
#>  9 cli_txt_ansi      25.3µs     27µs    36314.        0B     14.5
#> 10 fansi_txt_ansi    32.7µs   35.1µs    27958.    5.12KB     11.2
#> 11 cli_txt_plain     19.5µs   21.4µs    45830.        0B     18.3
#> 12 fansi_txt_plain   21.1µs   23.1µs    42299.      688B     16.9
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
#>  1 cli_ansi        101.01µs 111.22µs     8784.  104.86KB    14.7 
#>  2 fansi_ansi       83.47µs   90.8µs    10826.  106.35KB    16.7 
#>  3 base_ansi         2.93µs   3.17µs   307940.      224B     0   
#>  4 cli_plain       102.54µs 110.64µs     8823.    8.09KB    14.6 
#>  5 fansi_plain      83.12µs  90.17µs    10919.    9.62KB    16.9 
#>  6 base_plain        2.51µs   2.76µs   348229.        0B     0   
#>  7 cli_vec_ansi       5.1ms    5.3ms      189.  823.77KB    18.2 
#>  8 fansi_vec_ansi  777.33µs 819.31µs     1178.  846.81KB    24.6 
#>  9 base_vec_ansi   114.95µs 119.16µs     8247.    22.7KB     4.14
#> 10 cli_vec_plain     5.08ms   5.27ms      189.  823.77KB    18.4 
#> 11 fansi_vec_plain 731.48µs 773.19µs     1255.  845.98KB    26.2 
#> 12 base_vec_plain   77.03µs  81.45µs    11995.      848B     4.05
#> 13 cli_txt_ansi      2.44ms   2.51ms      397.    63.6KB     0   
#> 14 fansi_txt_ansi    1.24ms   1.25ms      797.   35.05KB     0   
#> 15 base_txt_ansi   106.93µs 114.38µs     8768.   18.47KB     4.07
#> 16 cli_txt_plain     1.75ms   1.76ms      565.    63.6KB     0   
#> 17 fansi_txt_plain 384.65µs 398.93µs     2487.    30.6KB     4.07
#> 18 base_txt_plain    67.6µs  69.09µs    14324.   11.05KB     2.02
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
#>  1 cli_ansi          99.4µs  104.4µs     9398.   33.84KB    18.9 
#>  2 fansi_ansi        36.8µs   40.7µs    24118.   31.42KB    16.9 
#>  3 base_ansi          771ns  841.1ns  1111072.     4.2KB     0   
#>  4 cli_plain         99.2µs  105.7µs     9329.        0B    18.8 
#>  5 fansi_plain       37.3µs   41.2µs    23890.      872B    16.7 
#>  6 base_plain       721.1ns  791.2ns  1183765.        0B     0   
#>  7 cli_vec_ansi     192.7µs  201.1µs     4898.   16.73KB     8.26
#>  8 fansi_vec_ansi      86µs   90.5µs    10872.    5.59KB    10.4 
#>  9 base_vec_ansi     28.2µs   28.5µs    34707.      848B     0   
#> 10 cli_vec_plain    167.2µs    174µs     5660.   16.73KB    10.4 
#> 11 fansi_vec_plain     81µs   85.4µs    11543.    5.59KB     8.26
#> 12 base_vec_plain      23µs   23.3µs    42483.      848B     4.25
#> 13 cli_txt_ansi     106.3µs  113.7µs     8610.        0B    16.8 
#> 14 fansi_txt_ansi    37.1µs   41.2µs    23955.      872B    16.8 
#> 15 base_txt_ansi    791.2ns  872.1ns  1076005.        0B     0   
#> 16 cli_txt_plain    100.2µs  107.9µs     9099.        0B    16.7 
#> 17 fansi_txt_plain   37.3µs   40.9µs    23969.      872B    16.8 
#> 18 base_txt_plain   741.1ns  841.1ns  1090971.        0B     0
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
#>  1 cli_ansi        277.52µs 298.65µs    3309.     6.18KB    14.6 
#>  2 fansi_ansi       67.36µs  73.72µs   13345.    97.33KB    17.0 
#>  3 base_ansi        25.02µs  26.99µs   36144.         0B    14.5 
#>  4 cli_plain       175.12µs 185.59µs    5283.         0B    16.7 
#>  5 fansi_plain      64.88µs  71.86µs   13788.       872B    17.5 
#>  6 base_plain       19.86µs  21.19µs   46242.         0B    13.9 
#>  7 cli_vec_ansi      28.7ms     29ms      34.5   94.67KB    30.6 
#>  8 fansi_vec_ansi  174.38µs  181.7µs    5439.     7.25KB     8.22
#>  9 base_vec_ansi     1.67ms   1.75ms     569.    48.18KB    17.4 
#> 10 cli_vec_plain    18.58ms  18.81ms      53.1    2.48KB    23.6 
#> 11 fansi_vec_plain 139.94µs 148.61µs    6644.     6.42KB     8.23
#> 12 base_vec_plain    1.22ms   1.29ms     775.     47.4KB    17.2 
#> 13 cli_txt_ansi     20.45ms  20.63ms      48.4    4.27MB     6.91
#> 14 fansi_txt_ansi  170.14µs 178.76µs    5523.     6.77KB     8.20
#> 15 base_txt_ansi   975.97µs   1.01ms     973.   582.06KB    11.1 
#> 16 cli_txt_plain   966.36µs      1ms     988.   369.84KB    13.5 
#> 17 fansi_txt_plain 132.16µs 139.77µs    7059.     2.51KB     8.20
#> 18 base_txt_plain  658.75µs 694.42µs    1424.   367.31KB    13.5
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
#>  1 cli_ansi          5.01µs   5.78µs   166113.   25.09KB    16.6 
#>  2 fansi_ansi       54.89µs  60.28µs    16303.   28.48KB    14.7 
#>  3 base_ansi        741.1ns 851.11ns  1040880.        0B   104.  
#>  4 cli_plain         4.96µs   5.68µs   170503.        0B    17.1 
#>  5 fansi_plain      54.78µs  59.98µs    16295.    1.98KB    14.7 
#>  6 base_plain      721.08ns 811.07ns  1134433.        0B     0   
#>  7 cli_vec_ansi     20.82µs  22.09µs    44400.     1.7KB     4.44
#>  8 fansi_vec_ansi   82.14µs  87.37µs    11236.    8.86KB    10.5 
#>  9 base_vec_ansi     4.63µs   5.05µs   194308.      848B    19.4 
#> 10 cli_vec_plain    18.01µs  19.06µs    50605.     1.7KB     5.06
#> 11 fansi_vec_plain  77.02µs  82.97µs    11816.    8.86KB    10.5 
#> 12 base_vec_plain    4.42µs   4.59µs   212440.      848B     0   
#> 13 cli_txt_ansi       4.9µs   5.72µs   166141.        0B    33.2 
#> 14 fansi_txt_ansi   54.29µs  59.65µs    16455.    1.98KB    14.7 
#> 15 base_txt_ansi     4.33µs   4.42µs   220866.        0B     0   
#> 16 cli_txt_plain     5.64µs   6.42µs   150604.        0B    15.1 
#> 17 fansi_txt_plain  54.52µs  59.92µs    16382.    1.98KB    16.9 
#> 18 base_txt_plain    2.76µs   2.86µs   338815.        0B     0
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
#>  1 cli_ansi        71.16µs  77.52µs   12599.     12.1KB    12.3 
#>  2 base_ansi      992.09ns   1.06µs  902958.         0B     0   
#>  3 cli_plain        56.3µs  59.03µs   16521.     8.91KB    12.4 
#>  4 base_plain     740.98ns 801.05ns 1203692.         0B     0   
#>  5 cli_vec_ansi     3.13ms   3.21ms     311.   838.95KB    20.1 
#>  6 base_vec_ansi   59.59µs  60.01µs   16379.       848B     0   
#>  7 cli_vec_plain    1.74ms   1.83ms     544.   817.08KB    17.5 
#>  8 base_vec_plain   34.7µs  35.12µs   28111.       848B     0   
#>  9 cli_txt_ansi    10.59ms  10.68ms      93.6   114.6KB     4.16
#> 10 base_txt_ansi   58.83µs   61.2µs   16200.         0B     2.01
#> 11 cli_txt_plain  214.01µs 222.94µs    4407.    18.34KB     2.01
#> 12 base_txt_plain  34.22µs  35.03µs   28229.         0B     0
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
#>  1 cli_ansi         70.5µs   75.7µs    12938.        0B    18.9 
#>  2 base_ansi        11.8µs   13.2µs    73731.        0B    14.7 
#>  3 cli_plain        70.5µs   75.1µs    13015.        0B    18.9 
#>  4 base_plain       11.7µs     13µs    74997.        0B    15.0 
#>  5 cli_vec_ansi    138.1µs  143.8µs     6834.     7.2KB     8.23
#>  6 base_vec_ansi    40.5µs   44.4µs    22187.    1.66KB     4.44
#>  7 cli_vec_plain   129.7µs    135µs     7276.     7.2KB    10.4 
#>  8 base_vec_plain     36µs   37.4µs    26306.    1.66KB     5.26
#>  9 cli_txt_ansi    123.4µs  129.3µs     7611.        0B    10.4 
#> 10 base_txt_ansi    29.5µs   30.9µs    31807.        0B     6.36
#> 11 cli_txt_plain   111.4µs  117.3µs     8370.        0B    12.4 
#> 12 base_txt_plain   25.1µs   26.6µs    37026.        0B     7.41
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
#> 1 cli          5.95µs   6.75µs   143704.        0B    14.4 
#> 2 base       621.08ns 701.05ns  1292408.        0B     0   
#> 3 cli_vec     17.79µs  18.84µs    52229.      448B     5.22
#> 4 base_vec     9.42µs   9.61µs   102124.      448B    10.2 
#> 5 cli_txt      17.8µs  18.78µs    52336.        0B     5.23
#> 6 base_txt    10.12µs  10.26µs    95942.        0B     0
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
#> 1 cli          5.91µs   6.72µs   144415.        0B    14.4 
#> 2 base       991.04ns   1.09µs   850458.        0B     0   
#> 3 cli_vec     22.96µs  24.04µs    40919.      448B     8.19
#> 4 base_vec    41.82µs  43.37µs    22860.      448B     0   
#> 5 cli_txt     23.18µs  24.31µs    40502.        0B     4.05
#> 6 base_txt    73.31µs  74.16µs    13358.        0B     0
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
#> 1 cli          6.27µs   7.17µs   135040.        0B    13.5 
#> 2 base       611.06ns 701.05ns  1221049.        0B   122.  
#> 3 cli_vec     15.33µs  16.27µs    59937.      448B     5.99
#> 4 base_vec     9.41µs   9.61µs   102408.      448B     0   
#> 5 cli_txt     15.84µs  16.82µs    58403.        0B     5.84
#> 6 base_txt     10.1µs  10.24µs    96033.        0B     0
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
#> 1 cli          4.67µs    5.4µs   178488.    22.2KB    17.9 
#> 2 base        741.1ns    851ns  1079023.        0B     0   
#> 3 cli_vec     22.27µs  23.34µs    42119.     1.7KB     4.21
#> 4 base_vec     6.25µs   6.58µs   149441.      848B     0   
#> 5 cli_txt      4.67µs   5.42µs   175584.        0B    35.1 
#> 6 base_txt     3.92µs   4.12µs   238050.        0B     0
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
#>  date     2026-11-07
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-11-07 [1] local
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
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
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
