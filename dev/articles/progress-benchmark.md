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
#> 1 __cli_update_due              0     10ns 77828856.        0B        0
#> 2 fun()                  140.05ns  160.1ns  4265099.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    130ns  7598408.        0B        0
#> 4 interactive()            8.96ns   10.1ns 69138456.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 39.9ns 50.1ns 18128662.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6223294.        0B        0
#> 2 ta[[1]]       140ns    160ns  5704985.        0B        0
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
#> 1 f0()         26.5ms   26.6ms      37.6    21.6KB     282.
#> 2 fp()         28.5ms   28.5ms      35.1    82.5KB     526.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 19.3ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     293ms    294ms      3.40        0B     30.6
#> 2 fp(1e+06)     308ms    310ms      3.23     1.9KB     29.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 15.8ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.88s    2.88s     0.347        0B     16.3
#> 2 fp(1e+07)     2.91s    2.91s     0.344     1.9KB     16.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 2.42ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     28.3s    28.3s    0.0353        0B     18.4
#> 2 fp(1e+08)     29.5s    29.5s    0.0339     1.9KB     17.4
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 12.3ns
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
#> 1 f0()         95.8ms    108ms      8.92     781KB    19.6 
#> 2 f01()       108.7ms    119ms      5.63     781KB     9.39
#> 3 fp()        115.6ms    134ms      7.63     783KB     7.63
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 255ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.15s    1.15s     0.869    7.63MB     6.08
#> 2 f01(1e+06)    1.86s    1.86s     0.537    7.63MB     2.15
#> 3 fp(1e+06)     1.49s    1.49s     0.671    7.63MB     3.36
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 339ns
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
#> 1 f0()         81.8ms   83.3ms     12.0     1.44MB     6.01
#> 2 f01()        97.8ms   98.9ms      9.98   781.3KB     6.65
#> 3 fp()        101.4ms  103.3ms      9.70  783.26KB     6.47
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 200ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 43.2ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  948.49ms 948.49ms     1.05     7.63MB     3.16
#> 2 f01(1e+06)    1.19s    1.19s     0.841    7.63MB     2.52
#> 3 fp(1e+06)     1.58s    1.58s     0.632    7.63MB     2.53
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 634ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 393ns
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
#> 1 f0()        30.31ms  34.04ms    27.7      39.3KB     1.98
#> 2 fp()          4.62s    4.62s     0.216   100.8KB     3.03
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 45.9µs
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
#> 1 f0()        26.66ms  44.87ms    22.0      18.7KB     2.00
#> 2 ff()        38.07ms  56.11ms    16.9      27.6KB     3.75
#> 3 fp()          3.87s    3.87s     0.259    25.1KB     1.55
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 38.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 112ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   270.3ms  298.5ms    3.35          0B     3.35
#> 2 ff(1e+06)   368.7ms  369.7ms    2.70      1.91KB     2.70
#> 3 fp(1e+06)     23.4s    23.4s    0.0427    1.91KB     2.44
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.1µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 71.2ns
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
#> 1 test_baseline()    77.83ms  78.16ms    12.5      2.08KB        0
#> 2 test_modulo()        1.27s    1.27s     0.786    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.11KB        0
#> 4 test_cli_unroll()  78.64ms  79.09ms    12.4      3.58KB        0
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
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
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
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.85ms 7.14ms      134.    1.44MB     2.06
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (420/s) | 3ms
#> ⠹ 2 done (61/s) | 33ms
#> ⠸ 3 done (72/s) | 43ms
#> ⠼ 4 done (80/s) | 51ms
#> ⠴ 5 done (86/s) | 59ms
#> ⠦ 6 done (90/s) | 67ms
#> ⠧ 7 done (94/s) | 75ms
#> ⠇ 8 done (96/s) | 84ms
#> ⠏ 9 done (98/s) | 92ms
#> ⠋ 10 done (100/s) | 101ms
#> ⠙ 11 done (101/s) | 109ms
#> ⠹ 12 done (102/s) | 118ms
#> ⠸ 13 done (104/s) | 126ms
#> ⠼ 14 done (105/s) | 134ms
#> ⠴ 15 done (106/s) | 143ms
#> ⠦ 16 done (107/s) | 151ms
#> ⠧ 17 done (107/s) | 159ms
#> ⠇ 18 done (108/s) | 167ms
#> ⠏ 19 done (109/s) | 175ms
#> ⠋ 20 done (110/s) | 183ms
#> ⠙ 21 done (107/s) | 196ms
#> ⠹ 22 done (107/s) | 205ms
#> ⠸ 23 done (108/s) | 214ms
#> ⠼ 24 done (108/s) | 223ms
#> ⠴ 25 done (108/s) | 233ms
#> ⠦ 26 done (108/s) | 242ms
#> ⠧ 27 done (108/s) | 250ms
#> ⠇ 28 done (108/s) | 259ms
#> ⠏ 29 done (109/s) | 267ms
#> ⠋ 30 done (109/s) | 275ms
#> ⠙ 31 done (110/s) | 283ms
#> ⠹ 32 done (110/s) | 291ms
#> ⠸ 33 done (110/s) | 300ms
#> ⠼ 34 done (111/s) | 308ms
#> ⠴ 35 done (111/s) | 316ms
#> ⠦ 36 done (111/s) | 325ms
#> ⠧ 37 done (111/s) | 333ms
#> ⠇ 38 done (111/s) | 342ms
#> ⠏ 39 done (112/s) | 350ms
#> ⠋ 40 done (112/s) | 359ms
#> ⠙ 41 done (112/s) | 367ms
#> ⠹ 42 done (112/s) | 375ms
#> ⠸ 43 done (112/s) | 384ms
#> ⠼ 44 done (113/s) | 392ms
#> ⠴ 45 done (113/s) | 400ms
#> ⠦ 46 done (113/s) | 409ms
#> ⠧ 47 done (113/s) | 417ms
#> ⠇ 48 done (113/s) | 425ms
#> ⠏ 49 done (113/s) | 434ms
#> ⠋ 50 done (113/s) | 442ms
#> ⠙ 51 done (113/s) | 451ms
#> ⠹ 52 done (113/s) | 459ms
#> ⠸ 53 done (114/s) | 467ms
#> ⠼ 54 done (114/s) | 476ms
#> ⠴ 55 done (114/s) | 484ms
#> ⠦ 56 done (114/s) | 493ms
#> ⠧ 57 done (114/s) | 501ms
#> ⠇ 58 done (114/s) | 509ms
#> ⠏ 59 done (114/s) | 517ms
#> ⠋ 60 done (114/s) | 526ms
#> ⠙ 61 done (114/s) | 534ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.98ms 8.32ms      119.     265KB     2.02
cli_progress_done()
```
