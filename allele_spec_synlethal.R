#########################################
## Allele-Specific Synthetic Lethality ##
#########################################

# Are any gene synthetic lethal in a KRAS allele-specific fashion

library(ggraph)
library(igraph)
library(tidygraph)
library(magrittr)
library(tidyverse)

sensitive_tissues <- c("HAEMATOPOIETIC_AND_LYMPHOID_TISSUE",
                       "LARGE_INTESTINE",
                       "LUNG",
                       "PANCREAS",
                       "SKIN")

ras_cancers <- c("Colon/Colorectal Cancer",
                 "Pancreatic Cancer",
                 "Skin Cancer",
                 "Myeloma",
                 "Lung Cancer")

#### ---- Load Data ---- ####

dat <- readRDS(file.path("data", "gene_effect.tib"))
ras <- readRDS(file.path("data", "cell_line_ras_anno.tib")) %>%
    mutate(tissue = str_split_fixed(CCLE_Name, "_", 2)[, 2]) %>%
    dplyr::select(DepMap_ID, tissue, ras, allele, ras_allele)

ras_synlethal <- dat %>%
    left_join(ras, by = "DepMap_ID") %>%
    filter(allele != "WT") %>%
    group_by(ras_allele) %>%
    filter(n_distinct(DepMap_ID) >= 2) %>%
    ungroup()


#### ---- Plotting Number of Alleles ---- ####

cellline_tib <- ras_synlethal %>%
    dplyr::select(DepMap_ID, tissue, ras, allele, ras_allele) %>%
    unique()

get_codon_label <- function(allele) {
    codons <- str_extract(allele, "[:digit:]+")
    codons[!str_detect(codons, "12|13|146|61")] <- "other"
    codons <- factor(codons, levels = c("12", "13", "61", "146", "other"))
    return(codons)
}

# number of each RAS allele per all tissues
cellline_tib %>%
    group_by(ras_allele, tissue, ras, allele) %>%
    summarise(num_cell_lines = n_distinct(DepMap_ID)) %>%
    ungroup() %>%
    mutate(ras_allele = str_replace_all(ras_allele, "_", " "),
           tissue = str_replace_all(tissue, "_", " "),
           tissue = str_to_title(tissue),
           codon = get_codon_label(allele)) %>%
    ggplot(aes(x = ras_allele, y = tissue)) +
    geom_point(aes(size = num_cell_lines, color = ras, shape = codon)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_shape_manual(values = c(16, 15, 17, 18, 10)) +
    labs(x = "", y = "", color = "RAS", size = "num. of\ncell lines")
ggsave(filename = file.path("images", "ras_alleles_per_tissue.png"),
       width = 10, height = 5.5, units = "in", dpi = 200)

# number of each RAS allele per sensitive tissues
cellline_tib %>%
    filter(tissue %in% sensitive_tissues) %>%
    group_by(ras_allele, tissue, ras, allele) %>%
    summarise(num_cell_lines = n_distinct(DepMap_ID)) %>%
    ungroup() %>%
    mutate(ras_allele = str_replace_all(ras_allele, "_", " "),
           tissue = str_replace_all(tissue, "_", " "),
           tissue = str_to_title(tissue),
           codon = get_codon_label(allele)) %>%
    ggplot(aes(x = ras_allele, y = tissue)) +
    geom_point(aes(size = num_cell_lines, color = ras, shape = codon)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_shape_manual(values = c(16, 15, 17, 18, 10)) +
    labs(x = "", y = "", color = "RAS", size = "num. of\ncell lines")
ggsave(filename = file.path("images", "ras_alleles_per_sensitive_tissue.png"),
       width = 9, height = 5.5, units = "in", dpi = 200)


#### ---- Plotting Dependence on Ras ---- ####

ras_synlethal %>%
    dplyr::select(gene, DepMap_ID, tissue, CERES_score,
                  ras_allele, ras, allele) %>%
    filter(gene == ras) %>%
    group_by(ras_allele, tissue, ras, allele) %>%
    summarise(avg_score = median(CERES_score)) %>%
    ungroup() %>%
    mutate(ras_allele = str_replace_all(ras_allele, "_", " "),
           tissue = str_replace_all(tissue, "_", " "),
           tissue = str_to_title(tissue),
           codon = get_codon_label(allele)) %>%
    ggplot(aes(x = ras_allele, y = tissue)) +
    geom_point(aes(size = avg_score, color = avg_score, shape = ras)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(x = "", y = "", color = "avg. score", size = "avg. score",
         title = "Dependence of RAS-mutant cell lines on RAS",
         subtitle = "The median dependency score of each cell line on its mutant ras") +
    scale_size(trans = "reverse") +
    scale_color_distiller(type = "div", palette = "Blues") +
    scale_shape_manual(values = c(15, 16, 17))
ggsave(filename = file.path("images", "ras_dependence.png"),
       width = 9, height = 5.5, units = "in", dpi = 200)


#### ---- Plot Example Ras Dependency Network ---- ####
ras_dependency_gr <- readRDS(file.path("data", "ras_dependency_graph.gr"))

gr <- ras_dependency_gr  %>%
    convert(to_undirected, .clean = TRUE) %E>%
    select(from, to, cancer, ras_allele, ras, codon, CERES_score) %>%
    filter(cancer == "COAD" &
           ras == "KRAS" &
           codon %in% c("12", "13", "61", "146") &
           CERES_score <= -1) %>%
    group_by(from, to, cancer, ras_allele, ras, codon) %>%
    mutate(CERES_score = median(CERES_score)) %>%
    ungroup() %>%
    filter(edge_is_multiple()) %>%
    mutate(CERES_score = ifelse(CERES_score > 2, 2, CERES_score),
           CERES_score = ifelse(CERES_score < -2, -2, CERES_score)) %N>%
    mutate(label = ifelse(gene_group == "ras", name, ""),
           label = str_replace_all(label, "_", " ")) %N>%
    filter(centrality_degree() > 0)
ggraph(gr, layout = "kk") +
    geom_edge_link(aes(width = abs(CERES_score), color = CERES_score)) +
    geom_node_point(aes(color = gene_group, size = gene_group)) +
    geom_node_text(aes(label = label),
                   color = "black",
                   repel = TRUE,
                   size = 7) +
    scale_edge_width_continuous(range = c(0.1, 2)) +
    scale_edge_color_distiller(type = "seq", palette = "YlOrRd") +
    scale_size_manual(values = c("ras" = 5, "target" = 0.5), guide = FALSE) +
    scale_color_manual(values = c("ras" = "black", target = "grey40"),
                       guide = FALSE) +
    theme_void() +
    theme(panel.background = element_rect(fill = "white"))
ggsave(file.path("images", "dependency_graph_nicely.png"),
       width = 22, height = 19, units = "in", dpi = 200)
