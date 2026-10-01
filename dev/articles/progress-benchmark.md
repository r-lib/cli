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
#> 1 __cli_update_due              0     10ns    1.03e8        0B        0
#> 2 fun()                  130.04ns  160.1ns    4.57e6        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    130ns    7.40e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    7.27e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 41.1ns 21945625.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6145299.        0B        0
#> 2 ta[[1]]       130ns    151ns  5764710.        0B        0
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
#> 1 f0()         21.9ms     22ms      45.5    21.6KB     432.
#> 2 fp()         24.7ms     25ms      39.9    82.5KB     340.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 30.6ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     239ms    256ms      3.90        0B     33.2
#> 2 fp(1e+06)     256ms    257ms      3.89     1.9KB     35.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.42s    2.42s     0.413        0B     19.8
#> 2 fp(1e+07)     2.49s    2.49s     0.401     1.9KB     18.8
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.25ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     24.1s    24.1s    0.0414        0B     21.8
#> 2 fp(1e+08)     25.3s    25.3s    0.0396     1.9KB     20.5
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 11.2ns
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
#> 1 f0()         89.4ms    102ms      7.99     781KB    17.6 
#> 2 f01()       104.4ms    107ms      9.19     781KB    11.0 
#> 3 fp()        117.6ms    123ms      7.39     783KB     9.23
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 212ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.09s    1.09s     0.921    7.63MB     6.45
#> 2 f01(1e+06)     1.9s     1.9s     0.526    7.63MB     4.21
#> 3 fp(1e+06)     2.41s    2.41s     0.415    7.63MB     2.08
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.32µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 508ns
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
#> 1 f0()         78.1ms   78.6ms     12.6     1.44MB     5.05
#> 2 f01()        93.2ms   93.8ms     10.6    781.3KB     7.03
#> 3 fp()         97.9ms  100.3ms      9.61  783.26KB     6.41
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 218ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 64.9ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  924.23ms 924.23ms     1.08     7.63MB     3.25
#> 2 f01(1e+06)    1.17s    1.17s     0.853    7.63MB     3.41
#> 3 fp(1e+06)     1.48s    1.48s     0.674    7.63MB     2.70
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 559ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 311ns
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
#> 1 f0()        26.59ms   31.2ms    31.1      39.3KB     3.89
#> 2 fp()          5.46s    5.46s     0.183   100.8KB     2.20
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 54.3µs
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
#> 1 f0()        21.75ms  21.88ms    45.1      18.7KB     3.92
#> 2 ff()        31.82ms  32.05ms    30.8      27.6KB     3.85
#> 3 fp()          2.25s    2.25s     0.444    25.1KB     2.66
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.3µs
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
#> 1 f0(1e+06)     225ms  225.3ms    4.43          0B     4.43
#> 2 ff(1e+06)   316.4ms  316.5ms    3.16      1.91KB     3.16
#> 3 fp(1e+06)     23.7s    23.7s    0.0422    1.91KB     2.53
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 91.1ns
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
#> 1 test_baseline()   631.55ms 631.55ms     1.58     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.11KB        0
#> 4 test_cli_unroll() 623.69ms 623.69ms     1.60     3.58KB        0
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
#> ■                                  0% | ETA: 34m
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
#> ■                                  0% | ETA: 14m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.41ms 6.49ms      151.    1.42MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (516/s) | 3ms
#> ⠹ 2 done (70/s) | 29ms
#> ⠸ 3 done (83/s) | 37ms
#> ⠼ 4 done (91/s) | 44ms
#> ⠴ 5 done (98/s) | 52ms
#> ⠦ 6 done (102/s) | 59ms
#> ⠧ 7 done (106/s) | 67ms
#> ⠇ 8 done (108/s) | 74ms
#> ⠏ 9 done (111/s) | 82ms
#> ⠋ 10 done (113/s) | 89ms
#> ⠙ 11 done (114/s) | 97ms
#> ⠹ 12 done (116/s) | 104ms
#> ⠸ 13 done (117/s) | 112ms
#> ⠼ 14 done (118/s) | 119ms
#> ⠴ 15 done (119/s) | 127ms
#> ⠦ 16 done (119/s) | 135ms
#> ⠧ 17 done (120/s) | 142ms
#> ⠇ 18 done (121/s) | 150ms
#> ⠏ 19 done (121/s) | 157ms
#> ⠋ 20 done (122/s) | 165ms
#> ⠙ 21 done (122/s) | 172ms
#> ⠹ 22 done (123/s) | 180ms
#> ⠸ 23 done (123/s) | 188ms
#> ⠼ 24 done (123/s) | 195ms
#> ⠴ 25 done (124/s) | 203ms
#> ⠦ 26 done (124/s) | 210ms
#> ⠧ 27 done (124/s) | 218ms
#> ⠇ 28 done (125/s) | 225ms
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
#> ⠏ 39 done (125/s) | 312ms
#> ⠋ 40 done (125/s) | 320ms
#> ⠙ 41 done (126/s) | 327ms
#> ⠹ 42 done (126/s) | 335ms
#> ⠸ 43 done (126/s) | 342ms
#> ⠼ 44 done (126/s) | 350ms
#> ⠴ 45 done (126/s) | 357ms
#> ⠦ 46 done (126/s) | 365ms
#> ⠧ 47 done (126/s) | 372ms
#> ⠇ 48 done (127/s) | 380ms
#> ⠏ 49 done (127/s) | 387ms
#> ⠋ 50 done (127/s) | 395ms
#> ⠙ 51 done (127/s) | 403ms
#> ⠹ 52 done (127/s) | 410ms
#> ⠸ 53 done (127/s) | 418ms
#> ⠼ 54 done (127/s) | 425ms
#> ⠴ 55 done (127/s) | 433ms
#> ⠦ 56 done (127/s) | 441ms
#> ⠧ 57 done (127/s) | 448ms
#> ⠇ 58 done (127/s) | 456ms
#> ⠏ 59 done (128/s) | 463ms
#> ⠋ 60 done (128/s) | 471ms
#> ⠙ 61 done (128/s) | 478ms
#> ⠹ 62 done (128/s) | 486ms
#> ⠸ 63 done (128/s) | 493ms
#> ⠼ 64 done (128/s) | 501ms
#> ⠴ 65 done (128/s) | 508ms
#> ⠦ 66 done (128/s) | 516ms
#> ⠧ 67 done (128/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.44ms 7.53ms      133.     265KB     2.04
cli_progress_done()
```
