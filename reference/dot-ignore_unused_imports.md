# Force R CMD CHECK to treat packages as imported.

Force R CMD CHECK to treat packages as imported.

## Usage

``` r
.ignore_unused_imports()
```

## Value

Nothing

## Note

This allows us to force dependencies to be considered in the package
(particularly necessary with R6 classes).
