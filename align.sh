#!/bin/bash

# This is the first step in the metagene pipeline. 
# First we must align the reads to the metagenome and genome
# to assign reads coordinates and preform normalization.

# path to run script to preform alignment and normalization
s=/fs/ess/PCON0160/ben/pipelines/nextflow_smRNA/workflows/smRNA/run.sh

# parameters
profile='cluster'
design='/fs/ess/PAS1473/znfx1_CSRIP_WAGO9IP/design.txt'
results='/fs/ess/PAS1473/znfx1_CSRIP_WAGO9IP/metagene_alignment'
features=false
contaminant='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.xk.fa'
tailor=false
transcripts='/fs/ess/PCON0160/ben/pipelines/nextflow_metagene/transcripts.txt'
genome='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.genomic.fa'
junctions='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.genomic.transcripts.juncs.fa'
dge=false
format='fastq' # or fasta

sh $s \
    -profile $profile \
    --design $design \
    --results $results \
    --outprefix analysis \
    --features $features \
    --contaminant $contaminant \
    --tailor $tailor \
    --transcripts $transcripts \
    --dge $dge \
    --format $format