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
#> 1 __cli_update_due           10ns   10.1ns 85367761.        0B        0
#> 2 fun()                     110ns  139.9ns  4679127.        0B        0
#> 3 .Call(ccli_tick_reset)    110ns  130.2ns  7138070.        0B        0
#> 4 interactive()              10ns     20ns 55702693.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.9ns 49.9ns 20370510.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      110ns    140ns  6523480.        0B        0
#> 2 ta[[1]]       120ns    150ns  5873950.        0B        0
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
#> 1 f0()         24.4ms   24.4ms      41.0    21.6KB     328.
#> 2 fp()         27.3ms   27.6ms      36.3    82.5KB     272.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 31.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     275ms    277ms      3.62        0B     32.5
#> 2 fp(1e+06)     298ms    299ms      3.34     1.9KB     30.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 22.8ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.82s    2.82s     0.355        0B     17.0
#> 2 fp(1e+07)     2.77s    2.77s     0.361     1.9KB     17.0
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
#> 1 f0(1e+08)     26.2s    26.2s    0.0381        0B     20.1
#> 2 fp(1e+08)       28s      28s    0.0358     1.9KB     18.5
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.5ns
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
#> 1 f0()         87.8ms    104ms      7.46     781KB     16.4
#> 2 f01()       105.4ms    108ms      9.01     781KB     10.8
#> 3 fp()        121.9ms    134ms      6.68     783KB     10.0
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 294ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  925.95ms 925.95ms     1.08     7.63MB     6.48
#> 2 f01(1e+06)    1.53s    1.53s     0.654    7.63MB     5.23
#> 3 fp(1e+06)     2.32s    2.32s     0.431    7.63MB     3.45
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.39µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 791ns
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
#> 1 f0()         78.1ms   82.3ms     12.2     1.44MB     24.3
#> 2 f01()       103.9ms  103.9ms      9.62   781.3KB     38.5
#> 3 fp()        136.8ms  136.8ms      7.31  783.26KB     21.9
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 545ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 329ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  888.69ms 888.69ms     1.13     7.63MB     2.25
#> 2 f01(1e+06)     1.2s     1.2s     0.832    7.63MB     2.50
#> 3 fp(1e+06)     1.24s    1.24s     0.808    7.63MB     2.42
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 350ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 36.9ns
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
#> 1 f0()        23.98ms  24.09ms    40.6      39.3KB     1.93
#> 2 fp()          3.81s    3.81s     0.262   100.8KB     2.10
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 37.9µs
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
#> 1 f0()        22.78ms  23.02ms    40.2      18.7KB     3.83
#> 2 ff()        31.83ms  31.92ms    29.0      27.6KB     1.94
#> 3 fp()          2.14s    2.14s     0.467    25.1KB     1.87
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 21.2µs
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
#> 1 f0(1e+06)   241.2ms  256.5ms    3.90          0B     3.90
#> 2 ff(1e+06)   318.7ms  334.6ms    2.99      1.91KB     1.49
#> 3 fp(1e+06)     23.1s    23.1s    0.0433    1.91KB     1.95
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 78.1ns
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
#> 1 test_baseline()   703.98ms 703.98ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.709    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.11KB        0
#> 4 test_cli_unroll() 705.45ms 705.45ms     1.42     3.58KB        0
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
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.75ms 5.93ms      164.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (474/s) | 3ms
#> ⠹ 2 done (67/s) | 31ms
#> ⠸ 3 done (81/s) | 38ms
#> ⠼ 4 done (90/s) | 45ms
#> ⠴ 5 done (98/s) | 52ms
#> ⠦ 6 done (103/s) | 59ms
#> ⠧ 7 done (107/s) | 66ms
#> ⠇ 8 done (111/s) | 73ms
#> ⠏ 9 done (114/s) | 80ms
#> ⠋ 10 done (116/s) | 87ms
#> ⠙ 11 done (118/s) | 94ms
#> ⠹ 12 done (119/s) | 101ms
#> ⠸ 13 done (120/s) | 109ms
#> ⠼ 14 done (121/s) | 116ms
#> ⠴ 15 done (117/s) | 129ms
#> ⠦ 16 done (118/s) | 136ms
#> ⠧ 17 done (119/s) | 143ms
#> ⠇ 18 done (120/s) | 150ms
#> ⠏ 19 done (121/s) | 157ms
#> ⠋ 20 done (122/s) | 165ms
#> ⠙ 21 done (122/s) | 172ms
#> ⠹ 22 done (123/s) | 179ms
#> ⠸ 23 done (124/s) | 186ms
#> ⠼ 24 done (124/s) | 193ms
#> ⠴ 25 done (125/s) | 200ms
#> ⠦ 26 done (126/s) | 207ms
#> ⠧ 27 done (126/s) | 214ms
#> ⠇ 28 done (127/s) | 221ms
#> ⠏ 29 done (127/s) | 228ms
#> ⠋ 30 done (128/s) | 235ms
#> ⠙ 31 done (128/s) | 242ms
#> ⠹ 32 done (129/s) | 249ms
#> ⠸ 33 done (129/s) | 256ms
#> ⠼ 34 done (129/s) | 263ms
#> ⠴ 35 done (130/s) | 270ms
#> ⠦ 36 done (130/s) | 277ms
#> ⠧ 37 done (130/s) | 284ms
#> ⠇ 38 done (131/s) | 291ms
#> ⠏ 39 done (131/s) | 298ms
#> ⠋ 40 done (132/s) | 305ms
#> ⠙ 41 done (132/s) | 311ms
#> ⠹ 42 done (132/s) | 318ms
#> ⠸ 43 done (132/s) | 325ms
#> ⠼ 44 done (133/s) | 332ms
#> ⠴ 45 done (133/s) | 339ms
#> ⠦ 46 done (133/s) | 346ms
#> ⠧ 47 done (133/s) | 353ms
#> ⠇ 48 done (134/s) | 360ms
#> ⠏ 49 done (134/s) | 367ms
#> ⠋ 50 done (134/s) | 374ms
#> ⠙ 51 done (134/s) | 381ms
#> ⠹ 52 done (134/s) | 388ms
#> ⠸ 53 done (134/s) | 395ms
#> ⠼ 54 done (135/s) | 402ms
#> ⠴ 55 done (135/s) | 409ms
#> ⠦ 56 done (135/s) | 416ms
#> ⠧ 57 done (135/s) | 423ms
#> ⠇ 58 done (135/s) | 430ms
#> ⠏ 59 done (135/s) | 436ms
#> ⠋ 60 done (136/s) | 443ms
#> ⠙ 61 done (136/s) | 450ms
#> ⠹ 62 done (136/s) | 457ms
#> ⠸ 63 done (136/s) | 464ms
#> ⠼ 64 done (136/s) | 471ms
#> ⠴ 65 done (136/s) | 478ms
#> ⠦ 66 done (136/s) | 485ms
#> ⠧ 67 done (136/s) | 492ms
#> ⠇ 68 done (136/s) | 499ms
#> ⠏ 69 done (136/s) | 506ms
#> ⠋ 70 done (137/s) | 513ms
#> ⠙ 71 done (137/s) | 520ms
#> ⠹ 72 done (137/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.74ms 6.95ms      143.     265KB     2.04
cli_progress_done()
```
