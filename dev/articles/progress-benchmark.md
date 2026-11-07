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
#> 1 __cli_update_due              0   10.1ns 72414094.        0B        0
#> 2 fun()                  130.04ns  150.1ns  4266145.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns  121.1ns  7412907.        0B        0
#> 4 interactive()            8.96ns   11.1ns 62047575.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 18124703.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    141ns  6225027.        0B        0
#> 2 ta[[1]]       150ns    171ns  4823394.        0B        0
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
#> 1 f0()         27.2ms   27.4ms      36.5    21.6KB     256.
#> 2 fp()         30.2ms   30.2ms      33.1    82.5KB     464.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 27.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     315ms    317ms      3.15        0B     28.4
#> 2 fp(1e+06)     331ms    332ms      3.01     1.9KB     25.6
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 15.4ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     3.03s    3.03s     0.330        0B     15.5
#> 2 fp(1e+07)     3.03s    3.03s     0.330     1.9KB     15.5
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
#> 1 f0(1e+08)     29.6s    29.6s    0.0338        0B     17.7
#> 2 fp(1e+08)     31.2s    31.2s    0.0321     1.9KB     16.4
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
#> 1 f0()          106ms    124ms      7.82     781KB    17.2 
#> 2 f01()         124ms    131ms      4.82     781KB     8.04
#> 3 fp()          127ms    131ms      7.66     783KB     7.66
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 71.1ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.26s    1.26s     0.793    7.63MB     5.55
#> 2 f01(1e+06)    3.48s    3.48s     0.287    7.63MB     2.30
#> 3 fp(1e+06)      1.3s     1.3s     0.772    7.63MB     2.32
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 35.3ns
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
#> 1 f0()         82.8ms   83.5ms     11.7     1.44MB     5.86
#> 2 f01()        99.8ms  101.4ms      9.53   781.3KB     2.38
#> 3 fp()        103.1ms  105.4ms      9.28  783.26KB     2.32
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 219ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 40.1ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  995.35ms 995.35ms     1.00     7.63MB     2.01
#> 2 f01(1e+06)    1.16s    1.16s     0.863    7.63MB     1.73
#> 3 fp(1e+06)     1.31s    1.31s     0.763    7.63MB     2.29
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 316ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 153ns
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
#> 1 f0()        27.63ms  27.97ms    34.7      39.3KB     1.93
#> 2 fp()          4.36s    4.36s     0.230   100.8KB     1.84
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 43.3µs
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
#> 1 f0()        26.36ms  26.55ms    37.0      18.7KB     1.95
#> 2 ff()        37.27ms  37.94ms    22.7      27.6KB     1.90
#> 3 fp()          2.35s    2.35s     0.426    25.1KB     1.70
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.2µs
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
#> 1 f0(1e+06)     274ms    283ms    3.53          0B     1.77
#> 2 ff(1e+06)     373ms    383ms    2.61      1.91KB     2.61
#> 3 fp(1e+06)       25s      25s    0.0400    1.91KB     1.68
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 24.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 100ns
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
#> 1 test_baseline()    95.08ms 103.32ms     9.94     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.801   24.11KB        0
#> 4 test_cli_unroll()  78.94ms  88.21ms    11.3      3.58KB        0
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
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
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
#> ■                                  0% | ETA: 16m
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
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.82ms 7.15ms      138.    1.44MB     2.05
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (392/s) | 3ms
#> ⠹ 2 done (61/s) | 33ms
#> ⠸ 3 done (72/s) | 42ms
#> ⠼ 4 done (80/s) | 51ms
#> ⠴ 5 done (86/s) | 59ms
#> ⠦ 6 done (90/s) | 67ms
#> ⠧ 7 done (94/s) | 75ms
#> ⠇ 8 done (96/s) | 84ms
#> ⠏ 9 done (99/s) | 92ms
#> ⠋ 10 done (100/s) | 100ms
#> ⠙ 11 done (101/s) | 109ms
#> ⠹ 12 done (102/s) | 118ms
#> ⠸ 13 done (102/s) | 128ms
#> ⠼ 14 done (104/s) | 136ms
#> ⠴ 15 done (105/s) | 144ms
#> ⠦ 16 done (106/s) | 152ms
#> ⠧ 17 done (107/s) | 160ms
#> ⠇ 18 done (108/s) | 168ms
#> ⠏ 19 done (108/s) | 176ms
#> ⠋ 20 done (109/s) | 184ms
#> ⠙ 21 done (109/s) | 193ms
#> ⠹ 22 done (110/s) | 201ms
#> ⠸ 23 done (110/s) | 209ms
#> ⠼ 24 done (111/s) | 217ms
#> ⠴ 25 done (111/s) | 225ms
#> ⠦ 26 done (112/s) | 233ms
#> ⠧ 27 done (112/s) | 242ms
#> ⠇ 28 done (112/s) | 250ms
#> ⠏ 29 done (113/s) | 258ms
#> ⠋ 30 done (113/s) | 266ms
#> ⠙ 31 done (113/s) | 275ms
#> ⠹ 32 done (113/s) | 283ms
#> ⠸ 33 done (113/s) | 292ms
#> ⠼ 34 done (114/s) | 300ms
#> ⠴ 35 done (114/s) | 308ms
#> ⠦ 36 done (114/s) | 317ms
#> ⠧ 37 done (114/s) | 325ms
#> ⠇ 38 done (114/s) | 333ms
#> ⠏ 39 done (115/s) | 341ms
#> ⠋ 40 done (115/s) | 349ms
#> ⠙ 41 done (115/s) | 357ms
#> ⠹ 42 done (115/s) | 365ms
#> ⠸ 43 done (116/s) | 373ms
#> ⠼ 44 done (116/s) | 381ms
#> ⠴ 45 done (116/s) | 389ms
#> ⠦ 46 done (116/s) | 397ms
#> ⠧ 47 done (116/s) | 406ms
#> ⠇ 48 done (116/s) | 414ms
#> ⠏ 49 done (116/s) | 422ms
#> ⠋ 50 done (117/s) | 430ms
#> ⠙ 51 done (117/s) | 438ms
#> ⠹ 52 done (117/s) | 446ms
#> ⠸ 53 done (117/s) | 454ms
#> ⠼ 54 done (117/s) | 462ms
#> ⠴ 55 done (117/s) | 471ms
#> ⠦ 56 done (117/s) | 479ms
#> ⠧ 57 done (117/s) | 488ms
#> ⠇ 58 done (117/s) | 496ms
#> ⠏ 59 done (117/s) | 505ms
#> ⠋ 60 done (117/s) | 513ms
#> ⠙ 61 done (117/s) | 521ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.89ms 8.18ms      121.     265KB     2.05
cli_progress_done()
```
