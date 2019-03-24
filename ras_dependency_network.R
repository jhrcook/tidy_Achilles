##############################
## Graphs of Ras-Dependency ##
##############################

# Make tidygraph objects of the depdency scores of Ras alleles

library(ggraph)
library(igraph)
library(tidygraph)
library(magrittr)
library(tidyverse)

cancer_names_tib <- c(COAD = "Colon/Colorectal Cancer",
                      PAAD = "Pancreatic Cancer",
                      SKCM = "Skin Cancer",
                      MM = "Myeloma",
                      LUAD = "Lung Cancer") %>%
    tibble::enframe(name = "cancer", value = "Primary_Disease")

#### ---- Prep Data ---- ####

get_codon_label <- function(allele) {
    codons <- str_extract(allele, "[:digit:]+")
    codons[!str_detect(codons, "12|13|146|61")] <- "other"
    return(codons)
}

# synethic lethality scores (CERES and batch-effect adjusted)
synlet_tib <- readRDS(file.path("data", "gene_effect.tib"))

# Ras data of cell lines
ccle_metadata <- readRDS(file.path("data", "cell_line_ras_anno.tib")) %>%
    dplyr::select(CCLE_Name, ras, allele, ras_allele) %>%
    mutate(codon = get_codon_label(allele)) %>%
    mutate(codon = ifelse(ras == "WT", "WT", codon))

depend_tib <- synlet_tib %>%
    left_join(cancer_names_tib, by = "Primary_Disease") %>%
    filter(!is.na(cancer)) %>%
    left_join(ccle_metadata, by = "CCLE_Name") %>%
    group_by(cancer, ras_allele) %>%
    mutate(num_celllines = n_distinct(CCLE_Name)) %>%
    ungroup()


#### ---- Ras Dependency Network ---- ####

depend_gr <- depend_tib %>%
    mutate(from = ras_allele,
           to = gene) %>%
    as_tbl_graph() %N>%
    mutate(gene_group = ifelse(str_detect(name, "_") | name == "WT",
                               "ras", "target"))

saveRDS(depend_gr, file.path("data", "ras_dependency_graph.gr"))
