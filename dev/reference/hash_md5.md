# MD5 hash

Calculate the MD5 hash of each element of a character vector.

## Usage

``` r
hash_md5(x)

hash_raw_md5(x)

hash_obj_md5(x, serialize_version = 2)

hash_file_md5(paths)
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

`hash_md5()` returns a character vector of hexadecimal MD5 hashes.

`hash_raw_md5()` returns a character scalar.

`hash_obj_md5()` returns a character scalar.

## Details

`hash_raw_md5()` calculates the MD5 hash of the bytes of a raw vector.

`hash_obj_md5()` calculates the MD5 hash of an R object. The object is
serialized into a binary vector first.

`hash_file_md5()` calculates the MD5 hash of one or more files.

## See also

[`tools::md5sum()`](https://rdrr.io/r/tools/md5sum.html) for a base R
MD5 function that works on files.

Other hash functions:
[`hash_animal()`](https://cli.r-lib.org/dev/reference/hash_animal.md),
[`hash_emoji()`](https://cli.r-lib.org/dev/reference/hash_emoji.md),
[`hash_sha1()`](https://cli.r-lib.org/dev/reference/hash_sha1.md),
[`hash_sha256()`](https://cli.r-lib.org/dev/reference/hash_sha256.md),
[`hash_xxhash()`](https://cli.r-lib.org/dev/reference/hash_xxhash.md)

## Examples

``` r
hash_md5(c("foo", NA, "bar", ""))
#> [1] "acbd18db4cc2f85cedef654fccc4a4d8"
#> [2] NA                                
#> [3] "37b51d194a7513e45b56f6524f2d51f2"
#> [4] "d41d8cd98f00b204e9800998ecf8427e"
```
