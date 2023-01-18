#!/usr/bin/env Rscript
library("optparse")
library(dplyr)

option_list = list(
  make_option(c("-g", "--grs_file"), type="character", default=NULL, 
              help="grs scores dataset file name", metavar="character"),
  make_option(c("-v", "--variables"), type="character", default=NULL, 
              help="alternative variables dataset file name", metavar="character"),
  make_option(c("-a", "--african_pop"), type="character", default=NULL, 
              help="allele frequencies from African populations to simulate 
              'fake' population", metavar="character"),
  make_option(c("-e", "--european_pop"), type="character", default=NULL, 
              help="allele frequencies from European populations to simulate 
              'fake' population", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

grs_file <- opt[[1]]
variables_file <- opt[[2]]
aa_pop_file <- opt[[3]]
ea_pop_file <- opt[[4]]

grs_scoresFull <- read.table(grs_file, header = TRUE , sep=",")
variables <- read.table(variables_file, header = TRUE , sep=",")
aa_pop <- read.table(aa_pop_file, header = TRUE , sep=",")
ea_pop <- read.table(ea_pop_file, header = TRUE , sep=",")