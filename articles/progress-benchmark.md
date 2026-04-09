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
#> 1 __cli_update_due           10ns   10.1ns 78821853.        0B        0
#> 2 fun()                     120ns    140ns  4903891.        0B        0
#> 3 .Call(ccli_tick_reset)    110ns    140ns  7030356.        0B        0
#> 4 interactive()              10ns     20ns 55013184.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns 40.2ns 21052843.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       90ns    110ns  7952349.        0B       0 
#> 2 ta[[1]]       110ns    130ns  6441682.        0B     644.
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
#> 1 f0()         24.1ms   24.2ms      41.3    21.6KB     220.
#> 2 fp()         26.6ms   26.7ms      37.1    82.3KB     173.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 25.4ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     260ms    262ms      3.81        0B     32.4
#> 2 fp(1e+06)     284ms    286ms      3.50    1.88KB     29.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 23.4ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.63s    2.63s     0.380        0B     31.9
#> 2 fp(1e+07)     2.83s    2.83s     0.353    1.88KB     29.3
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 20.6ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.8s    25.8s    0.0387        0B     18.8
#> 2 fp(1e+08)     27.7s    27.7s    0.0361    1.88KB     17.4
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.6ns
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
#> 1 f0()         89.2ms   91.7ms     10.6      781KB    14.1 
#> 2 f01()       117.8ms  128.5ms      7.59     781KB     9.49
#> 3 fp()        135.2ms  143.9ms      6.43     783KB    11.3
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 522ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  998.66ms 998.66ms     1.00     7.63MB     7.01
#> 2 f01(1e+06)    1.58s    1.58s     0.633    7.63MB     4.43
#> 3 fp(1e+06)     2.12s    2.12s     0.471    7.63MB     1.88
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.12µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 543ns
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
#> 1 f0()         76.5ms   77.1ms     12.9     1.41MB     5.15
#> 2 f01()        92.8ms   94.1ms     10.6    781.3KB     5.30
#> 3 fp()         97.7ms  103.5ms      9.62  783.24KB     6.41
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 263ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 93.9ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  933.62ms 933.62ms     1.07     7.63MB     2.14
#> 2 f01(1e+06)    1.27s    1.27s     0.788    7.63MB     3.15
#> 3 fp(1e+06)     1.72s    1.72s     0.581    7.63MB     2.32
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 787ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 452ns
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
#> 1 f0()        24.09ms  24.18ms    40.7      39.3KB     1.94
#> 2 fp()          3.91s    3.91s     0.256   100.4KB     2.56
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 38.9µs
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
#> 1 f0()        22.99ms  23.38ms    41.3      18.7KB     3.93
#> 2 ff()        31.88ms  32.08ms    29.9      27.6KB     3.98
#> 3 fp()          2.25s    2.25s     0.445    25.1KB     2.67
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 86.9ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   238.7ms  239.3ms    4.17          0B     4.17
#> 2 ff(1e+06)   318.6ms  359.6ms    2.78       1.9KB     2.78
#> 3 fp(1e+06)     22.1s    22.1s    0.0452     1.9KB     2.53
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.9µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 120ns
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
#> 1 test_baseline()   703.58ms 703.58ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   23.88KB        0
#> 4 test_cli_unroll() 704.42ms 704.42ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 24m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.98ms 6.08ms      159.    1.39MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (506/s) | 3ms
#> ⠹ 2 done (71/s) | 29ms
#> ⠸ 3 done (85/s) | 36ms
#> ⠼ 4 done (91/s) | 45ms
#> ⠴ 5 done (98/s) | 52ms
#> ⠦ 6 done (103/s) | 59ms
#> ⠧ 7 done (107/s) | 66ms
#> ⠇ 8 done (111/s) | 73ms
#> ⠏ 9 done (114/s) | 80ms
#> ⠋ 10 done (116/s) | 87ms
#> ⠙ 11 done (118/s) | 94ms
#> ⠹ 12 done (119/s) | 101ms
#> ⠸ 13 done (121/s) | 108ms
#> ⠼ 14 done (122/s) | 115ms
#> ⠴ 15 done (123/s) | 122ms
#> ⠦ 16 done (124/s) | 129ms
#> ⠧ 17 done (125/s) | 137ms
#> ⠇ 18 done (126/s) | 144ms
#> ⠏ 19 done (127/s) | 151ms
#> ⠋ 20 done (127/s) | 158ms
#> ⠙ 21 done (128/s) | 165ms
#> ⠹ 22 done (128/s) | 172ms
#> ⠸ 23 done (129/s) | 179ms
#> ⠼ 24 done (129/s) | 186ms
#> ⠴ 25 done (130/s) | 194ms
#> ⠦ 26 done (130/s) | 201ms
#> ⠧ 27 done (130/s) | 208ms
#> ⠇ 28 done (131/s) | 215ms
#> ⠏ 29 done (131/s) | 222ms
#> ⠋ 30 done (131/s) | 229ms
#> ⠙ 31 done (131/s) | 236ms
#> ⠹ 32 done (132/s) | 243ms
#> ⠸ 33 done (132/s) | 251ms
#> ⠼ 34 done (132/s) | 258ms
#> ⠴ 35 done (132/s) | 265ms
#> ⠦ 36 done (133/s) | 272ms
#> ⠧ 37 done (133/s) | 279ms
#> ⠇ 38 done (133/s) | 286ms
#> ⠏ 39 done (133/s) | 293ms
#> ⠋ 40 done (133/s) | 300ms
#> ⠙ 41 done (134/s) | 307ms
#> ⠹ 42 done (134/s) | 314ms
#> ⠸ 43 done (134/s) | 322ms
#> ⠼ 44 done (134/s) | 329ms
#> ⠴ 45 done (134/s) | 336ms
#> ⠦ 46 done (134/s) | 343ms
#> ⠧ 47 done (133/s) | 354ms
#> ⠇ 48 done (133/s) | 363ms
#> ⠏ 49 done (132/s) | 370ms
#> ⠋ 50 done (132/s) | 378ms
#> ⠙ 51 done (132/s) | 386ms
#> ⠹ 52 done (132/s) | 394ms
#> ⠸ 53 done (132/s) | 402ms
#> ⠼ 54 done (132/s) | 410ms
#> ⠴ 55 done (132/s) | 417ms
#> ⠦ 56 done (132/s) | 424ms
#> ⠧ 57 done (132/s) | 431ms
#> ⠇ 58 done (133/s) | 438ms
#> ⠏ 59 done (133/s) | 445ms
#> ⠋ 60 done (133/s) | 453ms
#> ⠙ 61 done (133/s) | 460ms
#> ⠹ 62 done (133/s) | 467ms
#> ⠸ 63 done (133/s) | 474ms
#> ⠼ 64 done (133/s) | 481ms
#> ⠴ 65 done (133/s) | 488ms
#> ⠦ 66 done (133/s) | 496ms
#> ⠧ 67 done (133/s) | 503ms
#> ⠇ 68 done (134/s) | 510ms
#> ⠏ 69 done (134/s) | 517ms
#> ⠋ 70 done (134/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.99ms 7.11ms      139.     265KB     2.04
cli_progress_done()
```
