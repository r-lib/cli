# cli progress bar benchmark

## Introduction

We make sure that the timer is not `TRUE`, by setting it to ten hours.

``` r
library(cli)
# 10 hours
cli:::cli_tick_set(10 * 60 * 60 * 1000)
cli_tick_reset()
#> NULL
`__cli_update_due`
#> [1] FALSE
```

## R benchmarks

### The timer

``` r
fun <- function() NULL
ben_st <- bench::mark(
  `__cli_update_due`,
  fun(),
  .Call(ccli_tick_reset),
  interactive(),
  check = FALSE
)
ben_st
#> # A tibble: 4 × 6
#>   expression                  min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>             <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 __cli_update_due        10.01ns   10.1ns 86116100.        0B        0
#> 2 fun()                  119.91ns  139.9ns  4902894.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  120.1ns  7929772.        0B        0
#> 4 interactive()            9.89ns   19.9ns 54916360.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 22757416.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       90ns    111ns  7994822.        0B       0 
#> 2 ta[[1]]       110ns    130ns  6447646.        0B     645.
```

#### `for` loop

This is the baseline:

``` r
f0 <- function(n = 1e5) {
  x <- 0
  seq <- 1:n
  for (i in seq) {
    x <- x + i %% 2
  }
  x
}
```

With progress bars:

``` r
fp <- function(n = 1e5) {
  x <- 0
  seq <- 1:n
  for (i in cli_progress_along(seq)) {
    x <- x + seq[[i]] %% 2
  }
  x
}
```

Overhead per iteration:

``` r
ben_taf <- bench::mark(f0(), fp())
ben_taf
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()         24.2ms   24.4ms      41.1    21.6KB     205.
#> 2 fp()           27ms   27.2ms      36.5    82.3KB     170.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28.6ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     268ms    269ms      3.72        0B     29.8
#> 2 fp(1e+06)     291ms    292ms      3.42    1.88KB     29.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 23.3ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.71s    2.71s     0.369        0B     31.0
#> 2 fp(1e+07)     2.88s    2.88s     0.347    1.88KB     29.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 16.8ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)       26s      26s    0.0385        0B     18.7
#> 2 fp(1e+08)     27.9s    27.9s    0.0359    1.88KB     17.3
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.9ns
```

#### Mapping with `lapply()`

This is the baseline:

``` r
f0 <- function(n = 1e5) {
  seq <- 1:n
  ret <- lapply(seq, function(x) {
    x %% 2
  })
  invisible(ret)
}
```

With an index vector:

``` r
f01 <- function(n = 1e5) {
  seq <- 1:n
  ret <- lapply(seq_along(seq), function(i) {
    seq[[i]] %% 2
  })
  invisible(ret)
}
```

With progress bars:

``` r
fp <- function(n = 1e5) {
  seq <- 1:n
  ret <- lapply(cli_progress_along(seq), function(i) {
    seq[[i]] %% 2
  })
  invisible(ret)
}
```

Overhead per iteration:

``` r
ben_tam <- bench::mark(f0(), f01(), fp())
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()         89.9ms   92.8ms     10.4      781KB    13.8 
#> 2 f01()       119.5ms  138.6ms      7.11     781KB     8.88
#> 3 fp()        143.3ms  152.2ms      5.93     783KB    10.4
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 594ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  978.05ms 978.05ms     1.02     7.63MB     7.16
#> 2 f01(1e+06)    1.57s    1.57s     0.637    7.63MB     5.10
#> 3 fp(1e+06)     2.22s    2.22s     0.450    7.63MB     1.80
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.24µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 650ns
```

#### Mapping with purrr

This is the baseline:

``` r
f0 <- function(n = 1e5) {
  seq <- 1:n
  ret <- purrr::map(seq, function(x) {
    x %% 2
  })
  invisible(ret)
}
```

With index vector:

``` r
f01 <- function(n = 1e5) {
  seq <- 1:n
  ret <- purrr::map(seq_along(seq), function(i) {
    seq[[i]] %% 2
  })
  invisible(ret)
}
```

With progress bars:

``` r
fp <- function(n = 1e5) {
  seq <- 1:n
  ret <- purrr::map(cli_progress_along(seq), function(i) {
    seq[[i]] %% 2
  })
  invisible(ret)
}
```

