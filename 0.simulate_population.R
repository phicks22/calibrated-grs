library(dplyr)
library(tidyr)


args = commandArgs(trailingOnly=TRUE)

# Ensure all arguments are included in command line
if (length(args)==0) {
  stop("The following arguments are required: \n 
       1. grs scores dataset file name \n
       2. alternative variables dataset file name \n
       3. allele frequencies from African populations \n
       4. allele frequencies from European populations", 
       call.=FALSE)
}

# Set variable names to args
grs_file <- args[1]
variables_file <- args[2]
aa_pop_file <- args[3]
ea_pop_file <- args[4]

# Read data
grs_scoresFull <- read.table(grs_file, header = TRUE , sep=",")
variables <- read.table(variables_file, header = TRUE , sep=",")
aa_pop <- read.table(aa_pop_file, header = TRUE , sep=",")
ea_pop <- read.table(ea_pop_file, header = TRUE , sep=",")

# Subset data from 0.read_data.R
aa_ancestry <- variables$AFR_ances_prop  # African ancestry proportion
grs_scores <- select(as.tibble(grs_scoresFull), -c(1:6))  # Only GRS scores
num_alleles <- nrow(grs_scores)

# Initialize list of dfs for each individual
all_indiv <- list()

generate_genotype <- function(chr_ancestry, allele) {
  # Initialize genotype
  genotypeCount <- 0
  
  # Iterate through both chromosomes of an individual
  for (ancestry_origin in chr_ancestry) {
    aa_risk <- aa_pop$risk_allele_freq[allele]
    
    # If african chromosome:
    if (chr_ancestry[ancestry_origin] == 0) {
      alleleChance <- runif(1, min=0, max=10)
      # If risk allele present: 
      if (alleleChance <= aa_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
    # If european chromosome: 
    else if (chr_ancestry[ancestry_origin] == 1) {
      alleleChance <- runif(1, min=0, max=10)
      ea_risk <- ea_pop$risk_allele_freq[allele]
      # If risk allele present:
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
    # 0 = african chromosome
    # 1 = european chromosome
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
