# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55eb0c031860\>
\<environment: 0x55eb0cb5d460\>

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
#> 1 ansi           47µs   50.6µs    19098.    99.6KB     21.1
#> 2 plain        46.6µs   50.5µs    19137.        0B     20.0
#> 3 base         11.6µs   12.8µs    75875.    48.6KB     22.8
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
#> 1 ansi         48.9µs   52.6µs    18386.        0B     21.4
#> 2 plain        48.7µs   52.5µs    18400.        0B     21.2
#> 3 base         13.5µs     15µs    64326.        0B     25.7
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
#> 1 ansi          117µs  124.7µs     7753.   77.03KB     16.9
#> 2 plain       93.33µs  98.87µs     9760.    8.91KB     14.6
#> 3 base         1.89µs   2.01µs   478662.        0B      0
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
#> 1 ansi          350µs    376µs     2626.   33.24KB     21.4
#> 2 plain         350µs    374µs     2640.    1.09KB     19.2
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
#>  1 cli_ansi          5.88µs   6.49µs   147328.    9.27KB    29.5 
#>  2 fansi_ansi       31.87µs  35.04µs    27620.    4.18KB    24.9 
#>  3 cli_plain         5.88µs   6.44µs   149316.        0B    29.9 
#>  4 fansi_plain      30.95µs  33.35µs    28387.      688B    14.2 
#>  5 cli_vec_ansi       7.2µs   7.73µs   124322.      448B    12.4 
#>  6 fansi_vec_ansi   41.08µs  43.54µs    21938.    5.02KB     8.78
#>  7 cli_vec_plain     7.78µs   8.27µs   117699.      448B    11.8 
#>  8 fansi_vec_plain  38.86µs  41.22µs    23361.    5.02KB    11.7 
#>  9 cli_txt_ansi      5.84µs   6.24µs   155339.        0B    15.5 
#> 10 fansi_txt_ansi   31.08µs  33.19µs    29140.      688B    11.7 
#> 11 cli_txt_plain     6.62µs   7.05µs   137292.        0B    13.7 
#> 12 fansi_txt_plain  39.15µs  41.85µs    23161.    5.02KB     9.27
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
#> 1 cli          56.5µs   58.5µs    16669.    22.7KB     6.13
#> 2 fansi       119.1µs  126.7µs     7785.    55.3KB     4.06
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
#>  1 cli_ansi          6.97µs   7.58µs   127924.        0B    12.8 
#>  2 fansi_ansi       92.97µs  98.22µs     9835.   38.84KB     8.19
#>  3 base_ansi       892.09ns 942.15ns   982227.        0B     0   
#>  4 cli_plain         6.92µs   7.58µs   127759.        0B    12.8 
#>  5 fansi_plain      91.76µs  97.49µs     9940.      688B    10.3 
#>  6 base_plain      821.08ns 862.05ns  1087676.        0B     0   
#>  7 cli_vec_ansi     29.33µs  30.26µs    32356.      448B     3.24
#>  8 fansi_vec_ansi  113.12µs 119.56µs     8111.    5.02KB     6.16
#>  9 base_vec_ansi    18.46µs  18.54µs    53059.      448B     0   
#> 10 cli_vec_plain    28.11µs  29.02µs    33658.      448B     3.37
#> 11 fansi_vec_plain 103.61µs  109.9µs     8823.    5.02KB     8.27
#> 12 base_vec_plain   10.82µs  10.89µs    90003.      448B     0   
#> 13 cli_txt_ansi     29.46µs  30.21µs    32403.        0B     3.24
#> 14 fansi_txt_ansi  104.89µs 110.63µs     8753.      688B     8.20
#> 15 base_txt_ansi    18.21µs  18.27µs    53892.        0B     0   
#> 16 cli_txt_plain    27.69µs  28.46µs    34272.        0B     3.43
#> 17 fansi_txt_plain  94.17µs  99.96µs     9691.      688B     8.20
#> 18 base_txt_plain   10.59µs  11.11µs    88665.        0B     0
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
#>  1 cli_ansi          8.44µs   9.26µs   104487.        0B    20.9 
#>  2 fansi_ansi       92.12µs  98.52µs     9821.      688B     8.30
#>  3 base_ansi         1.23µs   1.28µs   730150.        0B     0   
#>  4 cli_plain         8.46µs   9.27µs   104345.        0B    10.4 
#>  5 fansi_plain      92.77µs   97.8µs     9876.      688B     8.19
#>  6 base_plain        1.01µs   1.06µs   876884.        0B     0   
#>  7 cli_vec_ansi      34.7µs  35.73µs    27173.      448B     5.44
#>  8 fansi_vec_ansi  116.86µs 122.57µs     7866.    5.02KB     6.16
#>  9 base_vec_ansi    44.05µs  44.44µs    22195.      448B     0   
#> 10 cli_vec_plain     33.4µs  34.26µs    28565.      448B     2.86
#> 11 fansi_vec_plain 105.44µs 111.12µs     8703.    5.02KB     8.25
#> 12 base_vec_plain   23.05µs   23.8µs    41727.      448B     0   
#> 13 cli_txt_ansi     34.99µs  35.88µs    27241.        0B     2.72
#> 14 fansi_txt_ansi  106.66µs 112.35µs     8625.      688B     8.20
#> 15 base_txt_ansi    46.63µs   47.2µs    20911.        0B     0   
#> 16 cli_txt_plain       33µs  33.81µs    28987.        0B     2.90
#> 17 fansi_txt_plain  97.34µs 102.82µs     9399.      688B     8.21
#> 18 base_txt_plain   24.91µs  25.33µs    38966.        0B     3.90
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
#> 1 cli_ansi        6.87µs   7.42µs   130295.        0B    13.0 
#> 2 cli_plain       6.43µs   7.08µs   136534.        0B    13.7 
#> 3 cli_vec_ansi   32.28µs  33.26µs    29416.      848B     0   
#> 4 cli_vec_plain  10.36µs  11.13µs    87285.      848B     8.73
#> 5 cli_txt_ansi   31.69µs  33.12µs    29504.        0B     2.95
#> 6 cli_txt_plain   7.31µs   7.97µs   113116.        0B    11.3
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
#>  1 cli_ansi          26.3µs   28.1µs    34508.        0B    17.3 
#>  2 fansi_ansi          29µs   30.9µs    31177.    7.24KB    12.5 
#>  3 cli_plain         25.8µs   27.6µs    35004.        0B    14.0 
#>  4 fansi_plain       28.3µs   30.6µs    30480.      688B    12.2 
#>  5 cli_vec_ansi      35.1µs     37µs    26304.      848B    10.5 
#>  6 fansi_vec_ansi      56µs   59.3µs    16422.    5.41KB     8.32
#>  7 cli_vec_plain     28.6µs   30.4µs    31867.      848B    12.8 
#>  8 fansi_vec_plain   37.2µs   39.3µs    24661.    4.59KB     9.87
#>  9 cli_txt_ansi        34µs   35.4µs    27347.        0B    10.9 
#> 10 fansi_txt_ansi    44.2µs   45.9µs    20883.    5.12KB     8.36
#> 11 cli_txt_plain     26.5µs   27.7µs    34897.        0B    14.0 
#> 12 fansi_txt_plain     29µs   30.6µs    31735.      688B    12.7
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
#>  1 cli_ansi        165.15µs 173.99µs     5540.  104.86KB     8.21
#>  2 fansi_ansi      129.87µs  137.4µs     7094.  106.35KB    10.4 
#>  3 base_ansi         4.18µs    4.5µs   215570.      224B    21.6 
#>  4 cli_plain       164.44µs 171.72µs     5627.    8.09KB    10.3 
#>  5 fansi_plain     127.56µs 134.87µs     7219.    9.62KB    10.4 
#>  6 base_plain        3.68µs   3.93µs   246960.        0B     0   
#>  7 cli_vec_ansi       7.8ms   7.96ms      126.  823.77KB    11.2 
#>  8 fansi_vec_ansi    1.07ms    1.1ms      883.  846.81KB    17.4 
#>  9 base_vec_ansi   154.29µs 158.79µs     6154.    22.7KB     2.03
#> 10 cli_vec_plain     7.68ms   7.89ms      126.  823.77KB    14.0 
#> 11 fansi_vec_plain   1.02ms   1.05ms      944.  845.98KB    17.8 
#> 12 base_vec_plain  108.23µs 111.25µs     8845.      848B     2.02
#> 13 cli_txt_ansi      3.32ms   3.44ms      290.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.56ms   1.58ms      632.   35.05KB     0   
#> 15 base_txt_ansi   137.01µs 140.96µs     6976.   18.47KB     2.02
#> 16 cli_txt_plain      2.5ms   2.53ms      393.    63.6KB     0   
#> 17 fansi_txt_plain 516.81µs 538.01µs     1844.    30.6KB     4.08
#> 18 base_txt_plain  212.47µs 325.46µs     3061.   11.05KB     0
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
#>  1 cli_ansi        149.33µs  158.1µs     6070.   33.84KB    12.5 
#>  2 fansi_ansi        55.3µs  59.41µs    16272.   31.42KB    10.4 
#>  3 base_ansi         1.05µs    1.1µs   817289.     4.2KB    81.7 
#>  4 cli_plain       146.74µs 154.18µs     6279.        0B    12.4 
#>  5 fansi_plain      55.12µs  59.11µs    16330.      872B    10.3 
#>  6 base_plain      991.04ns   1.02µs   909189.        0B     0   
#>  7 cli_vec_ansi    279.31µs 292.43µs     3350.   16.73KB     6.18
#>  8 fansi_vec_ansi  117.77µs 121.97µs     7956.    5.59KB     8.29
#>  9 base_vec_ansi    36.62µs  37.27µs    26459.      848B     0   
#> 10 cli_vec_plain   236.32µs 246.27µs     3963.   16.73KB     6.31
#> 11 fansi_vec_plain 110.06µs 114.46µs     8500.    5.59KB     8.30
#> 12 base_vec_plain   30.16µs  30.71µs    32126.      848B     0   
#> 13 cli_txt_ansi    158.06µs 165.46µs     5851.        0B    10.3 
#> 14 fansi_txt_ansi   55.65µs  59.52µs    16242.      872B    12.5 
#> 15 base_txt_ansi     1.08µs   1.13µs   809179.        0B     0   
#> 16 cli_txt_plain   146.97µs 157.24µs     6179.        0B    12.4 
#> 17 fansi_txt_plain  54.18µs  56.74µs    17083.      872B    12.5 
#> 18 base_txt_plain       1µs   1.04µs   919562.        0B     0
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
#>  1 cli_ansi        426.98µs  455.2µs    2187.     6.18KB    10.4 
#>  2 fansi_ansi       98.06µs 103.95µs    9323.    97.33KB    12.6 
#>  3 base_ansi        39.11µs  41.31µs   23285.         0B     9.32
#>  4 cli_plain        280.4µs 292.96µs    3322.         0B    10.3 
#>  5 fansi_plain      96.45µs 104.04µs    9318.       872B    10.3 
#>  6 base_plain       31.73µs  33.75µs   28398.         0B    11.4 
#>  7 cli_vec_ansi      45.3ms  45.92ms      21.8   94.67KB    18.1 
#>  8 fansi_vec_ansi  240.73µs 250.57µs    3915.     7.25KB     6.14
#>  9 base_vec_ansi      2.3ms   2.37ms     419.    48.18KB    12.9 
#> 10 cli_vec_plain    29.33ms  29.61ms      33.8    2.48KB    14.1 
#> 11 fansi_vec_plain 191.92µs 200.64µs    4866.     6.42KB     6.14
#> 12 base_vec_plain    1.68ms   1.73ms     575.     47.4KB    13.0 
#> 13 cli_txt_ansi     27.97ms  28.11ms      35.4    4.27MB     7.08
#> 14 fansi_txt_ansi  227.28µs 236.18µs    4155.     6.77KB     4.06
#> 15 base_txt_ansi     1.29ms   1.32ms     749.   582.06KB    11.2 
#> 16 cli_txt_plain     1.32ms   1.36ms     727.   369.84KB     8.68
#> 17 fansi_txt_plain 178.36µs 186.21µs    5235.     2.51KB     6.14
#> 18 base_txt_plain  876.05µs 906.01µs    1080.   367.31KB     8.68
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
#>  1 cli_ansi          6.92µs   7.54µs   127701.   25.09KB    12.8 
#>  2 fansi_ansi       80.32µs  86.28µs    11210.   28.48KB    10.4 
#>  3 base_ansi         1.05µs   1.11µs   837260.        0B     0   
#>  4 cli_plain         6.63µs   7.36µs   131376.        0B    13.1 
#>  5 fansi_plain      79.74µs  85.32µs    11322.    1.98KB    10.4 
#>  6 base_plain           1µs   1.07µs   842420.        0B    84.3 
#>  7 cli_vec_ansi     26.74µs  27.75µs    35292.     1.7KB     3.53
#>  8 fansi_vec_ansi  119.29µs 124.93µs     7769.    8.86KB     6.29
#>  9 base_vec_ansi     6.39µs   6.74µs   144143.      848B    14.4 
#> 10 cli_vec_plain    23.39µs  24.44µs    38214.     1.7KB     3.82
#> 11 fansi_vec_plain  113.5µs 118.99µs     8158.    8.86KB     8.36
#> 12 base_vec_plain    6.22µs   6.39µs   152142.      848B     0   
#> 13 cli_txt_ansi      6.73µs   7.37µs   129847.        0B    13.0 
#> 14 fansi_txt_ansi   79.73µs  85.25µs    11259.    1.98KB    10.4 
#> 15 base_txt_ansi     6.48µs   6.55µs   148390.        0B     0   
#> 16 cli_txt_plain     7.57µs   8.24µs   116288.        0B    11.6 
#> 17 fansi_txt_plain  80.09µs  85.24µs    11321.    1.98KB    12.5 
#> 18 base_txt_plain    4.11µs   4.18µs   231964.        0B     0
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
#>  1 cli_ansi       110.62µs 115.48µs    8340.     12.1KB     9.79
#>  2 base_ansi        1.33µs   1.37µs  705577.         0B     0   
#>  3 cli_plain       89.33µs  93.47µs   10311.     8.91KB     6.12
#>  4 base_plain       1.03µs   1.07µs  893908.         0B    89.4 
#>  5 cli_vec_ansi     4.16ms   4.29ms     231.   838.95KB    13.1 
#>  6 base_vec_ansi   75.45µs  76.23µs   12947.       848B     0   
#>  7 cli_vec_plain    2.33ms    2.4ms     414.   817.08KB    15.1 
#>  8 base_vec_plain  45.93µs   46.4µs   21200.       848B     0   
#>  9 cli_txt_ansi    14.97ms  15.12ms      66.0   114.6KB     2.06
#> 10 base_txt_ansi   76.15µs  76.41µs   12893.         0B     0   
#> 11 cli_txt_plain   295.1µs 308.14µs    3176.    18.34KB     2.01
#> 12 base_txt_plain   42.4µs  43.93µs   22571.         0B     0
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
#>  1 cli_ansi        110.2µs  115.5µs     8359.        0B    10.3 
#>  2 base_ansi        16.6µs   17.8µs    54504.        0B    10.9 
#>  3 cli_plain         109µs  114.5µs     8432.        0B    12.4 
#>  4 base_plain       16.5µs   17.7µs    54686.        0B    10.9 
#>  5 cli_vec_ansi    210.7µs  219.7µs     4436.     7.2KB     6.16
#>  6 base_vec_ansi    59.2µs   65.9µs    14907.    1.66KB     2.02
#>  7 cli_vec_plain   197.8µs  207.3µs     4706.     7.2KB     8.28
#>  8 base_vec_plain   52.4µs   58.3µs    16747.    1.66KB     2.02
#>  9 cli_txt_ansi    184.9µs  192.2µs     5005.        0B     8.22
#> 10 base_txt_ansi      41µs   42.4µs    22913.        0B     4.58
#> 11 cli_txt_plain   170.3µs  175.9µs     5534.        0B     6.11
#> 12 base_txt_plain   35.6µs   36.9µs    26366.        0B     5.27
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
#> 1 cli          8.23µs   8.87µs   109290.        0B    10.9 
#> 2 base       871.02ns 922.13ns   988915.        0B     0   
#> 3 cli_vec     23.64µs  24.61µs    39612.      448B     3.96
#> 4 base_vec    11.45µs   11.7µs    77798.      448B     0   
#> 5 cli_txt     23.82µs  24.69µs    39334.        0B     3.93
#> 6 base_txt    12.52µs   12.6µs    77851.        0B     7.79
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
#> 1 cli          8.21µs   9.08µs   107333.        0B    10.7 
#> 2 base         1.29µs   1.34µs   704065.        0B     0   
#> 3 cli_vec     29.21µs  30.19µs    32295.      448B     3.23
#> 4 base_vec     50.6µs  50.94µs    18894.      448B     0   
#> 5 cli_txt     29.53µs  30.39µs    32159.        0B     6.43
#> 6 base_txt    86.87µs  87.81µs    11263.        0B     0
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
#> 1 cli          8.75µs   9.54µs   101597.        0B    10.2 
#> 2 base       861.01ns  902.1ns  1007210.        0B     0   
#> 3 cli_vec     19.55µs  20.62µs    47355.      448B     9.47
#> 4 base_vec    11.49µs  11.69µs    83987.      448B     0   
#> 5 cli_txt     20.39µs   21.3µs    45807.        0B     4.58
#> 6 base_txt    12.53µs   12.6µs    78067.        0B     0
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
#> 1 cli           6.4µs   7.01µs   136729.    22.2KB    27.4 
#> 2 base         1.06µs   1.13µs   820015.        0B     0   
#> 3 cli_vec     29.34µs  30.29µs    32400.     1.7KB     3.24
#> 4 base_vec     8.12µs   8.35µs   117775.      848B     0   
#> 5 cli_txt       6.3µs   6.92µs   139567.        0B    14.0 
#> 6 base_txt     5.47µs   5.55µs   173432.        0B    17.3
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
