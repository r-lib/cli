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
#> 1 __cli_update_due           10ns   10.1ns 75024736.        0B        0
#> 2 fun()                     110ns  131.1ns  4958412.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  110.1ns  8390912.        0B        0
#> 4 interactive()              10ns     20ns 57557973.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 29.9ns 39.9ns 26625128.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    121ns  7054042.        0B        0
#> 2 ta[[1]]       110ns    140ns  6219951.        0B        0
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
#> 1 f0()         24.1ms   24.2ms      41.3    21.6KB     330.
#> 2 fp()         27.2ms   27.4ms      36.6    82.5KB     274.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 31.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     271ms    273ms      3.66        0B     31.1
#> 2 fp(1e+06)     292ms    293ms      3.42    1.88KB     30.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.68s    2.68s     0.374        0B     18.3
#> 2 fp(1e+07)     2.75s    2.75s     0.364    1.88KB     17.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.21ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.9s    25.9s    0.0386        0B     20.5
#> 2 fp(1e+08)     27.6s    27.6s    0.0363    1.88KB     19.1
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.4ns
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
#> 1 f0()         86.2ms   89.5ms      7.82     781KB    15.6 
#> 2 f01()       101.2ms  104.4ms      9.25     781KB    11.1 
#> 3 fp()        115.6ms  122.3ms      7.32     783KB     9.15
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 328ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  995.22ms 995.22ms     1.00     7.63MB     7.03
#> 2 f01(1e+06)    2.63s    2.63s     0.379    7.63MB     3.04
#> 3 fp(1e+06)     1.09s    1.09s     0.916    7.63MB     1.83
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 96.2ns
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
#> 1 f0()         75.1ms   75.4ms      13.1    1.44MB     5.26
#> 2 f01()        88.9ms   92.3ms      10.7   781.3KB     2.15
#> 3 fp()         91.4ms   92.7ms      10.6  783.24KB     5.32
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 173ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 4.77ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  868.09ms 868.09ms     1.15     7.63MB     2.30
#> 2 f01(1e+06)    1.27s    1.27s     0.786    7.63MB     1.57
#> 3 fp(1e+06)     1.28s    1.28s     0.778    7.63MB     2.33
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 417ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 13.9ns
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
#> 1 f0()        24.71ms  29.75ms    30.6      39.3KB     1.91
#> 2 fp()          4.76s    4.76s     0.210   100.7KB     1.89
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 47.3µs
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
#> 1 f0()        23.31ms  49.04ms    21.2      18.7KB     1.93
#> 2 ff()        34.18ms  59.05ms    18.1      27.6KB     1.81
#> 3 fp()          2.37s    2.37s     0.422    25.1KB     1.69
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 100ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   511.1ms  511.1ms    1.96          0B     1.96
#> 2 ff(1e+06)   481.8ms  493.1ms    2.03       1.9KB     1.01
#> 3 fp(1e+06)     23.5s    23.5s    0.0425     1.9KB     1.78
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 1ns
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
#> 1 test_baseline()   703.78ms 703.78ms     1.42     2.08KB        0
#> 2 test_modulo()        1.43s    1.43s     0.702    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.982   24.09KB        0
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
#> ■                                  0% | ETA: 49m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.48ms 5.72ms      171.    1.41MB     2.22
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (474/s) | 3ms
#> ⠹ 2 done (17/s) | 116ms
#> ⠸ 3 done (24/s) | 124ms
#> ⠼ 4 done (31/s) | 130ms
#> ⠴ 5 done (37/s) | 137ms
#> ⠦ 6 done (42/s) | 144ms
#> ⠧ 7 done (46/s) | 151ms
#> ⠇ 8 done (51/s) | 158ms
#> ⠏ 9 done (55/s) | 165ms
#> ⠋ 10 done (58/s) | 172ms
#> ⠙ 11 done (62/s) | 179ms
#> ⠹ 12 done (65/s) | 186ms
#> ⠸ 13 done (68/s) | 193ms
#> ⠼ 14 done (70/s) | 200ms
#> ⠴ 15 done (73/s) | 207ms
#> ⠦ 16 done (75/s) | 214ms
#> ⠧ 17 done (77/s) | 221ms
#> ⠇ 18 done (79/s) | 228ms
#> ⠏ 19 done (81/s) | 235ms
#> ⠋ 20 done (83/s) | 241ms
#> ⠙ 21 done (85/s) | 248ms
#> ⠹ 22 done (86/s) | 255ms
#> ⠸ 23 done (88/s) | 262ms
#> ⠼ 24 done (89/s) | 269ms
#> ⠴ 25 done (91/s) | 276ms
#> ⠦ 26 done (92/s) | 283ms
#> ⠧ 27 done (93/s) | 290ms
#> ⠇ 28 done (95/s) | 297ms
#> ⠏ 29 done (96/s) | 304ms
#> ⠋ 30 done (97/s) | 311ms
#> ⠙ 31 done (98/s) | 318ms
#> ⠹ 32 done (99/s) | 325ms
#> ⠸ 33 done (100/s) | 332ms
#> ⠼ 34 done (101/s) | 339ms
#> ⠴ 35 done (101/s) | 345ms
#> ⠦ 36 done (102/s) | 352ms
#> ⠧ 37 done (103/s) | 359ms
#> ⠇ 38 done (104/s) | 366ms
#> ⠏ 39 done (105/s) | 373ms
#> ⠋ 40 done (105/s) | 380ms
#> ⠙ 41 done (106/s) | 387ms
#> ⠹ 42 done (107/s) | 394ms
#> ⠸ 43 done (107/s) | 401ms
#> ⠼ 44 done (108/s) | 408ms
#> ⠴ 45 done (109/s) | 415ms
#> ⠦ 46 done (108/s) | 427ms
#> ⠧ 47 done (109/s) | 433ms
#> ⠇ 48 done (109/s) | 440ms
#> ⠏ 49 done (110/s) | 446ms
#> ⠋ 50 done (111/s) | 453ms
#> ⠙ 51 done (111/s) | 460ms
#> ⠹ 52 done (112/s) | 466ms
#> ⠸ 53 done (112/s) | 473ms
#> ⠼ 54 done (113/s) | 480ms
#> ⠴ 55 done (113/s) | 487ms
#> ⠦ 56 done (114/s) | 494ms
#> ⠧ 57 done (114/s) | 500ms
#> ⠇ 58 done (115/s) | 507ms
#> ⠏ 59 done (115/s) | 514ms
#> ⠋ 60 done (115/s) | 521ms
#> ⠙ 61 done (116/s) | 527ms
#> ⠹ 62 done (116/s) | 534ms
#> ⠸ 63 done (117/s) | 541ms
#> ⠼ 64 done (117/s) | 548ms
#> ⠴ 65 done (117/s) | 555ms
#> ⠦ 66 done (118/s) | 562ms
#> ⠧ 67 done (118/s) | 569ms
#> ⠇ 68 done (118/s) | 575ms
#> ⠏ 69 done (119/s) | 582ms
#> ⠋ 70 done (119/s) | 589ms
#> ⠙ 71 done (119/s) | 596ms
#> ⠹ 72 done (120/s) | 603ms
#> ⠸ 73 done (120/s) | 609ms
#> ⠼ 74 done (120/s) | 616ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.52ms 6.89ms      145.     265KB     2.02
cli_progress_done()
```
