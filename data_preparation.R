################################################################
## Prepare Data for Allele-Specific Synthetic Lethal Analysis ##
################################################################

# Parse and prepare data from the Broad's Achilles project

library(magrittr)
library(tidyverse)

data_dir <- "data"
data_file_path <- function(x) file.path(data_dir, x)

# save each tissue separately in a sub-directory of data
save_tib_by_tissue <- function(tissue, data, save_dir, save_suffix) {
    cat("working on", tissue, "\n")
    new_data <- data %>%
        mutate(tissue = !!tissue)
    save_name <- file.path(data_dir, save_dir,
                           paste0(tissue, save_suffix))
    saveRDS(new_data, save_name)
}


#### ---- Cell Line Meta ---- ####
ccle <- read_csv(data_file_path("DepMap-2019q1-celllines_v2.csv"))
colnames(ccle) %<>% str_replace_all(" ", "_")
saveRDS(ccle, data_file_path("cell_line_metadata.tib"))


#### ---- Cell Line Mutations ---- ####
cell_mutations <- read_csv(data_file_path("depmap_19Q1_mutation_calls.csv")) %>%
    dplyr::select(-X1) %T>%
    saveRDS(data_file_path("cell_line_mutations.tib"))


#### ---- Ras-mutant Cell Lines (with anno.) ---- ####
ras_muts <- cell_mutations %>%
    filter(Hugo_Symbol %in% c("KRAS", "NRAS", "HRAS")) %>%
    mutate(amino_acid_mut = str_remove_all(Protein_Change, "^p\\.")) %>%
    dplyr::select(Tumor_Sample_Barcode, Hugo_Symbol, amino_acid_mut) %>%
    mutate(ras_allele = paste0(Hugo_Symbol, "_", amino_acid_mut))
colnames(ras_muts) <- c("DepMap_ID", "ras", "allele", "ras_allele")
ras_muts_anno <- left_join(ras_muts, ccle, by = "DepMap_ID") %T>%
    saveRDS(data_file_path("ras_muts_annotated.tib"))


#### ---- Cell Line Meta (with Ras-mutant anno.) ---- ####
ccle_ras_muts <- full_join(ccle, ras_muts, by = "DepMap_ID") %>%
    mutate(ras = ifelse(is.na(ras), "WT", ras),
           allele = ifelse(is.na(allele), "WT", allele),
           ras_allele = ifelse(is.na(ras_allele), "WT", ras_allele)) %T>%
    saveRDS(data_file_path("cell_line_ras_anno.tib"))


#### ---- RNAi Synthetic Lethal Data ---- ####
rnai_synlet <- read_csv(data_file_path("D2_combined_gene_dep_scores.csv")) %>%
    gather(cell_line, score, `127399_SOFT_TISSUE`:`ZR75B_BREAST`) %>%
    dplyr::rename(gene = "X1") %>%
    mutate(Entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])"),
           tissue = str_split_fixed(cell_line, "_", 2)[, 2]) %>%
    select(gene, Entrez, cell_line, tissue, score) %>%
    left_join(ccle_ras_muts, by = c("cell_line" = "CCLE_Name")) %T>%
    saveRDS(data_file_path("rnai_synthetic_lethal.tib"))

a <- rnai_synlet %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "rnai_synthetic_lethal",
         save_suffix = "_rnai_synlet.tib")


#### ---- Gene Effect ---- ####
gene_effect <- read_csv(data_file_path("gene_effect_corrected.csv")) %>%
    dplyr::rename(DepMap_ID = "X1") %>%
    tidyr::gather(key = "gene", value = "CERES_score", -DepMap_ID) %>%
    mutate(Entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    left_join(ccle, by = "DepMap_ID") %T>%
    saveRDS(data_file_path("gene_effect.tib"))


#### ---- Gene Dependency ---- ####
gene_depend <- read_csv(data_file_path("gene_dependency_corrected.csv")) %>%
    dplyr::rename(DepMap_ID = "line") %>%
    tidyr::gather(key = "gene", value = "dependency_score", -DepMap_ID) %>%
    mutate(Entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    left_join(ccle, by = "DepMap_ID") %T>%
    saveRDS(data_file_path("gene_dependency.tib"))


#### ---- Gene Essentiality  ---- ####
essential_genes <- read_tsv(data_file_path("essential_genes.txt")) %>%
    mutate(is_essential = TRUE)
nonessential_genes <- read_tsv(data_file_path("nonessential_genes.txt")) %>%
    mutate(is_essential = FALSE)
gene_essentiality <- bind_rows(essential_genes, nonessential_genes) %>%
    mutate(gene = str_extract(gene, "^.+(?=[:space:])")) %T>%
    saveRDS(data_file_path("gene_essentiality.tib"))


#### ---- CNV ---- ####
cn_tib <- read_csv(data_file_path("public_19Q1_gene_cn.csv"),
                    col_types = cols(.default = "c")) %>%
    dplyr::rename(DepMap_ID = "X1") %>%
    tidyr::gather(key = "gene", value = "copy_number", -DepMap_ID) %>%
    mutate(copy_number = as.numeric(copy_number),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(ccle, by = "DepMap_ID")  %>%
    mutate(tissue = str_remove_all(CCLE_Name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(CCLE_Name), "UNKNOWN", tissue)) %T>%
    saveRDS(data_file_path("cell_line_copy_number.tib"))

a <- cn_tib %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "copy_number",
         save_suffix = "_copynum.tib")


#### ---- Guide Maps ---- ####
guide_tib <- read_csv("data/guide_gene_map.csv") %>%
    mutate(Entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %T>%
    saveRDS(file.path("data", "guide_gene_map.tib"))
