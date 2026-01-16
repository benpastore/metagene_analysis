#!/bin/bash

b1=$1
b2=$2
ou=$3

module load miniconda3/24.1.2-py310
source activate rnaseq_basic

bedtools intersect -wo -a $b1 -b $b2 > $ou