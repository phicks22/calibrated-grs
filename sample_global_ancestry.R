library(dplyr)
library(tidyr)


# Define/initialize necessary simulation components
sample_aa_ancestry <- sample(1:9, 320, replace = TRUE)
alleles <- list("C", "A")
risk_allele <- "C"
other_allele <- "A"
haplotype_1 <- list()
haplotype_2 <- list()
risk_allele_freqs <- sample(1:9, 320, replace = TRUE) / 10
all_indiv <list()

# Generate random alleles for N=100 individuals
for (i in 1:100) {
  individual <- data.frame()
  haplotype_1 <- list()
  haplotype_2 <- list()
  
  # Generate snps
  for (j in 1:len(risk_allele_freqs)) {
    # initialize chromosome vector
    chromosomes <- vector()
    
    # Draw chromosomes based on global ancestry proportions
    for (chromosome in 1:2) {
      chr_draw <- runif(1, min=0, max=10)
      if (chr_draw <= sample_aa_ancestry[j]) {
        chromosomes[chromosome] <- "a"
      }
      else {
        chromosomes[chromosome] <- "e"
      }
    }
    haplotype_1[[j]] = alleles[[sample(1:length(alleles), 1)]]
    haplotype_2[[j]] = alleles[[sample(1:length(alleles), 1)]]
  }
  # Assign randomly selected snps to an individual
  individual$hap1 <- haplotype_1
  individual$hap2 <- haplotype_2
}

