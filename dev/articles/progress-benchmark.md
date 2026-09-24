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
#> 1 __cli_update_due         8.03ns   14.1ns 69180607.        0B        0
#> 2 fun()                  108.03ns  116.1ns  5255029.        0B        0
#> 3 .Call(ccli_tick_reset)  98.02ns    109ns  8727603.        0B        0
#> 4 interactive()           12.11ns   16.1ns 60851780.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  35ns   42ns 22123036.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      101ns    109ns  8442259.        0B        0
#> 2 ta[[1]]       110ns    121ns  7311074.        0B        0
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
#> 1 f0()         20.4ms   20.6ms      48.5    21.6KB     437.
#> 2 fp()         23.8ms   24.3ms      41.1    82.5KB     349.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 37.5ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     234ms    235ms      4.25        0B     36.9
#> 2 fp(1e+06)     250ms    291ms      3.43     1.9KB     25.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 56.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.29s    2.29s     0.437        0B     20.5
#> 2 fp(1e+07)     2.31s    2.31s     0.433     1.9KB     20.4
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 1.82ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     22.1s    22.1s    0.0453        0B     23.8
#> 2 fp(1e+08)     23.6s    23.6s    0.0424     1.9KB     22.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 15.2ns
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
#> 1 f0()         89.7ms  102.6ms      7.14     781KB    15.7 
#> 2 f01()        96.2ms   98.4ms      9.86     781KB    11.5 
#> 3 fp()        116.5ms  125.9ms      7.24     783KB     9.05
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 233ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.07s    1.07s     0.938    7.63MB     5.63
#> 2 f01(1e+06)       2s       2s     0.499    7.63MB     2.49
#> 3 fp(1e+06)     1.09s    1.09s     0.915    7.63MB     4.58
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 25.8ns
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
#> 1 f0()         67.3ms   67.9ms      14.7    1.44MB    11.0 
#> 2 f01()        78.5ms   80.4ms      12.4   781.3KB     6.20
#> 3 fp()           81ms   82.9ms      11.8  783.26KB     5.91
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 150ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 25.1ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   847.3ms  847.3ms     1.18     7.63MB     2.36
#> 2 f01(1e+06)    1.04s    1.04s     0.960    7.63MB     2.88
#> 3 fp(1e+06)     1.13s    1.13s     0.884    7.63MB     3.53
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 284ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 90.1ns
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
#> 1 f0()        19.86ms   20.1ms    49.0      39.3KB     1.96
#> 2 fp()          3.51s    3.51s     0.285   100.8KB     2.85
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 34.9µs
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
#> 1 f0()         19.6ms   19.7ms    43.5      18.7KB     3.95
#> 2 ff()         29.2ms   29.6ms    31.3      27.6KB     1.96
#> 3 fp()             2s       2s     0.501    25.1KB     2.50
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 19.8µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 98.8ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   206.4ms  210.7ms    1.31          0B    0.876
#> 2 ff(1e+06)   314.8ms  318.1ms    3.14      1.91KB    3.14 
#> 3 fp(1e+06)     19.2s    19.2s    0.0520    1.91KB    2.60
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 19µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 107ns
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
#> 1 test_baseline()   943.05ms 943.05ms     1.06     2.08KB        0
#> 2 test_modulo()        1.34s    1.34s     0.748    2.24KB        0
#> 3 test_cli()        981.11ms 981.11ms     1.02    24.11KB        0
#> 4 test_cli_unroll() 945.21ms 945.21ms     1.06     3.58KB        0
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
#> ■                                  0% | ETA: 46m
#> ■                                  0% | ETA: 41m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.97ms 6.25ms      157.    1.42MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (442/s) | 3ms
#> ⠹ 2 done (67/s) | 30ms
#> ⠸ 3 done (79/s) | 39ms
#> ⠼ 4 done (88/s) | 46ms
#> ⠴ 5 done (95/s) | 53ms
#> ⠦ 6 done (99/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 75ms
#> ⠏ 9 done (109/s) | 83ms
#> ⠋ 10 done (112/s) | 90ms
#> ⠙ 11 done (114/s) | 97ms
#> ⠹ 12 done (115/s) | 105ms
#> ⠸ 13 done (117/s) | 112ms
#> ⠼ 14 done (118/s) | 119ms
#> ⠴ 15 done (119/s) | 126ms
#> ⠦ 16 done (120/s) | 133ms
#> ⠧ 17 done (121/s) | 141ms
#> ⠇ 18 done (122/s) | 148ms
#> ⠏ 19 done (123/s) | 156ms
#> ⠋ 20 done (123/s) | 163ms
#> ⠙ 21 done (124/s) | 170ms
#> ⠹ 22 done (124/s) | 178ms
#> ⠸ 23 done (125/s) | 185ms
#> ⠼ 24 done (125/s) | 192ms
#> ⠴ 25 done (126/s) | 199ms
#> ⠦ 26 done (126/s) | 207ms
#> ⠧ 27 done (127/s) | 214ms
#> ⠇ 28 done (127/s) | 221ms
#> ⠏ 29 done (127/s) | 228ms
#> ⠋ 30 done (128/s) | 235ms
#> ⠙ 31 done (128/s) | 243ms
#> ⠹ 32 done (128/s) | 250ms
#> ⠸ 33 done (129/s) | 257ms
#> ⠼ 34 done (129/s) | 264ms
#> ⠴ 35 done (129/s) | 271ms
#> ⠦ 36 done (130/s) | 278ms
#> ⠧ 37 done (130/s) | 285ms
#> ⠇ 38 done (130/s) | 293ms
#> ⠏ 39 done (130/s) | 300ms
#> ⠋ 40 done (131/s) | 307ms
#> ⠙ 41 done (131/s) | 314ms
#> ⠹ 42 done (131/s) | 321ms
#> ⠸ 43 done (131/s) | 329ms
#> ⠼ 44 done (131/s) | 336ms
#> ⠴ 45 done (131/s) | 343ms
#> ⠦ 46 done (132/s) | 350ms
#> ⠧ 47 done (132/s) | 357ms
#> ⠇ 48 done (132/s) | 364ms
#> ⠏ 49 done (132/s) | 371ms
#> ⠋ 50 done (132/s) | 378ms
#> ⠙ 51 done (133/s) | 385ms
#> ⠹ 52 done (131/s) | 397ms
#> ⠸ 53 done (131/s) | 404ms
#> ⠼ 54 done (132/s) | 411ms
#> ⠴ 55 done (132/s) | 418ms
#> ⠦ 56 done (132/s) | 425ms
#> ⠧ 57 done (132/s) | 432ms
#> ⠇ 58 done (132/s) | 439ms
#> ⠏ 59 done (132/s) | 446ms
#> ⠋ 60 done (133/s) | 453ms
#> ⠙ 61 done (133/s) | 460ms
#> ⠹ 62 done (133/s) | 468ms
#> ⠸ 63 done (133/s) | 475ms
#> ⠼ 64 done (133/s) | 482ms
#> ⠴ 65 done (133/s) | 489ms
#> ⠦ 66 done (133/s) | 496ms
#> ⠧ 67 done (133/s) | 503ms
#> ⠇ 68 done (133/s) | 510ms
#> ⠏ 69 done (133/s) | 518ms
#> ⠋ 70 done (134/s) | 525ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.81ms 7.19ms      139.     265KB     2.04
cli_progress_done()
```
