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
#> 1 __cli_update_due         9.89ns     10ns 76923593.        0B        0
#> 2 fun()                  110.01ns    131ns  4921043.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    110ns  8625407.        0B        0
#> 4 interactive()           10.01ns     20ns 55047557.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns 40.2ns 22406937.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      110ns    130ns  6807960.        0B        0
#> 2 ta[[1]]       120ns    150ns  5740906.        0B        0
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
#> 1 f0()         23.7ms   23.8ms      42.0    21.6KB     357.
#> 2 fp()         26.4ms   27.1ms      36.9    82.5KB     277.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 32.9ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     258ms    261ms      3.84        0B     32.6
#> 2 fp(1e+06)     281ms    283ms      3.53    1.88KB     31.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 22.7ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.61s    2.61s     0.383        0B     18.4
#> 2 fp(1e+07)     2.71s    2.71s     0.368    1.88KB     17.3
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 9.97ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.7s    25.7s    0.0389        0B     20.6
#> 2 fp(1e+08)     27.6s    27.6s    0.0362    1.88KB     18.9
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 19.3ns
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
#> 1 f0()         83.2ms   86.3ms      8.71     781KB    13.9 
#> 2 f01()         106ms  117.5ms      8.40     781KB    13.4 
#> 3 fp()          122ms    130ms      6.93     783KB     8.66
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 437ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.09s    1.09s     0.913    7.63MB     7.31
#> 2 f01(1e+06)    1.83s    1.83s     0.546    7.63MB     2.19
#> 3 fp(1e+06)      1.5s     1.5s     0.668    7.63MB     4.01
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 401ns
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
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0()         74.2ms   74.8ms     13.1     1.44MB     3.74
#> 2 f01()       865.1ms  865.1ms      1.16   781.3KB     1.16
#> 3 fp()         90.9ms   94.5ms     10.5   783.24KB     3.49
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 197ns
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
#> 1 f0(1e+06)  879.97ms 879.97ms     1.14     7.63MB     3.41
#> 2 f01(1e+06)    1.13s    1.13s     0.882    7.63MB     2.65
#> 3 fp(1e+06)     1.56s    1.56s     0.639    7.63MB     2.56
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 684ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 430ns
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
#> 1 f0()        25.51ms  33.71ms    29.9      39.3KB     2.00
#> 2 fp()          4.32s    4.32s     0.232   100.8KB     3.01
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 42.8µs
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
#> 1 f0()        37.01ms  47.28ms    20.7      18.7KB     1.89
#> 2 ff()        33.35ms  56.62ms    18.9      27.6KB     3.78
#> 3 fp()          2.42s    2.42s     0.412    25.1KB     2.47
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.8µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 93.4ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   248.7ms  272.5ms    3.67          0B     3.67
#> 2 ff(1e+06)   333.2ms  333.5ms    3.00       1.9KB     3.00
#> 3 fp(1e+06)     21.9s    21.9s    0.0457     1.9KB     2.51
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 21.6µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 61ns
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
#> 1 test_baseline()   705.22ms 705.22ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.709    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.982   24.09KB        0
#> 4 test_cli_unroll() 706.09ms 706.09ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
#> ■                                  0% | ETA: 23m
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
#> 1 cli_progress_update(force… 5.73ms 5.89ms      163.    1.41MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (523/s) | 3ms
#> ⠹ 2 done (73/s) | 28ms
#> ⠸ 3 done (87/s) | 35ms
#> ⠼ 4 done (97/s) | 42ms
#> ⠴ 5 done (104/s) | 49ms
#> ⠦ 6 done (110/s) | 55ms
#> ⠧ 7 done (114/s) | 62ms
#> ⠇ 8 done (117/s) | 69ms
#> ⠏ 9 done (120/s) | 76ms
#> ⠋ 10 done (122/s) | 82ms
#> ⠙ 11 done (124/s) | 89ms
#> ⠹ 12 done (126/s) | 96ms
#> ⠸ 13 done (127/s) | 103ms
#> ⠼ 14 done (129/s) | 109ms
#> ⠴ 15 done (130/s) | 116ms
#> ⠦ 16 done (131/s) | 123ms
#> ⠧ 17 done (131/s) | 130ms
#> ⠇ 18 done (132/s) | 137ms
#> ⠏ 19 done (133/s) | 144ms
#> ⠋ 20 done (133/s) | 151ms
#> ⠙ 21 done (134/s) | 157ms
#> ⠹ 22 done (134/s) | 164ms
#> ⠸ 23 done (135/s) | 171ms
#> ⠼ 24 done (135/s) | 178ms
#> ⠴ 25 done (136/s) | 185ms
#> ⠦ 26 done (136/s) | 192ms
#> ⠧ 27 done (136/s) | 199ms
#> ⠇ 28 done (137/s) | 205ms
#> ⠏ 29 done (137/s) | 212ms
#> ⠋ 30 done (137/s) | 219ms
#> ⠙ 31 done (138/s) | 226ms
#> ⠹ 32 done (138/s) | 233ms
#> ⠸ 33 done (138/s) | 239ms
#> ⠼ 34 done (138/s) | 246ms
#> ⠴ 35 done (139/s) | 253ms
#> ⠦ 36 done (139/s) | 260ms
#> ⠧ 37 done (139/s) | 267ms
#> ⠇ 38 done (139/s) | 273ms
#> ⠏ 39 done (139/s) | 280ms
#> ⠋ 40 done (140/s) | 287ms
#> ⠙ 41 done (140/s) | 294ms
#> ⠹ 42 done (140/s) | 301ms
#> ⠸ 43 done (140/s) | 307ms
#> ⠼ 44 done (140/s) | 314ms
#> ⠴ 45 done (140/s) | 321ms
#> ⠦ 46 done (140/s) | 328ms
#> ⠧ 47 done (141/s) | 335ms
#> ⠇ 48 done (139/s) | 346ms
#> ⠏ 49 done (139/s) | 354ms
#> ⠋ 50 done (139/s) | 361ms
#> ⠙ 51 done (139/s) | 369ms
#> ⠹ 52 done (138/s) | 376ms
#> ⠸ 53 done (138/s) | 384ms
#> ⠼ 54 done (138/s) | 392ms
#> ⠴ 55 done (138/s) | 399ms
#> ⠦ 56 done (138/s) | 407ms
#> ⠧ 57 done (138/s) | 415ms
#> ⠇ 58 done (138/s) | 422ms
#> ⠏ 59 done (137/s) | 430ms
#> ⠋ 60 done (137/s) | 438ms
#> ⠙ 61 done (137/s) | 445ms
#> ⠹ 62 done (137/s) | 452ms
#> ⠸ 63 done (137/s) | 459ms
#> ⠼ 64 done (137/s) | 466ms
#> ⠴ 65 done (138/s) | 473ms
#> ⠦ 66 done (138/s) | 480ms
#> ⠧ 67 done (138/s) | 487ms
#> ⠇ 68 done (138/s) | 494ms
#> ⠏ 69 done (138/s) | 501ms
#> ⠋ 70 done (138/s) | 508ms
#> ⠙ 71 done (138/s) | 515ms
#> ⠹ 72 done (138/s) | 522ms
#> ⠸ 73 done (138/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.68ms 6.82ms      143.     265KB     2.02
cli_progress_done()
```
