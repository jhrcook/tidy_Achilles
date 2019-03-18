
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Tidy Project Achilles Data

**author: Joshua H. Cook**

**last updated: March 15, 2019**

This is “tidy” data from the Broad’s [Project
Achilles](https://depmap.org/portal/achilles/) with a focus of the
various *RAS* alleles. The data files are in the “data” directory and
exaplined below.

``` r
library(tidyverse)
```

To download this repository, run the following command on the command
line.

``` bash
git clone https://github.com/jhrcook/tidy_Achilles.git
```

-----

## Raw Data

### DepMap-2019q1-celllines\_v2.csv

Information on cell lines from the Broad’s [Cancer Cell Line
Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle). The tidy
data is available in “cell\_line\_metadata.tib”.

### depmap\_19Q1\_mutation\_calls.csv

Mutation data on the cell lines from the Broad’s [Cancer Cell Line
Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle). The tidy
data is available in “cell\_line\_mutations.tib”.

To access the file, decompress it with a GUI tools (usually double-click
on Mac works) or use the command line.

``` bash
gunzip depmap_19Q1_mutation_calls.csv.gz
```

### D2\_combined\_gene\_dep\_scores.csv

The “dependency scores” calculated by the Achilles Project. This file is
organized by target name in the first column and the following columns
are the scores for each cell line. The tidy data is available in
“synthetic\_lethal.tib”.

To access the file, decompress it with a GUI tools (usually double-click
on Mac works) or use the command line.

``` bash
gunzip D2_combined_gene_dep_scores.csv.gz
```

-----

## Tidy Data Tables

All processing was done in “data\_preparation.R”. The tidy data were
stored as “tibbles” (`tbl_df`, instead of R’s standard data.frame
object) in RDS files. They can all be read directly into R.

``` r
library(tibble)
readRDS("data/example_data_table.tib")
```

More inforamtion in the “tidy data” format can be found in [*R for Data
Science - Tidy data*](https://r4ds.had.co.nz/tidy-data.html).

### cell\_line\_metadata.tib

The information for each cell line from the Broad’s [Cancer Cell Line
Encyclopedia
(CCLE)](https://portals.broadinstitute.org/ccle).

``` r
cell_line_metadata <- readRDS(file.path("data", "cell_line_metadata.tib"))
head(cell_line_metadata)
#> # A tibble: 6 x 9
#>   DepMap_ID CCLE_Name Aliases COSMIC_ID Sanger_ID Primary_Disease
#>   <chr>     <chr>     <chr>       <dbl>     <dbl> <chr>          
#> 1 ACH-0000… NIHOVCAR… NIH:OV…    905933      2201 Ovarian Cancer 
#> 2 ACH-0000… HL60_HAE… HL-60      905938        55 Leukemia       
#> 3 ACH-0000… CACO2_LA… CACO2;…        NA        NA Colon/Colorect…
#> 4 ACH-0000… HEL_HAEM… HEL        907053       783 Leukemia       
#> 5 ACH-0000… HEL9217_… HEL 92…        NA        NA Leukemia       
#> 6 ACH-0000… MONOMAC6… MONO-M…    908148      2167 Leukemia       
#> # … with 3 more variables: Subtype_Disease <chr>, Gender <chr>,
#> #   Source <chr>
```

1.  **DepMap\_ID** - ID for Dependancy Map project
2.  **CCLE\_Name** - name from the [Cancer Cell Line Encyclopedia
    (CCLE)](https://portals.broadinstitute.org/ccle)
3.  **Aliases** - other names
4.  **COSMIC\_ID** - [COSMIC](https://cancer.sanger.ac.uk/cosmic) ID
5.  **Sanger\_ID** - Sanger ID
6.  **Primary\_Disease** - general disease of the cell line
7.  **Subtype\_Disease** - more specific disease of the cell line
8.  **Gender** - sex (if known) of the patient
9.  **Source** - source of the cell line

### cell\_line\_ras\_anno.tib

The cell line information with the status of the RAS isoforms. If they
are all wild-type, then the `ras` and `allele` columns will both be
`"WT"`. If a cell line has multiple RAS mutations, each one is a
separate
row.

``` r
cell_line_ras_anno <- readRDS(file.path("data", "cell_line_ras_anno.tib"))
head(cell_line_ras_anno)
#> # A tibble: 6 x 12
#>   DepMap_ID CCLE_Name Aliases COSMIC_ID Sanger_ID Primary_Disease
#>   <chr>     <chr>     <chr>       <dbl>     <dbl> <chr>          
#> 1 ACH-0000… NIHOVCAR… NIH:OV…    905933      2201 Ovarian Cancer 
#> 2 ACH-0000… HL60_HAE… HL-60      905938        55 Leukemia       
#> 3 ACH-0000… CACO2_LA… CACO2;…        NA        NA Colon/Colorect…
#> 4 ACH-0000… HEL_HAEM… HEL        907053       783 Leukemia       
#> 5 ACH-0000… HEL9217_… HEL 92…        NA        NA Leukemia       
#> 6 ACH-0000… MONOMAC6… MONO-M…    908148      2167 Leukemia       
#> # … with 6 more variables: Subtype_Disease <chr>, Gender <chr>,
#> #   Source <chr>, ras <chr>, allele <chr>, ras_allele <chr>
```

1.  **DepMap\_ID** through 9. **Source** - same as for
    “cell\_line\_metadata.tib”
2.  **ras** - *RAS* isoform; `"WT"` means all are wild-type
3.  **allele** - mutant *RAS* allele; `"WT"` means all *RAS* isoforms
    are wild-type
4.  **ras\_allele** - catentation of `ras` and `allele` columns

### ras\_muts\_annotated.tib

The *RAS* mutant cell lines. This if the same data as in
“cell\_line\_ras\_anno.tib”, but only *RAS* mutants. The columns are
in a different order, but hold the same
data.

``` r
ras_muts_annotated <- readRDS(file.path("data", "ras_muts_annotated.tib"))
head(ras_muts_annotated)
#> # A tibble: 6 x 12
#>   DepMap_ID ras   allele ras_allele CCLE_Name Aliases COSMIC_ID Sanger_ID
#>   <chr>     <chr> <chr>  <chr>      <chr>     <chr>       <dbl>     <dbl>
#> 1 ACH-0000… NRAS  Q61L   NRAS_Q61L  HL60_HAE… HL-60      905938        55
#> 2 ACH-0000… KRAS  G12D   KRAS_G12D  LS513_LA… LS513      907795       569
#> 3 ACH-0000… HRAS  G12V   HRAS_G12V  T24_URIN… T24        724812      1455
#> 4 ACH-0000… KRAS  G12V   KRAS_G12V  PATU8988… PA-TU-…        NA        NA
#> 5 ACH-0000… KRAS  G12V   KRAS_G12V  PATU8988… PA-TU-…   1240201      1242
#> 6 ACH-0000… NRAS  Q61K   NRAS_Q61K  CH157MN_… CH-157…        NA        NA
#> # … with 4 more variables: Primary_Disease <chr>, Subtype_Disease <chr>,
#> #   Gender <chr>, Source <chr>
```

### synthetic\_lethal

I had to split up the synthetic lethal data by tissue so that each data
file was small enough to push to GitHub. These are stored in
“data/synthetic\_lethal/”. All or a selection of them can be loaded
using `load_all_synthetic_lethal`. It returns a single tibble of the
desired data.

``` r
load_all_synthetic_lethal <- function(tissues = "all") {
    tissues <- paste0(tissues, collapse = "|")
    synlet_path <- file.path("data", "synthetic_lethal")
    synlet_files <- list.files(synlet_path, full.name = TRUE,
                               pattern = "_syn_lethal.tib")
    if (tissues != "all") {
        synlet_files <-  stringr::str_subset(synlet_files, tissues)
    }
    synlet <- purrr::map(synlet_files, readRDS) %>% bind_rows()
    return(synlet)
}
```

A specific selection of tissues can be loaded by passing a vector of the
tissue names (from the file names).

``` r
cervix_synlet <- load_all_synthetic_lethal(c("CERVIX", "BONE"))
cervix_synlet
#> # A tibble: 328,871 x 15
#>    gene  cell_line    score DepMap_ID Aliases COSMIC_ID Sanger_ID
#>    <chr> <chr>        <dbl> <chr>     <chr>       <dbl>     <dbl>
#>  1 A1BG  143B_BONE  0.146   ACH-0010… <NA>           NA        NA
#>  2 NAT2  143B_BONE  0.103   ACH-0010… <NA>           NA        NA
#>  3 ADA   143B_BONE  0.169   ACH-0010… <NA>           NA        NA
#>  4 CDH2  143B_BONE  0.0630  ACH-0010… <NA>           NA        NA
#>  5 AKT3  143B_BONE -0.00808 ACH-0010… <NA>           NA        NA
#>  6 MED6  143B_BONE -0.214   ACH-0010… <NA>           NA        NA
#>  7 NR2E3 143B_BONE -0.154   ACH-0010… <NA>           NA        NA
#>  8 NAAL… 143B_BONE  0.134   ACH-0010… <NA>           NA        NA
#>  9 DUXB  143B_BONE  0.139   ACH-0010… <NA>           NA        NA
#> 10 PDZK… 143B_BONE  0.0303  ACH-0010… <NA>           NA        NA
#> # … with 328,861 more rows, and 8 more variables: Primary_Disease <chr>,
#> #   Subtype_Disease <chr>, Gender <chr>, Source <chr>, ras <chr>,
#> #   allele <chr>, ras_allele <chr>, tissue <chr>
```

Or all tissues can be gathered by not passing anything.

``` r
synthetic_lethal <- load_all_synthetic_lethal()
```

-----

## Graphs

### ras\_dependency\_graph.gr
