# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55f7d71bedc0\>
\<environment: 0x55f7d7cea9c0\>

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
#> 1 ansi        29.05µs  32.98µs    29742.    99.6KB     29.8
#> 2 plain       29.32µs  32.95µs    29737.        0B     32.7
#> 3 base         8.34µs   9.62µs   100940.    48.6KB     20.2
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
#> 1 ansi        30.61µs   35.2µs    27862.        0B     33.5
#> 2 plain       30.87µs   34.4µs    28533.        0B     34.3
#> 3 base         9.66µs   11.2µs    86544.        0B     34.6
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
#> 1 ansi        78.02µs  84.97µs    11487.   77.03KB     23.4
#> 2 plain       59.41µs  65.53µs    14901.    8.91KB     21.1
#> 3 base         1.44µs   1.63µs   579143.        0B     57.9
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
#> 1 ansi          210µs    237µs     4187.   33.24KB     30.3
#> 2 plain         210µs    232µs     4209.    1.09KB     25.5
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
#>  1 cli_ansi          4.25µs   4.93µs   192898.    9.27KB     19.3
#>  2 fansi_ansi       21.37µs  23.94µs    40709.    4.18KB     16.3
#>  3 cli_plain         4.27µs   4.93µs   196708.        0B     19.7
#>  4 fansi_plain      21.15µs  23.92µs    40899.      688B     16.4
#>  5 cli_vec_ansi      5.38µs   6.09µs   159758.      448B     16.0
#>  6 fansi_vec_ansi   28.64µs  31.57µs    30895.    5.02KB     15.5
#>  7 cli_vec_plain     5.94µs   6.73µs   144573.      448B     14.5
#>  8 fansi_vec_plain  27.63µs  30.98µs    31665.    5.02KB     12.7
#>  9 cli_txt_ansi      4.24µs   4.93µs   196303.        0B     19.6
#> 10 fansi_txt_ansi    21.3µs  23.88µs    40982.      688B     16.4
#> 11 cli_txt_plain        5µs   5.64µs   172108.        0B     17.2
#> 12 fansi_txt_plain  27.97µs  31.11µs    31485.    5.02KB     15.8
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
#> 1 cli          43.4µs   45.3µs    21689.    22.7KB     6.51
#> 2 fansi        86.2µs   90.9µs    10813.    55.3KB     6.11
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
#>  1 cli_ansi          5.12µs   5.91µs   163334.        0B    16.3 
#>  2 fansi_ansi        56.9µs  62.53µs    15629.   38.84KB    12.4 
#>  3 base_ansi       711.07ns 791.04ns  1135011.        0B   114.  
#>  4 cli_plain         5.04µs   5.86µs   165698.        0B     0   
#>  5 fansi_plain      56.75µs  62.24µs    15749.      688B    14.6 
#>  6 base_plain      650.99ns 711.07ns  1256729.        0B     0   
#>  7 cli_vec_ansi     23.55µs  24.51µs    40160.      448B     4.02
#>  8 fansi_vec_ansi   73.92µs  79.79µs    12296.    5.02KB    10.4 
#>  9 base_vec_ansi    15.84µs  15.94µs    61651.      448B     0   
#> 10 cli_vec_plain    21.74µs  22.84µs    43304.      448B     4.33
#> 11 fansi_vec_plain  66.21µs  71.78µs    13675.    5.02KB    12.6 
#> 12 base_vec_plain    9.17µs   9.26µs   105749.      448B     0   
#> 13 cli_txt_ansi     23.48µs  24.44µs    40332.        0B     4.03
#> 14 fansi_txt_ansi   66.78µs  72.46µs    13553.      688B    12.4 
#> 15 base_txt_ansi    15.82µs  15.91µs    61908.        0B     0   
#> 16 cli_txt_plain    21.47µs   22.4µs    43943.        0B     4.39
#> 17 fansi_txt_plain  58.05µs  63.99µs    15100.      688B    12.4 
#> 18 base_txt_plain    9.13µs   9.21µs   106317.        0B     0
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
#>  1 cli_ansi          6.17µs   7.09µs   136031.        0B    13.6 
#>  2 fansi_ansi       57.16µs  62.11µs    15753.      688B    14.6 
#>  3 base_ansi       951.11ns   1.04µs   898035.        0B     0   
#>  4 cli_plain         6.15µs      7µs   137909.        0B    13.8 
#>  5 fansi_plain      56.69µs  62.18µs    15747.      688B    12.4 
#>  6 base_plain      791.04ns 872.07ns  1035875.        0B   104.  
#>  7 cli_vec_ansi     26.26µs  27.31µs    35958.      448B     3.60
#>  8 fansi_vec_ansi   75.52µs   81.3µs    12021.    5.02KB    10.5 
#>  9 base_vec_ansi    34.99µs  35.95µs    27550.      448B     0   
#> 10 cli_vec_plain    24.97µs  26.11µs    37691.      448B     3.77
#> 11 fansi_vec_plain  67.54µs  73.41µs    13327.    5.02KB    12.6 
#> 12 base_vec_plain   18.28µs  18.53µs    53188.      448B     0   
#> 13 cli_txt_ansi      26.8µs  27.89µs    35274.        0B     3.53
#> 14 fansi_txt_ansi   69.14µs  74.98µs    13028.      688B    12.4 
#> 15 base_txt_ansi    36.52µs  37.63µs    26292.        0B     0   
#> 16 cli_txt_plain    24.85µs  25.94µs    37963.        0B     3.80
#> 17 fansi_txt_plain  61.08µs  66.31µs    14771.      688B    12.4 
#> 18 base_txt_plain    20.1µs  20.35µs    48495.        0B     0
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
#> 1 cli_ansi        4.93µs   5.48µs   178486.        0B     0   
#> 2 cli_plain       4.72µs   5.24µs   186744.        0B    18.7 
#> 3 cli_vec_ansi   23.74µs  24.51µs    40195.      848B     4.02
#> 4 cli_vec_plain   7.88µs   8.47µs   115441.      848B    11.5 
#> 5 cli_txt_ansi   23.53µs  24.81µs    39778.        0B     3.98
#> 6 cli_txt_plain   5.43µs      6µs   163297.        0B    16.3
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
#>  1 cli_ansi          18.5µs   19.9µs    49101.        0B    19.6 
#>  2 fansi_ansi        19.7µs   21.4µs    45398.    7.24KB    18.2 
#>  3 cli_plain         18.4µs   19.8µs    49388.        0B    24.7 
#>  4 fansi_plain       19.5µs   21.4µs    45410.      688B    18.2 
#>  5 cli_vec_ansi      25.8µs   28.3µs    34599.      848B    13.8 
#>  6 fansi_vec_ansi    40.3µs   43.4µs    22612.    5.41KB     9.05
#>  7 cli_vec_plain     21.1µs     23µs    42466.      848B    17.0 
#>  8 fansi_vec_plain   27.4µs   29.9µs    32741.    4.59KB    13.1 
#>  9 cli_txt_ansi      25.5µs     28µs    35048.        0B    17.5 
#> 10 fansi_txt_ansi    32.9µs   35.4µs    27641.    5.12KB    11.1 
#> 11 cli_txt_plain     19.3µs   21.2µs    46118.        0B    18.5 
#> 12 fansi_txt_plain   20.5µs   22.6µs    43041.      688B    17.2
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
#>  1 cli_ansi        102.69µs 111.82µs     8753.  104.86KB    17.0 
#>  2 fansi_ansi       84.68µs  92.44µs    10655.  106.35KB    14.7 
#>  3 base_ansi         3.08µs    3.4µs   287385.      224B     0   
#>  4 cli_plain       102.72µs 111.11µs     8794.    8.09KB    16.8 
#>  5 fansi_plain      83.76µs  91.97µs    10710.    9.62KB    14.7 
#>  6 base_plain        2.69µs   2.92µs   328345.        0B     0   
#>  7 cli_vec_ansi      5.08ms    5.3ms      188.  823.77KB    18.4 
#>  8 fansi_vec_ansi  798.13µs 842.13µs     1112.  846.81KB    24.8 
#>  9 base_vec_ansi   120.57µs 125.67µs     7843.    22.7KB     4.14
#> 10 cli_vec_plain     5.02ms   5.28ms      189.  823.77KB    18.6 
#> 11 fansi_vec_plain 750.43µs 795.14µs     1229.  845.98KB    26.4 
#> 12 base_vec_plain   82.69µs  87.15µs    11272.      848B     2.01
#> 13 cli_txt_ansi      2.63ms   2.72ms      366.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.25ms   1.27ms      785.   35.05KB     0   
#> 15 base_txt_ansi   109.02µs 117.75µs     8446.   18.47KB     4.09
#> 16 cli_txt_plain        2ms   2.02ms      493.    63.6KB     0   
#> 17 fansi_txt_plain 408.06µs 439.02µs     2268.    30.6KB     4.08
#> 18 base_txt_plain   70.62µs  73.05µs    13406.   11.05KB     2.02
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
#>  1 cli_ansi          97.4µs  103.1µs     9491.   33.84KB    18.9 
#>  2 fansi_ansi        38.3µs   41.5µs    23585.   31.42KB    16.5 
#>  3 base_ansi        821.1ns  902.1ns  1027150.     4.2KB     0   
#>  4 cli_plain         98.3µs  105.8µs     9308.        0B    18.9 
#>  5 fansi_plain       37.8µs   41.9µs    23478.      872B    16.4 
#>  6 base_plain         761ns  831.1ns  1120987.        0B     0   
#>  7 cli_vec_ansi     196.6µs  205.8µs     4801.   16.73KB     8.28
#>  8 fansi_vec_ansi    89.1µs   93.8µs    10517.    5.59KB    10.4 
#>  9 base_vec_ansi       29µs   29.4µs    33649.      848B     0   
#> 10 cli_vec_plain    166.7µs  175.2µs     5635.   16.73KB    10.5 
#> 11 fansi_vec_plain     82µs   86.3µs    11420.    5.59KB     8.28
#> 12 base_vec_plain    24.1µs   24.5µs    40377.      848B     0   
#> 13 cli_txt_ansi     105.4µs    113µs     8720.        0B    19.1 
#> 14 fansi_txt_ansi    38.1µs     42µs    23433.      872B    16.4 
#> 15 base_txt_ansi    831.1ns  921.1ns  1022750.        0B     0   
#> 16 cli_txt_plain     99.8µs  106.4µs     9271.        0B    16.7 
#> 17 fansi_txt_plain   37.4µs   42.1µs    23328.      872B    18.7 
#> 18 base_txt_plain   770.9ns    842ns  1104544.        0B     0
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
#>  1 cli_ansi        278.13µs 300.07µs    3304.     6.18KB    16.8 
#>  2 fansi_ansi       68.38µs  75.47µs   13002.    97.33KB    14.9 
#>  3 base_ansi        25.25µs  27.57µs   35416.         0B    14.2 
#>  4 cli_plain       175.87µs 186.81µs    5259.         0B    16.8 
#>  5 fansi_plain      67.75µs  75.64µs   12986.       872B    16.9 
#>  6 base_plain       19.93µs  21.42µs   45756.         0B    13.7 
#>  7 cli_vec_ansi     28.21ms  28.44ms      35.1   94.67KB    31.2 
#>  8 fansi_vec_ansi  181.42µs  187.9µs    5243.     7.25KB     8.23
#>  9 base_vec_ansi     1.68ms   1.74ms     571.    48.18KB    17.5 
#> 10 cli_vec_plain    18.11ms  18.48ms      53.9    2.48KB    24.0 
#> 11 fansi_vec_plain 145.22µs 153.02µs    6453.     6.42KB     8.25
#> 12 base_vec_plain    1.24ms    1.3ms     767.     47.4KB    17.2 
#> 13 cli_txt_ansi     22.25ms  22.48ms      44.5    4.27MB     7.03
#> 14 fansi_txt_ansi  177.29µs 186.24µs    5308.     6.77KB     6.12
#> 15 base_txt_ansi        1ms   1.05ms     940.   582.06KB    13.7 
#> 16 cli_txt_plain   996.56µs   1.04ms     950.   369.84KB    11.0 
#> 17 fansi_txt_plain 135.46µs 144.08µs    6839.     2.51KB     8.29
#> 18 base_txt_plain  677.57µs 719.11µs    1382.   367.31KB    11.1
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
#>  1 cli_ansi          5.07µs   5.87µs   163866.   25.09KB    16.4 
#>  2 fansi_ansi        55.2µs  61.36µs    16008.   28.48KB    14.7 
#>  3 base_ansi       820.96ns 891.97ns  1014566.        0B     0   
#>  4 cli_plain         5.01µs   5.87µs   164282.        0B    16.4 
#>  5 fansi_plain      54.44µs  61.06µs    16064.    1.98KB    16.9 
#>  6 base_plain      771.02ns 861.01ns  1065638.        0B     0   
#>  7 cli_vec_ansi     20.53µs  21.82µs    45018.     1.7KB     4.50
#>  8 fansi_vec_ansi   84.07µs   90.3µs    10873.    8.86KB    10.5 
#>  9 base_vec_ansi     5.12µs   5.38µs   181578.      848B     0   
#> 10 cli_vec_plain    17.98µs  19.27µs    50994.     1.7KB     5.10
#> 11 fansi_vec_plain  79.59µs  86.11µs    11406.    8.86KB    10.5 
#> 12 base_vec_plain    4.84µs   5.15µs   188669.      848B    18.9 
#> 13 cli_txt_ansi      5.01µs    5.9µs   163491.        0B    16.4 
#> 14 fansi_txt_ansi   55.51µs  61.19µs    16035.    1.98KB    14.8 
#> 15 base_txt_ansi      5.5µs    5.6µs   174322.        0B     0   
#> 16 cli_txt_plain     5.76µs   6.59µs   145775.        0B    14.6 
#> 17 fansi_txt_plain  55.56µs  61.86µs    15900.    1.98KB    14.6 
#> 18 base_txt_plain    3.42µs   3.51µs   274775.        0B    27.5
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
#>  1 cli_ansi        73.14µs  79.23µs   12282.     12.1KB    12.5 
#>  2 base_ansi           1µs   1.06µs  881372.         0B     0   
#>  3 cli_plain       56.48µs   60.4µs   16117.     8.91KB    12.5 
#>  4 base_plain     761.12ns 831.09ns 1148624.         0B     0   
#>  5 cli_vec_ansi     3.24ms   3.32ms     300.   838.95KB    17.8 
#>  6 base_vec_ansi   58.69µs  60.01µs   16505.       848B     0   
#>  7 cli_vec_plain     1.8ms   1.86ms     534.   817.08KB    19.7 
#>  8 base_vec_plain  36.02µs  36.68µs   27029.       848B     0   
#>  9 cli_txt_ansi    12.43ms  12.55ms      79.4   114.6KB     4.29
#> 10 base_txt_ansi   57.36µs  58.53µs   16914.         0B     0   
#> 11 cli_txt_plain  228.59µs 239.85µs    4106.    18.34KB     2.01
#> 12 base_txt_plain  33.45µs  33.65µs   29410.         0B     0
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
#>  1 cli_ansi         69.9µs   74.9µs    13074.        0B    18.9 
#>  2 base_ansi        11.9µs   13.2µs    73960.        0B    14.8 
#>  3 cli_plain        69.6µs   74.6µs    13123.        0B    18.9 
#>  4 base_plain       11.7µs   13.1µs    74347.        0B    14.9 
#>  5 cli_vec_ansi    151.6µs  161.8µs     6098.     7.2KB     8.24
#>  6 base_vec_ansi    44.9µs   51.2µs    19235.    1.66KB     4.06
#>  7 cli_vec_plain   141.4µs  150.9µs     6531.     7.2KB     8.25
#>  8 base_vec_plain   39.1µs     45µs    21853.    1.66KB     4.37
#>  9 cli_txt_ansi    134.5µs  140.6µs     7000.        0B    10.3 
#> 10 base_txt_ansi      32µs   33.6µs    29237.        0B     5.85
#> 11 cli_txt_plain   122.6µs  128.6µs     7645.        0B    10.3 
#> 12 base_txt_plain   27.1µs   28.6µs    34321.        0B     6.87
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
#> 1 cli          6.02µs   6.87µs   140102.        0B    14.0 
#> 2 base       661.01ns 751.11ns  1152054.        0B   115.  
#> 3 cli_vec     18.01µs  19.16µs    51342.      448B     5.13
#> 4 base_vec     9.42µs   9.73µs   100271.      448B     0   
#> 5 cli_txt     17.99µs  18.98µs    51743.        0B     5.17
#> 6 base_txt    10.19µs  10.38µs    94740.        0B     0
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
#> 1 cli          5.98µs   6.84µs   140305.        0B    28.1 
#> 2 base            1µs    1.1µs   856607.        0B     0   
#> 3 cli_vec     23.56µs  24.73µs    39839.      448B     3.98
#> 4 base_vec    41.54µs  42.12µs    23502.      448B     0   
#> 5 cli_txt     23.64µs     25µs    39417.        0B     3.94
#> 6 base_txt     73.7µs  74.61µs    12917.        0B     0
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
#> 1 cli          6.44µs   8.04µs    84819.        0B     8.48
#> 2 base        641.1ns 721.08ns  1223583.        0B     0   
#> 3 cli_vec     15.33µs  16.54µs    59323.      448B     5.93
#> 4 base_vec     9.38µs   9.71µs   101301.      448B     0   
#> 5 cli_txt     15.99µs  16.97µs    57721.        0B    11.5 
#> 6 base_txt    10.18µs  10.36µs    95005.        0B     0
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
#> 1 cli           4.8µs   5.59µs   171598.    22.2KB    17.2 
#> 2 base       801.17ns 892.09ns   949632.        0B    95.0 
#> 3 cli_vec     22.82µs  23.96µs    41105.     1.7KB     4.11
#> 4 base_vec     6.45µs   6.68µs   146975.      848B     0   
#> 5 cli_txt      4.77µs   5.56µs   172455.        0B    17.2 
#> 6 base_txt     4.08µs   4.31µs   226974.        0B     0
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
