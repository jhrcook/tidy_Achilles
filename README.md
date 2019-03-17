---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# "Tidy Project Achilles Data"

**author: Joshua H Cook**

**last updated: March 15, 2019**

This is "tidy" data from the Broad's [Project Achilles](https://depmap.org/portal/achilles/) with a focus of the various *RAS* alleles. The data files are in the "data" directory and exaplined below.


```r
library(tidyverse)
```

To download this repository,

# TODO:

## Raw Data

### DepMap-2019q1-celllines_v2.csv

Information on cell lines from the Broad's [Cancer Cell Line Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle). The tidy data is available in "cell_line_metadata.tib".

### depmap_19Q1_mutation_calls.csv

Mutation data on the cell lines from the Broad's [Cancer Cell Line Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle). The tidy data is available in "cell_line_mutations.tib".

### D2_combined_gene_dep_scores.csv

The "dependency scores" calculated by the Achilles Project. This file is organized by target name in the first column and the following columns are the scores for each cell line. The tidy data is available in "synthetic_lethal.tib".


## Tidy Data Tables

All processing was done in "data_preparation.R". The tidy data were stored as "tibbles" (`tbl_df`, instead of R's standard data.frame object) in RDS files. They can all be read directly into R.


```r
library(tibble)
readRDS("data/example_data_table.tib")
```

More inforamtion in the "tidy data" format can be found in [*R for Data Science - Tidy data*](https://r4ds.had.co.nz/tidy-data.html). 

### cell_line_metadata.tib

The information for each cell line from the Broad's [Cancer Cell Line Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle).


```r
cell_line_metadata <- readRDS(file.path("data", "cell_line_metadata.tib"))
head(cell_line_metadata)
```

```
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

<div style="border: 1px solid #ddd; padding: 5px; overflow-y: scroll; height:300px; overflow-x: scroll; width:100%; "><table>
 <thead>
  <tr>
   <th style="text-align:left;"> DepMap_ID </th>
   <th style="text-align:left;"> CCLE_Name </th>
   <th style="text-align:left;"> Aliases </th>
   <th style="text-align:right;"> COSMIC_ID </th>
   <th style="text-align:right;"> Sanger_ID </th>
   <th style="text-align:left;"> Primary_Disease </th>
   <th style="text-align:left;"> Subtype_Disease </th>
   <th style="text-align:left;"> Gender </th>
   <th style="text-align:left;"> Source </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ACH-000001 </td>
   <td style="text-align:left;"> NIHOVCAR3_OVARY </td>
   <td style="text-align:left;"> NIH:OVCAR-3;OVCAR3 </td>
   <td style="text-align:right;"> 905933 </td>
   <td style="text-align:right;"> 2201 </td>
   <td style="text-align:left;"> Ovarian Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma, high grade serous </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000002 </td>
   <td style="text-align:left;"> HL60_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> HL-60 </td>
   <td style="text-align:right;"> 905938 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML), M3 (Promyelocytic) </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000003 </td>
   <td style="text-align:left;"> CACO2_LARGE_INTESTINE </td>
   <td style="text-align:left;"> CACO2;CACO2;CaCo-2 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Colon/Colorectal Cancer </td>
   <td style="text-align:left;"> Colon Adenocarcinoma </td>
   <td style="text-align:left;"> -1 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000004 </td>
   <td style="text-align:left;"> HEL_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> HEL </td>
   <td style="text-align:right;"> 907053 </td>
   <td style="text-align:right;"> 783 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML), M6 (Erythroleukemia) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000005 </td>
   <td style="text-align:left;"> HEL9217_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> HEL 92.1.7 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML), M6 (Erythroleukemia) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000006 </td>
   <td style="text-align:left;"> MONOMAC6_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MONO-MAC-6 </td>
   <td style="text-align:right;"> 908148 </td>
   <td style="text-align:right;"> 2167 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML), M5 (Monocytic) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000007 </td>
   <td style="text-align:left;"> LS513_LARGE_INTESTINE </td>
   <td style="text-align:left;"> LS513 </td>
   <td style="text-align:right;"> 907795 </td>
   <td style="text-align:right;"> 569 </td>
   <td style="text-align:left;"> Colon/Colorectal Cancer </td>
   <td style="text-align:left;"> Colon Carcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000009 </td>
   <td style="text-align:left;"> C2BBE1_LARGE_INTESTINE </td>
   <td style="text-align:left;"> C2BBe1 </td>
   <td style="text-align:right;"> 910700 </td>
   <td style="text-align:right;"> 2104 </td>
   <td style="text-align:left;"> Colon/Colorectal Cancer </td>
   <td style="text-align:left;"> Colon Adenocarcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000010 </td>
   <td style="text-align:left;"> NCIH2077_LUNG </td>
   <td style="text-align:left;"> NCI-H2077;NCI-H1581 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000011 </td>
   <td style="text-align:left;"> 253J_URINARY_TRACT </td>
   <td style="text-align:left;"> 253J </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Bladder Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> KCLB </td>
  </tr>
</tbody>
</table></div>

1. **DepMap_ID** - ID for Dependancy Map project
2. **CCLE_Name** - name from the [Cancer Cell Line Encyclopedia (CCLE)](https://portals.broadinstitute.org/ccle)
3. **Aliases** - other names
4. **COSMIC_ID** - [COSMIC](https://cancer.sanger.ac.uk/cosmic) ID
5. **Sanger_ID** - Sanger ID
6. **Primary_Disease** - general disease of the cell line
7. **Subtype_Disease** - more specific disease of the cell line
8. **Gender** - sex (if known) of the patient
9. **Source** - source of the cell line

### cell_line_ras_anno.tib



### ras_muts_annotated.tib

### synthetic_lethal.tib


## Graphs

### ras_dependency_graph.gr
