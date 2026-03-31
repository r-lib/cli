# Working around the bad Unicode character widths

R 3.6.2 and also the coming 3.6.3 and 4.0.0 versions use the Unicode 8
standard to calculate the display width of Unicode characters.
Unfortunately the widths of most emojis are incorrect in this standard,
and width 1 is reported instead of the correct 2 value.

## Details

cli implements a workaround for this. The package contains a table that
contains all Unicode ranges that have wide characters (display width 2).

On first use of one of the workaround wrappers (in
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
etc.) we check what the current version of R thinks about the width of
these characters, and then create a regex that matches the ones that R
is wrong about (`re_bad_char_width`).

Then we use this regex to duplicate all of the problematic characters in
the input string to the wrapper function, before calling the real string
manipulation function ([`nchar()`](https://rdrr.io/r/base/nchar.html),
[`strwrap()`](https://rdrr.io/r/base/strwrap.html)) etc. At end we undo
the duplication before we return the result.

This workaround is fine for
[`nchar()`](https://rdrr.io/r/base/nchar.html) and
[`strwrap()`](https://rdrr.io/r/base/strwrap.html), and consequently
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md) and
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md)
as well.

The rest of the `ansi_*()` functions work on characters, and do not deal
with character width.
