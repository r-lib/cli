# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x60b45be2d5e0\>
\<environment: 0x60b45c8bfcd0\>

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
#> 1 ansi           20µs   21.9µs    44866.    99.6KB     49.4
#> 2 plain       20.32µs   22.5µs    43712.        0B     48.1
#> 3 base         5.99µs    6.8µs   143796.    48.6KB     43.2
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
#> 1 ansi         20.7µs  23.57µs    41430.        0B     49.8
#> 2 plain        20.6µs  22.98µs    42790.        0B     51.4
#> 3 base         6.63µs   7.51µs   129825.        0B     52.0
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
#> 1 ansi         48.8µs   53.8µs    17585.   77.03KB     36.0
#> 2 plain          38µs   42.8µs    21681.    8.91KB     32.6
#> 3 base        929.9ns    981ns   957534.        0B      0
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
#> 1 ansi          143µs    155µs     6320.   33.23KB     34.6
#> 2 plain         144µs    154µs     6424.    1.09KB     23.0
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
#>  1 cli_ansi          3.11µs   3.56µs   273838.    9.27KB     27.4
#>  2 fansi_ansi        15.3µs  16.86µs    57694.    4.18KB     28.9
#>  3 cli_plain         3.12µs    3.8µs   261804.        0B     26.2
#>  4 fansi_plain      15.31µs  17.02µs    57367.      688B     23.0
#>  5 cli_vec_ansi      3.91µs   4.38µs   223090.      448B     22.3
#>  6 fansi_vec_ansi   20.22µs  22.44µs    43621.    5.02KB     17.5
#>  7 cli_vec_plain     4.15µs   4.63µs   211078.      448B     21.1
#>  8 fansi_vec_plain  19.72µs   21.5µs    45643.    5.02KB     18.3
#>  9 cli_txt_ansi       3.1µs   3.52µs   277710.        0B     27.8
#> 10 fansi_txt_ansi    15.2µs   16.8µs    58221.      688B     29.1
#> 11 cli_txt_plain     3.73µs   4.15µs   236085.        0B     23.6
#> 12 fansi_txt_plain  19.62µs  21.73µs    45032.    5.02KB     18.0
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
#> 1 cli          30.2µs     32µs    30878.    22.7KB     9.27
#> 2 fansi        60.8µs   64.1µs    15393.    55.3KB     8.16
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
#>  1 cli_ansi          3.57µs   4.18µs   233726.        0B     0   
#>  2 fansi_ansi       37.68µs  41.49µs    23709.   38.84KB    21.4 
#>  3 base_ansi       530.04ns  580.1ns  1615032.        0B     0   
#>  4 cli_plain          3.6µs   4.15µs   234445.        0B    23.4 
#>  5 fansi_plain      37.48µs  41.32µs    23811.      688B    21.4 
#>  6 base_plain      491.04ns 531.09ns  1740757.        0B     0   
#>  7 cli_vec_ansi     14.99µs  15.88µs    62204.      448B     6.22
#>  8 fansi_vec_ansi   48.42µs  52.33µs    18849.    5.02KB    16.7 
#>  9 base_vec_ansi      8.1µs  10.32µs    96364.      448B     0   
#> 10 cli_vec_plain    14.55µs  15.37µs    64184.      448B     6.42
#> 11 fansi_vec_plain  42.97µs  46.64µs    21098.    5.02KB    16.9 
#> 12 base_vec_plain    4.38µs   5.55µs   181726.      448B     0   
#> 13 cli_txt_ansi     14.37µs  15.26µs    64640.        0B     6.46
#> 14 fansi_txt_ansi   43.77µs  46.83µs    20965.      688B    16.8 
#> 15 base_txt_ansi     7.74µs  10.27µs    97362.        0B     0   
#> 16 cli_txt_plain     13.9µs   14.5µs    68048.        0B     6.81
#> 17 fansi_txt_plain  38.52µs  42.09µs    23301.      688B    21.0 
#> 18 base_txt_plain     4.6µs   5.73µs   173181.        0B     0
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
#>  1 cli_ansi          4.26µs   4.97µs   196407.        0B    39.3 
#>  2 fansi_ansi       38.03µs  41.79µs    23583.      688B    18.9 
#>  3 base_ansi       751.11ns 822.12ns  1151763.        0B     0   
#>  4 cli_plain         4.43µs   5.06µs   193255.        0B    38.7 
#>  5 fansi_plain      37.84µs  40.69µs    24081.      688B    19.5 
#>  6 base_plain       641.1ns 701.05ns  1340013.        0B     0   
#>  7 cli_vec_ansi     18.17µs  18.98µs    51948.      448B    10.4 
#>  8 fansi_vec_ansi   48.71µs  52.25µs    18843.    5.02KB    14.6 
#>  9 base_vec_ansi    24.58µs  26.58µs    37057.      448B     0   
#> 10 cli_vec_plain    17.68µs  18.71µs    52697.      448B    10.5 
#> 11 fansi_vec_plain  44.33µs  48.24µs    20394.    5.02KB    16.8 
#> 12 base_vec_plain   13.47µs  14.02µs    70715.      448B     0   
#> 13 cli_txt_ansi     17.73µs  18.46µs    53557.        0B     5.36
#> 14 fansi_txt_ansi   45.25µs  48.61µs    20245.      688B    18.7 
#> 15 base_txt_ansi    27.06µs  28.93µs    34351.        0B     0   
#> 16 cli_txt_plain    17.47µs  18.23µs    54231.        0B     5.42
#> 17 fansi_txt_plain  39.58µs  42.77µs    22969.      688B    20.7 
#> 18 base_txt_plain    14.8µs   15.4µs    64322.        0B     0
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
#> 1 cli_ansi        3.42µs   3.93µs   248041.        0B    24.8 
#> 2 cli_plain       3.25µs   3.77µs   258561.        0B    25.9 
#> 3 cli_vec_ansi   16.27µs   17.3µs    57218.      848B     5.72
#> 4 cli_vec_plain   5.22µs   5.86µs   166550.      848B    16.7 
#> 5 cli_txt_ansi      16µs  16.96µs    58246.        0B     5.83
#> 6 cli_txt_plain   3.87µs   4.39µs   223092.        0B     0
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
#>  1 cli_ansi          13.7µs   15.1µs    64561.        0B     25.8
#>  2 fansi_ansi        14.5µs   16.1µs    60614.    7.24KB     24.3
#>  3 cli_plain         13.7µs   15.2µs    64294.        0B     25.7
#>  4 fansi_plain       14.1µs   15.8µs    61431.      688B     24.6
#>  5 cli_vec_ansi      18.2µs   20.1µs    48773.      848B     19.5
#>  6 fansi_vec_ansi    27.8µs     30µs    32818.    5.41KB     16.4
#>  7 cli_vec_plain     14.6µs   16.8µs    58493.      848B     23.4
#>  8 fansi_vec_plain   19.3µs   21.4µs    45813.    4.59KB     18.3
#>  9 cli_txt_ansi      18.2µs   19.8µs    49618.        0B     19.9
#> 10 fansi_txt_ansi    22.6µs   24.2µs    40555.    5.12KB     16.2
#> 11 cli_txt_plain       14µs   15.4µs    63747.        0B     25.5
#> 12 fansi_txt_plain   14.6µs   16.1µs    60863.      688B     24.4
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
#>  1 cli_ansi         66.06µs  73.46µs    13335.  104.86KB    23.1 
#>  2 fansi_ansi       57.75µs  63.34µs    15549.  106.35KB    23.2 
#>  3 base_ansi         2.09µs   2.31µs   421878.      224B     0   
#>  4 cli_plain        64.96µs  71.07µs    13827.    8.09KB    24.8 
#>  5 fansi_plain      56.56µs  60.18µs    16263.    9.62KB    23.1 
#>  6 base_plain        1.75µs   1.88µs   515771.        0B     0   
#>  7 cli_vec_ansi      3.58ms   3.75ms      266.  823.77KB    25.2 
#>  8 fansi_vec_ansi  539.23µs 583.66µs     1681.  846.81KB    30.8 
#>  9 base_vec_ansi    78.31µs  81.87µs    11944.    22.7KB     6.28
#> 10 cli_vec_plain     3.59ms    3.8ms      261.  823.77KB    25.6 
#> 11 fansi_vec_plain 515.62µs 551.63µs     1802.  845.98KB    33.5 
#> 12 base_vec_plain   50.48µs  56.05µs    17576.      848B     4.04
#> 13 cli_txt_ansi      1.68ms   1.72ms      579.    63.6KB     2.01
#> 14 fansi_txt_ansi  765.39µs 810.16µs     1228.   35.05KB     2.02
#> 15 base_txt_ansi    68.99µs  74.06µs    13444.   18.47KB     4.07
#> 16 cli_txt_plain     1.29ms   1.33ms      748.    63.6KB     2.02
#> 17 fansi_txt_plain 250.74µs 269.84µs     3677.    30.6KB     6.15
#> 18 base_txt_plain   44.57µs  46.37µs    21315.   11.05KB     4.26
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
#>  1 cli_ansi            70µs   78.4µs    12446.   33.84KB     25.0
#>  2 fansi_ansi        28.1µs   31.2µs    31197.   31.42KB     21.9
#>  3 base_ansi        621.1ns  661.1ns  1411394.     4.2KB      0  
#>  4 cli_plain         71.9µs   78.3µs    12520.        0B     23.3
#>  5 fansi_plain       26.5µs   29.7µs    32860.      872B     23.0
#>  6 base_plain       561.1ns  601.1ns  1554155.        0B      0  
#>  7 cli_vec_ansi     134.5µs  144.3µs     6842.   16.73KB     14.9
#>  8 fansi_vec_ansi    59.5µs   62.1µs    15885.    5.59KB     12.4
#>  9 base_vec_ansi     18.9µs   19.5µs    50835.      848B      0  
#> 10 cli_vec_plain    112.6µs  118.7µs     8295.   16.73KB     16.8
#> 11 fansi_vec_plain   54.9µs   57.5µs    17128.    5.59KB     12.5
#> 12 base_vec_plain    17.3µs     18µs    55279.      848B      0  
#> 13 cli_txt_ansi      74.7µs   78.8µs    12506.        0B     25.0
#> 14 fansi_txt_ansi      27µs   29.5µs    33246.      872B     23.3
#> 15 base_txt_ansi    611.1ns  661.1ns  1406190.        0B      0  
#> 16 cli_txt_plain     70.8µs   75.2µs    13100.        0B     25.1
#> 17 fansi_txt_plain     27µs   29.7µs    32986.      872B     23.1
#> 18 base_txt_plain   561.1ns  601.1ns  1538485.        0B    154.
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
#>  1 cli_ansi        190.54µs 202.69µs    4881.     6.18KB     23.0
#>  2 fansi_ansi       47.78µs  53.03µs   18581.    97.33KB     23.1
#>  3 base_ansi        16.66µs  18.32µs   53355.         0B     21.4
#>  4 cli_plain       118.82µs 127.73µs    7697.         0B     22.9
#>  5 fansi_plain       47.2µs  52.74µs   18501.       872B     23.2
#>  6 base_plain       13.96µs  15.47µs   63209.         0B     19.0
#>  7 cli_vec_ansi     19.98ms   20.7ms      41.1   94.67KB     37.4
#>  8 fansi_vec_ansi  118.84µs 123.42µs    7994.     7.25KB     12.6
#>  9 base_vec_ansi     1.16ms   1.21ms     826.    48.18KB     23.7
#> 10 cli_vec_plain    12.33ms  13.01ms      75.6    2.48KB     33.3
#> 11 fansi_vec_plain  97.71µs 106.65µs    6469.     6.42KB     10.4
#> 12 base_vec_plain  859.38µs 917.41µs     996.     47.4KB     19.3
#> 13 cli_txt_ansi     13.51ms  13.83ms      72.2    4.27MB     11.6
#> 14 fansi_txt_ansi  116.17µs 124.74µs    7973.     6.77KB     10.3
#> 15 base_txt_ansi   666.48µs 714.61µs    1367.   582.06KB     18.4
#> 16 cli_txt_plain   646.99µs 703.43µs    1406.   369.84KB     15.6
#> 17 fansi_txt_plain  93.63µs  99.45µs    9949.     2.51KB     12.5
#> 18 base_txt_plain  465.19µs 504.69µs    1956.   367.31KB     18.1
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
#>  1 cli_ansi           3.5µs   4.12µs   232725.   25.09KB    46.6 
#>  2 fansi_ansi        38.5µs  44.04µs    22069.   28.48KB    19.9 
#>  3 base_ansi       581.14ns 631.09ns  1453763.        0B     0   
#>  4 cli_plain         3.44µs   4.04µs   241627.        0B    24.2 
#>  5 fansi_plain      39.55µs  44.84µs    21931.    1.98KB    22.0 
#>  6 base_plain      589.99ns 651.11ns  1374131.        0B     0   
#>  7 cli_vec_ansi     13.94µs   15.2µs    64754.     1.7KB     6.48
#>  8 fansi_vec_ansi   57.46µs  62.32µs    15797.    8.86KB    14.9 
#>  9 base_vec_ansi     3.33µs   3.73µs   264809.      848B     0   
#> 10 cli_vec_plain     12.5µs  13.63µs    68780.     1.7KB     6.88
#> 11 fansi_vec_plain  55.52µs  61.46µs    15947.    8.86KB    17.1 
#> 12 base_vec_plain    3.44µs    3.9µs   253453.      848B     0   
#> 13 cli_txt_ansi      3.58µs   4.17µs   233650.        0B    23.4 
#> 14 fansi_txt_ansi   38.34µs  43.38µs    22885.    1.98KB    22.5 
#> 15 base_txt_ansi     2.18µs   2.59µs   391919.        0B     0   
#> 16 cli_txt_plain     4.05µs   4.57µs   214208.        0B    21.4 
#> 17 fansi_txt_plain  38.35µs     41µs    23937.    1.98KB    21.6 
#> 18 base_txt_plain    1.56µs   1.78µs   550309.        0B     0
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
#>  1 cli_ansi           48µs  52.45µs    18668.    12.1KB    18.9 
#>  2 base_ansi      770.09ns 820.96ns  1176304.        0B     0   
#>  3 cli_plain       37.93µs  41.04µs    23931.    8.91KB    16.8 
#>  4 base_plain        561ns 600.94ns  1611795.        0B     0   
#>  5 cli_vec_ansi     2.31ms   2.48ms      401.  838.95KB    24.8 
#>  6 base_vec_ansi   44.58µs  46.23µs    21433.      848B     0   
#>  7 cli_vec_plain    1.33ms   1.39ms      709.  817.08KB    24.4 
#>  8 base_vec_plain  26.14µs  28.07µs    35359.      848B     0   
#>  9 cli_txt_ansi     7.39ms   7.46ms      132.   114.6KB     6.37
#> 10 base_txt_ansi   45.32µs  46.44µs    20140.        0B     0   
#> 11 cli_txt_plain  143.89µs 154.27µs     6432.   18.34KB     4.05
#> 12 base_txt_plain  24.59µs  25.15µs    39473.        0B     0
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
#>  1 cli_ansi        49.84µs  55.23µs    17659.        0B    23.4 
#>  2 base_ansi        8.51µs   9.56µs   101668.        0B    20.3 
#>  3 cli_plain       49.77µs  54.64µs    17919.        0B    25.3 
#>  4 base_plain       8.49µs   9.62µs   101223.        0B    20.2 
#>  5 cli_vec_ansi    94.68µs 100.68µs     9759.     7.2KB    12.5 
#>  6 base_vec_ansi   27.25µs   30.3µs    32568.    1.66KB     6.51
#>  7 cli_vec_plain   87.44µs   93.4µs    10598.     7.2KB    14.5 
#>  8 base_vec_plain  24.34µs  25.73µs    38334.    1.66KB     7.67
#>  9 cli_txt_ansi    81.97µs  87.81µs    11241.        0B    16.7 
#> 10 base_txt_ansi   18.53µs   20.2µs    48770.        0B     9.76
#> 11 cli_txt_plain   76.41µs  80.86µs    12153.        0B    16.5 
#> 12 base_txt_plain  16.95µs  18.22µs    54067.        0B    10.8
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
#> 1 cli          4.16µs   4.88µs   199528.        0B    20.0 
#> 2 base        541.1ns 581.03ns  1514916.        0B   152.  
#> 3 cli_vec     12.24µs  13.11µs    75180.      448B     7.52
#> 4 base_vec     6.82µs   7.08µs   138718.      448B     0   
#> 5 cli_txt     13.05µs  13.84µs    71051.        0B     7.11
#> 6 base_txt     7.77µs   7.82µs   126160.        0B     0
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
#> 1 cli          4.08µs   4.65µs   209905.        0B    42.0 
#> 2 base       730.97ns 800.94ns  1183243.        0B     0   
#> 3 cli_vec     14.13µs  14.94µs    66052.      448B     6.61
#> 4 base_vec    27.75µs  28.74µs    34025.      448B     0   
#> 5 cli_txt     14.96µs  15.61µs    63342.        0B     6.33
#> 6 base_txt    50.96µs  52.05µs    19064.        0B     0
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
#> 1 cli          4.41µs   5.03µs   193939.        0B    19.4 
#> 2 base       510.02ns 561.12ns  1660108.        0B     0   
#> 3 cli_vec     10.92µs  11.61µs    85084.      448B     8.51
#> 4 base_vec     6.87µs   7.02µs   139807.      448B     0   
#> 5 cli_txt     11.66µs  12.32µs    79899.        0B    16.0 
#> 6 base_txt     7.75µs   7.79µs   126469.        0B     0
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
#> 1 cli          3.31µs   3.79µs   257168.    22.2KB     25.7
#> 2 base       591.04ns  641.1ns  1385214.        0B      0  
#> 3 cli_vec     15.62µs  16.44µs    60150.     1.7KB     12.0
#> 4 base_vec     4.49µs   4.61µs   212260.      848B      0  
#> 5 cli_txt      3.33µs    3.8µs   257680.        0B     25.8
#> 6 base_txt     2.85µs    2.9µs   333029.        0B      0
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
