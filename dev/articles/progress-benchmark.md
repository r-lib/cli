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
#> 1 __cli_update_due              0     10ns 89497726.        0B        0
#> 2 fun()                  140.05ns  170.1ns  4211561.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    130ns  7366641.        0B        0
#> 4 interactive()            8.96ns   11.1ns 58489480.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 41.1ns 18651158.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    150ns  6030723.        0B        0
#> 2 ta[[1]]       140ns    160ns  5639213.        0B        0
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
#> 1 f0()         22.2ms   22.4ms      44.7    21.6KB     402.
#> 2 fp()         25.1ms   25.3ms      39.5    82.5KB     316.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 29.3ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     242ms    247ms      4.07        0B     35.3
#> 2 fp(1e+06)     266ms    296ms      3.38     1.9KB     27.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 49ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.43s    2.43s     0.411        0B     19.3
#> 2 fp(1e+07)     2.53s    2.53s     0.395     1.9KB     19.0
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 9.65ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.7s    23.7s    0.0422        0B     22.1
#> 2 fp(1e+08)     25.6s    25.6s    0.0390     1.9KB     20.2
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 19.2ns
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
#> 1 f0()         96.8ms    105ms      7.51     781KB    16.5 
#> 2 f01()       108.3ms    109ms      8.88     781KB    10.7 
#> 3 fp()        117.6ms    121ms      7.52     783KB     7.52
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 153ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  927.45ms 927.45ms     1.08     7.63MB     7.55
#> 2 f01(1e+06)    1.64s    1.64s     0.609    7.63MB     4.87
#> 3 fp(1e+06)      2.8s     2.8s     0.357    7.63MB     1.79
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.87µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 1.16µs
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
#> 1 f0()         78.9ms   79.2ms     12.6     1.44MB     5.05
#> 2 f01()        93.4ms   94.5ms     10.6    781.3KB     7.05
#> 3 fp()         97.2ms  104.5ms      9.62  783.26KB     2.41
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 254ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 101ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  922.38ms 922.38ms     1.08     7.63MB     2.17
#> 2 f01(1e+06)     1.2s     1.2s     0.833    7.63MB     4.16
#> 3 fp(1e+06)     1.56s    1.56s     0.639    7.63MB     2.56
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 642ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 363ns
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
#> 1 f0()        30.17ms  31.78ms    31.2      39.3KB     1.95
#> 2 fp()          4.51s    4.51s     0.222   100.8KB     3.33
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 44.8µs
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
#> 1 f0()        21.68ms  21.87ms    44.9      18.7KB     3.90
#> 2 ff()        31.76ms   32.2ms    30.8      27.6KB     3.85
#> 3 fp()          2.27s    2.27s     0.439    25.1KB     3.08
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.5µs
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
#> 1 f0(1e+06)   226.9ms  226.9ms    4.37          0B     4.37
#> 2 ff(1e+06)   323.3ms  323.3ms    3.09      1.91KB     3.09
#> 3 fp(1e+06)     24.3s    24.3s    0.0412    1.91KB     2.59
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 24.1µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 96.3ns
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
#> 1 test_baseline()   622.47ms 622.47ms     1.61     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.800    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.11KB        0
#> 4 test_cli_unroll()  623.9ms  623.9ms     1.60     3.58KB        0
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
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 33m
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
#> ■                                  0% | ETA: 19m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.46ms 6.59ms      149.    1.42MB     2.02
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (484/s) | 3ms
#> ⠹ 2 done (67/s) | 30ms
#> ⠸ 3 done (80/s) | 38ms
#> ⠼ 4 done (89/s) | 46ms
#> ⠴ 5 done (95/s) | 53ms
#> ⠦ 6 done (99/s) | 61ms
#> ⠧ 7 done (103/s) | 69ms
#> ⠇ 8 done (106/s) | 76ms
#> ⠏ 9 done (108/s) | 84ms
#> ⠋ 10 done (110/s) | 92ms
#> ⠙ 11 done (111/s) | 99ms
#> ⠹ 12 done (113/s) | 107ms
#> ⠸ 13 done (114/s) | 115ms
#> ⠼ 14 done (115/s) | 122ms
#> ⠴ 15 done (116/s) | 130ms
#> ⠦ 16 done (117/s) | 137ms
#> ⠧ 17 done (118/s) | 145ms
#> ⠇ 18 done (118/s) | 153ms
#> ⠏ 19 done (119/s) | 161ms
#> ⠋ 20 done (119/s) | 169ms
#> ⠙ 21 done (119/s) | 177ms
#> ⠹ 22 done (120/s) | 184ms
#> ⠸ 23 done (120/s) | 192ms
#> ⠼ 24 done (121/s) | 200ms
#> ⠴ 25 done (121/s) | 207ms
#> ⠦ 26 done (121/s) | 215ms
#> ⠧ 27 done (122/s) | 223ms
#> ⠇ 28 done (122/s) | 230ms
#> ⠏ 29 done (122/s) | 238ms
#> ⠋ 30 done (123/s) | 245ms
#> ⠙ 31 done (123/s) | 253ms
#> ⠹ 32 done (123/s) | 261ms
#> ⠸ 33 done (123/s) | 269ms
#> ⠼ 34 done (123/s) | 276ms
#> ⠴ 35 done (124/s) | 284ms
#> ⠦ 36 done (124/s) | 291ms
#> ⠧ 37 done (124/s) | 299ms
#> ⠇ 38 done (124/s) | 306ms
#> ⠏ 39 done (123/s) | 318ms
#> ⠋ 40 done (123/s) | 325ms
#> ⠙ 41 done (123/s) | 333ms
#> ⠹ 42 done (124/s) | 341ms
#> ⠸ 43 done (124/s) | 348ms
#> ⠼ 44 done (124/s) | 356ms
#> ⠴ 45 done (124/s) | 363ms
#> ⠦ 46 done (124/s) | 371ms
#> ⠧ 47 done (124/s) | 379ms
#> ⠇ 48 done (124/s) | 386ms
#> ⠏ 49 done (125/s) | 394ms
#> ⠋ 50 done (125/s) | 402ms
#> ⠙ 51 done (125/s) | 409ms
#> ⠹ 52 done (125/s) | 417ms
#> ⠸ 53 done (125/s) | 424ms
#> ⠼ 54 done (125/s) | 432ms
#> ⠴ 55 done (125/s) | 440ms
#> ⠦ 56 done (125/s) | 447ms
#> ⠧ 57 done (125/s) | 455ms
#> ⠇ 58 done (126/s) | 463ms
#> ⠏ 59 done (126/s) | 470ms
#> ⠋ 60 done (126/s) | 478ms
#> ⠙ 61 done (126/s) | 486ms
#> ⠹ 62 done (126/s) | 493ms
#> ⠸ 63 done (126/s) | 501ms
#> ⠼ 64 done (126/s) | 509ms
#> ⠴ 65 done (126/s) | 516ms
#> ⠦ 66 done (126/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.52ms 7.63ms      131.     265KB     2.04
cli_progress_done()
```
