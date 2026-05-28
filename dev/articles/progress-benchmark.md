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
#> 1 __cli_update_due         9.89ns     10ns 84168587.        0B        0
#> 2 fun()                  110.01ns  130.2ns  4973710.        0B        0
#> 3 .Call(ccli_tick_reset)  90.11ns  110.1ns  8528933.        0B        0
#> 4 interactive()            9.89ns   19.9ns 48990858.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20210080.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    121ns  6784562.        0B        0
#> 2 ta[[1]]       120ns    140ns  6262224.        0B        0
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
#> 1 f0()         24.4ms   24.5ms      40.9    21.6KB     307.
#> 2 fp()         27.7ms   28.5ms      35.1    82.5KB     246.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 40.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     276ms    278ms      3.60        0B     30.6
#> 2 fp(1e+06)     295ms    298ms      3.36    1.88KB     28.5
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.8ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.71s    2.71s     0.369        0B     17.7
#> 2 fp(1e+07)     2.75s    2.75s     0.364    1.88KB     17.5
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 3.6ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     26.2s    26.2s    0.0382        0B     20.3
#> 2 fp(1e+08)     27.7s    27.7s    0.0361    1.88KB     19.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 15.6ns
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
#> 1 f0()         86.2ms     89ms      7.86     781KB    15.7 
#> 2 f01()       103.1ms    106ms      9.12     781KB    10.9 
#> 3 fp()        126.3ms    136ms      6.75     783KB     8.43
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 471ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.13s    1.13s     0.883    7.63MB     5.30
#> 2 f01(1e+06)    2.09s    2.09s     0.479    7.63MB     2.88
#> 3 fp(1e+06)     1.26s    1.26s     0.794    7.63MB     3.97
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 128ns
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
#> 1 f0()         74.7ms   75.1ms      13.3    1.44MB     9.97
#> 2 f01()        90.2ms   91.1ms      11.0   781.3KB     5.48
#> 3 fp()         90.9ms  100.6ms      10.0  783.24KB     6.67
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 255ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 94.7ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  957.77ms 957.77ms     1.04     7.63MB     2.09
#> 2 f01(1e+06)    1.16s    1.16s     0.861    7.63MB     2.58
#> 3 fp(1e+06)     1.37s    1.37s     0.730    7.63MB     2.92
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 413ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 210ns
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
#> 1 f0()        24.33ms  24.54ms    39.7      39.3KB     3.97
#> 2 fp()          3.89s    3.89s     0.257   100.7KB     2.31
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 38.7µs
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
#> 1 f0()           23ms   23.2ms    38.0      18.7KB     3.80
#> 2 ff()         32.1ms   32.4ms    26.9      27.6KB     1.92
#> 3 fp()           2.3s     2.3s     0.434    25.1KB     2.17
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.8µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 91.9ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     238ms    254ms    4.02          0B     4.02
#> 2 ff(1e+06)     340ms    340ms    2.94       1.9KB     2.94
#> 3 fp(1e+06)       22s      22s    0.0455     1.9KB     2.28
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 86.9ns
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
#> 1 test_baseline()   704.28ms 704.28ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.707    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.09KB        0
#> 4 test_cli_unroll()  705.1ms  705.1ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
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
#> 1 cli_progress_update(force… 6.22ms 6.46ms      152.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (424/s) | 3ms
#> ⠹ 2 done (62/s) | 33ms
#> ⠸ 3 done (73/s) | 42ms
#> ⠼ 4 done (83/s) | 49ms
#> ⠴ 5 done (90/s) | 56ms
#> ⠦ 6 done (96/s) | 63ms
#> ⠧ 7 done (101/s) | 70ms
#> ⠇ 8 done (104/s) | 77ms
#> ⠏ 9 done (107/s) | 85ms
#> ⠋ 10 done (110/s) | 92ms
#> ⠙ 11 done (112/s) | 99ms
#> ⠹ 12 done (114/s) | 106ms
#> ⠸ 13 done (115/s) | 114ms
#> ⠼ 14 done (116/s) | 121ms
#> ⠴ 15 done (117/s) | 129ms
#> ⠦ 16 done (118/s) | 136ms
#> ⠧ 17 done (119/s) | 143ms
#> ⠇ 18 done (120/s) | 151ms
#> ⠏ 19 done (120/s) | 158ms
#> ⠋ 20 done (121/s) | 166ms
#> ⠙ 21 done (121/s) | 174ms
#> ⠹ 22 done (121/s) | 182ms
#> ⠸ 23 done (122/s) | 190ms
#> ⠼ 24 done (122/s) | 197ms
#> ⠴ 25 done (122/s) | 205ms
#> ⠦ 26 done (122/s) | 213ms
#> ⠧ 27 done (123/s) | 221ms
#> ⠇ 28 done (123/s) | 228ms
#> ⠏ 29 done (123/s) | 236ms
#> ⠋ 30 done (124/s) | 243ms
#> ⠙ 31 done (124/s) | 251ms
#> ⠹ 32 done (124/s) | 258ms
#> ⠸ 33 done (124/s) | 266ms
#> ⠼ 34 done (125/s) | 274ms
#> ⠴ 35 done (125/s) | 281ms
#> ⠦ 36 done (125/s) | 289ms
#> ⠧ 37 done (125/s) | 296ms
#> ⠇ 38 done (125/s) | 304ms
#> ⠏ 39 done (126/s) | 311ms
#> ⠋ 40 done (126/s) | 319ms
#> ⠙ 41 done (126/s) | 326ms
#> ⠹ 42 done (126/s) | 334ms
#> ⠸ 43 done (126/s) | 341ms
#> ⠼ 44 done (126/s) | 349ms
#> ⠴ 45 done (126/s) | 356ms
#> ⠦ 46 done (127/s) | 364ms
#> ⠧ 47 done (127/s) | 372ms
#> ⠇ 48 done (127/s) | 379ms
#> ⠏ 49 done (127/s) | 387ms
#> ⠋ 50 done (127/s) | 394ms
#> ⠙ 51 done (127/s) | 402ms
#> ⠹ 52 done (127/s) | 409ms
#> ⠸ 53 done (127/s) | 417ms
#> ⠼ 54 done (128/s) | 424ms
#> ⠴ 55 done (128/s) | 432ms
#> ⠦ 56 done (128/s) | 439ms
#> ⠧ 57 done (128/s) | 447ms
#> ⠇ 58 done (128/s) | 454ms
#> ⠏ 59 done (128/s) | 462ms
#> ⠋ 60 done (128/s) | 470ms
#> ⠙ 61 done (128/s) | 477ms
#> ⠹ 62 done (128/s) | 485ms
#> ⠸ 63 done (128/s) | 492ms
#> ⠼ 64 done (128/s) | 500ms
#> ⠴ 65 done (127/s) | 514ms
#> ⠦ 66 done (127/s) | 522ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.99ms 7.51ms      131.     265KB     2.05
cli_progress_done()
```
