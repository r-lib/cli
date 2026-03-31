# xxHash

Extremely fast hash algorithm.

## Usage

``` r
hash_xxhash(x)

hash_raw_xxhash(x)

hash_obj_xxhash(x, serialize_version = 2)

hash_file_xxhash(paths)

hash_xxhash64(x)

hash_raw_xxhash64(x)

hash_obj_xxhash64(x, serialize_version = 2)

hash_file_xxhash64(paths)
```

## Arguments

- x:

  Character vector. If not a character vector, then
  [`as.character()`](https://rdrr.io/r/base/character.html) is used to
  try to coerce it into one. `NA` entries will have an `NA` hash.

- serialize_version:

  Workspace format version to use, see
  [`base::serialize()`](https://rdrr.io/r/base/serialize.html).

- paths:

  Character vector of file names.

## Value

`hash_xxhash()` returns a character vector of hexadecimal xxHash hashes.

`hash_raw_xxhash()` returns a character scalar.

`hash_obj_xxhash()` returns a character scalar.

`hash_file_xxhash()` returns a character vector of xxHash hashes.

## Details

`hash_raw_xxhash()` calculates the xxHash hash of the bytes of a raw
vector.

`hash_obj_xxhash()` calculates the xxHash hash of an R object. The
object is serialized into a binary vector first.

`hash_file_xxhash()` calculates the xxHash hash of one or more files.

The `64` functions calculate the 64 bit variant of xxHash. Otherwise
they work the same.

## See also

Other hash functions:
[`hash_animal()`](https://cli.r-lib.org/dev/reference/hash_animal.md),
[`hash_emoji()`](https://cli.r-lib.org/dev/reference/hash_emoji.md),
[`hash_md5()`](https://cli.r-lib.org/dev/reference/hash_md5.md),
[`hash_sha1()`](https://cli.r-lib.org/dev/reference/hash_sha1.md),
[`hash_sha256()`](https://cli.r-lib.org/dev/reference/hash_sha256.md)

## Examples

``` r
hash_xxhash(c("foo", NA, "bar", ""))
#> [1] "79aef92e83454121ab6e5f64077e7d8a"
#> [2] NA                                
#> [3] "950829dab2011f31d463c860a032d362"
#> [4] "99aa06d3014798d86001c324468d497f"
```
