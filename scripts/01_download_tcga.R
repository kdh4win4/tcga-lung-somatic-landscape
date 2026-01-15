#!/usr/bin/env Rscript

# TCGA LUAD/LUSC mutation + clinical downloader
# Uses current TCGAbiolinks API (without GDCquery_Maf)

if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) {
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
    BiocManager::install("TCGAbiolinks")
}
if (!requireNamespace("glue", quietly = TRUE)) {
    install.packages("glue", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr", repos = "https://cloud.r-project.org")
}

library(TCGAbiolinks)
library(dplyr)
library(glue)

dir.create("data", showWarnings = FALSE)

projects <- c("TCGA-LUAD", "TCGA-LUSC")

for (proj in projects) {
    message(glue("Querying MAF for {proj} ..."))

    query <- GDCquery(
        project      = proj,
        data.category = "Simple Nucleotide Variation",
        data.type     = "Masked Somatic Mutation",
        access        = "open",
        workflow.type = "Aliquot Ensemble Somatic Variant Merging and Masking"
    )

    GDCdownload(query)
    maf <- GDCprepare(query)

    saveRDS(maf, file = glue("data/{proj}_maf.rds"))

    message(glue("Downloading clinical metadata for {proj} ..."))
    clin <- GDCquery_clinic(project = proj, type = "clinical")
    write.csv(clin, glue("data/{proj}_clinical.csv"), row.names = FALSE)
}

message("🎉 Done! MAF + clinical saved in /data")
