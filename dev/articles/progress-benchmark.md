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
#> 1 __cli_update_due              0     10ns 89396262.        0B        0
#> 2 fun()                  130.04ns  160.1ns  4432502.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns  121.1ns  7612236.        0B        0
#> 4 interactive()            8.96ns   10.1ns 65162540.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns   51ns 17817512.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    150ns  6413059.        0B        0
#> 2 ta[[1]]       140ns    161ns  5621127.        0B        0
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
#> 1 f0()         26.3ms   26.4ms      37.9    21.6KB     284.
#> 2 fp()         28.7ms   28.7ms      34.8    82.5KB     522.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 23.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     284ms    285ms      3.51        0B     31.5
#> 2 fp(1e+06)     305ms    306ms      3.27     1.9KB     29.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 20.4ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.89s    2.89s     0.346        0B     16.2
#> 2 fp(1e+07)     2.95s    2.95s     0.339     1.9KB     15.9
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 5.99ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     28.1s    28.1s    0.0356        0B     18.6
#> 2 fp(1e+08)     29.7s    29.7s    0.0337     1.9KB     17.3
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.1ns
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
#> 1 f0()         96.3ms    112ms      8.61     781KB    18.9 
#> 2 f01()       111.2ms    121ms      5.72     781KB     9.54
#> 3 fp()          119ms    138ms      7.31     783KB     7.31
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 267ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.16s    1.16s     0.864    7.63MB     6.05
#> 2 f01(1e+06)    1.87s    1.87s     0.536    7.63MB     2.14
#> 3 fp(1e+06)     1.48s    1.48s     0.675    7.63MB     3.37
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 324ns
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
#> 1 f0()         82.1ms   83.5ms     12.0     1.44MB     5.99
#> 2 f01()        98.5ms   99.8ms      9.91   781.3KB     6.61
#> 3 fp()        101.9ms  104.4ms      9.64  783.26KB     6.43
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 209ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 45.7ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  931.64ms 931.64ms     1.07     7.63MB     2.15
#> 2 f01(1e+06)    1.24s    1.24s     0.806    7.63MB     3.22
#> 3 fp(1e+06)     1.59s    1.59s     0.628    7.63MB     2.51
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 661ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 352ns
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
#> 1 f0()           30ms   33.1ms    27.7      39.3KB     3.69
#> 2 fp()           4.7s     4.7s     0.213   100.8KB     2.77
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 46.7µs
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
#> 1 f0()         32.8ms   47.2ms    21.3      18.7KB     3.87
#> 2 ff()         42.1ms   58.6ms    17.6      27.6KB     1.96
#> 3 fp()           3.9s     3.9s     0.256    25.1KB     1.54
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 38.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 114ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   275.5ms  305.4ms    3.27          0B     3.27
#> 2 ff(1e+06)   373.9ms  377.3ms    2.65      1.91KB     2.65
#> 3 fp(1e+06)     23.8s    23.8s    0.0420    1.91KB     2.39
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 71.9ns
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
#> 1 test_baseline()    77.76ms  78.04ms    12.8      2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.802    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.11KB        0
#> 4 test_cli_unroll()  78.76ms  78.97ms    12.7      3.58KB        0
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
#> ■                                  0% | ETA:  5m
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
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
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
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
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
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.48ms 6.71ms      145.    1.44MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (469/s) | 3ms
#> ⠹ 2 done (67/s) | 31ms
#> ⠸ 3 done (78/s) | 39ms
#> ⠼ 4 done (86/s) | 47ms
#> ⠴ 5 done (93/s) | 55ms
#> ⠦ 6 done (97/s) | 63ms
#> ⠧ 7 done (100/s) | 70ms
#> ⠇ 8 done (103/s) | 78ms
#> ⠏ 9 done (105/s) | 86ms
#> ⠋ 10 done (107/s) | 94ms
#> ⠙ 11 done (109/s) | 101ms
#> ⠹ 12 done (111/s) | 109ms
#> ⠸ 13 done (112/s) | 117ms
#> ⠼ 14 done (113/s) | 124ms
#> ⠴ 15 done (114/s) | 132ms
#> ⠦ 16 done (115/s) | 140ms
#> ⠧ 17 done (116/s) | 148ms
#> ⠇ 18 done (116/s) | 155ms
#> ⠏ 19 done (117/s) | 163ms
#> ⠋ 20 done (118/s) | 170ms
#> ⠙ 21 done (118/s) | 178ms
#> ⠹ 22 done (119/s) | 186ms
#> ⠸ 23 done (119/s) | 193ms
#> ⠼ 24 done (120/s) | 201ms
#> ⠴ 25 done (120/s) | 208ms
#> ⠦ 26 done (120/s) | 216ms
#> ⠧ 27 done (121/s) | 224ms
#> ⠇ 28 done (121/s) | 232ms
#> ⠏ 29 done (121/s) | 239ms
#> ⠋ 30 done (122/s) | 247ms
#> ⠙ 31 done (122/s) | 255ms
#> ⠹ 32 done (120/s) | 267ms
#> ⠸ 33 done (120/s) | 276ms
#> ⠼ 34 done (120/s) | 284ms
#> ⠴ 35 done (120/s) | 293ms
#> ⠦ 36 done (120/s) | 301ms
#> ⠧ 37 done (120/s) | 310ms
#> ⠇ 38 done (119/s) | 319ms
#> ⠏ 39 done (120/s) | 326ms
#> ⠋ 40 done (120/s) | 334ms
#> ⠙ 41 done (120/s) | 342ms
#> ⠹ 42 done (120/s) | 350ms
#> ⠸ 43 done (121/s) | 357ms
#> ⠼ 44 done (121/s) | 365ms
#> ⠴ 45 done (121/s) | 373ms
#> ⠦ 46 done (121/s) | 380ms
#> ⠧ 47 done (121/s) | 388ms
#> ⠇ 48 done (121/s) | 396ms
#> ⠏ 49 done (122/s) | 404ms
#> ⠋ 50 done (122/s) | 412ms
#> ⠙ 51 done (122/s) | 419ms
#> ⠹ 52 done (122/s) | 427ms
#> ⠸ 53 done (122/s) | 435ms
#> ⠼ 54 done (122/s) | 443ms
#> ⠴ 55 done (122/s) | 451ms
#> ⠦ 56 done (122/s) | 459ms
#> ⠧ 57 done (122/s) | 467ms
#> ⠇ 58 done (122/s) | 474ms
#> ⠏ 59 done (123/s) | 482ms
#> ⠋ 60 done (123/s) | 490ms
#> ⠙ 61 done (123/s) | 497ms
#> ⠹ 62 done (123/s) | 505ms
#> ⠸ 63 done (123/s) | 513ms
#> ⠼ 64 done (123/s) | 521ms
#> ⠴ 65 done (123/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.58ms  7.7ms      128.     265KB     2.03
cli_progress_done()
```
