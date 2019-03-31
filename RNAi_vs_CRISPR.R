############################################
## Compare RNAi and CRISPR screen results ##
############################################

library(tidyverse)

rnai <- readRDS(file.path("data", "rnai_synthetic_lethal.tib")) %>%
    dplyr::rename(RNAi_score = "score")
crispr <- readRDS(file.path("data", "gene_effect.tib")) %>%
    dplyr::rename(CRISPR_score = "CERES_score")


#### ---- Overview Plots ---- ####

rnai_select <- rnai %>%
    select(gene, DepMap_ID, RNAi_score) %>%
    na.omit()

crispr_select <- crispr %>%
    select(gene, DepMap_ID, CRISPR_score) %>%
    na.omit()

dat <- inner_join(rnai_select, crispr_select,
                  by = c("gene", "DepMap_ID"))

g <- dat %>%
    mutate(diff_scores = RNAi_score - CRISPR_score) %>%
    ggplot(aes(x = CRISPR_score, y = RNAi_score)) +
    geom_point(aes(color = diff_scores), size = 0.2) +
    geom_hline(yintercept = 0, color = "grey50") +
    geom_vline(xintercept = 0, color = "grey50") +
    geom_abline(aes(intercept = 0, slope = 1),
                color = "grey25", linetype = 2) +
    scale_color_gradient2(low = "dodgerblue", high = "tomato", mid = "grey95") +
    theme_bw() +
    labs(x = "CRISPR screen score",
         y = "RNAi screen score",
         title = "Difference between CRISPR and RNAi scores")
ggsave(filename = file.path("images", "diff_RNAi_CRISPR_individual.png"),
       plot = g,
       width = 7.5, height = 5.7, dpi = 200, units = "in")

rnai_disease <- rnai %>%
    group_by(gene, Primary_Disease) %>%
    mutate(avg_rnai = mean(RNAi_score)) %>%
    ungroup() %>%
    na.omit()

crispr_disease <- crispr %>%
    group_by(gene, Primary_Disease) %>%
    mutate(avg_crispr = mean(CRISPR_score)) %>%
    ungroup() %>%
    na.omit()

dat_disease <- inner_join(rnai_disease, crispr_disease,
                          by = c("gene", "DepMap_ID"))

g <- dat_disease %>%
    mutate(diff_scores = avg_rnai - avg_crispr) %>%
    ggplot(aes(x = avg_crispr, y = avg_rnai)) +
    geom_point(aes(color = diff_scores), size = 0.2) +
    geom_hline(yintercept = 0, color = "grey50") +
    geom_vline(xintercept = 0, color = "grey50") +
    geom_abline(aes(intercept = 0, slope = 1),
                color = "grey25", linetype = 2) +
    scale_color_gradient2(low = "dodgerblue", high = "tomato", mid = "grey95") +
    theme_bw() +
    labs(x = "CRISPR screen score",
         y = "RNAi screen score",
         title = "Difference between CRISPR and RNAi scores",
         subtitle = "scores were average for each disease")
ggsave(filename = file.path("images", "diff_RNAi_CRISPR_avg.png"),
       plot = g,
       width = 7.5, height = 5.7, dpi = 200, units = "in")


#### ---- High CRISPR, low RNAi Outliers ---- ####

# outliers as a CRISPR score of at least 1
dat %>%
    filter(CRISPR_score >= 1) %>%
    group_by(gene) %>%
    summarise(n_cells = n_distinct(DepMap_ID)) %>%
    ungroup() %>%
    arrange(desc(n_cells))

outliers <- dat %>%
    filter(CRISPR_score >= 1) %>%
    pull(gene) %>%
    unique()

 g <- dat %>%
    filter(gene %in% outliers) %>%
    mutate(diff_scores = RNAi_score - CRISPR_score) %>%
    ggplot(aes(x = CRISPR_score, y = RNAi_score)) +
    geom_point(aes(color = diff_scores), size = 0.2) +
    geom_hline(yintercept = 0, color = "grey50") +
    geom_vline(xintercept = 0, color = "grey50") +
    geom_abline(aes(intercept = 0, slope = 1),
                color = "grey25", linetype = 2) +
    scale_color_gradient2(low = "dodgerblue", high = "tomato", mid = "grey95") +
    theme_bw() +
    labs(x = "CRISPR screen score",
         y = "RNAi screen score",
         title = "The distribution of scores of \"outlier\" genes")
ggsave(filename = file.path("images", "diff_RNAi_CRISPR_outliers.png"),
       plot = g,
       width = 6, height = 4, dpi = 200, units = "in")

copynum <- readRDS(file.path("data", "cell_line_copy_number.tib"))
copynum_select <- copynum %>%
    dplyr::select(gene, DepMap_ID, copy_number)

# CRISPR score vs. copy number
outlier_dat <- dat %>%
    filter(gene %in% outliers) %>%
    left_join(copynum_select, by = c("gene", "DepMap_ID"))

minmax <- function(x, lower, upper) {
    if (is.na(x)) return(x)
    return(min(max(x, lower), upper))
}

g <- outlier_dat %>%
    mutate(copy_number = map_dbl(copy_number, minmax, lower = -2, upper = 2)) %>%
    ggplot(aes(x = CRISPR_score, y = RNAi_score)) +
    geom_point(aes(color = copy_number), size = 0.2) +
    geom_hline(yintercept = 0, color = "grey50") +
    geom_vline(xintercept = 0, color = "grey50") +
    geom_abline(aes(intercept = 0, slope = 1),
                color = "grey25", linetype = 2) +
    scale_color_gradient2(low = "dodgerblue", high = "tomato", mid = "grey95",
                          na.value = "black") +
    theme_bw() +
    labs(x = "CRISPR screen score",
         y = "RNAi screen score",
         title = "The distribution of scores of \"outlier\" genes",
         subtitle = "black points have no copy number information")
ggsave(filename = file.path("images", "diff_RNAi_CRISPR_outliers_copynum.png"),
       plot = g,
       width = 6, height = 4, dpi = 200, units = "in")
