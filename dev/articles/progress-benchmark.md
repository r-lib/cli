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
#> 1 __cli_update_due              0     10ns    1.00e8        0B        0
#> 2 fun()                  120.02ns    141ns    5.06e6        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    120ns    8.14e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    6.64e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 41.1ns 21141259.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    140ns  6452903.        0B        0
#> 2 ta[[1]]       140ns    151ns  6000066.        0B        0
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
#> 1 f0()         21.7ms   21.8ms      45.9    21.6KB     436.
#> 2 fp()         24.2ms   24.6ms      40.7    82.5KB     346.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     235ms    237ms      4.23        0B     38.0
#> 2 fp(1e+06)     253ms    283ms      3.54    1.88KB     26.5
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 46.3ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.36s    2.36s     0.423        0B     20.3
#> 2 fp(1e+07)     2.45s    2.45s     0.408    1.88KB     19.6
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 8.92ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.3s    23.3s    0.0429        0B     22.7
#> 2 fp(1e+08)       25s      25s    0.0401    1.88KB     21.0
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
#> 1 f0()         83.6ms     89ms      8.96     781KB     14.3
#> 2 f01()       104.3ms    115ms      8.19     781KB     13.1
#> 3 fp()        117.9ms    120ms      7.97     783KB     11.2
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 310ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  871.89ms 871.89ms     1.15     7.63MB     4.59
#> 2 f01(1e+06)    1.11s    1.11s     0.904    7.63MB     5.42
#> 3 fp(1e+06)     1.36s    1.36s     0.734    7.63MB     2.94
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 490ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 255ns
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
#> 1 f0()         75.4ms   75.7ms     13.2     1.44MB     9.91
#> 2 f01()          91ms   91.2ms     10.9    781.3KB    10.9 
#> 3 fp()         97.8ms  103.3ms      9.69  783.24KB     6.46
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 276ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 121ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  912.45ms 912.45ms     1.10     7.63MB     4.38
#> 2 f01(1e+06)    1.36s    1.36s     0.735    7.63MB     3.67
#> 3 fp(1e+06)     1.57s    1.57s     0.638    7.63MB     3.19
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 654ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 206ns
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
#> 1 f0()        22.92ms  23.02ms    42.9      39.3KB     3.90
#> 2 fp()          4.17s    4.17s     0.240   100.8KB     3.11
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 41.5µs
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
#> 1 f0()        21.42ms  21.64ms    41.5      18.7KB     5.93
#> 2 ff()        30.51ms  31.34ms    29.1      27.6KB     3.87
#> 3 fp()          2.25s    2.25s     0.445    25.1KB     3.12
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 97ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   221.6ms    222ms    4.46          0B     5.95
#> 2 ff(1e+06)   307.1ms  308.9ms    3.24       1.9KB     3.24
#> 3 fp(1e+06)     22.9s    22.9s    0.0437     1.9KB     3.24
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.6µs
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
#> 1 test_baseline()   623.19ms 623.19ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.802    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.09KB        0
#> 4 test_cli_unroll() 623.62ms 623.62ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 39m
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
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
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
#> ■                                  0% | ETA: 13m
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
#> 1 cli_progress_update(force… 6.02ms 6.11ms      161.    1.41MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (549/s) | 2ms
#> ⠹ 2 done (64/s) | 32ms
#> ⠸ 3 done (77/s) | 39ms
#> ⠼ 4 done (87/s) | 47ms
#> ⠴ 5 done (94/s) | 54ms
#> ⠦ 6 done (100/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (104/s) | 78ms
#> ⠏ 9 done (107/s) | 85ms
#> ⠋ 10 done (110/s) | 92ms
#> ⠙ 11 done (112/s) | 99ms
#> ⠹ 12 done (114/s) | 106ms
#> ⠸ 13 done (116/s) | 113ms
#> ⠼ 14 done (117/s) | 120ms
#> ⠴ 15 done (118/s) | 127ms
#> ⠦ 16 done (120/s) | 134ms
#> ⠧ 17 done (121/s) | 141ms
#> ⠇ 18 done (122/s) | 149ms
#> ⠏ 19 done (123/s) | 156ms
#> ⠋ 20 done (123/s) | 163ms
#> ⠙ 21 done (124/s) | 170ms
#> ⠹ 22 done (125/s) | 177ms
#> ⠸ 23 done (126/s) | 184ms
#> ⠼ 24 done (126/s) | 191ms
#> ⠴ 25 done (127/s) | 198ms
#> ⠦ 26 done (127/s) | 205ms
#> ⠧ 27 done (128/s) | 212ms
#> ⠇ 28 done (128/s) | 219ms
#> ⠏ 29 done (128/s) | 226ms
#> ⠋ 30 done (129/s) | 233ms
#> ⠙ 31 done (129/s) | 241ms
#> ⠹ 32 done (130/s) | 248ms
#> ⠸ 33 done (130/s) | 255ms
#> ⠼ 34 done (130/s) | 262ms
#> ⠴ 35 done (130/s) | 269ms
#> ⠦ 36 done (131/s) | 276ms
#> ⠧ 37 done (131/s) | 283ms
#> ⠇ 38 done (131/s) | 290ms
#> ⠏ 39 done (131/s) | 297ms
#> ⠋ 40 done (132/s) | 305ms
#> ⠙ 41 done (132/s) | 312ms
#> ⠹ 42 done (132/s) | 319ms
#> ⠸ 43 done (132/s) | 326ms
#> ⠼ 44 done (132/s) | 333ms
#> ⠴ 45 done (133/s) | 340ms
#> ⠦ 46 done (133/s) | 347ms
#> ⠧ 47 done (133/s) | 354ms
#> ⠇ 48 done (133/s) | 362ms
#> ⠏ 49 done (133/s) | 369ms
#> ⠋ 50 done (133/s) | 376ms
#> ⠙ 51 done (133/s) | 383ms
#> ⠹ 52 done (133/s) | 390ms
#> ⠸ 53 done (134/s) | 397ms
#> ⠼ 54 done (134/s) | 404ms
#> ⠴ 55 done (134/s) | 411ms
#> ⠦ 56 done (126/s) | 446ms
#> ⠧ 57 done (126/s) | 454ms
#> ⠇ 58 done (126/s) | 461ms
#> ⠏ 59 done (126/s) | 468ms
#> ⠋ 60 done (126/s) | 475ms
#> ⠙ 61 done (127/s) | 483ms
#> ⠹ 62 done (127/s) | 490ms
#> ⠸ 63 done (127/s) | 497ms
#> ⠼ 64 done (127/s) | 504ms
#> ⠴ 65 done (127/s) | 512ms
#> ⠦ 66 done (127/s) | 519ms
#> ⠧ 67 done (127/s) | 526ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.99ms 7.09ms      140.     265KB     4.37
cli_progress_done()
```
