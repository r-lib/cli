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
#> 1 __cli_update_due              0     10ns    1.14e8        0B        0
#> 2 fun()                  130.04ns    161ns    4.29e6        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    120ns    8.01e6        0B        0
#> 4 interactive()            8.85ns     10ns    7.47e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 31.1ns 40.2ns 20664936.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      140ns    160ns  5820760.        0B        0
#> 2 ta[[1]]       160ns    181ns  5028841.        0B        0
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
#> 1 f0()         22.2ms   22.3ms      44.8    21.6KB     404.
#> 2 fp()         24.8ms   24.8ms      40.3    82.5KB     323.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 25.1ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     250ms    250ms      4.00        0B     36.0
#> 2 fp(1e+06)     268ms    268ms      3.73    1.88KB     31.7
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 18.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.45s    2.45s     0.408        0B     19.6
#> 2 fp(1e+07)     2.52s    2.52s     0.396    1.88KB     19.0
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.27ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)       24s      24s    0.0417        0B     22.1
#> 2 fp(1e+08)     25.3s    25.3s    0.0395    1.88KB     20.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 13.4ns
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
#> 1 f0()         90.9ms   95.6ms      7.55     781KB    15.1 
#> 2 f01()       109.2ms  111.7ms      7.91     781KB     9.49
#> 3 fp()        133.9ms  138.4ms      7.09     783KB     8.87
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 428ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.04s    1.04s     0.961    7.63MB     6.73
#> 2 f01(1e+06)       2s       2s     0.500    7.63MB     2.50
#> 3 fp(1e+06)     1.23s    1.23s     0.813    7.63MB     4.07
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 189ns
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
#> 1 f0()         80.2ms   80.4ms     12.3     1.44MB     6.17
#> 2 f01()        96.3ms     97ms     10.3    781.3KB     5.14
#> 3 fp()         98.8ms  100.4ms      9.91  783.24KB     6.61
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 201ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 34.6ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  895.62ms 895.62ms     1.12     7.63MB     2.23
#> 2 f01(1e+06)    1.18s    1.18s     0.851    7.63MB     2.55
#> 3 fp(1e+06)     1.21s    1.21s     0.824    7.63MB     2.47
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 317ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 38.5ns
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
#> 1 f0()        22.84ms  22.98ms    42.3      39.3KB     3.85
#> 2 fp()          4.04s    4.04s     0.247   100.7KB     1.98
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 40.2µs
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
#> 1 f0()        21.55ms  21.72ms    44.0      18.7KB     4.00
#> 2 ff()        31.59ms  32.21ms    25.2      27.6KB     1.94
#> 3 fp()          2.29s    2.29s     0.437    25.1KB     2.18
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.7µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 105ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   233.9ms  245.9ms    4.13          0B     2.76
#> 2 ff(1e+06)   333.7ms  334.4ms    2.99       1.9KB     2.99
#> 3 fp(1e+06)     23.3s    23.3s    0.0428     1.9KB     2.01
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.1µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 88.4ns
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
#> 1 test_baseline()   623.65ms 623.65ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.09KB        0
#> 4 test_cli_unroll() 624.82ms 624.82ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 46m
#> ■                                  0% | ETA: 41m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
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
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 15m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.46ms 6.72ms      146.    1.41MB     2.05
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (444/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (76/s) | 40ms
#> ⠼ 4 done (84/s) | 48ms
#> ⠴ 5 done (90/s) | 56ms
#> ⠦ 6 done (95/s) | 64ms
#> ⠧ 7 done (98/s) | 72ms
#> ⠇ 8 done (101/s) | 80ms
#> ⠏ 9 done (103/s) | 88ms
#> ⠋ 10 done (105/s) | 96ms
#> ⠙ 11 done (107/s) | 104ms
#> ⠹ 12 done (108/s) | 112ms
#> ⠸ 13 done (109/s) | 120ms
#> ⠼ 14 done (110/s) | 128ms
#> ⠴ 15 done (111/s) | 136ms
#> ⠦ 16 done (112/s) | 144ms
#> ⠧ 17 done (112/s) | 152ms
#> ⠇ 18 done (113/s) | 160ms
#> ⠏ 19 done (113/s) | 168ms
#> ⠋ 20 done (114/s) | 176ms
#> ⠙ 21 done (115/s) | 184ms
#> ⠹ 22 done (115/s) | 192ms
#> ⠸ 23 done (115/s) | 200ms
#> ⠼ 24 done (116/s) | 208ms
#> ⠴ 25 done (116/s) | 216ms
#> ⠦ 26 done (116/s) | 224ms
#> ⠧ 27 done (117/s) | 232ms
#> ⠇ 28 done (117/s) | 240ms
#> ⠏ 29 done (117/s) | 248ms
#> ⠋ 30 done (118/s) | 255ms
#> ⠙ 31 done (118/s) | 263ms
#> ⠹ 32 done (118/s) | 271ms
#> ⠸ 33 done (119/s) | 279ms
#> ⠼ 34 done (119/s) | 287ms
#> ⠴ 35 done (119/s) | 295ms
#> ⠦ 36 done (119/s) | 303ms
#> ⠧ 37 done (119/s) | 311ms
#> ⠇ 38 done (120/s) | 319ms
#> ⠏ 39 done (120/s) | 326ms
#> ⠋ 40 done (120/s) | 334ms
#> ⠙ 41 done (120/s) | 342ms
#> ⠹ 42 done (120/s) | 351ms
#> ⠸ 43 done (120/s) | 358ms
#> ⠼ 44 done (120/s) | 366ms
#> ⠴ 45 done (121/s) | 374ms
#> ⠦ 46 done (121/s) | 382ms
#> ⠧ 47 done (121/s) | 389ms
#> ⠇ 48 done (121/s) | 397ms
#> ⠏ 49 done (121/s) | 405ms
#> ⠋ 50 done (121/s) | 413ms
#> ⠙ 51 done (121/s) | 420ms
#> ⠹ 52 done (122/s) | 428ms
#> ⠸ 53 done (122/s) | 436ms
#> ⠼ 54 done (122/s) | 444ms
#> ⠴ 55 done (122/s) | 451ms
#> ⠦ 56 done (122/s) | 459ms
#> ⠧ 57 done (122/s) | 467ms
#> ⠇ 58 done (122/s) | 474ms
#> ⠏ 59 done (123/s) | 482ms
#> ⠋ 60 done (123/s) | 490ms
#> ⠙ 61 done (123/s) | 497ms
#> ⠹ 62 done (123/s) | 505ms
#> ⠸ 63 done (123/s) | 513ms
#> ⠼ 64 done (123/s) | 520ms
#> ⠴ 65 done (123/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.56ms 7.85ms      127.     265KB     2.02
cli_progress_done()
```