Overhead per iteration:

``` r
ben_pur <- bench::mark(f0(), f01(), fp())
ben_pur
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()         76.9ms     77ms     12.8     1.41MB     6.40
#> 2 f01()          92ms     94ms     10.6    781.3KB     5.31
#> 3 fp()         98.7ms   99.3ms      9.98  783.24KB     6.65
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 222ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 52.8ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  958.47ms 958.47ms     1.04     7.63MB     3.13
#> 2 f01(1e+06)    1.46s    1.46s     0.685    7.63MB     2.06
#> 3 fp(1e+06)      1.4s     1.4s     0.715    7.63MB     2.86
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 441ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 1ns
```

### `ticking()`

``` r
f0 <- function(n = 1e5) {
  i <- 0
  x <- 0 
  while (i < n) {
    x <- x + i %% 2
    i <- i + 1
  }
  x
}
```

``` r
fp <- function(n = 1e5) {
  i <- 0
  x <- 0 
  while (ticking(i < n)) {
    x <- x + i %% 2
    i <- i + 1
  }
  x
}
```

``` r
ben_tk <- bench::mark(f0(), fp())
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tk
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()        23.94ms  24.14ms    37.9      39.3KB     1.99
#> 2 fp()          4.03s    4.03s     0.248   100.4KB     2.73
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 40µs
```

### Traditional API

``` r
f0 <- function(n = 1e5) {
  x <- 0
  for (i in 1:n) {
    x <- x + i %% 2
  }
  x
}
```

``` r
fp <- function(n = 1e5) {
  cli_progress_bar(total = n)
  x <- 0
  for (i in 1:n) {
    x <- x + i %% 2
    cli_progress_update()
  }
  x
}
```

``` r
ff <- function(n = 1e5) {
  cli_progress_bar(total = n)
  x <- 0
  for (i in 1:n) {
    x <- x + i %% 2
    if (`__cli_update_due`) cli_progress_update()
  }
  x
}
```

``` r
ben_api <- bench::mark(f0(), ff(), fp())
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()        23.07ms  23.28ms    38.7      18.7KB     3.87
#> 2 ff()        31.83ms  32.18ms    28.8      27.6KB     1.92
#> 3 fp()          3.63s    3.63s     0.276    25.1KB     1.65
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 36µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 89ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   238.6ms  258.1ms    3.96          0B     3.96
#> 2 ff(1e+06)   341.5ms  341.9ms    2.93       1.9KB     2.93
#> 3 fp(1e+06)     23.8s    23.8s    0.0420     1.9KB     2.48
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 83.8ns
```

## C benchmarks

Baseline function:

``` c
SEXP test_baseline() {
  int i;
  int res = 0;
  for (i = 0; i < 2000000000; i++) {
    res += i % 2;
  }
  return ScalarInteger(res);
}
```

Switch + modulo check:

``` c
SEXP test_modulo(SEXP progress) {
  int i;
  int res = 0;
  int progress_ = LOGICAL(progress)[0];
  for (i = 0; i < 2000000000; i++) {
    if (i % 10000 == 0 && progress_) cli_progress_set(R_NilValue, i);
    res += i % 2;
  }
  return ScalarInteger(res);
}
```

cli progress bar API:

``` c
SEXP test_cli() {
  int i;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  for (i = 0; i < 2000000000; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}
```

``` c
SEXP test_cli_unroll() {
  int i = 0;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  int s, final, step = 2000000000 / 100000;
  for (s = 0; s < 100000; s++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
    final = (s + 1) * step;
    for (i = s * step; i < final; i++) {
      res += i % 2;
    }
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}
```

``` r
library(progresstest)
ben_c <- bench::mark(
  test_baseline(),
  test_modulo(),
  test_cli(),
  test_cli_unroll()
)
ben_c
#> # A tibble: 4 × 6
#>   expression             min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>        <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 test_baseline()   702.85ms 702.85ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984    23.9KB        0
#> 4 test_cli_unroll() 704.34ms 704.34ms     1.42     3.56KB        0
(ben_c$median[3] - ben_c$median[1]) / 2000000000
#> [1] 1ns
```

## Display update

