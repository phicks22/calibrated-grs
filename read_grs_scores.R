#!/usr/bin/env Rscript
library("optparse")

option_list = list(
  make_option(c("-gf", "--grs_file"), type="character", default=NULL, 
              help="grs scores dataset file name", metavar="character"),
  make_option(c("-aa", "--aa_ancestry"), type="character", default=NULL, 
              help="african ancestry dataset file name", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)