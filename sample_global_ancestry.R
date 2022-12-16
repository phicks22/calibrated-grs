library(dplyr)
library(tidyr)

sample_aa_ancestry <- sample(1:9, 100, replace = TRUE) / 10
sample_grs_scores <- runif(100, min=-5, max=5)

# Define/initialize necessary simulation components
alleles <- list("C", "A")
risk_allele <- "C"
other_allele <- "A"
haplotype_1 <- list()
haplotype_2 <- list()
risk_allele_freqs <- sample(1:9, 320, replace = TRUE) / 10
population <- list()

# Generate random alleles for N=100 individuals
for (i in 1:100) {
  haplotype_1 <- list()
  haplotype_2 <- list()
  for (j in 1:320) {
    haplotype_1[[j]] = alleles[[sample(1:length(alleles), 1)]]
    haplotype_2[[j]] = alleles[[sample(1:length(alleles), 1)]]
  }
}


