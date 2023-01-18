# 0.read_data.R must be run first to create the necessary data frames

library(dplyr)
library(tidyr)


# Define/initialize necessary simulation components
# sample_aa_ancestry <- sample(1:9, num_alleles, replace = TRUE)
# ea_risk_allele_freqs <- sample(1:9, num_alleles, replace = TRUE)
# aa_risk_allele_freqs <- sample(1:9, num_alleles, replace = TRUE)
all_indiv <- list() # To be a list of dfs for each individual

# Subset data from 0.read_data.R
aa_ancestry <- variables$AFR_ances_prop  # African ancestry proportion
grs_scores <- select(as.tibble(grs_scoresFull), -c(1:6))  # Only GRS scores
num_alleles <- nrow(grs_scores)


generate_genotype <- function(chr_ancestry, allele) {
  genotypeCount <- 0
  for (ancestry_origin in chr_ancestry) {
    aa_risk <- aa_pop$risk_allele_freq[allele]
    if (chr_ancestry[ancestry_origin] == 0) {
      alleleChance <- runif(1, min=0, max=10)
      if (alleleChance <= aa_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
    else if (chr_ancestry[ancestry_origin] == 1) {
      alleleChance <- runif(1, min=0, max=10)
      ea_risk <- ea_pop$risk_allele_freq[allele]
      if (alleleChance <= ea_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
  }
  
  return(genotypeCount)
}

# Generate random alleles for N=100 individuals
for (i in 1:100) {
  individual <- data.frame(allele_num = 1:num_alleles)
  snps_genotype <- vector()
  
  # Generate snps
  for (allele in 1:num_alleles) {
    # initialize chromosome vector
    chromosomes <- vector()
    
    # Draw chromosomes based on global ancestry proportions
    for (chromosome in 1:2) {
      chr_draw <- runif(1, min=0, max=10)
      if (chr_draw <= sample_aa_ancestry[allele]) {
        chromosomes[chromosome] <- 0
      }
      else {
        chromosomes[chromosome] <- 1
      }
    }
    
    # 2 <- risk genotype
    # 1 <- heterozygous
    # 0 <- wild type
    genotypeCount <- generate_genotype(chr_ancestry = chromosomes,
                                       allele = allele)
    
    # Append genotype to simulated individual 
    snps_genotype <- append(snps_genotype, genotypeCount)
  }
  # Add genotype scores to df
  individual['snps'] <- snps_genotype
  # TODO calculate grs. Need dosage data
  # TODO add grs scores to df
  
  # Append invididual's data to population list
  all_indiv[[i]] <- individual
}
