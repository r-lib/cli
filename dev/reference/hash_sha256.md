# SHA-256 hash

Calculate the SHA-256 hash of each element of a character vector.

## Usage

``` r
hash_sha256(x)

hash_raw_sha256(x)

hash_obj_sha256(x, serialize_version = 2)

hash_file_sha256(paths)
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

`hash_sha256()` returns a character vector of hexadecimal SHA-256
hashes.

`hash_raw_sha256()` returns a character scalar.

`hash_obj_sha256()` returns a character scalar.

`hash_file_sha256()` returns a character vector of SHA-256 hashes.

## Details

`hash_raw_sha256()` calculates the SHA-256 hash of the bytes of a raw
vector.

`hash_obj_sha256()` calculates the SHA-256 hash of an R object. The
object is serialized into a binary vector first.

`hash_file_sha256()` calculates the SHA-256 hash of one or more files.

## See also

Other hash functions:
[`hash_animal()`](https://cli.r-lib.org/dev/reference/hash_animal.md),
[`hash_emoji()`](https://cli.r-lib.org/dev/reference/hash_emoji.md),
[`hash_md5()`](https://cli.r-lib.org/dev/reference/hash_md5.md),
[`hash_sha1()`](https://cli.r-lib.org/dev/reference/hash_sha1.md),
[`hash_xxhash()`](https://cli.r-lib.org/dev/reference/hash_xxhash.md)

## Examples

``` r
hash_sha256(c("foo", NA, "bar", ""))
#> [1] "2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae"
#> [2] NA                                                                
#> [3] "fcde2b2edba56bf408601fb721fe9b5c338d10ee429ea04fae5511b68fbf8fb9"
#> [4] "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
```
