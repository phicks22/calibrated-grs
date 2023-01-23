#!/usr/bin/env Rscript
library(dplyr)

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

grs_file <- args[1]
variables_file <- args[2]
aa_pop_file <- args[3]
ea_pop_file <- args[4]

grs_scoresFull <- read.table(grs_file, header = TRUE , sep=",")
variables <- read.table(variables_file, header = TRUE , sep=",")
aa_pop <- read.table(aa_pop_file, header = TRUE , sep=",")
ea_pop <- read.table(ea_pop_file, header = TRUE , sep=",")