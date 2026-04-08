# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x560884de0c58\>
\<environment: 0x560885933438\>

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
#> 1 ansi         38.5µs   42.2µs    23171.    99.3KB     23.2
#> 2 plain        38.6µs   42.3µs    23084.        0B     23.1
#> 3 base         10.7µs   12.1µs    80445.    48.4KB     24.1
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
#> 1 ansi           40µs   44.1µs    22029.        0B     26.5
#> 2 plain        40.2µs   44.1µs    22163.        0B     24.4
#> 3 base         12.5µs   14.1µs    68963.        0B     20.7
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
#> 1 ansi        92.67µs 100.88µs     9640.   75.07KB     16.9
#> 2 plain       71.74µs   78.2µs    12427.    8.73KB     16.9
#> 3 base         1.83µs   2.03µs   468870.        0B     46.9
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
#> 1 ansi          277µs    301µs     3298.   33.17KB     21.5
#> 2 plain         278µs    301µs     3297.    1.09KB     23.8
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
#>  1 cli_ansi           5.6µs   6.35µs   151782.     9.2KB     30.4
#>  2 fansi_ansi       26.11µs   29.7µs    32827.    4.18KB     29.6
#>  3 cli_plain         5.51µs   6.02µs   161747.        0B     16.2
#>  4 fansi_plain      26.19µs  28.23µs    34497.      688B     27.6
#>  5 cli_vec_ansi      6.92µs   7.49µs   130173.      448B     26.0
#>  6 fansi_vec_ansi   36.27µs  38.57µs    25325.    5.02KB     20.3
#>  7 cli_vec_plain     7.75µs   8.42µs   115281.      448B     23.1
#>  8 fansi_vec_plain  35.19µs  37.62µs    25988.    5.02KB     20.8
#>  9 cli_txt_ansi      5.51µs    6.1µs   157120.        0B     31.4
#> 10 fansi_txt_ansi   26.64µs  28.64µs    33960.      688B     27.2
#> 11 cli_txt_plain     6.48µs   7.03µs   138323.        0B     27.7
#> 12 fansi_txt_plain   35.3µs  37.67µs    25923.    5.02KB     20.8
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
#> 1 cli          56.2µs   58.1µs    16888.    22.7KB     8.18
#> 2 fansi       112.7µs  116.2µs     8468.    55.3KB    10.3
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
#>  1 cli_ansi          6.39µs   7.07µs   136030.        0B    27.2 
#>  2 fansi_ansi       73.23µs  78.17µs    12414.   38.83KB    19.1 
#>  3 base_ansi       851.11ns  941.1ns   957274.        0B    95.7 
#>  4 cli_plain         6.44µs   7.11µs   134470.        0B    13.4 
#>  5 fansi_plain      72.72µs  77.81µs    12485.      688B    21.4 
#>  6 base_plain      791.04ns 871.14ns  1036071.        0B     0   
#>  7 cli_vec_ansi     27.73µs     29µs    33352.      448B     6.67
#>  8 fansi_vec_ansi   93.95µs  99.26µs     9785.    5.02KB    17.0 
#>  9 base_vec_ansi    14.62µs  14.81µs    66402.      448B     0   
#> 10 cli_vec_plain    26.39µs  27.39µs    35821.      448B     7.17
#> 11 fansi_vec_plain  84.08µs  89.98µs    10768.    5.02KB    17.1 
#> 12 base_vec_plain    8.67µs   8.82µs   110327.      448B     0   
#> 13 cli_txt_ansi     29.29µs   30.3µs    30579.        0B     6.12
#> 14 fansi_txt_ansi   85.62µs  92.07µs     9607.      688B    16.9 
#> 15 base_txt_ansi    14.44µs  14.56µs    65059.        0B     0   
#> 16 cli_txt_plain     25.8µs   26.6µs    36903.        0B     7.38
#> 17 fansi_txt_plain  75.72µs  80.87µs    11981.      688B    19.8 
#> 18 base_txt_plain    8.51µs    8.6µs   113591.        0B     0
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
#>  1 cli_ansi          7.87µs   8.54µs   113800.        0B    34.2 
#>  2 fansi_ansi       72.66µs  76.71µs    12641.      688B    19.1 
#>  3 base_ansi         1.19µs   1.29µs   716441.        0B    71.7 
#>  4 cli_plain         7.83µs   8.51µs   114415.        0B    22.9 
#>  5 fansi_plain      72.83µs  77.35µs    12358.      688B    19.2 
#>  6 base_plain      990.93ns   1.08µs   851252.        0B    85.1 
#>  7 cli_vec_ansi     33.74µs  34.77µs    28213.      448B     5.64
#>  8 fansi_vec_ansi   96.53µs 102.73µs     9462.    5.02KB    14.8 
#>  9 base_vec_ansi    41.51µs  41.95µs    23493.      448B     2.35
#> 10 cli_vec_plain    32.52µs  33.61µs    29220.      448B     5.85
#> 11 fansi_vec_plain  86.81µs  92.33µs    10438.    5.02KB    17.1 
#> 12 base_vec_plain   21.86µs  22.16µs    44406.      448B     0   
#> 13 cli_txt_ansi     34.46µs  35.42µs    27754.        0B     8.33
#> 14 fansi_txt_ansi      89µs  94.28µs    10331.      688B    16.9 
#> 15 base_txt_ansi    43.45µs  43.72µs    22559.        0B     0   
#> 16 cli_txt_plain    31.98µs  32.93µs    29600.        0B     5.92
#> 17 fansi_txt_plain  77.98µs  83.74µs    11592.      688B    19.2 
#> 18 base_txt_plain   23.16µs  23.33µs    42144.        0B     0
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
#> 1 cli_ansi        6.44µs   7.07µs   136764.        0B    27.4 
#> 2 cli_plain          6µs   6.57µs   147754.        0B    14.8 
#> 3 cli_vec_ansi   30.72µs     32µs    30702.      848B     6.14
#> 4 cli_vec_plain  10.13µs  10.87µs    89774.      848B     8.98
#> 5 cli_txt_ansi   30.74µs  31.62µs    31145.        0B     6.23
#> 6 cli_txt_plain   7.01µs    7.6µs   127535.        0B    25.5
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
#>  1 cli_ansi          24.2µs   26.1µs    37156.        0B     29.7
#>  2 fansi_ansi          25µs     27µs    35858.    7.24KB     28.7
#>  3 cli_plain         23.9µs   25.9µs    37590.        0B     30.1
#>  4 fansi_plain       24.6µs   26.6µs    36294.      688B     29.1
#>  5 cli_vec_ansi      33.5µs     36µs    27075.      848B     21.7
#>  6 fansi_vec_ansi    51.9µs   54.4µs    17940.    5.41KB     12.7
#>  7 cli_vec_plain       27µs   28.8µs    33737.      848B     27.0
#>  8 fansi_vec_plain   34.8µs   36.9µs    26498.    4.59KB     21.2
#>  9 cli_txt_ansi      33.2µs     35µs    27892.        0B     22.3
#> 10 fansi_txt_ansi    41.4µs   43.6µs    22442.    5.12KB     18.0
#> 11 cli_txt_plain       25µs   26.8µs    36493.        0B     29.2
#> 12 fansi_txt_plain   25.9µs   27.8µs    35029.      688B     24.5
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
#>  1 cli_ansi        133.49µs 141.74µs     6859.  104.34KB    23.7 
#>  2 fansi_ansi      106.43µs 113.73µs     8591.  106.35KB    24.0 
#>  3 base_ansi         4.01µs   4.38µs   222428.      224B     0   
#>  4 cli_plain        131.9µs 139.89µs     6948.    8.09KB    23.7 
#>  5 fansi_plain     105.42µs 112.26µs     8700.    9.62KB    23.9 
#>  6 base_plain        3.48µs   3.92µs   246895.        0B    24.7 
#>  7 cli_vec_ansi      6.66ms   6.82ms      146.  823.77KB    31.3 
#>  8 fansi_vec_ansi    1.04ms   1.08ms      884.  846.81KB    17.7 
#>  9 base_vec_ansi   151.88µs 157.67µs     6163.    22.7KB     2.05
#> 10 cli_vec_plain     6.64ms   6.77ms      146.  823.77KB    31.9 
#> 11 fansi_vec_plain 982.04µs   1.01ms      978.  845.98KB    19.0 
#> 12 base_vec_plain  102.58µs 107.49µs     9169.      848B     4.07
#> 13 cli_txt_ansi      3.31ms   3.38ms      295.    63.6KB     0   
#> 14 fansi_txt_ansi    1.59ms   1.62ms      614.   35.05KB     2.02
#> 15 base_txt_ansi   138.98µs 150.37µs     6620.   18.47KB     2.03
#> 16 cli_txt_plain     2.44ms   2.48ms      402.    63.6KB     0   
#> 17 fansi_txt_plain 521.86µs 559.78µs     1787.    30.6KB     6.19
#> 18 base_txt_plain   91.03µs  93.77µs    10373.   11.05KB     2.02
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
#>  1 cli_ansi        126.04µs 133.01µs     7369.   33.84KB     28.8
#>  2 fansi_ansi       47.82µs  51.67µs    18891.   31.42KB     23.6
#>  3 base_ansi         1.06µs   1.14µs   821254.     4.2KB     82.1
#>  4 cli_plain        125.8µs 132.06µs     7427.        0B     25.8
#>  5 fansi_plain      47.96µs   51.5µs    18963.      872B     26.0
#>  6 base_plain      991.04ns   1.06µs   843496.        0B     84.4
#>  7 cli_vec_ansi    249.41µs 259.13µs     3803.   16.73KB     12.6
#>  8 fansi_vec_ansi  114.12µs  118.8µs     8266.    5.59KB     12.6
#>  9 base_vec_ansi    36.41µs  36.67µs    26915.      848B      0  
#> 10 cli_vec_plain   212.44µs 221.93µs     4423.   16.73KB     17.2
#> 11 fansi_vec_plain 104.85µs  109.5µs     8880.    5.59KB     14.9
#> 12 base_vec_plain   30.29µs  30.63µs    32214.      848B      0  
#> 13 cli_txt_ansi     136.2µs 142.88µs     6853.        0B     25.9
#> 14 fansi_txt_ansi   48.17µs  51.83µs    18806.      872B     23.8
#> 15 base_txt_ansi     1.09µs   1.17µs   787050.        0B     78.7
#> 16 cli_txt_plain   126.83µs 134.12µs     7322.        0B     27.3
#> 17 fansi_txt_plain  47.27µs  49.94µs    19563.      872B     26.0
#> 18 base_txt_plain    1.01µs   1.09µs   876151.        0B      0
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
#>  1 cli_ansi        332.25µs 357.02µs    2748.         0B    23.9 
#>  2 fansi_ansi       87.03µs  93.16µs   10365.    97.32KB    23.6 
#>  3 base_ansi        32.53µs  34.66µs   27641.         0B    24.9 
#>  4 cli_plain       219.82µs 235.41µs    4115.         0B    23.6 
#>  5 fansi_plain      86.27µs  93.09µs   10356.       872B    23.7 
#>  6 base_plain       26.45µs   28.3µs   33936.         0B    23.8 
#>  7 cli_vec_ansi     35.97ms   36.1ms      27.7    2.48KB   152.  
#>  8 fansi_vec_ansi  235.51µs 250.32µs    3573.     7.25KB    10.4 
#>  9 base_vec_ansi     2.23ms    2.3ms     417.    48.18KB    25.2 
#> 10 cli_vec_plain    23.23ms  23.44ms      42.4    2.48KB    51.8 
#> 11 fansi_vec_plain 188.33µs  197.1µs    4934.     6.42KB    14.7 
#> 12 base_vec_plain    1.57ms   1.65ms     605.     47.4KB    15.8 
#> 13 cli_txt_ansi     23.52ms  23.79ms      42.0  507.59KB     7.00
#> 14 fansi_txt_ansi  231.28µs 239.99µs    4110.     6.77KB     6.15
#> 15 base_txt_ansi     1.27ms   1.31ms     745.   582.06KB     8.86
#> 16 cli_txt_plain     1.25ms   1.29ms     764.   369.84KB    11.1 
#> 17 fansi_txt_plain 179.75µs 187.68µs    5256.     2.51KB     6.14
#> 18 base_txt_plain  869.74µs 907.42µs    1087.   367.31KB     8.85
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
#>  1 cli_ansi          6.59µs   7.38µs   130848.   24.83KB    13.1 
#>  2 fansi_ansi       69.42µs  75.15µs    13061.   28.48KB    12.6 
#>  3 base_ansi        970.9ns   1.08µs   835359.        0B     0   
#>  4 cli_plain         6.56µs   7.35µs   130762.        0B    26.2 
#>  5 fansi_plain      69.29µs     75µs    13087.    1.98KB    12.6 
#>  6 base_plain      951.11ns   1.05µs   879569.        0B     0   
#>  7 cli_vec_ansi     26.21µs  27.53µs    35690.     1.7KB     3.57
#>  8 fansi_vec_ansi  105.72µs 111.82µs     8736.    8.86KB     8.40
#>  9 base_vec_ansi     6.18µs   6.58µs   150783.      848B     0   
#> 10 cli_vec_plain    23.27µs  24.58µs    39779.     1.7KB     7.96
#> 11 fansi_vec_plain 100.67µs 106.36µs     9181.    8.86KB     8.40
#> 12 base_vec_plain    5.63µs   5.91µs   165114.      848B     0   
#> 13 cli_txt_ansi      6.53µs   7.37µs   131151.        0B    13.1 
#> 14 fansi_txt_ansi   69.81µs  74.98µs    12996.    1.98KB    12.6 
#> 15 base_txt_ansi     5.56µs   5.68µs   170752.        0B     0   
#> 16 cli_txt_plain     7.43µs   8.22µs   117687.        0B    23.5 
#> 17 fansi_txt_plain  68.46µs  74.92µs    13047.    1.98KB    12.7 
#> 18 base_txt_plain    3.56µs   3.68µs   263122.        0B     0
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
#>  1 cli_ansi        87.07µs  93.29µs   10475.    11.88KB    10.4 
#>  2 base_ansi        1.26µs   1.33µs  720726.         0B     0   
#>  3 cli_plain        68.7µs  73.16µs   13309.     8.73KB    10.3 
#>  4 base_plain     962.06ns   1.03µs  930356.         0B     0   
#>  5 cli_vec_ansi        4ms   4.17ms     241.   838.77KB    15.4 
#>  6 base_vec_ansi   71.45µs  72.87µs   13611.       848B     0   
#>  7 cli_vec_plain    2.25ms   2.33ms     428.    816.9KB    15.3 
#>  8 base_vec_plain  42.45µs   43.3µs   22814.       848B     0   
#>  9 cli_txt_ansi    13.77ms  13.84ms      72.1  114.42KB     2.06
#> 10 base_txt_ansi   71.55µs   72.2µs   13683.         0B     0   
#> 11 cli_txt_plain  243.89µs 253.17µs    3880.    18.16KB     4.06
#> 12 base_txt_plain  40.68µs  40.97µs   24111.         0B     0
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
#>  1 cli_ansi         88.9µs   94.5µs    10325.        0B    14.6 
#>  2 base_ansi        14.9µs   16.3µs    59353.        0B    17.8 
#>  3 cli_plain        88.8µs   94.6µs    10355.        0B    14.8 
#>  4 base_plain       14.9µs   16.3µs    59964.        0B    12.0 
#>  5 cli_vec_ansi    175.6µs    187µs     5292.     7.2KB     6.15
#>  6 base_vec_ansi    51.6µs   54.9µs    17707.    1.66KB     4.06
#>  7 cli_vec_plain     161µs  172.7µs     5720.     7.2KB     8.26
#>  8 base_vec_plain   46.2µs   49.9µs    19551.    1.66KB     4.07
#>  9 cli_txt_ansi    154.6µs  161.5µs     6107.        0B    10.1 
#> 10 base_txt_ansi    38.1µs   39.3µs    25052.        0B     5.01
#> 11 cli_txt_plain   138.2µs  142.7µs     6882.        0B    10.3 
#> 12 base_txt_plain   32.8µs   34.1µs    28909.        0B     5.78
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
#> 1 cli          7.69µs    8.3µs   117729.        0B    11.8 
#> 2 base       832.14ns    932ns  1003775.        0B     0   
#> 3 cli_vec     23.21µs     24µs    40931.      448B     4.09
#> 4 base_vec     12.2µs   12.4µs    79071.      448B     7.91
#> 5 cli_txt     23.23µs   23.9µs    41239.        0B     4.12
#> 6 base_txt    12.94µs   13.1µs    75164.        0B     0
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
#> 1 cli          7.55µs   8.27µs   118408.        0B    11.8 
#> 2 base         1.29µs   1.42µs   664250.        0B     0   
#> 3 cli_vec     29.25µs  30.32µs    32515.      448B     6.50
#> 4 base_vec    54.23µs  54.98µs    17971.      448B     0   
#> 5 cli_txt     29.67µs  30.74µs    31831.        0B     3.18
#> 6 base_txt    89.88µs  90.93µs    10182.        0B     0
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
#> 1 cli          8.28µs   9.11µs    94204.        0B    18.8 
#> 2 base       831.09ns   1.02µs   730458.        0B     0   
#> 3 cli_vec     19.59µs  21.63µs    39946.      448B     4.00
#> 4 base_vec    12.21µs  12.81µs    75610.      448B     0   
#> 5 cli_txt     20.35µs  21.46µs    43786.        0B     8.76
#> 6 base_txt    12.95µs  13.11µs    75022.        0B     0
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
#> 1 cli          6.23µs   7.01µs   137974.    22.1KB    13.8 
#> 2 base       992.09ns   1.08µs   826588.        0B     0   
#> 3 cli_vec     31.12µs  32.29µs    30493.     1.7KB     6.10
#> 4 base_vec      8.7µs   8.93µs   109867.      848B     0   
#> 5 cli_txt       6.2µs   6.99µs   138391.        0B    13.8 
#> 6 base_txt     5.05µs    5.2µs   186473.        0B     0
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
