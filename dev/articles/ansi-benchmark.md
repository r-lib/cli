# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55cd2a2eb830\>
\<environment: 0x55cd2ae17440\>

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
#> 1 ansi         45.5µs   48.8µs    19863.    99.6KB     21.0
#> 2 plain        45.4µs     49µs    19680.        0B     19.6
#> 3 base         11.4µs   12.5µs    77699.    48.6KB     23.3
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
#> 1 ansi         46.1µs   51.3µs    18885.        0B     23.6
#> 2 plain        46.5µs   50.2µs    19306.        0B     23.2
#> 3 base         13.1µs   14.1µs    68737.        0B     27.5
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
#> 1 ansi       116.05µs  122.3µs     7921.   77.03KB     16.7
#> 2 plain        92.8µs  97.51µs     9925.    8.91KB     14.5
#> 3 base         1.87µs   1.99µs   484709.        0B      0
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
#> 1 ansi          329µs    353µs     2806.   33.24KB     21.0
#> 2 plain         330µs    358µs     2775.    1.09KB     18.9
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
#>  1 cli_ansi          5.87µs   6.44µs   149805.    9.27KB    30.0 
#>  2 fansi_ansi       30.52µs  33.41µs    28971.    4.18KB    23.2 
#>  3 cli_plain          5.8µs   6.21µs   140257.        0B    14.0 
#>  4 fansi_plain      30.04µs  32.29µs    29886.      688B    15.0 
#>  5 cli_vec_ansi      7.19µs   7.64µs   127376.      448B    12.7 
#>  6 fansi_vec_ansi   40.13µs  42.88µs    22212.    5.02KB     8.89
#>  7 cli_vec_plain     7.82µs   8.27µs   118023.      448B    11.8 
#>  8 fansi_vec_plain   38.2µs  40.49µs    23989.    5.02KB     9.60
#>  9 cli_txt_ansi      5.79µs    6.2µs   156914.        0B    15.7 
#> 10 fansi_txt_ansi    30.2µs  32.42µs    29918.      688B    15.0 
#> 11 cli_txt_plain     6.63µs   7.25µs   135267.        0B    13.5 
#> 12 fansi_txt_plain  38.36µs  40.74µs    23869.    5.02KB     9.55
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
#> 1 cli          56.4µs   58.2µs    16761.    22.7KB     6.12
#> 2 fansi       117.9µs  123.5µs     7889.    55.3KB     4.05
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
#>  1 cli_ansi          6.96µs   7.59µs   127472.        0B    12.7 
#>  2 fansi_ansi       91.36µs  97.19µs     9972.   38.84KB     8.18
#>  3 base_ansi       911.07ns 952.04ns   950636.        0B     0   
#>  4 cli_plain          6.9µs   7.51µs   129236.        0B    12.9 
#>  5 fansi_plain      91.43µs  96.81µs    10009.      688B    10.3 
#>  6 base_plain      821.08ns 871.02ns  1069516.        0B     0   
#>  7 cli_vec_ansi     29.38µs  30.32µs    32192.      448B     3.22
#>  8 fansi_vec_ansi  113.13µs 118.16µs     8207.    5.02KB     6.15
#>  9 base_vec_ansi    18.46µs  18.54µs    53120.      448B     0   
#> 10 cli_vec_plain    28.12µs   28.9µs    33895.      448B     3.39
#> 11 fansi_vec_plain 103.27µs 108.05µs     8939.    5.02KB     8.26
#> 12 base_vec_plain   10.78µs  10.85µs    80186.      448B     0   
#> 13 cli_txt_ansi     29.41µs  30.43µs    32206.        0B     3.22
#> 14 fansi_txt_ansi  103.12µs  109.1µs     8898.      688B     8.19
#> 15 base_txt_ansi     18.2µs  18.25µs    54037.        0B     0   
#> 16 cli_txt_plain    27.67µs  28.43µs    34533.        0B     3.45
#> 17 fansi_txt_plain  93.32µs  98.75µs     9797.      688B     8.18
#> 18 base_txt_plain   10.58µs   11.1µs    88368.        0B     0
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
#>  1 cli_ansi          8.52µs   9.25µs   104887.        0B    10.5 
#>  2 fansi_ansi        92.9µs  97.88µs     9905.      688B     8.19
#>  3 base_ansi         1.24µs   1.28µs   729706.        0B     0   
#>  4 cli_plain         8.42µs   9.26µs   105196.        0B    10.5 
#>  5 fansi_plain      92.29µs  96.94µs     9978.      688B    10.3 
#>  6 base_plain        1.01µs   1.05µs   898321.        0B     0   
#>  7 cli_vec_ansi     34.63µs  35.62µs    27438.      448B     2.74
#>  8 fansi_vec_ansi   115.7µs 120.91µs     8039.    5.02KB     6.14
#>  9 base_vec_ansi    44.08µs  44.43µs    22226.      448B     0   
#> 10 cli_vec_plain    33.41µs  34.27µs    28630.      448B     2.86
#> 11 fansi_vec_plain 105.82µs 110.26µs     8781.    5.02KB     6.13
#> 12 base_vec_plain   22.98µs  23.27µs    42400.      448B     4.24
#> 13 cli_txt_ansi     35.02µs   35.8µs    27388.        0B     2.74
#> 14 fansi_txt_ansi  107.39µs 112.32µs     8628.      688B     8.18
#> 15 base_txt_ansi    46.67µs  47.23µs    20941.        0B     0   
#> 16 cli_txt_plain    32.87µs  33.69µs    29001.        0B     2.90
#> 17 fansi_txt_plain  97.79µs 102.59µs     9386.      688B     8.18
#> 18 base_txt_plain   24.48µs  25.33µs    38991.        0B     0
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
#> 1 cli_ansi        6.86µs   7.52µs   128453.        0B    12.8 
#> 2 cli_plain       6.42µs   6.99µs   138452.        0B    13.8 
#> 3 cli_vec_ansi   32.47µs   33.5µs    29266.      848B     2.93
#> 4 cli_vec_plain  10.43µs  11.09µs    87960.      848B     8.80
#> 5 cli_txt_ansi   32.28µs   33.4µs    29351.        0B     2.94
#> 6 cli_txt_plain   7.33µs   8.03µs   121065.        0B    12.1
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
#>  1 cli_ansi          25.8µs   27.5µs    35495.        0B    14.2 
#>  2 fansi_ansi        28.4µs   30.5µs    31726.    7.24KB    12.7 
#>  3 cli_plain         25.8µs   27.4µs    35455.        0B    14.2 
#>  4 fansi_plain       27.7µs   29.8µs    32535.      688B    13.0 
#>  5 cli_vec_ansi      34.7µs   36.7µs    26473.      848B    13.2 
#>  6 fansi_vec_ansi    55.6µs   58.9µs    16567.    5.41KB     6.18
#>  7 cli_vec_plain     28.3µs   30.2µs    32282.      848B    12.9 
#>  8 fansi_vec_plain   37.1µs   38.8µs    24903.    4.59KB     9.97
#>  9 cli_txt_ansi      33.7µs   35.3µs    26061.        0B    13.0 
#> 10 fansi_txt_ansi    43.6µs   45.4µs    21424.    5.12KB     8.57
#> 11 cli_txt_plain     26.4µs   27.7µs    35318.        0B    14.1 
#> 12 fansi_txt_plain   28.7µs   30.2µs    32090.      688B    12.8
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
#>  1 cli_ansi        161.56µs 168.29µs     5786.  104.86KB    10.3 
#>  2 fansi_ansi      128.39µs 135.33µs     7210.  106.35KB    10.3 
#>  3 base_ansi         4.19µs   4.55µs   214701.      224B     0   
#>  4 cli_plain       160.09µs 167.42µs     5814.    8.09KB    10.3 
#>  5 fansi_plain     126.08µs 133.88µs     7232.    9.62KB    12.5 
#>  6 base_plain        3.76µs   3.97µs   246104.        0B     0   
#>  7 cli_vec_ansi      7.62ms   7.76ms      129.  823.77KB    11.1 
#>  8 fansi_vec_ansi    1.04ms   1.07ms      913.  846.81KB    19.3 
#>  9 base_vec_ansi   154.75µs 160.56µs     6069.    22.7KB     2.03
#> 10 cli_vec_plain     7.57ms   7.81ms      128.  823.77KB    11.4 
#> 11 fansi_vec_plain 982.14µs   1.02ms      971.  845.98KB    19.6 
#> 12 base_vec_plain   106.7µs 109.75µs     8873.      848B     2.01
#> 13 cli_txt_ansi      3.33ms   3.36ms      297.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.55ms   1.56ms      637.   35.05KB     0   
#> 15 base_txt_ansi   133.55µs 143.15µs     6896.   18.47KB     2.02
#> 16 cli_txt_plain      2.5ms   2.55ms      392.    63.6KB     0   
#> 17 fansi_txt_plain 513.33µs    555µs     1812.    30.6KB     4.08
#> 18 base_txt_plain   86.46µs  88.58µs    11104.   11.05KB     2.02
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
#>  1 cli_ansi        148.53µs 155.81µs     6225.   33.84KB    12.5 
#>  2 fansi_ansi       55.09µs  58.97µs    16438.   31.42KB    10.3 
#>  3 base_ansi         1.05µs   1.12µs   827374.     4.2KB    82.7 
#>  4 cli_plain       142.06µs 150.56µs     6479.        0B    12.3 
#>  5 fansi_plain      53.89µs  57.59µs    16829.      872B    12.4 
#>  6 base_plain      991.04ns   1.03µs   924041.        0B     0   
#>  7 cli_vec_ansi    274.59µs 287.12µs     3403.   16.73KB     6.26
#>  8 fansi_vec_ansi  116.45µs 120.89µs     8066.    5.59KB     6.15
#>  9 base_vec_ansi    36.83µs  37.37µs    26349.      848B     0   
#> 10 cli_vec_plain   226.92µs 240.84µs     3976.   16.73KB     8.27
#> 11 fansi_vec_plain 108.88µs 112.96µs     8627.    5.59KB     6.14
#> 12 base_vec_plain    30.3µs  30.84µs    31579.      848B     0   
#> 13 cli_txt_ansi    151.27µs 162.64µs     5990.        0B    12.4 
#> 14 fansi_txt_ansi   53.78µs   57.8µs    16835.      872B    12.0 
#> 15 base_txt_ansi     1.09µs   1.14µs   847075.        0B     0   
#> 16 cli_txt_plain   143.76µs 151.08µs     6446.        0B    12.4 
#> 17 fansi_txt_plain  53.49µs  55.91µs    17355.      872B    12.4 
#> 18 base_txt_plain       1µs   1.05µs   893282.        0B     0
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
#>  1 cli_ansi        418.21µs 449.38µs    2220.     6.18KB    10.5 
#>  2 fansi_ansi        98.5µs 105.46µs    9201.    97.33KB    10.3 
#>  3 base_ansi        38.91µs  40.94µs   23642.         0B    11.8 
#>  4 cli_plain       278.46µs  292.2µs    3341.         0B    10.3 
#>  5 fansi_plain      98.29µs 104.75µs    9279.       872B    10.3 
#>  6 base_plain       31.42µs  33.27µs   28960.         0B    11.6 
#>  7 cli_vec_ansi      45.2ms  45.56ms      22.0   94.67KB    18.3 
#>  8 fansi_vec_ansi  238.25µs 248.17µs    3954.     7.25KB     6.13
#>  9 base_vec_ansi      2.3ms   2.35ms     424.    48.18KB    10.6 
#> 10 cli_vec_plain    28.83ms  29.17ms      33.5    2.48KB    18.3 
#> 11 fansi_vec_plain 191.31µs 199.02µs    4912.     6.42KB     6.13
#> 12 base_vec_plain    1.66ms   1.71ms     583.     47.4KB    12.7 
#> 13 cli_txt_ansi     27.65ms  27.86ms      35.8    4.27MB     4.47
#> 14 fansi_txt_ansi  231.02µs 239.02µs    4103.     6.77KB     6.13
#> 15 base_txt_ansi     1.28ms   1.31ms     755.   582.06KB    11.1 
#> 16 cli_txt_plain      1.3ms   1.34ms     739.   369.84KB     8.56
#> 17 fansi_txt_plain 181.41µs  190.7µs    5135.     2.51KB     6.13
#> 18 base_txt_plain  869.26µs 901.22µs    1093.   367.31KB     8.64
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
#>  1 cli_ansi          6.86µs   7.55µs   127476.   25.09KB    12.7 
#>  2 fansi_ansi        79.2µs  84.38µs    11512.   28.48KB    10.3 
#>  3 base_ansi         1.05µs   1.11µs   833609.        0B     0   
#>  4 cli_plain         6.81µs   7.44µs   129295.        0B    25.9 
#>  5 fansi_plain      79.18µs  84.52µs    11474.    1.98KB    10.5 
#>  6 base_plain        1.02µs   1.08µs   866608.        0B     0   
#>  7 cli_vec_ansi     27.11µs  28.17µs    34770.     1.7KB     3.48
#>  8 fansi_vec_ansi  118.16µs 123.17µs     7890.    8.86KB     8.32
#>  9 base_vec_ansi     6.44µs   6.75µs   143205.      848B     0   
#> 10 cli_vec_plain    23.38µs  24.38µs    38770.     1.7KB     3.88
#> 11 fansi_vec_plain 112.88µs 117.81µs     8245.    8.86KB     8.35
#> 12 base_vec_plain     6.1µs   6.38µs   152975.      848B     0   
#> 13 cli_txt_ansi      6.85µs   7.57µs   126781.        0B    12.7 
#> 14 fansi_txt_ansi   79.29µs  84.78µs    11424.    1.98KB    12.5 
#> 15 base_txt_ansi     6.47µs   6.53µs   150056.        0B     0   
#> 16 cli_txt_plain     7.62µs   8.11µs   120381.        0B    12.0 
#> 17 fansi_txt_plain  77.75µs  81.04µs    12001.    1.98KB    10.3 
#> 18 base_txt_plain    4.13µs   4.19µs   232663.        0B    23.3
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
#>  1 cli_ansi       111.11µs 115.17µs    8432.     12.1KB     8.20
#>  2 base_ansi        1.34µs   1.38µs  706824.         0B     0   
#>  3 cli_plain       90.68µs  94.21µs   10272.     8.91KB     8.20
#>  4 base_plain       1.03µs   1.07µs  908284.         0B     0   
#>  5 cli_vec_ansi     4.19ms   4.29ms     232.   838.95KB    13.3 
#>  6 base_vec_ansi   75.36µs  76.12µs   12946.       848B     0   
#>  7 cli_vec_plain    2.35ms   2.42ms     411.   817.08KB    15.1 
#>  8 base_vec_plain  45.47µs  46.43µs   21258.       848B     0   
#>  9 cli_txt_ansi    14.92ms  15.01ms      66.2   114.6KB     2.07
#> 10 base_txt_ansi   75.36µs   76.5µs   12901.         0B     2.01
#> 11 cli_txt_plain  296.09µs 308.14µs    3181.    18.34KB     2.01
#> 12 base_txt_plain  42.64µs  43.61µs   21618.         0B     0
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
#>  1 cli_ansi        107.9µs  112.8µs     8601.        0B    12.3 
#>  2 base_ansi        16.2µs   17.5µs    55230.        0B    11.0 
#>  3 cli_plain       106.1µs  111.6µs     8705.        0B    12.4 
#>  4 base_plain       16.3µs   17.4µs    55770.        0B    11.2 
#>  5 cli_vec_ansi    209.8µs  218.2µs     4470.     7.2KB     6.12
#>  6 base_vec_ansi    58.7µs     65µs    15149.    1.66KB     2.01
#>  7 cli_vec_plain   194.6µs  203.8µs     4784.     7.2KB     8.22
#>  8 base_vec_plain   52.3µs   58.1µs    16939.    1.66KB     2.01
#>  9 cli_txt_ansi      185µs  191.8µs     5082.        0B     8.19
#> 10 base_txt_ansi    40.7µs   42.3µs    23111.        0B     4.62
#> 11 cli_txt_plain   166.5µs  174.4µs     5590.        0B     8.27
#> 12 base_txt_plain     35µs   36.2µs    26910.        0B     5.38
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
#> 1 cli          8.14µs   8.95µs   107512.        0B    10.8 
#> 2 base       861.01ns    912ns  1001686.        0B     0   
#> 3 cli_vec     23.73µs  24.53µs    39803.      448B     3.98
#> 4 base_vec    11.47µs   11.7µs    84142.      448B     0   
#> 5 cli_txt     23.96µs  24.63µs    39728.        0B     7.95
#> 6 base_txt    12.51µs  12.59µs    78282.        0B     0
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
#> 1 cli          8.27µs   8.98µs   108015.        0B    10.8 
#> 2 base          1.3µs   1.35µs   692472.        0B     0   
#> 3 cli_vec     29.16µs  30.06µs    32542.      448B     3.25
#> 4 base_vec    50.36µs  50.88µs    19413.      448B     2.01
#> 5 cli_txt     29.52µs  30.41µs    32217.        0B     3.22
#> 6 base_txt    86.52µs  87.11µs    11306.        0B     0
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
#> 1 cli          8.63µs   9.41µs   102977.        0B    10.3 
#> 2 base       871.02ns 922.13ns   984516.        0B     0   
#> 3 cli_vec     19.43µs  20.33µs    48003.      448B     9.60
#> 4 base_vec    11.48µs  11.73µs    83851.      448B     0   
#> 5 cli_txt     20.38µs  21.11µs    46439.        0B     4.64
#> 6 base_txt    12.52µs  12.59µs    78116.        0B     0
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
#> 1 cli          6.47µs   7.07µs   137066.    22.2KB    13.7 
#> 2 base         1.07µs   1.13µs   835192.        0B     0   
#> 3 cli_vec     29.33µs  30.15µs    32516.     1.7KB     3.25
#> 4 base_vec     8.11µs   8.45µs   116724.      848B     0   
#> 5 cli_txt      6.43µs   6.95µs   138786.        0B    27.8 
#> 6 base_txt     5.49µs   5.55µs   176305.        0B     0
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
#>  date     2026-10-01
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-10-01 [1] local
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
