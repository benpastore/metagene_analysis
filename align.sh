#!/bin/bash

# This is the first step in the metagene pipeline. 
# First we must align the reads to the metagenome and genome
# to assign reads coordinates and preform normalization.

# path to run script to preform alignment and normalization
s=/fs/ess/PCON0160/ben/pipelines/nextflow_smRNA/workflows/smRNA/run.sh

# parameters
profile='cluster'
#design='/fs/ess/PAS1473/deep_sequencing/drh3_gu_mol_cell/design.txt'
#results='/fs/ess/PAS1473/deep_sequencing/drh3_gu_mol_cell/metagene'

design='/fs/ess/PCON0160/ben/projects/antisense_piRNA/antisense_piRNA_design.txt'
results='/fs/ess/PCON0160/ben/projects/antisense_piRNA/metagene'
features=false
contaminant='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.xk.fa'
tailor=false
transcripts='/fs/ess/PCON0160/ben/pipelines/metagene_analysis/transcripts.txt'
genome='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.genomic.fa'
junctions='/fs/ess/PCON0160/ben/genomes/c_elegans/WS279/c_elegans.PRJNA13758.WS279.genomic.transcripts.juncs.fa'
dge=false
format='fasta'

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
    --artifacts_filter "true" \
    --format $format #--adapter "CTGTAG"