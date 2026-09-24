# ANSI function benchmarks

\$output function (x, options) { if (class == “output” && output_asis(x,
options)) return(x) hook.t(x, options\[\[paste0(“attr.”, class)\]\],
options\[\[paste0(“class.”, class)\]\]) } \<bytecode: 0x558434692c88\>
\<environment: 0x558435129328\>

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
#> 1 ansi           29µs  33.37µs    29416.    99.6KB     29.4
#> 2 plain       29.57µs  33.42µs    29250.        0B     32.2
#> 3 base         8.44µs   9.76µs    99706.    48.6KB     19.9
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
#> 1 ansi        31.16µs   35.5µs    27570.        0B     33.1
#> 2 plain       30.76µs   35.3µs    27650.        0B     33.2
#> 3 base         9.79µs   11.4µs    84850.        0B     34.0
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
#> 1 ansi        77.33µs  85.36µs    11449.   77.03KB     23.4
#> 2 plain       59.46µs   66.2µs    14751.    8.91KB     21.2
#> 3 base         1.44µs   1.63µs   576856.        0B     57.7
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
#> 1 ansi          220µs    241µs     4108.   33.24KB     30.2
#> 2 plain         206µs    235µs     4188.    1.09KB     22.5
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
#>  1 cli_ansi          4.27µs   4.78µs   198442.    9.27KB     19.8
#>  2 fansi_ansi       20.84µs  23.23µs    41918.    4.18KB     16.8
#>  3 cli_plain         4.24µs   4.79µs   201862.        0B     20.2
#>  4 fansi_plain         21µs  23.28µs    42062.      688B     16.8
#>  5 cli_vec_ansi      5.43µs      6µs   161673.      448B     16.2
#>  6 fansi_vec_ansi    27.9µs  30.77µs    31693.    5.02KB     15.9
#>  7 cli_vec_plain      5.9µs   6.47µs   150609.      448B      0  
#>  8 fansi_vec_plain  27.47µs  30.25µs    32384.    5.02KB     16.2
#>  9 cli_txt_ansi      4.26µs   4.81µs   199843.        0B     20.0
#> 10 fansi_txt_ansi   21.13µs  23.48µs    41681.      688B     16.7
#> 11 cli_txt_plain     4.95µs   5.47µs   177362.        0B     17.7
#> 12 fansi_txt_plain  27.29µs  30.18µs    32275.    5.02KB     12.9
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
#> 1 cli          44.1µs   46.2µs    21333.    22.7KB     6.40
#> 2 fansi        86.1µs   90.9µs    10804.    55.3KB     6.08
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
#>  1 cli_ansi          5.11µs   5.79µs   166181.        0B    16.6 
#>  2 fansi_ansi       55.77µs  61.59µs    15898.   38.84KB    12.4 
#>  3 base_ansi       701.05ns 781.03ns  1132387.        0B   113.  
#>  4 cli_plain         5.01µs   5.74µs   167721.        0B    16.8 
#>  5 fansi_plain      56.27µs  61.53µs    15928.      688B    12.4 
#>  6 base_plain      631.09ns 701.17ns  1249459.        0B     0   
#>  7 cli_vec_ansi     22.54µs  23.64µs    41626.      448B     4.16
#>  8 fansi_vec_ansi   73.17µs  79.08µs    12385.    5.02KB    10.4 
#>  9 base_vec_ansi    15.79µs  15.95µs    61636.      448B     6.16
#> 10 cli_vec_plain    20.99µs  22.13µs    44702.      448B     4.47
#> 11 fansi_vec_plain     65µs  70.94µs    13809.    5.02KB    10.4 
#> 12 base_vec_plain    9.11µs    9.2µs   106860.      448B     0   
#> 13 cli_txt_ansi     22.53µs  23.52µs    41760.        0B     4.18
#> 14 fansi_txt_ansi   66.54µs  72.08µs    13613.      688B    12.4 
#> 15 base_txt_ansi    15.82µs  15.93µs    61823.        0B     0   
#> 16 cli_txt_plain    20.68µs  21.52µs    45682.        0B     4.57
#> 17 fansi_txt_plain  58.46µs  63.95µs    15334.      688B    14.6 
#> 18 base_txt_plain    9.13µs   9.21µs   106677.        0B     0
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
#>  1 cli_ansi          6.22µs   7.13µs   136166.        0B    13.6 
#>  2 fansi_ansi        56.7µs  61.83µs    15822.      688B    14.6 
#>  3 base_ansi       942.03ns   1.02µs   896493.        0B     0   
#>  4 cli_plain         6.13µs   6.97µs   138874.        0B    13.9 
#>  5 fansi_plain      56.61µs  61.66µs    15860.      688B    14.6 
#>  6 base_plain      771.13ns 852.16ns  1035745.        0B     0   
#>  7 cli_vec_ansi     26.19µs  27.35µs    36021.      448B     3.60
#>  8 fansi_vec_ansi      75µs   81.2µs    12072.    5.02KB    10.5 
#>  9 base_vec_ansi    35.43µs     36µs    27499.      448B     0   
#> 10 cli_vec_plain    24.99µs  26.02µs    37749.      448B     7.55
#> 11 fansi_vec_plain  67.19µs  73.02µs    13417.    5.02KB    10.4 
#> 12 base_vec_plain   18.27µs   18.5µs    53221.      448B     0   
#> 13 cli_txt_ansi     26.76µs  27.73µs    35334.        0B     7.07
#> 14 fansi_txt_ansi   68.59µs  74.64µs    13147.      688B    10.3 
#> 15 base_txt_ansi    36.46µs  37.38µs    26456.        0B     0   
#> 16 cli_txt_plain    24.82µs  25.84µs    38050.        0B     7.61
#> 17 fansi_txt_plain  60.09µs  65.67µs    14956.      688B    12.4 
#> 18 base_txt_plain   19.46µs  19.67µs    50272.        0B     0
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
#> 1 cli_ansi        4.95µs   5.42µs   180377.        0B    18.0 
#> 2 cli_plain       4.67µs   5.18µs   187712.        0B    18.8 
#> 3 cli_vec_ansi    24.1µs  24.95µs    39578.      848B     3.96
#> 4 cli_vec_plain   7.87µs   8.49µs   115186.      848B    11.5 
#> 5 cli_txt_ansi   23.39µs   24.5µs    40304.        0B     4.03
#> 6 cli_txt_plain   5.47µs   5.94µs   164993.        0B    16.5
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
#>  1 cli_ansi          18.5µs   19.8µs    49398.        0B    19.8 
#>  2 fansi_ansi        19.4µs   20.9µs    46601.    7.24KB    18.6 
#>  3 cli_plain         18.6µs   19.9µs    49152.        0B    19.7 
#>  4 fansi_plain       19.2µs   21.2µs    45857.      688B    18.4 
#>  5 cli_vec_ansi      26.2µs   28.4µs    34532.      848B    17.3 
#>  6 fansi_vec_ansi    40.3µs   42.8µs    22917.    5.41KB     9.17
#>  7 cli_vec_plain     20.9µs   22.8µs    42816.      848B    17.1 
#>  8 fansi_vec_plain   26.6µs   29.3µs    33425.    4.59KB    13.4 
#>  9 cli_txt_ansi      25.8µs   27.8µs    35223.        0B    14.1 
#> 10 fansi_txt_ansi    32.7µs   35.1µs    27942.    5.12KB    11.2 
#> 11 cli_txt_plain     19.5µs   21.3µs    45781.        0B    22.9 
#> 12 fansi_txt_plain   20.2µs   22.4µs    43396.      688B    17.4
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
#>  1 cli_ansi        101.31µs 112.46µs     7917.  104.86KB    14.7 
#>  2 fansi_ansi       83.77µs   92.4µs    10671.  106.35KB    14.7 
#>  3 base_ansi         3.08µs   3.37µs   288817.      224B     0   
#>  4 cli_plain       101.91µs 110.35µs     8442.    8.09KB    16.7 
#>  5 fansi_plain      82.79µs  92.16µs     9476.    9.62KB    12.5 
#>  6 base_plain        2.67µs   2.91µs   332128.        0B     0   
#>  7 cli_vec_ansi      5.08ms   5.32ms      188.  823.77KB    18.3 
#>  8 fansi_vec_ansi  789.46µs 831.73µs     1092.  846.81KB    25.0 
#>  9 base_vec_ansi   120.88µs 125.65µs     7842.    22.7KB     4.16
#> 10 cli_vec_plain     5.09ms   5.27ms      188.  823.77KB    18.4 
#> 11 fansi_vec_plain 742.72µs 790.59µs     1228.  845.98KB    26.4 
#> 12 base_vec_plain   82.06µs  86.23µs    11247.      848B     2.01
#> 13 cli_txt_ansi       2.5ms   2.53ms      393.    63.6KB     2.02
#> 14 fansi_txt_ansi    1.25ms   1.26ms      788.   35.05KB     0   
#> 15 base_txt_ansi   109.89µs 118.47µs     8402.   18.47KB     4.09
#> 16 cli_txt_plain     1.86ms   1.89ms      527.    63.6KB     0   
#> 17 fansi_txt_plain  409.9µs 436.69µs     2279.    30.6KB     4.08
#> 18 base_txt_plain   70.25µs  72.63µs    13466.   11.05KB     2.02
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
#>  1 cli_ansi          97.1µs  103.1µs     9480.   33.84KB    18.9 
#>  2 fansi_ansi        37.3µs     41µs    23799.   31.42KB    16.7 
#>  3 base_ansi          791ns  872.1ns  1058645.     4.2KB     0   
#>  4 cli_plain           99µs  106.4µs     9248.        0B    18.9 
#>  5 fansi_plain         37µs   41.7µs    23607.      872B    16.5 
#>  6 base_plain       760.9ns    841ns  1111126.        0B     0   
#>  7 cli_vec_ansi     196.2µs  205.1µs     4819.   16.73KB     8.26
#>  8 fansi_vec_ansi      88µs   92.8µs    10620.    5.59KB    10.4 
#>  9 base_vec_ansi     29.7µs   30.1µs    32891.      848B     0   
#> 10 cli_vec_plain    164.1µs  173.5µs     5703.   16.73KB    10.4 
#> 11 fansi_vec_plain   81.5µs   86.3µs    11445.    5.59KB     8.28
#> 12 base_vec_plain    24.9µs   25.3µs    39084.      848B     3.91
#> 13 cli_txt_ansi     104.8µs  114.1µs     8641.        0B    16.9 
#> 14 fansi_txt_ansi    37.5µs   41.4µs    23740.      872B    16.6 
#> 15 base_txt_ansi      841ns  921.1ns  1027625.        0B     0   
#> 16 cli_txt_plain     99.2µs  106.6µs     9257.        0B    18.9 
#> 17 fansi_txt_plain   37.6µs     42µs    23457.      872B    16.4 
#> 18 base_txt_plain   772.1ns  851.6ns  1114746.        0B     0
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
#>  1 cli_ansi        277.31µs  301.2µs    3287.     6.18KB    16.8 
#>  2 fansi_ansi       66.56µs  74.56µs   13155.    97.33KB    14.9 
#>  3 base_ansi        25.25µs   27.4µs   35344.         0B    17.7 
#>  4 cli_plain       176.79µs 187.98µs    5206.         0B    14.6 
#>  5 fansi_plain      67.64µs  75.06µs   13057.       872B    17.4 
#>  6 base_plain          20µs   21.3µs   45958.         0B    13.8 
#>  7 cli_vec_ansi     28.92ms   29.1ms      34.3   94.67KB    30.5 
#>  8 fansi_vec_ansi  184.22µs 190.78µs    5174.     7.25KB     8.23
#>  9 base_vec_ansi     1.68ms   1.74ms     569.    48.18KB    17.4 
#> 10 cli_vec_plain    18.19ms   18.7ms      53.6    2.48KB    23.8 
#> 11 fansi_vec_plain 148.02µs 156.82µs    6299.     6.42KB     8.24
#> 12 base_vec_plain    1.24ms   1.29ms     768.     47.4KB    14.9 
#> 13 cli_txt_ansi     22.02ms   22.3ms      44.9    4.27MB     9.97
#> 14 fansi_txt_ansi  175.52µs 184.45µs    5326.     6.77KB     6.11
#> 15 base_txt_ansi     1.01ms   1.06ms     934.   582.06KB    11.2 
#> 16 cli_txt_plain        1ms   1.04ms     948.   369.84KB    11.2 
#> 17 fansi_txt_plain 135.01µs 144.16µs    6747.     2.51KB     8.40
#> 18 base_txt_plain  679.54µs 719.57µs    1368.   367.31KB    13.6
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
#>  1 cli_ansi             5µs   5.77µs   164307.   25.09KB    16.4 
#>  2 fansi_ansi       55.44µs  61.12µs    16003.   28.48KB    16.9 
#>  3 base_ansi       801.05ns 892.09ns  1020587.        0B     0   
#>  4 cli_plain         4.88µs   5.72µs   168768.        0B    16.9 
#>  5 fansi_plain      55.84µs  61.28µs    15928.    1.98KB    14.7 
#>  6 base_plain      771.02ns    851ns  1041194.        0B     0   
#>  7 cli_vec_ansi     20.56µs   21.7µs    45081.     1.7KB     4.51
#>  8 fansi_vec_ansi   84.69µs  90.57µs     9709.    8.86KB    10.6 
#>  9 base_vec_ansi     5.06µs   5.36µs   178479.      848B     0   
#> 10 cli_vec_plain    18.01µs   19.2µs    51065.     1.7KB     5.11
#> 11 fansi_vec_plain   80.4µs  86.08µs    11343.    8.86KB    10.6 
#> 12 base_vec_plain    4.84µs   5.42µs   182733.      848B     0   
#> 13 cli_txt_ansi      4.94µs   5.74µs   164695.        0B    32.9 
#> 14 fansi_txt_ansi   55.32µs  61.05µs    15985.    1.98KB    14.9 
#> 15 base_txt_ansi     5.49µs   5.59µs   174776.        0B     0   
#> 16 cli_txt_plain     5.68µs   6.45µs   149506.        0B    15.0 
#> 17 fansi_txt_plain  55.36µs  60.87µs    16052.    1.98KB    14.7 
#> 18 base_txt_plain    3.42µs   3.54µs   267068.        0B    26.7
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
#>  1 cli_ansi        73.39µs   78.8µs   12358.     12.1KB    12.4 
#>  2 base_ansi      992.09ns   1.05µs  891426.         0B     0   
#>  3 cli_plain       56.48µs  60.94µs   16005.     8.91KB    12.4 
#>  4 base_plain     751.11ns 811.18ns 1173381.         0B     0   
#>  5 cli_vec_ansi     3.24ms   3.31ms     297.   838.95KB    17.7 
#>  6 base_vec_ansi   58.58µs   59.9µs   16592.       848B     0   
#>  7 cli_vec_plain    1.81ms   1.87ms     529.   817.08KB    19.5 
#>  8 base_vec_plain  35.89µs  36.71µs   27042.       848B     0   
#>  9 cli_txt_ansi    12.38ms  12.52ms      79.6   114.6KB     2.04
#> 10 base_txt_ansi   55.41µs  58.63µs   16876.         0B     2.01
#> 11 cli_txt_plain  227.59µs 237.77µs    4140.    18.34KB     2.04
#> 12 base_txt_plain  33.29µs  33.68µs   29379.         0B     0
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
#>  1 cli_ansi         71.4µs   76.6µs    12757.        0B    18.9 
#>  2 base_ansi          12µs   13.4µs    72546.        0B    14.5 
#>  3 cli_plain        71.1µs   76.6µs    12730.        0B    16.7 
#>  4 base_plain         12µs   13.2µs    73381.        0B    14.7 
#>  5 cli_vec_ansi    153.8µs  162.7µs     6054.     7.2KB     8.24
#>  6 base_vec_ansi    44.9µs     51µs    19287.    1.66KB     4.06
#>  7 cli_vec_plain   142.2µs  151.9µs     6477.     7.2KB    10.4 
#>  8 base_vec_plain   39.5µs   45.1µs    21799.    1.66KB     4.36
#>  9 cli_txt_ansi    135.5µs  142.1µs     6925.        0B     8.17
#> 10 base_txt_ansi    32.6µs     34µs    28870.        0B     5.78
#> 11 cli_txt_plain   122.5µs  129.5µs     7595.        0B    10.4 
#> 12 base_txt_plain   26.9µs   28.4µs    34442.        0B     6.89
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
#> 1 cli          6.04µs   6.84µs   140953.        0B    14.1 
#> 2 base       661.12ns  741.1ns  1211217.        0B     0   
#> 3 cli_vec     18.12µs  19.09µs    51447.      448B     5.15
#> 4 base_vec     9.38µs   9.66µs   101660.      448B     0   
#> 5 cli_txt     17.88µs  18.75µs    52378.        0B     5.24
#> 6 base_txt    10.19µs   10.4µs    94529.        0B     9.45
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
#> 1 cli          5.97µs   6.77µs   142815.        0B    14.3 
#> 2 base         1.02µs    1.1µs   845912.        0B     0   
#> 3 cli_vec     23.18µs  24.41µs    40311.      448B     4.03
#> 4 base_vec     41.5µs  42.26µs    23415.      448B     0   
#> 5 cli_txt     23.01µs  24.14µs    40661.        0B     8.13
#> 6 base_txt    74.23µs  75.13µs    13173.        0B     0
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
#> 1 cli          6.49µs    7.4µs   131011.        0B    13.1 
#> 2 base       661.01ns  741.1ns  1182660.        0B     0   
#> 3 cli_vec     15.38µs  16.46µs    59346.      448B    11.9 
#> 4 base_vec     9.38µs   9.69µs   101852.      448B     0   
#> 5 cli_txt     15.97µs  16.95µs    57813.        0B     5.78
#> 6 base_txt    10.17µs  10.33µs    94870.        0B     0
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
#> 1 cli          4.74µs   5.46µs   174987.    22.2KB    35.0 
#> 2 base       791.16ns 921.08ns  1006989.        0B     0   
#> 3 cli_vec     22.84µs  24.13µs    40794.     1.7KB     4.08
#> 4 base_vec     6.41µs   6.66µs   147324.      848B     0   
#> 5 cli_txt      4.73µs   5.53µs   172524.        0B    17.3 
#> 6 base_txt     4.03µs   4.21µs   228268.        0B    22.8
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
