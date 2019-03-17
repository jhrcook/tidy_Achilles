---
title: "Tidy Project Achilles Data"
author: "Joshua H Cook"
output: github_document
---




```r
library(tidyverse)
```

**last updated: March 15, 2019**

This is "tidy" data from the Broad's [Project Achilles](https://depmap.org/portal/achilles/) with a focus of the various *RAS* alleles. The data files are in the "data" directory and exaplined below.

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


```r
cell_line_metadata %>%
	slice(1:100) %>%
	kable() %>%
	scroll_box(width = "100%", height = "300px")
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
  <tr>
   <td style="text-align:left;"> ACH-000012 </td>
   <td style="text-align:left;"> HCC827_LUNG </td>
   <td style="text-align:left;"> HCC827 </td>
   <td style="text-align:right;"> 1240146 </td>
   <td style="text-align:right;"> 354 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000013 </td>
   <td style="text-align:left;"> ONCODG1_OVARY </td>
   <td style="text-align:left;"> ONCO-DG-1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Ovarian Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000014 </td>
   <td style="text-align:left;"> HS294T_SKIN </td>
   <td style="text-align:left;"> Hs 294T;A101D;Hs 294.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Skin Cancer </td>
   <td style="text-align:left;"> Melanoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000015 </td>
   <td style="text-align:left;"> NCIH1581_LUNG </td>
   <td style="text-align:left;"> NCI-H1581;NCI-H2077 </td>
   <td style="text-align:right;"> 908471 </td>
   <td style="text-align:right;"> 1237 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Large Cell Carcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000016 </td>
   <td style="text-align:left;"> SLR21_KIDNEY </td>
   <td style="text-align:left;"> SLR 21 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Kidney Cancer </td>
   <td style="text-align:left;"> Renal Cell Carcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000017 </td>
   <td style="text-align:left;"> SKBR3_BREAST </td>
   <td style="text-align:left;"> SK-BR-3 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Breast Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000018 </td>
   <td style="text-align:left;"> T24_URINARY_TRACT </td>
   <td style="text-align:left;"> T24 </td>
   <td style="text-align:right;"> 724812 </td>
   <td style="text-align:right;"> 1455 </td>
   <td style="text-align:left;"> Bladder Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000019 </td>
   <td style="text-align:left;"> MCF7_BREAST </td>
   <td style="text-align:left;"> MCF7 </td>
   <td style="text-align:right;"> 905946 </td>
   <td style="text-align:right;"> 588 </td>
   <td style="text-align:left;"> Breast Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000492 </td>
   <td style="text-align:left;"> MUTZ5_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MUTZ-5 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Lymphoblastic Leukemia (ALL), B-cell </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000021 </td>
   <td style="text-align:left;"> NCIH1693_LUNG </td>
   <td style="text-align:left;"> NCI-H1693 </td>
   <td style="text-align:right;"> 687802 </td>
   <td style="text-align:right;"> 634 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000022 </td>
   <td style="text-align:left;"> PATU8988S_PANCREAS </td>
   <td style="text-align:left;"> PA-TU-8988S </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Ductal Adenocarcinoma, exocrine </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000023 </td>
   <td style="text-align:left;"> PATU8988T_PANCREAS </td>
   <td style="text-align:left;"> PA-TU-8988T </td>
   <td style="text-align:right;"> 1240201 </td>
   <td style="text-align:right;"> 1242 </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Ductal Adenocarcinoma, exocrine </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000024 </td>
   <td style="text-align:left;"> OPM2_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> OPM-2 </td>
   <td style="text-align:right;"> 909249 </td>
   <td style="text-align:right;"> 112 </td>
   <td style="text-align:left;"> Myeloma </td>
   <td style="text-align:left;"> Multiple Myeloma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000036 </td>
   <td style="text-align:left;"> U343_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> U343 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000026 </td>
   <td style="text-align:left;"> 253JBV_URINARY_TRACT </td>
   <td style="text-align:left;"> 253J-BV </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Bladder Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000027 </td>
   <td style="text-align:left;"> GOS3_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> GOS-3 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000028 </td>
   <td style="text-align:left;"> KPL1_BREAST </td>
   <td style="text-align:left;"> KPL-1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Breast Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000053 </td>
   <td style="text-align:left;"> KARPAS299_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> KARPAS-299 </td>
   <td style="text-align:right;"> 907273 </td>
   <td style="text-align:right;"> 906 </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> T-cell, Non-Hodgkins, Anaplastic Large Cell (ALCL) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ECAAC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000030 </td>
   <td style="text-align:left;"> PC14_LUNG </td>
   <td style="text-align:left;"> PC-14 </td>
   <td style="text-align:right;"> 753608 </td>
   <td style="text-align:right;"> 198 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> RIKEN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000031 </td>
   <td style="text-align:left;"> PANC0213_PANCREAS </td>
   <td style="text-align:left;"> Panc 02.13 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Ductal Adenocarcinoma, exocrine </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000032 </td>
   <td style="text-align:left;"> MHHCALL3_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MHH-CALL-3 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Lymphoblastic Leukemia (ALL), B-cell </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000033 </td>
   <td style="text-align:left;"> NCIH1819_LUNG </td>
   <td style="text-align:left;"> NCI-H1819 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> -1 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000034 </td>
   <td style="text-align:left;"> PLB985_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> PLB985;PLB-985 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000035 </td>
   <td style="text-align:left;"> NCIH1650_LUNG </td>
   <td style="text-align:left;"> NCI-H1650 </td>
   <td style="text-align:right;"> 687800 </td>
   <td style="text-align:right;"> 1548 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Bronchoalveolar Carcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000127 </td>
   <td style="text-align:left;"> SLR20_KIDNEY </td>
   <td style="text-align:left;"> SLR 20 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Kidney Cancer </td>
   <td style="text-align:left;"> Renal Cell Carcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000037 </td>
   <td style="text-align:left;"> S117_THYROID </td>
   <td style="text-align:left;"> S-117 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Sarcoma </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000371 </td>
   <td style="text-align:left;"> RL_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> RL </td>
   <td style="text-align:right;"> 910861 </td>
   <td style="text-align:right;"> 1273 </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> B-cell, Non-Hodgkins </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000052 </td>
   <td style="text-align:left;"> A673_BONE </td>
   <td style="text-align:left;"> A-673 </td>
   <td style="text-align:right;"> 684052 </td>
   <td style="text-align:right;"> 660 </td>
   <td style="text-align:left;"> Bone Cancer </td>
   <td style="text-align:left;"> Ewings Sarcoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000040 </td>
   <td style="text-align:left;"> U118MG_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> U-118 MG </td>
   <td style="text-align:right;"> 687588 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000210 </td>
   <td style="text-align:left;"> CADOES1_BONE </td>
   <td style="text-align:left;"> CADO-ES1;CADO-ES-1 </td>
   <td style="text-align:right;"> 753539 </td>
   <td style="text-align:right;"> 1523 </td>
   <td style="text-align:left;"> Bone Cancer </td>
   <td style="text-align:left;"> Ewings Sarcoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000042 </td>
   <td style="text-align:left;"> PANC0203_PANCREAS </td>
   <td style="text-align:left;"> Panc 02.03 </td>
   <td style="text-align:right;"> 1298475 </td>
   <td style="text-align:right;"> 1838 </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Ductal Adenocarcinoma, exocrine </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000043 </td>
   <td style="text-align:left;"> HS895T_FIBROBLAST </td>
   <td style="text-align:left;"> Hs 895.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Fibroblast </td>
   <td style="text-align:left;"> malignant_melanoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-001393 </td>
   <td style="text-align:left;"> SUM190PT_BREAST </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Breast Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000045 </td>
   <td style="text-align:left;"> MV411_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MV4;11;MV-4-11 </td>
   <td style="text-align:right;"> 908156 </td>
   <td style="text-align:right;"> 133 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000046 </td>
   <td style="text-align:left;"> ACHN_KIDNEY </td>
   <td style="text-align:left;"> ACHN </td>
   <td style="text-align:right;"> 905950 </td>
   <td style="text-align:right;"> 371 </td>
   <td style="text-align:left;"> Kidney Cancer </td>
   <td style="text-align:left;"> Renal Cell Adenocarcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000047 </td>
   <td style="text-align:left;"> GCIY_STOMACH </td>
   <td style="text-align:left;"> GCIY </td>
   <td style="text-align:right;"> 906869 </td>
   <td style="text-align:right;"> 1414 </td>
   <td style="text-align:left;"> Gastric Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> RIKEN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000048 </td>
   <td style="text-align:left;"> TOV112D_OVARY </td>
   <td style="text-align:left;"> TOV-112D </td>
   <td style="text-align:right;"> 1299070 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Ovarian Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma, endometrioid </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000049 </td>
   <td style="text-align:left;"> HEKTE_KIDNEY </td>
   <td style="text-align:left;"> HEK TE </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Kidney Cancer </td>
   <td style="text-align:left;"> Immortalized </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000050 </td>
   <td style="text-align:left;"> NCIH929_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> NCI-H929 </td>
   <td style="text-align:right;"> 724825 </td>
   <td style="text-align:right;"> 1230 </td>
   <td style="text-align:left;"> Myeloma </td>
   <td style="text-align:left;"> Multiple Myeloma, plasmacytoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000051 </td>
   <td style="text-align:left;"> TE617T_SOFT_TISSUE </td>
   <td style="text-align:left;"> TE 617.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Sarcoma </td>
   <td style="text-align:left;"> Rhabdomyosarcoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-001022 </td>
   <td style="text-align:left;"> CBAGPN_BONE </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Bone Cancer </td>
   <td style="text-align:left;"> Ewings Sarcoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000169 </td>
   <td style="text-align:left;"> RD_SOFT_TISSUE </td>
   <td style="text-align:left;"> RD </td>
   <td style="text-align:right;"> 909264 </td>
   <td style="text-align:right;"> 1763 </td>
   <td style="text-align:left;"> Sarcoma </td>
   <td style="text-align:left;"> Rhabdomyosarcoma, embryonal </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000054 </td>
   <td style="text-align:left;"> HT1080_SOFT_TISSUE </td>
   <td style="text-align:left;"> HT-1080 </td>
   <td style="text-align:right;"> 907064 </td>
   <td style="text-align:right;"> 1391 </td>
   <td style="text-align:left;"> Sarcoma </td>
   <td style="text-align:left;"> Fibrosarcoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000055 </td>
   <td style="text-align:left;"> D283MED_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> D283 Med;D283 </td>
   <td style="text-align:right;"> 906834 </td>
   <td style="text-align:right;"> 1184 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Medulloblastoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000056 </td>
   <td style="text-align:left;"> DOHH2_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> DOHH-2 </td>
   <td style="text-align:right;"> 906842 </td>
   <td style="text-align:right;"> 1339 </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> Diffuse Large B-cell Lymphoma (DLBCL) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000057 </td>
   <td style="text-align:left;"> OPM1_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> OPM-1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Myeloma </td>
   <td style="text-align:left;"> Multiple Myeloma </td>
   <td style="text-align:left;"> -1 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000058 </td>
   <td style="text-align:left;"> ML1_THYROID </td>
   <td style="text-align:left;"> ML-1 </td>
   <td style="text-align:right;"> 1240178 </td>
   <td style="text-align:right;"> 1227 </td>
   <td style="text-align:left;"> Thyroid Cancer </td>
   <td style="text-align:left;"> Carcinoma, follicular </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000156 </td>
   <td style="text-align:left;"> MHHCALL4_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MHH-CALL-4 </td>
   <td style="text-align:right;"> 908133 </td>
   <td style="text-align:right;"> 2070 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Lymphoblastic Leukemia (ALL), B-cell </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000060 </td>
   <td style="text-align:left;"> PANC1005_PANCREAS </td>
   <td style="text-align:left;"> Panc 10.05 </td>
   <td style="text-align:right;"> 925348 </td>
   <td style="text-align:right;"> 197 </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000061 </td>
   <td style="text-align:left;"> HH_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> HH </td>
   <td style="text-align:right;"> 907056 </td>
   <td style="text-align:right;"> 310 </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> T-cell, Non-Hodgkins, Cutaneous </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000062 </td>
   <td style="text-align:left;"> RERFLCMS_LUNG </td>
   <td style="text-align:left;"> RERF-LC-MS </td>
   <td style="text-align:right;"> 910931 </td>
   <td style="text-align:right;"> 2051 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> JCRB </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000063 </td>
   <td style="text-align:left;"> HS616T_FIBROBLAST </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> B-Cell, Hodgkins </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000064 </td>
   <td style="text-align:left;"> SALE_LUNG </td>
   <td style="text-align:left;"> SALE </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Immortalized </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000065 </td>
   <td style="text-align:left;"> OCIAML5_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> OCI-AML5 </td>
   <td style="text-align:right;"> 1330983 </td>
   <td style="text-align:right;"> 2130 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000066 </td>
   <td style="text-align:left;"> HCC4006_LUNG </td>
   <td style="text-align:left;"> HCC4006 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Non-Small Cell Lung Cancer (NSCLC), Adenocarcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000067 </td>
   <td style="text-align:left;"> HS683_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> Hs 683 </td>
   <td style="text-align:right;"> 1240150 </td>
   <td style="text-align:right;"> 769 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000069 </td>
   <td style="text-align:left;"> HS611T_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> Hs 611.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> B-cell, Hodgkins </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-001498 </td>
   <td style="text-align:left;"> FARAGE_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 1297449 </td>
   <td style="text-align:right;"> 1772 </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> B-cell, Non-Hodgkins </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000071 </td>
   <td style="text-align:left;"> HS706T_BONE </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> fibroblast </td>
   <td style="text-align:left;"> giant_cell_tumor </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000072 </td>
   <td style="text-align:left;"> MEG01_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MEG-01 </td>
   <td style="text-align:right;"> 908126 </td>
   <td style="text-align:right;"> 1263 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Chronic Myelogenous Leukemia (CML) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000220 </td>
   <td style="text-align:left;"> MINO_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> Mino </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> B-cell, Non-Hodgkins, Mantle Cell </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000074 </td>
   <td style="text-align:left;"> KU812_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> KU812 </td>
   <td style="text-align:right;"> 907311 </td>
   <td style="text-align:right;"> 598 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Chronic Myelogenous Leukemia (CML), blast crisis </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000075 </td>
   <td style="text-align:left;"> U87MG_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> U-87 MG </td>
   <td style="text-align:right;"> 687590 </td>
   <td style="text-align:right;"> 549 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000076 </td>
   <td style="text-align:left;"> NCO2_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> NCO2 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Chronic Myelogenous Leukemia (CML) </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> HSSRB </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000077 </td>
   <td style="text-align:left;"> MJ_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MJ </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lymphoma </td>
   <td style="text-align:left;"> T-cell, Non-Hodgkins, Cutaneous </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000078 </td>
   <td style="text-align:left;"> MHHNB11_AUTONOMIC_GANGLIA </td>
   <td style="text-align:left;"> MHH-NB-11 </td>
   <td style="text-align:right;"> 908135 </td>
   <td style="text-align:right;"> 1818 </td>
   <td style="text-align:left;"> Neuroblastoma </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000079 </td>
   <td style="text-align:left;"> TE125T_FIBROBLAST </td>
   <td style="text-align:left;"> TE 125.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Fibroblast </td>
   <td style="text-align:left;"> Rhabdomyosarcoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000070 </td>
   <td style="text-align:left;"> 697_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> 697 </td>
   <td style="text-align:right;"> 906800 </td>
   <td style="text-align:right;"> 63 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Lymphoblastic Leukemia (ALL), B-cell </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000081 </td>
   <td style="text-align:left;"> GDM1_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> GDM-1 </td>
   <td style="text-align:right;"> 906870 </td>
   <td style="text-align:right;"> 164 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML) </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000082 </td>
   <td style="text-align:left;"> G292CLONEA141B1_BONE </td>
   <td style="text-align:left;"> G-292;clone A141B1;G292CLONEA141B1;G-292 clone A141B1 </td>
   <td style="text-align:right;"> 1290807 </td>
   <td style="text-align:right;"> 661 </td>
   <td style="text-align:left;"> Bone Cancer </td>
   <td style="text-align:left;"> Osteosarcoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000083 </td>
   <td style="text-align:left;"> HS281T_FIBROBLAST </td>
   <td style="text-align:left;"> Hs 281.T </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Fibroblast </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000084 </td>
   <td style="text-align:left;"> MUTZ3_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> MUTZ3 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Myelogenous Leukemia (AML) </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000085 </td>
   <td style="text-align:left;"> T3M4_PANCREAS </td>
   <td style="text-align:left;"> T3M-4 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Ductal Adenocarcinoma, exocrine </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> RIKEN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000086 </td>
   <td style="text-align:left;"> ACCMESO1_PLEURA </td>
   <td style="text-align:left;"> ACC-MESO-1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Mesothelioma </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> RIKEN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000088 </td>
   <td style="text-align:left;"> HS172T_FIBROBLAST </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Fibroblast </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000089 </td>
   <td style="text-align:left;"> NCIH684_LARGE_INTESTINE </td>
   <td style="text-align:left;"> NCI-H684 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Colon/Colorectal Cancer </td>
   <td style="text-align:left;"> Colon Adenocarcinoma </td>
   <td style="text-align:left;"> -1 </td>
   <td style="text-align:left;"> KCLB </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000090 </td>
   <td style="text-align:left;"> PC3_PROSTATE </td>
   <td style="text-align:left;"> PC-3 </td>
   <td style="text-align:right;"> 905934 </td>
   <td style="text-align:right;"> 911 </td>
   <td style="text-align:left;"> Prostate Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000091 </td>
   <td style="text-align:left;"> OV56_OVARY </td>
   <td style="text-align:left;"> OV56 </td>
   <td style="text-align:right;"> 1480362 </td>
   <td style="text-align:right;"> 686 </td>
   <td style="text-align:left;"> Ovarian Cancer </td>
   <td style="text-align:left;"> Carcinoma, serous </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ECACC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000092 </td>
   <td style="text-align:left;"> NCIH2452_PLEURA </td>
   <td style="text-align:left;"> NCI-H2452 </td>
   <td style="text-align:right;"> 908462 </td>
   <td style="text-align:right;"> 624 </td>
   <td style="text-align:left;"> Lung Cancer </td>
   <td style="text-align:left;"> Mesothelioma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000093 </td>
   <td style="text-align:left;"> PANC0504_PANCREAS </td>
   <td style="text-align:left;"> Panc 05.04 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000094 </td>
   <td style="text-align:left;"> HPAFII_PANCREAS </td>
   <td style="text-align:left;"> HPAF-II </td>
   <td style="text-align:right;"> 724869 </td>
   <td style="text-align:right;"> 889 </td>
   <td style="text-align:left;"> Pancreatic Cancer </td>
   <td style="text-align:left;"> Carcinoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000095 </td>
   <td style="text-align:left;"> D341MED_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> D341;D341MED </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Medulloblastoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000096 </td>
   <td style="text-align:left;"> G401_SOFT_TISSUE </td>
   <td style="text-align:left;"> G-401 </td>
   <td style="text-align:right;"> 907299 </td>
   <td style="text-align:right;"> 962 </td>
   <td style="text-align:left;"> Rhabdoid </td>
   <td style="text-align:left;"> Malignant Rhabdoid Tumor </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000097 </td>
   <td style="text-align:left;"> ZR751_BREAST </td>
   <td style="text-align:left;"> ZR-75-1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> Breast Cancer </td>
   <td style="text-align:left;"> Breast Ductal Carcinoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000098 </td>
   <td style="text-align:left;"> GAMG_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> GAMG </td>
   <td style="text-align:right;"> 906868 </td>
   <td style="text-align:right;"> 1174 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000099 </td>
   <td style="text-align:left;"> SIMA_AUTONOMIC_GANGLIA </td>
   <td style="text-align:left;"> SIMA </td>
   <td style="text-align:right;"> 753620 </td>
   <td style="text-align:right;"> 2076 </td>
   <td style="text-align:left;"> Neuroblastoma </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000100 </td>
   <td style="text-align:left;"> RH41_SOFT_TISSUE </td>
   <td style="text-align:left;"> RH-41 </td>
   <td style="text-align:right;"> 1240210 </td>
   <td style="text-align:right;"> 2052 </td>
   <td style="text-align:left;"> Sarcoma </td>
   <td style="text-align:left;"> Rhabdomyosarcoma, alveolar </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000101 </td>
   <td style="text-align:left;"> KE37_HAEMATOPOIETIC_AND_LYMPHOID_TISSUE </td>
   <td style="text-align:left;"> KE-37 </td>
   <td style="text-align:right;"> 907277 </td>
   <td style="text-align:right;"> 1012 </td>
   <td style="text-align:left;"> Leukemia </td>
   <td style="text-align:left;"> Acute Lymphoblastic Leukemia (ALL), T-cell </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000102 </td>
   <td style="text-align:left;"> GMS10_CENTRAL_NERVOUS_SYSTEM </td>
   <td style="text-align:left;"> GMS-10 </td>
   <td style="text-align:right;"> 906873 </td>
   <td style="text-align:right;"> 294 </td>
   <td style="text-align:left;"> Brain Cancer </td>
   <td style="text-align:left;"> Glioblastoma </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> DSMZ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ACH-000103 </td>
   <td style="text-align:left;"> CAOV4_OVARY </td>
   <td style="text-align:left;"> Caov-4 </td>
   <td style="text-align:right;"> 949090 </td>
   <td style="text-align:right;"> 1524 </td>
   <td style="text-align:left;"> Ovarian Cancer </td>
   <td style="text-align:left;"> Adenocarcinoma, high grade serous </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> ATCC </td>
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
