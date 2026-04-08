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
#> 1 __cli_update_due           12ns     17ns 59359976.        0B        0
#> 2 fun()                     120ns    131ns  5127034.        0B        0
#> 3 .Call(ccli_tick_reset)    118ns    128ns  7579806.        0B        0
#> 4 interactive()              17ns     24ns 39590243.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 42.1ns   52ns 18670077.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      114ns    125ns  7283573.        0B       0 
#> 2 ta[[1]]       118ns    132ns  5959664.        0B     596.
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
#> 1 f0()         20.6ms   20.6ms      48.3    21.6KB     290.
#> 2 fp()         23.4ms   23.4ms      41.7    82.3KB     223.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     228ms    229ms      4.34        0B     36.2
#> 2 fp(1e+06)     249ms    282ms      3.55    1.88KB     28.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 52.5ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.35s    2.35s     0.425        0B     35.7
#> 2 fp(1e+07)     2.45s    2.45s     0.409    1.88KB     34.3
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 9.47ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)       22s      22s    0.0455        0B     22.1
#> 2 fp(1e+08)     23.8s    23.8s    0.0419    1.88KB     20.3
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.5ns
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
#> 1 f0()         78.7ms   85.8ms     11.5      781KB     13.5
#> 2 f01()       102.7ms  110.9ms      8.56     781KB     13.7
#> 3 fp()        110.9ms  121.2ms      7.88     783KB     12.6
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 354ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  849.26ms 849.26ms     1.18     7.63MB     4.71
#> 2 f01(1e+06)    1.19s    1.19s     0.842    7.63MB     4.21
#> 3 fp(1e+06)     1.26s    1.26s     0.790    7.63MB     4.74
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 416ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 77.8ns
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
#> 1 f0()         68.1ms   68.9ms      14.5    1.41MB     10.9
#> 2 f01()        78.9ms   79.2ms      12.6   781.3KB     12.6
#> 3 fp()         81.2ms   84.3ms      11.9  783.24KB     23.7
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 154ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 51.5ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  789.97ms 789.97ms     1.27     7.63MB     2.53
#> 2 f01(1e+06)    1.04s    1.04s     0.960    7.63MB     3.84
#> 3 fp(1e+06)     1.36s    1.36s     0.738    7.63MB     3.69
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 566ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 314ns
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
#> 1 f0()         20.9ms  21.02ms    46.4      39.3KB     3.87
#> 2 fp()          3.67s    3.67s     0.273   100.4KB     3.00
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 36.5µs
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
#> 1 f0()         19.4ms  19.66ms    48.3      18.7KB     5.80
#> 2 ff()         29.2ms  29.38ms    33.3      27.6KB     1.96
#> 3 fp()          2.01s    2.01s     0.496    25.1KB     2.98
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 19.9µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 97.2ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   198.5ms  217.5ms    4.43          0B     4.43
#> 2 ff(1e+06)   298.8ms  300.1ms    3.33       1.9KB     3.33
#> 3 fp(1e+06)     20.2s    20.2s    0.0494     1.9KB     2.87
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 20µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 82.5ns
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
#> 1 test_baseline()   919.92ms 919.92ms     1.09     2.08KB        0
#> 2 test_modulo()        1.56s    1.56s     0.640    2.24KB        0
#> 3 test_cli()           1.15s    1.15s     0.867    23.9KB        0
#> 4 test_cli_unroll()    917ms    917ms     1.09     3.56KB        0
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
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.14ms 6.25ms      156.     1.4MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (495/s) | 3ms
#> ⠹ 2 done (71/s) | 29ms
#> ⠸ 3 done (84/s) | 36ms
#> ⠼ 4 done (93/s) | 44ms
#> ⠴ 5 done (100/s) | 51ms
#> ⠦ 6 done (104/s) | 58ms
#> ⠧ 7 done (108/s) | 65ms
#> ⠇ 8 done (111/s) | 72ms
#> ⠏ 9 done (114/s) | 80ms
#> ⠋ 10 done (116/s) | 87ms
#> ⠙ 11 done (118/s) | 94ms
#> ⠹ 12 done (119/s) | 101ms
#> ⠸ 13 done (121/s) | 108ms
#> ⠼ 14 done (122/s) | 116ms
#> ⠴ 15 done (123/s) | 123ms
#> ⠦ 16 done (124/s) | 130ms
#> ⠧ 17 done (125/s) | 137ms
#> ⠇ 18 done (125/s) | 144ms
#> ⠏ 19 done (126/s) | 152ms
#> ⠋ 20 done (127/s) | 159ms
#> ⠙ 21 done (127/s) | 166ms
#> ⠹ 22 done (128/s) | 173ms
#> ⠸ 23 done (128/s) | 180ms
#> ⠼ 24 done (128/s) | 188ms
#> ⠴ 25 done (129/s) | 195ms
#> ⠦ 26 done (129/s) | 202ms
#> ⠧ 27 done (129/s) | 209ms
#> ⠇ 28 done (130/s) | 216ms
#> ⠏ 29 done (130/s) | 224ms
#> ⠋ 30 done (130/s) | 231ms
#> ⠙ 31 done (131/s) | 238ms
#> ⠹ 32 done (131/s) | 245ms
#> ⠸ 33 done (131/s) | 253ms
#> ⠼ 34 done (131/s) | 260ms
#> ⠴ 35 done (131/s) | 267ms
#> ⠦ 36 done (132/s) | 274ms
#> ⠧ 37 done (132/s) | 282ms
#> ⠇ 38 done (132/s) | 289ms
#> ⠏ 39 done (132/s) | 296ms
#> ⠋ 40 done (132/s) | 303ms
#> ⠙ 41 done (132/s) | 310ms
#> ⠹ 42 done (132/s) | 318ms
#> ⠸ 43 done (133/s) | 325ms
#> ⠼ 44 done (133/s) | 332ms
#> ⠴ 45 done (131/s) | 344ms
#> ⠦ 46 done (131/s) | 352ms
#> ⠧ 47 done (131/s) | 359ms
#> ⠇ 48 done (131/s) | 367ms
#> ⠏ 49 done (131/s) | 375ms
#> ⠋ 50 done (131/s) | 383ms
#> ⠙ 51 done (131/s) | 391ms
#> ⠹ 52 done (131/s) | 398ms
#> ⠸ 53 done (131/s) | 406ms
#> ⠼ 54 done (131/s) | 413ms
#> ⠴ 55 done (131/s) | 420ms
#> ⠦ 56 done (131/s) | 428ms
#> ⠧ 57 done (131/s) | 435ms
#> ⠇ 58 done (131/s) | 442ms
#> ⠏ 59 done (131/s) | 449ms
#> ⠋ 60 done (132/s) | 457ms
#> ⠙ 61 done (132/s) | 464ms
#> ⠹ 62 done (132/s) | 471ms
#> ⠸ 63 done (132/s) | 478ms
#> ⠼ 64 done (132/s) | 486ms
#> ⠴ 65 done (132/s) | 493ms
#> ⠦ 66 done (132/s) | 500ms
#> ⠧ 67 done (132/s) | 507ms
#> ⠇ 68 done (132/s) | 514ms
#> ⠏ 69 done (132/s) | 522ms
#> ⠋ 70 done (133/s) | 529ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.11ms 7.21ms      137.     265KB     2.02
cli_progress_done()
```
