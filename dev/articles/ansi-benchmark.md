# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x5597a8300d10\>
\<environment: 0x5597a8e2c910\>

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
#> 1 ansi        29.17µs  32.51µs    30189.    99.6KB     30.2
#> 2 plain       29.17µs  32.53µs    30110.        0B     33.2
#> 3 base         8.46µs   9.72µs   100376.    48.6KB     20.1
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
#> 1 ansi        30.69µs   34.6µs    28307.        0B     34.0
#> 2 plain        30.2µs   33.6µs    29130.        0B     35.0
#> 3 base         9.86µs   11.2µs    87173.        0B     34.9
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
#> 1 ansi        76.94µs  84.03µs    11601.   77.03KB     23.3
#> 2 plain       58.66µs  64.67µs    15044.    8.91KB     23.4
#> 3 base         1.45µs   1.61µs   586651.        0B      0
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
#> 1 ansi          216µs    235µs     4225.   33.24KB     32.5
#> 2 plain         207µs    230µs     4276.    1.09KB     22.3
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
#>  1 cli_ansi          4.24µs   4.73µs   203230.    9.27KB     20.3
#>  2 fansi_ansi       20.94µs     23µs    42358.    4.18KB     16.9
#>  3 cli_plain         4.27µs   4.72µs   206466.        0B     20.6
#>  4 fansi_plain      20.91µs  22.91µs    42661.      688B     21.3
#>  5 cli_vec_ansi       5.3µs   5.89µs   165459.      448B     16.5
#>  6 fansi_vec_ansi   28.11µs   30.7µs    31756.    5.02KB     12.7
#>  7 cli_vec_plain     5.84µs   6.39µs   152454.      448B     15.2
#>  8 fansi_vec_plain  27.51µs  30.09µs    32575.    5.02KB     13.0
#>  9 cli_txt_ansi      4.22µs   4.74µs   202133.        0B     20.2
#> 10 fansi_txt_ansi   20.94µs  23.03µs    42466.      688B     21.2
#> 11 cli_txt_plain     4.97µs   5.55µs   174876.        0B     17.5
#> 12 fansi_txt_plain  27.38µs  30.06µs    32604.    5.02KB     13.0
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
#> 1 cli          42.8µs   44.8µs    21997.    22.7KB     6.60
#> 2 fansi        86.5µs   90.4µs    10873.    55.3KB     6.11
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
#>  1 cli_ansi          5.09µs   5.73µs   168735.        0B    16.9 
#>  2 fansi_ansi        56.4µs  61.16µs    16007.   38.84KB    14.5 
#>  3 base_ansi       701.17ns 762.05ns  1178008.        0B     0   
#>  4 cli_plain         5.03µs    5.7µs   170470.        0B    17.0 
#>  5 fansi_plain      55.64µs   61.1µs    16056.      688B    14.5 
#>  6 base_plain      630.97ns 691.16ns  1297473.        0B     0   
#>  7 cli_vec_ansi     23.36µs   24.2µs    40651.      448B     4.07
#>  8 fansi_vec_ansi   72.53µs  78.69µs    12458.    5.02KB    10.5 
#>  9 base_vec_ansi    15.83µs  15.91µs    61762.      448B     0   
#> 10 cli_vec_plain     21.7µs  23.05µs    42906.      448B     4.29
#> 11 fansi_vec_plain  64.09µs  70.25µs    13956.    5.02KB    12.5 
#> 12 base_vec_plain    9.11µs   9.22µs   106500.      448B     0   
#> 13 cli_txt_ansi     23.45µs  24.21µs    40772.        0B     4.08
#> 14 fansi_txt_ansi   66.39µs   71.5µs    13729.      688B    12.4 
#> 15 base_txt_ansi     15.8µs  15.89µs    62070.        0B     0   
#> 16 cli_txt_plain     21.4µs  22.61µs    43681.        0B     4.37
#> 17 fansi_txt_plain  57.66µs  63.37µs    15484.      688B    12.4 
#> 18 base_txt_plain    9.12µs    9.2µs   106077.        0B    10.6
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
#>  1 cli_ansi          6.25µs   7.01µs   138808.        0B    13.9 
#>  2 fansi_ansi       56.88µs  61.81µs    15844.      688B    14.5 
#>  3 base_ansi        941.1ns   1.03µs   895508.        0B     0   
#>  4 cli_plain         6.16µs   6.98µs   139218.        0B    13.9 
#>  5 fansi_plain      56.38µs  61.28µs    15998.      688B    14.5 
#>  6 base_plain      761.01ns 842.15ns  1079628.        0B     0   
#>  7 cli_vec_ansi      26.2µs  27.31µs    36093.      448B     3.61
#>  8 fansi_vec_ansi   75.01µs  80.69µs    12156.    5.02KB    10.5 
#>  9 base_vec_ansi    34.96µs  35.76µs    27691.      448B     0   
#> 10 cli_vec_plain    24.96µs  25.96µs    38007.      448B     7.60
#> 11 fansi_vec_plain  66.74µs  72.18µs    13574.    5.02KB    10.4 
#> 12 base_vec_plain   18.26µs   18.5µs    53366.      448B     0   
#> 13 cli_txt_ansi     26.73µs  27.66µs    35598.        0B     7.12
#> 14 fansi_txt_ansi   68.84µs  73.75µs    13310.      688B    10.3 
#> 15 base_txt_ansi    36.86µs  37.58µs    26370.        0B     2.64
#> 16 cli_txt_plain     24.8µs  25.67µs    38426.        0B     3.84
#> 17 fansi_txt_plain  59.99µs   64.4µs    15150.      688B    12.2 
#> 18 base_txt_plain   19.47µs  19.69µs    50309.        0B     0
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
#> 1 cli_ansi        4.98µs   5.41µs   181034.        0B     0   
#> 2 cli_plain       4.71µs   5.14µs   190584.        0B    19.1 
#> 3 cli_vec_ansi   23.73µs  24.46µs    40415.      848B     4.04
#> 4 cli_vec_plain   7.86µs   8.41µs   116708.      848B    11.7 
#> 5 cli_txt_ansi   23.41µs  24.89µs    39723.        0B     3.97
#> 6 cli_txt_plain   5.45µs   5.91µs   165724.        0B    16.6
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
#>  1 cli_ansi          18.2µs   19.7µs    49834.        0B    19.9 
#>  2 fansi_ansi        19.4µs   20.9µs    46753.    7.24KB    18.7 
#>  3 cli_plain         18.3µs   19.6µs    49922.        0B    25.0 
#>  4 fansi_plain       19.1µs   21.1µs    46253.      688B    18.5 
#>  5 cli_vec_ansi      25.8µs     28µs    35087.      848B    14.0 
#>  6 fansi_vec_ansi    39.9µs   42.8µs    22901.    5.41KB     9.16
#>  7 cli_vec_plain     20.7µs   22.7µs    43238.      848B    17.3 
#>  8 fansi_vec_plain   26.7µs   28.8µs    34032.    4.59KB    13.6 
#>  9 cli_txt_ansi      25.1µs   27.4µs    35778.        0B    17.9 
#> 10 fansi_txt_ansi    32.5µs   34.7µs    28291.    5.12KB    11.3 
#> 11 cli_txt_plain     19.1µs     21µs    46633.        0B    18.7 
#> 12 fansi_txt_plain     20µs     22µs    44352.      688B    17.7
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
#>  1 cli_ansi        100.91µs 109.58µs     8945.  104.86KB    16.9 
#>  2 fansi_ansi       82.59µs  90.37µs    10920.  106.35KB    14.7 
#>  3 base_ansi         3.06µs   4.04µs   243820.      224B    24.4 
#>  4 cli_plain       101.14µs 108.65µs     9013.    8.09KB    14.5 
#>  5 fansi_plain      81.64µs  89.48µs    11014.    9.62KB    16.9 
#>  6 base_plain        2.68µs   2.92µs   330703.        0B     0   
#>  7 cli_vec_ansi      5.07ms   5.27ms      190.  823.77KB    18.3 
#>  8 fansi_vec_ansi  785.49µs 835.17µs     1175.  846.81KB    24.7 
#>  9 base_vec_ansi   120.64µs 125.08µs     7903.    22.7KB     4.13
#> 10 cli_vec_plain     5.05ms   5.26ms      189.  823.77KB    18.7 
#> 11 fansi_vec_plain 735.09µs 783.63µs     1241.  845.98KB    25.0 
#> 12 base_vec_plain   82.13µs  86.96µs    11279.      848B     4.05
#> 13 cli_txt_ansi      2.57ms   2.66ms      374.    63.6KB     0   
#> 14 fansi_txt_ansi    1.25ms   1.27ms      786.   35.05KB     0   
#> 15 base_txt_ansi   109.04µs 114.46µs     8614.   18.47KB     4.07
#> 16 cli_txt_plain     2.01ms   2.04ms      490.    63.6KB     0   
#> 17 fansi_txt_plain    415µs 435.89µs     2280.    30.6KB     4.08
#> 18 base_txt_plain   70.88µs  73.32µs    13432.   11.05KB     2.02
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
#>  1 cli_ansi          96.7µs  101.2µs     9689.   33.84KB    18.9 
#>  2 fansi_ansi        36.8µs   40.6µs    23891.   31.42KB    16.7 
#>  3 base_ansi          791ns    871ns  1050625.     4.2KB     0   
#>  4 cli_plain         96.1µs  103.2µs     9544.        0B    18.9 
#>  5 fansi_plain       37.3µs   40.9µs    23935.      872B    16.8 
#>  6 base_plain       741.1ns  821.2ns  1116402.        0B     0   
#>  7 cli_vec_ansi       195µs  203.9µs     4848.   16.73KB    10.4 
#>  8 fansi_vec_ansi    88.5µs   92.9µs    10559.    5.59KB     8.28
#>  9 base_vec_ansi     28.8µs   29.1µs    33015.      848B     0   
#> 10 cli_vec_plain    163.2µs  171.7µs     5547.   16.73KB    10.4 
#> 11 fansi_vec_plain   81.1µs   85.6µs    11282.    5.59KB    10.4 
#> 12 base_vec_plain      24µs   24.3µs    40000.      848B     0   
#> 13 cli_txt_ansi     101.6µs  110.9µs     8683.        0B    16.9 
#> 14 fansi_txt_ansi    36.8µs   40.6µs    23767.      872B    16.6 
#> 15 base_txt_ansi    821.1ns  902.1ns  1021926.        0B     0   
#> 16 cli_txt_plain     97.1µs  104.5µs     9380.        0B    18.9 
#> 17 fansi_txt_plain   37.2µs   40.9µs    24051.      872B    16.8 
#> 18 base_txt_plain     761ns  841.1ns  1084898.        0B     0
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
#>  1 cli_ansi        271.09µs 292.24µs    3380.     6.18KB    16.8 
#>  2 fansi_ansi       67.18µs  73.56µs   13324.    97.33KB    17.0 
#>  3 base_ansi        24.26µs  26.08µs   37378.         0B    15.0 
#>  4 cli_plain       169.28µs 180.67µs    5446.         0B    16.7 
#>  5 fansi_plain      65.58µs  70.89µs   13859.       872B    17.4 
#>  6 base_plain       19.75µs  20.88µs   47062.         0B    14.1 
#>  7 cli_vec_ansi     28.14ms  28.23ms      35.4   94.67KB    39.8 
#>  8 fansi_vec_ansi  181.49µs 187.49µs    5244.     7.25KB     6.14
#>  9 base_vec_ansi     1.65ms   1.74ms     575.    48.18KB    17.5 
#> 10 cli_vec_plain    17.77ms  18.02ms      55.4    2.48KB    23.3 
#> 11 fansi_vec_plain 143.42µs 152.22µs    6483.     6.42KB    10.4 
#> 12 base_vec_plain    1.22ms   1.27ms     781.     47.4KB    14.9 
#> 13 cli_txt_ansi     21.96ms  22.07ms      45.2    4.27MB    10.1 
#> 14 fansi_txt_ansi  180.55µs 188.51µs    5247.     6.77KB     6.11
#> 15 base_txt_ansi   995.08µs   1.03ms     954.   582.06KB    11.2 
#> 16 cli_txt_plain   986.38µs   1.03ms     964.   369.84KB    13.5 
#> 17 fansi_txt_plain 140.32µs  147.4µs    6703.     2.51KB     8.20
#> 18 base_txt_plain  672.64µs 708.72µs    1394.   367.31KB    11.1
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
#>  1 cli_ansi          5.03µs    5.7µs   169282.   25.09KB    16.9 
#>  2 fansi_ansi       55.24µs  60.36µs    16278.   28.48KB    14.7 
#>  3 base_ansi       811.07ns 891.04ns  1028592.        0B     0   
#>  4 cli_plain         4.97µs   5.64µs   170442.        0B    17.0 
#>  5 fansi_plain      55.54µs  60.35µs    16229.    1.98KB    14.7 
#>  6 base_plain      761.01ns 842.03ns  1089508.        0B     0   
#>  7 cli_vec_ansi     20.56µs  21.69µs    45401.     1.7KB     4.54
#>  8 fansi_vec_ansi   84.28µs  89.46µs    10955.    8.86KB    10.5 
#>  9 base_vec_ansi     5.09µs   5.37µs   182452.      848B     0   
#> 10 cli_vec_plain    17.95µs  19.19µs    51032.     1.7KB    10.2 
#> 11 fansi_vec_plain   79.6µs  85.04µs    11522.    8.86KB    10.5 
#> 12 base_vec_plain    4.99µs   5.22µs   188423.      848B     0   
#> 13 cli_txt_ansi      4.97µs   5.74µs   166088.        0B    16.6 
#> 14 fansi_txt_ansi   55.01µs   60.4µs    16262.    1.98KB    14.7 
#> 15 base_txt_ansi     5.49µs    5.6µs   173028.        0B    17.3 
#> 16 cli_txt_plain     5.66µs   6.37µs   152023.        0B    15.2 
#> 17 fansi_txt_plain  55.25µs  60.54µs    16207.    1.98KB    14.7 
#> 18 base_txt_plain    3.42µs    3.5µs   276997.        0B     0
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
#>  1 cli_ansi        72.04µs  77.77µs   12589.     12.1KB    12.4 
#>  2 base_ansi           1µs   1.06µs  901585.         0B     0   
#>  3 cli_plain       56.73µs  59.94µs   15669.     8.91KB    10.3 
#>  4 base_plain     761.01ns 821.08ns 1149129.         0B   115.  
#>  5 cli_vec_ansi     3.24ms   3.31ms     301.   838.95KB    17.7 
#>  6 base_vec_ansi   58.72µs   60.1µs   16395.       848B     0   
#>  7 cli_vec_plain    1.81ms   1.87ms     530.   817.08KB    17.6 
#>  8 base_vec_plain     36µs  36.74µs   27024.       848B     0   
#>  9 cli_txt_ansi    12.49ms  12.57ms      79.5   114.6KB     4.18
#> 10 base_txt_ansi   55.52µs  58.88µs   16774.         0B     0   
#> 11 cli_txt_plain  228.59µs 239.54µs    4093.    18.34KB     4.05
#> 12 base_txt_plain  33.47µs  33.93µs   29187.         0B     0
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
#>  1 cli_ansi         69.6µs   74.7µs    13123.        0B    18.8 
#>  2 base_ansi        11.7µs     13µs    75087.        0B    15.0 
#>  3 cli_plain        69.9µs   74.5µs    13142.        0B    16.7 
#>  4 base_plain       11.8µs     13µs    74736.        0B    15.0 
#>  5 cli_vec_ansi    150.4µs  161.1µs     6108.     7.2KB     8.22
#>  6 base_vec_ansi    44.3µs   50.9µs    19441.    1.66KB     4.06
#>  7 cli_vec_plain   140.6µs  150.4µs     6547.     7.2KB    10.4 
#>  8 base_vec_plain   38.9µs     45µs    21976.    1.66KB     4.40
#>  9 cli_txt_ansi    134.7µs  140.5µs     6995.        0B    10.4 
#> 10 base_txt_ansi      32µs   33.4µs    29487.        0B     5.90
#> 11 cli_txt_plain   121.5µs    127µs     7730.        0B    10.3 
#> 12 base_txt_plain   26.7µs     28µs    35105.        0B     7.02
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
#> 1 cli          5.93µs   6.68µs   144969.        0B    14.5 
#> 2 base       640.98ns 722.12ns  1215811.        0B     0   
#> 3 cli_vec     17.91µs  18.82µs    52157.      448B     5.22
#> 4 base_vec     9.38µs   9.65µs   101576.      448B    10.2 
#> 5 cli_txt     17.87µs  18.68µs    52560.        0B     5.26
#> 6 base_txt    10.16µs  10.35µs    95033.        0B     0
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
#> 1 cli          5.87µs   6.64µs   142533.        0B    14.3 
#> 2 base         1.01µs    1.1µs   845690.        0B     0   
#> 3 cli_vec     22.86µs  23.95µs    39091.      448B     7.82
#> 4 base_vec    41.65µs  42.18µs    23433.      448B     0   
#> 5 cli_txt     23.07µs  24.04µs    40998.        0B     4.10
#> 6 base_txt    74.83µs  75.66µs    13082.        0B     0
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
#> 1 cli          6.34µs   7.19µs   133677.        0B    26.7 
#> 2 base        641.1ns 721.08ns  1270797.        0B     0   
#> 3 cli_vec     15.33µs  16.28µs    60151.      448B     6.02
#> 4 base_vec     9.37µs   9.64µs   102175.      448B     0   
#> 5 cli_txt     15.86µs  16.77µs    58491.        0B     5.85
#> 6 base_txt    10.19µs  10.38µs    94456.        0B     9.45
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
#> 1 cli          4.71µs   5.41µs   177458.    22.2KB    17.7 
#> 2 base       791.04ns 880.91ns  1047800.        0B     0   
#> 3 cli_vec     22.61µs  23.57µs    41705.     1.7KB     4.17
#> 4 base_vec     6.42µs   6.69µs   145316.      848B    14.5 
#> 5 cli_txt      4.71µs   5.36µs   179763.        0B    18.0 
#> 6 base_txt     4.03µs   4.23µs   230599.        0B     0
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
#>  date     2026-10-02
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-10-02 [1] local
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
