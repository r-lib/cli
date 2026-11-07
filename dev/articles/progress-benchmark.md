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
#> 1 __cli_update_due            1ns     20ns 57904251.        0B        0
#> 2 fun()                  130.04ns    160ns  4469257.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    130ns  7644704.        0B        0
#> 4 interactive()            8.96ns     20ns 53861907.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 60.1ns 17158048.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    141ns  6582185.        0B        0
#> 2 ta[[1]]       130ns    151ns  5910231.        0B        0
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
#> 1 f0()         26.2ms   26.3ms      38.1    21.6KB     286.
#> 2 fp()         28.5ms   28.7ms      34.9    82.5KB     244.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 24.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     286ms    287ms      3.48        0B     29.6
#> 2 fp(1e+06)     304ms    307ms      3.26     1.9KB     29.3
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.3ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.87s    2.87s     0.348        0B     16.4
#> 2 fp(1e+07)     2.88s    2.88s     0.347     1.9KB     16.3
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
#> 1 f0(1e+08)     27.7s    27.7s    0.0360        0B     18.8
#> 2 fp(1e+08)       29s      29s    0.0345     1.9KB     17.7
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 12.5ns
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
#> 1 f0()           92ms   99.1ms      9.52     781KB    20.9 
#> 2 f01()         107ms  114.3ms      6.63     781KB     9.95
#> 3 fp()          125ms  126.9ms      7.67     783KB     7.67
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 277ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.11s    1.11s     0.899    7.63MB     6.29
#> 2 f01(1e+06)    1.99s    1.99s     0.504    7.63MB     4.03
#> 3 fp(1e+06)     2.46s    2.46s     0.407    7.63MB     2.03
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.34µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 472ns
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
#> 1 f0()         81.8ms   82.3ms     12.0     1.44MB     6.02
#> 2 f01()        98.5ms     99ms     10.0    781.3KB     2.50
#> 3 fp()        101.5ms    102ms      9.81  783.26KB     9.81
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 197ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 29ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  976.49ms 976.49ms     1.02     7.63MB     3.07
#> 2 f01(1e+06)    1.22s    1.22s     0.822    7.63MB     3.29
#> 3 fp(1e+06)     1.54s    1.54s     0.647    7.63MB     2.59
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 568ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 328ns
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
#> 1 f0()         27.2ms  27.45ms    36.2      39.3KB     1.91
#> 2 fp()          5.26s    5.26s     0.190   100.8KB     2.09
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 52.3µs
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
#> 1 f0()        25.52ms  25.66ms    38.4      18.7KB     3.84
#> 2 ff()           36ms  36.26ms    27.4      27.6KB     1.96
#> 3 fp()          2.28s    2.28s     0.439    25.1KB     2.63
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.5µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 106ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   260.7ms  262.2ms    3.81          0B     3.81
#> 2 ff(1e+06)   373.6ms  393.8ms    2.54      1.91KB     3.81
#> 3 fp(1e+06)     24.2s    24.2s    0.0413    1.91KB     2.44
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 24µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 132ns
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
#> 1 test_baseline()    77.84ms  78.01ms    12.8      2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.803    2.24KB        0
#> 3 test_cli()           1.24s    1.24s     0.804   24.11KB        0
#> 4 test_cli_unroll()  78.64ms  78.78ms    12.7      3.58KB        0
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
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 6.4ms 6.48ms      151.    1.44MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (476/s) | 3ms
#> ⠹ 2 done (69/s) | 30ms
#> ⠸ 3 done (81/s) | 38ms
#> ⠼ 4 done (89/s) | 45ms
#> ⠴ 5 done (96/s) | 53ms
#> ⠦ 6 done (100/s) | 60ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 76ms
#> ⠏ 9 done (109/s) | 83ms
#> ⠋ 10 done (111/s) | 91ms
#> ⠙ 11 done (113/s) | 98ms
#> ⠹ 12 done (114/s) | 106ms
#> ⠸ 13 done (115/s) | 113ms
#> ⠼ 14 done (117/s) | 121ms
#> ⠴ 15 done (118/s) | 128ms
#> ⠦ 16 done (118/s) | 136ms
#> ⠧ 17 done (119/s) | 143ms
#> ⠇ 18 done (120/s) | 151ms
#> ⠏ 19 done (121/s) | 158ms
#> ⠋ 20 done (121/s) | 166ms
#> ⠙ 21 done (122/s) | 173ms
#> ⠹ 22 done (122/s) | 181ms
#> ⠸ 23 done (123/s) | 188ms
#> ⠼ 24 done (123/s) | 196ms
#> ⠴ 25 done (123/s) | 203ms
#> ⠦ 26 done (124/s) | 211ms
#> ⠧ 27 done (124/s) | 218ms
#> ⠇ 28 done (124/s) | 226ms
#> ⠏ 29 done (125/s) | 233ms
#> ⠋ 30 done (125/s) | 241ms
#> ⠙ 31 done (125/s) | 248ms
#> ⠹ 32 done (125/s) | 256ms
#> ⠸ 33 done (126/s) | 263ms
#> ⠼ 34 done (126/s) | 271ms
#> ⠴ 35 done (126/s) | 278ms
#> ⠦ 36 done (126/s) | 286ms
#> ⠧ 37 done (126/s) | 293ms
#> ⠇ 38 done (127/s) | 301ms
#> ⠏ 39 done (127/s) | 308ms
#> ⠋ 40 done (127/s) | 316ms
#> ⠙ 41 done (127/s) | 323ms
#> ⠹ 42 done (127/s) | 331ms
#> ⠸ 43 done (127/s) | 338ms
#> ⠼ 44 done (128/s) | 346ms
#> ⠴ 45 done (128/s) | 353ms
#> ⠦ 46 done (127/s) | 364ms
#> ⠧ 47 done (127/s) | 372ms
#> ⠇ 48 done (127/s) | 379ms
#> ⠏ 49 done (127/s) | 387ms
#> ⠋ 50 done (127/s) | 394ms
#> ⠙ 51 done (127/s) | 402ms
#> ⠹ 52 done (127/s) | 409ms
#> ⠸ 53 done (127/s) | 417ms
#> ⠼ 54 done (127/s) | 424ms
#> ⠴ 55 done (127/s) | 432ms
#> ⠦ 56 done (128/s) | 440ms
#> ⠧ 57 done (128/s) | 447ms
#> ⠇ 58 done (128/s) | 455ms
#> ⠏ 59 done (128/s) | 462ms
#> ⠋ 60 done (128/s) | 470ms
#> ⠙ 61 done (128/s) | 477ms
#> ⠹ 62 done (128/s) | 485ms
#> ⠸ 63 done (128/s) | 492ms
#> ⠼ 64 done (128/s) | 500ms
#> ⠴ 65 done (128/s) | 507ms
#> ⠦ 66 done (128/s) | 515ms
#> ⠧ 67 done (128/s) | 522ms
#> ⠇ 68 done (128/s) | 530ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.42ms 7.51ms      133.     265KB     2.01
cli_progress_done()
```
