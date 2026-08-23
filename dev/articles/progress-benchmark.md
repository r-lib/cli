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
#> 1 __cli_update_due              0     10ns 90312200.        0B        0
#> 2 fun()                  130.04ns    161ns  4385038.        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns  120.1ns  7745756.        0B        0
#> 4 interactive()            8.96ns   10.1ns 62203938.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20509608.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    150ns  6415908.        0B        0
#> 2 ta[[1]]       140ns    160ns  5793334.        0B        0
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
#> 1 f0()         22.4ms   22.5ms      44.5    21.6KB     378.
#> 2 fp()         25.1ms   25.5ms      39.2    82.5KB     313.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 30.4ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     252ms    253ms      3.95        0B     35.6
#> 2 fp(1e+06)     271ms    272ms      3.67     1.9KB     31.2
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.5ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.47s    2.47s     0.405        0B     19.5
#> 2 fp(1e+07)     2.56s    2.56s     0.390     1.9KB     18.3
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 9.67ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)       24s      24s    0.0416        0B     21.9
#> 2 fp(1e+08)     25.8s    25.8s    0.0387     1.9KB     20.1
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.9ns
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
#> 1 f0()           93ms    108ms      7.22     781KB    15.9 
#> 2 f01()         107ms    109ms      8.92     781KB    10.7 
#> 3 fp()          128ms    141ms      6.64     783KB     8.30
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 337ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)      1.1s     1.1s     0.906    7.63MB     6.34
#> 2 f01(1e+06)    2.02s    2.02s     0.495    7.63MB     3.96
#> 3 fp(1e+06)     2.51s    2.51s     0.398    7.63MB     1.59
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.41µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 492ns
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
#> 1 f0()         78.7ms   79.3ms     12.5     1.44MB     6.27
#> 2 f01()        94.5ms   94.5ms     10.5    781.3KB     6.98
#> 3 fp()         99.3ms  100.2ms      9.98  783.26KB     6.65
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 209ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 57.3ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  915.55ms 915.55ms     1.09     7.63MB     2.18
#> 2 f01(1e+06)    1.12s    1.12s     0.891    7.63MB     2.67
#> 3 fp(1e+06)     1.66s    1.66s     0.603    7.63MB     3.01
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 744ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 538ns
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
#> 1 f0()        22.72ms  22.91ms    43.4      39.3KB     1.97
#> 2 fp()          4.15s    4.15s     0.241   100.8KB     2.41
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 41.3µs
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
#> 1 f0()         21.8ms   22.1ms    41.8      18.7KB     3.98
#> 2 ff()         32.3ms   32.6ms    28.4      27.6KB     3.78
#> 3 fp()           2.4s     2.4s     0.417    25.1KB     2.09
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.7µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 105ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   222.3ms  222.4ms    4.48          0B     4.48
#> 2 ff(1e+06)   336.2ms  357.3ms    2.80      1.91KB     2.80
#> 3 fp(1e+06)     23.5s    23.5s    0.0426    1.91KB     2.38
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.3µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 135ns
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
#> 1 test_baseline()      626ms    626ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.11KB        0
#> 4 test_cli_unroll()    624ms    624ms     1.60     3.58KB        0
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
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
#> ■                                  0% | ETA: 23m
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
#> 1 cli_progress_update(force… 6.46ms 6.58ms      146.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (484/s) | 3ms
#> ⠹ 2 done (65/s) | 32ms
#> ⠸ 3 done (78/s) | 39ms
#> ⠼ 4 done (86/s) | 47ms
#> ⠴ 5 done (93/s) | 55ms
#> ⠦ 6 done (97/s) | 62ms
#> ⠧ 7 done (100/s) | 71ms
#> ⠇ 8 done (103/s) | 78ms
#> ⠏ 9 done (106/s) | 86ms
#> ⠋ 10 done (108/s) | 93ms
#> ⠙ 11 done (105/s) | 105ms
#> ⠹ 12 done (106/s) | 114ms
#> ⠸ 13 done (107/s) | 122ms
#> ⠼ 14 done (108/s) | 131ms
#> ⠴ 15 done (108/s) | 139ms
#> ⠦ 16 done (109/s) | 147ms
#> ⠧ 17 done (109/s) | 156ms
#> ⠇ 18 done (110/s) | 164ms
#> ⠏ 19 done (110/s) | 173ms
#> ⠋ 20 done (110/s) | 182ms
#> ⠙ 21 done (111/s) | 190ms
#> ⠹ 22 done (111/s) | 199ms
#> ⠸ 23 done (111/s) | 207ms
#> ⠼ 24 done (112/s) | 216ms
#> ⠴ 25 done (112/s) | 224ms
#> ⠦ 26 done (113/s) | 231ms
#> ⠧ 27 done (113/s) | 239ms
#> ⠇ 28 done (114/s) | 246ms
#> ⠏ 29 done (114/s) | 254ms
#> ⠋ 30 done (115/s) | 262ms
#> ⠙ 31 done (115/s) | 269ms
#> ⠹ 32 done (116/s) | 277ms
#> ⠸ 33 done (116/s) | 285ms
#> ⠼ 34 done (117/s) | 292ms
#> ⠴ 35 done (117/s) | 300ms
#> ⠦ 36 done (117/s) | 307ms
#> ⠧ 37 done (118/s) | 315ms
#> ⠇ 38 done (118/s) | 323ms
#> ⠏ 39 done (118/s) | 330ms
#> ⠋ 40 done (119/s) | 338ms
#> ⠙ 41 done (119/s) | 345ms
#> ⠹ 42 done (119/s) | 353ms
#> ⠸ 43 done (119/s) | 361ms
#> ⠼ 44 done (120/s) | 368ms
#> ⠴ 45 done (120/s) | 376ms
#> ⠦ 46 done (120/s) | 383ms
#> ⠧ 47 done (120/s) | 391ms
#> ⠇ 48 done (121/s) | 399ms
#> ⠏ 49 done (121/s) | 406ms
#> ⠋ 50 done (121/s) | 414ms
#> ⠙ 51 done (121/s) | 422ms
#> ⠹ 52 done (121/s) | 429ms
#> ⠸ 53 done (121/s) | 437ms
#> ⠼ 54 done (122/s) | 445ms
#> ⠴ 55 done (122/s) | 452ms
#> ⠦ 56 done (122/s) | 460ms
#> ⠧ 57 done (122/s) | 468ms
#> ⠇ 58 done (122/s) | 475ms
#> ⠏ 59 done (122/s) | 483ms
#> ⠋ 60 done (122/s) | 491ms
#> ⠙ 61 done (123/s) | 498ms
#> ⠹ 62 done (123/s) | 506ms
#> ⠸ 63 done (123/s) | 513ms
#> ⠼ 64 done (123/s) | 521ms
#> ⠴ 65 done (123/s) | 529ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.53ms 7.62ms      128.     265KB     2.03
cli_progress_done()
```
