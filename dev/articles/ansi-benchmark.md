# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x6256f2c78008\>
\<environment: 0x6256f3710268\>

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
#> 1 ansi        30.45µs  34.42µs    28427.    99.6KB     31.3
#> 2 plain       29.89µs  34.48µs    28330.        0B     31.2
#> 3 base         8.54µs   9.98µs    97349.    48.6KB     29.2
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
#> 1 ansi        31.75µs   36.3µs    26820.        0B     32.2
#> 2 plain       31.59µs   36.1µs    26976.        0B     32.4
#> 3 base         9.73µs   11.5µs    84134.        0B     33.7
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
#> 1 ansi        76.47µs  86.07µs    11335.   77.03KB     21.4
#> 2 plain       59.52µs  66.56µs    14539.    8.91KB     23.7
#> 3 base         1.24µs   1.42µs   665300.        0B      0
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
#> 1 ansi          230µs    251µs     3944.   33.23KB     30.6
#> 2 plain         209µs    245µs     4002.    1.09KB     23.0
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
#>  1 cli_ansi          4.24µs   4.87µs   196790.    9.27KB     19.7
#>  2 fansi_ansi       21.55µs  24.41µs    40049.    4.18KB     16.0
#>  3 cli_plain         4.29µs   4.89µs   197777.        0B     19.8
#>  4 fansi_plain      21.71µs  24.45µs    40011.      688B     20.0
#>  5 cli_vec_ansi      5.45µs   6.16µs   156447.      448B     15.6
#>  6 fansi_vec_ansi   28.78µs  31.88µs    30645.    5.02KB     12.3
#>  7 cli_vec_plain        6µs    6.7µs   145499.      448B     14.6
#>  8 fansi_vec_plain  28.71µs  31.98µs    30558.    5.02KB     12.2
#>  9 cli_txt_ansi      4.27µs   4.93µs   196039.        0B     19.6
#> 10 fansi_txt_ansi   21.97µs  24.74µs    39600.      688B     15.8
#> 11 cli_txt_plain        5µs   5.67µs   171017.        0B     17.1
#> 12 fansi_txt_plain  29.27µs  32.56µs    30037.    5.02KB     15.0
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
#> 1 cli          41.7µs   43.5µs    22623.    22.7KB     6.79
#> 2 fansi        83.6µs   88.1µs    11130.    55.3KB     6.13
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
#>  1 cli_ansi          4.98µs    5.8µs   166609.        0B    16.7 
#>  2 fansi_ansi       56.71µs  62.59µs    15655.   38.84KB    12.5 
#>  3 base_ansi       651.11ns  741.1ns  1194715.        0B     0   
#>  4 cli_plain         4.92µs   5.73µs   168723.        0B    16.9 
#>  5 fansi_plain      56.57µs  61.96µs    15784.      688B    14.6 
#>  6 base_plain      601.05ns 681.15ns  1300184.        0B     0   
#>  7 cli_vec_ansi     21.82µs  24.24µs    40832.      448B     4.08
#>  8 fansi_vec_ansi   72.97µs  79.04µs    12360.    5.02KB    10.5 
#>  9 base_vec_ansi    12.39µs  12.49µs    78701.      448B     0   
#> 10 cli_vec_plain    19.97µs  21.52µs    45639.      448B     4.56
#> 11 fansi_vec_plain  64.88µs   70.7µs    13835.    5.02KB    12.8 
#> 12 base_vec_plain    7.24µs   7.34µs   132945.      448B     0   
#> 13 cli_txt_ansi     21.74µs  23.38µs    42407.        0B     4.24
#> 14 fansi_txt_ansi   66.63µs   72.3µs    13479.      688B    12.5 
#> 15 base_txt_ansi    12.34µs  12.45µs    79138.        0B     0   
#> 16 cli_txt_plain    19.36µs  20.22µs    48642.        0B     4.86
#> 17 fansi_txt_plain  58.88µs   64.2µs    15250.      688B    12.5 
#> 18 base_txt_plain    7.19µs    7.3µs   134116.        0B     0
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
#>  1 cli_ansi          6.09µs   7.05µs   137179.        0B    27.4 
#>  2 fansi_ansi       57.05µs  62.27µs    15695.      688B    12.5 
#>  3 base_ansi       911.07ns   1.02µs   901193.        0B     0   
#>  4 cli_plain         6.06µs   7.03µs   137477.        0B    13.7 
#>  5 fansi_plain      56.08µs  61.79µs    15814.      688B    14.6 
#>  6 base_plain      751.11ns  841.1ns  1068651.        0B     0   
#>  7 cli_vec_ansi     26.47µs  27.69µs    35502.      448B     3.55
#>  8 fansi_vec_ansi   74.64µs  80.92µs    12070.    5.02KB    10.5 
#>  9 base_vec_ansi    32.16µs  32.75µs    30061.      448B     0   
#> 10 cli_vec_plain    25.21µs   26.6µs    37082.      448B     7.42
#> 11 fansi_vec_plain  66.96µs  72.41µs    13482.    5.02KB    10.5 
#> 12 base_vec_plain   16.88µs  17.16µs    56242.      448B     0   
#> 13 cli_txt_ansi     26.87µs  28.06µs    35016.        0B     7.00
#> 14 fansi_txt_ansi   68.98µs  74.66µs    13082.      688B    10.3 
#> 15 base_txt_ansi    33.89µs  34.36µs    28602.        0B     0   
#> 16 cli_txt_plain    24.87µs  25.99µs    37563.        0B     3.76
#> 17 fansi_txt_plain   60.6µs  68.51µs    13069.      688B    12.5 
#> 18 base_txt_plain   18.02µs  18.28µs    53950.        0B     0
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
#> 1 cli_ansi        4.77µs   5.33µs   181631.        0B    18.2 
#> 2 cli_plain       4.56µs   5.12µs   190557.        0B    19.1 
#> 3 cli_vec_ansi   22.86µs  23.84µs    41336.      848B     4.13
#> 4 cli_vec_plain   7.64µs   8.32µs   117517.      848B    11.8 
#> 5 cli_txt_ansi   22.48µs   23.5µs    42019.        0B     4.20
#> 6 cli_txt_plain   5.33µs    5.9µs   165912.        0B     0
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
#>  1 cli_ansi          18.7µs   20.3µs    48171.        0B    19.3 
#>  2 fansi_ansi        20.1µs     22µs    44482.    7.24KB    17.8 
#>  3 cli_plain         18.8µs   20.3µs    48045.        0B    19.2 
#>  4 fansi_plain       19.9µs   21.9µs    44450.      688B    17.8 
#>  5 cli_vec_ansi      25.4µs     28µs    35075.      848B    14.0 
#>  6 fansi_vec_ansi    40.3µs   43.3µs    22423.    5.41KB     8.97
#>  7 cli_vec_plain     21.2µs   23.2µs    41991.      848B    21.0 
#>  8 fansi_vec_plain   28.1µs   30.7µs    31907.    4.59KB    12.8 
#>  9 cli_txt_ansi      25.3µs   27.5µs    35152.        0B    14.1 
#> 10 fansi_txt_ansi    32.9µs   35.7µs    27463.    5.12KB    11.0 
#> 11 cli_txt_plain     19.7µs   21.7µs    44999.        0B    18.0 
#> 12 fansi_txt_plain   21.4µs   23.8µs    40997.      688B    16.4
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
#>  1 cli_ansi        104.25µs 113.09µs     8642.  104.86KB    17.0 
#>  2 fansi_ansi       84.89µs  93.66µs    10441.  106.35KB    14.8 
#>  3 base_ansi          2.8µs   3.15µs   309430.      224B     0   
#>  4 cli_plain        103.3µs  112.3µs     8701.    8.09KB    14.6 
#>  5 fansi_plain      83.67µs  92.23µs    10659.    9.62KB    17.0 
#>  6 base_plain        2.53µs   2.78µs   349078.        0B     0   
#>  7 cli_vec_ansi      5.19ms    5.4ms      185.  823.77KB    18.3 
#>  8 fansi_vec_ansi  792.01µs 838.81µs     1141.  846.81KB    22.0 
#>  9 base_vec_ansi   113.79µs 118.95µs     8207.    22.7KB     4.22
#> 10 cli_vec_plain     5.17ms   5.38ms      186.  823.77KB    18.6 
#> 11 fansi_vec_plain 751.15µs 796.64µs     1250.  845.98KB    24.7 
#> 12 base_vec_plain   76.48µs  80.43µs    12261.      848B     4.98
#> 13 cli_txt_ansi      2.42ms   2.52ms      398.    63.6KB     0   
#> 14 fansi_txt_ansi    1.24ms   1.26ms      787.   35.05KB     2.02
#> 15 base_txt_ansi    106.2µs 113.23µs     8871.   18.47KB     2.02
#> 16 cli_txt_plain     1.76ms    1.8ms      551.    63.6KB     2.02
#> 17 fansi_txt_plain 387.71µs 401.72µs     2466.    30.6KB     2.02
#> 18 base_txt_plain   67.33µs  69.05µs    14123.   11.05KB     4.07
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
#>  1 cli_ansi         100.8µs  105.9µs     9227.   33.84KB    16.8 
#>  2 fansi_ansi        38.5µs   41.8µs    23489.   31.42KB    16.5 
#>  3 base_ansi        771.1ns  851.1ns  1057394.     4.2KB   106.  
#>  4 cli_plain        100.7µs  108.8µs     9063.        0B    16.8 
#>  5 fansi_plain       38.1µs   42.5µs    23197.      872B    16.2 
#>  6 base_plain         731ns  811.1ns  1114753.        0B     0   
#>  7 cli_vec_ansi     193.2µs  203.3µs     4819.   16.73KB    10.5 
#>  8 fansi_vec_ansi    86.6µs   91.8µs    10736.    5.59KB     8.31
#>  9 base_vec_ansi     27.9µs   28.2µs    34973.      848B     0   
#> 10 cli_vec_plain    168.5µs  176.7µs     5574.   16.73KB    10.5 
#> 11 fansi_vec_plain   81.4µs   86.4µs    11407.    5.59KB     8.31
#> 12 base_vec_plain      23µs   23.2µs    42546.      848B     0   
#> 13 cli_txt_ansi     108.6µs  116.7µs     8434.        0B    17.1 
#> 14 fansi_txt_ansi    38.3µs   42.6µs    23115.      872B    16.2 
#> 15 base_txt_ansi    801.1ns  891.2ns  1011682.        0B     0   
#> 16 cli_txt_plain    102.4µs  110.7µs     8928.        0B    19.0 
#> 17 fansi_txt_plain   38.2µs   42.6µs    23101.      872B    16.2 
#> 18 base_txt_plain   751.1ns  831.1ns  1124971.        0B     0
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
#>  1 cli_ansi        278.49µs  301.7µs    3282.     6.18KB    14.7 
#>  2 fansi_ansi       67.75µs  75.14µs   13114.    97.33KB    16.9 
#>  3 base_ansi        25.08µs   27.8µs   35009.         0B    14.0 
#>  4 cli_plain       175.86µs 189.76µs    5158.         0B    16.9 
#>  5 fansi_plain      67.62µs  74.68µs   13131.       872B    14.7 
#>  6 base_plain        20.1µs  22.24µs   43690.         0B    17.5 
#>  7 cli_vec_ansi     28.89ms   29.2ms      34.1   94.67KB    30.3 
#>  8 fansi_vec_ansi  175.23µs 182.31µs    5414.     7.25KB     8.27
#>  9 base_vec_ansi     1.71ms   1.77ms     562.    48.18KB    15.0 
#> 10 cli_vec_plain    18.87ms  19.11ms      52.3    2.48KB    24.6 
#> 11 fansi_vec_plain  141.9µs 150.08µs    6571.     6.42KB    10.4 
#> 12 base_vec_plain    1.27ms   1.34ms     743.     47.4KB    15.0 
#> 13 cli_txt_ansi     20.68ms  20.96ms      47.7    4.27MB     6.81
#> 14 fansi_txt_ansi  172.42µs 180.87µs    5441.     6.77KB     6.14
#> 15 base_txt_ansi   992.45µs   1.04ms     943.   582.06KB    14.0 
#> 16 cli_txt_plain   991.78µs   1.03ms     957.   369.84KB    11.2 
#> 17 fansi_txt_plain  133.4µs 140.93µs    6999.     2.51KB     8.24
#> 18 base_txt_plain   676.6µs 716.85µs    1373.   367.31KB    11.3
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
#>  1 cli_ansi          5.01µs   5.83µs   165205.   25.09KB    16.5 
#>  2 fansi_ansi       55.94µs  61.83µs    15910.   28.48KB    14.7 
#>  3 base_ansi       751.11ns 861.59ns  1053779.        0B     0   
#>  4 cli_plain          4.9µs   5.81µs   166047.        0B    16.6 
#>  5 fansi_plain      55.74µs  61.73µs    15918.    1.98KB    14.7 
#>  6 base_plain      731.09ns 851.11ns  1055467.        0B     0   
#>  7 cli_vec_ansi      20.6µs  22.03µs    44597.     1.7KB     8.92
#>  8 fansi_vec_ansi      82µs  86.15µs    11372.    8.86KB    10.3 
#>  9 base_vec_ansi     4.71µs   5.07µs   194088.      848B     0   
#> 10 cli_vec_plain     17.9µs  18.88µs    52070.     1.7KB     5.21
#> 11 fansi_vec_plain  77.08µs  81.62µs    11997.    8.86KB    10.6 
#> 12 base_vec_plain    4.49µs   4.95µs   195470.      848B    19.5 
#> 13 cli_txt_ansi      4.96µs   5.63µs   173396.        0B    17.3 
#> 14 fansi_txt_ansi   54.63µs  58.06µs    16884.    1.98KB    14.8 
#> 15 base_txt_ansi     4.33µs   4.44µs   219645.        0B     0   
#> 16 cli_txt_plain     5.66µs   6.31µs   154581.        0B    30.9 
#> 17 fansi_txt_plain  55.14µs  60.78µs    16236.    1.98KB    14.9 
#> 18 base_txt_plain    2.76µs   2.88µs   334855.        0B     0
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
#>  1 cli_ansi        72.58µs  78.48µs   12490.     12.1KB    10.3 
#>  2 base_ansi      981.03ns   1.04µs  888944.         0B     0   
#>  3 cli_plain       57.68µs  61.77µs   15811.     8.91KB    12.5 
#>  4 base_plain      741.1ns 801.05ns 1152014.         0B     0   
#>  5 cli_vec_ansi     3.23ms   3.42ms     293.   838.95KB    18.0 
#>  6 base_vec_ansi   59.66µs  60.01µs   16400.       848B     0   
#>  7 cli_vec_plain    1.78ms   1.91ms     525.   817.08KB    17.3 
#>  8 base_vec_plain  35.25µs  35.62µs   27586.       848B     0   
#>  9 cli_txt_ansi    10.67ms  10.75ms      93.0   114.6KB     4.23
#> 10 base_txt_ansi   59.06µs  61.37µs   16200.         0B     0   
#> 11 cli_txt_plain  215.11µs 224.39µs    4389.    18.34KB     4.05
#> 12 base_txt_plain  34.19µs  34.97µs   28316.         0B     0
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
#>  1 cli_ansi         70.6µs   77.2µs    12717.        0B    19.3 
#>  2 base_ansi        11.9µs   13.3µs    73321.        0B    14.7 
#>  3 cli_plain        70.6µs   76.9µs    12751.        0B    16.8 
#>  4 base_plain       11.8µs   13.2µs    73661.        0B    14.7 
#>  5 cli_vec_ansi    138.3µs  144.6µs     6804.     7.2KB     8.27
#>  6 base_vec_ansi    39.5µs   43.9µs    22723.    1.66KB     4.55
#>  7 cli_vec_plain   128.8µs  135.5µs     7266.     7.2KB    10.4 
#>  8 base_vec_plain   35.7µs   37.6µs    26160.    1.66KB     5.23
#>  9 cli_txt_ansi    122.7µs  129.9µs     7557.        0B    10.3 
#> 10 base_txt_ansi    29.4µs     31µs    31693.        0B     6.34
#> 11 cli_txt_plain   112.7µs  118.8µs     8267.        0B    12.6 
#> 12 base_txt_plain   25.2µs   26.6µs    36882.        0B     7.38
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
#> 1 cli          5.82µs   6.79µs   142508.        0B    14.3 
#> 2 base       631.09ns 722.12ns  1218667.        0B     0   
#> 3 cli_vec     17.72µs  18.91µs    51970.      448B     5.20
#> 4 base_vec     9.43µs   9.62µs   101891.      448B    10.2 
#> 5 cli_txt     17.75µs  18.79µs    52244.        0B     5.22
#> 6 base_txt    10.12µs  10.24µs    95841.        0B     0
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
#> 1 cli          5.84µs    6.8µs   142159.        0B    14.2 
#> 2 base            1µs    1.1µs   838284.        0B     0   
#> 3 cli_vec     22.92µs   24.2µs    40667.      448B     8.13
#> 4 base_vec    41.99µs   43.3µs    22899.      448B     0   
#> 5 cli_txt     23.34µs   24.5µs    40252.        0B     4.03
#> 6 base_txt    72.48µs   73.4µs    13506.        0B     0
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
#> 1 cli          6.27µs   7.34µs   131934.        0B    13.2 
#> 2 base       631.09ns 731.09ns  1221344.        0B   122.  
#> 3 cli_vec      15.3µs  16.43µs    59783.      448B     5.98
#> 4 base_vec     9.44µs   9.62µs   102062.      448B     0   
#> 5 cli_txt     15.77µs  16.96µs    57849.        0B     5.79
#> 6 base_txt    10.12µs  10.31µs    95418.        0B     9.54
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
#> 1 cli          4.65µs   5.51µs   174634.    22.2KB    17.5 
#> 2 base       761.01ns 881.03ns  1031147.        0B     0   
#> 3 cli_vec     22.42µs  23.94µs    41204.     1.7KB     4.12
#> 4 base_vec      6.3µs   6.58µs   148084.      848B    14.8 
#> 5 cli_txt      4.68µs   5.52µs   174835.        0B    17.5 
#> 6 base_txt     3.92µs   4.08µs   238298.        0B     0
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
