# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x560680512c70\>
\<environment: 0x560680fb1fe8\>

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
#> 1 ansi         47.1µs   50.4µs    19148.    99.6KB     21.1
#> 2 plain        46.2µs   49.5µs    19527.        0B     22.0
#> 3 base         11.4µs   12.6µs    76714.    48.6KB     15.3
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
#> 1 ansi         48.5µs     52µs    18278.        0B     21.4
#> 2 plain        48.1µs     52µs    17727.        0B     21.3
#> 3 base         13.3µs   14.6µs    66155.        0B     26.5
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
#> 1 ansi       119.56µs 128.13µs     7535.   77.03KB     14.7
#> 2 plain       96.17µs 102.77µs     9302.    8.91KB     14.6
#> 3 base         1.88µs   2.01µs   475088.        0B      0
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
#> 1 ansi          352µs    375µs     2620.   33.24KB     19.2
#> 2 plain         350µs    374µs     2617.    1.09KB     19.2
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
#>  1 cli_ansi          5.86µs    6.5µs   147774.    9.27KB    29.6 
#>  2 fansi_ansi       31.26µs  34.85µs    27538.    4.18KB    24.8 
#>  3 cli_plain         5.89µs   6.51µs   147524.        0B    29.5 
#>  4 fansi_plain      30.28µs  33.44µs    28249.      688B    17.0 
#>  5 cli_vec_ansi      7.21µs   7.75µs   123215.      448B    12.3 
#>  6 fansi_vec_ansi      41µs  43.62µs    21902.    5.02KB     8.76
#>  7 cli_vec_plain     7.92µs   8.45µs   114431.      448B    11.4 
#>  8 fansi_vec_plain  38.84µs  41.24µs    23481.    5.02KB     9.40
#>  9 cli_txt_ansi      5.75µs   6.24µs   153562.        0B    15.4 
#> 10 fansi_txt_ansi   30.87µs  33.17µs    28528.      688B    14.3 
#> 11 cli_txt_plain     6.66µs   7.08µs   136872.        0B     0   
#> 12 fansi_txt_plain  38.75µs  41.69µs    23153.    5.02KB    11.6
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
#> 1 cli          60.2µs   62.2µs    15668.    22.7KB     4.06
#> 2 fansi       120.1µs    128µs     7672.    55.3KB     4.05
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
#>  1 cli_ansi             7µs   7.65µs   126422.        0B    12.6 
#>  2 fansi_ansi       93.67µs  98.95µs     9729.   38.84KB     8.21
#>  3 base_ansi        902.1ns 952.04ns   985635.        0B     0   
#>  4 cli_plain         6.91µs   7.58µs   127856.        0B    12.8 
#>  5 fansi_plain      93.17µs  98.98µs     9654.      688B     8.21
#>  6 base_plain      821.08ns 862.05ns  1058012.        0B     0   
#>  7 cli_vec_ansi     28.22µs  29.09µs    33594.      448B     3.36
#>  8 fansi_vec_ansi  113.93µs 120.55µs     7985.    5.02KB     6.16
#>  9 base_vec_ansi    18.43µs  18.56µs    52501.      448B     5.25
#> 10 cli_vec_plain    26.65µs  27.49µs    35353.      448B     3.54
#> 11 fansi_vec_plain 105.19µs 110.83µs     8674.    5.02KB     6.15
#> 12 base_vec_plain   10.77µs  10.87µs    90121.      448B     0   
#> 13 cli_txt_ansi        28µs  28.82µs    33915.        0B     3.39
#> 14 fansi_txt_ansi  106.11µs 111.81µs     8413.      688B     8.21
#> 15 base_txt_ansi    18.21µs  18.27µs    53786.        0B     0   
#> 16 cli_txt_plain    26.28µs  27.05µs    36202.        0B     3.62
#> 17 fansi_txt_plain  95.16µs 100.53µs     9547.      688B     8.19
#> 18 base_txt_plain   10.59µs  11.12µs    88302.        0B     0
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
#>  1 cli_ansi          8.55µs   9.32µs   103385.        0B    20.7 
#>  2 fansi_ansi       93.06µs  99.52µs     9653.      688B     8.36
#>  3 base_ansi         1.23µs   1.28µs   730950.        0B     0   
#>  4 cli_plain         8.51µs   9.24µs   104758.        0B    10.5 
#>  5 fansi_plain      93.22µs  98.61µs     9729.      688B     8.21
#>  6 base_plain        1.01µs   1.06µs   862830.        0B     0   
#>  7 cli_vec_ansi      34.3µs  35.39µs    27336.      448B     5.47
#>  8 fansi_vec_ansi  116.55µs 122.69µs     7862.    5.02KB     6.15
#>  9 base_vec_ansi    43.99µs   44.8µs    21834.      448B     0   
#> 10 cli_vec_plain    33.29µs  34.21µs    28568.      448B     2.86
#> 11 fansi_vec_plain 106.85µs 112.08µs     8595.    5.02KB     8.26
#> 12 base_vec_plain   22.94µs  23.24µs    42444.      448B     0   
#> 13 cli_txt_ansi     34.81µs  35.66µs    27454.        0B     2.75
#> 14 fansi_txt_ansi  107.73µs 112.81µs     8571.      688B     8.19
#> 15 base_txt_ansi    46.56µs  47.69µs    20722.        0B     0   
#> 16 cli_txt_plain    32.97µs   33.8µs    28916.        0B     2.89
#> 17 fansi_txt_plain  97.92µs  102.6µs     9445.      688B     8.19
#> 18 base_txt_plain   24.32µs  25.36µs    38846.        0B     3.88
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
#> 1 cli_ansi        6.96µs   7.55µs   128213.        0B    12.8 
#> 2 cli_plain       6.46µs   7.02µs   138066.        0B     0   
#> 3 cli_vec_ansi   32.68µs  33.65µs    29121.      848B     0   
#> 4 cli_vec_plain  10.59µs  11.28µs    86246.      848B     8.63
#> 5 cli_txt_ansi   32.57µs  33.46µs    29215.        0B     2.92
#> 6 cli_txt_plain   7.22µs   7.91µs   122349.        0B    12.2
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
#>  1 cli_ansi          26.4µs     28µs    34578.        0B    17.3 
#>  2 fansi_ansi        28.9µs   30.9µs    31311.    7.24KB    12.5 
#>  3 cli_plain         25.8µs   27.8µs    34804.        0B    13.9 
#>  4 fansi_plain       28.1µs   30.3µs    31922.      688B    12.8 
#>  5 cli_vec_ansi      35.7µs   37.5µs    25874.      848B    10.4 
#>  6 fansi_vec_ansi    56.2µs   59.8µs    16272.    5.41KB     8.31
#>  7 cli_vec_plain     28.8µs   30.5µs    31703.      848B    12.7 
#>  8 fansi_vec_plain   37.1µs   39.8µs    24239.    4.59KB     9.86
#>  9 cli_txt_ansi      34.7µs   36.2µs    26853.        0B    10.7 
#> 10 fansi_txt_ansi    44.4µs     46µs    21097.    5.12KB     8.44
#> 11 cli_txt_plain     26.7µs   28.1µs    34375.        0B    13.8 
#> 12 fansi_txt_plain   29.3µs     31µs    31026.      688B    12.4
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
#>  1 cli_ansi        167.79µs 177.37µs     5447.  104.86KB     8.33
#>  2 fansi_ansi      131.85µs 140.86µs     6851.  106.35KB    10.4 
#>  3 base_ansi         4.08µs    4.5µs   215705.      224B     0   
#>  4 cli_plain       165.66µs 174.04µs     5526.    8.09KB    10.4 
#>  5 fansi_plain     128.59µs 137.54µs     6691.    9.62KB    10.4 
#>  6 base_plain        3.73µs      4µs   242485.        0B     0   
#>  7 cli_vec_ansi      7.79ms   7.97ms      124.  823.77KB    11.3 
#>  8 fansi_vec_ansi    1.07ms    1.1ms      886.  846.81KB    17.4 
#>  9 base_vec_ansi    156.5µs 161.43µs     6066.    22.7KB     2.03
#> 10 cli_vec_plain     7.64ms    7.8ms      127.  823.77KB    13.9 
#> 11 fansi_vec_plain   1.01ms   1.04ms      953.  845.98KB    17.7 
#> 12 base_vec_plain  106.77µs 113.19µs     8748.      848B     2.02
#> 13 cli_txt_ansi      3.19ms   3.35ms      299.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.55ms   1.57ms      634.   35.05KB     0   
#> 15 base_txt_ansi   135.48µs 139.98µs     6982.   18.47KB     2.02
#> 16 cli_txt_plain      2.4ms   2.54ms      394.    63.6KB     2.02
#> 17 fansi_txt_plain 518.36µs 555.75µs     1805.    30.6KB     2.02
#> 18 base_txt_plain   88.17µs   91.2µs    10693.   11.05KB     2.02
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
#>  1 cli_ansi         151.5µs  159.3µs     6060.   33.84KB    12.5 
#>  2 fansi_ansi       55.35µs  59.28µs    16319.   31.42KB    10.3 
#>  3 base_ansi         1.06µs   1.11µs   832811.     4.2KB     0   
#>  4 cli_plain       149.76µs 156.25µs     6105.        0B    12.4 
#>  5 fansi_plain      55.46µs  59.53µs    16223.      872B    12.5 
#>  6 base_plain      991.04ns   1.03µs   920020.        0B     0   
#>  7 cli_vec_ansi    277.42µs 288.87µs     3384.   16.73KB     6.17
#>  8 fansi_vec_ansi  116.19µs 120.83µs     8042.    5.59KB     6.16
#>  9 base_vec_ansi    35.75µs  36.76µs    26897.      848B     0   
#> 10 cli_vec_plain   235.46µs 246.51µs     3956.   16.73KB     8.47
#> 11 fansi_vec_plain 109.24µs 114.03µs     8450.    5.59KB     6.16
#> 12 base_vec_plain   30.09µs   30.9µs    32061.      848B     0   
#> 13 cli_txt_ansi    159.79µs 167.32µs     5776.        0B    12.5 
#> 14 fansi_txt_ansi   55.09µs  59.11µs    16346.      872B    12.5 
#> 15 base_txt_ansi      1.1µs   1.16µs   831814.        0B     0   
#> 16 cli_txt_plain   149.86µs 157.83µs     6132.        0B    12.2 
#> 17 fansi_txt_plain  54.06µs  56.83µs    17044.      872B    10.3 
#> 18 base_txt_plain    1.01µs   1.06µs   895004.        0B    89.5
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
#>  1 cli_ansi         423.7µs  452.2µs    2202.     6.18KB    10.3 
#>  2 fansi_ansi       99.11µs 104.36µs    9287.    97.33KB    10.3 
#>  3 base_ansi        38.39µs  40.92µs   22902.         0B    11.5 
#>  4 cli_plain       279.91µs 292.49µs    3326.         0B    10.3 
#>  5 fansi_plain      98.36µs 104.58µs    9249.       872B    10.3 
#>  6 base_plain       31.39µs  33.36µs   28783.         0B    11.5 
#>  7 cli_vec_ansi     45.03ms   45.5ms      22.0   94.67KB    18.3 
#>  8 fansi_vec_ansi  238.07µs 249.14µs    3892.     7.25KB     6.14
#>  9 base_vec_ansi     2.28ms   2.35ms     423.    48.18KB    12.8 
#> 10 cli_vec_plain     29.3ms  29.66ms      33.7    2.48KB    14.0 
#> 11 fansi_vec_plain 192.45µs 201.11µs    4855.     6.42KB     6.13
#> 12 base_vec_plain    1.64ms    1.7ms     585.     47.4KB    13.0 
#> 13 cli_txt_ansi     27.45ms  28.05ms      35.6    4.27MB     7.11
#> 14 fansi_txt_ansi  228.92µs 238.04µs    4111.     6.77KB     4.06
#> 15 base_txt_ansi     1.29ms   1.34ms     740.   582.06KB    11.3 
#> 16 cli_txt_plain     1.32ms   1.37ms     723.   369.84KB     8.71
#> 17 fansi_txt_plain 180.06µs 189.28µs    5139.     2.51KB     6.14
#> 18 base_txt_plain  880.59µs 924.02µs    1055.   367.31KB     8.76
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
#>  1 cli_ansi          6.75µs   7.54µs   125255.   25.09KB    25.1 
#>  2 fansi_ansi       81.17µs  86.76µs    11063.   28.48KB    10.4 
#>  3 base_ansi         1.05µs    1.1µs   836748.        0B     0   
#>  4 cli_plain         6.65µs   7.45µs   129148.        0B    12.9 
#>  5 fansi_plain      80.45µs  86.24µs    11168.    1.98KB    10.4 
#>  6 base_plain        1.01µs   1.07µs   857373.        0B     0   
#>  7 cli_vec_ansi      26.5µs  27.97µs    33844.     1.7KB     6.77
#>  8 fansi_vec_ansi  118.06µs  124.8µs     7726.    8.86KB     6.29
#>  9 base_vec_ansi     6.31µs   6.59µs   146409.      848B     0   
#> 10 cli_vec_plain    22.99µs  24.23µs    40075.     1.7KB     4.01
#> 11 fansi_vec_plain  112.1µs 119.78µs     8046.    8.86KB     8.38
#> 12 base_vec_plain    6.05µs   6.38µs   152473.      848B     0   
#> 13 cli_txt_ansi      6.78µs   7.63µs   123595.        0B    12.4 
#> 14 fansi_txt_ansi   80.62µs  86.46µs    11096.    1.98KB    12.5 
#> 15 base_txt_ansi     6.49µs   6.56µs   148397.        0B     0   
#> 16 cli_txt_plain     7.49µs   8.34µs   115730.        0B    11.6 
#> 17 fansi_txt_plain   79.8µs  85.98µs    11027.    1.98KB    10.4 
#> 18 base_txt_plain    4.12µs   4.18µs   230742.        0B     0
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
#>  1 cli_ansi       111.95µs  118.3µs    8173.     12.1KB     7.25
#>  2 base_ansi        1.33µs   1.37µs  704290.         0B     0   
#>  3 cli_plain       91.45µs   95.3µs   10005.     8.91KB     8.22
#>  4 base_plain       1.04µs   1.07µs  904183.         0B     0   
#>  5 cli_vec_ansi     4.18ms    4.3ms     231.   838.95KB    13.1 
#>  6 base_vec_ansi   75.67µs   76.2µs   12917.       848B     0   
#>  7 cli_vec_plain    2.34ms    2.4ms     414.   817.08KB    15.1 
#>  8 base_vec_plain  45.04µs  46.06µs   20295.       848B     0   
#>  9 cli_txt_ansi    14.93ms  15.05ms      66.4   114.6KB     2.08
#> 10 base_txt_ansi   76.28µs  76.49µs   12896.         0B     2.01
#> 11 cli_txt_plain  296.69µs 307.54µs    3174.    18.34KB     2.04
#> 12 base_txt_plain  42.62µs  43.23µs   22812.         0B     0
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
#>  1 cli_ansi        111.3µs  116.2µs     8261.        0B    12.4 
#>  2 base_ansi        16.8µs   17.9µs    53949.        0B    10.8 
#>  3 cli_plain       109.7µs  114.8µs     8338.        0B    10.3 
#>  4 base_plain       16.8µs   17.9µs    53974.        0B    10.8 
#>  5 cli_vec_ansi    211.6µs  221.5µs     4378.     7.2KB     6.13
#>  6 base_vec_ansi    59.8µs     66µs    14914.    1.66KB     4.06
#>  7 cli_vec_plain   198.7µs  207.5µs     4702.     7.2KB     6.14
#>  8 base_vec_plain   52.5µs   60.1µs    16481.    1.66KB     4.06
#>  9 cli_txt_ansi    188.5µs  194.5µs     4995.        0B     6.10
#> 10 base_txt_ansi    41.1µs   42.6µs    22758.        0B     4.55
#> 11 cli_txt_plain   170.4µs  177.1µs     5412.        0B     8.18
#> 12 base_txt_plain   35.5µs   36.8µs    26479.        0B     5.30
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
#> 1 cli           8.3µs   9.05µs   106791.        0B    10.7 
#> 2 base          871ns 921.08ns  1001327.        0B     0   
#> 3 cli_vec      23.4µs  24.29µs    40014.      448B     4.00
#> 4 base_vec     11.5µs  11.73µs    83333.      448B     8.33
#> 5 cli_txt      23.5µs  24.39µs    39874.        0B     3.99
#> 6 base_txt     12.5µs   12.6µs    77610.        0B     0
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
#> 1 cli          8.19µs   8.99µs   107125.        0B    10.7 
#> 2 base         1.31µs   1.36µs   690474.        0B     0   
#> 3 cli_vec     28.68µs  29.94µs    32579.      448B     6.52
#> 4 base_vec    50.53µs  51.21µs    19243.      448B     0   
#> 5 cli_txt      29.2µs  30.07µs    32431.        0B     3.24
#> 6 base_txt    87.39µs  88.19µs    11197.        0B     0
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
#> 1 cli          8.82µs   9.57µs   101256.        0B    10.1 
#> 2 base       871.02ns 922.13ns   955124.        0B    95.5 
#> 3 cli_vec     19.66µs  20.59µs    47380.      448B     4.74
#> 4 base_vec    11.48µs  11.74µs    83603.      448B     0   
#> 5 cli_txt     20.44µs  21.34µs    45618.        0B     4.56
#> 6 base_txt    12.53µs  12.62µs    77556.        0B     7.76
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
#> 1 cli          6.42µs   7.07µs   136379.    22.2KB    13.6 
#> 2 base         1.07µs   1.13µs   812555.        0B     0   
#> 3 cli_vec     28.91µs  29.95µs    32017.     1.7KB     3.20
#> 4 base_vec     8.11µs   8.41µs   116710.      848B     0   
#> 5 cli_txt      6.47µs    7.1µs   134510.        0B    26.9 
#> 6 base_txt     5.49µs   5.56µs   175819.        0B     0
```

## Session info

``` r

sessioninfo::session_info()
```

``` fansi
#> ─ Session info ──────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.1 (2026-06-24)
#>  os       Ubuntu 24.04.4 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en
#>  collate  C.UTF-8
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-08-23
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-08-23 [1] local
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
#>  knitr         1.51       2025-12-20 [1] RSPM
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
#>  rmarkdown     2.31       2026-03-26 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  xfun          0.60       2026-07-09 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.1/lib/R/site-library
#>  [3] /opt/R/4.6.1/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ─────────────────────────────────────────────────────────────────────
```
