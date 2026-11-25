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
#> 1 __cli_update_due         8.96ns     15ns 65239101.        0B        0
#> 2 fun()                     100ns    111ns  5325121.        0B        0
#> 3 .Call(ccli_tick_reset)  98.02ns    110ns  8543842.        0B        0
#> 4 interactive()           11.99ns     18ns 52930092.        0B        0
```

``` r

ben_st2 <- bench::mark(
  if (`__cli_update_due`) foobar()
)
ben_st2
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 if (`__cli_update_due`) f… 36.1ns 44.1ns 20888339.        0B        0
```

### `cli_progress_along()`

``` r

seq <- 1:100000
ta <- cli_progress_along(seq)
bench::mark(seq[[1]], ta[[1]])
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 seq[[1]]     94.1ns    104ns  8637410.        0B        0
#> 2 ta[[1]]        97ns    113ns  7751587.        0B        0
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
#> 1 f0()         22.6ms   22.7ms      44.1    21.6KB     375.
#> 2 fp()         25.1ms   25.1ms      39.8    82.5KB     318.
(ben_taf$median[2] - ben_taf$median[1]) / 1e5
#> [1] 24.7ns
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
#> 2 fp(1e+06)     271ms    274ms      3.65     1.9KB     32.9
(ben_taf2$median[2] - ben_taf2$median[1]) / 1e6
#> [1] 20.8ns
```

``` r

ben_taf3 <- bench::mark(f0(1e7), fp(1e7))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf3
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+07)     2.48s    2.48s     0.403        0B     18.9
#> 2 fp(1e+07)     2.54s    2.54s     0.394     1.9KB     18.1
(ben_taf3$median[2] - ben_taf3$median[1]) / 1e7
#> [1] 5.58ns
```

``` r

ben_taf4 <- bench::mark(f0(1e8), fp(1e8))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_taf4
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+08)     24.1s    24.1s    0.0416        0B     21.6
#> 2 fp(1e+08)     25.7s    25.7s    0.0388     1.9KB     19.8
(ben_taf4$median[2] - ben_taf4$median[1]) / 1e8
#> [1] 16.9ns
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
#> 1 f0()         86.5ms    101ms      9.02     781KB    21.6 
#> 2 f01()        95.1ms    102ms      7.05     781KB     8.81
#> 3 fp()        101.1ms    112ms      6.73     783KB    10.8
(ben_tam$median[3] - ben_tam$median[1]) / 1e5
#> [1] 105ns
```

``` r

ben_tam2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_tam2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  871.67ms 871.67ms     1.15     7.63MB     6.88
#> 2 f01(1e+06)    1.35s    1.35s     0.740    7.63MB     5.92
#> 3 fp(1e+06)     2.12s    2.12s     0.472    7.63MB     2.36
(ben_tam2$median[3] - ben_tam2$median[1]) / 1e6
#> [1] 1.25µs
(ben_tam2$median[3] - ben_tam2$median[2]) / 1e6
#> [1] 766ns
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
#> 1 f0()         67.2ms   67.7ms      14.6    1.44MB     4.86
#> 2 f01()        77.6ms   79.8ms      12.4   781.3KB     6.22
#> 3 fp()           80ms   81.6ms      11.8  783.26KB    11.8
(ben_pur$median[3] - ben_pur$median[1]) / 1e5
#> [1] 139ns
(ben_pur$median[3] - ben_pur$median[2]) / 1e5
#> [1] 17.7ns
```

``` r

