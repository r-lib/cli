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
#> 1 __cli_update_due              0     10ns    1.21e8        0B        0
#> 2 fun()                  129.92ns  150.9ns    4.60e6        0B        0
#> 3 .Call(ccli_tick_reset) 101.05ns  120.1ns    8.02e6        0B        0
#> 4 interactive()            8.96ns   11.1ns    6.50e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 21326992.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    150ns  6161085.        0B        0
#> 2 ta[[1]]       140ns    160ns  5560972.        0B        0
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
#> 1 f0()         22.2ms   22.3ms      44.7    21.6KB     253.
#> 2 fp()         24.6ms   24.7ms      40.5    82.3KB     344.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 23.7ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     244ms    244ms      4.09        0B     34.1
#> 2 fp(1e+06)     264ms    296ms      3.38     1.9KB     30.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 51.2ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.56s    2.56s     0.390        0B     30.8
#> 2 fp(1e+07)     2.51s    2.51s     0.399     1.9KB     18.8
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 1ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.8s    23.8s    0.0420        0B     22.3
#> 2 fp(1e+08)     25.6s    25.6s    0.0391     1.9KB     20.5
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 17.6ns
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
#> 1 f0()         91.6ms    105ms      8.01     781KB     17.6
#> 2 f01()       105.1ms    107ms      9.09     781KB     10.9
#> 3 fp()        114.6ms    125ms      7.02     783KB     12.3
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 201ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  919.01ms 919.01ms     1.09     7.63MB     4.35
#> 2 f01(1e+06)    1.15s    1.15s     0.869    7.63MB     5.21
#> 3 fp(1e+06)     1.45s    1.45s     0.692    7.63MB     2.77
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 527ns
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 295ns
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
#> 1 f0()           80ms   80.1ms      12.4    1.44MB     4.96
#> 2 f01()        94.3ms   94.6ms      10.6   781.3KB    15.9 
#> 3 fp()         98.3ms   99.7ms      10.0  783.26KB     6.69
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 196ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 51ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  967.59ms 967.59ms     1.03     7.63MB     3.10
#> 2 f01(1e+06)    1.21s    1.21s     0.825    7.63MB     3.30
#> 3 fp(1e+06)     2.68s    2.68s     0.373    7.63MB     1.49
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1.71µs
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 1.47µs
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
#> 1 f0()        22.75ms  22.84ms    43.0      39.3KB     3.91
#> 2 fp()          4.13s    4.13s     0.242   100.4KB     2.66
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 41.1µs
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
#> 1 f0()        21.68ms  21.98ms    43.1      18.7KB     3.92
#> 2 ff()        31.86ms   32.2ms    28.6      27.6KB     3.81
#> 3 fp()          2.34s    2.34s     0.428    25.1KB     2.57
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.2µs
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
#> 1 f0(1e+06)   222.9ms  223.2ms    4.48          0B     4.48
#> 2 ff(1e+06)   318.9ms  319.6ms    3.13      1.91KB     4.69
#> 3 fp(1e+06)     22.8s    22.8s    0.0439    1.91KB     2.72
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.6µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 96.4ns
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
#> 1 test_baseline()   623.83ms 623.83ms     1.60     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.801    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   23.89KB        0
#> 4 test_cli_unroll() 624.38ms 624.38ms     1.60     3.58KB        0
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.62ms 7.02ms      140.     1.4MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (446/s) | 3ms
#> ⠹ 2 done (66/s) | 31ms
#> ⠸ 3 done (77/s) | 40ms
#> ⠼ 4 done (85/s) | 48ms
#> ⠴ 5 done (90/s) | 56ms
#> ⠦ 6 done (94/s) | 64ms
#> ⠧ 7 done (98/s) | 72ms
#> ⠇ 8 done (100/s) | 81ms
#> ⠏ 9 done (102/s) | 89ms
#> ⠋ 10 done (104/s) | 97ms
#> ⠙ 11 done (105/s) | 105ms
#> ⠹ 12 done (107/s) | 113ms
#> ⠸ 13 done (107/s) | 122ms
#> ⠼ 14 done (108/s) | 130ms
#> ⠴ 15 done (109/s) | 138ms
#> ⠦ 16 done (110/s) | 146ms
#> ⠧ 17 done (110/s) | 155ms
#> ⠇ 18 done (111/s) | 163ms
#> ⠏ 19 done (111/s) | 172ms
#> ⠋ 20 done (111/s) | 180ms
#> ⠙ 21 done (112/s) | 189ms
#> ⠹ 22 done (112/s) | 197ms
#> ⠸ 23 done (112/s) | 205ms
#> ⠼ 24 done (113/s) | 214ms
#> ⠴ 25 done (113/s) | 222ms
#> ⠦ 26 done (113/s) | 230ms
#> ⠧ 27 done (114/s) | 238ms
#> ⠇ 28 done (114/s) | 246ms
#> ⠏ 29 done (114/s) | 255ms
#> ⠋ 30 done (114/s) | 263ms
#> ⠙ 31 done (114/s) | 271ms
#> ⠹ 32 done (115/s) | 280ms
#> ⠸ 33 done (115/s) | 288ms
#> ⠼ 34 done (115/s) | 296ms
#> ⠴ 35 done (115/s) | 304ms
#> ⠦ 36 done (115/s) | 312ms
#> ⠧ 37 done (116/s) | 321ms
#> ⠇ 38 done (114/s) | 333ms
#> ⠏ 39 done (114/s) | 342ms
#> ⠋ 40 done (114/s) | 351ms
#> ⠙ 41 done (114/s) | 361ms
#> ⠹ 42 done (113/s) | 371ms
#> ⠸ 43 done (113/s) | 380ms
#> ⠼ 44 done (113/s) | 388ms
#> ⠴ 45 done (114/s) | 397ms
#> ⠦ 46 done (114/s) | 405ms
#> ⠧ 47 done (114/s) | 413ms
#> ⠇ 48 done (114/s) | 421ms
#> ⠏ 49 done (114/s) | 429ms
#> ⠋ 50 done (114/s) | 440ms
#> ⠙ 51 done (114/s) | 449ms
#> ⠹ 52 done (113/s) | 461ms
#> ⠸ 53 done (112/s) | 474ms
#> ⠼ 54 done (112/s) | 483ms
#> ⠴ 55 done (112/s) | 491ms
#> ⠦ 56 done (112/s) | 499ms
#> ⠧ 57 done (112/s) | 508ms
#> ⠇ 58 done (113/s) | 516ms
#> ⠏ 59 done (113/s) | 524ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 8.03ms 8.26ms      117.     265KB     2.05
cli_progress_done()
```
