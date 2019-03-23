################################################################
## Prepare Data for Allele-Specific Synthetic Lethal Analysis ##
################################################################

# Parse and prepare data from the Broad's Achilles project

library(magrittr)
library(tidyverse)

data_dir <- "data"
data_file_path <- function(x) file.path(data_dir, x)

#### ---- Cell Line Meta ---- ####
ccle <- read_csv(data_file_path("DepMap-2019q1-celllines_v2.csv"))
colnames(ccle) %<>% str_replace_all(" ", "_")
saveRDS(ccle, data_file_path("cell_line_metadata.tib"))


#### ---- Cell Line Mutations ---- ####
cell_mutations <- read_csv(data_file_path("depmap_19Q1_mutation_calls.csv")) %>%
    dplyr::select(-X1)
saveRDS(cell_mutations, data_file_path("cell_line_mutations.tib"))


#### ---- Ras-mutant Cell Lines (with anno.) ---- ####
ras_muts <- cell_mutations %>%
    filter(Hugo_Symbol %in% c("KRAS", "NRAS", "HRAS")) %>%
    mutate(amino_acid_mut = str_remove_all(Protein_Change, "^p\\.")) %>%
    dplyr::select(Tumor_Sample_Barcode, Hugo_Symbol, amino_acid_mut) %>%
    mutate(ras_allele = paste0(Hugo_Symbol, "_", amino_acid_mut))
colnames(ras_muts) <- c("DepMap_ID", "ras", "allele", "ras_allele")
ras_muts_anno <- left_join(ras_muts, ccle, by = "DepMap_ID")
saveRDS(ras_muts_anno, data_file_path("ras_muts_annotated.tib"))


#### ---- Cell Line Meta (with Ras-mutant anno.) ---- ####
ccle_ras_muts <- full_join(ccle, ras_muts, by = "DepMap_ID") %>%
    mutate(ras = ifelse(is.na(ras), "WT", ras),
           allele = ifelse(is.na(allele), "WT", allele),
           ras_allele = ifelse(is.na(ras_allele), "WT", ras_allele))
saveRDS(ccle_ras_muts, data_file_path("cell_line_ras_anno.tib"))


#### ---- Synthetic Lethal Data ---- ####
syn_lethal <- read_csv(data_file_path("D2_combined_gene_dep_scores.csv"))
syn_lethal_tidy <- syn_lethal %>%
    gather(cell_line, score, `127399_SOFT_TISSUE`:`ZR75B_BREAST`) %>%
    mutate(gene = str_remove_all(X1, "[:space:]\\([:digit:]+\\)"),
           tissue = str_split_fixed(cell_line, "_", 2)[, 2]) %>%
    select(gene, cell_line, tissue, score) %>%
    left_join(ccle_ras_muts, by = c("cell_line" = "CCLE_Name"))
saveRDS(syn_lethal_tidy, data_file_path("synthetic_lethal.tib"))

# save each tissue separately in a sub-directory of data
save_syn_lethal <- function(tissue, data) {
    cat("working on", tissue, "\n")
    new_data <- data %>%
        mutate(tissue = !!tissue)
    save_name <- file.path(data_dir, "synthetic_lethal",
                           paste0(tissue, "_syn_lethal.tib"))
    saveRDS(new_data, save_name)
}

a <- syn_lethal_tidy %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_syn_lethal)


#### ---- Gene Essentiality  ---- ####

essential_genes <- read_tsv(data_file_path("essential_genes.txt")) %>%
    mutate(is_essential = TRUE)
nonessential_genes <- read_tsv(data_file_path("nonessential_genes.txt")) %>%
    mutate(is_essential = FALSE)
gene_essentiality <- bind_rows(essential_genes, nonessential_genes) %>%
    mutate(gene = str_extract(gene, "^[:alnum:]+(?=[:space:])"))
saveRDS(gene_essentiality,
        data_file_path("gene_essentiality.tib"))


#### ---- CNV ---- ####

cn_tib <- read_csv(data_file_path("public_19Q1_gene_cn.csv"),
                    col_types = cols(.default = "c")) %>%
    dplyr::rename(cell_line = "X1") %>%
    tidyr::gather(key = "gene", value = "copy_number", -cell_line) %>%
    mutate(copy_number = as.numeric(copy_number),
           gene = str_extract(gene, "^.+(?=[:space:])")) %T>%
    saveRDS(data_file_path("cell_line_copy_number.tib"))

# save each cell line separately in a sub-directory of data
save_cn_tib <- function(cell_line, data) {
    new_data <- data %>%
        mutate(cell_line = !!cell_line)
    save_name <- file.path(data_dir, "copy_number",
                           paste0(cell_line, "_syn_lethal.tib"))
    saveRDS(new_data, save_name)
}

a <- cn_tib %>%
    group_by(cell_line) %>%
    nest() %>%
    pmap(save_cn_tib)
