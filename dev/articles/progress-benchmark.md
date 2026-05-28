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
#> 1 __cli_update_due              0     10ns    1.10e8        0B        0
#> 2 fun()                  119.91ns    140ns    5.01e6        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  111.1ns    8.52e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    7.06e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 40.2ns 21956462.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    140ns  6099167.        0B        0
#> 2 ta[[1]]       140ns    151ns  5991183.        0B        0
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
#> 1 f0()         21.6ms   21.7ms      46.1    21.6KB     438.
#> 2 fp()         24.4ms   24.5ms      40.8    82.5KB     218.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28.2ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     235ms    236ms      4.25        0B     36.8
#> 2 fp(1e+06)     253ms    286ms      3.50    1.88KB     26.3
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 50.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.36s    2.36s     0.423        0B     20.3
#> 2 fp(1e+07)     2.47s    2.47s     0.405    1.88KB     19.4
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 10.6ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.3s    23.3s    0.0430        0B     22.7
#> 2 fp(1e+08)     24.9s    24.9s    0.0401    1.88KB     21.1
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
#> 1 f0()         84.8ms     90ms      8.91     781KB    16.0 
#> 2 f01()       110.7ms    115ms      8.63     781KB     8.63
#> 3 fp()        114.6ms    127ms      7.44     783KB    11.9
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 369ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  895.46ms 895.46ms     1.12     7.63MB     7.82
#> 2 f01(1e+06)    1.29s    1.29s     0.775    7.63MB     5.43
#> 3 fp(1e+06)     1.81s    1.81s     0.552    7.63MB     4.41
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 917ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 522ns
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
#> 1 f0()         76.4ms   81.6ms     12.2     1.44MB     6.98
#> 2 f01()       112.1ms  115.8ms      7.66   781.3KB     7.66
#> 3 fp()        117.7ms  127.2ms      7.81  783.24KB     5.86
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 456ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 113ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  848.13ms 848.13ms     1.18     7.63MB     2.36
#> 2 f01(1e+06)    1.27s    1.27s     0.789    7.63MB     2.37
#> 3 fp(1e+06)     1.19s    1.19s     0.844    7.63MB     1.69
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 337ns
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
#> 1 f0()        22.82ms  22.98ms    43.2      39.3KB     1.97
#> 2 fp()          3.97s    3.97s     0.252   100.7KB     2.01
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.5µs
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
#> 1 f0()        21.31ms  21.49ms    41.1      18.7KB     3.92
#> 2 ff()        30.38ms  30.53ms    30.7      27.6KB     1.92
#> 3 fp()          2.24s    2.24s     0.447    25.1KB     1.79
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.2µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 90.4ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   233.5ms  250.3ms    3.76          0B     3.76
#> 2 ff(1e+06)   322.1ms  333.1ms    3.00       1.9KB     1.50
#> 3 fp(1e+06)     22.8s    22.8s    0.0439     1.9KB     1.89
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 82.8ns
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
#> 1 test_baseline()   622.58ms 622.58ms     1.61     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.800    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.09KB        0
#> 4 test_cli_unroll()  623.7ms  623.7ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
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
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.02ms 6.12ms      161.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (513/s) | 3ms
#> ⠹ 2 done (68/s) | 30ms
#> ⠸ 3 done (81/s) | 38ms
#> ⠼ 4 done (90/s) | 45ms
#> ⠴ 5 done (97/s) | 52ms
#> ⠦ 6 done (102/s) | 59ms
#> ⠧ 7 done (106/s) | 67ms
#> ⠇ 8 done (109/s) | 74ms
#> ⠏ 9 done (112/s) | 81ms
#> ⠋ 10 done (114/s) | 88ms
#> ⠙ 11 done (116/s) | 95ms
#> ⠹ 12 done (118/s) | 103ms
#> ⠸ 13 done (119/s) | 110ms
#> ⠼ 14 done (120/s) | 117ms
#> ⠴ 15 done (122/s) | 124ms
#> ⠦ 16 done (123/s) | 131ms
#> ⠧ 17 done (123/s) | 138ms
#> ⠇ 18 done (124/s) | 146ms
#> ⠏ 19 done (125/s) | 153ms
#> ⠋ 20 done (126/s) | 160ms
#> ⠙ 21 done (126/s) | 167ms
#> ⠹ 22 done (127/s) | 174ms
#> ⠸ 23 done (127/s) | 181ms
#> ⠼ 24 done (128/s) | 189ms
#> ⠴ 25 done (128/s) | 196ms
#> ⠦ 26 done (128/s) | 203ms
#> ⠧ 27 done (129/s) | 210ms
#> ⠇ 28 done (129/s) | 217ms
#> ⠏ 29 done (130/s) | 224ms
#> ⠋ 30 done (130/s) | 232ms
#> ⠙ 31 done (130/s) | 239ms
#> ⠹ 32 done (130/s) | 246ms
#> ⠸ 33 done (131/s) | 253ms
#> ⠼ 34 done (131/s) | 260ms
#> ⠴ 35 done (131/s) | 267ms
#> ⠦ 36 done (131/s) | 275ms
#> ⠧ 37 done (132/s) | 282ms
#> ⠇ 38 done (132/s) | 289ms
#> ⠏ 39 done (131/s) | 299ms
#> ⠋ 40 done (131/s) | 306ms
#> ⠙ 41 done (131/s) | 313ms
#> ⠹ 42 done (131/s) | 320ms
#> ⠸ 43 done (132/s) | 327ms
#> ⠼ 44 done (132/s) | 335ms
#> ⠴ 45 done (132/s) | 342ms
#> ⠦ 46 done (132/s) | 349ms
#> ⠧ 47 done (132/s) | 356ms
#> ⠇ 48 done (132/s) | 363ms
#> ⠏ 49 done (133/s) | 370ms
#> ⠋ 50 done (133/s) | 378ms
#> ⠙ 51 done (133/s) | 385ms
#> ⠹ 52 done (133/s) | 392ms
#> ⠸ 53 done (133/s) | 399ms
#> ⠼ 54 done (133/s) | 406ms
#> ⠴ 55 done (133/s) | 413ms
#> ⠦ 56 done (133/s) | 420ms
#> ⠧ 57 done (134/s) | 428ms
#> ⠇ 58 done (134/s) | 435ms
#> ⠏ 59 done (134/s) | 442ms
#> ⠋ 60 done (134/s) | 449ms
#> ⠙ 61 done (134/s) | 456ms
#> ⠹ 62 done (134/s) | 463ms
#> ⠸ 63 done (134/s) | 470ms
#> ⠼ 64 done (134/s) | 478ms
#> ⠴ 65 done (134/s) | 485ms
#> ⠦ 66 done (134/s) | 492ms
#> ⠧ 67 done (134/s) | 499ms
#> ⠇ 68 done (134/s) | 507ms
#> ⠏ 69 done (134/s) | 514ms
#> ⠋ 70 done (135/s) | 521ms
#> ⠙ 71 done (135/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.01ms 7.16ms      139.     265KB     2.02
cli_progress_done()
```
