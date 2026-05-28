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
#> 1 __cli_update_due              0      1ns    2.54e8        0B        0
#> 2 fun()                   79.98ns   90.1ns    8.28e6        0B        0
#> 3 .Call(ccli_tick_reset)  50.06ns   70.1ns    1.42e7        0B        0
#> 4 interactive()            9.89ns   19.9ns    5.55e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 19.9ns   30ns 32896653.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       70ns   80.1ns 11782284.        0B        0
#> 2 ta[[1]]      70.1ns     81ns 10860706.        0B        0
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
#> 1 f0()         13.8ms   13.9ms      72.2    21.6KB     523.
#> 2 fp()         15.1ms   15.3ms      65.6    82.5KB     443.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 14ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     148ms    148ms      5.81        0B     40.7
#> 2 fp(1e+06)     155ms    157ms      6.32    1.88KB     30.0
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 8.3ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     1.57s    1.57s     0.635        0B     30.5
#> 2 fp(1e+07)     1.59s    1.59s     0.630    1.88KB     30.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 1.39ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     15.6s    15.6s    0.0640        0B     35.4
#> 2 fp(1e+08)     16.5s    16.5s    0.0607    1.88KB     31.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 8.55ns
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
#> 1 f0()         51.2ms   58.6ms     16.9      781KB     20.7
#> 2 f01()          82ms   86.3ms     11.0      781KB     18.3
#> 3 fp()         85.5ms   93.7ms      9.79     783KB     13.7
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 352ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  643.23ms 643.23ms     1.55     7.63MB    10.9 
#> 2 f01(1e+06)    1.38s    1.38s     0.726    7.63MB     5.08
#> 3 fp(1e+06)     1.67s    1.67s     0.600    7.63MB     3.00
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.02µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 291ns
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
#> 1 f0()         45.7ms   45.9ms      21.6    1.44MB     8.11
#> 2 f01()        55.1ms   61.6ms      15.7   781.3KB     9.41
#> 3 fp()         61.5ms   66.5ms      15.0  783.24KB    11.2
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 206ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 49.3ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  604.91ms 604.91ms     1.65     7.63MB     4.96
#> 2 f01(1e+06) 773.38ms 773.38ms     1.29     7.63MB     5.17
#> 3 fp(1e+06)     1.12s    1.12s     0.890    7.63MB     3.56
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 518ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 350ns
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
#> 1 f0()        14.74ms  14.85ms    66.2      39.3KB     3.90
#> 2 fp()          2.07s    2.07s     0.483   100.7KB     5.32
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 20.5µs
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
#> 1 f0()        13.87ms  14.21ms    67.2      18.7KB     7.90
#> 2 ff()         18.3ms  18.52ms    52.6      27.6KB     5.84
#> 3 fp()          1.17s    1.17s     0.858    25.1KB     5.15
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 11.5µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 43.1ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     153ms    164ms    5.71          0B     5.71
#> 2 ff(1e+06)     198ms    198ms    5.04       1.9KB     5.04
#> 3 fp(1e+06)       13s      13s    0.0769     1.9KB     4.46
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 12.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 34.6ns
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
#> 1 test_baseline()      462ms    466ms      2.15    2.08KB        0
#> 2 test_modulo()        747ms    747ms      1.34    2.24KB        0
#> 3 test_cli()           490ms    498ms      2.01   24.09KB        0
#> 4 test_cli_unroll()    445ms    445ms      2.25    3.56KB        0
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
#> ■                                  0% | ETA:  2m
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> ■                                  0% | ETA:  6m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.06ms 3.14ms      313.    1.41MB     4.09
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (900/s) | 2ms
#> ⠹ 2 done (135/s) | 15ms
#> ⠸ 3 done (161/s) | 19ms
#> ⠼ 4 done (178/s) | 23ms
#> ⠴ 5 done (191/s) | 27ms
#> ⠦ 6 done (201/s) | 30ms
#> ⠧ 7 done (209/s) | 34ms
#> ⠇ 8 done (216/s) | 38ms
#> ⠏ 9 done (221/s) | 41ms
#> ⠋ 10 done (225/s) | 45ms
#> ⠙ 11 done (229/s) | 49ms
#> ⠹ 12 done (232/s) | 52ms
#> ⠸ 13 done (235/s) | 56ms
#> ⠼ 14 done (238/s) | 59ms
#> ⠴ 15 done (239/s) | 63ms
#> ⠦ 16 done (241/s) | 67ms
#> ⠧ 17 done (243/s) | 71ms
#> ⠇ 18 done (245/s) | 74ms
#> ⠏ 19 done (246/s) | 78ms
#> ⠋ 20 done (247/s) | 81ms
#> ⠙ 21 done (249/s) | 85ms
#> ⠹ 22 done (250/s) | 89ms
#> ⠸ 23 done (251/s) | 92ms
#> ⠼ 24 done (252/s) | 96ms
#> ⠴ 25 done (253/s) | 100ms
#> ⠦ 26 done (253/s) | 103ms
#> ⠧ 27 done (254/s) | 107ms
#> ⠇ 28 done (255/s) | 110ms
#> ⠏ 29 done (256/s) | 114ms
#> ⠋ 30 done (256/s) | 118ms
#> ⠙ 31 done (257/s) | 121ms
#> ⠹ 32 done (257/s) | 125ms
#> ⠸ 33 done (258/s) | 129ms
#> ⠼ 34 done (258/s) | 132ms
#> ⠴ 35 done (259/s) | 136ms
#> ⠦ 36 done (259/s) | 139ms
#> ⠧ 37 done (260/s) | 143ms
#> ⠇ 38 done (260/s) | 147ms
#> ⠏ 39 done (260/s) | 150ms
#> ⠋ 40 done (261/s) | 154ms
#> ⠙ 41 done (261/s) | 158ms
#> ⠹ 42 done (261/s) | 161ms
#> ⠸ 43 done (257/s) | 168ms
#> ⠼ 44 done (257/s) | 172ms
#> ⠴ 45 done (258/s) | 175ms
#> ⠦ 46 done (258/s) | 179ms
#> ⠧ 47 done (259/s) | 182ms
#> ⠇ 48 done (259/s) | 186ms
#> ⠏ 49 done (259/s) | 190ms
#> ⠋ 50 done (259/s) | 193ms
#> ⠙ 51 done (260/s) | 197ms
#> ⠹ 52 done (260/s) | 201ms
#> ⠸ 53 done (260/s) | 204ms
#> ⠼ 54 done (260/s) | 208ms
#> ⠴ 55 done (260/s) | 212ms
#> ⠦ 56 done (261/s) | 215ms
#> ⠧ 57 done (261/s) | 219ms
#> ⠇ 58 done (261/s) | 223ms
#> ⠏ 59 done (261/s) | 227ms
#> ⠋ 60 done (261/s) | 230ms
#> ⠙ 61 done (261/s) | 234ms
#> ⠹ 62 done (261/s) | 238ms
#> ⠸ 63 done (261/s) | 242ms
#> ⠼ 64 done (261/s) | 245ms
#> ⠴ 65 done (261/s) | 249ms
#> ⠦ 66 done (262/s) | 253ms
#> ⠧ 67 done (262/s) | 257ms
#> ⠇ 68 done (262/s) | 260ms
#> ⠏ 69 done (262/s) | 264ms
#> ⠋ 70 done (262/s) | 268ms
#> ⠙ 71 done (262/s) | 271ms
#> ⠹ 72 done (262/s) | 275ms
#> ⠸ 73 done (263/s) | 279ms
#> ⠼ 74 done (263/s) | 282ms
#> ⠴ 75 done (263/s) | 286ms
#> ⠦ 76 done (263/s) | 290ms
#> ⠧ 77 done (263/s) | 293ms
#> ⠇ 78 done (263/s) | 297ms
#> ⠏ 79 done (263/s) | 300ms
#> ⠋ 80 done (264/s) | 304ms
#> ⠙ 81 done (264/s) | 308ms
#> ⠹ 82 done (264/s) | 311ms
#> ⠸ 83 done (264/s) | 315ms
#> ⠼ 84 done (264/s) | 319ms
#> ⠴ 85 done (264/s) | 322ms
#> ⠦ 86 done (264/s) | 326ms
#> ⠧ 87 done (265/s) | 329ms
#> ⠇ 88 done (265/s) | 333ms
#> ⠏ 89 done (265/s) | 337ms
#> ⠋ 90 done (265/s) | 340ms
#> ⠙ 91 done (265/s) | 344ms
#> ⠹ 92 done (265/s) | 348ms
#> ⠸ 93 done (265/s) | 351ms
#> ⠼ 94 done (265/s) | 355ms
#> ⠴ 95 done (265/s) | 358ms
#> ⠦ 96 done (266/s) | 362ms
#> ⠧ 97 done (266/s) | 366ms
#> ⠇ 98 done (266/s) | 369ms
#> ⠏ 99 done (266/s) | 373ms
#> ⠋ 100 done (266/s) | 377ms
#> ⠙ 101 done (266/s) | 380ms
#> ⠹ 102 done (266/s) | 384ms
#> ⠸ 103 done (264/s) | 390ms
#> ⠼ 104 done (264/s) | 394ms
#> ⠴ 105 done (265/s) | 397ms
#> ⠦ 106 done (265/s) | 401ms
#> ⠧ 107 done (265/s) | 405ms
#> ⠇ 108 done (265/s) | 408ms
#> ⠏ 109 done (265/s) | 412ms
#> ⠋ 110 done (265/s) | 416ms
#> ⠙ 111 done (265/s) | 419ms
#> ⠹ 112 done (265/s) | 423ms
#> ⠸ 113 done (265/s) | 427ms
#> ⠼ 114 done (265/s) | 430ms
#> ⠴ 115 done (265/s) | 434ms
#> ⠦ 116 done (265/s) | 438ms
#> ⠧ 117 done (265/s) | 441ms
#> ⠇ 118 done (265/s) | 445ms
#> ⠏ 119 done (266/s) | 449ms
#> ⠋ 120 done (266/s) | 452ms
#> ⠙ 121 done (266/s) | 456ms
#> ⠹ 122 done (266/s) | 460ms
#> ⠸ 123 done (266/s) | 463ms
#> ⠼ 124 done (266/s) | 467ms
#> ⠴ 125 done (266/s) | 471ms
#> ⠦ 126 done (266/s) | 474ms
#> ⠧ 127 done (266/s) | 478ms
#> ⠇ 128 done (266/s) | 482ms
#> ⠏ 129 done (266/s) | 485ms
#> ⠋ 130 done (266/s) | 489ms
#> ⠙ 131 done (266/s) | 493ms
#> ⠹ 132 done (266/s) | 496ms
#> ⠸ 133 done (266/s) | 500ms
#> ⠼ 134 done (266/s) | 504ms
#> ⠴ 135 done (266/s) | 507ms
#> ⠦ 136 done (267/s) | 511ms
#> ⠧ 137 done (267/s) | 514ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.55ms 3.64ms      274.     265KB     4.09
cli_progress_done()
```
