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
#> 1 __cli_update_due              0     10ns    1.18e8        0B        0
#> 2 fun()                  130.04ns  160.1ns    4.63e6        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns  121.1ns    7.53e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    6.93e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 21063782.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6123015.        0B        0
#> 2 ta[[1]]       140ns    160ns  5750360.        0B        0
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
#> 1 f0()         22.2ms   22.2ms      45.0    21.6KB     405.
#> 2 fp()         24.4ms   24.4ms      40.9    82.5KB     348.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 21.9ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     239ms    240ms      4.16        0B     37.5
#> 2 fp(1e+06)     259ms    287ms      3.49     1.9KB     24.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 46.9ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.42s    2.42s     0.414        0B     19.5
#> 2 fp(1e+07)      2.5s     2.5s     0.400     1.9KB     18.8
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 8.32ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.5s    23.5s    0.0426        0B     22.3
#> 2 fp(1e+08)     25.2s    25.2s    0.0397     1.9KB     20.4
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.2ns
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
#> 1 f0()         92.5ms    103ms      7.73     781KB    18.6 
#> 2 f01()       105.3ms    108ms      9.24     781KB     9.24
#> 3 fp()        111.9ms    132ms      7.06     783KB    12.4
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 286ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  938.34ms 938.34ms     1.07     7.63MB     7.46
#> 2 f01(1e+06)    1.47s    1.47s     0.681    7.63MB     4.77
#> 3 fp(1e+06)     1.86s    1.86s     0.537    7.63MB     4.29
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 925ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 394ns
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
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()           80ms   87.4ms     11.5     1.44MB     7.69
#> 2 f01()         113ms  120.4ms      7.94   781.3KB     5.96
#> 3 fp()          130ms  132.6ms      6.76  783.26KB     6.76
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 452ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 122ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     2.17s    2.17s     0.460    7.63MB    0.920
#> 2 f01(1e+06)    1.08s    1.08s     0.924    7.63MB    1.85 
#> 3 fp(1e+06)      1.2s     1.2s     0.832    7.63MB    2.50
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 120ns
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
#> 1 f0()        22.66ms  22.75ms    43.1      39.3KB     1.96
#> 2 fp()          4.02s    4.02s     0.249   100.8KB     1.74
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 40µs
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
#> 1 f0()        21.99ms  22.15ms    41.9      18.7KB     3.99
#> 2 ff()        31.93ms  32.06ms    29.7      27.6KB     1.98
#> 3 fp()          2.23s    2.23s     0.447    25.1KB     1.79
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 99.1ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   226.3ms  226.8ms    4.29          0B     2.86
#> 2 ff(1e+06)   338.4ms  339.1ms    2.95      1.91KB     2.95
#> 3 fp(1e+06)     22.9s    22.9s    0.0436    1.91KB     1.66
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 112ns
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
#> 1 test_baseline()   623.24ms 623.24ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.11KB        0
#> 4 test_cli_unroll() 624.73ms 624.73ms     1.60     3.58KB        0
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.48ms 6.55ms      150.    1.44MB        0
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (495/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (78/s) | 39ms
#> ⠼ 4 done (87/s) | 47ms
#> ⠴ 5 done (93/s) | 54ms
#> ⠦ 6 done (98/s) | 62ms
#> ⠧ 7 done (102/s) | 69ms
#> ⠇ 8 done (96/s) | 84ms
#> ⠏ 9 done (98/s) | 93ms
#> ⠋ 10 done (100/s) | 101ms
#> ⠙ 11 done (101/s) | 109ms
#> ⠹ 12 done (102/s) | 118ms
#> ⠸ 13 done (103/s) | 126ms
#> ⠼ 14 done (104/s) | 135ms
#> ⠴ 15 done (105/s) | 143ms
#> ⠦ 16 done (106/s) | 152ms
#> ⠧ 17 done (107/s) | 160ms
#> ⠇ 18 done (108/s) | 168ms
#> ⠏ 19 done (109/s) | 175ms
#> ⠋ 20 done (110/s) | 183ms
#> ⠙ 21 done (110/s) | 191ms
#> ⠹ 22 done (111/s) | 198ms
#> ⠸ 23 done (112/s) | 206ms
#> ⠼ 24 done (113/s) | 214ms
#> ⠴ 25 done (113/s) | 221ms
#> ⠦ 26 done (114/s) | 229ms
#> ⠧ 27 done (114/s) | 237ms
#> ⠇ 28 done (115/s) | 244ms
#> ⠏ 29 done (116/s) | 252ms
#> ⠋ 30 done (116/s) | 259ms
#> ⠙ 31 done (116/s) | 267ms
#> ⠹ 32 done (117/s) | 275ms
#> ⠸ 33 done (117/s) | 282ms
#> ⠼ 34 done (118/s) | 290ms
#> ⠴ 35 done (118/s) | 298ms
#> ⠦ 36 done (118/s) | 305ms
#> ⠧ 37 done (118/s) | 313ms
#> ⠇ 38 done (119/s) | 321ms
#> ⠏ 39 done (119/s) | 328ms
#> ⠋ 40 done (119/s) | 336ms
#> ⠙ 41 done (120/s) | 344ms
#> ⠹ 42 done (120/s) | 351ms
#> ⠸ 43 done (120/s) | 359ms
#> ⠼ 44 done (120/s) | 367ms
#> ⠴ 45 done (120/s) | 374ms
#> ⠦ 46 done (121/s) | 382ms
#> ⠧ 47 done (121/s) | 390ms
#> ⠇ 48 done (121/s) | 397ms
#> ⠏ 49 done (121/s) | 405ms
#> ⠋ 50 done (121/s) | 413ms
#> ⠙ 51 done (122/s) | 420ms
#> ⠹ 52 done (122/s) | 428ms
#> ⠸ 53 done (122/s) | 436ms
#> ⠼ 54 done (122/s) | 443ms
#> ⠴ 55 done (122/s) | 451ms
#> ⠦ 56 done (122/s) | 459ms
#> ⠧ 57 done (122/s) | 466ms
#> ⠇ 58 done (123/s) | 474ms
#> ⠏ 59 done (123/s) | 481ms
#> ⠋ 60 done (123/s) | 489ms
#> ⠙ 61 done (123/s) | 497ms
#> ⠹ 62 done (123/s) | 504ms
#> ⠸ 63 done (123/s) | 512ms
#> ⠼ 64 done (123/s) | 520ms
#> ⠴ 65 done (123/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.54ms 7.64ms      129.     265KB     2.05
cli_progress_done()
```
