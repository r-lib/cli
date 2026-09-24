# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x55c3e9246f20\>
\<environment: 0x55c3e9cddb80\>

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
#> 1 ansi        21.66µs   23.7µs    41401.    99.6KB     41.4
#> 2 plain       21.36µs  23.27µs    42182.        0B     46.5
#> 3 base         6.21µs   6.94µs   141034.    48.6KB     28.2
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
#> 1 ansi        22.73µs  25.69µs    37435.        0B     45.0
#> 2 plain       22.29µs  24.88µs    39179.        0B     47.1
#> 3 base         7.11µs   8.07µs   115134.        0B     46.1
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
#> 1 ansi        53.84µs  59.91µs    15584.   77.03KB     31.6
#> 2 plain       42.81µs  46.22µs    21221.    8.91KB     31.9
#> 3 base         1.26µs   1.31µs   718827.        0B      0
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
#> 1 ansi          151µs    166µs     5896.   33.24KB     34.6
#> 2 plain         156µs    168µs     5893.    1.09KB     22.9
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
#>  1 cli_ansi          3.31µs   3.81µs   252251.    9.27KB     25.2
#>  2 fansi_ansi        16.5µs  18.35µs    53209.    4.18KB     21.3
#>  3 cli_plain         3.44µs   3.93µs   248819.        0B     24.9
#>  4 fansi_plain      16.34µs  18.68µs    52349.      688B     20.9
#>  5 cli_vec_ansi      4.27µs   4.76µs   205774.      448B     20.6
#>  6 fansi_vec_ansi      22µs  24.35µs    40034.    5.02KB     20.0
#>  7 cli_vec_plain     4.54µs   5.05µs   194538.      448B     19.5
#>  8 fansi_vec_plain  20.83µs   23.3µs    42103.    5.02KB     16.8
#>  9 cli_txt_ansi       3.4µs   3.91µs   248936.        0B     24.9
#> 10 fansi_txt_ansi   16.34µs  18.28µs    53623.      688B     21.5
#> 11 cli_txt_plain     4.03µs   4.46µs   220339.        0B     22.0
#> 12 fansi_txt_plain  21.02µs  23.86µs    41004.    5.02KB     20.5
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
#> 1 cli          33.6µs   35.5µs    27681.    22.7KB     8.31
#> 2 fansi        64.1µs   68.4µs    14289.    55.3KB     8.17
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
#>  1 cli_ansi           3.9µs    4.6µs   211577.        0B    21.2 
#>  2 fansi_ansi       41.38µs  45.16µs    21687.   38.84KB    17.4 
#>  3 base_ansi       591.04ns 650.99ns  1416334.        0B   142.  
#>  4 cli_plain         3.94µs    4.5µs   217104.        0B    21.7 
#>  5 fansi_plain      40.76µs  44.56µs    22041.      688B    17.6 
#>  6 base_plain      540.98ns 581.03ns  1604989.        0B     0   
#>  7 cli_vec_ansi     15.54µs  16.66µs    59249.      448B     5.93
#>  8 fansi_vec_ansi    53.3µs  57.85µs    16983.    5.02KB    14.6 
#>  9 base_vec_ansi     9.84µs  12.45µs    81775.      448B     8.18
#> 10 cli_vec_plain    15.84µs  16.72µs    59071.      448B     5.91
#> 11 fansi_vec_plain  47.65µs  52.65µs    18644.    5.02KB    14.7 
#> 12 base_vec_plain    5.44µs   6.64µs   146258.      448B     0   
#> 13 cli_txt_ansi     15.54µs  16.83µs    58835.        0B     5.88
#> 14 fansi_txt_ansi   48.45µs  52.53µs    18697.      688B    16.6 
#> 15 base_txt_ansi     9.37µs   11.5µs    87197.        0B     0   
#> 16 cli_txt_plain    15.09µs  15.91µs    61961.        0B     6.20
#> 17 fansi_txt_plain  41.07µs  46.15µs    21314.      688B    19.2 
#> 18 base_txt_plain    5.37µs   6.51µs   153214.        0B     0
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
#>  1 cli_ansi          4.71µs   5.48µs   177674.        0B    35.5 
#>  2 fansi_ansi       41.05µs  44.97µs    21806.      688B    17.5 
#>  3 base_ansi        841.1ns 901.99ns  1052717.        0B     0   
#>  4 cli_plain         4.68µs   5.43µs   179515.        0B    35.9 
#>  5 fansi_plain      40.74µs  44.21µs    22208.      688B    17.6 
#>  6 base_plain      662.05ns 761.01ns  1212532.        0B   121.  
#>  7 cli_vec_ansi     20.32µs  21.42µs    45909.      448B     4.59
#>  8 fansi_vec_ansi   53.77µs  58.22µs    16012.    5.02KB    12.6 
#>  9 base_vec_ansi    27.91µs  31.08µs    31897.      448B     3.19
#> 10 cli_vec_plain     19.4µs  20.68µs    47878.      448B     4.79
#> 11 fansi_vec_plain  48.01µs  51.65µs    19049.    5.02KB    16.8 
#> 12 base_vec_plain   15.42µs  16.09µs    61769.      448B     0   
#> 13 cli_txt_ansi     19.21µs   20.2µs    48997.        0B     4.90
#> 14 fansi_txt_ansi   50.15µs  54.48µs    18051.      688B    14.6 
#> 15 base_txt_ansi    30.88µs  33.23µs    29165.        0B     2.92
#> 16 cli_txt_plain    18.63µs   19.9µs    49770.        0B     4.98
#> 17 fansi_txt_plain   42.8µs  46.53µs    21139.      688B    16.9 
#> 18 base_txt_plain   16.09µs  16.92µs    58586.        0B     5.86
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
#> 1 cli_ansi        3.74µs   4.26µs   229632.        0B    23.0 
#> 2 cli_plain       3.54µs   4.03µs   242765.        0B    24.3 
#> 3 cli_vec_ansi   17.54µs  18.97µs    50926.      848B     0   
#> 4 cli_vec_plain   5.75µs   6.41µs   152481.      848B    15.2 
#> 5 cli_txt_ansi   17.56µs  18.57µs    53125.        0B     5.31
#> 6 cli_txt_plain    4.1µs   4.69µs   208728.        0B    20.9
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
#>  1 cli_ansi          14.3µs   15.9µs    61700.        0B     30.9
#>  2 fansi_ansi        14.6µs   16.4µs    59710.    7.24KB     23.9
#>  3 cli_plain         14.1µs   15.6µs    62630.        0B     25.1
#>  4 fansi_plain       14.8µs   16.3µs    60069.      688B     24.0
#>  5 cli_vec_ansi      19.9µs     22µs    44612.      848B     17.9
#>  6 fansi_vec_ansi    29.4µs   32.2µs    30405.    5.41KB     12.2
#>  7 cli_vec_plain     15.8µs   17.6µs    55558.      848B     27.8
#>  8 fansi_vec_plain     20µs   22.5µs    43312.    4.59KB     17.3
#>  9 cli_txt_ansi      19.7µs   21.7µs    45172.        0B     18.1
#> 10 fansi_txt_ansi    24.5µs   26.5µs    36907.    5.12KB     14.8
#> 11 cli_txt_plain     14.9µs   16.5µs    50532.        0B     20.2
#> 12 fansi_txt_plain   15.7µs   17.4µs    55862.      688B     22.4
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
#>  1 cli_ansi          69.9µs     76µs    12910.  104.86KB    23.1 
#>  2 fansi_ansi       60.42µs  66.73µs    14765.  106.35KB    20.9 
#>  3 base_ansi         2.41µs   2.62µs   370585.      224B     0   
#>  4 cli_plain        69.03µs  75.67µs    12926.    8.09KB    24.4 
#>  5 fansi_plain      60.85µs  65.76µs    14930.    9.62KB    21.2 
#>  6 base_plain        2.15µs   2.31µs   420982.        0B     0   
#>  7 cli_vec_ansi      3.68ms   3.86ms      256.  823.77KB    25.6 
#>  8 fansi_vec_ansi  576.67µs 628.38µs     1573.  846.81KB    28.6 
#>  9 base_vec_ansi    88.57µs  93.94µs    10346.    22.7KB     4.17
#> 10 cli_vec_plain     3.94ms   4.08ms      242.  823.77KB    23.7 
#> 11 fansi_vec_plain 591.02µs  635.2µs     1544.  845.98KB    27.5 
#> 12 base_vec_plain   58.64µs  64.07µs    15400.      848B     6.12
#> 13 cli_txt_ansi       1.9ms   1.96ms      507.    63.6KB     0   
#> 14 fansi_txt_ansi  916.06µs 961.35µs     1039.   35.05KB     2.02
#> 15 base_txt_ansi    76.35µs  81.86µs    11589.   18.47KB     4.27
#> 16 cli_txt_plain     1.34ms    1.4ms      714.    63.6KB     0   
#> 17 fansi_txt_plain 287.77µs 303.97µs     3269.    30.6KB     4.07
#> 18 base_txt_plain    47.7µs  49.99µs    19690.   11.05KB     6.13
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
#>  1 cli_ansi          73.8µs   80.4µs    12120.   33.84KB     23.0
#>  2 fansi_ansi        28.8µs   31.8µs    30620.   31.42KB     21.4
#>  3 base_ansi          661ns  691.2ns  1343901.     4.2KB      0  
#>  4 cli_plain           75µs   81.8µs    11897.        0B     25.2
#>  5 fansi_plain       28.7µs   32.7µs    28910.      872B     20.3
#>  6 base_plain         591ns  651.1ns  1434768.        0B      0  
#>  7 cli_vec_ansi     142.6µs  152.2µs     6481.   16.73KB     12.5
#>  8 fansi_vec_ansi      68µs   72.2µs    13349.    5.59KB     10.3
#>  9 base_vec_ansi     21.2µs     23µs    38046.      848B      0  
#> 10 cli_vec_plain    121.1µs  129.7µs     7521.   16.73KB     14.7
#> 11 fansi_vec_plain   59.9µs   63.5µs    14282.    5.59KB     12.7
#> 12 base_vec_plain    17.3µs   18.3µs    54365.      848B      0  
#> 13 cli_txt_ansi      77.5µs   83.5µs    11758.        0B     23.1
#> 14 fansi_txt_ansi      28µs   30.5µs    31979.      872B     22.4
#> 15 base_txt_ansi      671ns  721.1ns  1249000.        0B      0  
#> 16 cli_txt_plain     75.3µs   80.5µs    12210.        0B     23.1
#> 17 fansi_txt_plain   28.1µs   31.2µs    31407.      872B     22.0
#> 18 base_txt_plain   611.1ns  661.1ns  1418523.        0B    142.
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
#>  1 cli_ansi           201µs  215.8µs    4585.     6.18KB    21.1 
#>  2 fansi_ansi        51.8µs   57.2µs   17130.    97.33KB    21.3 
#>  3 base_ansi           18µs   20.2µs   45718.         0B    18.3 
#>  4 cli_plain        126.7µs  136.3µs    7202.         0B    23.2 
#>  5 fansi_plain       49.8µs   55.8µs   17600.       872B    20.8 
#>  6 base_plain        14.7µs   16.5µs   59115.         0B    23.7 
#>  7 cli_vec_ansi      21.5ms     22ms      45.4   94.67KB    37.8 
#>  8 fansi_vec_ansi   133.3µs  143.6µs    6347.     7.25KB    10.4 
#>  9 base_vec_ansi      1.3ms    1.4ms     695.    48.18KB    19.7 
#> 10 cli_vec_plain     13.8ms   14.4ms      69.7    2.48KB    33.2 
#> 11 fansi_vec_plain  110.6µs  115.8µs    8524.     6.42KB    12.5 
#> 12 base_vec_plain   948.7µs  985.2µs    1007.     47.4KB    19.4 
#> 13 cli_txt_ansi      14.6ms   15.2ms      65.4    4.27MB    12.1 
#> 14 fansi_txt_ansi   131.2µs  139.9µs    7049.     6.77KB     8.28
#> 15 base_txt_ansi    734.2µs  804.8µs    1216.   582.06KB    16.4 
#> 16 cli_txt_plain      714µs  757.5µs    1281.   369.84KB    15.9 
#> 17 fansi_txt_plain  104.6µs  110.5µs    8921.     2.51KB    10.4 
#> 18 base_txt_plain   499.6µs  536.7µs    1823.   367.31KB    15.9
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
#>  1 cli_ansi          3.88µs   4.56µs   207258.   25.09KB    41.5 
#>  2 fansi_ansi       43.36µs  48.95µs    20043.   28.48KB    19.1 
#>  3 base_ansi       611.06ns 681.15ns  1325882.        0B     0   
#>  4 cli_plain         3.83µs   4.56µs   211856.        0B    21.2 
#>  5 fansi_plain      43.24µs  48.95µs    19951.    1.98KB    19.1 
#>  6 base_plain      611.06ns 651.11ns  1348159.        0B     0   
#>  7 cli_vec_ansi      15.2µs  16.61µs    59174.     1.7KB     5.92
#>  8 fansi_vec_ansi   65.23µs  70.76µs    13851.    8.86KB    12.8 
#>  9 base_vec_ansi     3.89µs   4.37µs   225631.      848B     0   
#> 10 cli_vec_plain    13.35µs  14.52µs    67502.     1.7KB    13.5 
#> 11 fansi_vec_plain  61.77µs   67.3µs    14568.    8.86KB    12.9 
#> 12 base_vec_plain    3.82µs   4.24µs   233222.      848B     0   
#> 13 cli_txt_ansi      3.99µs   4.64µs   202665.        0B    40.5 
#> 14 fansi_txt_ansi   42.98µs  48.84µs    20109.    1.98KB    16.9 
#> 15 base_txt_ansi     2.97µs   3.02µs   313812.        0B    31.4 
#> 16 cli_txt_plain     4.54µs    5.3µs   182339.        0B    18.2 
#> 17 fansi_txt_plain  43.59µs  49.19µs    19987.    1.98KB    19.8 
#> 18 base_txt_plain    1.96µs   2.02µs   474264.        0B     0
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
#>  1 cli_ansi        53.05µs  57.76µs    17036.    12.1KB    16.8 
#>  2 base_ansi         912ns 981.15ns   987513.        0B     0   
#>  3 cli_plain       42.48µs  46.14µs    21310.    8.91KB    17.1 
#>  4 base_plain     631.09ns 711.07ns  1365618.        0B     0   
#>  5 cli_vec_ansi     2.54ms   2.71ms      367.  838.95KB    20.3 
#>  6 base_vec_ansi    48.8µs  51.03µs    19388.      848B     2.01
#>  7 cli_vec_plain    1.42ms    1.5ms      662.  817.08KB    21.9 
#>  8 base_vec_plain  26.88µs  28.64µs    34678.      848B     0   
#>  9 cli_txt_ansi     8.27ms   8.51ms      117.   114.6KB     6.39
#> 10 base_txt_ansi   48.85µs  50.48µs    19712.        0B     0   
#> 11 cli_txt_plain  155.75µs  165.6µs     5865.   18.34KB     4.06
#> 12 base_txt_plain  26.71µs  27.38µs    34271.        0B     0
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
#>  1 cli_ansi        52.63µs  58.05µs    16612.        0B    23.2 
#>  2 base_ansi        8.98µs  10.14µs    94723.        0B    18.9 
#>  3 cli_plain       53.22µs  58.27µs    16617.        0B    23.4 
#>  4 base_plain       8.82µs   9.97µs    97166.        0B    19.4 
#>  5 cli_vec_ansi   107.84µs 114.32µs     8622.     7.2KB    12.5 
#>  6 base_vec_ansi   31.03µs  35.02µs    28454.    1.66KB     5.69
#>  7 cli_vec_plain   98.07µs 105.58µs     9322.     7.2KB    12.5 
#>  8 base_vec_plain  28.29µs  32.55µs    30591.    1.66KB     6.12
#>  9 cli_txt_ansi    92.58µs  99.44µs     9750.        0B    14.5 
#> 10 base_txt_ansi   21.03µs  22.68µs    43295.        0B     8.66
#> 11 cli_txt_plain    83.5µs  90.31µs    10840.        0B    14.5 
#> 12 base_txt_plain  18.53µs  20.14µs    48805.        0B     9.76
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
#> 1 cli          4.52µs   5.33µs   181059.        0B    18.1 
#> 2 base        570.9ns 620.96ns  1360776.        0B   136.  
#> 3 cli_vec     12.64µs  13.72µs    71496.      448B     7.15
#> 4 base_vec     7.26µs   7.79µs   126789.      448B     0   
#> 5 cli_txt     13.35µs  14.37µs    68247.        0B     6.83
#> 6 base_txt     7.98µs   8.24µs   119088.        0B     0
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
#> 1 cli          4.39µs   5.17µs   186224.        0B    37.3 
#> 2 base       812.11ns 892.09ns  1048971.        0B     0   
#> 3 cli_vec     15.86µs  16.93µs    58124.      448B     5.81
#> 4 base_vec    29.95µs  31.25µs    31121.      448B     0   
#> 5 cli_txt     15.39µs  16.41µs    59967.        0B     6.00
#> 6 base_txt    54.43µs  55.93µs    17720.        0B     0
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
#> 1 cli          4.79µs   5.67µs   170644.        0B    17.1 
#> 2 base       550.99ns 601.17ns  1495918.        0B     0   
#> 3 cli_vec      11.4µs  12.52µs    78267.      448B     7.83
#> 4 base_vec     7.22µs   7.87µs   124620.      448B    12.5 
#> 5 cli_txt     12.44µs  13.83µs    71035.        0B     7.10
#> 6 base_txt     8.05µs   8.84µs   112904.        0B     0
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
#> 1 cli          3.67µs   4.43µs   216542.    22.2KB    21.7 
#> 2 base       651.11ns 691.16ns  1204995.        0B   121.  
#> 3 cli_vec        17µs  18.24µs    53854.     1.7KB     5.39
#> 4 base_vec     4.86µs   5.09µs   192026.      848B     0   
#> 5 cli_txt      3.75µs   4.45µs   215641.        0B    21.6 
#> 6 base_txt     2.82µs   3.03µs   319175.        0B     0
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
#>  date     2026-09-24
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   NA
#> 
#> ─ Packages ──────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  bench         1.1.4      2025-01-16 [1] RSPM
#>  bslib         0.12.0     2026-08-04 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  cli         * 3.6.6.9000 2026-09-24 [1] local
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
#>  sessioninfo   1.2.4      2026-06-04 [1] RSPM
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
