#!/usr/bin/env Rscript

# 03_tmb_smoking_summary.R
# - Join TMB with clinical metadata
# - Extract smoking-related info (if available)
# - Summarize TMB by smoking group
# - Save CSV + simple boxplots

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("glue", quietly = TRUE)) {
  install.packages("glue", repos = "https://cloud.r-project.org")
}

library(dplyr)
library(ggplot2)
library(glue)

dir.create("results", showWarnings = FALSE)

projects <- c("TCGA-LUAD", "TCGA-LUSC")

for (proj in projects) {
  message(glue("Processing {proj} ..."))
  
  tmb_path  <- glue("results/{proj}_tmb.csv")
  clin_path <- glue("data/{proj}_clinical.csv")
  
  if (!file.exists(tmb_path) || !file.exists(clin_path)) {
    message(glue("  Skipping {proj}: missing TMB or clinical file"))
    next
  }
  
  tmb  <- read.csv(tmb_path, stringsAsFactors = FALSE)
  clin <- read.csv(clin_path, stringsAsFactors = FALSE)
  
  # maftools::tmb output usually has Tumor_Sample_Barcode
  if (!"Tumor_Sample_Barcode" %in% colnames(tmb)) {
    message(glue("  Skipping {proj}: no Tumor_Sample_Barcode in TMB"))
    next
  }
  
  # Derive patient ID (first 12 chars of TCGA barcode)
  tmb <- tmb %>%
    mutate(
      patient_id = substr(Tumor_Sample_Barcode, 1, 12)
    )
  
  # Try to detect a smoking-related column in clinical
  smok_cols <- grep("smok|tobacco", names(clin), ignore.case = TRUE, value = TRUE)
  
  if (length(smok_cols) == 0) {
    message(glue("  No smoking-related column found in clinical for {proj}."))
    next
  }
  
  # Use the first smoking column as label
  smok_col <- smok_cols[1]
  message(glue("  Using smoking column: {smok_col}"))
  
  # Standardize patient ID column name in clinical
  id_cols <- c("bcr_patient_barcode", "case_submitter_id", "patient_id")
  id_col  <- id_cols[id_cols %in% names(clin)][1]
  
  if (is.na(id_col)) {
    message(glue("  No obvious patient ID column in clinical for {proj}."))
    next
  }
  
  clin_clean <- clin %>%
    mutate(patient_id = !!as.name(id_col)) %>%
    select(patient_id, !!as.name(smok_col))
  
  # Join TMB + smoking
  dat <- tmb %>%
    left_join(clin_clean, by = "patient_id") %>%
    rename(smoking_status = !!smok_col)
  
  # Simple cleaning of smoking_status
  dat <- dat %>%
    mutate(
      smoking_status = trimws(as.character(smoking_status)),
      smoking_group = case_when(
        is.na(smoking_status) ~ "Unknown",
        grepl("never", smoking_status, ignore.case = TRUE) ~ "Never",
        grepl("former|ex-", smoking_status, ignore.case = TRUE) ~ "Former",
        grepl("current", smoking_status, ignore.case = TRUE) ~ "Current",
        TRUE ~ "Other"
      )
    )
  
  # Save joined table
  out_csv <- glue("results/{proj}_tmb_with_smoking.csv")
  write.csv(dat, out_csv, row.names = FALSE)
  
  # Summaries
  summary_tbl <- dat %>%
    group_by(smoking_group) %>%
    summarise(
      n = n(),
      median_tmb = median(total_perMB, na.rm = TRUE),
      mean_tmb   = mean(total_perMB, na.rm = TRUE)
    ) %>%
    arrange(desc(n))
  
  out_summary <- glue("results/{proj}_tmb_smoking_summary.csv")
  write.csv(summary_tbl, out_summary, row.names = FALSE)
  
  # Boxplot
  out_png <- glue("results/{proj}_tmb_by_smoking.png")
  png(out_png, width = 900, height = 600, res = 120)
  print(
    ggplot(dat, aes(x = smoking_group, y = total_perMB)) +
      geom_boxplot(outlier.size = 0.8) +
      theme_bw() +
      labs(
        title = glue("{proj} TMB by smoking group"),
        x = "Smoking group",
        y = "TMB (mutations per Mb)"
      )
  )
  dev.off()
  
  message(glue("  Saved: {out_csv}, {out_summary}, {out_png}"))
}

message("🎉 TMB + smoking summary completed (where metadata available).")
