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
#> 1 __cli_update_due              0   10.1ns 96202145.        0B        0
#> 2 fun()                  130.04ns  150.1ns  4638658.        0B        0
#> 3 .Call(ccli_tick_reset)  99.88ns  119.9ns  8182562.        0B        0
#> 4 interactive()            8.96ns   10.1ns 59231124.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20653275.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6291078.        0B        0
#> 2 ta[[1]]       141ns    161ns  5621778.        0B        0
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
#> 1 f0()         22.1ms   22.3ms      44.8    21.6KB     403.
#> 2 fp()         24.5ms   25.1ms      39.9    82.5KB     339.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 27.6ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     244ms    244ms      4.09        0B     35.5
#> 2 fp(1e+06)     263ms    296ms      3.38    1.88KB     25.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 51.5ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.43s    2.43s     0.412        0B     19.8
#> 2 fp(1e+07)     2.51s    2.51s     0.398    1.88KB     18.7
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 8ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.6s    23.6s    0.0424        0B     22.4
#> 2 fp(1e+08)     25.2s    25.2s    0.0397    1.88KB     20.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.2ns
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
#> 1 f0()         90.5ms   94.4ms      8.52     781KB    13.6 
#> 2 f01()         109ms  121.6ms      8.48     781KB    13.6 
#> 3 fp()        123.9ms  134.4ms      6.81     783KB     8.51
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 400ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  904.09ms 904.09ms     1.11     7.63MB     4.42
#> 2 f01(1e+06)    1.33s    1.33s     0.749    7.63MB     3.74
#> 3 fp(1e+06)      1.3s     1.3s     0.771    7.63MB     4.63
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 392ns
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
#> 1 f0()         78.7ms   79.2ms     12.5     1.44MB     9.39
#> 2 f01()        95.4ms   95.5ms     10.3    781.3KB     6.88
#> 3 fp()         99.4ms   99.9ms      9.92  783.24KB     6.61
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 208ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 44.6ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  925.19ms 925.19ms     1.08     7.63MB     2.16
#> 2 f01(1e+06)    1.16s    1.16s     0.860    7.63MB     2.58
#> 3 fp(1e+06)     1.19s    1.19s     0.839    7.63MB     2.52
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 267ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 29.5ns
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
#> 1 f0()        22.92ms     23ms    43.0      39.3KB     1.96
#> 2 fp()          4.01s    4.01s     0.249   100.8KB     2.24
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.9µs
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
#> 1 f0()        21.56ms  21.72ms    37.3      18.7KB     3.93
#> 2 ff()        30.65ms  31.22ms    30.1      27.6KB     1.88
#> 3 fp()          2.28s    2.28s     0.439    25.1KB     2.20
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 95ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   232.6ms  249.1ms    4.10          0B     4.10
#> 2 ff(1e+06)   337.4ms  956.5ms    1.05       1.9KB     1.05
#> 3 fp(1e+06)     22.1s    22.1s    0.0452     1.9KB     2.13
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.9µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 707ns
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
#> 1 test_baseline()   623.91ms 623.91ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.09KB        0
#> 4 test_cli_unroll() 623.77ms 623.77ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
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
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.11ms  6.3ms      156.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (500/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (79/s) | 39ms
#> ⠼ 4 done (88/s) | 46ms
#> ⠴ 5 done (95/s) | 53ms
#> ⠦ 6 done (100/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 75ms
#> ⠏ 9 done (110/s) | 83ms
#> ⠋ 10 done (112/s) | 90ms
#> ⠙ 11 done (114/s) | 97ms
#> ⠹ 12 done (115/s) | 105ms
#> ⠸ 13 done (117/s) | 112ms
#> ⠼ 14 done (115/s) | 123ms
#> ⠴ 15 done (116/s) | 130ms
#> ⠦ 16 done (117/s) | 137ms
#> ⠧ 17 done (118/s) | 145ms
#> ⠇ 18 done (119/s) | 152ms
#> ⠏ 19 done (120/s) | 159ms
#> ⠋ 20 done (121/s) | 167ms
#> ⠙ 21 done (121/s) | 174ms
#> ⠹ 22 done (122/s) | 181ms
#> ⠸ 23 done (122/s) | 189ms
#> ⠼ 24 done (123/s) | 196ms
#> ⠴ 25 done (123/s) | 203ms
#> ⠦ 26 done (124/s) | 211ms
#> ⠧ 27 done (124/s) | 218ms
#> ⠇ 28 done (124/s) | 226ms
#> ⠏ 29 done (125/s) | 233ms
#> ⠋ 30 done (125/s) | 240ms
#> ⠙ 31 done (125/s) | 248ms
#> ⠹ 32 done (126/s) | 255ms
#> ⠸ 33 done (126/s) | 262ms
#> ⠼ 34 done (126/s) | 270ms
#> ⠴ 35 done (127/s) | 277ms
#> ⠦ 36 done (127/s) | 285ms
#> ⠧ 37 done (127/s) | 292ms
#> ⠇ 38 done (127/s) | 299ms
#> ⠏ 39 done (127/s) | 307ms
#> ⠋ 40 done (128/s) | 314ms
#> ⠙ 41 done (128/s) | 322ms
#> ⠹ 42 done (128/s) | 329ms
#> ⠸ 43 done (128/s) | 336ms
#> ⠼ 44 done (128/s) | 344ms
#> ⠴ 45 done (128/s) | 351ms
#> ⠦ 46 done (128/s) | 359ms
#> ⠧ 47 done (129/s) | 366ms
#> ⠇ 48 done (129/s) | 373ms
#> ⠏ 49 done (129/s) | 381ms
#> ⠋ 50 done (129/s) | 388ms
#> ⠙ 51 done (129/s) | 395ms
#> ⠹ 52 done (129/s) | 403ms
#> ⠸ 53 done (129/s) | 411ms
#> ⠼ 54 done (129/s) | 419ms
#> ⠴ 55 done (129/s) | 426ms
#> ⠦ 56 done (129/s) | 433ms
#> ⠧ 57 done (130/s) | 441ms
#> ⠇ 58 done (130/s) | 448ms
#> ⠏ 59 done (130/s) | 456ms
#> ⠋ 60 done (130/s) | 463ms
#> ⠙ 61 done (130/s) | 471ms
#> ⠹ 62 done (130/s) | 478ms
#> ⠸ 63 done (130/s) | 485ms
#> ⠼ 64 done (130/s) | 493ms
#> ⠴ 65 done (130/s) | 500ms
#> ⠦ 66 done (130/s) | 508ms
#> ⠧ 67 done (130/s) | 515ms
#> ⠇ 68 done (130/s) | 522ms
#> ⠏ 69 done (130/s) | 530ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.21ms 7.36ms      135.     265KB     2.02
cli_progress_done()
```
