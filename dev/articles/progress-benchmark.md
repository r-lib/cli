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
#> 1 __cli_update_due              0   10.1ns 84033974.        0B        0
#> 2 fun()                  120.02ns  141.1ns  4726078.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  111.1ns  8510438.        0B        0
#> 4 interactive()            8.96ns   10.1ns 62030639.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.1ns 40.2ns 22194069.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    151ns  6229927.        0B       0 
#> 2 ta[[1]]       150ns    170ns  5325931.        0B     533.
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
#> 1 f0()         22.1ms   22.3ms      44.7    21.6KB     253.
#> 2 fp()         25.2ms   25.2ms      39.3    82.3KB     196.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28.6ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     247ms    251ms      4.00        0B     33.4
#> 2 fp(1e+06)     270ms    271ms      3.69    1.88KB     31.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.9ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.56s    2.56s     0.390        0B     32.8
#> 2 fp(1e+07)     2.62s    2.62s     0.381    1.88KB     32.0
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 5.97ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.8s    23.8s    0.0421        0B     20.5
#> 2 fp(1e+08)     25.6s    25.6s    0.0390    1.88KB     18.9
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.8ns
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
#> 1 f0()         85.1ms   93.7ms     10.5      781KB     12.3
#> 2 f01()       117.6ms  122.9ms      7.58     781KB     13.3
#> 3 fp()        127.8ms  130.9ms      7.45     783KB     13.0
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 372ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   893.6ms  893.6ms     1.12     7.63MB     4.48
#> 2 f01(1e+06)    1.13s    1.13s     0.882    7.63MB     5.29
#> 3 fp(1e+06)     1.43s    1.43s     0.698    7.63MB     3.49
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 538ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 298ns
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
#> 1 f0()         79.1ms   79.5ms      12.5    1.41MB     4.98
#> 2 f01()        90.8ms   90.9ms      11.0   781.3KB    16.5 
#> 3 fp()         94.1ms   96.6ms      10.4  783.24KB     6.94
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 171ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 57ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     2.19s    2.19s     0.457    7.63MB    0.914
#> 2 f01(1e+06)    1.13s    1.13s     0.884    7.63MB    3.54 
#> 3 fp(1e+06)     1.49s    1.49s     0.674    7.63MB    2.69
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 353ns
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
#> 1 f0()        26.59ms  32.08ms    30.8      39.3KB     3.84
#> 2 fp()          4.57s    4.57s     0.219   100.4KB     3.50
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 45.3µs
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
#> 1 f0()        22.34ms  44.57ms    23.6      18.7KB     3.93
#> 2 ff()        31.62ms  50.95ms    21.4      27.6KB     3.89
#> 3 fp()          2.55s    2.55s     0.392    25.1KB     3.13
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 25.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 63.8ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     223ms    223ms    4.47          0B     4.47
#> 2 ff(1e+06)   313.7ms    315ms    3.17       1.9KB     3.17
#> 3 fp(1e+06)     22.4s    22.4s    0.0447     1.9KB     2.41
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.2µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 92.1ns
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
#> 1 test_baseline()   633.74ms 633.74ms     1.58     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.802    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802    23.9KB        0
#> 4 test_cli_unroll() 624.55ms 624.55ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
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
#> 1 cli_progress_update(force… 6.43ms 6.63ms      147.     1.4MB     2.05
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (451/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (77/s) | 39ms
#> ⠼ 4 done (86/s) | 47ms
#> ⠴ 5 done (92/s) | 55ms
#> ⠦ 6 done (96/s) | 63ms
#> ⠧ 7 done (100/s) | 71ms
#> ⠇ 8 done (103/s) | 79ms
#> ⠏ 9 done (105/s) | 86ms
#> ⠋ 10 done (107/s) | 94ms
#> ⠙ 11 done (109/s) | 101ms
#> ⠹ 12 done (111/s) | 109ms
#> ⠸ 13 done (112/s) | 116ms
#> ⠼ 14 done (114/s) | 124ms
#> ⠴ 15 done (115/s) | 131ms
#> ⠦ 16 done (116/s) | 139ms
#> ⠧ 17 done (117/s) | 146ms
#> ⠇ 18 done (117/s) | 154ms
#> ⠏ 19 done (118/s) | 161ms
#> ⠋ 20 done (119/s) | 169ms
#> ⠙ 21 done (119/s) | 177ms
#> ⠹ 22 done (117/s) | 189ms
#> ⠸ 23 done (117/s) | 198ms
#> ⠼ 24 done (117/s) | 206ms
#> ⠴ 25 done (117/s) | 215ms
#> ⠦ 26 done (117/s) | 224ms
#> ⠧ 27 done (117/s) | 232ms
#> ⠇ 28 done (117/s) | 241ms
#> ⠏ 29 done (117/s) | 249ms
#> ⠋ 30 done (117/s) | 256ms
#> ⠙ 31 done (118/s) | 264ms
#> ⠹ 32 done (118/s) | 271ms
#> ⠸ 33 done (119/s) | 279ms
#> ⠼ 34 done (119/s) | 287ms
#> ⠴ 35 done (119/s) | 294ms
#> ⠦ 36 done (120/s) | 302ms
#> ⠧ 37 done (120/s) | 309ms
#> ⠇ 38 done (120/s) | 317ms
#> ⠏ 39 done (121/s) | 324ms
#> ⠋ 40 done (121/s) | 332ms
#> ⠙ 41 done (121/s) | 339ms
#> ⠹ 42 done (121/s) | 347ms
#> ⠸ 43 done (122/s) | 354ms
#> ⠼ 44 done (122/s) | 362ms
#> ⠴ 45 done (122/s) | 369ms
#> ⠦ 46 done (122/s) | 377ms
#> ⠧ 47 done (122/s) | 384ms
#> ⠇ 48 done (123/s) | 392ms
#> ⠏ 49 done (123/s) | 400ms
#> ⠋ 50 done (123/s) | 407ms
#> ⠙ 51 done (123/s) | 415ms
#> ⠹ 52 done (123/s) | 422ms
#> ⠸ 53 done (124/s) | 430ms
#> ⠼ 54 done (124/s) | 437ms
#> ⠴ 55 done (124/s) | 445ms
#> ⠦ 56 done (124/s) | 452ms
#> ⠧ 57 done (124/s) | 460ms
#> ⠇ 58 done (124/s) | 467ms
#> ⠏ 59 done (124/s) | 475ms
#> ⠋ 60 done (125/s) | 482ms
#> ⠙ 61 done (125/s) | 490ms
#> ⠹ 62 done (125/s) | 497ms
#> ⠸ 63 done (125/s) | 505ms
#> ⠼ 64 done (125/s) | 512ms
#> ⠴ 65 done (125/s) | 520ms
#> ⠦ 66 done (125/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.41ms 7.54ms      131.     265KB     2.04
cli_progress_done()
```
