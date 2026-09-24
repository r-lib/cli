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
#> 1 __cli_update_due              0     10ns 98277067.        0B        0
#> 2 fun()                  130.04ns  151.1ns  4343334.        0B        0
#> 3 .Call(ccli_tick_reset) 120.02ns    140ns  6975437.        0B        0
#> 4 interactive()            8.96ns   10.1ns 70496033.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                  <bch> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) fo…  40ns 50.1ns 20376120.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]      120ns    141ns  6278513.        0B        0
#> 2 ta[[1]]       140ns    151ns  5824533.        0B        0
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
#> 1 f0()         22.6ms   22.6ms      44.2    21.6KB     375.
#> 2 fp()         25.4ms   25.9ms      38.7    82.5KB     290.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 32.1ns
```

``` r

ben_taf2 <- bench::mark(f0(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf2
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)     263ms    267ms      3.75        0B     33.7
#> 2 fp(1e+06)     282ms    283ms      3.54     1.9KB     31.8
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 16ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.53s    2.53s     0.396        0B     18.6
#> 2 fp(1e+07)      2.6s     2.6s     0.385     1.9KB     18.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 6.88ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     24.7s    24.7s    0.0405        0B     21.3
#> 2 fp(1e+08)     26.1s    26.1s    0.0384     1.9KB     19.9
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 13.7ns
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
#> 1 f0()         94.8ms    115ms      7.28     781KB    16.0 
#> 2 f01()       106.5ms    109ms      8.94     781KB    10.7 
#> 3 fp()        121.6ms    136ms      6.51     783KB     9.77
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 209ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  975.24ms 975.24ms     1.03     7.63MB     7.18
#> 2 f01(1e+06)    1.47s    1.47s     0.682    7.63MB     4.77
#> 3 fp(1e+06)     2.19s    2.19s     0.456    7.63MB     3.65
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.22µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 725ns
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
#> 1 f0()         80.6ms   94.3ms      9.98    1.44MB     6.65
#> 2 f01()       104.6ms  118.2ms      8.36   781.3KB     6.69
#> 3 fp()        132.6ms  156.9ms      5.92  783.26KB     5.92
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 626ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 387ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  988.75ms 988.75ms     1.01     7.63MB     2.02
#> 2 f01(1e+06)    1.12s    1.12s     0.895    7.63MB     1.79
#> 3 fp(1e+06)     1.27s    1.27s     0.784    7.63MB     2.35
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 287ns
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 158ns
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
#> 1 f0()         22.8ms  22.94ms    42.8      39.3KB     1.95
#> 2 fp()          4.35s    4.35s     0.230   100.8KB     1.84
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 43.2µs
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
#> 1 f0()        21.83ms  22.12ms    40.6      18.7KB     3.86
#> 2 ff()        31.92ms  32.18ms    28.7      27.6KB     1.91
#> 3 fp()          2.36s    2.36s     0.424    25.1KB     1.69
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 23.4µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 101ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   244.1ms  256.6ms    3.90          0B     3.90
#> 2 ff(1e+06)   350.9ms  352.8ms    2.83      1.91KB     2.83
#> 3 fp(1e+06)     25.1s    25.1s    0.0398    1.91KB     1.71
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 24.9µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 96.2ns
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
#> 1 test_baseline()   651.97ms 651.97ms     1.53     2.08KB        0
#> 2 test_modulo()        1.25s    1.25s     0.797    2.24KB        0
#> 3 test_cli()           1.25s    1.25s     0.803   24.11KB        0
#> 4 test_cli_unroll()  645.9ms  645.9ms     1.55     3.58KB        0
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
#> ■                                  0% | ETA: 43m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 36m
#> ■                                  0% | ETA: 34m
#> ■                                  0% | ETA: 32m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 28m
#> ■                                  0% | ETA: 27m
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
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.35ms  6.5ms      151.    1.41MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (468/s) | 3ms
#> ⠹ 2 done (59/s) | 35ms
#> ⠸ 3 done (70/s) | 43ms
#> ⠼ 4 done (78/s) | 52ms
#> ⠴ 5 done (85/s) | 60ms
#> ⠦ 6 done (90/s) | 67ms
#> ⠧ 7 done (94/s) | 75ms
#> ⠇ 8 done (97/s) | 83ms
#> ⠏ 9 done (100/s) | 91ms
#> ⠋ 10 done (102/s) | 98ms
#> ⠙ 11 done (105/s) | 106ms
#> ⠹ 12 done (106/s) | 113ms
#> ⠸ 13 done (108/s) | 121ms
#> ⠼ 14 done (110/s) | 128ms
#> ⠴ 15 done (111/s) | 136ms
#> ⠦ 16 done (112/s) | 144ms
#> ⠧ 17 done (113/s) | 152ms
#> ⠇ 18 done (113/s) | 160ms
#> ⠏ 19 done (114/s) | 167ms
#> ⠋ 20 done (112/s) | 179ms
#> ⠙ 21 done (113/s) | 187ms
#> ⠹ 22 done (114/s) | 194ms
#> ⠸ 23 done (114/s) | 202ms
#> ⠼ 24 done (115/s) | 209ms
#> ⠴ 25 done (116/s) | 217ms
#> ⠦ 26 done (116/s) | 224ms
#> ⠧ 27 done (117/s) | 232ms
#> ⠇ 28 done (117/s) | 240ms
#> ⠏ 29 done (118/s) | 247ms
#> ⠋ 30 done (118/s) | 255ms
#> ⠙ 31 done (118/s) | 263ms
#> ⠹ 32 done (119/s) | 270ms
#> ⠸ 33 done (119/s) | 278ms
#> ⠼ 34 done (119/s) | 286ms
#> ⠴ 35 done (120/s) | 293ms
#> ⠦ 36 done (120/s) | 301ms
#> ⠧ 37 done (120/s) | 308ms
#> ⠇ 38 done (121/s) | 316ms
#> ⠏ 39 done (121/s) | 323ms
#> ⠋ 40 done (121/s) | 331ms
#> ⠙ 41 done (121/s) | 338ms
#> ⠹ 42 done (122/s) | 346ms
#> ⠸ 43 done (122/s) | 353ms
#> ⠼ 44 done (122/s) | 361ms
#> ⠴ 45 done (122/s) | 368ms
#> ⠦ 46 done (123/s) | 376ms
#> ⠧ 47 done (123/s) | 383ms
#> ⠇ 48 done (123/s) | 391ms
#> ⠏ 49 done (123/s) | 398ms
#> ⠋ 50 done (123/s) | 406ms
#> ⠙ 51 done (124/s) | 413ms
#> ⠹ 52 done (124/s) | 421ms
#> ⠸ 53 done (124/s) | 428ms
#> ⠼ 54 done (124/s) | 436ms
#> ⠴ 55 done (124/s) | 443ms
#> ⠦ 56 done (124/s) | 451ms
#> ⠧ 57 done (125/s) | 458ms
#> ⠇ 58 done (125/s) | 466ms
#> ⠏ 59 done (125/s) | 473ms
#> ⠋ 60 done (125/s) | 481ms
#> ⠙ 61 done (125/s) | 489ms
#> ⠹ 62 done (125/s) | 497ms
#> ⠸ 63 done (125/s) | 504ms
#> ⠼ 64 done (125/s) | 513ms
#> ⠴ 65 done (125/s) | 521ms
#> ⠦ 66 done (125/s) | 529ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 7.35ms 7.57ms      131.     265KB     2.04
cli_progress_done()
```
