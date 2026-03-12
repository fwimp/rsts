# Colour text in an character-based theme.

Colour text in an character-based theme.

## Usage

``` r
col_character(char, text = NULL)
```

## Arguments

- char:

  The character colour to use.

- text:

  The text to theme (or `NULL` if you just want to use "char").

## Value

A defect-themed colour function.

## Examples

``` r
col_character("Ironclad")
#> <cli_ansi_string>
#> [1] Ironclad
col_character("Silent", "Other text")
#> <cli_ansi_string>
#> [1] Other text
```
