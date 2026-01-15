# TCGA Lung Cancer Somatic Landscape Analysis

This repository contains a reproducible analysis pipeline for exploring
the mutational landscape of lung cancer using open-access TCGA datasets.
The goal of this project is to analyze and visualize somatic alterations
across LUAD (adenocarcinoma) and LUSC (squamous cell carcinoma), with a
special interest in differences between never-smokers and smokers.

The project demonstrates core research themes relevant to large-scale cancer
genomics:
- Somatic mutation profiling
- Mutational signature deconvolution
- Copy number alteration exploration
- Clinical and phenotype integration
- Reproducible analysis workflows

---

## 🚀 Project Objectives
1. Download TCGA LUAD/LUSC somatic mutation and clinical datasets
2. Summarize driver mutations and mutational burden patterns
3. Compare never-smoker vs smoker genomic differences (when metadata allows)
4. Extract and interpret mutational signatures (SBS)
5. Explore broad copy number alterations
6. Produce publication-quality figures and summary reports

---

## 🧬 Data Sources
This project uses open-access TCGA data via:
- Genomic Data Commons (GDC)
- UCSC Xena Public Data Hub
- TCGAbiolinks (R/Bioconductor)

No controlled-access data (*.bam/*fastq) is stored in this repo.

---

## 🛠️ Methods & Tools

### Languages
- **R** (Bioconductor)
- **Python** (mutational signatures / utilities)

### Key Packages
- `TCGAbiolinks`, `maftools`, `ComplexHeatmap`
- `SigProfilerExtractor`
- `GSVA`, `dplyr`, `ggplot2`

### Optional Extensions
- RNA–mutation integration
- GISTIC-like CNA analysis
- Cox models for survival

---

## 📁 Repository Structure
