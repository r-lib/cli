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
#> 1 __cli_update_due              0     10ns    1.16e8        0B        0
#> 2 fun()                  130.04ns  160.1ns    4.45e6        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  121.1ns    7.26e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    7.15e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 41.1ns 21792484.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6378074.        0B        0
#> 2 ta[[1]]       140ns    160ns  5787153.        0B        0
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
#> 1 f0()         22.4ms   22.4ms      44.6    21.6KB     379.
#> 2 fp()         25.4ms   25.5ms      39.2    82.5KB     313.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 30.9ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     258ms    279ms      3.58        0B     32.2
#> 2 fp(1e+06)     274ms    276ms      3.62     1.9KB     30.8
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
#> 1 f0(1e+07)      2.5s     2.5s     0.400        0B     18.8
#> 2 fp(1e+07)     2.54s    2.54s     0.394     1.9KB     18.9
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 3.96ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     24.1s    24.1s    0.0415        0B     21.8
#> 2 fp(1e+08)     25.9s    25.9s    0.0387     1.9KB     20.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.6ns
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
#> 1 f0()         97.6ms    120ms      7.08     781KB     15.6
#> 2 f01()         107ms    110ms      8.91     781KB     10.7
#> 3 fp()        121.6ms    131ms      6.76     783KB     10.1
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 110ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  963.17ms 963.17ms     1.04     7.63MB     7.27
#> 2 f01(1e+06)    1.45s    1.45s     0.690    7.63MB     4.83
#> 3 fp(1e+06)     2.16s    2.16s     0.463    7.63MB     3.71
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.2µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 711ns
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
#> 1 f0()         82.7ms   85.6ms     11.7     1.44MB     23.4
#> 2 f01()       103.9ms  103.9ms      9.62   781.3KB     38.5
#> 3 fp()        134.3ms  134.3ms      7.45  783.26KB     22.3
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 487ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 303ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  917.76ms 917.76ms     1.09     7.63MB     2.18
#> 2 f01(1e+06)    1.19s    1.19s     0.844    7.63MB     2.53
#> 3 fp(1e+06)     1.23s    1.23s     0.812    7.63MB     2.44
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 314ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 46.5ns
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
#> 1 f0()         22.6ms   22.9ms    42.3      39.3KB     1.92
#> 2 fp()             4s       4s     0.250   100.8KB     2.00
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.8µs
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
#> 1 f0()        21.78ms  21.97ms    42.9      18.7KB     3.90
#> 2 ff()        32.02ms   32.3ms    29.5      27.6KB     1.96
#> 3 fp()          2.24s    2.24s     0.446    25.1KB     1.78
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 103ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   228.4ms  244.7ms    4.18          0B     4.18
#> 2 ff(1e+06)   315.6ms  325.5ms    3.07      1.91KB     1.54
#> 3 fp(1e+06)     23.7s    23.7s    0.0422    1.91KB     1.90
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 80.7ns
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
#> 1 test_baseline()   623.14ms 623.14ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.802    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.11KB        0
#> 4 test_cli_unroll() 623.66ms 623.66ms     1.60     3.58KB        0
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
#> ■                                  0% | ETA: 47m
#> ■                                  0% | ETA: 42m
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
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
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
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.32ms 6.42ms      152.    1.42MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (467/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (77/s) | 40ms
#> ⠼ 4 done (85/s) | 48ms
#> ⠴ 5 done (91/s) | 56ms
#> ⠦ 6 done (95/s) | 64ms
#> ⠧ 7 done (99/s) | 72ms
#> ⠇ 8 done (101/s) | 80ms
#> ⠏ 9 done (104/s) | 88ms
#> ⠋ 10 done (105/s) | 96ms
#> ⠙ 11 done (107/s) | 104ms
#> ⠹ 12 done (108/s) | 111ms
#> ⠸ 13 done (110/s) | 119ms
#> ⠼ 14 done (111/s) | 127ms
#> ⠴ 15 done (112/s) | 135ms
#> ⠦ 16 done (113/s) | 142ms
#> ⠧ 17 done (114/s) | 150ms
#> ⠇ 18 done (114/s) | 158ms
#> ⠏ 19 done (115/s) | 166ms
#> ⠋ 20 done (116/s) | 174ms
#> ⠙ 21 done (116/s) | 182ms
#> ⠹ 22 done (117/s) | 189ms
#> ⠸ 23 done (117/s) | 197ms
#> ⠼ 24 done (117/s) | 205ms
#> ⠴ 25 done (118/s) | 213ms
#> ⠦ 26 done (118/s) | 221ms
#> ⠧ 27 done (119/s) | 228ms
#> ⠇ 28 done (119/s) | 236ms
#> ⠏ 29 done (119/s) | 244ms
#> ⠋ 30 done (119/s) | 253ms
#> ⠙ 31 done (119/s) | 261ms
#> ⠹ 32 done (119/s) | 269ms
#> ⠸ 33 done (117/s) | 282ms
#> ⠼ 34 done (118/s) | 290ms
#> ⠴ 35 done (118/s) | 298ms
#> ⠦ 36 done (118/s) | 306ms
#> ⠧ 37 done (118/s) | 314ms
#> ⠇ 38 done (118/s) | 322ms
#> ⠏ 39 done (119/s) | 329ms
#> ⠋ 40 done (119/s) | 337ms
#> ⠙ 41 done (119/s) | 346ms
#> ⠹ 42 done (119/s) | 354ms
#> ⠸ 43 done (119/s) | 362ms
#> ⠼ 44 done (119/s) | 369ms
#> ⠴ 45 done (119/s) | 377ms
#> ⠦ 46 done (120/s) | 385ms
#> ⠧ 47 done (120/s) | 393ms
#> ⠇ 48 done (120/s) | 400ms
#> ⠏ 49 done (120/s) | 408ms
#> ⠋ 50 done (120/s) | 416ms
#> ⠙ 51 done (121/s) | 423ms
#> ⠹ 52 done (121/s) | 432ms
#> ⠸ 53 done (121/s) | 440ms
#> ⠼ 54 done (121/s) | 447ms
#> ⠴ 55 done (121/s) | 455ms
#> ⠦ 56 done (121/s) | 463ms
#> ⠧ 57 done (121/s) | 471ms
#> ⠇ 58 done (121/s) | 479ms
#> ⠏ 59 done (121/s) | 486ms
#> ⠋ 60 done (122/s) | 494ms
#> ⠙ 61 done (122/s) | 501ms
#> ⠹ 62 done (122/s) | 509ms
#> ⠸ 63 done (122/s) | 517ms
#> ⠼ 64 done (122/s) | 524ms
#> ⠴ 65 done (122/s) | 532ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.51ms 7.84ms      127.     265KB     2.02
cli_progress_done()
```
