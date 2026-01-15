#!/usr/bin/env Rscript

# 02_mutation_summary.R
# - Load TCGA LUAD/LUSC MAF objects from data/
# - Run basic somatic summary with maftools
# - Save oncoplots and TMB tables to results/

# ---- package check & install ----
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

if (!requireNamespace("maftools", quietly = TRUE)) {
  BiocManager::install("maftools", ask = FALSE, update = FALSE)
}

if (!requireNamespace("ComplexHeatmap", quietly = TRUE)) {
  install.packages("ComplexHeatmap", repos = "https://cloud.r-project.org")
}

if (!requireNamespace("glue", quietly = TRUE)) {
  install.packages("glue", repos = "https://cloud.r-project.org")
}

library(maftools)
library(ComplexHeatmap)
library(glue)

dir.create("results", showWarnings = FALSE)

projects <- c("TCGA-LUAD", "TCGA-LUSC")

for (proj in projects) {
  maf_path <- glue("data/{proj}_maf.rds")
  
  if (!file.exists(maf_path)) {
    message(glue("Skipping {proj}: {maf_path} not found"))
    next
  }
  
  message(glue("Loading MAF for {proj} ..."))
  maf_df <- readRDS(maf_path)
  
  # maftools can take a data.frame
  m <- read.maf(maf = maf_df)
  
  # ---- Oncoplot ----
  png(glue("results/{proj}_oncoplot_top20.png"),
      width = 1400, height = 1000, res = 120)
  oncoplot(maf = m, top = 20)
  dev.off()
  
  # ---- TMB ----
  tmb_tbl <- tmb(maf = m)
  write.csv(tmb_tbl,
            glue("results/{proj}_tmb.csv"),
            row.names = FALSE)
  
  # Optional: simple TMB histogram
  png(glue("results/{proj}_tmb_hist.png"),
      width = 800, height = 600, res = 120)
  hist(tmb_tbl$total_perMB,
       main = glue("{proj} Tumor Mutational Burden"),
       xlab = "Mutations per Mb")
  dev.off()
  
  message(glue("Done: {proj} summary saved in results/"))
}

message("🎉 All available projects processed.")
