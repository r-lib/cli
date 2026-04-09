# Adjective-animal hash

Adjective-animal hash

## Usage

``` r
hash_animal(x, n_adj = 2)

hash_raw_animal(x, n_adj = 2)

hash_obj_animal(x, n_adj = 2, serialize_version = 2)
```

## Arguments

- x:

  Character vector. `NA` entries will have an `NA` hash.

- n_adj:

  Number of adjectives to use. It must be from 0 through 3.

- serialize_version:

  Workspace format version to use, see
  [`base::serialize()`](https://rdrr.io/r/base/serialize.html).

## Value

A data frame with columns

- `hash`: the hash value, a string.

- `words`: list column with the adjectives and the animal name in a
  character vector.

`hash_raw_animal()` and `hash_obj_animal()` return a list with entries:

- `hash`: the hash value, a string,

- \`words: the adjectives and the animal name in a character vector.

## Details

It uses the first 13 hexadecimal characters (out of the 32) of the MD5
hash of the input, and converts them into an adjective-animal form to
create a human readable hash.

### Number of possible hash values

`hash_animal()` uses 1748 animal names and 8946 different adjectives.
The number of different hashes you can get for different values of
`n_adj`:

|         |                              |
|---------|------------------------------|
| `n_adj` | size of the hash table space |
| 0       | 1,748                        |
| 1       | 15,637,608                   |
| 2       | 139,894,041,168              |
| 3       | 1,251,492,092,288,928        |

### Source

The list of adjectives and animals comes from the ids package, and in
turn from <https://github.com/a-type/adjective-adjective-animal>, and
from `https://gfycat.com` (now gone).

`hash_raw_animal()` calculates the adjective-animal hash of the bytes of
a raw vector.

`hash_obj_animal()` calculates the adjective-animal hash of an R object.
The object is serialized into a binary vector first.

## See also

the ids package for generating random adjective-animal ids

Other hash functions:
[`hash_emoji()`](https://cli.r-lib.org/reference/hash_emoji.md),
[`hash_md5()`](https://cli.r-lib.org/reference/hash_md5.md),
[`hash_sha1()`](https://cli.r-lib.org/reference/hash_sha1.md),
[`hash_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md),
[`hash_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)

## Examples

``` r
hash_animal(c("foo", "bar"))
#>                                       hash        words
#> 1                   sacrilegious diet lion sacrileg....
#> 2 uncitizenly agricultural amethystgemclam uncitize....

# if you increase `n_adj`, the shorter hash is a suffix of the longer:
hash_animal("cli package", 0)$hash
#> [1] "pullet"
hash_animal("cli package", 1)$hash
#> [1] "pastyfaced pullet"
hash_animal("cli package", 2)$hash
#> [1] "pregnant pastyfaced pullet"
hash_animal("cli package", 3)$hash
#> [1] "unwelcome pregnant pastyfaced pullet"
```
