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
#> 1 __cli_update_due         5.01ns   14.1ns 68306469.        0B        0
#> 2 fun()                   95.11ns    103ns  6411160.        0B        0
#> 3 .Call(ccli_tick_reset)  95.11ns  104.1ns  9200130.        0B        0
#> 4 interactive()           11.99ns   15.1ns 63410637.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  34ns   40ns 23410926.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]     94.1ns    103ns  9163875.        0B        0
#> 2 ta[[1]]       105ns    114ns  8013651.        0B        0
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
#> 1 f0()         16.3ms   16.3ms      60.4    21.6KB     483.
#> 2 fp()         18.2ms   18.5ms      53.9    82.5KB     395.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 22.1ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     183ms    186ms      4.87        0B     43.9
#> 2 fp(1e+06)     189ms    191ms      5.23     1.9KB     24.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 5.23ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     1.83s    1.83s     0.546        0B     26.2
#> 2 fp(1e+07)     1.89s    1.89s     0.528     1.9KB     24.8
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 6.21ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     17.7s    17.7s    0.0566        0B     29.6
#> 2 fp(1e+08)     19.1s    19.1s    0.0523     1.9KB     27.2
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 14.5ns
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
#> 1 f0()         60.9ms   65.2ms      11.5     781KB     21.1
#> 2 f01()        67.8ms   73.9ms      12.9     781KB     20.3
#> 3 fp()         72.9ms   80.6ms      12.0     783KB     18.9
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 153ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  708.44ms 708.44ms     1.41     7.63MB     5.65
#> 2 f01(1e+06) 986.49ms 986.49ms     1.01     7.63MB     4.05
#> 3 fp(1e+06)     1.04s    1.04s     0.958    7.63MB     4.79
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 335ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 57.3ns
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
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()        796.7ms  796.7ms      1.26    1.44MB     1.26
#> 2 f01()        67.7ms   72.1ms     13.3    781.3KB     3.81
#> 3 fp()         69.7ms   73.4ms     12.2   783.26KB     5.25
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 1ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 12.9ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  746.39ms 746.39ms     1.34     7.63MB     2.68
#> 2 f01(1e+06) 945.15ms 945.15ms     1.06     7.63MB     4.23
#> 3 fp(1e+06)     1.11s    1.11s     0.902    7.63MB     3.61
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 362ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 163ns
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
#> 1 f0()         16.8ms   17.6ms    55.7      39.3KB     3.98
#> 2 fp()           2.9s     2.9s     0.345   100.8KB     3.45
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 28.9µs
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
#> 1 f0()        16.57ms  17.25ms    55.3      18.7KB     5.93
#> 2 ff()        24.51ms  25.39ms    38.4      27.6KB     3.84
#> 3 fp()          1.66s    1.66s     0.604    25.1KB     3.02
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 16.4µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 81.3ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   183.4ms  183.5ms    5.38          0B     5.38
#> 2 ff(1e+06)   255.8ms    256ms    3.91      1.91KB     3.91
#> 3 fp(1e+06)     17.9s    17.9s    0.0560    1.91KB     3.02
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 17.7µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 72.4ns
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
#> 1 test_baseline()   817.45ms 817.45ms     1.22     2.08KB        0
#> 2 test_modulo()        1.14s    1.14s     0.876    2.24KB        0
#> 3 test_cli()        846.55ms 846.55ms     1.18    24.11KB        0
#> 4 test_cli_unroll() 818.68ms 818.68ms     1.22     3.58KB        0
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
#> ■                                  0% | ETA: 45m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 22m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 21m
#> ■                                  0% | ETA: 20m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 19m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
#> ■                                  0% | ETA: 18m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 4.99ms 5.37ms      181.    1.42MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (605/s) | 2ms
#> ⠹ 2 done (73/s) | 28ms
#> ⠸ 3 done (90/s) | 34ms
#> ⠼ 4 done (103/s) | 40ms
#> ⠴ 5 done (111/s) | 46ms
#> ⠦ 6 done (117/s) | 52ms
#> ⠧ 7 done (122/s) | 58ms
#> ⠇ 8 done (126/s) | 64ms
#> ⠏ 9 done (129/s) | 70ms
#> ⠋ 10 done (132/s) | 76ms
#> ⠙ 11 done (135/s) | 82ms
#> ⠹ 12 done (136/s) | 89ms
#> ⠸ 13 done (138/s) | 95ms
#> ⠼ 14 done (140/s) | 101ms
#> ⠴ 15 done (141/s) | 107ms
#> ⠦ 16 done (142/s) | 113ms
#> ⠧ 17 done (143/s) | 120ms
#> ⠇ 18 done (143/s) | 127ms
#> ⠏ 19 done (143/s) | 134ms
#> ⠋ 20 done (143/s) | 140ms
#> ⠙ 21 done (144/s) | 147ms
#> ⠹ 22 done (144/s) | 153ms
#> ⠸ 23 done (145/s) | 159ms
#> ⠼ 24 done (145/s) | 166ms
#> ⠴ 25 done (146/s) | 172ms
#> ⠦ 26 done (146/s) | 178ms
#> ⠧ 27 done (147/s) | 184ms
#> ⠇ 28 done (147/s) | 191ms
#> ⠏ 29 done (148/s) | 197ms
#> ⠋ 30 done (148/s) | 203ms
#> ⠙ 31 done (149/s) | 209ms
#> ⠹ 32 done (149/s) | 215ms
#> ⠸ 33 done (150/s) | 221ms
#> ⠼ 34 done (150/s) | 227ms
#> ⠴ 35 done (150/s) | 233ms
#> ⠦ 36 done (151/s) | 239ms
#> ⠧ 37 done (151/s) | 246ms
#> ⠇ 38 done (151/s) | 252ms
#> ⠏ 39 done (152/s) | 258ms
#> ⠋ 40 done (152/s) | 264ms
#> ⠙ 41 done (152/s) | 270ms
#> ⠹ 42 done (152/s) | 277ms
#> ⠸ 43 done (152/s) | 283ms
#> ⠼ 44 done (153/s) | 289ms
#> ⠴ 45 done (153/s) | 295ms
#> ⠦ 46 done (153/s) | 301ms
#> ⠧ 47 done (153/s) | 307ms
#> ⠇ 48 done (154/s) | 313ms
#> ⠏ 49 done (154/s) | 319ms
#> ⠋ 50 done (154/s) | 325ms
#> ⠙ 51 done (154/s) | 331ms
#> ⠹ 52 done (154/s) | 337ms
#> ⠸ 53 done (154/s) | 344ms
#> ⠼ 54 done (154/s) | 350ms
#> ⠴ 55 done (155/s) | 356ms
#> ⠦ 56 done (155/s) | 362ms
#> ⠧ 57 done (155/s) | 369ms
#> ⠇ 58 done (155/s) | 376ms
#> ⠏ 59 done (154/s) | 382ms
#> ⠋ 60 done (155/s) | 389ms
#> ⠙ 61 done (155/s) | 395ms
#> ⠹ 62 done (155/s) | 401ms
#> ⠸ 63 done (155/s) | 407ms
#> ⠼ 64 done (154/s) | 417ms
#> ⠴ 65 done (154/s) | 422ms
#> ⠦ 66 done (154/s) | 428ms
#> ⠧ 67 done (155/s) | 434ms
#> ⠇ 68 done (155/s) | 440ms
#> ⠏ 69 done (155/s) | 447ms
#> ⠋ 70 done (155/s) | 453ms
#> ⠙ 71 done (155/s) | 459ms
#> ⠹ 72 done (155/s) | 465ms
#> ⠸ 73 done (155/s) | 471ms
#> ⠼ 74 done (155/s) | 478ms
#> ⠴ 75 done (155/s) | 484ms
#> ⠦ 76 done (155/s) | 490ms
#> ⠧ 77 done (155/s) | 496ms
#> ⠇ 78 done (155/s) | 503ms
#> ⠏ 79 done (155/s) | 510ms
#> ⠋ 80 done (155/s) | 516ms
#> ⠙ 81 done (156/s) | 521ms
#> ⠹ 82 done (156/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.71ms 6.14ms      161.     265KB     2.02
cli_progress_done()
```
