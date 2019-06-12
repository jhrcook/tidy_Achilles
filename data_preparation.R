################################################################
## Prepare Data for Allele-Specific Synthetic Lethal Analysis ##
################################################################

# Parse and prepare data from the Broad's Achilles project

library(jhcutils)
library(magrittr)
library(tidyverse)

# reading and writing data from `data/` dir
data_dir <- "data"
file_data_path <- function(x) file.path(data_dir, x)
read_data <- function(file, ...) read_csv(file_data_path(file), ...)
write_data <- function(x, file, ...) saveRDS(x, file_data_path(file), ...)

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
sample_info <- read_data("sample_info.csv") %>%
    janitor::clean_names() %T>%
    write_data("cell_line_metadata.tib")


#### ---- Cell Line Mutations ---- ####
read_data("CCLE_mutations.csv") %>%
    janitor::clean_names() %>%
    dplyr::select(-x1, -x) %>%
    write_data("cell_line_mutations.tib")


#### ---- CNV ---- ####
cn_tib <- read_data("CCLE_gene_cn.csv",
                    col_types = cols(.default = "c")) %>%
    dplyr::rename(dep_map_id = "X1") %>%
    tidyr::gather(key = "gene", value = "copy_number", -dep_map_id) %>%
    janitor::clean_names() %>%
    mutate(copy_number = as.numeric(copy_number),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(sample_info, by = "dep_map_id")  %>%
    mutate(tissue = str_remove_all(ccle_name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(ccle_name), "UNKNOWN", tissue)) %T>%
    write_data("cell_line_copy_number.tib")

a <- cn_tib %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "copy_number",
         save_suffix = "_copynum.tib")

rm(cn_tib)


#### ---- Gene expression ---- ####
gene_expr <- read_data("CCLE_expression.csv") %>%
    dplyr::rename(dep_map_id = "X1") %>%
    tidyr::gather(key = "gene", value = "gene_expression", -dep_map_id) %>%
    janitor::clean_names() %>%
    mutate(gene_expression = as.numeric(gene_expression),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(sample_info, by = "dep_map_id")  %>%
    mutate(tissue = str_remove_all(ccle_name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(ccle_name), "UNKNOWN", tissue)) %T>%
    write_data("cell_line_gene_expression.tib")

a <- gene_expr %>%
    group_by(tissue) %>%
    nest() %>%
    pmap(save_tib_by_tissue,
         save_dir = "gene_expression",
         save_suffix = "_geneexpr.tib")

rm(gene_expr)


#### ---- Gene effect ---- ####
read_data("Achilles_gene_effect.csv") %>%
    dplyr::rename(dep_map_id = "X1") %>%
    tidyr::gather(key = "gene", value = "gene_effect", -dep_map_id) %>%
    janitor::clean_names() %>%
    mutate(gene_effect = as.numeric(gene_effect),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(sample_info, by = "dep_map_id")  %>%
    mutate(tissue = str_remove_all(ccle_name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(ccle_name), "UNKNOWN", tissue)) %T>%
    write_data("Achilles_gene_effect.tib")


#### ---- Gene dependency ---- ####
read_data("Achilles_gene_dependency.csv") %>%
    dplyr::rename(dep_map_id = "X1") %>%
    tidyr::gather(key = "gene", value = "gene_dependency", -dep_map_id) %>%
    janitor::clean_names() %>%
    mutate(gene_dependency = as.numeric(gene_dependency),
           gene = str_extract(gene, "^.+(?=[:space:])"))  %>%
    left_join(sample_info, by = "dep_map_id")  %>%
    mutate(tissue = str_remove_all(ccle_name, "\\[MERGED_TO.+\\]")) %>%
    mutate(tissue = str_split_fixed(tissue, "_", 2)[, 2]) %>%
    mutate(tissue = ifelse(is.na(ccle_name), "UNKNOWN", tissue)) %T>%
    write_data("Achilles_gene_dependency.tib")


#### ---- CRISPR guides ---- ####
guide_efficacy <- read_data("Achilles_guide_efficacy.csv") %>%
    janitor:::clean_names() %>%
    dplyr::rename(sgrna = "sg_rna")
guide_map <- read_data("Achilles_guide_map.csv") %>%
    janitor::clean_names()
dropped <- read_data("Achilles_dropped_guides.csv") %>%
    pull(guide) %>%
    unlist()
left_join(guide_map, guide_efficacy, by = "sgrna") %>%
    mutate(dropped = sgrna %in% !!dropped) %>%
    write_data("Achilles_guides.tib")
rm(guide_efficacy, guide_map, dropped)


#### ---- Achilles Replicates ---- ####
read_data("Achilles_replicate_map.csv") %>%
    janitor::clean_names() %>%
    write_data("Achilles_replicate_map.tib")



#### ---- Essentiality ---- ####
agreed_essentials <- read_data("common_essentials.csv") %>%
    u_pull(gene) %>% unlist()
achilles_essentials <- read_data("Achilles_common_essentials.csv") %>%
    u_pull(gene) %>% unlist()
nonessentials <- read_data("nonessentials.csv") %>%
    u_pull(gene) %>% unlist()

all_genes <- unlist(c(
    agreed_essentials, achilles_essentials, nonessentials
))

tibble(gene = unique(all_genes)) %>%
    mutate(common_essential = gene %in% !!agreed_essentials,
           achilles_essential  = gene %in% !!achilles_essentials,
           nonessential = gene %in% !!nonessentials) %>%
    write_data("gene_essentiality.tib")
