library(dplyr)
library(tidyr)


# Define/initialize necessary simulation components
sample_aa_ancestry <- sample(1:9, 320, replace = TRUE)
haplotype_1 <- list()
haplotype_2 <- list()
ea_risk_allele_freqs <- sample(1:9, 320, replace = TRUE)
aa_risk_allele_freqs <- sample(1:9, 320, replace = TRUE)
all_indiv <- list() # To be a list of dfs for each individual


generate_genotype <- function(chr_ancestry, aa_risk, ea_risk) {
  genotypeCount <- 0
  for (k in 1:2) {
    
    if (chr_ancestry[k] == "a") {
      alleleChance <- runif(1, min=0, max=10)
      if (alleleChance <= aa_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
    else {
      alleleChance <- runif(1, min=0, max=10)
      if (alleleChance <= ea_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
  }
  
  return(genotypeCount)
}

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
    genotypeCount <- generate_genotype(chr_ancestry = chromosomes, 
                                      aa_risk = aa_risk_allele_freqs[j], 
                                       ea_risk = aa_risk_allele_freqs[j])
    
    # Append genotype to simulated individual 
    snps_genotype[j] <- genotypeCount
  }
  # Add genotype scores to df
  individual$snps <- snps_genotype
  # TODO calculate grs. Need dosage data
  # TODO add grs scores to df
}
