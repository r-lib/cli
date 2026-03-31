# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x556202ed7a30\>
\<environment: 0x556203a28810\>

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
#> 1 ansi         45.3µs   48.7µs    19944.    99.3KB     18.9
#> 2 plain        45.3µs   48.6µs    19943.        0B     19.8
#> 3 base         11.3µs   12.4µs    77975.    48.4KB     15.6
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
#> 1 ansi           47µs   50.7µs    19133.        0B     21.3
#> 2 plain          47µs   50.6µs    19187.        0B     21.4
#> 3 base         13.3µs   14.6µs    66302.        0B     26.5
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
#> 1 ansi        109.4µs 116.87µs     8268.   75.07KB     14.6
#> 2 plain       87.99µs  93.15µs    10372.    8.73KB     14.7
#> 3 base         1.79µs   1.93µs   495030.        0B      0
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
#> 1 ansi          336µs    358µs     2755.   33.17KB     19.2
#> 2 plain         337µs    357µs     2760.    1.09KB     19.3
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
#>  1 cli_ansi          5.74µs   6.31µs   152515.     9.2KB     30.5
#>  2 fansi_ansi       30.76µs  33.74µs    28697.    4.18KB     23.0
#>  3 cli_plain         5.71µs   6.25µs   154186.        0B     30.8
#>  4 fansi_plain      29.76µs  32.74µs    29657.      688B     23.7
#>  5 cli_vec_ansi      7.04µs   7.46µs   130593.      448B     26.1
#>  6 fansi_vec_ansi   39.76µs   41.8µs    23268.    5.02KB     18.6
#>  7 cli_vec_plain     7.64µs   8.09µs   120600.      448B     24.1
#>  8 fansi_vec_plain  37.47µs  39.94µs    24264.    5.02KB     19.4
#>  9 cli_txt_ansi      5.64µs   6.02µs   160653.        0B     32.1
#> 10 fansi_txt_ansi   30.32µs  32.21µs    30131.      688B     24.1
#> 11 cli_txt_plain     6.46µs   6.89µs   141259.        0B     28.3
#> 12 fansi_txt_plain  37.69µs   39.7µs    24387.    5.02KB     19.5
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
#> 1 cli          56.2µs   57.7µs    16928.    22.7KB    10.3 
#> 2 fansi       118.4µs  121.5µs     8049.    55.3KB     8.22
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
#>  1 cli_ansi          6.71µs   7.26µs   133256.        0B    26.7 
#>  2 fansi_ansi       90.32µs  95.06µs    10176.   38.83KB    16.8 
#>  3 base_ansi       831.09ns 882.08ns  1046879.        0B     0   
#>  4 cli_plain         6.72µs   7.28µs   132264.        0B    26.5 
#>  5 fansi_plain      89.97µs  94.75µs    10239.      688B    16.8 
#>  6 base_plain      772.07ns 821.08ns  1109705.        0B   111.  
#>  7 cli_vec_ansi     28.53µs  29.32µs    33450.      448B     3.35
#>  8 fansi_vec_ansi  110.54µs 115.41µs     8376.    5.02KB    14.7 
#>  9 base_vec_ansi    14.68µs  14.76µs    66733.      448B     0   
#> 10 cli_vec_plain     26.6µs  27.35µs    35791.      448B     7.16
#> 11 fansi_vec_plain 100.48µs 105.54µs     9181.    5.02KB    14.7 
#> 12 base_vec_plain    8.77µs   8.83µs   110650.      448B     0   
#> 13 cli_txt_ansi     27.82µs  28.61µs    33968.        0B     6.80
#> 14 fansi_txt_ansi  101.96µs 107.12µs     8804.      688B    14.7 
#> 15 base_txt_ansi    14.27µs  14.35µs    68237.        0B     0   
#> 16 cli_txt_plain    26.12µs  26.79µs    36462.        0B     7.29
#> 17 fansi_txt_plain  92.02µs     97µs     9984.      688B    16.8 
#> 18 base_txt_plain    8.41µs   8.67µs   112310.        0B     0
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
#>  1 cli_ansi          8.37µs   9.01µs   107267.        0B    21.5 
#>  2 fansi_ansi       89.88µs  94.96µs    10214.      688B    16.8 
#>  3 base_ansi         1.18µs   1.22µs   764898.        0B     0   
#>  4 cli_plain         8.33µs   8.93µs   108201.        0B    32.5 
#>  5 fansi_plain      89.36µs  93.92µs    10297.      688B    16.9 
#>  6 base_plain      960.89ns      1µs   943865.        0B     0   
#>  7 cli_vec_ansi     34.72µs  35.62µs    27471.      448B     5.50
#>  8 fansi_vec_ansi  113.07µs 117.39µs     8247.    5.02KB    14.7 
#>  9 base_vec_ansi    42.53µs  42.82µs    23053.      448B     0   
#> 10 cli_vec_plain     33.1µs   33.9µs    28925.      448B     5.79
#> 11 fansi_vec_plain  103.1µs 107.32µs     8987.    5.02KB    14.7 
#> 12 base_vec_plain   22.22µs   22.5µs    43224.      448B     4.32
#> 13 cli_txt_ansi     34.71µs  35.47µs    27623.        0B     5.53
#> 14 fansi_txt_ansi  104.75µs  109.4µs     8889.      688B    14.6 
#> 15 base_txt_ansi    45.16µs  45.64µs    21628.        0B     0   
#> 16 cli_txt_plain    32.82µs   33.6µs    29194.        0B     5.84
#> 17 fansi_txt_plain  94.96µs 100.21µs     9664.      688B    16.8 
#> 18 base_txt_plain   23.77µs  24.61µs    40133.        0B     0
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
#> 1 cli_ansi         6.7µs   7.18µs   135150.        0B    13.5 
#> 2 cli_plain       6.33µs   6.77µs   143359.        0B    28.7 
#> 3 cli_vec_ansi   30.89µs   32.2µs    30466.      848B     6.09
#> 4 cli_vec_plain  10.14µs  10.78µs    89300.      848B     8.93
#> 5 cli_txt_ansi   30.59µs  31.69µs    31007.        0B     6.20
#> 6 cli_txt_plain   7.09µs   7.68µs   126193.        0B    12.6
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
#>  1 cli_ansi          25.5µs   27.2µs    35673.        0B     28.6
#>  2 fansi_ansi        28.2µs   30.1µs    32094.    7.24KB     25.7
#>  3 cli_plain         25.3µs   26.9µs    36128.        0B     28.9
#>  4 fansi_plain       27.5µs   29.5µs    32795.      688B     23.0
#>  5 cli_vec_ansi      34.3µs     36µs    26954.      848B     21.6
#>  6 fansi_vec_ansi    53.5µs     56µs    17354.    5.41KB     14.8
#>  7 cli_vec_plain       28µs   29.7µs    32526.      848B     26.0
#>  8 fansi_vec_plain   36.4µs   38.5µs    25136.    4.59KB     17.6
#>  9 cli_txt_ansi      33.5µs   35.2µs    27493.        0B     22.0
#> 10 fansi_txt_ansi    43.9µs   45.9µs    21141.    5.12KB     17.2
#> 11 cli_txt_plain     25.7µs     27µs    35993.        0B     28.8
#> 12 fansi_txt_plain   28.7µs   30.4µs    31884.      688B     25.5
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
#>  1 cli_ansi        163.27µs 171.51µs     5671.  104.34KB    19.0 
#>  2 fansi_ansi       127.4µs 134.19µs     7227.  106.35KB    19.1 
#>  3 base_ansi         3.95µs   4.39µs   222669.      224B    22.3 
#>  4 cli_plain       162.09µs  169.8µs     5706.    8.09KB    19.0 
#>  5 fansi_plain      126.8µs 133.43µs     7278.    9.62KB    19.2 
#>  6 base_plain        3.51µs   3.89µs   248244.        0B    24.8 
#>  7 cli_vec_ansi      7.55ms   7.79ms      128.  823.77KB    25.6 
#>  8 fansi_vec_ansi    1.03ms   1.07ms      906.  846.81KB    19.7 
#>  9 base_vec_ansi   152.69µs 159.14µs     6120.    22.7KB     2.04
#> 10 cli_vec_plain     7.58ms   7.74ms      128.  823.77KB    26.2 
#> 11 fansi_vec_plain 963.61µs   1.01ms      970.  845.98KB    19.7 
#> 12 base_vec_plain  105.49µs 108.92µs     9042.      848B     4.05
#> 13 cli_txt_ansi      3.41ms   3.64ms      278.    63.6KB     0   
#> 14 fansi_txt_ansi    1.56ms   1.58ms      630.   35.05KB     2.02
#> 15 base_txt_ansi   138.61µs 146.93µs     6741.   18.47KB     2.02
#> 16 cli_txt_plain     2.36ms   2.59ms      391.    63.6KB     0   
#> 17 fansi_txt_plain 512.94µs 531.98µs     1867.    30.6KB     6.17
#> 18 base_txt_plain   88.17µs  91.04µs    10783.   11.05KB     2.38
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
#>  1 cli_ansi        144.93µs 151.32µs     6422.   33.84KB     23.5
#>  2 fansi_ansi       53.57µs  56.83µs    17038.   31.42KB     24.0
#>  3 base_ansi         1.03µs   1.08µs   874188.     4.2KB      0  
#>  4 cli_plain       142.55µs 149.26µs     6522.        0B     23.5
#>  5 fansi_plain      52.83µs  56.21µs    17301.      872B     23.5
#>  6 base_plain         951ns   1.01µs   926288.        0B     92.6
#>  7 cli_vec_ansi    274.16µs 282.88µs     3468.   16.73KB     12.6
#>  8 fansi_vec_ansi  113.98µs 118.28µs     8182.    5.59KB     12.6
#>  9 base_vec_ansi    36.28µs   37.2µs    26558.      848B      0  
#> 10 cli_vec_plain   228.06µs 237.56µs     4115.   16.73KB     14.9
#> 11 fansi_vec_plain 107.39µs 111.37µs     8753.    5.59KB     14.7
#> 12 base_vec_plain   30.54µs  31.24µs    31600.      848B      0  
#> 13 cli_txt_ansi    153.74µs 160.08µs     6080.        0B     21.2
#> 14 fansi_txt_ansi   53.49µs   56.9µs    17046.      872B     23.6
#> 15 base_txt_ansi     1.07µs   1.12µs   845486.        0B      0  
#> 16 cli_txt_plain   143.75µs 150.48µs     6476.        0B     25.8
#> 17 fansi_txt_plain  52.61µs  56.24µs    17280.      872B     21.3
#> 18 base_txt_plain  982.08ns   1.02µs   918998.        0B     91.9
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
#>  1 cli_ansi        395.55µs 422.23µs    2231.         0B    17.3 
#>  2 fansi_ansi       96.83µs 104.08µs    9364.    97.32KB    10.4 
#>  3 base_ansi        37.24µs   39.8µs   24298.         0B    12.2 
#>  4 cli_plain       269.36µs 280.94µs    3480.         0B    12.4 
#>  5 fansi_plain      95.47µs 102.73µs    9486.       872B    10.4 
#>  6 base_plain       30.62µs  32.64µs   29655.         0B    11.9 
#>  7 cli_vec_ansi     41.58ms  42.02ms      23.8    2.48KB    23.8 
#>  8 fansi_vec_ansi  235.68µs 243.83µs    4022.     7.25KB     6.15
#>  9 base_vec_ansi     2.23ms   2.32ms     430.    48.18KB    12.8 
#> 10 cli_vec_plain    28.27ms  28.79ms      34.8    2.48KB    14.5 
#> 11 fansi_vec_plain  191.8µs 199.23µs    4853.     6.42KB     8.28
#> 12 base_vec_plain    1.61ms   1.68ms     595.     47.4KB    12.8 
#> 13 cli_txt_ansi     23.92ms  24.13ms      41.4  507.59KB     4.36
#> 14 fansi_txt_ansi  226.48µs 234.52µs    4184.     6.77KB     6.14
#> 15 base_txt_ansi     1.25ms   1.29ms     764.   582.06KB    11.3 
#> 16 cli_txt_plain     1.27ms    1.3ms     759.   369.84KB     8.68
#> 17 fansi_txt_plain  177.4µs 184.84µs    5298.     2.51KB     6.15
#> 18 base_txt_plain  847.41µs 884.35µs    1113.   367.31KB    11.1
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
#>  1 cli_ansi          6.72µs   7.37µs   129038.   24.83KB    12.9 
#>  2 fansi_ansi       78.02µs  83.56µs    11602.   28.48KB    12.5 
#>  3 base_ansi       981.03ns   1.03µs   896725.        0B     0   
#>  4 cli_plain         6.72µs   7.38µs   131386.        0B    13.1 
#>  5 fansi_plain      78.77µs  83.44µs    11630.    1.98KB    12.5 
#>  6 base_plain         951ns      1µs   931615.        0B     0   
#>  7 cli_vec_ansi      27.8µs  28.86µs    33903.     1.7KB     3.39
#>  8 fansi_vec_ansi  114.56µs 119.74µs     8104.    8.86KB     8.35
#>  9 base_vec_ansi     6.09µs   6.35µs   154241.      848B     0   
#> 10 cli_vec_plain    23.61µs  24.88µs    39288.     1.7KB     3.93
#> 11 fansi_vec_plain 109.31µs 113.76µs     8527.    8.86KB     8.36
#> 12 base_vec_plain     5.7µs   6.03µs   160664.      848B    16.1 
#> 13 cli_txt_ansi      6.72µs   7.36µs   131413.        0B    13.1 
#> 14 fansi_txt_ansi   78.74µs  83.66µs    11601.    1.98KB    10.5 
#> 15 base_txt_ansi     5.14µs   5.21µs   187053.        0B     0   
#> 16 cli_txt_plain     7.46µs   8.12µs   118520.        0B    23.7 
#> 17 fansi_txt_plain  78.71µs  82.96µs    11687.    1.98KB    10.4 
#> 18 base_txt_plain    3.37µs   3.44µs   281286.        0B     0
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
#>  1 cli_ansi       104.16µs 110.03µs    8817.    11.88KB     8.22
#>  2 base_ansi        1.28µs   1.34µs  711634.         0B     0   
#>  3 cli_plain       83.79µs  88.23µs   10959.     8.73KB     8.21
#>  4 base_plain     962.06ns   1.03µs  921111.         0B    92.1 
#>  5 cli_vec_ansi        4ms   4.08ms     243.   838.77KB    13.1 
#>  6 base_vec_ansi   71.81µs  72.11µs   13693.       848B     0   
#>  7 cli_vec_plain    2.26ms    2.3ms     433.    816.9KB    17.5 
#>  8 base_vec_plain  42.97µs  43.49µs   22721.       848B     0   
#>  9 cli_txt_ansi     13.5ms  13.56ms      73.6  114.42KB     2.04
#> 10 base_txt_ansi   73.54µs  74.09µs   13296.         0B     0   
#> 11 cli_txt_plain  258.97µs 267.64µs    3670.    18.16KB     4.06
#> 12 base_txt_plain  40.96µs  41.69µs   23660.         0B     0
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
#>  1 cli_ansi        105.7µs  111.7µs     8682.        0B    12.6 
#>  2 base_ansi        16.3µs   17.4µs    55667.        0B    11.1 
#>  3 cli_plain       106.5µs  112.2µs     8572.        0B    12.5 
#>  4 base_plain       16.3µs   17.3µs    55975.        0B    11.2 
#>  5 cli_vec_ansi    195.8µs  206.2µs     4727.     7.2KB     6.14
#>  6 base_vec_ansi    54.2µs   60.6µs    16445.    1.66KB     4.06
#>  7 cli_vec_plain     180µs    193µs     5066.     7.2KB     8.27
#>  8 base_vec_plain     49µs   55.3µs    18111.    1.66KB     4.06
#>  9 cli_txt_ansi    172.6µs  179.1µs     5436.        0B     6.11
#> 10 base_txt_ansi      38µs   39.3µs    24800.        0B     4.96
#> 11 cli_txt_plain   156.6µs  162.8µs     5973.        0B    10.3 
#> 12 base_txt_plain   33.4µs   34.9µs    27945.        0B     5.59
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
#> 1 cli          8.04µs   8.72µs   110964.        0B    11.1 
#> 2 base       821.08ns 872.07ns  1041555.        0B     0   
#> 3 cli_vec     22.93µs   23.8µs    41002.      448B     4.10
#> 4 base_vec    11.67µs  11.96µs    81996.      448B     8.20
#> 5 cli_txt     23.22µs  23.93µs    40317.        0B     4.03
#> 6 base_txt    12.31µs  12.52µs    78378.        0B     0
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
#> 1 cli          8.02µs    8.7µs   111518.        0B    11.2 
#> 2 base         1.24µs   1.31µs   684810.        0B    68.5 
#> 3 cli_vec     28.37µs  29.32µs    33376.      448B     3.34
#> 4 base_vec    51.41µs  51.95µs    19002.      448B     0   
#> 5 cli_txt     28.84µs  29.78µs    32891.        0B     3.29
#> 6 base_txt    87.94µs  88.81µs    11131.        0B     0
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
#> 1 cli          8.64µs   9.37µs   103062.        0B    20.6 
#> 2 base       821.08ns 872.07ns  1040792.        0B     0   
#> 3 cli_vec     19.65µs  20.56µs    47401.      448B     4.74
#> 4 base_vec    11.66µs  11.98µs    82049.      448B     0   
#> 5 cli_txt     20.05µs  20.82µs    46867.        0B     9.38
#> 6 base_txt     12.3µs   12.4µs    79126.        0B     0
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
#> 1 cli           6.3µs   6.92µs   139926.    22.1KB    14.0 
#> 2 base            1µs   1.06µs   864645.        0B    86.5 
#> 3 cli_vec     30.01µs  30.96µs    31685.     1.7KB     3.17
#> 4 base_vec      8.3µs   8.48µs   115662.      848B     0   
#> 5 cli_txt      6.35µs   6.97µs   138627.        0B    13.9 
#> 6 base_txt     5.42µs   5.51µs   177679.        0B     0
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
