
## Allele-Specific Synthetic Lethality ##

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

dat <- readRDS(file.path("data", "synthetic_lethal.tib"))

ras_synlethal <- dat %>%
    filter(allele != "WT") %>%
    group_by(ras_allele) %>%
    filter(n_distinct(cell_line) >= 2) %>%
    ungroup()


#### ---- Plotting Number of Alleles ---- ####

cellline_tib <- ras_synlethal %>%
    dplyr::select(cell_line, tissue, ras, allele, ras_allele) %>%
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
    summarise(num_cell_lines = n_distinct(cell_line)) %>%
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
    summarise(num_cell_lines = n_distinct(cell_line)) %>%
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
    dplyr::select(gene, cell_line, tissue, score, ras_allele, ras, allele) %>%
    filter(gene == ras) %>%
    group_by(ras_allele, tissue, ras, allele) %>%
    summarise(avg_score = median(score)) %>%
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


#### ---- Ras Dependency Network ---- ####
# Put all of the data into a tidygraph
ras_dependency_gr <- ras_synlethal %>%
    mutate(codon = get_codon_label(allele)) %>%
    filter(gene != ras & Primary_Disease %in% ras_cancers) %>%
    dplyr::select(ras_allele, gene, cell_line, tissue, score,
                  ras, allele, codon,
                  Primary_Disease, Subtype_Disease) %>%
    as_tbl_graph(directed = FALSE) %N>%
    mutate(gene_group = ifelse(str_detect(name, "_"), "ras", "target"))
saveRDS(ras_dependency_gr, file.path("data", "ras_dependency_graph.gr"))

ras_dependency_gr %E>%
    filter(Primary_Disease == ras_cancers[[1]] &
           ras == "KRAS" &
           codon %in% c("12", "13", "61", "146") &
           abs(score) >= 1) %>%
    group_by(from, to, tissue, ras, allele, Primary_Disease, Subtype_Disease) %>%
    filter(score == median(score)) %>%
    ungroup() %>%
    mutate(score = ifelse(score > 2, 2, score),
           score = ifelse(score < -2, -2, score)) %N>%
    filter(centrality_degree() > 0) %>%
    mutate(label = ifelse(gene_group == "ras", name, ""),
           label = str_replace_all(label, "_", " ")) %>%
    ggraph(layout = "nicely") +
    geom_edge_link(aes(width = abs(score), color = score)) +
    geom_node_point(aes(color = gene_group, size = gene_group)) +
    geom_node_text(aes(label = label),
                   color = "black",
                   repel = TRUE,
                   size = 7) +
    scale_edge_width_continuous(range = c(0.1, 1)) +
    scale_edge_color_gradient2(low = "dodgerblue", high = "tomato") +
    scale_size_manual(values = c("ras" = 5, "target" = 0.5), guide = FALSE) +
    scale_color_manual(values = c("ras" = "black", target = "grey40"), guide = FALSE) +
    theme_void() +
    theme(panel.background = element_rect(fill = "grey95"))
ggsave(file.path("images", "dependency_graph_nicely.png"),
       width = 22, height = 19, units = "in", dpi = 200)
