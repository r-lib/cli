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
#> 1 __cli_update_due         9.89ns     10ns 77677143.        0B        0
#> 2 fun()                  100.12ns    131ns  4876640.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns    120ns  7782353.        0B        0
#> 4 interactive()           10.01ns     20ns 57224685.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 18976127.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      110ns    131ns  5920767.        0B        0
#> 2 ta[[1]]       120ns    141ns  5613728.        0B        0
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
#> 1 f0()         24.3ms   24.4ms      41.0    21.6KB     328.
#> 2 fp()         27.3ms   28.1ms      35.6    82.5KB     250.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 36.6ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     276ms    278ms      3.60        0B     32.4
#> 2 fp(1e+06)     296ms    312ms      3.21    1.88KB     27.3
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 33.9ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.68s    2.68s     0.373        0B     17.9
#> 2 fp(1e+07)     2.76s    2.76s     0.362    1.88KB     17.4
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.98ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     26.4s    26.4s    0.0379        0B     20.1
#> 2 fp(1e+08)       28s      28s    0.0357    1.88KB     18.7
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 15.8ns
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
#> 1 f0()         88.4ms   93.1ms      7.39     781KB    14.8 
#> 2 f01()       106.8ms  107.8ms      8.93     781KB    10.7 
#> 3 fp()        133.5ms  165.7ms      5.20     783KB     8.67
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 726ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.17s    1.17s     0.852    7.63MB     5.96
#> 2 f01(1e+06)       2s       2s     0.500    7.63MB     2.00
#> 3 fp(1e+06)     1.57s    1.57s     0.638    7.63MB     3.83
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 394ns
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
#> 1 f0()         73.7ms   74.3ms      13.3    1.44MB     8.87
#> 2 f01()        88.4ms   89.6ms      11.0   781.3KB     5.52
#> 3 fp()         91.4ms   91.5ms      10.9  783.24KB    16.4
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 172ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 19.6ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  911.45ms 911.45ms     1.10     7.63MB     3.29
#> 2 f01(1e+06)    1.13s    1.13s     0.882    7.63MB     2.64
#> 3 fp(1e+06)     1.61s    1.61s     0.620    7.63MB     2.48
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 702ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 479ns
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
#> 1 f0()        27.24ms  34.83ms    29.3      39.3KB     1.96
#> 2 fp()          4.46s    4.46s     0.224   100.7KB     3.14
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 44.2µs
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
#> 1 f0()        46.23ms   48.3ms    19.5      18.7KB     1.95
#> 2 ff()        33.14ms  57.29ms    18.1      27.6KB     3.63
#> 3 fp()          3.98s    3.98s     0.251    25.1KB     1.51
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 39.3µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 89.9ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     244ms    281ms    3.56          0B     3.56
#> 2 ff(1e+06)   327.7ms  328.3ms    3.05       1.9KB     3.05
#> 3 fp(1e+06)     22.2s    22.2s    0.0451     1.9KB     2.57
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.9µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 47.3ns
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
#> 1 test_baseline()   703.48ms 703.48ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.09KB        0
#> 4 test_cli_unroll() 704.27ms 704.27ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 21m
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
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.86ms 6.01ms      162.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (500/s) | 3ms
#> ⠹ 2 done (67/s) | 30ms
#> ⠸ 3 done (82/s) | 37ms
#> ⠼ 4 done (84/s) | 48ms
#> ⠴ 5 done (90/s) | 56ms
#> ⠦ 6 done (95/s) | 64ms
#> ⠧ 7 done (99/s) | 71ms
#> ⠇ 8 done (102/s) | 79ms
#> ⠏ 9 done (105/s) | 86ms
#> ⠋ 10 done (107/s) | 94ms
#> ⠙ 11 done (109/s) | 102ms
#> ⠹ 12 done (111/s) | 109ms
#> ⠸ 13 done (113/s) | 116ms
#> ⠼ 14 done (115/s) | 123ms
#> ⠴ 15 done (116/s) | 129ms
#> ⠦ 16 done (118/s) | 136ms
#> ⠧ 17 done (119/s) | 143ms
#> ⠇ 18 done (120/s) | 150ms
#> ⠏ 19 done (121/s) | 157ms
#> ⠋ 20 done (122/s) | 164ms
#> ⠙ 21 done (123/s) | 171ms
#> ⠹ 22 done (124/s) | 178ms
#> ⠸ 23 done (125/s) | 185ms
#> ⠼ 24 done (125/s) | 192ms
#> ⠴ 25 done (126/s) | 199ms
#> ⠦ 26 done (127/s) | 206ms
#> ⠧ 27 done (127/s) | 213ms
#> ⠇ 28 done (127/s) | 220ms
#> ⠏ 29 done (128/s) | 227ms
#> ⠋ 30 done (128/s) | 234ms
#> ⠙ 31 done (129/s) | 241ms
#> ⠹ 32 done (129/s) | 248ms
#> ⠸ 33 done (130/s) | 255ms
#> ⠼ 34 done (130/s) | 262ms
#> ⠴ 35 done (130/s) | 269ms
#> ⠦ 36 done (131/s) | 276ms
#> ⠧ 37 done (131/s) | 283ms
#> ⠇ 38 done (131/s) | 290ms
#> ⠏ 39 done (132/s) | 297ms
#> ⠋ 40 done (132/s) | 304ms
#> ⠙ 41 done (132/s) | 311ms
#> ⠹ 42 done (132/s) | 318ms
#> ⠸ 43 done (133/s) | 325ms
#> ⠼ 44 done (133/s) | 332ms
#> ⠴ 45 done (133/s) | 339ms
#> ⠦ 46 done (133/s) | 346ms
#> ⠧ 47 done (133/s) | 353ms
#> ⠇ 48 done (134/s) | 360ms
#> ⠏ 49 done (134/s) | 367ms
#> ⠋ 50 done (134/s) | 373ms
#> ⠙ 51 done (134/s) | 380ms
#> ⠹ 52 done (134/s) | 387ms
#> ⠸ 53 done (135/s) | 394ms
#> ⠼ 54 done (135/s) | 401ms
#> ⠴ 55 done (135/s) | 408ms
#> ⠦ 56 done (135/s) | 415ms
#> ⠧ 57 done (135/s) | 422ms
#> ⠇ 58 done (135/s) | 429ms
#> ⠏ 59 done (136/s) | 436ms
#> ⠋ 60 done (136/s) | 443ms
#> ⠙ 61 done (136/s) | 450ms
#> ⠹ 62 done (136/s) | 457ms
#> ⠸ 63 done (136/s) | 463ms
#> ⠼ 64 done (136/s) | 470ms
#> ⠴ 65 done (136/s) | 477ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.79ms 6.94ms      142.     265KB     4.60
cli_progress_done()
```
