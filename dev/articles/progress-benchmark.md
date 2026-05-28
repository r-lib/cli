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
#> 1 __cli_update_due              0     10ns 99287413.        0B        0
#> 2 fun()                  130.04ns    151ns  4487040.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    120ns  8096160.        0B        0
#> 4 interactive()            8.96ns   10.1ns 68392288.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 19819923.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6341050.        0B        0
#> 2 ta[[1]]       140ns    160ns  5709202.        0B        0
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
#> 1 f0()         21.8ms   21.8ms      45.8    21.6KB     412.
#> 2 fp()         24.1ms   24.2ms      41.3    82.5KB     220.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 23.9ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     237ms    238ms      4.20        0B     36.4
#> 2 fp(1e+06)     261ms    291ms      3.44    1.88KB     27.5
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 52.6ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.42s    2.42s     0.414        0B     19.9
#> 2 fp(1e+07)     2.48s    2.48s     0.403    1.88KB     19.3
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 6.52ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.8s    23.8s    0.0419        0B     22.2
#> 2 fp(1e+08)     25.4s    25.4s    0.0393    1.88KB     20.7
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 15.9ns
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
#> 1 f0()           96ms   96.9ms      7.54     781KB    15.1 
#> 2 f01()         113ms  119.6ms      8.40     781KB     8.40
#> 3 fp()          119ms  132.9ms      7.67     783KB    13.4
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 360ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.11s    1.11s     0.897    7.63MB     6.28
#> 2 f01(1e+06)    2.75s    2.75s     0.364    7.63MB     2.91
#> 3 fp(1e+06)     1.15s    1.15s     0.872    7.63MB     1.74
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 31.6ns
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
#> 1 f0()         79.6ms   79.9ms     12.3     1.44MB     4.94
#> 2 f01()        95.8ms     98ms     10.1    781.3KB     2.54
#> 3 fp()         99.3ms  101.3ms      9.83  783.24KB     2.46
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 214ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 33.2ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     929ms    929ms     1.08     7.63MB     2.15
#> 2 f01(1e+06)     1.1s     1.1s     0.905    7.63MB     1.81
#> 3 fp(1e+06)     1.23s    1.23s     0.816    7.63MB     2.45
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 296ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 120ns
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
#> 1 f0()         22.8ms   22.9ms    43.4      39.3KB     1.97
#> 2 fp()             4s       4s     0.250   100.7KB     1.75
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.7µs
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
#> 1 f0()        21.55ms  21.72ms    43.2      18.7KB     3.92
#> 2 ff()        30.81ms  30.94ms    30.7      27.6KB     1.92
#> 3 fp()          2.23s    2.23s     0.449    25.1KB     1.79
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 92.2ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   228.4ms  229.9ms    4.26          0B     2.84
#> 2 ff(1e+06)   320.5ms  326.6ms    3.06       1.9KB     3.06
#> 3 fp(1e+06)     23.6s    23.6s    0.0424     1.9KB     1.78
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.4µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 96.8ns
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
#> 1 test_baseline()    623.4ms  623.4ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.800    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.09KB        0
#> 4 test_cli_unroll() 623.86ms 623.86ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 31m
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
#> ■                                  0% | ETA: 17m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 6.2ms 6.38ms      154.    1.41MB     2.02
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (452/s) | 3ms
#> ⠹ 2 done (65/s) | 31ms
#> ⠸ 3 done (78/s) | 39ms
#> ⠼ 4 done (87/s) | 47ms
#> ⠴ 5 done (93/s) | 54ms
#> ⠦ 6 done (98/s) | 62ms
#> ⠧ 7 done (102/s) | 69ms
#> ⠇ 8 done (105/s) | 77ms
#> ⠏ 9 done (107/s) | 84ms
#> ⠋ 10 done (110/s) | 92ms
#> ⠙ 11 done (111/s) | 99ms
#> ⠹ 12 done (113/s) | 107ms
#> ⠸ 13 done (114/s) | 114ms
#> ⠼ 14 done (116/s) | 122ms
#> ⠴ 15 done (117/s) | 129ms
#> ⠦ 16 done (118/s) | 137ms
#> ⠧ 17 done (118/s) | 144ms
#> ⠇ 18 done (119/s) | 152ms
#> ⠏ 19 done (120/s) | 159ms
#> ⠋ 20 done (121/s) | 166ms
#> ⠙ 21 done (121/s) | 174ms
#> ⠹ 22 done (119/s) | 186ms
#> ⠸ 23 done (119/s) | 193ms
#> ⠼ 24 done (120/s) | 201ms
#> ⠴ 25 done (121/s) | 208ms
#> ⠦ 26 done (121/s) | 215ms
#> ⠧ 27 done (121/s) | 223ms
#> ⠇ 28 done (122/s) | 231ms
#> ⠏ 29 done (122/s) | 238ms
#> ⠋ 30 done (122/s) | 246ms
#> ⠙ 31 done (123/s) | 253ms
#> ⠹ 32 done (123/s) | 261ms
#> ⠸ 33 done (123/s) | 268ms
#> ⠼ 34 done (124/s) | 276ms
#> ⠴ 35 done (124/s) | 283ms
#> ⠦ 36 done (124/s) | 291ms
#> ⠧ 37 done (124/s) | 298ms
#> ⠇ 38 done (125/s) | 306ms
#> ⠏ 39 done (125/s) | 313ms
#> ⠋ 40 done (125/s) | 320ms
#> ⠙ 41 done (125/s) | 328ms
#> ⠹ 42 done (126/s) | 335ms
#> ⠸ 43 done (126/s) | 342ms
#> ⠼ 44 done (126/s) | 350ms
#> ⠴ 45 done (126/s) | 357ms
#> ⠦ 46 done (126/s) | 364ms
#> ⠧ 47 done (127/s) | 372ms
#> ⠇ 48 done (127/s) | 379ms
#> ⠏ 49 done (127/s) | 387ms
#> ⠋ 50 done (127/s) | 395ms
#> ⠙ 51 done (127/s) | 402ms
#> ⠹ 52 done (127/s) | 410ms
#> ⠸ 53 done (127/s) | 418ms
#> ⠼ 54 done (127/s) | 426ms
#> ⠴ 55 done (127/s) | 434ms
#> ⠦ 56 done (127/s) | 441ms
#> ⠧ 57 done (127/s) | 449ms
#> ⠇ 58 done (127/s) | 457ms
#> ⠏ 59 done (127/s) | 465ms
#> ⠋ 60 done (127/s) | 472ms
#> ⠙ 61 done (127/s) | 480ms
#> ⠹ 62 done (127/s) | 487ms
#> ⠸ 63 done (127/s) | 495ms
#> ⠼ 64 done (127/s) | 503ms
#> ⠴ 65 done (127/s) | 511ms
#> ⠦ 66 done (127/s) | 519ms
#> ⠧ 67 done (127/s) | 526ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.29ms 7.51ms      133.     265KB     2.04
cli_progress_done()
```
