#!/usr/bin/env Rscript
library("optparse")

option_list = list(
  make_option(c("-g", "--grs_file"), type="character", default=NULL, 
              help="grs scores dataset file name", metavar="character"),
  make_option(c("-v", "--variables"), type="character", default=NULL, 
              help="alternative variables dataset file name", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

grs_file <- opt[[1]]
variables_file <- opt[[2]]

grs_scores <- read.table(grs_file, sep=",")
variables <- read.table(variables_file, sep=",")