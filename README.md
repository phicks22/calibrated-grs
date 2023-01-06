# Calibrated GRS scores for underrepresented GWAS groups

## Purpose

Genetic risk scores (GRSs) are used today in precision medicine to assess an individual's risk for acquiring a genetic disorder. When incorporated into healthcare practices, GRSs can aid physicians in reducing the burden of disease and suggesting preventive treatments. However, GRSs for individuals of non-European ancestry are known to be inaccurate predictions of genetic risk due to oversampling of individuals with European ancestry in genome-wide association studies (GWAS). The present inaccuracies are suggested to even exacerbate existing health disparities in groups of non-European ancestry.

Here, we present a method to calibrate GRSs for groups of African American (AA) ancestry by generating a separate GRS distribution for each individual based on estimated global ancestries

## Read in your GRS and variables data

First, we must read in the data. Run the following command in your terminal to read the GRS and variables `.txt` files.

``` bash
Rscript 0.read_data.R -g <GRS_file.txt> -v <variables_file.txts>
```
