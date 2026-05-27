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
#> 1 __cli_update_due              0     10ns    1.01e8        0B        0
#> 2 fun()                  130.04ns  151.1ns    4.56e6        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    120ns    8.11e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    7.08e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns   49ns 21464260.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  5685823.        0B        0
#> 2 ta[[1]]       140ns    160ns  5672378.        0B        0
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
#> 1 f0()         21.9ms     22ms      45.4    21.6KB     409.
#> 2 fp()         24.5ms   24.6ms      40.7    82.5KB     326.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 25.6ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     246ms    247ms      4.04        0B     36.4
#> 2 fp(1e+06)     264ms    298ms      3.36    1.88KB     25.2
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 50.5ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.43s    2.43s     0.411        0B     19.7
#> 2 fp(1e+07)     2.51s    2.51s     0.398    1.88KB     19.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.77ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.9s    23.9s    0.0419        0B     22.2
#> 2 fp(1e+08)     25.3s    25.3s    0.0396    1.88KB     20.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 14.1ns
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
#> 1 f0()         92.1ms   95.2ms      7.73     781KB    15.5 
#> 2 f01()       109.3ms    112ms      8.18     781KB     8.18
#> 3 fp()          119ms  126.3ms      7.94     783KB    11.9
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 311ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.12s    1.12s     0.893    7.63MB     6.25
#> 2 f01(1e+06)    2.01s    2.01s     0.498    7.63MB     3.98
#> 3 fp(1e+06)      2.5s     2.5s     0.400    7.63MB     1.60
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.38µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 493ns
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
#> 1 f0()         79.4ms   79.4ms     12.6     1.44MB     9.44
#> 2 f01()        97.9ms   99.7ms      9.71   781.3KB     6.48
#> 3 fp()         99.6ms    103ms      9.56  783.24KB     2.39
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 236ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 33.4ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  930.83ms 930.83ms     1.07     7.63MB     3.22
#> 2 f01(1e+06)    1.21s    1.21s     0.830    7.63MB     3.32
#> 3 fp(1e+06)     1.58s    1.58s     0.633    7.63MB     2.53
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 650ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 376ns
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
#> 1 f0()        25.16ms  31.24ms    31.8      39.3KB     1.99
#> 2 fp()          4.53s    4.53s     0.221   100.7KB     3.09
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 45µs
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
#> 1 f0()        24.58ms  43.51ms    23.0      18.7KB     3.83
#> 2 ff()        32.56ms  53.74ms    19.4      27.6KB     1.94
#> 3 fp()          3.75s    3.75s     0.267    25.1KB     1.87
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 37.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 102ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     219ms    222ms    4.50          0B     5.99
#> 2 ff(1e+06)     308ms    309ms    3.24       1.9KB     3.24
#> 3 fp(1e+06)       24s      24s    0.0417     1.9KB     2.46
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.8µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 87.3ns
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
#> 1 test_baseline()   623.91ms 623.91ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.09KB        0
#> 4 test_cli_unroll() 625.09ms 625.09ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA:  5m
#> ■                                  0% | ETA:  2h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA:  1h
#> ■                                  0% | ETA: 47m
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
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
#> 1 cli_progress_update(force… 6.41ms 6.64ms      148.    1.41MB     2.05
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (484/s) | 3ms
#> ⠹ 2 done (67/s) | 30ms
#> ⠸ 3 done (78/s) | 39ms
#> ⠼ 4 done (87/s) | 47ms
#> ⠴ 5 done (92/s) | 55ms
#> ⠦ 6 done (97/s) | 63ms
#> ⠧ 7 done (100/s) | 70ms
#> ⠇ 8 done (103/s) | 78ms
#> ⠏ 9 done (106/s) | 86ms
#> ⠋ 10 done (108/s) | 94ms
#> ⠙ 11 done (109/s) | 101ms
#> ⠹ 12 done (110/s) | 109ms
#> ⠸ 13 done (112/s) | 117ms
#> ⠼ 14 done (113/s) | 125ms
#> ⠴ 15 done (114/s) | 133ms
#> ⠦ 16 done (115/s) | 140ms
#> ⠧ 17 done (115/s) | 148ms
#> ⠇ 18 done (116/s) | 156ms
#> ⠏ 19 done (117/s) | 164ms
#> ⠋ 20 done (117/s) | 171ms
#> ⠙ 21 done (118/s) | 179ms
#> ⠹ 22 done (118/s) | 187ms
#> ⠸ 23 done (119/s) | 194ms
#> ⠼ 24 done (119/s) | 202ms
#> ⠴ 25 done (119/s) | 210ms
#> ⠦ 26 done (118/s) | 222ms
#> ⠧ 27 done (118/s) | 230ms
#> ⠇ 28 done (118/s) | 237ms
#> ⠏ 29 done (119/s) | 245ms
#> ⠋ 30 done (119/s) | 252ms
#> ⠙ 31 done (120/s) | 260ms
#> ⠹ 32 done (120/s) | 267ms
#> ⠸ 33 done (120/s) | 275ms
#> ⠼ 34 done (121/s) | 283ms
#> ⠴ 35 done (121/s) | 290ms
#> ⠦ 36 done (121/s) | 298ms
#> ⠧ 37 done (121/s) | 305ms
#> ⠇ 38 done (122/s) | 313ms
#> ⠏ 39 done (122/s) | 321ms
#> ⠋ 40 done (122/s) | 328ms
#> ⠙ 41 done (122/s) | 336ms
#> ⠹ 42 done (123/s) | 343ms
#> ⠸ 43 done (123/s) | 351ms
#> ⠼ 44 done (123/s) | 359ms
#> ⠴ 45 done (123/s) | 367ms
#> ⠦ 46 done (123/s) | 374ms
#> ⠧ 47 done (123/s) | 382ms
#> ⠇ 48 done (123/s) | 390ms
#> ⠏ 49 done (124/s) | 397ms
#> ⠋ 50 done (124/s) | 405ms
#> ⠙ 51 done (124/s) | 413ms
#> ⠹ 52 done (124/s) | 421ms
#> ⠸ 53 done (124/s) | 429ms
#> ⠼ 54 done (124/s) | 437ms
#> ⠴ 55 done (124/s) | 444ms
#> ⠦ 56 done (124/s) | 452ms
#> ⠧ 57 done (124/s) | 460ms
#> ⠇ 58 done (124/s) | 468ms
#> ⠏ 59 done (124/s) | 476ms
#> ⠋ 60 done (124/s) | 484ms
#> ⠙ 61 done (124/s) | 492ms
#> ⠹ 62 done (124/s) | 500ms
#> ⠸ 63 done (124/s) | 508ms
#> ⠼ 64 done (124/s) | 516ms
#> ⠴ 65 done (124/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.47ms 7.75ms      129.     265KB     2.05
cli_progress_done()
```
