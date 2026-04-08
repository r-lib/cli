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
#> 1 __cli_update_due         9.89ns     10ns 81065339.        0B        0
#> 2 fun()                  110.01ns    130ns  4988875.        0B        0
#> 3 .Call(ccli_tick_reset)  99.88ns    110ns  8519089.        0B        0
#> 4 interactive()           10.01ns     20ns 50234975.        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns 50.1ns 18939930.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]     89.9ns    120ns  7540599.        0B       0 
#> 2 ta[[1]]     109.9ns    130ns  6357435.        0B     636.
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
#> 1 f0()         24.3ms   24.5ms      40.9    21.6KB     205.
#> 2 fp()         27.1ms   27.1ms      36.5    82.3KB     170.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 26.4ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     269ms    269ms      3.71        0B     29.7
#> 2 fp(1e+06)     292ms    292ms      3.42    1.88KB     29.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 23.1ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.69s    2.69s     0.372        0B     31.2
#> 2 fp(1e+07)     2.93s    2.93s     0.342    1.88KB     28.7
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 23.5ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     25.4s    25.4s    0.0393        0B     19.1
#> 2 fp(1e+08)     27.2s    27.2s    0.0368    1.88KB     17.7
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.5ns
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
#> 1 f0()         86.9ms   89.6ms     10.9      781KB    14.5 
#> 2 f01()         111ms  126.3ms      7.74     781KB     9.67
#> 3 fp()        137.9ms  141.3ms      6.50     783KB    11.4
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 518ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  936.88ms 936.88ms     1.07     7.63MB     7.47
#> 2 f01(1e+06)    1.41s    1.41s     0.711    7.63MB     4.98
#> 3 fp(1e+06)     2.05s    2.05s     0.487    7.63MB     2.44
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.11µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 646ns
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
#> 1 f0()         75.9ms   76.5ms      13.0    1.41MB     6.48
#> 2 f01()        92.4ms   95.1ms      10.5   781.3KB     5.25
#> 3 fp()         95.5ms   99.1ms      10.1  783.24KB     6.71
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 226ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 40.6ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  960.16ms 960.16ms     1.04     7.63MB     3.12
#> 2 f01(1e+06)    1.45s    1.45s     0.688    7.63MB     2.06
#> 3 fp(1e+06)     1.34s    1.34s     0.747    7.63MB     2.99
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 379ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 1ns
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
#> 1 f0()        23.95ms   24.1ms    38.2      39.3KB     1.91
#> 2 fp()          3.97s    3.97s     0.252   100.4KB     2.77
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.4µs
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
#> 1 f0()        22.96ms  23.38ms    38.3      18.7KB     3.83
#> 2 ff()        31.57ms  32.33ms     6.87     27.6KB     1.06
#> 3 fp()          2.08s    2.08s     0.480    25.1KB     2.40
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 20.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 89.5ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   248.9ms  265.5ms    3.77          0B     5.65
#> 2 ff(1e+06)   338.6ms  339.3ms    2.95       1.9KB     2.95
#> 3 fp(1e+06)     22.7s    22.7s    0.0441     1.9KB     2.56
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.4µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 73.9ns
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
#> 1 test_baseline()   704.12ms 704.12ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.982    23.9KB        0
#> 4 test_cli_unroll() 706.02ms 706.02ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 50m
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 28m
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
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.67ms 5.92ms      166.     1.4MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (536/s) | 2ms
#> ⠹ 2 done (74/s) | 28ms
#> ⠸ 3 done (89/s) | 34ms
#> ⠼ 4 done (99/s) | 41ms
#> ⠴ 5 done (106/s) | 48ms
#> ⠦ 6 done (111/s) | 55ms
#> ⠧ 7 done (115/s) | 62ms
#> ⠇ 8 done (118/s) | 68ms
#> ⠏ 9 done (120/s) | 75ms
#> ⠋ 10 done (122/s) | 82ms
#> ⠙ 11 done (124/s) | 89ms
#> ⠹ 12 done (126/s) | 96ms
#> ⠸ 13 done (127/s) | 103ms
#> ⠼ 14 done (128/s) | 110ms
#> ⠴ 15 done (129/s) | 117ms
#> ⠦ 16 done (129/s) | 124ms
#> ⠧ 17 done (130/s) | 131ms
#> ⠇ 18 done (131/s) | 138ms
#> ⠏ 19 done (131/s) | 145ms
#> ⠋ 20 done (132/s) | 152ms
#> ⠙ 21 done (133/s) | 159ms
#> ⠹ 22 done (133/s) | 166ms
#> ⠸ 23 done (134/s) | 173ms
#> ⠼ 24 done (134/s) | 180ms
#> ⠴ 25 done (134/s) | 187ms
#> ⠦ 26 done (135/s) | 194ms
#> ⠧ 27 done (135/s) | 201ms
#> ⠇ 28 done (135/s) | 207ms
#> ⠏ 29 done (136/s) | 214ms
#> ⠋ 30 done (136/s) | 221ms
#> ⠙ 31 done (136/s) | 228ms
#> ⠹ 32 done (136/s) | 235ms
#> ⠸ 33 done (137/s) | 242ms
#> ⠼ 34 done (137/s) | 249ms
#> ⠴ 35 done (137/s) | 256ms
#> ⠦ 36 done (137/s) | 263ms
#> ⠧ 37 done (137/s) | 270ms
#> ⠇ 38 done (138/s) | 277ms
#> ⠏ 39 done (138/s) | 284ms
#> ⠋ 40 done (138/s) | 291ms
#> ⠙ 41 done (138/s) | 298ms
#> ⠹ 42 done (138/s) | 305ms
#> ⠸ 43 done (138/s) | 312ms
#> ⠼ 44 done (138/s) | 318ms
#> ⠴ 45 done (138/s) | 326ms
#> ⠦ 46 done (139/s) | 333ms
#> ⠧ 47 done (139/s) | 340ms
#> ⠇ 48 done (139/s) | 347ms
#> ⠏ 49 done (139/s) | 354ms
#> ⠋ 50 done (139/s) | 361ms
#> ⠙ 51 done (139/s) | 368ms
#> ⠹ 52 done (139/s) | 374ms
#> ⠸ 53 done (139/s) | 382ms
#> ⠼ 54 done (139/s) | 388ms
#> ⠴ 55 done (139/s) | 395ms
#> ⠦ 56 done (139/s) | 402ms
#> ⠧ 57 done (139/s) | 409ms
#> ⠇ 58 done (140/s) | 416ms
#> ⠏ 59 done (138/s) | 427ms
#> ⠋ 60 done (138/s) | 434ms
#> ⠙ 61 done (139/s) | 440ms
#> ⠹ 62 done (139/s) | 447ms
#> ⠸ 63 done (139/s) | 454ms
#> ⠼ 64 done (139/s) | 461ms
#> ⠴ 65 done (139/s) | 468ms
#> ⠦ 66 done (139/s) | 474ms
#> ⠧ 67 done (139/s) | 481ms
#> ⠇ 68 done (139/s) | 488ms
#> ⠏ 69 done (139/s) | 495ms
#> ⠋ 70 done (140/s) | 502ms
#> ⠙ 71 done (140/s) | 509ms
#> ⠹ 72 done (140/s) | 516ms
#> ⠸ 73 done (140/s) | 523ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.57ms 6.92ms      145.     265KB     2.04
cli_progress_done()
```
