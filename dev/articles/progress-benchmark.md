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
#> 1 __cli_update_due           10ns   10.1ns 67481011.        0B        0
#> 2 fun()                     110ns  131.1ns  4681315.        0B        0
#> 3 .Call(ccli_tick_reset)   99.9ns    110ns  8231539.        0B        0
#> 4 interactive()              10ns     20ns 53953690.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 39.9ns 49.9ns 18822802.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    130ns  6440768.        0B        0
#> 2 ta[[1]]       110ns    131ns  6226017.        0B        0
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
#> 1 f0()         24.3ms   24.3ms      41.2    21.6KB     329.
#> 2 fp()         27.3ms   27.7ms      36.1    82.5KB     253.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 33.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     270ms    272ms      3.67        0B     31.2
#> 2 fp(1e+06)     300ms    301ms      3.32    1.88KB     29.9
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 28.7ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.73s    2.73s     0.367        0B     17.6
#> 2 fp(1e+07)     2.81s    2.81s     0.355    1.88KB     17.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 8.77ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     26.3s    26.3s    0.0380        0B     20.2
#> 2 fp(1e+08)       28s      28s    0.0358    1.88KB     18.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.6ns
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
#> 1 f0()         90.5ms   93.2ms      7.33     781KB    14.7 
#> 2 f01()       107.8ms    110ms      7.77     781KB     9.32
#> 3 fp()        141.6ms  148.4ms      6.63     783KB     8.28
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 552ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.08s    1.08s     0.925    7.63MB     5.55
#> 2 f01(1e+06)    2.28s    2.28s     0.438    7.63MB     2.63
#> 3 fp(1e+06)     1.27s    1.27s     0.785    7.63MB     3.93
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 192ns
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
#> 1 f0()         75.4ms   76.4ms      13.0    1.44MB     9.76
#> 2 f01()        91.7ms   91.9ms      10.8   781.3KB     7.22
#> 3 fp()         92.1ms   96.3ms      10.1  783.24KB     6.72
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 199ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 43.4ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     903ms    903ms     1.11     7.63MB     2.21
#> 2 f01(1e+06)     1.2s     1.2s     0.832    7.63MB     2.50
#> 3 fp(1e+06)     1.23s    1.23s     0.812    7.63MB     2.44
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 328ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 29.2ns
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
#> 1 f0()        24.16ms  24.54ms    39.8      39.3KB     1.99
#> 2 fp()          3.96s    3.96s     0.253   100.7KB     2.27
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.3µs
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
#> 1 f0()        22.92ms     24ms    31.8      18.7KB     1.87
#> 2 ff()        31.89ms  32.23ms    27.6      27.6KB     3.94
#> 3 fp()          2.27s    2.27s     0.439    25.1KB     1.76
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.5µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 82.3ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     245ms  256.3ms    3.90          0B     3.90
#> 2 ff(1e+06)   347.3ms  347.4ms    2.88       1.9KB     2.88
#> 3 fp(1e+06)     22.7s    22.7s    0.0441     1.9KB     2.03
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.4µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 91.2ns
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
#> 1 test_baseline()   702.96ms 702.96ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.09KB        0
#> 4 test_cli_unroll() 704.59ms 704.59ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
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
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.94ms 6.11ms      158.    1.41MB     2.05
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (460/s) | 3ms
#> ⠹ 2 done (67/s) | 31ms
#> ⠸ 3 done (79/s) | 39ms
#> ⠼ 4 done (88/s) | 46ms
#> ⠴ 5 done (95/s) | 53ms
#> ⠦ 6 done (100/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 75ms
#> ⠏ 9 done (110/s) | 82ms
#> ⠋ 10 done (113/s) | 89ms
#> ⠙ 11 done (114/s) | 97ms
#> ⠹ 12 done (116/s) | 104ms
#> ⠸ 13 done (117/s) | 111ms
#> ⠼ 14 done (119/s) | 119ms
#> ⠴ 15 done (120/s) | 126ms
#> ⠦ 16 done (121/s) | 133ms
#> ⠧ 17 done (122/s) | 140ms
#> ⠇ 18 done (122/s) | 148ms
#> ⠏ 19 done (123/s) | 155ms
#> ⠋ 20 done (124/s) | 162ms
#> ⠙ 21 done (125/s) | 169ms
#> ⠹ 22 done (125/s) | 176ms
#> ⠸ 23 done (126/s) | 183ms
#> ⠼ 24 done (127/s) | 190ms
#> ⠴ 25 done (127/s) | 197ms
#> ⠦ 26 done (125/s) | 209ms
#> ⠧ 27 done (125/s) | 217ms
#> ⠇ 28 done (125/s) | 225ms
#> ⠏ 29 done (125/s) | 233ms
#> ⠋ 30 done (124/s) | 242ms
#> ⠙ 31 done (124/s) | 250ms
#> ⠹ 32 done (124/s) | 259ms
#> ⠸ 33 done (124/s) | 267ms
#> ⠼ 34 done (124/s) | 276ms
#> ⠴ 35 done (124/s) | 283ms
#> ⠦ 36 done (124/s) | 291ms
#> ⠧ 37 done (125/s) | 298ms
#> ⠇ 38 done (125/s) | 305ms
#> ⠏ 39 done (125/s) | 312ms
#> ⠋ 40 done (125/s) | 320ms
#> ⠙ 41 done (126/s) | 327ms
#> ⠹ 42 done (126/s) | 334ms
#> ⠸ 43 done (126/s) | 342ms
#> ⠼ 44 done (126/s) | 349ms
#> ⠴ 45 done (127/s) | 356ms
#> ⠦ 46 done (127/s) | 364ms
#> ⠧ 47 done (127/s) | 371ms
#> ⠇ 48 done (127/s) | 378ms
#> ⠏ 49 done (127/s) | 386ms
#> ⠋ 50 done (128/s) | 393ms
#> ⠙ 51 done (128/s) | 400ms
#> ⠹ 52 done (128/s) | 408ms
#> ⠸ 53 done (128/s) | 415ms
#> ⠼ 54 done (128/s) | 422ms
#> ⠴ 55 done (128/s) | 430ms
#> ⠦ 56 done (128/s) | 437ms
#> ⠧ 57 done (129/s) | 444ms
#> ⠇ 58 done (129/s) | 451ms
#> ⠏ 59 done (129/s) | 459ms
#> ⠋ 60 done (129/s) | 466ms
#> ⠙ 61 done (129/s) | 473ms
#> ⠹ 62 done (129/s) | 480ms
#> ⠸ 63 done (129/s) | 487ms
#> ⠼ 64 done (130/s) | 495ms
#> ⠴ 65 done (130/s) | 502ms
#> ⠦ 66 done (130/s) | 509ms
#> ⠧ 67 done (130/s) | 517ms
#> ⠇ 68 done (130/s) | 524ms
#> ⠏ 69 done (130/s) | 531ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.96ms 7.28ms      135.     265KB     2.02
cli_progress_done()
```
