# Emoji hash

Emoji hash

## Usage

``` r
hash_emoji(x, size = 3)

hash_raw_emoji(x, size = 3)

hash_obj_emoji(x, size = 3, serialize_version = 2)
```

## Arguments

- x:

  Character vector. `NA` entries will have an `NA` hash.

- size:

  Number of emojis to use in a hash. Currently it has to be from 1
  through 4.

- serialize_version:

  Workspace format version to use, see
  [`base::serialize()`](https://rdrr.io/r/base/serialize.html).

## Value

`hash_emoji()` returns a data frame with columns

- `hash`: the emoji hash, a string of the requested size.

- `emojis`: list column with the emoji characters in character vectors.
  Note that an emoji might have multiple code points.

- `text`: text representation of `hash`, comma separated.

- `names`: list column with the text representations of `emojis`, in
  character vectors.

`hash_raw_emoji()` and `hash_obj_emoji()` return a list with entries:

- `hash`: the emoji hash, a string of requested size,

- `emojis`: the individual emoji characters in a character vector,

- `text`: text representation of `hash`, comma separated,

- `names`: names of the emojis, in a character vector.

## Details

It uses the first 13 hexadecimal characters (out of the 32) of the MD5
hash of the input, and converts them into an emoji representation. It
uses a manually selected subset of all emojis, that tend to be displayed
correctly.

### Number of possible hash values

cli uses 2280 possible emojis. This is the number of different hashes
you can get for different values of `size`:

|        |                          |
|--------|--------------------------|
| `size` | size of hash table space |
| 1      | 2,280                    |
| 2      | 5,198,400                |
| 3      | 11,852,352,000           |
| 4      | 27,023,362,560,000       |

`hash_raw_emoji()` calculates the emoji hash of the bytes of a raw
vector.

`hash_obj_emoji()` calculates the emoji hash of an R object. The object
is serialized into a binary vector first.

## See also

the emoji package for a comprehensive list of emojis

Other hash functions:
[`hash_animal()`](https://cli.r-lib.org/dev/reference/hash_animal.md),
[`hash_md5()`](https://cli.r-lib.org/dev/reference/hash_md5.md),
[`hash_sha1()`](https://cli.r-lib.org/dev/reference/hash_sha1.md),
[`hash_sha256()`](https://cli.r-lib.org/dev/reference/hash_sha256.md),
[`hash_xxhash()`](https://cli.r-lib.org/dev/reference/hash_xxhash.md)

## Examples

``` r
hash_emoji(c("foo", NA, "bar", ""))$text
#> [1] "sun behind cloud, raised back of hand: dark skin tone, children crossing"
#> [2] NA                                                                        
#> [3] "man pilot: medium-light skin tone, flag: Afghanistan, keycap: *"         
#> [4] "teacup without handle, rhinoceros, flushed face"                         

# if you increase `size`, the shorter hash is a prefix of the longer:
hash_emoji("foobar", 1)$text
#> [1] "fishing pole"
hash_emoji("foobar", 2)$text
#> [1] "fishing pole, money with wings"
hash_emoji("foobar", 3)$text
#> [1] "fishing pole, money with wings, eagle"
hash_emoji("foobar", 4)$text
#> [1] "fishing pole, money with wings, eagle, dog face"
```
