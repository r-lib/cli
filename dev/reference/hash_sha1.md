# SHA-1 hash

Calculate the SHA-1 hash of each element of a character vector.

## Usage

``` r
hash_sha1(x)

hash_raw_sha1(x)

hash_obj_sha1(x, serialize_version = 2)

hash_file_sha1(paths)
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

`hash_sha1()` returns a character vector of hexadecimal SHA-1 hashes.

`hash_raw_sha1()` returns a character scalar.

`hash_obj_sha1()` returns a character scalar.

`hash_file_sha1()` returns a character vector of SHA-1 hashes.

## Details

`hash_raw_sha1()` calculates the SHA-1 hash of the bytes of a raw
vector.

`hash_obj_sha1()` calculates the SHA-1 hash of an R object. The object
is serialized into a binary vector first.

`hash_file_sha1()` calculates the SHA-1 hash of one or more files.

## See also

Other hash functions:
[`hash_animal()`](https://cli.r-lib.org/dev/reference/hash_animal.md),
[`hash_emoji()`](https://cli.r-lib.org/dev/reference/hash_emoji.md),
[`hash_md5()`](https://cli.r-lib.org/dev/reference/hash_md5.md),
[`hash_sha256()`](https://cli.r-lib.org/dev/reference/hash_sha256.md),
[`hash_xxhash()`](https://cli.r-lib.org/dev/reference/hash_xxhash.md)

## Examples

``` r
hash_sha1(c("foo", NA, "bar", ""))
#> [1] "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"
#> [2] NA                                        
#> [3] "62cdb7020ff920e5aa642c3d4066950dd1f01f4d"
#> [4] "da39a3ee5e6b4b0d3255bfef95601890afd80709"
```
