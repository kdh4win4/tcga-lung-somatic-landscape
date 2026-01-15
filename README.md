# TCGA Lung Cancer Somatic Landscape Explorer
_A reproducible analysis of somatic alterations in TCGA LUAD/LUSC with a focus on smoking-associated genomic signatures._

## 🧬 Overview
This repository implements a lightweight but extensible workflow for analyzing
somatic alterations in lung cancer using openly accessible TCGA datasets.
The project highlights core components of large-scale cancer genomics:
- Somatic mutation profiling
- Mutational signature decomposition
- Copy-number alteration exploration
- Clinical phenotype integration
- Publication-ready visualization

While the Sherlock-Lung project focuses on never-smokers using deep multi-omics sequencing,
this repository demonstrates the same conceptual workflow using open TCGA cohorts.

---

## 🎯 Objectives
1. Retrieve somatic mutation and clinical metadata for TCGA LUAD/LUSC
2. Summarize mutation burden and recurrent driver events
3. Evaluate genomic differences linked to smoking history (pending metadata stratification)
4. Infer mutational processes via SBS signatures
5. Explore broad copy-number alterations
6. Produce interpretable figures and reports

---

## 📊 Expected Outputs
- Top mutated lung cancer genes (oncoplots)
- Tumor mutational burden distribution
- Smoking-associated signatures (e.g., SBS4)
- Copy-number gain/loss visualization
- Summary Rmarkdown report

---

## 📁 Repository Structure
~~~
scripts/        # Reproducible R/Python workflows
notebooks/      # Interactive data exploration
reports/        # Rmarkdown-based summaries
data/           # Placeholder; no raw TCGA data committed
environment.yml # Conda environment
~~~

---

## 🔧 Tools & Methods

### Core Languages
- **R** (primary)
- **Python** (support)

### Key Packages

**R**
- TCGAbiolinks  
- maftools  
- ComplexHeatmap  
- tidyverse  

**Python**
- SigProfilerExtractor  
- pandas  
- matplotlib  

---

## ▶️ Quickstart

### 1) Create the conda environment
~~~
conda env create -f environment.yml
conda activate tcga-lung
~~~

### 2) Download TCGA mutation + clinical data
~~~
Rscript scripts/01_download_tcga.R
~~~

### 3) Generate mutation summary
~~~
Rscript scripts/02_mutation_summary.R
~~~

### 4) Extract mutational signatures
~~~
python scripts/03_signature_analysis.py
~~~

### 5) (Optional) Copy-number analysis
~~~
Rscript scripts/04_cna_analysis.R
~~~

---

## 🚦 Notes
- No controlled-access data is stored or required  
- `data/` remains empty until analysis is run  
- Smoking-status integration coming soon  
- Does not require TCGA BAM/FASTQ  

---

## 📜 License
MIT License

---

## ✉️ Contact
**Author:** Dohoon Kim  
GitHub: https://github.com/kdh4win4
