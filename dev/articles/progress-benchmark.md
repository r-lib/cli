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
#> 1 __cli_update_due              0     10ns 83700568.        0B        0
#> 2 fun()                  130.04ns    160ns  4574794.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns    121ns  7835771.        0B        0
#> 4 interactive()            8.96ns     20ns 49768362.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 41.1ns 19910120.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      130ns    160ns  5774834.        0B        0
#> 2 ta[[1]]       150ns    170ns  5358797.        0B        0
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
#> 1 f0()         21.7ms   21.8ms      45.9    21.6KB     436.
#> 2 fp()         24.1ms   24.3ms      41.1    82.5KB     219.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 24.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     238ms    241ms      4.16        0B     36.1
#> 2 fp(1e+06)     259ms    288ms      3.47    1.88KB     26.1
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 46.7ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.39s    2.39s     0.418        0B     20.0
#> 2 fp(1e+07)     2.47s    2.47s     0.404    1.88KB     19.4
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.82ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.4s    23.4s    0.0427        0B     22.6
#> 2 fp(1e+08)     25.2s    25.2s    0.0397    1.88KB     20.9
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
#> 1 f0()         92.2ms   94.5ms      7.89     781KB    15.8 
#> 2 f01()       107.8ms  122.1ms      8.40     781KB     8.40
#> 3 fp()        116.4ms    127ms      7.86     783KB    11.8
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 325ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)      1.1s     1.1s     0.911    7.63MB     6.38
#> 2 f01(1e+06)    2.69s    2.69s     0.372    7.63MB     2.97
#> 3 fp(1e+06)     1.14s    1.14s     0.878    7.63MB     1.76
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 41.1ns
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
#> 1 f0()         78.9ms   81.2ms     12.4     1.44MB     4.95
#> 2 f01()        95.3ms   95.7ms     10.3    781.3KB     2.06
#> 3 fp()         98.7ms  101.4ms      9.78  783.24KB     2.44
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 202ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 57.7ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  907.37ms 907.37ms     1.10     7.63MB     2.20
#> 2 f01(1e+06)    1.08s    1.08s     0.923    7.63MB     1.85
#> 3 fp(1e+06)     1.21s    1.21s     0.826    7.63MB     2.48
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 303ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 127ns
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
#> 1 f0()        22.84ms   22.9ms    43.4      39.3KB     1.97
#> 2 fp()          4.01s    4.01s     0.249   100.7KB     1.75
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 39.9µs
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
#> 1 f0()        21.41ms  21.58ms    43.8      18.7KB     3.98
#> 2 ff()         30.8ms  30.96ms    30.9      27.6KB     1.93
#> 3 fp()          2.23s    2.23s     0.449    25.1KB     1.79
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 93.8ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   225.9ms  236.1ms    4.28          0B     2.85
#> 2 ff(1e+06)   305.8ms  316.5ms    3.16       1.9KB     3.16
#> 3 fp(1e+06)     23.3s    23.3s    0.0429     1.9KB     1.80
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 23.1µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 80.4ns
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
#> 1 test_baseline()   623.92ms 623.92ms     1.60     2.08KB        0
#> 2 test_modulo()        1.26s    1.26s     0.792    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.801   24.09KB        0
#> 4 test_cli_unroll() 624.31ms 624.31ms     1.60     3.56KB        0
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
#> ■                                  0% | ETA: 47m
#> ■                                  0% | ETA: 42m
#> ■                                  0% | ETA: 38m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
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
#> ■                                  0% | ETA: 13m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.24ms 6.35ms      154.    1.41MB        0
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (487/s) | 3ms
#> ⠹ 2 done (66/s) | 31ms
#> ⠸ 3 done (79/s) | 39ms
#> ⠼ 4 done (88/s) | 46ms
#> ⠴ 5 done (94/s) | 54ms
#> ⠦ 6 done (99/s) | 61ms
#> ⠧ 7 done (103/s) | 69ms
#> ⠇ 8 done (106/s) | 76ms
#> ⠏ 9 done (109/s) | 84ms
#> ⠋ 10 done (111/s) | 91ms
#> ⠙ 11 done (108/s) | 103ms
#> ⠹ 12 done (109/s) | 110ms
#> ⠸ 13 done (111/s) | 118ms
#> ⠼ 14 done (113/s) | 125ms
#> ⠴ 15 done (114/s) | 132ms
#> ⠦ 16 done (115/s) | 140ms
#> ⠧ 17 done (116/s) | 147ms
#> ⠇ 18 done (117/s) | 155ms
#> ⠏ 19 done (117/s) | 162ms
#> ⠋ 20 done (118/s) | 170ms
#> ⠙ 21 done (119/s) | 177ms
#> ⠹ 22 done (120/s) | 185ms
#> ⠸ 23 done (120/s) | 192ms
#> ⠼ 24 done (121/s) | 199ms
#> ⠴ 25 done (121/s) | 207ms
#> ⠦ 26 done (122/s) | 214ms
#> ⠧ 27 done (122/s) | 221ms
#> ⠇ 28 done (123/s) | 229ms
#> ⠏ 29 done (123/s) | 236ms
#> ⠋ 30 done (123/s) | 244ms
#> ⠙ 31 done (124/s) | 251ms
#> ⠹ 32 done (124/s) | 259ms
#> ⠸ 33 done (124/s) | 266ms
#> ⠼ 34 done (125/s) | 273ms
#> ⠴ 35 done (125/s) | 281ms
#> ⠦ 36 done (125/s) | 288ms
#> ⠧ 37 done (125/s) | 296ms
#> ⠇ 38 done (125/s) | 304ms
#> ⠏ 39 done (125/s) | 312ms
#> ⠋ 40 done (125/s) | 319ms
#> ⠙ 41 done (125/s) | 327ms
#> ⠹ 42 done (126/s) | 335ms
#> ⠸ 43 done (126/s) | 342ms
#> ⠼ 44 done (126/s) | 350ms
#> ⠴ 45 done (126/s) | 357ms
#> ⠦ 46 done (126/s) | 365ms
#> ⠧ 47 done (127/s) | 372ms
#> ⠇ 48 done (127/s) | 379ms
#> ⠏ 49 done (127/s) | 387ms
#> ⠋ 50 done (127/s) | 394ms
#> ⠙ 51 done (127/s) | 402ms
#> ⠹ 52 done (127/s) | 409ms
#> ⠸ 53 done (127/s) | 417ms
#> ⠼ 54 done (127/s) | 424ms
#> ⠴ 55 done (128/s) | 432ms
#> ⠦ 56 done (128/s) | 439ms
#> ⠧ 57 done (128/s) | 447ms
#> ⠇ 58 done (128/s) | 454ms
#> ⠏ 59 done (128/s) | 462ms
#> ⠋ 60 done (128/s) | 469ms
#> ⠙ 61 done (128/s) | 476ms
#> ⠹ 62 done (128/s) | 484ms
#> ⠸ 63 done (128/s) | 491ms
#> ⠼ 64 done (129/s) | 499ms
#> ⠴ 65 done (129/s) | 506ms
#> ⠦ 66 done (129/s) | 514ms
#> ⠧ 67 done (129/s) | 521ms
#> ⠇ 68 done (129/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 7.3ms 7.43ms      134.     265KB     2.03
cli_progress_done()
```
