################################################################
## Prepare Data for Allele-Specific Synthetic Lethal Analysis ##
################################################################

# Parse and prepare data from the Broad's Achilles project

library(jhcutils)
library(magrittr)
library(tidyverse)

data_dir <- "data"
data_file_path <- function(x) file.path(data_dir, x)

# save each tissue separately in a sub-directory of data
save_tib_by_tissue <- function(tissue, data, save_dir, save_suffix) {
    cat("working on", tissue, "\n")
    new_data <- data %>%
        mutate(tissue = !!tissue)
    save_name <- file.path(
        data_dir, save_dir,
        paste0(tissue, save_suffix)
    )
    saveRDS(new_data, save_name)
}


#### ---- Cell Line Meta ---- ####
ccle <- read_csv(data_file_path("DepMap-2019q1-celllines_v2.csv")) %>%
    janitor::clean_names() %T>%
    saveRDS(data_file_path("cell_line_metadata.tib"))


#### ---- Cell Line Mutations ---- ####
read_csv(data_file_path("depmap_19Q1_mutation_calls.csv")) %>%
    janitor::clean_names() %>%
    dplyr::select(-x1) %>%
    saveRDS(data_file_path("cell_line_mutations.tib"))


#### ---- RNAi Synthetic Lethal Data ---- ####
rnai_synlet <- read_csv(data_file_path("D2_combined_gene_dep_scores.csv")) %>%
    janitor::clean_names() %>%
    gather(key = "cell_line", value = "achilles_score", -x1) %>%
    dplyr::rename(gene = "x1") %>%
    mutate(entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])"),
           tissue = str_split_fixed(cell_line, "_", 2)[, 2]) %>%
    select(gene, entrez, cell_line, tissue, achilles_score) %>%
    left_join(ccle, by = c("cell_line" = "ccle_name")) %T>%
    saveRDS(data_file_path("rnai_synthetic_lethal.tib"))

a <- rnai_synlet %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "rnai_synthetic_lethal",
         save_suffix = "_rnai_synlet.tib")

rm(rnai_synlet)


#### ---- Gene Effect ---- ####
read_csv(data_file_path("gene_effect_corrected.csv")) %>%
    janitor::clean_names() %>%
    dplyr::rename(dep_map_id = "x1") %>%
    tidyr::gather(key = "gene", value = "ceres_score", -dep_map_id) %>%
    mutate(entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    left_join(ccle, by = "dep_map_id") %>%
    saveRDS(data_file_path("gene_effect.tib"))


#### ---- Gene Dependency ---- ####
read_csv(data_file_path("gene_dependency_corrected.csv")) %>%
    janitor::clean_names() %>%
    dplyr::rename(dep_map_id = "line") %>%
    tidyr::gather(key = "gene", value = "dependency_score", -dep_map_id) %>%
    mutate(entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    left_join(ccle, by = "dep_map_id") %>%
    saveRDS(data_file_path("gene_dependency.tib"))


#### ---- Gene Essentiality  ---- ####
essential_genes <- read_tsv(data_file_path("essential_genes.txt")) %>%
    janitor::clean_names() %>%
    mutate(is_essential = TRUE)
nonessential_genes <- read_tsv(data_file_path("nonessential_genes.txt")) %>%
    mutate(is_essential = FALSE)
bind_rows(essential_genes, nonessential_genes) %>%
    mutate(gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    saveRDS(data_file_path("gene_essentiality.tib"))

rm(essential_genes, nonessential_genes)


#### ---- CNV ---- ####
cn_tib <- read_csv(data_file_path("public_19Q1_gene_cn.csv"),
                    col_types = cols(.default = "c")) %>%
    janitor::clean_names() %>%
    dplyr::rename(dep_map_id = "x1") %>%
    tidyr::gather(key = "gene", value = "copy_number", -dep_map_id) %>%
    mutate(copy_number = as.numeric(copy_number),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(ccle, by = "dep_map_id")  %>%
    mutate(tissue = str_remove_all(ccle_name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(ccle_name), "UNKNOWN", tissue)) %T>%
    saveRDS(data_file_path("cell_line_copy_number.tib"))

a <- cn_tib %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "copy_number",
         save_suffix = "_copynum.tib")

rm(cn_tib)


#### ---- Guide Maps ---- ####
read_csv("data/guide_gene_map.csv") %>%
    janitor::clean_names() %>%
    mutate(entrez = str_extract(gene, "(?<=\\()[:digit:]+(?=\\))"),
           gene = str_extract(gene, "^.+(?=[:space:])")) %>%
    saveRDS(file.path("data", "guide_gene_map.tib"))
