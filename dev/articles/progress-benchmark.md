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
#> 1 __cli_update_due              0     10ns 87990981.        0B        0
#> 2 fun()                  130.04ns    161ns  4255057.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    130ns  7515464.        0B        0
#> 4 interactive()            8.96ns   11.1ns 66521912.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20463880.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6323424.        0B        0
#> 2 ta[[1]]       140ns    160ns  5787218.        0B        0
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
#> 1 f0()         22.5ms   22.6ms      44.3    21.6KB     376.
#> 2 fp()         25.5ms   25.8ms      38.8    82.5KB     310.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 32.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     258ms    258ms      3.88        0B     34.9
#> 2 fp(1e+06)     273ms    276ms      3.62     1.9KB     30.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 18.3ns
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
#> 2 fp(1e+07)     2.57s    2.57s     0.389     1.9KB     18.7
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 6.76ns
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
#> 2 fp(1e+08)     25.7s    25.7s    0.0389     1.9KB     20.2
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
#> 1 f0()         92.1ms    109ms      7.64     781KB     16.8
#> 2 f01()       104.1ms    110ms      8.92     781KB     10.7
#> 3 fp()        122.1ms    133ms      6.76     783KB     10.1
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 239ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  971.14ms 971.14ms     1.03     7.63MB     7.21
#> 2 f01(1e+06)    1.44s    1.44s     0.696    7.63MB     4.87
#> 3 fp(1e+06)     2.13s    2.13s     0.470    7.63MB     3.76
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.16µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 690ns
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
#> 1 f0()         81.2ms   83.7ms     11.9     1.44MB     23.9
#> 2 f01()       100.6ms  100.6ms      9.94   781.3KB     39.8
#> 3 fp()        128.5ms  128.5ms      7.78  783.26KB     23.3
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 448ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 280ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   893.7ms  893.7ms     1.12     7.63MB     2.24
#> 2 f01(1e+06)    1.14s    1.14s     0.874    7.63MB     2.62
#> 3 fp(1e+06)      1.2s     1.2s     0.833    7.63MB     2.50
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 306ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 56ns
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
#> 1 f0()        22.65ms  22.86ms    42.9      39.3KB     1.95
#> 2 fp()          4.03s    4.03s     0.248   100.8KB     1.98
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 40.1µs
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
#> 1 f0()        21.72ms  21.94ms    43.0      18.7KB     3.91
#> 2 ff()        31.64ms  32.26ms    29.7      27.6KB     1.98
#> 3 fp()          2.25s    2.25s     0.444    25.1KB     1.77
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.3µs
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
#> 1 f0(1e+06)   229.9ms  247.5ms    4.03          0B     4.03
#> 2 ff(1e+06)   318.2ms  325.7ms    3.07      1.91KB     1.54
#> 3 fp(1e+06)     23.7s    23.7s    0.0422    1.91KB     1.90
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 78.2ns
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
#> 1 test_baseline()   622.85ms 622.85ms     1.61     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.798    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.11KB        0
#> 4 test_cli_unroll() 623.91ms 623.91ms     1.60     3.58KB        0
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
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.37ms 6.47ms      152.    1.42MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (496/s) | 3ms
#> ⠹ 2 done (68/s) | 30ms
#> ⠸ 3 done (81/s) | 38ms
#> ⠼ 4 done (90/s) | 45ms
#> ⠴ 5 done (96/s) | 53ms
#> ⠦ 6 done (101/s) | 60ms
#> ⠧ 7 done (105/s) | 67ms
#> ⠇ 8 done (108/s) | 75ms
#> ⠏ 9 done (110/s) | 82ms
#> ⠋ 10 done (112/s) | 90ms
#> ⠙ 11 done (114/s) | 97ms
#> ⠹ 12 done (115/s) | 105ms
#> ⠸ 13 done (117/s) | 112ms
#> ⠼ 14 done (118/s) | 119ms
#> ⠴ 15 done (119/s) | 127ms
#> ⠦ 16 done (120/s) | 134ms
#> ⠧ 17 done (120/s) | 142ms
#> ⠇ 18 done (121/s) | 149ms
#> ⠏ 19 done (122/s) | 157ms
#> ⠋ 20 done (122/s) | 164ms
#> ⠙ 21 done (123/s) | 172ms
#> ⠹ 22 done (123/s) | 179ms
#> ⠸ 23 done (124/s) | 187ms
#> ⠼ 24 done (124/s) | 194ms
#> ⠴ 25 done (125/s) | 201ms
#> ⠦ 26 done (125/s) | 209ms
#> ⠧ 27 done (125/s) | 216ms
#> ⠇ 28 done (125/s) | 224ms
#> ⠏ 29 done (126/s) | 231ms
#> ⠋ 30 done (126/s) | 239ms
#> ⠙ 31 done (124/s) | 250ms
#> ⠹ 32 done (125/s) | 258ms
#> ⠸ 33 done (125/s) | 265ms
#> ⠼ 34 done (125/s) | 273ms
#> ⠴ 35 done (125/s) | 280ms
#> ⠦ 36 done (125/s) | 288ms
#> ⠧ 37 done (126/s) | 295ms
#> ⠇ 38 done (126/s) | 303ms
#> ⠏ 39 done (126/s) | 310ms
#> ⠋ 40 done (126/s) | 318ms
#> ⠙ 41 done (126/s) | 325ms
#> ⠹ 42 done (127/s) | 333ms
#> ⠸ 43 done (127/s) | 340ms
#> ⠼ 44 done (127/s) | 347ms
#> ⠴ 45 done (127/s) | 355ms
#> ⠦ 46 done (127/s) | 363ms
#> ⠧ 47 done (127/s) | 370ms
#> ⠇ 48 done (127/s) | 378ms
#> ⠏ 49 done (127/s) | 385ms
#> ⠋ 50 done (128/s) | 393ms
#> ⠙ 51 done (128/s) | 400ms
#> ⠹ 52 done (128/s) | 408ms
#> ⠸ 53 done (128/s) | 415ms
#> ⠼ 54 done (128/s) | 423ms
#> ⠴ 55 done (128/s) | 430ms
#> ⠦ 56 done (128/s) | 437ms
#> ⠧ 57 done (128/s) | 445ms
#> ⠇ 58 done (128/s) | 452ms
#> ⠏ 59 done (129/s) | 460ms
#> ⠋ 60 done (129/s) | 467ms
#> ⠙ 61 done (129/s) | 474ms
#> ⠹ 62 done (129/s) | 482ms
#> ⠸ 63 done (129/s) | 489ms
#> ⠼ 64 done (129/s) | 497ms
#> ⠴ 65 done (129/s) | 504ms
#> ⠦ 66 done (129/s) | 512ms
#> ⠧ 67 done (129/s) | 519ms
#> ⠇ 68 done (129/s) | 526ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.32ms 7.44ms      134.     265KB     2.03
cli_progress_done()
```
