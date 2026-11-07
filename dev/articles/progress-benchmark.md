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
#> 1 __cli_update_due         9.89ns     10ns 63850541.        0B        0
#> 2 fun()                   60.07ns   80.1ns  8961470.        0B        0
#> 3 .Call(ccli_tick_reset)  50.06ns   70.1ns 13425289.        0B        0
#> 4 interactive()           19.91ns     20ns 43299970.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.9ns 39.9ns 26925433.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       70ns     80ns 11347879.        0B        0
#> 2 ta[[1]]      60.1ns   71.1ns 11385709.        0B        0
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
#> 1 f0()         17.4ms   17.5ms      57.3    21.6KB     439.
#> 2 fp()         18.3ms   18.5ms      54.0    82.5KB     621.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 10.6ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     181ms    186ms      5.37        0B     46.6
#> 2 fp(1e+06)     188ms    189ms      4.67     1.9KB     21.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 2.78ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)      1.9s     1.9s     0.526        0B     25.2
#> 2 fp(1e+07)     1.91s    1.91s     0.525     1.9KB     24.7
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 1ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)       19s      19s    0.0525        0B     27.4
#> 2 fp(1e+08)     19.8s    19.8s    0.0505     1.9KB     26.1
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 7.72ns
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
#> 1 f0()         59.3ms   61.9ms     11.3      781KB     24.5
#> 2 f01()        67.2ms     77ms     13.1      781KB     13.1
#> 3 fp()         84.7ms   93.8ms      9.68     783KB     15.5
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 319ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   782.2ms  782.2ms     1.28     7.63MB    10.2 
#> 2 f01(1e+06)     1.4s     1.4s     0.715    7.63MB     2.86
#> 3 fp(1e+06)   887.1ms  887.1ms     1.13     7.63MB     7.89
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 105ns
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
#> 1 f0()           48ms   48.6ms      20.5    1.44MB     13.7
#> 2 f01()        56.3ms   62.5ms      15.8   781.3KB     15.8
#> 3 fp()         58.9ms   76.3ms      13.6  783.26KB     10.2
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 277ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 138ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  671.16ms 671.16ms     1.49     7.63MB     4.47
#> 2 f01(1e+06) 873.32ms 873.32ms     1.15     7.63MB     4.58
#> 3 fp(1e+06)     1.28s    1.28s     0.779    7.63MB     2.34
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 612ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 410ns
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
#> 1 f0()        18.16ms  18.32ms    52.5      39.3KB     1.94
#> 2 fp()          3.31s    3.31s     0.302   100.8KB     3.32
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 33µs
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
#> 1 f0()        17.23ms  17.85ms    52.5      18.7KB     3.89
#> 2 ff()        21.51ms  21.77ms    41.1      27.6KB     5.87
#> 3 fp()          1.16s    1.16s     0.863    25.1KB     4.32
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 11.4µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 39.2ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   187.1ms  196.6ms    5.15          0B     5.15
#> 2 ff(1e+06)   238.1ms  238.5ms    4.14      1.91KB     5.52
#> 3 fp(1e+06)     13.6s    13.6s    0.0736    1.91KB     4.41
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 13.4µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 41.9ns
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
#> 1 test_baseline()      133ms    133ms      7.50    2.08KB        0
#> 2 test_modulo()        764ms    764ms      1.31    2.24KB        0
#> 3 test_cli()           511ms    511ms      1.96   24.11KB        0
#> 4 test_cli_unroll()    128ms    132ms      7.61    3.58KB        0
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
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 24m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 3.2ms 3.33ms      297.    1.44MB     4.13
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (831/s) | 2ms
#> ⠹ 2 done (128/s) | 16ms
#> ⠸ 3 done (152/s) | 20ms
#> ⠼ 4 done (169/s) | 24ms
#> ⠴ 5 done (181/s) | 28ms
#> ⠦ 6 done (190/s) | 32ms
#> ⠧ 7 done (198/s) | 36ms
#> ⠇ 8 done (204/s) | 40ms
#> ⠏ 9 done (209/s) | 44ms
#> ⠋ 10 done (200/s) | 50ms
#> ⠙ 11 done (204/s) | 54ms
#> ⠹ 12 done (208/s) | 58ms
#> ⠸ 13 done (211/s) | 62ms
#> ⠼ 14 done (213/s) | 66ms
#> ⠴ 15 done (215/s) | 70ms
#> ⠦ 16 done (218/s) | 74ms
#> ⠧ 17 done (220/s) | 78ms
#> ⠇ 18 done (221/s) | 82ms
#> ⠏ 19 done (223/s) | 86ms
#> ⠋ 20 done (225/s) | 90ms
#> ⠙ 21 done (226/s) | 93ms
#> ⠹ 22 done (227/s) | 97ms
#> ⠸ 23 done (229/s) | 101ms
#> ⠼ 24 done (230/s) | 105ms
#> ⠴ 25 done (231/s) | 109ms
#> ⠦ 26 done (232/s) | 113ms
#> ⠧ 27 done (233/s) | 117ms
#> ⠇ 28 done (233/s) | 120ms
#> ⠏ 29 done (234/s) | 124ms
#> ⠋ 30 done (235/s) | 128ms
#> ⠙ 31 done (235/s) | 132ms
#> ⠹ 32 done (236/s) | 136ms
#> ⠸ 33 done (237/s) | 140ms
#> ⠼ 34 done (237/s) | 144ms
#> ⠴ 35 done (237/s) | 148ms
#> ⠦ 36 done (238/s) | 152ms
#> ⠧ 37 done (238/s) | 156ms
#> ⠇ 38 done (239/s) | 160ms
#> ⠏ 39 done (239/s) | 163ms
#> ⠋ 40 done (240/s) | 167ms
#> ⠙ 41 done (240/s) | 171ms
#> ⠹ 42 done (240/s) | 175ms
#> ⠸ 43 done (241/s) | 179ms
#> ⠼ 44 done (241/s) | 183ms
#> ⠴ 45 done (242/s) | 187ms
#> ⠦ 46 done (242/s) | 191ms
#> ⠧ 47 done (242/s) | 194ms
#> ⠇ 48 done (243/s) | 198ms
#> ⠏ 49 done (243/s) | 202ms
#> ⠋ 50 done (243/s) | 206ms
#> ⠙ 51 done (244/s) | 210ms
#> ⠹ 52 done (244/s) | 214ms
#> ⠸ 53 done (244/s) | 218ms
#> ⠼ 54 done (244/s) | 222ms
#> ⠴ 55 done (244/s) | 226ms
#> ⠦ 56 done (245/s) | 229ms
#> ⠧ 57 done (245/s) | 233ms
#> ⠇ 58 done (245/s) | 237ms
#> ⠏ 59 done (245/s) | 241ms
#> ⠋ 60 done (245/s) | 245ms
#> ⠙ 61 done (246/s) | 249ms
#> ⠹ 62 done (246/s) | 253ms
#> ⠸ 63 done (246/s) | 257ms
#> ⠼ 64 done (246/s) | 260ms
#> ⠴ 65 done (247/s) | 264ms
#> ⠦ 66 done (247/s) | 268ms
#> ⠧ 67 done (247/s) | 272ms
#> ⠇ 68 done (245/s) | 278ms
#> ⠏ 69 done (245/s) | 282ms
#> ⠋ 70 done (245/s) | 286ms
#> ⠙ 71 done (245/s) | 290ms
#> ⠹ 72 done (245/s) | 294ms
#> ⠸ 73 done (245/s) | 298ms
#> ⠼ 74 done (246/s) | 302ms
#> ⠴ 75 done (246/s) | 306ms
#> ⠦ 76 done (246/s) | 309ms
#> ⠧ 77 done (246/s) | 313ms
#> ⠇ 78 done (246/s) | 317ms
#> ⠏ 79 done (247/s) | 321ms
#> ⠋ 80 done (247/s) | 325ms
#> ⠙ 81 done (247/s) | 329ms
#> ⠹ 82 done (247/s) | 333ms
#> ⠸ 83 done (247/s) | 336ms
#> ⠼ 84 done (247/s) | 340ms
#> ⠴ 85 done (247/s) | 344ms
#> ⠦ 86 done (248/s) | 348ms
#> ⠧ 87 done (248/s) | 352ms
#> ⠇ 88 done (248/s) | 356ms
#> ⠏ 89 done (248/s) | 360ms
#> ⠋ 90 done (248/s) | 363ms
#> ⠙ 91 done (248/s) | 367ms
#> ⠹ 92 done (248/s) | 371ms
#> ⠸ 93 done (249/s) | 375ms
#> ⠼ 94 done (249/s) | 378ms
#> ⠴ 95 done (249/s) | 382ms
#> ⠦ 96 done (249/s) | 386ms
#> ⠧ 97 done (249/s) | 390ms
#> ⠇ 98 done (249/s) | 394ms
#> ⠏ 99 done (249/s) | 397ms
#> ⠋ 100 done (250/s) | 401ms
#> ⠙ 101 done (250/s) | 405ms
#> ⠹ 102 done (250/s) | 409ms
#> ⠸ 103 done (250/s) | 413ms
#> ⠼ 104 done (250/s) | 416ms
#> ⠴ 105 done (250/s) | 420ms
#> ⠦ 106 done (250/s) | 424ms
#> ⠧ 107 done (250/s) | 428ms
#> ⠇ 108 done (251/s) | 432ms
#> ⠏ 109 done (251/s) | 436ms
#> ⠋ 110 done (251/s) | 439ms
#> ⠙ 111 done (251/s) | 443ms
#> ⠹ 112 done (251/s) | 447ms
#> ⠸ 113 done (251/s) | 451ms
#> ⠼ 114 done (251/s) | 455ms
#> ⠴ 115 done (251/s) | 458ms
#> ⠦ 116 done (251/s) | 462ms
#> ⠧ 117 done (251/s) | 466ms
#> ⠇ 118 done (252/s) | 470ms
#> ⠏ 119 done (252/s) | 473ms
#> ⠋ 120 done (252/s) | 477ms
#> ⠙ 121 done (252/s) | 481ms
#> ⠹ 122 done (252/s) | 485ms
#> ⠸ 123 done (252/s) | 488ms
#> ⠼ 124 done (252/s) | 492ms
#> ⠴ 125 done (252/s) | 496ms
#> ⠦ 126 done (251/s) | 502ms
#> ⠧ 127 done (251/s) | 506ms
#> ⠇ 128 done (251/s) | 510ms
#> ⠏ 129 done (251/s) | 514ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.73ms 3.85ms      260.     266KB     6.23
cli_progress_done()
```
