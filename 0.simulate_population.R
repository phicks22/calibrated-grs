library(dplyr)
library(tidyr)


args = commandArgs(trailingOnly=TRUE)

# Ensure all arguments are included in command line
if (length(args)==0) {
  stop("The following arguments are required: \n 
       1. grs scores dataset file name \n
       2. weight and chromosome locations file name \n
       3. allele frequencies from African populations \n
       4. allele frequencies from European populations", 
       call.=FALSE)
}

# Set variable names to args
grs_file <- args[1]
weights_and_location_file <- args[2]
aa_pop_file <- args[3]
ea_pop_file <- args[4]

# Read data
AA_prs_scores <- read.table(grs_file, header = TRUE , sep=",")
weights_and_location <- read.table(
  weights_and_location_file, header = TRUE , sep=",")

aa_pop <- read.table(aa_pop_file, header = TRUE)
ea_pop <- read.table(ea_pop_file, header = TRUE)

# Remove unnecessary columns
aa_pop <- select(aa_pop, -c("CHR", "A1", "A2", "NCHROBS"))
ea_pop <- select(ea_pop, -c("CHR", "A1", "A2", "NCHROBS"))

# Distinguish AFR MAF from EUR MAF
colnames(aa_pop)[which(names(aa_pop) == "MAF")] <- "AFR_MAF"
colnames(ea_pop)[which(names(ea_pop) == "MAF")] <- "EUR_MAF"

all_pops <- merge(aa_pop, ea_pop)

colnames(all_pops)[which(names(all_pops) == "SNP")] <- "Index.SNV"


# Merge dfs to get both AFR and EUR MAF
weights_and_location <- merge(weights_and_location, all_pops)

# Subset data from 0.read_data.R
# aa_ancestry <- variables$AFR_ances_prop  # African ancestry proportion
# grs_scores <- select(as.tibble(grs_scoresFull), -c(1:6))  # Only GRS scores
num_alleles <- nrow(weights_and_location)
# Initialize list of dfs for each individual
all_indiv <- list()

generate_genotype <- function(chr_ancestry, allele) {
  # Initialize genotype
  genotypeCount <- 0
  
  # Iterate through both chromosomes of an individual
  for (ancestry_origin in 1:2) {
    aa_risk <- all_pops$AFR_MAF[allele]
    
    # If african chromosome:
    if (chr_ancestry[ancestry_origin] == 0) {
      alleleChance <- runif(1, min=0, max=1)
      # If risk allele present: 
      if (alleleChance <= aa_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
    # If european chromosome: 
    else if (chr_ancestry[ancestry_origin] == 1) {
      alleleChance <- runif(1, min=0, max=1)
      ea_risk <- all_pops$EUR_MAF[allele]
      # If risk allele present:
      if (alleleChance <= ea_risk) {
        genotypeCount = genotypeCount + 1
      }
    }
  }
  
  return(genotypeCount)
}

# Formatted to use apply()
simulate_population <- function(prs_score_df, num_samples=100) {
  id_ <- prs_score_df["IID"]
  afr_ancestry <- prs_score_df["AFR_ances_prop"]
  existing_prs <- prs_score_df["grs.wt"]
  existing_prs_std <- prs_score_df["grs.std.wt"]
  
  # Generate random alleles for N=100 individuals
  for (i in 1:num_samples) {
    individual <- data.frame(allele_num = 1:num_alleles)
    snps_genotype <- vector()
    beta <- weights_and_location$Beta
    
    # Generate snps
    for (allele in 1:num_alleles) {
      snp_loc <- weights_and_location$Risk_Label
      # initialize chromosome vector
      chromosomes <- vector()
      
      # Draw chromosomes based on global ancestry proportions
      # 0 = african chromosome
      # 1 = european chromosome
      for (chromosome in 1:2) {
        chr_draw <- runif(1, min=0, max=1)
        if (chr_draw <= afr_ancestry) {
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
    individual['Genotype'] <- snps_genotype
    individual["Risk_Label"] <- snp_loc
    individual["Beta"] <- beta

    # Calculate PRS score
    individual <- individual %>% mutate(gt_x_wt = Genotype * Beta)
    prs_score <- sum(individual$gt_x_wt)
    
    #standardized to center distribution on 0
    # grs.std.wt <- (grs.wt - mean(grs.wt))/sd(grs.wt)
    # Append invididual's data to population list
    all_indiv[[i]] <- prs_score
  }
  
  return(all_indiv)
}

apply(AA_prs_scores[1:10,], 1, FUN=simulate_population)
print(all_indiv)