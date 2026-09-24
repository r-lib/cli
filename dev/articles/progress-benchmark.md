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
#> 1 __cli_update_due              0     10ns    1.72e8        0B        0
#> 2 fun()                      80ns   90.1ns    7.20e6        0B        0
#> 3 .Call(ccli_tick_reset)     70ns   80.1ns    1.13e7        0B        0
#> 4 interactive()               1ns   10.1ns    8.56e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  20ns   30ns 32048324.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       80ns   90.1ns 10228939.        0B        0
#> 2 ta[[1]]        90ns  100.1ns  8899375.        0B        0
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
#> 1 f0()         15.4ms   15.6ms      64.0    21.6KB     512.
#> 2 fp()         17.2ms   17.2ms      57.9    82.5KB     424.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 16.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     183ms    183ms      4.75        0B     42.8
#> 2 fp(1e+06)     174ms    174ms      5.71     1.9KB     26.7
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     1.74s    1.74s     0.573        0B     27.5
#> 2 fp(1e+07)     1.77s    1.77s     0.564     1.9KB     26.5
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 2.92ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     17.2s    17.2s    0.0581        0B     30.4
#> 2 fp(1e+08)     18.4s    18.4s    0.0543     1.9KB     28.1
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 11.8ns
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
#> 1 f0()         69.3ms   86.3ms      9.15     781KB     18.3
#> 2 f01()        69.1ms   84.8ms     11.0      781KB     18.8
#> 3 fp()         91.8ms  104.7ms      9.53     783KB     13.3
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 184ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  690.08ms 690.08ms     1.45     7.63MB     8.69
#> 2 f01(1e+06)     1.3s     1.3s     0.771    7.63MB     6.16
#> 3 fp(1e+06)     1.52s    1.52s     0.657    7.63MB     4.60
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 832ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 224ns
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
#> 1 f0()         49.1ms   49.2ms      20.0    1.44MB    39.9 
#> 2 f01()        56.1ms   58.2ms      17.2   781.3KB     5.74
#> 3 fp()         57.9ms   58.9ms      16.4  783.26KB     9.86
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 97.1ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 6.83ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  684.23ms 684.23ms     1.46     7.63MB     4.38
#> 2 f01(1e+06) 823.64ms 823.64ms     1.21     7.63MB     4.86
#> 3 fp(1e+06)     1.16s    1.16s     0.860    7.63MB     3.44
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 478ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 339ns
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
#> 1 f0()        15.37ms  15.73ms    62.8      39.3KB     3.92
#> 2 fp()          2.29s    2.29s     0.436   100.8KB     4.80
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 22.8µs
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
#> 1 f0()        14.24ms  14.96ms    57.4      18.7KB     7.92
#> 2 ff()        19.16ms   19.6ms    47.2      27.6KB     3.93
#> 3 fp()          1.34s    1.34s     0.744    25.1KB     4.46
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 13.3µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 46.5ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   166.8ms  168.6ms    5.79          0B     7.73
#> 2 ff(1e+06)   211.8ms    212ms    4.71      1.91KB     4.71
#> 3 fp(1e+06)     13.8s    13.8s    0.0727    1.91KB     4.43
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 13.6µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 43.4ns
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
#> 1 test_baseline()      467ms    478ms      2.09    2.08KB        0
#> 2 test_modulo()        808ms    808ms      1.24    2.24KB        0
#> 3 test_cli()           530ms    530ms      1.89   24.11KB        0
#> 4 test_cli_unroll()    478ms    482ms      2.07    3.58KB        0
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
#> ■                                  0% | ETA: 46m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 13m
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
#> ■                                  0% | ETA:  9m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.33ms 3.46ms      284.    1.41MB     4.09
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (790/s) | 2ms
#> ⠹ 2 done (124/s) | 17ms
#> ⠸ 3 done (147/s) | 21ms
#> ⠼ 4 done (164/s) | 25ms
#> ⠴ 5 done (176/s) | 29ms
#> ⠦ 6 done (186/s) | 33ms
#> ⠧ 7 done (193/s) | 37ms
#> ⠇ 8 done (199/s) | 41ms
#> ⠏ 9 done (204/s) | 45ms
#> ⠋ 10 done (208/s) | 49ms
#> ⠙ 11 done (211/s) | 53ms
#> ⠹ 12 done (213/s) | 57ms
#> ⠸ 13 done (215/s) | 61ms
#> ⠼ 14 done (217/s) | 65ms
#> ⠴ 15 done (219/s) | 69ms
#> ⠦ 16 done (220/s) | 73ms
#> ⠧ 17 done (222/s) | 77ms
#> ⠇ 18 done (223/s) | 81ms
#> ⠏ 19 done (224/s) | 85ms
#> ⠋ 20 done (225/s) | 89ms
#> ⠙ 21 done (219/s) | 96ms
#> ⠹ 22 done (220/s) | 100ms
#> ⠸ 23 done (221/s) | 105ms
#> ⠼ 24 done (222/s) | 109ms
#> ⠴ 25 done (223/s) | 113ms
#> ⠦ 26 done (224/s) | 117ms
#> ⠧ 27 done (225/s) | 121ms
#> ⠇ 28 done (225/s) | 125ms
#> ⠏ 29 done (226/s) | 129ms
#> ⠋ 30 done (227/s) | 133ms
#> ⠙ 31 done (227/s) | 137ms
#> ⠹ 32 done (228/s) | 141ms
#> ⠸ 33 done (228/s) | 145ms
#> ⠼ 34 done (229/s) | 149ms
#> ⠴ 35 done (229/s) | 153ms
#> ⠦ 36 done (230/s) | 157ms
#> ⠧ 37 done (230/s) | 161ms
#> ⠇ 38 done (230/s) | 166ms
#> ⠏ 39 done (231/s) | 170ms
#> ⠋ 40 done (231/s) | 174ms
#> ⠙ 41 done (231/s) | 178ms
#> ⠹ 42 done (231/s) | 182ms
#> ⠸ 43 done (231/s) | 186ms
#> ⠼ 44 done (232/s) | 190ms
#> ⠴ 45 done (232/s) | 195ms
#> ⠦ 46 done (232/s) | 199ms
#> ⠧ 47 done (233/s) | 203ms
#> ⠇ 48 done (233/s) | 207ms
#> ⠏ 49 done (233/s) | 211ms
#> ⠋ 50 done (233/s) | 215ms
#> ⠙ 51 done (234/s) | 219ms
#> ⠹ 52 done (234/s) | 223ms
#> ⠸ 53 done (234/s) | 227ms
#> ⠼ 54 done (234/s) | 231ms
#> ⠴ 55 done (235/s) | 235ms
#> ⠦ 56 done (235/s) | 239ms
#> ⠧ 57 done (235/s) | 243ms
#> ⠇ 58 done (236/s) | 247ms
#> ⠏ 59 done (236/s) | 251ms
#> ⠋ 60 done (236/s) | 255ms
#> ⠙ 61 done (236/s) | 259ms
#> ⠹ 62 done (236/s) | 263ms
#> ⠸ 63 done (236/s) | 267ms
#> ⠼ 64 done (236/s) | 271ms
#> ⠴ 65 done (236/s) | 275ms
#> ⠦ 66 done (237/s) | 280ms
#> ⠧ 67 done (237/s) | 284ms
#> ⠇ 68 done (237/s) | 288ms
#> ⠏ 69 done (237/s) | 292ms
#> ⠋ 70 done (237/s) | 296ms
#> ⠙ 71 done (237/s) | 300ms
#> ⠹ 72 done (238/s) | 304ms
#> ⠸ 73 done (238/s) | 308ms
#> ⠼ 74 done (238/s) | 312ms
#> ⠴ 75 done (238/s) | 316ms
#> ⠦ 76 done (238/s) | 320ms
#> ⠧ 77 done (238/s) | 324ms
#> ⠇ 78 done (238/s) | 328ms
#> ⠏ 79 done (236/s) | 335ms
#> ⠋ 80 done (237/s) | 339ms
#> ⠙ 81 done (237/s) | 343ms
#> ⠹ 82 done (237/s) | 347ms
#> ⠸ 83 done (237/s) | 351ms
#> ⠼ 84 done (237/s) | 356ms
#> ⠴ 85 done (237/s) | 360ms
#> ⠦ 86 done (237/s) | 364ms
#> ⠧ 87 done (237/s) | 368ms
#> ⠇ 88 done (237/s) | 372ms
#> ⠏ 89 done (237/s) | 376ms
#> ⠋ 90 done (237/s) | 380ms
#> ⠙ 91 done (237/s) | 385ms
#> ⠹ 92 done (237/s) | 389ms
#> ⠸ 93 done (237/s) | 393ms
#> ⠼ 94 done (237/s) | 397ms
#> ⠴ 95 done (237/s) | 401ms
#> ⠦ 96 done (237/s) | 405ms
#> ⠧ 97 done (237/s) | 409ms
#> ⠇ 98 done (238/s) | 413ms
#> ⠏ 99 done (238/s) | 417ms
#> ⠋ 100 done (238/s) | 421ms
#> ⠙ 101 done (238/s) | 425ms
#> ⠹ 102 done (238/s) | 429ms
#> ⠸ 103 done (238/s) | 433ms
#> ⠼ 104 done (238/s) | 437ms
#> ⠴ 105 done (238/s) | 441ms
#> ⠦ 106 done (238/s) | 445ms
#> ⠧ 107 done (238/s) | 449ms
#> ⠇ 108 done (238/s) | 454ms
#> ⠏ 109 done (238/s) | 458ms
#> ⠋ 110 done (239/s) | 462ms
#> ⠙ 111 done (239/s) | 466ms
#> ⠹ 112 done (239/s) | 470ms
#> ⠸ 113 done (239/s) | 474ms
#> ⠼ 114 done (239/s) | 478ms
#> ⠴ 115 done (239/s) | 482ms
#> ⠦ 116 done (239/s) | 487ms
#> ⠧ 117 done (239/s) | 491ms
#> ⠇ 118 done (239/s) | 495ms
#> ⠏ 119 done (239/s) | 499ms
#> ⠋ 120 done (239/s) | 503ms
#> ⠙ 121 done (239/s) | 507ms
#> ⠹ 122 done (239/s) | 511ms
#> ⠸ 123 done (239/s) | 515ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.94ms 4.07ms      246.     266KB     4.10
cli_progress_done()
```
