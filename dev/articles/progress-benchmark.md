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
#> 1 __cli_update_due              0     10ns    1.28e8        0B        0
#> 2 fun()                  140.05ns  160.1ns    4.44e6        0B        0
#> 3 .Call(ccli_tick_reset)  99.88ns    120ns    8.11e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    6.61e7        0B        0
```

``` r
ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 21566164.        0B        0
```

### `cli_progress_along()`

``` r
seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      110ns    130ns  7173841.        0B       0 
#> 2 ta[[1]]       130ns    150ns  5974177.        0B     597.
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
#> 1 f0()         22.2ms   22.3ms      44.5    21.6KB     252.
#> 2 fp()         25.3ms   25.4ms      39.0    82.5KB     195.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 30.7ns
```

``` r
ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     243ms    247ms      4.07        0B     33.9
#> 2 fp(1e+06)     269ms    271ms      3.70    1.88KB     31.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 24.1ns
```

``` r
ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.51s    2.51s     0.398        0B     33.4
#> 2 fp(1e+07)     2.66s    2.66s     0.375    1.88KB     31.5
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 15ns
```

``` r
ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.6s    23.6s    0.0423        0B     20.6
#> 2 fp(1e+08)     25.8s    25.8s    0.0388    1.88KB     18.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 21.6ns
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
#> 1 f0()         86.4ms   93.7ms     10.5      781KB     12.3
#> 2 f01()       118.8ms  122.3ms      7.47     781KB     13.1
#> 3 fp()        133.1ms  139.3ms      7.21     783KB     12.6
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 455ns
```

``` r
ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   900.6ms  900.6ms     1.11     7.63MB     4.44
#> 2 f01(1e+06)    1.13s    1.13s     0.885    7.63MB     5.31
#> 3 fp(1e+06)     1.39s    1.39s     0.717    7.63MB     3.59
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 493ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 264ns
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
#> 1 f0()         78.8ms     79ms      12.6    1.41MB     5.02
#> 2 f01()        90.1ms   90.1ms      11.1   781.3KB    11.1 
#> 3 fp()         93.1ms   96.1ms      10.5  783.24KB     6.98
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 171ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 60.3ns
```

``` r
ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     2.13s    2.13s     0.470    7.63MB    0.939
#> 2 f01(1e+06)    1.12s    1.12s     0.896    7.63MB    3.58 
#> 3 fp(1e+06)     1.51s    1.51s     0.664    7.63MB    2.66
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 390ns
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
#> 1 f0()        24.17ms  31.32ms    29.8      39.3KB     3.73
#> 2 fp()          4.34s    4.34s     0.230   100.7KB     2.77
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 43.1µs
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
#> 1 f0()         34.3ms   41.1ms    24.0      18.7KB     1.84
#> 2 ff()         32.6ms   50.8ms    20.7      27.6KB     3.75
#> 3 fp()           2.4s     2.4s     0.416    25.1KB     2.50
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.6µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 96.6ns
```

``` r
ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   222.3ms  222.9ms    4.47          0B     4.47
#> 2 ff(1e+06)   331.3ms  355.1ms    2.82       1.9KB     2.82
#> 3 fp(1e+06)     23.2s    23.2s    0.0431     1.9KB     2.33
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 132ns
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
#> 1 test_baseline()   632.82ms 632.82ms     1.58     2.08KB        0
#> 2 test_modulo()        1.26s    1.26s     0.792    2.24KB        0
#> 3 test_cli()           1.26s    1.26s     0.794   24.09KB        0
#> 4 test_cli_unroll() 632.88ms 632.88ms     1.58     3.56KB        0
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
#> ■                                  0% | ETA: 50m
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 40m
#> ■                                  0% | ETA: 37m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
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
#> ■                                  0% | ETA: 14m
#> ■                                  0% | ETA: 14m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.39ms 6.62ms      146.     1.4MB        0
cli_progress_done()
```

### Iterator without a bar

``` r
cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (453/s) | 3ms
#> ⠹ 2 done (63/s) | 32ms
#> ⠸ 3 done (74/s) | 41ms
#> ⠼ 4 done (82/s) | 50ms
#> ⠴ 5 done (87/s) | 58ms
#> ⠦ 6 done (91/s) | 67ms
#> ⠧ 7 done (94/s) | 75ms
#> ⠇ 8 done (97/s) | 84ms
#> ⠏ 9 done (99/s) | 92ms
#> ⠋ 10 done (101/s) | 100ms
#> ⠙ 11 done (103/s) | 107ms
#> ⠹ 12 done (105/s) | 115ms
#> ⠸ 13 done (106/s) | 123ms
#> ⠼ 14 done (108/s) | 131ms
#> ⠴ 15 done (109/s) | 138ms
#> ⠦ 16 done (110/s) | 146ms
#> ⠧ 17 done (111/s) | 154ms
#> ⠇ 18 done (112/s) | 161ms
#> ⠏ 19 done (113/s) | 169ms
#> ⠋ 20 done (114/s) | 177ms
#> ⠙ 21 done (114/s) | 184ms
#> ⠹ 22 done (115/s) | 192ms
#> ⠸ 23 done (116/s) | 200ms
#> ⠼ 24 done (116/s) | 207ms
#> ⠴ 25 done (117/s) | 215ms
#> ⠦ 26 done (117/s) | 223ms
#> ⠧ 27 done (118/s) | 230ms
#> ⠇ 28 done (118/s) | 238ms
#> ⠏ 29 done (119/s) | 245ms
#> ⠋ 30 done (119/s) | 253ms
#> ⠙ 31 done (119/s) | 260ms
#> ⠹ 32 done (120/s) | 268ms
#> ⠸ 33 done (120/s) | 275ms
#> ⠼ 34 done (120/s) | 283ms
#> ⠴ 35 done (121/s) | 291ms
#> ⠦ 36 done (121/s) | 298ms
#> ⠧ 37 done (121/s) | 306ms
#> ⠇ 38 done (121/s) | 313ms
#> ⠏ 39 done (122/s) | 321ms
#> ⠋ 40 done (122/s) | 329ms
#> ⠙ 41 done (122/s) | 336ms
#> ⠹ 42 done (122/s) | 344ms
#> ⠸ 43 done (123/s) | 351ms
#> ⠼ 44 done (123/s) | 359ms
#> ⠴ 45 done (123/s) | 367ms
#> ⠦ 46 done (123/s) | 374ms
#> ⠧ 47 done (123/s) | 382ms
#> ⠇ 48 done (123/s) | 389ms
#> ⠏ 49 done (124/s) | 397ms
#> ⠋ 50 done (124/s) | 405ms
#> ⠙ 51 done (124/s) | 412ms
#> ⠹ 52 done (124/s) | 420ms
#> ⠸ 53 done (124/s) | 427ms
#> ⠼ 54 done (124/s) | 435ms
#> ⠴ 55 done (124/s) | 442ms
#> ⠦ 56 done (125/s) | 450ms
#> ⠧ 57 done (125/s) | 458ms
#> ⠇ 58 done (125/s) | 465ms
#> ⠏ 59 done (125/s) | 473ms
#> ⠋ 60 done (125/s) | 480ms
#> ⠙ 61 done (124/s) | 493ms
#> ⠹ 62 done (124/s) | 501ms
#> ⠸ 63 done (124/s) | 510ms
#> ⠼ 64 done (124/s) | 518ms
#> ⠴ 65 done (124/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.48ms 7.63ms      129.     265KB     2.04
cli_progress_done()
```
