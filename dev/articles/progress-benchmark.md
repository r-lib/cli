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
#> 1 __cli_update_due              0     10ns    1.16e8        0B        0
#> 2 fun()                  130.04ns  160.1ns    4.44e6        0B        0
#> 3 .Call(ccli_tick_reset) 110.01ns  121.1ns    7.70e6        0B        0
#> 4 interactive()            8.96ns   10.1ns    7.15e7        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 40.2ns 21632924.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      150ns    170ns  5559526.        0B        0
#> 2 ta[[1]]       140ns    160ns  5708232.        0B        0
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
#> 1 f0()         22.3ms   22.4ms      44.7    21.6KB     380.
#> 2 fp()         24.6ms   25.2ms      39.6    82.5KB     317.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 28.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     251ms    253ms      3.95        0B     35.6
#> 2 fp(1e+06)     271ms    273ms      3.67     1.9KB     33.0
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 19.8ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.48s    2.48s     0.404        0B     19.0
#> 2 fp(1e+07)     2.56s    2.56s     0.391     1.9KB     18.8
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.91ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     23.9s    23.9s    0.0418        0B     21.9
#> 2 fp(1e+08)     25.8s    25.8s    0.0387     1.9KB     20.0
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
#> 1 f0()         95.7ms    108ms      7.53     781KB    16.6 
#> 2 f01()       106.6ms    108ms      9.24     781KB     9.24
#> 3 fp()        127.9ms    131ms      6.83     783KB    12.0
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 233ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  957.15ms 957.15ms     1.04     7.63MB     7.31
#> 2 f01(1e+06)    1.65s    1.65s     0.608    7.63MB     4.86
#> 3 fp(1e+06)     2.57s    2.57s     0.390    7.63MB     1.95
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.61µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 922ns
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
#> 1 f0()         78.3ms   78.6ms      12.6    1.44MB     5.05
#> 2 f01()        94.2ms   95.6ms      10.4   781.3KB     2.07
#> 3 fp()         97.3ms   97.6ms      10.2  783.26KB     6.82
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 190ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 20.1ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   954.7ms  954.7ms     1.05     7.63MB     3.14
#> 2 f01(1e+06)    1.18s    1.18s     0.845    7.63MB     3.38
#> 3 fp(1e+06)     1.55s    1.55s     0.646    7.63MB     2.58
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 593ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 365ns
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
#> 1 f0()        28.05ms  31.21ms    31.2      39.3KB     3.90
#> 2 fp()          4.49s    4.49s     0.223   100.8KB     3.12
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 44.6µs
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
#> 1 f0()         21.7ms  21.88ms    44.9      18.7KB     3.90
#> 2 ff()        31.85ms  32.06ms    30.6      27.6KB     3.82
#> 3 fp()          2.29s    2.29s     0.437    25.1KB     3.06
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 22.6µs
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
#> 1 f0(1e+06)   227.3ms  227.4ms    4.39          0B     4.39
#> 2 ff(1e+06)   324.6ms  326.6ms    3.06      1.91KB     4.59
#> 3 fp(1e+06)     24.2s    24.2s    0.0413    1.91KB     2.56
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 24µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 99.2ns
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
#> 1 test_baseline()   622.85ms 622.85ms     1.61     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.800    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.802   24.11KB        0
#> 4 test_cli_unroll() 623.68ms 623.68ms     1.60     3.58KB        0
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.44ms 6.51ms      153.    1.42MB     4.19
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (488/s) | 3ms
#> ⠹ 2 done (68/s) | 30ms
#> ⠸ 3 done (80/s) | 38ms
#> ⠼ 4 done (89/s) | 46ms
#> ⠴ 5 done (95/s) | 53ms
#> ⠦ 6 done (100/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (106/s) | 76ms
#> ⠏ 9 done (109/s) | 84ms
#> ⠋ 10 done (111/s) | 91ms
#> ⠙ 11 done (112/s) | 99ms
#> ⠹ 12 done (114/s) | 106ms
#> ⠸ 13 done (115/s) | 114ms
#> ⠼ 14 done (116/s) | 121ms
#> ⠴ 15 done (117/s) | 129ms
#> ⠦ 16 done (118/s) | 136ms
#> ⠧ 17 done (119/s) | 144ms
#> ⠇ 18 done (119/s) | 152ms
#> ⠏ 19 done (120/s) | 159ms
#> ⠋ 20 done (120/s) | 167ms
#> ⠙ 21 done (121/s) | 174ms
#> ⠹ 22 done (121/s) | 182ms
#> ⠸ 23 done (122/s) | 189ms
#> ⠼ 24 done (122/s) | 197ms
#> ⠴ 25 done (123/s) | 204ms
#> ⠦ 26 done (123/s) | 212ms
#> ⠧ 27 done (123/s) | 220ms
#> ⠇ 28 done (124/s) | 227ms
#> ⠏ 29 done (124/s) | 235ms
#> ⠋ 30 done (124/s) | 242ms
#> ⠙ 31 done (124/s) | 250ms
#> ⠹ 32 done (125/s) | 257ms
#> ⠸ 33 done (125/s) | 265ms
#> ⠼ 34 done (125/s) | 273ms
#> ⠴ 35 done (125/s) | 281ms
#> ⠦ 36 done (125/s) | 288ms
#> ⠧ 37 done (125/s) | 296ms
#> ⠇ 38 done (125/s) | 304ms
#> ⠏ 39 done (126/s) | 311ms
#> ⠋ 40 done (126/s) | 319ms
#> ⠙ 41 done (126/s) | 326ms
#> ⠹ 42 done (126/s) | 334ms
#> ⠸ 43 done (126/s) | 342ms
#> ⠼ 44 done (126/s) | 349ms
#> ⠴ 45 done (126/s) | 357ms
#> ⠦ 46 done (125/s) | 368ms
#> ⠧ 47 done (125/s) | 376ms
#> ⠇ 48 done (126/s) | 383ms
#> ⠏ 49 done (126/s) | 391ms
#> ⠋ 50 done (126/s) | 398ms
#> ⠙ 51 done (126/s) | 406ms
#> ⠹ 52 done (126/s) | 413ms
#> ⠸ 53 done (126/s) | 421ms
#> ⠼ 54 done (126/s) | 428ms
#> ⠴ 55 done (126/s) | 436ms
#> ⠦ 56 done (126/s) | 444ms
#> ⠧ 57 done (127/s) | 451ms
#> ⠇ 58 done (127/s) | 459ms
#> ⠏ 59 done (127/s) | 466ms
#> ⠋ 60 done (127/s) | 474ms
#> ⠙ 61 done (127/s) | 481ms
#> ⠹ 62 done (127/s) | 489ms
#> ⠸ 63 done (127/s) | 497ms
#> ⠼ 64 done (127/s) | 504ms
#> ⠴ 65 done (127/s) | 512ms
#> ⠦ 66 done (127/s) | 519ms
#> ⠧ 67 done (127/s) | 527ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.46ms 7.57ms      132.     265KB     2.03
cli_progress_done()
```
