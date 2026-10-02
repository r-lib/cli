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
#> 1 __cli_update_due              0   10.1ns 98463064.        0B        0
#> 2 fun()                    80.1ns  100.6ns  6262905.        0B        0
#> 3 .Call(ccli_tick_reset)     80ns   90.1ns 10200497.        0B        0
#> 4 interactive()              10ns   10.1ns 64939480.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 26788495.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       90ns    110ns  8369241.        0B        0
#> 2 ta[[1]]      90.1ns    120ns  7555433.        0B        0
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
#> 1 f0()         18.5ms   18.5ms      53.6    21.6KB     357.
#> 2 fp()         20.5ms   21.1ms      47.3    82.5KB     473.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 26.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     207ms    208ms      4.79        0B     43.1
#> 2 fp(1e+06)     213ms    254ms      3.94     1.9KB     23.6
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 45.5ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.08s    2.08s     0.482        0B     23.1
#> 2 fp(1e+07)     2.12s    2.12s     0.471     1.9KB     22.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 4.76ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     20.3s    20.3s    0.0492        0B     25.8
#> 2 fp(1e+08)     21.7s    21.7s    0.0460     1.9KB     23.9
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 13.9ns
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
#> 1 f0()         73.6ms   81.3ms      9.06     781KB     19.9
#> 2 f01()        85.2ms   89.1ms     10.2      781KB     10.2
#> 3 fp()         90.3ms  100.6ms      9.70     783KB     13.6
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 193ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  951.05ms 951.05ms     1.05     7.63MB     7.36
#> 2 f01(1e+06)    2.65s    2.65s     0.377    7.63MB     3.02
#> 3 fp(1e+06)  900.29ms 900.29ms     1.11     7.63MB     2.22
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 1ns
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
#> 1 f0()         57.6ms     58ms      17.2    1.44MB     4.92
#> 2 f01()        70.1ms     71ms      13.3   781.3KB     5.31
#> 3 fp()         71.7ms   75.1ms      13.0  783.26KB     5.19
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 171ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 41.4ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  720.94ms 720.94ms     1.39     7.63MB     2.77
#> 2 f01(1e+06) 876.63ms 876.63ms     1.14     7.63MB     2.28
#> 3 fp(1e+06)     1.31s    1.31s     0.765    7.63MB     2.30
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 586ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 430ns
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
#> 1 f0()        19.79ms  23.39ms    40.5      39.3KB     1.93
#> 2 fp()          3.29s    3.29s     0.303   100.8KB     2.73
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 32.7µs
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
#> 1 f0()         18.1ms   33.4ms    28.9      18.7KB     3.85
#> 2 ff()         24.9ms   40.3ms    25.0      27.6KB     1.92
#> 3 fp()           1.9s     1.9s     0.525    25.1KB     2.63
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 18.7µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 69.3ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   177.6ms  179.9ms    5.57          0B     3.72
#> 2 ff(1e+06)   241.2ms  243.7ms    4.11      1.91KB     2.74
#> 3 fp(1e+06)     16.8s    16.8s    0.0595    1.91KB     2.50
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 16.6µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 63.8ns
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
#> 1 test_baseline()   546.47ms 546.47ms     1.83     2.08KB        0
#> 2 test_modulo()        1.09s    1.09s     0.915    2.24KB        0
#> 3 test_cli()        792.41ms 792.41ms     1.26    24.11KB        0
#> 4 test_cli_unroll() 547.23ms 547.23ms     1.83     3.58KB        0
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
#> ■                                  0% | ETA:  3m
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
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
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.58ms 4.73ms      209.    1.42MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (605/s) | 2ms
#> ⠹ 2 done (91/s) | 23ms
#> ⠸ 3 done (108/s) | 28ms
#> ⠼ 4 done (121/s) | 34ms
#> ⠴ 5 done (129/s) | 39ms
#> ⠦ 6 done (136/s) | 45ms
#> ⠧ 7 done (141/s) | 50ms
#> ⠇ 8 done (145/s) | 56ms
#> ⠏ 9 done (148/s) | 61ms
#> ⠋ 10 done (151/s) | 67ms
#> ⠙ 11 done (153/s) | 72ms
#> ⠹ 12 done (155/s) | 78ms
#> ⠸ 13 done (157/s) | 83ms
#> ⠼ 14 done (159/s) | 89ms
#> ⠴ 15 done (160/s) | 94ms
#> ⠦ 16 done (161/s) | 100ms
#> ⠧ 17 done (162/s) | 105ms
#> ⠇ 18 done (163/s) | 111ms
#> ⠏ 19 done (164/s) | 117ms
#> ⠋ 20 done (165/s) | 122ms
#> ⠙ 21 done (165/s) | 128ms
#> ⠹ 22 done (166/s) | 133ms
#> ⠸ 23 done (167/s) | 139ms
#> ⠼ 24 done (167/s) | 144ms
#> ⠴ 25 done (168/s) | 150ms
#> ⠦ 26 done (168/s) | 155ms
#> ⠧ 27 done (168/s) | 161ms
#> ⠇ 28 done (169/s) | 166ms
#> ⠏ 29 done (169/s) | 172ms
#> ⠋ 30 done (170/s) | 177ms
#> ⠙ 31 done (170/s) | 183ms
#> ⠹ 32 done (170/s) | 189ms
#> ⠸ 33 done (171/s) | 194ms
#> ⠼ 34 done (171/s) | 200ms
#> ⠴ 35 done (171/s) | 205ms
#> ⠦ 36 done (171/s) | 211ms
#> ⠧ 37 done (172/s) | 216ms
#> ⠇ 38 done (172/s) | 222ms
#> ⠏ 39 done (172/s) | 228ms
#> ⠋ 40 done (172/s) | 233ms
#> ⠙ 41 done (172/s) | 239ms
#> ⠹ 42 done (172/s) | 245ms
#> ⠸ 43 done (172/s) | 250ms
#> ⠼ 44 done (173/s) | 256ms
#> ⠴ 45 done (173/s) | 261ms
#> ⠦ 46 done (173/s) | 267ms
#> ⠧ 47 done (173/s) | 272ms
#> ⠇ 48 done (173/s) | 278ms
#> ⠏ 49 done (173/s) | 283ms
#> ⠋ 50 done (174/s) | 289ms
#> ⠙ 51 done (174/s) | 294ms
#> ⠹ 52 done (174/s) | 300ms
#> ⠸ 53 done (174/s) | 305ms
#> ⠼ 54 done (174/s) | 311ms
#> ⠴ 55 done (174/s) | 316ms
#> ⠦ 56 done (174/s) | 322ms
#> ⠧ 57 done (174/s) | 328ms
#> ⠇ 58 done (174/s) | 333ms
#> ⠏ 59 done (174/s) | 339ms
#> ⠋ 60 done (175/s) | 344ms
#> ⠙ 61 done (175/s) | 350ms
#> ⠹ 62 done (175/s) | 355ms
#> ⠸ 63 done (175/s) | 361ms
#> ⠼ 64 done (175/s) | 366ms
#> ⠴ 65 done (175/s) | 372ms
#> ⠦ 66 done (175/s) | 377ms
#> ⠧ 67 done (175/s) | 383ms
#> ⠇ 68 done (175/s) | 388ms
#> ⠏ 69 done (175/s) | 394ms
#> ⠋ 70 done (175/s) | 399ms
#> ⠙ 71 done (176/s) | 405ms
#> ⠹ 72 done (176/s) | 411ms
#> ⠸ 73 done (176/s) | 416ms
#> ⠼ 74 done (176/s) | 422ms
#> ⠴ 75 done (176/s) | 428ms
#> ⠦ 76 done (176/s) | 433ms
#> ⠧ 77 done (176/s) | 439ms
#> ⠇ 78 done (176/s) | 444ms
#> ⠏ 79 done (176/s) | 450ms
#> ⠋ 80 done (176/s) | 455ms
#> ⠙ 81 done (176/s) | 461ms
#> ⠹ 82 done (176/s) | 466ms
#> ⠸ 83 done (175/s) | 476ms
#> ⠼ 84 done (175/s) | 481ms
#> ⠴ 85 done (175/s) | 487ms
#> ⠦ 86 done (175/s) | 492ms
#> ⠧ 87 done (175/s) | 498ms
#> ⠇ 88 done (175/s) | 503ms
#> ⠏ 89 done (175/s) | 509ms
#> ⠋ 90 done (175/s) | 514ms
#> ⠙ 91 done (175/s) | 520ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.38ms 5.53ms      181.     266KB     2.03
cli_progress_done()
```
