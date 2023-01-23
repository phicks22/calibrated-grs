# Calibrated GRS scores for underrepresented GWAS groups

## Purpose

Genetic risk scores (GRSs) are used today in precision medicine to assess an individual's risk for acquiring a genetic disorder. When incorporated into healthcare practices, GRSs can aid physicians in reducing the burden of disease and suggesting preventive treatments. However, GRSs for individuals of non-European ancestry are known to be inaccurate predictions of genetic risk due to oversampling of individuals with European ancestry in genome-wide association studies (GWAS). The present inaccuracies are suggested to even exacerbate existing health disparities in groups of non-European ancestry.

Here, we present a method to calibrate GRSs for groups of African American (AA) ancestry by generating a separate GRS distribution for each individual based on estimated global ancestries


## Simulate the population

We need to read in the data and simulate a population representative of an individual of African Ancestry. The ``1.simulate_population.R` script will generate a simulated population for each individual in the target data set using the ancestry and target data saved from `0.read_data.R`.

``` bash
Rscript 1.simulate_population.R <GRS_file.txt> <variables_file.txts> <1KGenomes_AFR_file.txt> <G1KGenomes_EURO_file.txt>
```