ben_pur2 <- bench::mark(f0(1e6), f01(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_pur2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)  870.94ms 870.94ms     1.15     7.63MB     3.44
#> 2 f01(1e+06)    1.03s    1.03s     0.971    7.63MB     2.91
#> 3 fp(1e+06)     2.64s    2.64s     0.379    7.63MB     1.89
(ben_pur2$median[3] - ben_pur2$median[1]) / 1e6
#> [1] 1.77µs
(ben_pur2$median[3] - ben_pur2$median[2]) / 1e6
#> [1] 1.61µs
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
#> 1 f0()        22.77ms  23.03ms    42.4      39.3KB     3.85
#> 2 fp()          3.52s    3.52s     0.284   100.8KB     2.84
(ben_tk$median[2] - ben_tk$median[1]) / 1e5
#> [1] 35µs
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
#> 1 f0()        21.41ms  21.83ms    42.5      18.7KB     5.80
#> 2 ff()        32.51ms  32.96ms    29.7      27.6KB     1.98
#> 3 fp()          1.93s    1.93s     0.519    25.1KB     3.11
(ben_api$median[3] - ben_api$median[1]) / 1e5
#> [1] 19.1µs
(ben_api$median[2] - ben_api$median[1]) / 1e5
#> [1] 111ns
```

``` r

ben_api2 <- bench::mark(f0(1e6), ff(1e6), fp(1e6))
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
ben_api2
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 f0(1e+06)   232.1ms    235ms    4.24          0B    5.65 
#> 2 ff(1e+06)     338ms       1s    0.995     1.91KB    0.995
#> 3 fp(1e+06)     18.8s    18.8s    0.0533    1.91KB    3.04
(ben_api2$median[3] - ben_api2$median[1]) / 1e6
#> [1] 18.5µs
(ben_api2$median[2] - ben_api2$median[1]) / 1e6
#> [1] 770ns
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
#> 1 test_baseline()   121.35ms 123.57ms     8.12     2.08KB        0
#> 2 test_modulo()        1.36s    1.36s     0.736    2.24KB        0
#> 3 test_cli()        978.38ms 978.38ms     1.02    24.11KB        0
#> 4 test_cli_unroll() 124.41ms 124.62ms     8.01     3.58KB        0
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
#> ■                                  0% | ETA: 44m
#> ■                                  0% | ETA: 39m
#> ■                                  0% | ETA: 35m
#> ■                                  0% | ETA: 33m
#> ■                                  0% | ETA: 30m
#> ■                                  0% | ETA: 29m
#> ■                                  0% | ETA: 27m
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
#> 1 cli_progress_update(force… 5.92ms 6.16ms      159.    1.44MB     2.04
cli_progress_done()
```

### Iterator without a bar

``` r

cli_progress_bar(total = NA)
bench::mark(cli_progress_update(force = TRUE), max_iterations = 10000)
#> ⠙ 1 done (468/s) | 3ms
#> ⠹ 2 done (69/s) | 30ms
#> ⠸ 3 done (75/s) | 41ms
#> ⠼ 4 done (85/s) | 48ms
#> ⠴ 5 done (93/s) | 54ms
#> ⠦ 6 done (99/s) | 61ms
#> ⠧ 7 done (104/s) | 68ms
#> ⠇ 8 done (107/s) | 75ms
#> ⠏ 9 done (110/s) | 82ms
#> ⠋ 10 done (113/s) | 89ms
#> ⠙ 11 done (115/s) | 97ms
#> ⠹ 12 done (116/s) | 104ms
#> ⠸ 13 done (118/s) | 111ms
#> ⠼ 14 done (119/s) | 118ms
#> ⠴ 15 done (121/s) | 125ms
#> ⠦ 16 done (122/s) | 132ms
#> ⠧ 17 done (123/s) | 139ms
#> ⠇ 18 done (124/s) | 146ms
#> ⠏ 19 done (124/s) | 153ms
#> ⠋ 20 done (125/s) | 160ms
#> ⠙ 21 done (126/s) | 168ms
#> ⠹ 22 done (126/s) | 175ms
#> ⠸ 23 done (127/s) | 182ms
#> ⠼ 24 done (128/s) | 189ms
#> ⠴ 25 done (128/s) | 196ms
#> ⠦ 26 done (129/s) | 203ms
#> ⠧ 27 done (129/s) | 210ms
#> ⠇ 28 done (129/s) | 217ms
#> ⠏ 29 done (130/s) | 224ms
#> ⠋ 30 done (130/s) | 231ms
#> ⠙ 31 done (131/s) | 238ms
#> ⠹ 32 done (131/s) | 245ms
#> ⠸ 33 done (131/s) | 252ms
#> ⠼ 34 done (131/s) | 259ms
#> ⠴ 35 done (132/s) | 266ms
#> ⠦ 36 done (132/s) | 274ms
#> ⠧ 37 done (132/s) | 281ms
#> ⠇ 38 done (132/s) | 288ms
#> ⠏ 39 done (133/s) | 295ms
#> ⠋ 40 done (133/s) | 302ms
#> ⠙ 41 done (133/s) | 309ms
#> ⠹ 42 done (133/s) | 316ms
#> ⠸ 43 done (133/s) | 323ms
#> ⠼ 44 done (134/s) | 330ms
#> ⠴ 45 done (134/s) | 337ms
#> ⠦ 46 done (134/s) | 344ms
#> ⠧ 47 done (134/s) | 351ms
#> ⠇ 48 done (134/s) | 358ms
#> ⠏ 49 done (135/s) | 365ms
#> ⠋ 50 done (135/s) | 372ms
#> ⠙ 51 done (135/s) | 379ms
#> ⠹ 52 done (135/s) | 386ms
#> ⠸ 53 done (135/s) | 392ms
#> ⠼ 54 done (135/s) | 400ms
#> ⠴ 55 done (135/s) | 407ms
#> ⠦ 56 done (136/s) | 414ms
#> ⠧ 57 done (136/s) | 421ms
#> ⠇ 58 done (136/s) | 428ms
#> ⠏ 59 done (136/s) | 435ms
#> ⠋ 60 done (136/s) | 441ms
#> ⠙ 61 done (136/s) | 448ms
#> ⠹ 62 done (136/s) | 456ms
#> ⠸ 63 done (136/s) | 463ms
#> ⠼ 64 done (136/s) | 473ms
#> ⠴ 65 done (136/s) | 479ms
#> ⠦ 66 done (136/s) | 486ms
#> ⠧ 67 done (136/s) | 493ms
#> ⠇ 68 done (136/s) | 500ms
#> ⠏ 69 done (136/s) | 507ms
#> ⠋ 70 done (136/s) | 514ms
#> ⠙ 71 done (136/s) | 521ms
#> ⠹ 72 done (136/s) | 528ms
#> # A tibble: 1 × 6
#>   expression                    min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                 <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 cli_progress_update(force… 6.71ms 7.02ms      143.     265KB     4.14
cli_progress_done()
```
