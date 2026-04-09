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
#> 1 __cli_update_due           10ns   10.1ns 79735253.        0B        0
#> 2 fun()                     110ns  130.2ns  5090093.        0B        0
#> 3 .Call(ccli_tick_reset)   99.9ns  110.9ns  6722202.        0B        0
#> 4 interactive()              10ns     20ns 51141766.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns 40.2ns 21883695.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       90ns    111ns  7956258.        0B       0 
#> 2 ta[[1]]       110ns    131ns  6226878.        0B     623.
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
#> 1 f0()         24.3ms   24.4ms      41.0    21.6KB     205.
#> 2 fp()         26.9ms   27.1ms      36.5    82.3KB     170.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 27.1ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     269ms    270ms      3.70        0B     29.6
#> 2 fp(1e+06)     291ms    310ms      3.22    1.88KB     27.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 40.1ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.69s    2.69s     0.372        0B     31.3
#> 2 fp(1e+07)     2.89s    2.89s     0.346    1.88KB     29.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 20.5ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.9s    25.9s    0.0386        0B     18.8
#> 2 fp(1e+08)     27.8s    27.8s    0.0359    1.88KB     17.3
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 19.5ns
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
#> 1 f0()         93.1ms   94.9ms      9.72     781KB     11.7
#> 2 f01()       121.9ms  135.8ms      6.96     781KB     10.4
#> 3 fp()          140ms  142.5ms      6.91     783KB     12.1
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 476ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  970.67ms 970.67ms     1.03     7.63MB     7.21
#> 2 f01(1e+06)     1.5s     1.5s     0.665    7.63MB     4.65
#> 3 fp(1e+06)     2.11s    2.11s     0.473    7.63MB     3.78
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.14µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 609ns
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
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()         77.4ms   87.4ms     11.6     1.41MB     7.76
#> 2 f01()       119.1ms  121.1ms      7.04   781.3KB     7.04
#> 3 fp()        124.9ms    132ms      7.46  783.24KB     3.73
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 445ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 108ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  934.51ms 934.51ms     1.07     7.63MB     2.14
#> 2 f01(1e+06)    1.13s    1.13s     0.883    7.63MB     1.77
#> 3 fp(1e+06)     1.47s    1.47s     0.680    7.63MB     1.36
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 536ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 338ns
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
#> 1 f0()        23.92ms  24.13ms    41.1      39.3KB     1.96
#> 2 fp()          3.91s    3.91s     0.256   100.4KB     2.05
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 38.8µs
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
#> 1 f0()        22.96ms  23.23ms    37.0      18.7KB     3.89
#> 2 ff()        31.75ms  31.98ms    28.6      27.6KB     1.91
#> 3 fp()          2.19s    2.19s     0.457    25.1KB     1.83
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 21.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 87.5ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     252ms    264ms    3.79          0B     3.79
#> 2 ff(1e+06)     336ms    381ms    2.62       1.9KB     1.31
#> 3 fp(1e+06)       23s      23s    0.0435     1.9KB     1.87
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 117ns
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
#> 1 test_baseline()   704.09ms 704.09ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.709    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984    23.9KB        0
#> 4 test_cli_unroll() 704.25ms 704.25ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
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
#> ■                                  0% | ETA: 17m
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
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 5.9ms 6.07ms      162.     1.4MB     2.02
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (494/s) | 3ms
#> ⠹ 2 done (72/s) | 28ms
#> ⠸ 3 done (86/s) | 36ms
#> ⠼ 4 done (95/s) | 43ms
#> ⠴ 5 done (102/s) | 50ms
#> ⠦ 6 done (107/s) | 57ms
#> ⠧ 7 done (111/s) | 64ms
#> ⠇ 8 done (114/s) | 71ms
#> ⠏ 9 done (117/s) | 78ms
#> ⠋ 10 done (119/s) | 85ms
#> ⠙ 11 done (121/s) | 92ms
#> ⠹ 12 done (122/s) | 99ms
#> ⠸ 13 done (123/s) | 106ms
#> ⠼ 14 done (125/s) | 113ms
#> ⠴ 15 done (125/s) | 121ms
#> ⠦ 16 done (126/s) | 128ms
#> ⠧ 17 done (127/s) | 135ms
#> ⠇ 18 done (127/s) | 142ms
#> ⠏ 19 done (128/s) | 149ms
#> ⠋ 20 done (129/s) | 156ms
#> ⠙ 21 done (130/s) | 163ms
#> ⠹ 22 done (130/s) | 170ms
#> ⠸ 23 done (131/s) | 177ms
#> ⠼ 24 done (131/s) | 184ms
#> ⠴ 25 done (132/s) | 191ms
#> ⠦ 26 done (132/s) | 198ms
#> ⠧ 27 done (132/s) | 205ms
#> ⠇ 28 done (133/s) | 212ms
#> ⠏ 29 done (133/s) | 219ms
#> ⠋ 30 done (133/s) | 226ms
#> ⠙ 31 done (134/s) | 233ms
#> ⠹ 32 done (134/s) | 240ms
#> ⠸ 33 done (134/s) | 247ms
#> ⠼ 34 done (134/s) | 253ms
#> ⠴ 35 done (135/s) | 260ms
#> ⠦ 36 done (135/s) | 267ms
#> ⠧ 37 done (135/s) | 274ms
#> ⠇ 38 done (135/s) | 281ms
#> ⠏ 39 done (136/s) | 288ms
#> ⠋ 40 done (136/s) | 295ms
#> ⠙ 41 done (136/s) | 302ms
#> ⠹ 42 done (136/s) | 309ms
#> ⠸ 43 done (136/s) | 316ms
#> ⠼ 44 done (136/s) | 323ms
#> ⠴ 45 done (136/s) | 330ms
#> ⠦ 46 done (137/s) | 337ms
#> ⠧ 47 done (137/s) | 344ms
#> ⠇ 48 done (137/s) | 351ms
#> ⠏ 49 done (137/s) | 358ms
#> ⠋ 50 done (137/s) | 366ms
#> ⠙ 51 done (137/s) | 373ms
#> ⠹ 52 done (137/s) | 380ms
#> ⠸ 53 done (137/s) | 387ms
#> ⠼ 54 done (137/s) | 394ms
#> ⠴ 55 done (137/s) | 401ms
#> ⠦ 56 done (138/s) | 408ms
#> ⠧ 57 done (138/s) | 415ms
#> ⠇ 58 done (138/s) | 422ms
#> ⠏ 59 done (138/s) | 429ms
#> ⠋ 60 done (138/s) | 436ms
#> ⠙ 61 done (138/s) | 443ms
#> ⠹ 62 done (138/s) | 450ms
#> ⠸ 63 done (138/s) | 457ms
#> ⠼ 64 done (138/s) | 464ms
#> ⠴ 65 done (138/s) | 471ms
#> ⠦ 66 done (138/s) | 478ms
#> ⠧ 67 done (138/s) | 485ms
#> ⠇ 68 done (138/s) | 492ms
#> ⠏ 69 done (139/s) | 499ms
#> ⠋ 70 done (139/s) | 506ms
#> ⠙ 71 done (139/s) | 513ms
#> ⠹ 72 done (139/s) | 520ms
#> ⠸ 73 done (139/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.92ms 6.99ms      143.     265KB        0
cli_progress_done()
```
