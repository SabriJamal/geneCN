#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)
cnv_kit_path="/Users/sjamal/Documents/Work/2.scripts/CNVkit/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

#*_tumour=$1
#pooled_ref=$2
#vcf=$3
#target_bed=$4
#experiment=$5

#Find break points
python $cnv_kit_path/cnvkit.py breaks $mydirec/../*cnr $mydirec/../*cns > $mydirec/gene-breaks.txt #| cut -f1 | sort -u > $mydirec/gene-breaks.txt

#Identify genes with copy number gain or loss above threshold (0.2 for pure tumour)
python $cnv_kit_path/cnvkit.py genemetrics $mydirec/../*cnr -s $mydirec/../*cns -t 0.4 -m 5 -y > gene_CNA_events.txt

##Identify genes with copy number gain or loss above threshold and plots each gene
#python $cnv_kit_path/cnvkit.py genemetrics -y $mydirec/../*.cnr -s $mydirec/../*.cns | tail -n+2 | cut -f1 | sort > $mydirec/segment-genes.txt
#python $cnv_kit_path/cnvkit.py genemetrics -y $mydirec/../*.cnr | tail -n+2 | cut -f1 | sort > $mydirec/ratio-genes.txt
#comm -12 $mydirec/ratio-genes.txt $mydirec/segment-genes.txt > $mydirec/trusted-genes.txt
#for gene in `cat trusted-genes.txt`
#do
#    python $cnv_kit_path/cnvkit.py scatter -s $mydirec/../*.cn{s,r} -g $gene -o $mydirec/*-$gene-scatter.pdf
#done

#Investigating noise by looking at spread of bin-level log2 ratios
python $cnv_kit_path/cnvkit.py metrics $mydirec/../*.cnr -s $mydirec/../*.cns > Noise.txt

#Investigating noise segments
python $cnv_kit_path/cnvkit.py segmetrics $mydirec/../*.cnr -s $mydirec/../*.cns --iqr --median --mean --std --mad --bivar --mse --ci > Noise_per_segement.txt




#cp $mydirec/$script_name $mydirec/Result/CNV_kit_$experiment\_$id/.

#####################################
## Writing called script to folder ##
#####################################
#cat << EOF > $mydirec/Result/CNV_kit_$experiment\_$id/cnvkit_call_pooled_ref.out.sh
#
#EOF
