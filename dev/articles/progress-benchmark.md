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
#> 1 __cli_update_due              0   10.1ns 93596323.        0B        0
#> 2 fun()                  130.04ns  150.1ns  4852357.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    120ns  8210996.        0B        0
#> 4 interactive()            8.96ns   10.1ns 65570218.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20294695.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6256991.        0B        0
#> 2 ta[[1]]       150ns    161ns  5677178.        0B        0
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
#> 1 f0()           22ms   22.1ms      45.3    21.6KB     408.
#> 2 fp()         24.4ms   24.8ms      40.3    82.5KB     342.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 27.7ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     237ms    239ms      4.20        0B     36.4
#> 2 fp(1e+06)     258ms    287ms      3.48    1.88KB     26.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 48.6ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.37s    2.37s     0.421        0B     20.2
#> 2 fp(1e+07)     2.49s    2.49s     0.402    1.88KB     18.9
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 11.4ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.3s    23.3s    0.0429        0B     22.6
#> 2 fp(1e+08)       25s      25s    0.0401    1.88KB     21.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.4ns
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
#> 1 f0()         90.4ms   91.5ms      8.58     781KB    13.7 
#> 2 f01()       108.9ms  121.2ms      8.49     781KB    13.6 
#> 3 fp()        122.1ms  130.7ms      6.90     783KB     8.63
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 392ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  903.65ms 903.65ms     1.11     7.63MB     4.43
#> 2 f01(1e+06)    1.27s    1.27s     0.785    7.63MB     3.14
#> 3 fp(1e+06)     1.28s    1.28s     0.778    7.63MB     4.67
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 381ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 10.8ns
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
#> 1 f0()         79.2ms   79.7ms      12.5    1.44MB     9.34
#> 2 f01()        95.8ms   96.7ms      10.2   781.3KB     6.82
#> 3 fp()         98.4ms   98.6ms      10.0  783.24KB     6.67
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 189ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 18.9ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  971.92ms 971.92ms     1.03     7.63MB     4.12
#> 2 f01(1e+06)    1.41s    1.41s     0.709    7.63MB     3.55
#> 3 fp(1e+06)     2.98s    2.98s     0.336    7.63MB     1.68
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 2µs
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 1.57µs
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
#> 1 f0()        23.24ms  23.37ms    41.8      39.3KB     1.99
#> 2 fp()          3.96s    3.96s     0.252   100.8KB     1.77
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.4µs
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
#> 1 f0()        21.37ms  24.94ms    39.3      18.7KB     3.93
#> 2 ff()        30.57ms  30.73ms    31.2      27.6KB     1.95
#> 3 fp()          2.33s    2.33s     0.430    25.1KB     1.29
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 57.9ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   232.3ms  236.4ms    4.18          0B     2.79
#> 2 ff(1e+06)   315.6ms  318.9ms    3.14       1.9KB     1.57
#> 3 fp(1e+06)     23.2s    23.2s    0.0431     1.9KB     1.51
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 82.4ns
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
#> 1 test_baseline()   626.47ms 626.47ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.09KB        0
#> 4 test_cli_unroll() 623.72ms 623.72ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 22m
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
#> 1 cli_progress_update(force… 6.14ms 6.31ms      156.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (511/s) | 3ms
#> ⠹ 2 done (66/s) | 31ms
#> ⠸ 3 done (79/s) | 39ms
#> ⠼ 4 done (88/s) | 46ms
#> ⠴ 5 done (94/s) | 54ms
#> ⠦ 6 done (100/s) | 61ms
#> ⠧ 7 done (103/s) | 68ms
#> ⠇ 8 done (107/s) | 76ms
#> ⠏ 9 done (109/s) | 83ms
#> ⠋ 10 done (111/s) | 91ms
#> ⠙ 11 done (113/s) | 98ms
#> ⠹ 12 done (115/s) | 105ms
#> ⠸ 13 done (116/s) | 113ms
#> ⠼ 14 done (117/s) | 120ms
#> ⠴ 15 done (118/s) | 127ms
#> ⠦ 16 done (119/s) | 135ms
#> ⠧ 17 done (120/s) | 142ms
#> ⠇ 18 done (121/s) | 150ms
#> ⠏ 19 done (121/s) | 157ms
#> ⠋ 20 done (122/s) | 164ms
#> ⠙ 21 done (123/s) | 172ms
#> ⠹ 22 done (123/s) | 179ms
#> ⠸ 23 done (124/s) | 186ms
#> ⠼ 24 done (124/s) | 194ms
#> ⠴ 25 done (125/s) | 201ms
#> ⠦ 26 done (125/s) | 209ms
#> ⠧ 27 done (125/s) | 216ms
#> ⠇ 28 done (126/s) | 223ms
#> ⠏ 29 done (126/s) | 231ms
#> ⠋ 30 done (126/s) | 238ms
#> ⠙ 31 done (127/s) | 246ms
#> ⠹ 32 done (127/s) | 253ms
#> ⠸ 33 done (127/s) | 260ms
#> ⠼ 34 done (127/s) | 268ms
#> ⠴ 35 done (128/s) | 275ms
#> ⠦ 36 done (128/s) | 282ms
#> ⠧ 37 done (128/s) | 290ms
#> ⠇ 38 done (128/s) | 297ms
#> ⠏ 39 done (128/s) | 305ms
#> ⠋ 40 done (128/s) | 312ms
#> ⠙ 41 done (129/s) | 320ms
#> ⠹ 42 done (129/s) | 327ms
#> ⠸ 43 done (129/s) | 334ms
#> ⠼ 44 done (129/s) | 342ms
#> ⠴ 45 done (129/s) | 349ms
#> ⠦ 46 done (128/s) | 361ms
#> ⠧ 47 done (128/s) | 368ms
#> ⠇ 48 done (128/s) | 376ms
#> ⠏ 49 done (128/s) | 383ms
#> ⠋ 50 done (128/s) | 390ms
#> ⠙ 51 done (129/s) | 397ms
#> ⠹ 52 done (129/s) | 405ms
#> ⠸ 53 done (129/s) | 412ms
#> ⠼ 54 done (129/s) | 419ms
#> ⠴ 55 done (129/s) | 427ms
#> ⠦ 56 done (129/s) | 434ms
#> ⠧ 57 done (129/s) | 442ms
#> ⠇ 58 done (129/s) | 449ms
#> ⠏ 59 done (129/s) | 457ms
#> ⠋ 60 done (129/s) | 464ms
#> ⠙ 61 done (130/s) | 472ms
#> ⠹ 62 done (130/s) | 479ms
#> ⠸ 63 done (130/s) | 486ms
#> ⠼ 64 done (130/s) | 494ms
#> ⠴ 65 done (130/s) | 501ms
#> ⠦ 66 done (130/s) | 509ms
#> ⠧ 67 done (130/s) | 516ms
#> ⠇ 68 done (130/s) | 523ms
#> ⠏ 69 done (130/s) | 531ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.19ms 7.37ms      135.     265KB     2.02
cli_progress_done()
```
