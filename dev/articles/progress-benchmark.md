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
#> 1 __cli_update_due           10ns   10.1ns 56741635.        0B        0
#> 2 fun()                     110ns    140ns  4697807.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  110.1ns  8532742.        0B        0
#> 4 interactive()              10ns     20ns 50085155.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 22970946.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      110ns    130ns  6646607.        0B        0
#> 2 ta[[1]]       110ns    140ns  5983657.        0B        0
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
#> 1 f0()         24.2ms   24.3ms      41.2    21.6KB     309.
#> 2 fp()         28.1ms   28.1ms      35.6    82.5KB     249.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 38.3ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     321ms    336ms      2.98        0B     26.8
#> 2 fp(1e+06)     307ms    321ms      3.11    1.88KB     26.4
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.79s    2.79s     0.359        0B     17.2
#> 2 fp(1e+07)     2.77s    2.77s     0.362    1.88KB     17.4
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
#> 1 f0(1e+08)     25.8s    25.8s    0.0387        0B     20.5
#> 2 fp(1e+08)     27.6s    27.6s    0.0362    1.88KB     19.0
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.1ns
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
#> 1 f0()           85ms   89.4ms      7.94     781KB    15.9 
#> 2 f01()         103ms  106.6ms      9.08     781KB    10.9 
#> 3 fp()          122ms  133.3ms      6.88     783KB     8.60
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 438ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.13s    1.13s     0.888    7.63MB     5.33
#> 2 f01(1e+06)    2.15s    2.15s     0.465    7.63MB     2.33
#> 3 fp(1e+06)     1.29s    1.29s     0.773    7.63MB     4.64
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 167ns
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
#> 1 f0()         76.2ms   76.7ms      13.0    1.44MB     9.78
#> 2 f01()        91.9ms   92.3ms      10.8   781.3KB     7.18
#> 3 fp()         96.1ms   96.4ms      10.1  783.24KB     6.76
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 197ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 40.7ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   922.3ms  922.3ms     1.08     7.63MB     2.17
#> 2 f01(1e+06)    1.16s    1.16s     0.863    7.63MB     2.59
#> 3 fp(1e+06)     1.29s    1.29s     0.778    7.63MB     3.11
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 364ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 128ns
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
#> 1 f0()        24.38ms  24.68ms    40.0      39.3KB     2.00
#> 2 fp()          3.88s    3.88s     0.258   100.7KB     2.32
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 38.6µs
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
#> 1 f0()        22.73ms  23.45ms    35.6      18.7KB     1.98
#> 2 ff()        31.71ms  31.89ms    26.3      27.6KB     3.76
#> 3 fp()          2.17s    2.17s     0.461    25.1KB     1.84
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 21.5µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 84.4ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   245.8ms  995.3ms    1.00          0B     1.00
#> 2 ff(1e+06)   329.9ms  334.2ms    2.99       1.9KB     1.50
#> 3 fp(1e+06)     21.3s    21.3s    0.0469     1.9KB     2.34
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 20.3µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 1ns
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
#> 1 test_baseline()   703.79ms 703.79ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.709    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.09KB        0
#> 4 test_cli_unroll() 704.96ms 704.96ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> ■                                  0% | ETA: 12m
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 5.63ms 5.91ms      167.    1.41MB     2.03
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (524/s) | 3ms
#> ⠹ 2 done (69/s) | 29ms
#> ⠸ 3 done (84/s) | 37ms
#> ⠼ 4 done (94/s) | 43ms
#> ⠴ 5 done (101/s) | 50ms
#> ⠦ 6 done (107/s) | 57ms
#> ⠧ 7 done (111/s) | 64ms
#> ⠇ 8 done (115/s) | 70ms
#> ⠏ 9 done (117/s) | 77ms
#> ⠋ 10 done (115/s) | 88ms
#> ⠙ 11 done (117/s) | 94ms
#> ⠹ 12 done (120/s) | 101ms
#> ⠸ 13 done (122/s) | 108ms
#> ⠼ 14 done (123/s) | 114ms
#> ⠴ 15 done (125/s) | 121ms
#> ⠦ 16 done (126/s) | 128ms
#> ⠧ 17 done (127/s) | 134ms
#> ⠇ 18 done (128/s) | 141ms
#> ⠏ 19 done (129/s) | 148ms
#> ⠋ 20 done (130/s) | 155ms
#> ⠙ 21 done (130/s) | 162ms
#> ⠹ 22 done (131/s) | 169ms
#> ⠸ 23 done (132/s) | 175ms
#> ⠼ 24 done (132/s) | 182ms
#> ⠴ 25 done (133/s) | 189ms
#> ⠦ 26 done (133/s) | 196ms
#> ⠧ 27 done (134/s) | 203ms
#> ⠇ 28 done (134/s) | 210ms
#> ⠏ 29 done (134/s) | 217ms
#> ⠋ 30 done (135/s) | 223ms
#> ⠙ 31 done (135/s) | 230ms
#> ⠹ 32 done (135/s) | 237ms
#> ⠸ 33 done (136/s) | 244ms
#> ⠼ 34 done (136/s) | 251ms
#> ⠴ 35 done (136/s) | 258ms
#> ⠦ 36 done (136/s) | 265ms
#> ⠧ 37 done (137/s) | 272ms
#> ⠇ 38 done (137/s) | 278ms
#> ⠏ 39 done (137/s) | 285ms
#> ⠋ 40 done (137/s) | 292ms
#> ⠙ 41 done (137/s) | 299ms
#> ⠹ 42 done (138/s) | 306ms
#> ⠸ 43 done (138/s) | 312ms
#> ⠼ 44 done (138/s) | 319ms
#> ⠴ 45 done (138/s) | 326ms
#> ⠦ 46 done (138/s) | 333ms
#> ⠧ 47 done (138/s) | 340ms
#> ⠇ 48 done (139/s) | 347ms
#> ⠏ 49 done (139/s) | 354ms
#> ⠋ 50 done (139/s) | 361ms
#> ⠙ 51 done (139/s) | 367ms
#> ⠹ 52 done (139/s) | 374ms
#> ⠸ 53 done (139/s) | 381ms
#> ⠼ 54 done (139/s) | 388ms
#> ⠴ 55 done (140/s) | 395ms
#> ⠦ 56 done (140/s) | 402ms
#> ⠧ 57 done (140/s) | 409ms
#> ⠇ 58 done (140/s) | 416ms
#> ⠏ 59 done (140/s) | 422ms
#> ⠋ 60 done (140/s) | 429ms
#> ⠙ 61 done (140/s) | 436ms
#> ⠹ 62 done (140/s) | 443ms
#> ⠸ 63 done (140/s) | 450ms
#> ⠼ 64 done (140/s) | 457ms
#> ⠴ 65 done (140/s) | 464ms
#> ⠦ 66 done (140/s) | 470ms
#> ⠧ 67 done (141/s) | 477ms
#> ⠇ 68 done (141/s) | 484ms
#> ⠏ 69 done (141/s) | 491ms
#> ⠋ 70 done (141/s) | 498ms
#> ⠙ 71 done (141/s) | 505ms
#> ⠹ 72 done (141/s) | 511ms
#> ⠸ 73 done (141/s) | 518ms
#> ⠼ 74 done (141/s) | 525ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.53ms 6.82ms      147.     265KB     2.04
cli_progress_done()
```
