#!/bin/bash

bed=$1
ou=$2

module load miniconda3/24.1.2-py310
source activate rnaseq_basic

cat $bed | sort -k1,1 -k3,3nr > tmp.bed

cat tmp.bed | awk -F'\t' '{OFS="\t"; if ( ($2-10)>=0 )print $1,$2-10,$3,$4,$5,$6; else print $1,0,$3,$4,$5,$6 }' > tmp.pad.bed

bedtools intersect -wo -a tmp.pad.bed -b tmp.bed |\
    awk '($4!=$10)' |\
    awk '($3>$9)' |\
    awk -F'\t' '{OFS="\t"; print $0,($3-length($4))-$9 }' > $ou
