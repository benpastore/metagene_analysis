library(ggpubr)
library(tidyverse)
library(ggplot2)
library(lemon)
library(scales)
library(RColorBrewer)
library(ggrepel)
library(ggpmisc)
library(ggseqlogo)
library(rstatix)
library(ggdist)

source("/fs/ess/PCON0160/ben/bin/mighty.R")

dat = read.delim("test.tsv")
dat$sample = gsub(".trimmed.uniq.xc.v0.m1000.transcripts", "", dat$sample)

p = ggplot(data = dat, aes(x = dist, y = anti_zscore)) + 
  geom_bar(stat = 'identity', fill = "black", color = "white") + 
  facet_wrap(~sample*id, scales = "free", ncol = 3)
ggsave(p, filename = "test.pdf", dpi = 300, height = 40, width = 15)
