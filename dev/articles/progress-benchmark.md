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
#> 1 __cli_update_due           10ns   10.1ns 75841812.        0B        0
#> 2 fun()                     110ns  131.1ns  4847309.        0B        0
#> 3 .Call(ccli_tick_reset)    100ns  111.1ns  8335198.        0B        0
#> 4 interactive()              10ns     20ns 50822723.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  30ns   40ns 19079628.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      100ns    130ns  6564884.        0B        0
#> 2 ta[[1]]       120ns    140ns  6148531.        0B        0
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
#> 1 f0()         24.5ms   24.5ms      40.7    21.6KB     326.
#> 2 fp()         28.8ms   30.6ms      32.7    82.5KB     229.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 60.8ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     273ms    277ms      3.61        0B     32.4
#> 2 fp(1e+06)     292ms    293ms      3.41    1.88KB     29.0
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 16.1ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.67s    2.67s     0.374        0B     18.0
#> 2 fp(1e+07)     2.75s    2.75s     0.364    1.88KB     17.5
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 7.56ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     26.4s    26.4s    0.0378        0B     20.0
#> 2 fp(1e+08)     28.3s    28.3s    0.0354    1.88KB     18.6
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 18.4ns
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
#> 1 f0()         91.4ms   96.8ms      6.92     781KB    13.8 
#> 2 f01()       110.2ms  110.6ms      8.60     781KB    10.3 
#> 3 fp()        136.3ms  139.9ms      5.80     783KB     9.67
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 431ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     1.24s    1.24s     0.805    7.63MB     5.63
#> 2 f01(1e+06)    2.08s    2.08s     0.481    7.63MB     1.93
#> 3 fp(1e+06)     1.65s    1.65s     0.606    7.63MB     3.64
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 407ns
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
#> 1 f0()         74.5ms   76.2ms      13.1    1.44MB    13.1 
#> 2 f01()        89.7ms   92.5ms      10.8   781.3KB     5.41
#> 3 fp()         92.6ms   92.7ms      10.7  783.24KB    10.7
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 164ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 1.28ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  947.96ms 947.96ms     1.05     7.63MB     3.16
#> 2 f01(1e+06)    1.17s    1.17s     0.855    7.63MB     2.57
#> 3 fp(1e+06)      1.8s     1.8s     0.556    7.63MB     2.78
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 850ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 628ns
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
#> 1 f0()        28.39ms   35.7ms    27.8      39.3KB     1.98
#> 2 fp()          4.64s    4.64s     0.216   100.7KB     2.80
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 46µs
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
#> 1 f0()        24.65ms  54.93ms    18.7      18.7KB     3.73
#> 2 ff()        33.29ms  62.85ms    16.3      27.6KB     1.81
#> 3 fp()          2.61s    2.61s     0.383    25.1KB     2.68
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 25.5µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 79.2ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   235.7ms  236.2ms    4.20          0B     4.20
#> 2 ff(1e+06)   318.5ms  319.1ms    3.13       1.9KB     3.13
#> 3 fp(1e+06)     22.4s    22.4s    0.0446     1.9KB     2.59
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 22.2µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 82.9ns
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
#> 1 test_baseline()    703.8ms  703.8ms     1.42     2.08KB        0
#> 2 test_modulo()        1.41s    1.41s     0.710    2.24KB        0
#> 3 test_cli()           1.02s    1.02s     0.984   24.09KB        0
#> 4 test_cli_unroll() 704.66ms 704.66ms     1.42     3.56KB        0
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
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 31m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
#> ■                                  0% | ETA: 26m
#> ■                                  0% | ETA: 25m
#> ■                                  0% | ETA: 24m
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
#> 1 cli_progress_update(force… 5.89ms 6.03ms      161.    1.41MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (491/s) | 3ms
#> ⠹ 2 done (71/s) | 29ms
#> ⠸ 3 done (85/s) | 36ms
#> ⠼ 4 done (94/s) | 43ms
#> ⠴ 5 done (101/s) | 50ms
#> ⠦ 6 done (106/s) | 57ms
#> ⠧ 7 done (110/s) | 64ms
#> ⠇ 8 done (113/s) | 71ms
#> ⠏ 9 done (116/s) | 78ms
#> ⠋ 10 done (118/s) | 86ms
#> ⠙ 11 done (119/s) | 93ms
#> ⠹ 12 done (121/s) | 100ms
#> ⠸ 13 done (122/s) | 107ms
#> ⠼ 14 done (124/s) | 114ms
#> ⠴ 15 done (125/s) | 121ms
#> ⠦ 16 done (125/s) | 128ms
#> ⠧ 17 done (126/s) | 135ms
#> ⠇ 18 done (127/s) | 142ms
#> ⠏ 19 done (128/s) | 149ms
#> ⠋ 20 done (129/s) | 156ms
#> ⠙ 21 done (129/s) | 163ms
#> ⠹ 22 done (130/s) | 170ms
#> ⠸ 23 done (126/s) | 182ms
#> ⠼ 24 done (127/s) | 190ms
#> ⠴ 25 done (127/s) | 198ms
#> ⠦ 26 done (127/s) | 206ms
#> ⠧ 27 done (127/s) | 214ms
#> ⠇ 28 done (127/s) | 222ms
#> ⠏ 29 done (126/s) | 230ms
#> ⠋ 30 done (126/s) | 238ms
#> ⠙ 31 done (127/s) | 245ms
#> ⠹ 32 done (127/s) | 252ms
#> ⠸ 33 done (128/s) | 259ms
#> ⠼ 34 done (128/s) | 266ms
#> ⠴ 35 done (128/s) | 273ms
#> ⠦ 36 done (129/s) | 280ms
#> ⠧ 37 done (129/s) | 288ms
#> ⠇ 38 done (129/s) | 295ms
#> ⠏ 39 done (129/s) | 302ms
#> ⠋ 40 done (130/s) | 309ms
#> ⠙ 41 done (130/s) | 316ms
#> ⠹ 42 done (130/s) | 323ms
#> ⠸ 43 done (130/s) | 330ms
#> ⠼ 44 done (131/s) | 337ms
#> ⠴ 45 done (131/s) | 344ms
#> ⠦ 46 done (131/s) | 351ms
#> ⠧ 47 done (131/s) | 358ms
#> ⠇ 48 done (132/s) | 365ms
#> ⠏ 49 done (132/s) | 373ms
#> ⠋ 50 done (132/s) | 380ms
#> ⠙ 51 done (132/s) | 387ms
#> ⠹ 52 done (132/s) | 394ms
#> ⠸ 53 done (132/s) | 401ms
#> ⠼ 54 done (133/s) | 408ms
#> ⠴ 55 done (133/s) | 415ms
#> ⠦ 56 done (133/s) | 422ms
#> ⠧ 57 done (133/s) | 429ms
#> ⠇ 58 done (133/s) | 436ms
#> ⠏ 59 done (133/s) | 443ms
#> ⠋ 60 done (133/s) | 450ms
#> ⠙ 61 done (134/s) | 457ms
#> ⠹ 62 done (134/s) | 465ms
#> ⠸ 63 done (134/s) | 472ms
#> ⠼ 64 done (134/s) | 479ms
#> ⠴ 65 done (134/s) | 486ms
#> ⠦ 66 done (134/s) | 493ms
#> ⠧ 67 done (134/s) | 500ms
#> ⠇ 68 done (134/s) | 507ms
#> ⠏ 69 done (134/s) | 514ms
#> ⠋ 70 done (135/s) | 521ms
#> ⠙ 71 done (135/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force … 6.9ms 7.05ms      140.     265KB     2.03
cli_progress_done()
```
