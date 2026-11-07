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
#> 1 __cli_update_due              0   10.1ns 95422594.        0B        0
#> 2 fun()                      90ns  110.1ns  6088005.        0B        0
#> 3 .Call(ccli_tick_reset)     80ns   90.1ns 10356857.        0B        0
#> 4 interactive()              10ns   10.1ns 64417230.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 23578136.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       80ns   91.2ns  9359373.        0B        0
#> 2 ta[[1]]        90ns    110ns  8046943.        0B        0
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
#> 1 f0()         21.9ms   22.1ms      45.2    21.6KB     407.
#> 2 fp()         23.8ms   23.9ms      41.9    82.5KB     356.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 17.5ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     240ms    240ms      4.17        0B     37.5
#> 2 fp(1e+06)     256ms    288ms      3.47     1.9KB     24.3
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 48.4ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.41s    2.41s     0.414        0B     19.5
#> 2 fp(1e+07)     2.45s    2.45s     0.408     1.9KB     19.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 4.01ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.5s    23.5s    0.0425        0B     22.1
#> 2 fp(1e+08)     24.9s    24.9s    0.0401     1.9KB     20.6
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 14ns
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
#> 1 f0()         70.4ms   86.4ms      8.78     781KB     20.5
#> 2 f01()        76.4ms   95.3ms     10.5      781KB     10.5
#> 3 fp()         97.6ms    112ms      8.09     783KB     12.9
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 256ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  795.57ms 795.57ms     1.26     7.63MB     8.80
#> 2 f01(1e+06)    1.23s    1.23s     0.816    7.63MB     5.71
#> 3 fp(1e+06)      1.6s     1.6s     0.625    7.63MB     5.00
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 804ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 374ns
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
#> 1 f0()         62.3ms   62.9ms     15.9     1.44MB     47.7
#> 2 f01()       100.1ms  100.1ms      9.99   781.3KB     40.0
#> 3 fp()        111.7ms  111.7ms      8.95  783.26KB     26.9
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 488ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 116ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  829.69ms 829.69ms     1.21     7.63MB     2.41
#> 2 f01(1e+06) 916.87ms 916.87ms     1.09     7.63MB     2.18
#> 3 fp(1e+06)     1.05s    1.05s     0.954    7.63MB     2.86
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 219ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 132ns
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
#> 1 f0()        22.33ms  22.45ms    44.0      39.3KB     1.91
#> 2 fp()          3.13s    3.13s     0.320   100.8KB     2.56
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 31µs
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
#> 1 f0()        21.39ms  21.55ms    43.3      18.7KB     3.94
#> 2 ff()        28.93ms  29.07ms    32.7      27.6KB     1.92
#> 3 fp()          1.74s    1.74s     0.574    25.1KB     2.30
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 17.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 75.2ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     216ms    266ms    3.95          0B     2.64
#> 2 ff(1e+06)     310ms    317ms    3.15      1.91KB     1.58
#> 3 fp(1e+06)       19s      19s    0.0526    1.91KB     2.21
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 18.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 51.7ns
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
#> 1 test_baseline()    68.37ms   68.4ms    14.6      2.08KB        0
#> 2 test_modulo()        1.36s    1.36s     0.734    2.24KB        0
#> 3 test_cli()        788.58ms 788.58ms     1.27    24.11KB        0
#> 4 test_cli_unroll()  83.22ms  87.24ms    11.2      3.58KB        0
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
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
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
#> 1 cli_progress_update(force… 4.82ms  4.9ms      201.    1.44MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (627/s) | 2ms
#> ⠹ 2 done (91/s) | 23ms
#> ⠸ 3 done (108/s) | 28ms
#> ⠼ 4 done (119/s) | 34ms
#> ⠴ 5 done (128/s) | 40ms
#> ⠦ 6 done (134/s) | 45ms
#> ⠧ 7 done (139/s) | 51ms
#> ⠇ 8 done (142/s) | 57ms
#> ⠏ 9 done (145/s) | 63ms
#> ⠋ 10 done (148/s) | 68ms
#> ⠙ 11 done (150/s) | 74ms
#> ⠹ 12 done (152/s) | 80ms
#> ⠸ 13 done (153/s) | 85ms
#> ⠼ 14 done (155/s) | 91ms
#> ⠴ 15 done (156/s) | 97ms
#> ⠦ 16 done (158/s) | 102ms
#> ⠧ 17 done (158/s) | 108ms
#> ⠇ 18 done (159/s) | 114ms
#> ⠏ 19 done (160/s) | 119ms
#> ⠋ 20 done (161/s) | 125ms
#> ⠙ 21 done (162/s) | 131ms
#> ⠹ 22 done (162/s) | 136ms
#> ⠸ 23 done (163/s) | 142ms
#> ⠼ 24 done (163/s) | 148ms
#> ⠴ 25 done (163/s) | 154ms
#> ⠦ 26 done (164/s) | 159ms
#> ⠧ 27 done (164/s) | 165ms
#> ⠇ 28 done (165/s) | 171ms
#> ⠏ 29 done (165/s) | 176ms
#> ⠋ 30 done (165/s) | 182ms
#> ⠙ 31 done (166/s) | 188ms
#> ⠹ 32 done (166/s) | 194ms
#> ⠸ 33 done (166/s) | 199ms
#> ⠼ 34 done (166/s) | 205ms
#> ⠴ 35 done (167/s) | 211ms
#> ⠦ 36 done (167/s) | 216ms
#> ⠧ 37 done (167/s) | 222ms
#> ⠇ 38 done (167/s) | 228ms
#> ⠏ 39 done (167/s) | 234ms
#> ⠋ 40 done (168/s) | 239ms
#> ⠙ 41 done (168/s) | 245ms
#> ⠹ 42 done (168/s) | 251ms
#> ⠸ 43 done (168/s) | 257ms
#> ⠼ 44 done (168/s) | 262ms
#> ⠴ 45 done (168/s) | 268ms
#> ⠦ 46 done (168/s) | 274ms
#> ⠧ 47 done (168/s) | 280ms
#> ⠇ 48 done (168/s) | 285ms
#> ⠏ 49 done (169/s) | 291ms
#> ⠋ 50 done (169/s) | 297ms
#> ⠙ 51 done (169/s) | 302ms
#> ⠹ 52 done (169/s) | 308ms
#> ⠸ 53 done (169/s) | 314ms
#> ⠼ 54 done (169/s) | 320ms
#> ⠴ 55 done (169/s) | 325ms
#> ⠦ 56 done (169/s) | 331ms
#> ⠧ 57 done (170/s) | 337ms
#> ⠇ 58 done (170/s) | 343ms
#> ⠏ 59 done (170/s) | 348ms
#> ⠋ 60 done (170/s) | 354ms
#> ⠙ 61 done (170/s) | 360ms
#> ⠹ 62 done (170/s) | 365ms
#> ⠸ 63 done (170/s) | 371ms
#> ⠼ 64 done (169/s) | 380ms
#> ⠴ 65 done (169/s) | 386ms
#> ⠦ 66 done (169/s) | 391ms
#> ⠧ 67 done (169/s) | 397ms
#> ⠇ 68 done (169/s) | 402ms
#> ⠏ 69 done (169/s) | 408ms
#> ⠋ 70 done (169/s) | 414ms
#> ⠙ 71 done (169/s) | 420ms
#> ⠹ 72 done (170/s) | 425ms
#> ⠸ 73 done (170/s) | 431ms
#> ⠼ 74 done (170/s) | 437ms
#> ⠴ 75 done (170/s) | 442ms
#> ⠦ 76 done (170/s) | 448ms
#> ⠧ 77 done (170/s) | 454ms
#> ⠇ 78 done (170/s) | 459ms
#> ⠏ 79 done (170/s) | 465ms
#> ⠋ 80 done (170/s) | 471ms
#> ⠙ 81 done (170/s) | 477ms
#> ⠹ 82 done (170/s) | 482ms
#> ⠸ 83 done (170/s) | 488ms
#> ⠼ 84 done (170/s) | 494ms
#> ⠴ 85 done (170/s) | 499ms
#> ⠦ 86 done (170/s) | 505ms
#> ⠧ 87 done (170/s) | 511ms
#> ⠇ 88 done (171/s) | 516ms
#> ⠏ 89 done (171/s) | 522ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.58ms 5.69ms      176.     266KB     2.02
cli_progress_done()
```
