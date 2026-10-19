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
#> 1 __cli_update_due              0      1ns    1.64e8        0B        0
#> 2 fun()                    70.1ns   81.1ns    7.53e6        0B        0
#> 3 .Call(ccli_tick_reset)   70.1ns   90.1ns    1.06e7        0B        0
#> 4 interactive()                 0   10.1ns    1.07e8        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  20ns   30ns 32165101.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       70ns   80.1ns 11704110.        0B        0
#> 2 ta[[1]]        90ns  100.1ns  8560882.        0B        0
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
#> 1 f0()         14.4ms   14.5ms      54.0    21.6KB     396.
#> 2 fp()         16.2ms   16.2ms      60.7    82.5KB     486.
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
#> 1 f0(1e+06)     175ms    180ms      4.93        0B     44.3
#> 2 fp(1e+06)     163ms    165ms      6.08     1.9KB     27.4
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
#> 1 f0(1e+07)     1.66s    1.66s     0.604        0B     28.4
#> 2 fp(1e+07)     1.67s    1.67s     0.598     1.9KB     28.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 1.61ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     16.6s    16.6s    0.0604        0B     31.5
#> 2 fp(1e+08)     17.4s    17.4s    0.0576     1.9KB     29.9
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 8.17ns
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
#> 1 f0()         60.2ms   65.4ms      11.3     781KB     16.9
#> 2 f01()          72ms   84.5ms      10.5     781KB     15.8
#> 3 fp()         87.7ms   99.4ms      10.2     783KB     11.9
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 340ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  647.93ms 647.93ms     1.54     7.63MB    10.8 
#> 2 f01(1e+06)    1.92s    1.92s     0.522    7.63MB     4.18
#> 3 fp(1e+06)  683.76ms 683.76ms     1.46     7.63MB     2.92
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 35.8ns
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
#> 1 f0()         45.7ms   46.2ms      21.0    1.44MB     4.66
#> 2 f01()        55.9ms   60.6ms      16.2   781.3KB     5.40
#> 3 fp()         54.4ms   57.1ms      16.7  783.26KB     5.58
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 109ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 1ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     599ms    599ms      1.67    7.63MB     3.34
#> 2 f01(1e+06)    771ms    771ms      1.30    7.63MB     3.89
#> 3 fp(1e+06)     815ms    815ms      1.23    7.63MB     3.68
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 216ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 43.4ns
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
#> 1 f0()        14.61ms  14.79ms    65.9      39.3KB     3.99
#> 2 fp()          2.27s    2.27s     0.441   100.8KB     3.53
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 22.5µs
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
#> 1 f0()           14ms   14.2ms    62.6      18.7KB     3.91
#> 2 ff()         18.4ms   18.8ms    44.8      27.6KB     3.89
#> 3 fp()           1.2s     1.2s     0.835    25.1KB     3.34
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 11.8µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 46.2ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     144ms    164ms    6.11          0B     4.58
#> 2 ff(1e+06)     201ms    224ms    4.62      1.91KB     3.08
#> 3 fp(1e+06)       12s      12s    0.0837    1.91KB     3.68
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 11.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 59.9ns
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
#> 1 test_baseline()      445ms    451ms      2.22    2.08KB        0
#> 2 test_modulo()        784ms    784ms      1.28    2.24KB        0
#> 3 test_cli()           495ms    496ms      2.02   24.11KB        0
#> 4 test_cli_unroll()    446ms    448ms      2.23    3.58KB        0
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
#> ■                                  0% | ETA: 49m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 17m
#> ■                                  0% | ETA: 16m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
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
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  9m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  8m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> ■                                  0% | ETA:  7m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 3.58ms 3.78ms      261.    1.42MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (661/s) | 2ms
#> ⠹ 2 done (108/s) | 19ms
#> ⠸ 3 done (127/s) | 24ms
#> ⠼ 4 done (142/s) | 29ms
#> ⠴ 5 done (154/s) | 33ms
#> ⠦ 6 done (162/s) | 38ms
#> ⠧ 7 done (168/s) | 42ms
#> ⠇ 8 done (174/s) | 47ms
#> ⠏ 9 done (178/s) | 51ms
#> ⠋ 10 done (182/s) | 56ms
#> ⠙ 11 done (185/s) | 60ms
#> ⠹ 12 done (187/s) | 65ms
#> ⠸ 13 done (190/s) | 69ms
#> ⠼ 14 done (192/s) | 74ms
#> ⠴ 15 done (193/s) | 78ms
#> ⠦ 16 done (195/s) | 83ms
#> ⠧ 17 done (196/s) | 87ms
#> ⠇ 18 done (197/s) | 92ms
#> ⠏ 19 done (198/s) | 97ms
#> ⠋ 20 done (199/s) | 101ms
#> ⠙ 21 done (200/s) | 105ms
#> ⠹ 22 done (201/s) | 110ms
#> ⠸ 23 done (202/s) | 114ms
#> ⠼ 24 done (203/s) | 119ms
#> ⠴ 25 done (204/s) | 123ms
#> ⠦ 26 done (205/s) | 127ms
#> ⠧ 27 done (205/s) | 132ms
#> ⠇ 28 done (206/s) | 136ms
#> ⠏ 29 done (207/s) | 141ms
#> ⠋ 30 done (207/s) | 145ms
#> ⠙ 31 done (208/s) | 150ms
#> ⠹ 32 done (208/s) | 154ms
#> ⠸ 33 done (209/s) | 159ms
#> ⠼ 34 done (209/s) | 163ms
#> ⠴ 35 done (209/s) | 168ms
#> ⠦ 36 done (210/s) | 172ms
#> ⠧ 37 done (210/s) | 176ms
#> ⠇ 38 done (205/s) | 186ms
#> ⠏ 39 done (205/s) | 191ms
#> ⠋ 40 done (206/s) | 195ms
#> ⠙ 41 done (206/s) | 199ms
#> ⠹ 42 done (207/s) | 204ms
#> ⠸ 43 done (207/s) | 208ms
#> ⠼ 44 done (208/s) | 213ms
#> ⠴ 45 done (208/s) | 217ms
#> ⠦ 46 done (208/s) | 222ms
#> ⠧ 47 done (209/s) | 226ms
#> ⠇ 48 done (209/s) | 230ms
#> ⠏ 49 done (209/s) | 235ms
#> ⠋ 50 done (210/s) | 239ms
#> ⠙ 51 done (210/s) | 243ms
#> ⠹ 52 done (210/s) | 248ms
#> ⠸ 53 done (211/s) | 252ms
#> ⠼ 54 done (211/s) | 257ms
#> ⠴ 55 done (211/s) | 261ms
#> ⠦ 56 done (211/s) | 266ms
#> ⠧ 57 done (212/s) | 270ms
#> ⠇ 58 done (212/s) | 274ms
#> ⠏ 59 done (212/s) | 279ms
#> ⠋ 60 done (212/s) | 283ms
#> ⠙ 61 done (213/s) | 287ms
#> ⠹ 62 done (213/s) | 292ms
#> ⠸ 63 done (213/s) | 296ms
#> ⠼ 64 done (213/s) | 300ms
#> ⠴ 65 done (214/s) | 305ms
#> ⠦ 66 done (214/s) | 309ms
#> ⠧ 67 done (214/s) | 314ms
#> ⠇ 68 done (214/s) | 318ms
#> ⠏ 69 done (214/s) | 323ms
#> ⠋ 70 done (214/s) | 327ms
#> ⠙ 71 done (215/s) | 331ms
#> ⠹ 72 done (215/s) | 336ms
#> ⠸ 73 done (215/s) | 340ms
#> ⠼ 74 done (215/s) | 344ms
#> ⠴ 75 done (215/s) | 349ms
#> ⠦ 76 done (216/s) | 353ms
#> ⠧ 77 done (216/s) | 357ms
#> ⠇ 78 done (216/s) | 362ms
#> ⠏ 79 done (216/s) | 366ms
#> ⠋ 80 done (216/s) | 371ms
#> ⠙ 81 done (216/s) | 375ms
#> ⠹ 82 done (216/s) | 380ms
#> ⠸ 83 done (216/s) | 384ms
#> ⠼ 84 done (217/s) | 389ms
#> ⠴ 85 done (217/s) | 393ms
#> ⠦ 86 done (217/s) | 397ms
#> ⠧ 87 done (217/s) | 402ms
#> ⠇ 88 done (217/s) | 406ms
#> ⠏ 89 done (217/s) | 411ms
#> ⠋ 90 done (217/s) | 415ms
#> ⠙ 91 done (217/s) | 420ms
#> ⠹ 92 done (217/s) | 424ms
#> ⠸ 93 done (217/s) | 428ms
#> ⠼ 94 done (217/s) | 433ms
#> ⠴ 95 done (217/s) | 437ms
#> ⠦ 96 done (218/s) | 442ms
#> ⠧ 97 done (218/s) | 446ms
#> ⠇ 98 done (218/s) | 451ms
#> ⠏ 99 done (218/s) | 455ms
#> ⠋ 100 done (218/s) | 460ms
#> ⠙ 101 done (218/s) | 464ms
#> ⠹ 102 done (218/s) | 468ms
#> ⠸ 103 done (218/s) | 473ms
#> ⠼ 104 done (218/s) | 477ms
#> ⠴ 105 done (218/s) | 482ms
#> ⠦ 106 done (218/s) | 486ms
#> ⠧ 107 done (218/s) | 491ms
#> ⠇ 108 done (218/s) | 495ms
#> ⠏ 109 done (218/s) | 500ms
#> ⠋ 110 done (218/s) | 504ms
#> ⠙ 111 done (218/s) | 509ms
#> ⠹ 112 done (217/s) | 516ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.29ms 4.42ms      224.     266KB     2.04
cli_progress_done()
```
