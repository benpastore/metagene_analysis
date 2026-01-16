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

# define targets of all mutants based on IP / input or 22G loss in mutants
# plot sense vs. antisense counts boxplot
IP_to_input = read.delim("/fs/ess/PCON0160/ben/projects/claycomb_argonomics/IP_to_input.txt")

counts = read.delim("/fs/ess/PCON0160/ben/projects/claycomb_argonomics/results/master_tables/claycomb_argonomics.aligned.v0.m1000.count_total_norm.tsv", check.names = F)

counts_long = counts %>% 
  pivot_longer(!c(gene_name, seq_id, locus_id, biotype, class, feature), names_to = 'sample', values_to = 'count')

IP = counts_long %>% 
  filter(grepl("IP", sample)) %>% 
  dplyr::rename(IP_rpm = count)

input = counts_long %>% 
  filter(grepl("input", sample)) %>% 
  left_join(IP_to_input, by = c("sample" = "input")) %>% 
  drop_na() %>% 
  dplyr::rename(input_rpm = count) %>% 
  select(gene_name, input_rpm, IP)

IP_vs_input = IP %>% 
  filter(feature == "siRNA" | feature == "sense_transcripts") %>% 
  left_join(input, by = c("sample" = "IP", "gene_name")) %>% 
  mutate(ratio = log2( (IP_rpm+0.1) / (input_rpm + 0.1)) )%>% 
  drop_na()

IP_vs_input %>% head()

p = ggplot(data = IP_vs_input, aes(x = reorder(sample, -ratio, FUN=median), y = ratio)) + 
  geom_boxplot() + 
  my_theme() + 
  theme(aspect.ratio = 0.5, 
        axis.text.x = element_text(angle = 60, vjust = 0.5)) + 
  facet_wrap(~feature, nrow = 2) + 
  geom_hline(yintercept = 0, color = "red", lty = 2, alpha = 0.8)

ggsave(p, filename = "sense_vs_anti_ratio.png", dpi = 300, height = 20, width = 20)

# plot IP/input sense reads 
replicates = read.delim("/fs/ess/PCON0160/ben/projects/claycomb_argonomics/results_0329/samples/replicates.csv", sep = ",")

IP_input_grouped = IP_vs_input %>% 
  left_join(replicates, by = c("sample" = "simple_name")) %>% 
  group_by(locus_id, condition, feature) %>% 
  summarise(IP = mean(IP_rpm), input = mean(input_rpm), ratio = mean(ratio))


IP_input_grouped %>%
  filter(feature == "siRNA") %>% 
  group_by(condition, feature) %>% 
  filter(IP > 10) %>% 
  top_n(1, wt = ratio)

p = ggplot(data = IP_input_grouped, aes(x = input, y = IP)) + 
  geom_point(size = 0.1, alpha = 0.5, color = 'black') + 
  my_theme() + 
  theme(aspect.ratio = 1) + 
  facet_wrap(~sample) + 
  geom_abline(slope = 1, intercept = 0, lty = "solid", color = "red", alpha = 1, lwd = 0.5) +
  geom_abline(slope = 1, intercept = 2, lty = "dashed", color = "red", alpha = 1, lwd = 0.5) + 
  geom_abline(slope = 1, intercept = -2, lty = "dashed", color = "red", alpha = 1, lwd = 0.5) + 
  scale_y_continuous( limits = c(2^-10, 2^15),
    trans = "log2",
    labels = trans_format("log2", math_format(2^.x)),
    breaks = trans_breaks("log2", function(x) 2^x)) + 
  scale_x_continuous(limits = c(2^-10, 2^15),
    trans = "log2",
    labels = trans_format("log2", math_format(2^.x)),
    breaks = trans_breaks("log2", function(x) 2^x)) + 
  facet_wrap(~condition*feature, ncol = 4)
ggsave(p, filename = "siRNA_IP_vs_Input.png", dpi = 300, height = 40, width = 15)

p = ggplot(data = IP_vs_input %>% filter(feature == "sense_transcripts"), aes(x = input_rpm, y = IP_rpm)) + 
  geom_point(size = 0.1, alpha = 0.5, color = 'grey50') + 
  my_theme() + 
  theme(aspect.ratio = 1) + 
  facet_wrap(~sample) + 
  geom_abline(slope = 1, intercept = 0, lty = "solid", color = "red", alpha = 1, lwd = 0.5) +
  geom_abline(slope = 1, intercept = 2, lty = "dashed", color = "red", alpha = 1, lwd = 0.5) + 
  geom_abline(slope = 1, intercept = -2, lty = "dashed", color = "red", alpha = 1, lwd = 0.5) + 
  scale_y_continuous( limits = c(2^-10, 2^15),
                      trans = "log2",
                      labels = trans_format("log2", math_format(2^.x)),
                      breaks = trans_breaks("log2", function(x) 2^x)) + 
  scale_x_continuous(limits = c(2^-10, 2^15),
                     trans = "log2",
                     labels = trans_format("log2", math_format(2^.x)),
                     breaks = trans_breaks("log2", function(x) 2^x)) + 
  facet_wrap(~sample)
ggsave(p, filename = "sense_transcripts_IP_vs_Input.png", dpi = 300, height = 30, width = 30)





