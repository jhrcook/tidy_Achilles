################################################################
## Prepare Data for Allele-Specific Synthetic Lethal Analysis ##
################################################################

# Parse and prepare data from the Broad's Achilles project

library(magrittr)
library(tidyverse)

data_dir <- "data"

#### ---- Cell Line Meta ---- ####
ccle <- read_csv(file.path(data_dir, "DepMap-2019q1-celllines_v2.csv"))
colnames(ccle) %<>% str_replace_all(" ", "_")
saveRDS(ccle, file.path(data_dir, "cell_line_metadata.tib"))

#### ---- Cell Line Mutations ---- ####
cell_mutations <- read_csv(file.path(data_dir,
                                     "depmap_19Q1_mutation_calls.csv")) %>%
    dplyr::select(-X1)
saveRDS(cell_mutations, file.path("data", "cell_line_mutations.tib"))

#### ---- Ras-mutant Cell Lines (with anno.) ---- ####
ras_muts <- cell_mutations %>%
    filter(Hugo_Symbol %in% c("KRAS", "NRAS", "HRAS")) %>%
    mutate(amino_acid_mut = str_remove_all(Protein_Change, "^p\\.")) %>%
    dplyr::select(Tumor_Sample_Barcode, Hugo_Symbol, amino_acid_mut) %>%
    mutate(ras_allele = paste0(Hugo_Symbol, "_", amino_acid_mut))
colnames(ras_muts) <- c("DepMap_ID", "ras", "allele", "ras_allele")
ras_muts_anno <- left_join(ras_muts, ccle, by = "DepMap_ID")
saveRDS(ras_muts_anno, file.path(data_dir, "ras_muts_annotated.tib"))

#### ---- Cell Line Meta (with Ras-mutant anno.) ---- ####
ccle_ras_muts <- full_join(ccle, ras_muts, by = "DepMap_ID") %>%
    mutate(ras = ifelse(is.na(ras), "WT", ras),
           allele = ifelse(is.na(allele), "WT", allele),
           ras_allele = ifelse(is.na(ras_allele), "WT", ras_allele))
saveRDS(ccle_ras_muts, file.path(data_dir, "cell_line_ras_anno.tib"))

#### ---- Synthetic Lethal Data ---- ####
syn_lethal <- read_csv(file.path(data_dir, "D2_combined_gene_dep_scores.csv"))
syn_lethal_tidy <- syn_lethal %>%
    gather(cell_line, score, `127399_SOFT_TISSUE`:`ZR75B_BREAST`) %>%
    mutate(gene = str_remove_all(X1, "[:space:]\\([:digit:]+\\)"),
           tissue = str_split_fixed(cell_line, "_", 2)[, 2]) %>%
    select(gene, cell_line, tissue, score) %>%
    left_join(ccle_ras_muts, by = c("cell_line" = "CCLE_Name"))
saveRDS(syn_lethal_tidy, file.path(data_dir, "synthetic_lethal.tib"))
