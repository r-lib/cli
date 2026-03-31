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
#> 1 __cli_update_due              0   10.1ns 71180258.        0B        0
#> 2 fun()                  120.02ns  140.2ns  5001823.        0B        0
#> 3 .Call(ccli_tick_reset)  99.88ns  119.9ns  8298710.        0B        0
#> 4 interactive()            8.96ns   10.1ns 71118032.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20524888.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    140ns  6914136.        0B       0 
#> 2 ta[[1]]       150ns    170ns  5468411.        0B     547.
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
#> 1 f0()         21.9ms     22ms      45.6    21.6KB     273.
#> 2 fp()         24.8ms   24.9ms      39.8    82.3KB     212.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 29.8ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     236ms    239ms      4.17        0B     34.8
#> 2 fp(1e+06)     265ms    296ms      3.38    1.88KB     27.0
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 57.2ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.47s    2.47s     0.405        0B     34.1
#> 2 fp(1e+07)     2.58s    2.58s     0.388    1.88KB     32.6
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 11.2ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.4s    23.4s    0.0427        0B     20.8
#> 2 fp(1e+08)     25.5s    25.5s    0.0393    1.88KB     19.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 20.6ns
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
#> 1 f0()         88.7ms   93.1ms     10.7      781KB     12.5
#> 2 f01()       112.6ms  118.3ms      7.78     781KB     13.6
#> 3 fp()        104.8ms  118.8ms      8.60     783KB     13.8
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 257ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  896.59ms 896.59ms     1.12     7.63MB     4.46
#> 2 f01(1e+06)    1.14s    1.14s     0.877    7.63MB     5.26
#> 3 fp(1e+06)     1.39s    1.39s     0.717    7.63MB     3.59
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 498ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 254ns
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
#> 1 f0()         80.2ms   80.3ms      12.3    1.41MB     4.93
#> 2 f01()        90.9ms   90.9ms      10.9   781.3KB    10.9 
#> 3 fp()         93.7ms   95.3ms      10.4  783.24KB     6.94
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 150ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 44.3ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     2.08s    2.08s     0.480    7.63MB     1.44
#> 2 f01(1e+06)    1.09s    1.09s     0.915    7.63MB     2.74
#> 3 fp(1e+06)     1.17s    1.17s     0.857    7.63MB     3.43
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 72.9ns
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
#> 1 f0()        24.15ms  29.59ms    32.3      39.3KB     1.90
#> 2 fp()          4.33s    4.33s     0.231   100.4KB     2.77
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 43µs
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
#> 1 f0()         28.2ms   40.8ms    25.1      18.7KB     3.86
#> 2 ff()         41.4ms     51ms    20.0      27.6KB     1.82
#> 3 fp()           2.4s     2.4s     0.416    25.1KB     2.91
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 102ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     221ms    222ms    4.51          0B     4.51
#> 2 ff(1e+06)     314ms    342ms    2.92       1.9KB     2.92
#> 3 fp(1e+06)       23s      23s    0.0435     1.9KB     2.35
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 121ns
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
#> 1 test_baseline()   623.35ms 623.35ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.802    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803    23.9KB        0
#> 4 test_cli_unroll() 623.95ms 623.95ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.38ms 6.49ms      149.     1.4MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (488/s) | 3ms
#> ⠹ 2 done (69/s) | 30ms
#> ⠸ 3 done (81/s) | 38ms
#> ⠼ 4 done (90/s) | 45ms
#> ⠴ 5 done (96/s) | 53ms
#> ⠦ 6 done (101/s) | 60ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 75ms
#> ⠏ 9 done (110/s) | 83ms
#> ⠋ 10 done (112/s) | 90ms
#> ⠙ 11 done (113/s) | 98ms
#> ⠹ 12 done (115/s) | 105ms
#> ⠸ 13 done (116/s) | 113ms
#> ⠼ 14 done (117/s) | 120ms
#> ⠴ 15 done (118/s) | 128ms
#> ⠦ 16 done (119/s) | 135ms
#> ⠧ 17 done (120/s) | 143ms
#> ⠇ 18 done (120/s) | 150ms
#> ⠏ 19 done (121/s) | 158ms
#> ⠋ 20 done (121/s) | 165ms
#> ⠙ 21 done (122/s) | 173ms
#> ⠹ 22 done (122/s) | 180ms
#> ⠸ 23 done (123/s) | 188ms
#> ⠼ 24 done (123/s) | 196ms
#> ⠴ 25 done (124/s) | 203ms
#> ⠦ 26 done (124/s) | 211ms
#> ⠧ 27 done (124/s) | 218ms
#> ⠇ 28 done (124/s) | 226ms
#> ⠏ 29 done (125/s) | 233ms
#> ⠋ 30 done (125/s) | 241ms
#> ⠙ 31 done (125/s) | 248ms
#> ⠹ 32 done (125/s) | 256ms
#> ⠸ 33 done (126/s) | 263ms
#> ⠼ 34 done (126/s) | 271ms
#> ⠴ 35 done (125/s) | 280ms
#> ⠦ 36 done (125/s) | 288ms
#> ⠧ 37 done (125/s) | 296ms
#> ⠇ 38 done (126/s) | 303ms
#> ⠏ 39 done (126/s) | 311ms
#> ⠋ 40 done (126/s) | 318ms
#> ⠙ 41 done (126/s) | 326ms
#> ⠹ 42 done (126/s) | 333ms
#> ⠸ 43 done (126/s) | 341ms
#> ⠼ 44 done (127/s) | 348ms
#> ⠴ 45 done (127/s) | 356ms
#> ⠦ 46 done (127/s) | 363ms
#> ⠧ 47 done (127/s) | 371ms
#> ⠇ 48 done (127/s) | 379ms
#> ⠏ 49 done (125/s) | 392ms
#> ⠋ 50 done (125/s) | 400ms
#> ⠙ 51 done (125/s) | 408ms
#> ⠹ 52 done (125/s) | 417ms
#> ⠸ 53 done (125/s) | 425ms
#> ⠼ 54 done (125/s) | 433ms
#> ⠴ 55 done (125/s) | 442ms
#> ⠦ 56 done (125/s) | 450ms
#> ⠧ 57 done (124/s) | 459ms
#> ⠇ 58 done (124/s) | 467ms
#> ⠏ 59 done (124/s) | 475ms
#> ⠋ 60 done (124/s) | 484ms
#> ⠙ 61 done (124/s) | 491ms
#> ⠹ 62 done (124/s) | 499ms
#> ⠸ 63 done (125/s) | 506ms
#> ⠼ 64 done (125/s) | 514ms
#> ⠴ 65 done (125/s) | 521ms
#> ⠦ 66 done (125/s) | 529ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.44ms 7.53ms      130.     265KB     2.03
cli_progress_done()
```
