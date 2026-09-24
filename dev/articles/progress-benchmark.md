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
#> 1 __cli_update_due              0   10.1ns 75677191.        0B        0
#> 2 fun()                      80ns    101ns  6140350.        0B        0
#> 3 .Call(ccli_tick_reset)     80ns   90.1ns  9874511.        0B        0
#> 4 interactive()              10ns   10.1ns 66700791.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.9ns 39.9ns 23993426.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       90ns    110ns  8392563.        0B        0
#> 2 ta[[1]]      90.1ns    110ns  7419322.        0B        0
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
#> 1 f0()         18.9ms     19ms      52.7    21.6KB     351.
#> 2 fp()         20.7ms   20.9ms      47.8    82.5KB     478.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 19.1ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     214ms    218ms      4.42        0B     39.7
#> 2 fp(1e+06)     216ms    259ms      3.86     1.9KB     23.2
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 40.4ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.12s    2.12s     0.473        0B     22.7
#> 2 fp(1e+07)     2.17s    2.17s     0.461     1.9KB     21.7
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 5.18ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     20.7s    20.7s    0.0484        0B     25.4
#> 2 fp(1e+08)     21.9s    21.9s    0.0456     1.9KB     23.6
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 12.8ns
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
#> 1 f0()         75.9ms   88.5ms      8.32     781KB    18.3 
#> 2 f01()          88ms   92.7ms      9.88     781KB     9.88
#> 3 fp()         89.5ms    107ms      8.59     783KB    10.3
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 184ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  781.42ms 781.42ms     1.28     7.63MB     8.96
#> 2 f01(1e+06)    2.42s    2.42s     0.414    7.63MB     3.31
#> 3 fp(1e+06)  892.21ms 892.21ms     1.12     7.63MB     2.24
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 111ns
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
#> 1 f0()         57.4ms   57.9ms      16.9    1.44MB     4.84
#> 2 f01()        70.7ms     74ms      13.4   781.3KB     6.69
#> 3 fp()         72.1ms   73.9ms      12.9  783.26KB     2.15
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 160ns
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
#> 1 f0(1e+06)  699.03ms 699.03ms     1.43     7.63MB     2.86
#> 2 f01(1e+06) 983.19ms 983.19ms     1.02     7.63MB     3.05
#> 3 fp(1e+06)     1.01s    1.01s     0.988    7.63MB     2.96
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 313ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 29ns
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
#> 1 f0()         18.8ms  18.96ms    50.3      39.3KB     1.94
#> 2 fp()          3.08s    3.08s     0.324   100.8KB     2.59
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 30.6µs
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
#> 1 f0()        17.82ms  18.82ms    45.7      18.7KB     3.98
#> 2 ff()        24.68ms   24.8ms    37.6      27.6KB     1.98
#> 3 fp()          1.68s    1.68s     0.594    25.1KB     2.37
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 16.7µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 59.8ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     187ms    189ms    5.09          0B     3.39
#> 2 ff(1e+06)     278ms    290ms    3.44      1.91KB     3.44
#> 3 fp(1e+06)       18s      18s    0.0557    1.91KB     2.34
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 17.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 101ns
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
#> 1 test_baseline()   545.42ms 545.42ms     1.83     2.08KB        0
#> 2 test_modulo()        1.09s    1.09s     0.914    2.24KB        0
#> 3 test_cli()        787.83ms 787.83ms     1.27    24.11KB        0
#> 4 test_cli_unroll() 547.77ms 547.77ms     1.83     3.58KB        0
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
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
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
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> ■                                  0% | ETA: 10m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.61ms 4.73ms      208.    1.41MB     2.02
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (579/s) | 2ms
#> ⠹ 2 done (84/s) | 24ms
#> ⠸ 3 done (102/s) | 30ms
#> ⠼ 4 done (114/s) | 36ms
#> ⠴ 5 done (123/s) | 41ms
#> ⠦ 6 done (130/s) | 47ms
#> ⠧ 7 done (135/s) | 53ms
#> ⠇ 8 done (139/s) | 58ms
#> ⠏ 9 done (143/s) | 64ms
#> ⠋ 10 done (146/s) | 69ms
#> ⠙ 11 done (149/s) | 75ms
#> ⠹ 12 done (151/s) | 80ms
#> ⠸ 13 done (153/s) | 86ms
#> ⠼ 14 done (155/s) | 91ms
#> ⠴ 15 done (156/s) | 97ms
#> ⠦ 16 done (152/s) | 106ms
#> ⠧ 17 done (153/s) | 111ms
#> ⠇ 18 done (155/s) | 117ms
#> ⠏ 19 done (156/s) | 122ms
#> ⠋ 20 done (157/s) | 128ms
#> ⠙ 21 done (159/s) | 133ms
#> ⠹ 22 done (160/s) | 138ms
#> ⠸ 23 done (160/s) | 144ms
#> ⠼ 24 done (161/s) | 149ms
#> ⠴ 25 done (162/s) | 155ms
#> ⠦ 26 done (163/s) | 161ms
#> ⠧ 27 done (163/s) | 166ms
#> ⠇ 28 done (164/s) | 172ms
#> ⠏ 29 done (164/s) | 177ms
#> ⠋ 30 done (165/s) | 183ms
#> ⠙ 31 done (165/s) | 188ms
#> ⠹ 32 done (166/s) | 194ms
#> ⠸ 33 done (166/s) | 199ms
#> ⠼ 34 done (166/s) | 205ms
#> ⠴ 35 done (167/s) | 210ms
#> ⠦ 36 done (167/s) | 216ms
#> ⠧ 37 done (168/s) | 221ms
#> ⠇ 38 done (168/s) | 227ms
#> ⠏ 39 done (168/s) | 232ms
#> ⠋ 40 done (169/s) | 238ms
#> ⠙ 41 done (169/s) | 243ms
#> ⠹ 42 done (169/s) | 249ms
#> ⠸ 43 done (169/s) | 254ms
#> ⠼ 44 done (170/s) | 260ms
#> ⠴ 45 done (170/s) | 265ms
#> ⠦ 46 done (170/s) | 271ms
#> ⠧ 47 done (170/s) | 276ms
#> ⠇ 48 done (171/s) | 282ms
#> ⠏ 49 done (171/s) | 287ms
#> ⠋ 50 done (171/s) | 293ms
#> ⠙ 51 done (171/s) | 298ms
#> ⠹ 52 done (172/s) | 304ms
#> ⠸ 53 done (172/s) | 309ms
#> ⠼ 54 done (172/s) | 315ms
#> ⠴ 55 done (172/s) | 320ms
#> ⠦ 56 done (172/s) | 325ms
#> ⠧ 57 done (173/s) | 331ms
#> ⠇ 58 done (173/s) | 336ms
#> ⠏ 59 done (173/s) | 342ms
#> ⠋ 60 done (173/s) | 348ms
#> ⠙ 61 done (173/s) | 353ms
#> ⠹ 62 done (173/s) | 358ms
#> ⠸ 63 done (173/s) | 364ms
#> ⠼ 64 done (174/s) | 369ms
#> ⠴ 65 done (174/s) | 375ms
#> ⠦ 66 done (174/s) | 380ms
#> ⠧ 67 done (174/s) | 386ms
#> ⠇ 68 done (174/s) | 392ms
#> ⠏ 69 done (174/s) | 397ms
#> ⠋ 70 done (174/s) | 403ms
#> ⠙ 71 done (174/s) | 408ms
#> ⠹ 72 done (174/s) | 414ms
#> ⠸ 73 done (174/s) | 419ms
#> ⠼ 74 done (174/s) | 425ms
#> ⠴ 75 done (175/s) | 430ms
#> ⠦ 76 done (175/s) | 436ms
#> ⠧ 77 done (175/s) | 441ms
#> ⠇ 78 done (175/s) | 447ms
#> ⠏ 79 done (175/s) | 452ms
#> ⠋ 80 done (175/s) | 458ms
#> ⠙ 81 done (175/s) | 464ms
#> ⠹ 82 done (175/s) | 469ms
#> ⠸ 83 done (175/s) | 475ms
#> ⠼ 84 done (175/s) | 480ms
#> ⠴ 85 done (175/s) | 486ms
#> ⠦ 86 done (175/s) | 492ms
#> ⠧ 87 done (175/s) | 497ms
#> ⠇ 88 done (175/s) | 503ms
#> ⠏ 89 done (175/s) | 508ms
#> ⠋ 90 done (175/s) | 514ms
#> ⠙ 91 done (175/s) | 519ms
#> ⠹ 92 done (175/s) | 525ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.35ms  5.5ms      181.     266KB     2.02
cli_progress_done()
```
