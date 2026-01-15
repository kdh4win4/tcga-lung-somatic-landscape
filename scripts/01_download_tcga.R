#!/usr/bin/env Rscript

# TCGA LUAD/LUSC mutation + clinical downloader
# Uses TCGAbiolinks (base + Mutect2 MAF)

if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) {
    install.packages("TCGAbiolinks", repos="https://cloud.r-project.org")
}
if (!requireNamespace("glue", quietly = TRUE)) {
    install.packages("glue", repos="https://cloud.r-project.org")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr", repos="https://cloud.r-project.org")
}

library(TCGAbiolinks)
library(dplyr)
library(glue)

dir.create("data", showWarnings = FALSE)

projects <- c("TCGA-LUAD", "TCGA-LUSC")

for (proj in projects) {
    message(glue("Downloading MAF for {proj} ..."))
    maf <- GDCquery_Maf(tumor = proj, pipelines = "mutect2")
    saveRDS(maf, file = glue("data/{proj}_mutect2_maf.rds"))

    message(glue("Downloading clinical metadata for {proj} ..."))
    clin <- GDCquery_clinic(project = proj, type = "clinical")
    write.csv(clin, glue("data/{proj}_clinical.csv"), row.names = FALSE)
}

message("🎉 Done! Files saved in /data")
