#!/bin/bash

sm=$1
tr=$2
ou=$3

module load python
source activate rnaseq_basic

bedtools intersect -v -wa -a $tr -b $sm > $ou