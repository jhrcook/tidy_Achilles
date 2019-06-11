# Test that the new data release from DepMap is in the same format as the
# previous data.

library(assertr)
library(jhcutils)
library(magrittr)
library(tidyverse)

data_dir <- "data"
data_file_path <- function(x) file.path(data_dir, x)

#### ---- Cell Line Meta ---- ####
a <- read_csv(data_file_path("DepMap-2019q1-celllines_v2.csv")) %>%
    janitor::clean_names() %>%
    verify(has_all_names(
        "dep_map_id", "ccle_name", "aliases", "cosmic_id", "sanger_id",
        "primary_disease", "subtype_disease", "gender","source"
    )) %>%
    verify(!is.na(dep_map_id)) %>%
    verify(!is.na(ccle_name)) %>%
    verify(!is.na(primary_disease))


#### ---- Cell Line Mutations ---- ####
a <- read_csv(data_file_path("depmap_19Q1_mutation_calls.csv")) %>%
    janitor::clean_names() %>%
    verify(has_all_names(
        "x1", "hugo_symbol", "entrez_gene_id", "ncbi_build", "chromosome",
        "variant_classification", "variant_type", "protein_change", "dep_map_id"
    )) %>%
    verify(!is.na(dep_map_id)) %>%
    verify(!is.na(hugo_symbol)) %>%
    verify(ncbi_build == "37")


#### ---- RNAi Synthetic Lethal Data ---- ####
a <- read_csv(data_file_path("D2_combined_gene_dep_scores.csv")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("x1")) %>%
    slice(5) %>%
    gather(key = "cell_line", value = "score", -x1) %>%
    verify(has_all_names("x1", "cell_line", "score")) %>%
    verify(is.character(x1)) %>%
    verify(is.character(cell_line)) %>%
    verify(is.numeric(score))


#### ---- Gene Effect ---- ####
a <- read_csv(data_file_path("gene_effect_corrected.csv")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("x1")) %>%
    slice(5) %>%
    gather(key = "gene", value = "score", -x1) %>%
    verify(has_all_names("x1", "gene", "score")) %>%
    verify(is.character(x1)) %>%
    verify(is.character(gene)) %>%
    verify(is.numeric(score))


#### ---- Gene Dependency ---- ####
a <- read_csv(data_file_path("gene_dependency_corrected.csv")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("line")) %>%
    slice(5) %>%
    gather(key = "gene", value = "score", -line) %>%
    verify(has_all_names("line", "gene", "score")) %>%
    verify(is.character(line)) %>%
    verify(is.character(gene)) %>%
    verify(is.numeric(score))


#### ---- Gene Essentiality  ---- ####
a <- read_tsv(data_file_path("essential_genes.txt")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("gene"))
a <- read_tsv(data_file_path("nonessential_genes.txt")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("gene"))


#### ---- CNV ---- ####
a <- read_csv(data_file_path("public_19Q1_gene_cn.csv"),
                    col_types = cols(.default = "c")) %>%
    janitor::clean_names() %>%
    verify(has_all_names("x1")) %>%
    slice(5) %>%
    gather(key = "gene", value = "cn", -x1) %>%
    verify(has_all_names("x1", "gene", "cn")) %>%
    verify(is.character(x1)) %>%
    verify(is.character(gene)) %>%
    verify(is.character(cn))


#### ---- Guide Maps ---- ####
a <- read_csv("data/guide_gene_map.csv") %>%
    janitor::clean_names() %>%
    verify(has_all_names("sgrna", "genome_alignment", "gene", "n_alignments")) %>%
    verify(!is.na(sgrna)) %>%
    verify(!is.na(genome_alignment)) %>%
    verify(!is.na(gene)) %>%
    verify(!is.na(n_alignments)) %>%
    verify(n_alignments > 0)
