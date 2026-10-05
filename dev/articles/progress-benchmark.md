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
#> 1 __cli_update_due              0   10.1ns 91018438.        0B        0
#> 2 fun()                    79.9ns  100.9ns  6350673.        0B        0
#> 3 .Call(ccli_tick_reset)     80ns    101ns  8895247.        0B        0
#> 4 interactive()              10ns   10.1ns 67424918.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 19865888.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    120ns  7403052.        0B        0
#> 2 ta[[1]]       100ns    130ns  6941505.        0B        0
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
#> 1 f0()         18.7ms   18.7ms      53.5    21.6KB     357.
#> 2 fp()         20.8ms   21.3ms      46.9    82.5KB     469.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 26.5ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     207ms    208ms      4.81        0B     43.3
#> 2 fp(1e+06)     213ms    256ms      3.91     1.9KB     23.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 48.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.09s    2.09s     0.478        0B     22.9
#> 2 fp(1e+07)     2.13s    2.13s     0.469     1.9KB     22.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 3.73ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     20.4s    20.4s    0.0491        0B     25.7
#> 2 fp(1e+08)     21.9s    21.9s    0.0457     1.9KB     23.7
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 15.1ns
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
#> 1 f0()           74ms   85.8ms      8.62     781KB    19.0 
#> 2 f01()        86.4ms   89.7ms      9.92     781KB     9.92
#> 3 fp()         93.7ms  102.4ms      9.52     783KB    13.3
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 166ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  965.17ms 965.17ms     1.04     7.63MB     7.25
#> 2 f01(1e+06)    2.79s    2.79s     0.359    7.63MB     2.87
#> 3 fp(1e+06)  909.62ms 909.62ms     1.10     7.63MB     2.20
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1ns
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
#> 1 f0()         57.9ms   58.2ms      17.1    1.44MB     4.89
#> 2 f01()        70.5ms   72.2ms      13.1   781.3KB     5.24
#> 3 fp()           72ms   75.4ms      13.0  783.26KB     5.18
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 171ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 31.5ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  732.57ms 732.57ms     1.37     7.63MB     2.73
#> 2 f01(1e+06) 895.25ms 895.25ms     1.12     7.63MB     2.23
#> 3 fp(1e+06)     1.37s    1.37s     0.731    7.63MB     2.19
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 636ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 473ns
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
#> 1 f0()        20.86ms   25.6ms    37.6      39.3KB     1.98
#> 2 fp()          3.43s    3.43s     0.292   100.8KB     2.63
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 34µs
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
#> 1 f0()        18.14ms  38.98ms    26.9      18.7KB     3.84
#> 2 ff()        25.25ms  44.61ms    23.5      27.6KB     1.96
#> 3 fp()          1.97s    1.97s     0.508    25.1KB     2.54
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 19.3µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 56.3ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   183.3ms  183.6ms    5.37          0B     5.37
#> 2 ff(1e+06)   245.7ms  248.1ms    4.04      1.91KB     2.70
#> 3 fp(1e+06)     17.1s    17.1s    0.0584    1.91KB     2.45
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 16.9µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 64.5ns
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
#> 1 test_baseline()    547.1ms  547.1ms     1.83     2.08KB        0
#> 2 test_modulo()         1.1s     1.1s     0.909    2.24KB        0
#> 3 test_cli()         792.5ms  792.5ms     1.26    24.11KB        0
#> 4 test_cli_unroll()  550.1ms  550.1ms     1.82     3.58KB        0
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
#> ■                                  0% | ETA:  3m
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
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
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 11m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.72ms 4.88ms      202.    1.42MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (614/s) | 2ms
#> ⠹ 2 done (82/s) | 25ms
#> ⠸ 3 done (98/s) | 31ms
#> ⠼ 4 done (109/s) | 37ms
#> ⠴ 5 done (118/s) | 43ms
#> ⠦ 6 done (125/s) | 49ms
#> ⠧ 7 done (130/s) | 54ms
#> ⠇ 8 done (135/s) | 60ms
#> ⠏ 9 done (139/s) | 65ms
#> ⠋ 10 done (142/s) | 71ms
#> ⠙ 11 done (144/s) | 77ms
#> ⠹ 12 done (146/s) | 83ms
#> ⠸ 13 done (148/s) | 88ms
#> ⠼ 14 done (150/s) | 94ms
#> ⠴ 15 done (152/s) | 99ms
#> ⠦ 16 done (153/s) | 105ms
#> ⠧ 17 done (155/s) | 110ms
#> ⠇ 18 done (156/s) | 116ms
#> ⠏ 19 done (157/s) | 122ms
#> ⠋ 20 done (152/s) | 132ms
#> ⠙ 21 done (153/s) | 138ms
#> ⠹ 22 done (154/s) | 144ms
#> ⠸ 23 done (155/s) | 149ms
#> ⠼ 24 done (156/s) | 155ms
#> ⠴ 25 done (156/s) | 160ms
#> ⠦ 26 done (157/s) | 166ms
#> ⠧ 27 done (158/s) | 172ms
#> ⠇ 28 done (158/s) | 177ms
#> ⠏ 29 done (159/s) | 183ms
#> ⠋ 30 done (160/s) | 189ms
#> ⠙ 31 done (160/s) | 194ms
#> ⠹ 32 done (161/s) | 200ms
#> ⠸ 33 done (161/s) | 205ms
#> ⠼ 34 done (162/s) | 211ms
#> ⠴ 35 done (162/s) | 217ms
#> ⠦ 36 done (162/s) | 222ms
#> ⠧ 37 done (163/s) | 228ms
#> ⠇ 38 done (163/s) | 234ms
#> ⠏ 39 done (163/s) | 239ms
#> ⠋ 40 done (164/s) | 245ms
#> ⠙ 41 done (164/s) | 251ms
#> ⠹ 42 done (164/s) | 256ms
#> ⠸ 43 done (165/s) | 262ms
#> ⠼ 44 done (165/s) | 267ms
#> ⠴ 45 done (165/s) | 273ms
#> ⠦ 46 done (165/s) | 279ms
#> ⠧ 47 done (166/s) | 284ms
#> ⠇ 48 done (166/s) | 290ms
#> ⠏ 49 done (166/s) | 296ms
#> ⠋ 50 done (166/s) | 301ms
#> ⠙ 51 done (166/s) | 307ms
#> ⠹ 52 done (167/s) | 313ms
#> ⠸ 53 done (167/s) | 318ms
#> ⠼ 54 done (167/s) | 324ms
#> ⠴ 55 done (167/s) | 330ms
#> ⠦ 56 done (167/s) | 336ms
#> ⠧ 57 done (167/s) | 341ms
#> ⠇ 58 done (167/s) | 347ms
#> ⠏ 59 done (168/s) | 353ms
#> ⠋ 60 done (168/s) | 358ms
#> ⠙ 61 done (168/s) | 364ms
#> ⠹ 62 done (168/s) | 370ms
#> ⠸ 63 done (168/s) | 375ms
#> ⠼ 64 done (168/s) | 381ms
#> ⠴ 65 done (168/s) | 387ms
#> ⠦ 66 done (169/s) | 392ms
#> ⠧ 67 done (169/s) | 398ms
#> ⠇ 68 done (169/s) | 404ms
#> ⠏ 69 done (169/s) | 409ms
#> ⠋ 70 done (169/s) | 415ms
#> ⠙ 71 done (169/s) | 421ms
#> ⠹ 72 done (169/s) | 426ms
#> ⠸ 73 done (169/s) | 432ms
#> ⠼ 74 done (169/s) | 438ms
#> ⠴ 75 done (169/s) | 444ms
#> ⠦ 76 done (169/s) | 449ms
#> ⠧ 77 done (169/s) | 456ms
#> ⠇ 78 done (169/s) | 461ms
#> ⠏ 79 done (169/s) | 467ms
#> ⠋ 80 done (169/s) | 473ms
#> ⠙ 81 done (169/s) | 479ms
#> ⠹ 82 done (169/s) | 484ms
#> ⠸ 83 done (169/s) | 490ms
#> ⠼ 84 done (170/s) | 496ms
#> ⠴ 85 done (170/s) | 502ms
#> ⠦ 86 done (170/s) | 507ms
#> ⠧ 87 done (170/s) | 513ms
#> ⠇ 88 done (170/s) | 519ms
#> ⠏ 89 done (170/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.44ms 5.66ms      176.     266KB     2.03
cli_progress_done()
```
