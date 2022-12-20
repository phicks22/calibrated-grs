library(dplyr)
library(tidyr)


# Define/initialize necessary simulation components
sample_aa_ancestry <- sample(1:9, 320, replace = TRUE)
haplotype_1 <- list()
haplotype_2 <- list()
risk_allele_freqs <- sample(1:9, 320, replace = TRUE) / 10
all_indiv <- list() # To be a list of dfs for each individual

# Generate random alleles for N=100 individuals
for (i in 1:100) {
  individual <- data.frame()
  snps_genotype <- list()
  
  # Generate snps
  for (j in 1:length(risk_allele_freqs)) {
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
    # 2 <- risk genotype
    # 1 <- heterozygous
    # 0 <- wild type
    genotypeCount <- 0
    for (k in 1:2) {
      alleleChance <- runif(1, min=0, max=10)
      if (alleleChance <= risk_allele_freqs[j]) {
        genotypeCount = genotypeCount + 1
      }
    }
    # Append genotype to simulated individual 
    snps_genotype[j] <- genotypeCount
  }
}

# haplotype_1[[j]] = alleles[[sample(1:length(alleles), 1)]]
# haplotype_2[[j]] = alleles[[sample(1:length(alleles), 1)]]
# }
# # Assign randomly selected snps to an individual
# individual$hap1 <- haplotype_1
# individual$hap2 <- haplotype_2

