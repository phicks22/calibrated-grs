library(ROCR)
library(dplyr)
library(stringr)
library(stringi)
library(PredictABEL)

# TODO organize this

args = commandArgs(trailingOnly=TRUE)

# Ensure all arguments are included in command line
if (length(args)==0) {
  stop("The following arguments are required: \n 
       1. grs scores dataset file name \n
       2. weight and chromosome locations file name \n
       3. African ancestry proportion dataset (AA variables)",
       call.=FALSE)
}

GRS_alleles_dose <- args[1]
Diam_Trans_bp38 <- args[2]
ancestry_file <- args[3]

GRS_alleles_dose <- read.table(GRS_alleles_dose, header=TRUE, sep = ',')
Diam_Trans_bp38 <- read.table(Diam_Trans_bp38, header=TRUE, sep = '\t')
IID <- GRS_alleles_dose$IID
GRS_alleles_dose <- select(GRS_alleles_dose, -c(1:6))

#create dataframe of risk allele labels (the SNP names in the dosage file)
allele_names <- data.frame(colnames(GRS_alleles_dose))
names(allele_names)[1] <- 'Risk_Label'
#add column with bp38 location. This will be used for joining labels to PRS
allele_names$bp38 <- gsub('chr(\\d+\\:\\d+)\\:.*','\\1',allele_names$Risk_Label)
Diam_Trans_bp38$bp38 <- str_c("chr", Diam_Trans_bp38$bp38, ".", Diam_Trans_bp38$Risk_Allele, ".", Diam_Trans_bp38$Other_Allele, '_', Diam_Trans_bp38$Risk_Allele)
Diam_Trans_bp38$bp38 <- stri_replace_first(Diam_Trans_bp38$bp38, fixed=":", ".")

#combine labels and PRS
Diam_Trans_bp38 <- merge(Diam_Trans_bp38, allele_names)
# print(Diam_Trans_bp38FU)
#check for duplicates
Diam_Trans_bp38[duplicated(Diam_Trans_bp38$bp38), ]
#for larger PRSs, you'd actually need to code this, but in this case, you're just removing chr1:213977478:G:A_C and chr17:37739961:AATTT:A_AATTT
Diam_Trans_bp38 <- Diam_Trans_bp38[!(Diam_Trans_bp38$Risk_Label=="chr1:213977478:G:A_C" |
                                       Diam_Trans_bp38$Risk_Label=="chr17:37739961:AATTT:A_AATTT"),]

write.table(Diam_Trans_bp38, file = "data/weights&loc.txt",
            sep = ",")

#capture snps & dosages that are present in Risk_Label
snp.wts <- dplyr::select(GRS_alleles_dose, one_of(Diam_Trans_bp38$Risk_Label))
#identify which column your using as the weight and label it
beta.est <- Diam_Trans_bp38$Beta
names(beta.est) <- Diam_Trans_bp38$Risk_Label
#predictABEL will calculate the score for each individual in dataset
grs.wt <- riskScore(weights = beta.est, data = GRS_alleles_dose,
                    cGenPreds = which(names(GRS_alleles_dose) %in% names(beta.est)),
                    Type = "weighted")
#standardized to center distribution on 0
grs.std.wt <- (grs.wt - mean(grs.wt))/sd(grs.wt)

# Get ancestry data
# ancestry_file <- "data/AA_Diabetes_Variables_REGARDS.txt"
# ancestry <- read.table(ancestry_file, header = TRUE , sep=",")
# ancestry <- select(ancestry, c("IID", "AFR_ances_prop"))

end_df <- data.frame("grs.std.wt" = grs.std.wt, "grs.wt" = grs.wt, "IID" = IID)

print(end_df)
write.table(end_df, file = "data/grs_init.txt",
            sep = ",")