We only update the display a fixed number of times per second.
(Currently maximum five times per second.)

Let’s measure how long a single update takes.

### Iterator with a bar

``` r
cli_progress_bar(total = 100000)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ■                                  0% | ETA:  5m
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.01ms 6.15ms      157.     1.4MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (482/s) | 3ms
#> ⠹ 2 done (71/s) | 29ms
#> ⠸ 3 done (84/s) | 36ms
#> ⠼ 4 done (93/s) | 44ms
#> ⠴ 5 done (100/s) | 51ms
#> ⠦ 6 done (104/s) | 58ms
#> ⠧ 7 done (108/s) | 65ms
#> ⠇ 8 done (111/s) | 72ms
#> ⠏ 9 done (114/s) | 79ms
#> ⠋ 10 done (116/s) | 87ms
#> ⠙ 11 done (118/s) | 94ms
#> ⠹ 12 done (119/s) | 101ms
#> ⠸ 13 done (121/s) | 108ms
#> ⠼ 14 done (122/s) | 115ms
#> ⠴ 15 done (123/s) | 122ms
#> ⠦ 16 done (124/s) | 130ms
#> ⠧ 17 done (125/s) | 137ms
#> ⠇ 18 done (126/s) | 144ms
#> ⠏ 19 done (126/s) | 151ms
#> ⠋ 20 done (127/s) | 158ms
#> ⠙ 21 done (128/s) | 165ms
#> ⠹ 22 done (128/s) | 172ms
#> ⠸ 23 done (129/s) | 179ms
#> ⠼ 24 done (129/s) | 186ms
#> ⠴ 25 done (130/s) | 194ms
#> ⠦ 26 done (130/s) | 201ms
#> ⠧ 27 done (130/s) | 208ms
#> ⠇ 28 done (131/s) | 215ms
#> ⠏ 29 done (131/s) | 222ms
#> ⠋ 30 done (131/s) | 229ms
#> ⠙ 31 done (131/s) | 236ms
#> ⠹ 32 done (129/s) | 248ms
#> ⠸ 33 done (130/s) | 255ms
#> ⠼ 34 done (130/s) | 262ms
#> ⠴ 35 done (130/s) | 269ms
#> ⠦ 36 done (130/s) | 277ms
#> ⠧ 37 done (131/s) | 284ms
#> ⠇ 38 done (131/s) | 291ms
#> ⠏ 39 done (131/s) | 298ms
#> ⠋ 40 done (131/s) | 306ms
#> ⠙ 41 done (131/s) | 313ms
#> ⠹ 42 done (131/s) | 320ms
#> ⠸ 43 done (132/s) | 328ms
#> ⠼ 44 done (132/s) | 335ms
#> ⠴ 45 done (132/s) | 342ms
#> ⠦ 46 done (132/s) | 349ms
#> ⠧ 47 done (132/s) | 356ms
#> ⠇ 48 done (132/s) | 363ms
#> ⠏ 49 done (132/s) | 371ms
#> ⠋ 50 done (133/s) | 378ms
#> ⠙ 51 done (133/s) | 385ms
#> ⠹ 52 done (133/s) | 392ms
#> ⠸ 53 done (133/s) | 399ms
#> ⠼ 54 done (133/s) | 406ms
#> ⠴ 55 done (133/s) | 413ms
#> ⠦ 56 done (133/s) | 420ms
#> ⠧ 57 done (134/s) | 428ms
#> ⠇ 58 done (134/s) | 435ms
#> ⠏ 59 done (134/s) | 442ms
#> ⠋ 60 done (134/s) | 449ms
#> ⠙ 61 done (134/s) | 456ms
#> ⠹ 62 done (134/s) | 464ms
#> ⠸ 63 done (134/s) | 471ms
#> ⠼ 64 done (134/s) | 478ms
#> ⠴ 65 done (134/s) | 485ms
#> ⠦ 66 done (134/s) | 492ms
#> ⠧ 67 done (134/s) | 499ms
#> ⠇ 68 done (134/s) | 506ms
#> ⠏ 69 done (134/s) | 514ms
#> ⠋ 70 done (135/s) | 521ms
#> ⠙ 71 done (135/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.03ms 7.14ms      140.     265KB     2.02
cli_progress_done()
```
