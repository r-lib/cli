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
#> 1 __cli_update_due         9.89ns     10ns 85400521.        0B        0
#> 2 fun()                  119.91ns  139.9ns  4832612.        0B        0
#> 3 .Call(ccli_tick_reset)  99.88ns  119.9ns  7967869.        0B        0
#> 4 interactive()            9.89ns   19.9ns 52757212.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.9ns   41ns 21532274.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    120ns  7882417.        0B       0 
#> 2 ta[[1]]       110ns    131ns  6297916.        0B     630.
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
#> 1 f0()         24.4ms   24.5ms      40.9    21.6KB     204.
#> 2 fp()         27.2ms   27.2ms      36.5    82.3KB     170.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 27.8ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     266ms    266ms      3.75        0B     30.0
#> 2 fp(1e+06)     290ms    291ms      3.43    1.88KB     29.2
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 25ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.68s    2.68s     0.373        0B     31.4
#> 2 fp(1e+07)     2.88s    2.88s     0.348    1.88KB     29.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 19.7ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.7s    25.7s    0.0390        0B     18.9
#> 2 fp(1e+08)     27.7s    27.7s    0.0361    1.88KB     17.4
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 20.1ns
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
#> 1 f0()         87.1ms     91ms     10.5      781KB    13.9 
#> 2 f01()       116.5ms    135ms      7.19     781KB     8.99
#> 3 fp()        139.5ms    144ms      6.08     783KB    10.6
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 528ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  975.11ms 975.11ms     1.03     7.63MB     7.18
#> 2 f01(1e+06)    1.48s    1.48s     0.675    7.63MB     4.72
#> 3 fp(1e+06)     2.16s    2.16s     0.463    7.63MB     2.31
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.19µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 679ns
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
#> 1 f0()         76.5ms   76.6ms     12.9     1.41MB     5.17
#> 2 f01()        92.6ms   93.2ms     10.7    781.3KB     7.14
#> 3 fp()         97.5ms  100.4ms      9.85  783.24KB     6.57
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 238ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 71.9ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  947.37ms 947.37ms     1.06     7.63MB     2.11
#> 2 f01(1e+06)    1.24s    1.24s     0.804    7.63MB     3.22
#> 3 fp(1e+06)     1.71s    1.71s     0.585    7.63MB     2.34
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 763ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 467ns
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
#> 1 f0()        23.96ms  24.11ms    40.9      39.3KB     1.95
#> 2 fp()          3.86s    3.86s     0.259   100.4KB     2.59
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 38.4µs
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
#> 1 f0()           23ms  23.16ms    42.0      18.7KB     3.82
#> 2 ff()        31.51ms  31.66ms    30.8      27.6KB     3.85
#> 3 fp()          2.14s    2.14s     0.468    25.1KB     2.81
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 21.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 85ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   236.2ms  236.4ms    4.20          0B     4.20
#> 2 ff(1e+06)   316.9ms  352.1ms    2.84       1.9KB     2.84
#> 3 fp(1e+06)     21.8s    21.8s    0.0458     1.9KB     2.56
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.6µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 116ns
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
#> 1 test_baseline()   704.68ms 704.68ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.709    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.983    23.9KB        0
#> 4 test_cli_unroll() 705.94ms 705.94ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA:  4m
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 30m
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
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.94ms 6.12ms      159.     1.4MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (453/s) | 3ms
#> ⠹ 2 done (65/s) | 32ms
#> ⠸ 3 done (76/s) | 40ms
#> ⠼ 4 done (85/s) | 48ms
#> ⠴ 5 done (92/s) | 55ms
#> ⠦ 6 done (97/s) | 63ms
#> ⠧ 7 done (101/s) | 70ms
#> ⠇ 8 done (105/s) | 77ms
#> ⠏ 9 done (107/s) | 84ms
#> ⠋ 10 done (110/s) | 92ms
#> ⠙ 11 done (112/s) | 99ms
#> ⠹ 12 done (114/s) | 106ms
#> ⠸ 13 done (115/s) | 113ms
#> ⠼ 14 done (117/s) | 120ms
#> ⠴ 15 done (118/s) | 128ms
#> ⠦ 16 done (119/s) | 135ms
#> ⠧ 17 done (120/s) | 142ms
#> ⠇ 18 done (121/s) | 149ms
#> ⠏ 19 done (122/s) | 156ms
#> ⠋ 20 done (123/s) | 163ms
#> ⠙ 21 done (123/s) | 171ms
#> ⠹ 22 done (124/s) | 178ms
#> ⠸ 23 done (125/s) | 185ms
#> ⠼ 24 done (125/s) | 192ms
#> ⠴ 25 done (126/s) | 199ms
#> ⠦ 26 done (126/s) | 206ms
#> ⠧ 27 done (127/s) | 214ms
#> ⠇ 28 done (127/s) | 221ms
#> ⠏ 29 done (128/s) | 228ms
#> ⠋ 30 done (128/s) | 235ms
#> ⠙ 31 done (128/s) | 242ms
#> ⠹ 32 done (129/s) | 249ms
#> ⠸ 33 done (129/s) | 256ms
#> ⠼ 34 done (130/s) | 263ms
#> ⠴ 35 done (130/s) | 270ms
#> ⠦ 36 done (130/s) | 277ms
#> ⠧ 37 done (130/s) | 284ms
#> ⠇ 38 done (131/s) | 291ms
#> ⠏ 39 done (131/s) | 298ms
#> ⠋ 40 done (131/s) | 306ms
#> ⠙ 41 done (131/s) | 313ms
#> ⠹ 42 done (132/s) | 320ms
#> ⠸ 43 done (132/s) | 327ms
#> ⠼ 44 done (132/s) | 334ms
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
#> ⠦ 56 done (134/s) | 420ms
#> ⠧ 57 done (134/s) | 427ms
#> ⠇ 58 done (134/s) | 434ms
#> ⠏ 59 done (133/s) | 445ms
#> ⠋ 60 done (133/s) | 453ms
#> ⠙ 61 done (132/s) | 461ms
#> ⠹ 62 done (132/s) | 469ms
#> ⠸ 63 done (132/s) | 477ms
#> ⠼ 64 done (132/s) | 485ms
#> ⠴ 65 done (132/s) | 493ms
#> ⠦ 66 done (132/s) | 500ms
#> ⠧ 67 done (132/s) | 507ms
#> ⠇ 68 done (132/s) | 515ms
#> ⠏ 69 done (132/s) | 522ms
#> ⠋ 70 done (132/s) | 529ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.96ms 7.14ms      138.     265KB     2.03
cli_progress_done()
```
