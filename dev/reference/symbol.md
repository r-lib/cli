# Various handy symbols to use in a command line UI

Various handy symbols to use in a command line UI

## Usage

``` r
symbol

list_symbols()
```

## Format

A named list, see `names(symbol)` for all sign names.

## Details

On Windows they have a fallback to less fancy symbols.

`list_symbols()` prints a table with all symbols to the screen.

## Examples

``` r
cat(symbol$tick, " SUCCESS\n", symbol$cross, " FAILURE\n", sep = "")
#> ✔ SUCCESS
#> ✖ FAILURE

## All symbols
cat(paste(format(names(symbol), width = 20),
  unlist(symbol)), sep = "\n")
#> tick                 ✔
#> cross                ✖
#> star                 ★
#> square               ▇
#> square_small         ◻
#> square_small_filled  ◼
#> circle               ◯
#> circle_filled        ◉
#> circle_dotted        ◌
#> circle_double        ◎
#> circle_circle        ⓞ
#> circle_cross         ⓧ
#> circle_pipe          Ⓘ
#> circle_question_mark ?⃝
#> bullet               •
#> dot                  ․
#> line                 ─
#> double_line          ═
#> ellipsis             …
#> continue             …
#> pointer              ❯
#> info                 ℹ
#> warning              ⚠
#> menu                 ☰
#> smiley               ☺
#> mustache             ෴
#> heart                ♥
#> arrow_up             ↑
#> arrow_down           ↓
#> arrow_left           ←
#> arrow_right          →
#> radio_on             ◉
#> radio_off            ◯
#> checkbox_on          ☒
#> checkbox_off         ☐
#> checkbox_circle_on   ⓧ
#> checkbox_circle_off  Ⓘ
#> fancy_question_mark  ❓
#> neq                  ≠
#> geq                  ≥
#> leq                  ≤
#> times                ×
#> upper_block_1        ▔
#> upper_block_4        ▀
#> lower_block_1        ▁
#> lower_block_2        ▂
#> lower_block_3        ▃
#> lower_block_4        ▄
#> lower_block_5        ▅
#> lower_block_6        ▆
#> lower_block_7        ▇
#> lower_block_8        █
#> full_block           █
#> sup_0                ⁰
#> sup_1                ¹
#> sup_2                ²
#> sup_3                ³
#> sup_4                ⁴
#> sup_5                ⁵
#> sup_6                ⁶
#> sup_7                ⁷
#> sup_8                ⁸
#> sup_9                ⁹
#> sup_minus            ⁻
#> sup_plus             ⁺
#> play                 ▶
#> stop                 ■
#> record               ●
#> figure_dash          ‒
#> en_dash              –
#> em_dash              —
#> dquote_left          “
#> dquote_right         ”
#> squote_left          ‘
#> squote_right         ’
```
