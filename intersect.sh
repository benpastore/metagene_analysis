#!/bin/bash

b1=$1
b2=$2
ou=$3

module load python
source activate rnaseq_basic

bedtools intersect -wo -a $b1 -b $b2 > $ou