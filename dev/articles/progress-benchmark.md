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
#> 1 __cli_update_due              0   10.1ns 97479109.        0B        0
#> 2 fun()                      90ns  110.1ns  5839556.        0B        0
#> 3 .Call(ccli_tick_reset)     80ns   90.1ns 10323374.        0B        0
#> 4 interactive()              10ns   10.1ns 69316206.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 25094454.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]       80ns    100ns  8742237.        0B        0
#> 2 ta[[1]]        90ns    111ns  7652335.        0B        0
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
#> 1 f0()           22ms     22ms      45.5    21.6KB     409.
#> 2 fp()           24ms   24.2ms      41.4    82.5KB     352.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 21.7ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     255ms    256ms      3.91        0B     35.2
#> 2 fp(1e+06)     270ms    271ms      3.69     1.9KB     33.2
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 15.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)      2.5s     2.5s     0.400        0B     18.8
#> 2 fp(1e+07)     2.53s    2.53s     0.396     1.9KB     18.2
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 2.48ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     24.1s    24.1s    0.0415        0B     21.6
#> 2 fp(1e+08)     25.5s    25.5s    0.0392     1.9KB     20.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 14.2ns
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
#> 1 f0()         85.8ms   97.2ms      9.59     781KB     21.1
#> 2 f01()        92.2ms   97.5ms      6.74     781KB     10.1
#> 3 fp()         96.9ms  116.8ms      7.86     783KB     12.6
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 196ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  823.34ms 823.34ms     1.21     7.63MB     7.29
#> 2 f01(1e+06)    1.53s    1.53s     0.653    7.63MB     5.22
#> 3 fp(1e+06)     2.07s    2.07s     0.483    7.63MB     3.86
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.25µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 541ns
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
#> 1 f0()         61.9ms   62.5ms      15.9    1.44MB     5.30
#> 2 f01()        74.7ms   86.2ms      11.8   781.3KB    11.8 
#> 3 fp()         80.8ms   92.8ms      11.1  783.26KB     5.56
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 303ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 66.3ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   808.7ms  808.7ms     1.24     7.63MB     2.47
#> 2 f01(1e+06)    1.02s    1.02s     0.979    7.63MB     3.92
#> 3 fp(1e+06)     1.48s    1.48s     0.675    7.63MB     2.70
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 672ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 460ns
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
#> 1 f0()         25.9ms     32ms    30.8      39.3KB     1.92
#> 2 fp()           3.7s     3.7s     0.270   100.8KB     3.78
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 36.7µs
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
#> 1 f0()         25.2ms   48.8ms    20.6      18.7KB     3.75
#> 2 ff()         30.5ms   56.1ms    18.3      27.6KB     1.83
#> 3 fp()           2.1s     2.1s     0.475    25.1KB     3.33
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 20.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 73.3ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     222ms    223ms    4.49          0B     4.49
#> 2 ff(1e+06)     290ms    290ms    3.44      1.91KB     3.44
#> 3 fp(1e+06)       18s      18s    0.0556    1.91KB     3.39
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 17.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 67.8ns
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
#> 1 test_baseline()    68.17ms  68.39ms    14.6      2.08KB        0
#> 2 test_modulo()        1.36s    1.36s     0.734    2.24KB        0
#> 3 test_cli()        789.45ms 789.45ms     1.27    24.11KB        0
#> 4 test_cli_unroll()  83.45ms  90.98ms    11.0      3.58KB        0
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
#> ■                                  0% | ETA:  1d
#> ■                                  0% | ETA: 16h
#> ■                                  0% | ETA: 12h
#> ■                                  0% | ETA: 10h
#> ■                                  0% | ETA:  8h
#> ■                                  0% | ETA:  7h
#> ■                                  0% | ETA:  6h
#> ■                                  0% | ETA:  5h
#> ■                                  0% | ETA:  5h
#> ■                                  0% | ETA:  4h
#> ■                                  0% | ETA:  4h
#> ■                                  0% | ETA:  4h
#> ■                                  0% | ETA:  4h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  3h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 49m
#> ■                                  0% | ETA: 49m
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 48m
#> ■                                  0% | ETA: 47m
#> ■                                  0% | ETA: 47m
#> ■                                  0% | ETA: 46m
#> ■                                  0% | ETA: 46m
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 41m
#> ■                                  0% | ETA: 41m
#> ■                                  0% | ETA: 41m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 36m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.66ms  4.8ms      204.    1.44MB     2.02
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (563/s) | 2ms
#> ⠹ 2 done (87/s) | 24ms
#> ⠸ 3 done (103/s) | 30ms
#> ⠼ 4 done (114/s) | 36ms
#> ⠴ 5 done (123/s) | 41ms
#> ⠦ 6 done (130/s) | 47ms
#> ⠧ 7 done (135/s) | 52ms
#> ⠇ 8 done (139/s) | 58ms
#> ⠏ 9 done (143/s) | 63ms
#> ⠋ 10 done (146/s) | 69ms
#> ⠙ 11 done (149/s) | 74ms
#> ⠹ 12 done (151/s) | 80ms
#> ⠸ 13 done (152/s) | 86ms
#> ⠼ 14 done (154/s) | 91ms
#> ⠴ 15 done (155/s) | 97ms
#> ⠦ 16 done (157/s) | 103ms
#> ⠧ 17 done (157/s) | 109ms
#> ⠇ 18 done (158/s) | 114ms
#> ⠏ 19 done (159/s) | 120ms
#> ⠋ 20 done (160/s) | 125ms
#> ⠙ 21 done (161/s) | 131ms
#> ⠹ 22 done (162/s) | 137ms
#> ⠸ 23 done (162/s) | 142ms
#> ⠼ 24 done (158/s) | 152ms
#> ⠴ 25 done (159/s) | 158ms
#> ⠦ 26 done (159/s) | 164ms
#> ⠧ 27 done (160/s) | 170ms
#> ⠇ 28 done (160/s) | 175ms
#> ⠏ 29 done (161/s) | 181ms
#> ⠋ 30 done (161/s) | 186ms
#> ⠙ 31 done (162/s) | 192ms
#> ⠹ 32 done (162/s) | 198ms
#> ⠸ 33 done (163/s) | 204ms
#> ⠼ 34 done (163/s) | 210ms
#> ⠴ 35 done (163/s) | 215ms
#> ⠦ 36 done (163/s) | 221ms
#> ⠧ 37 done (163/s) | 227ms
#> ⠇ 38 done (164/s) | 233ms
#> ⠏ 39 done (164/s) | 239ms
#> ⠋ 40 done (164/s) | 244ms
#> ⠙ 41 done (164/s) | 250ms
#> ⠹ 42 done (165/s) | 256ms
#> ⠸ 43 done (165/s) | 261ms
#> ⠼ 44 done (165/s) | 267ms
#> ⠴ 45 done (165/s) | 273ms
#> ⠦ 46 done (165/s) | 279ms
#> ⠧ 47 done (165/s) | 285ms
#> ⠇ 48 done (166/s) | 290ms
#> ⠏ 49 done (166/s) | 296ms
#> ⠋ 50 done (166/s) | 302ms
#> ⠙ 51 done (166/s) | 307ms
#> ⠹ 52 done (166/s) | 313ms
#> ⠸ 53 done (167/s) | 318ms
#> ⠼ 54 done (167/s) | 324ms
#> ⠴ 55 done (167/s) | 329ms
#> ⠦ 56 done (168/s) | 335ms
#> ⠧ 57 done (168/s) | 340ms
#> ⠇ 58 done (168/s) | 346ms
#> ⠏ 59 done (168/s) | 352ms
#> ⠋ 60 done (168/s) | 357ms
#> ⠙ 61 done (168/s) | 363ms
#> ⠹ 62 done (169/s) | 368ms
#> ⠸ 63 done (169/s) | 374ms
#> ⠼ 64 done (169/s) | 380ms
#> ⠴ 65 done (169/s) | 385ms
#> ⠦ 66 done (169/s) | 391ms
#> ⠧ 67 done (169/s) | 397ms
#> ⠇ 68 done (169/s) | 402ms
#> ⠏ 69 done (169/s) | 408ms
#> ⠋ 70 done (169/s) | 414ms
#> ⠙ 71 done (169/s) | 420ms
#> ⠹ 72 done (170/s) | 425ms
#> ⠸ 73 done (170/s) | 431ms
#> ⠼ 74 done (170/s) | 437ms
#> ⠴ 75 done (169/s) | 443ms
#> ⠦ 76 done (169/s) | 449ms
#> ⠧ 77 done (169/s) | 455ms
#> ⠇ 78 done (169/s) | 461ms
#> ⠏ 79 done (169/s) | 467ms
#> ⠋ 80 done (169/s) | 473ms
#> ⠙ 81 done (169/s) | 479ms
#> ⠹ 82 done (169/s) | 485ms
#> ⠸ 83 done (169/s) | 491ms
#> ⠼ 84 done (169/s) | 497ms
#> ⠴ 85 done (168/s) | 507ms
#> ⠦ 86 done (168/s) | 513ms
#> ⠧ 87 done (168/s) | 518ms
#> ⠇ 88 done (168/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.45ms 5.69ms      175.     266KB     4.11
cli_progress_done()
```
