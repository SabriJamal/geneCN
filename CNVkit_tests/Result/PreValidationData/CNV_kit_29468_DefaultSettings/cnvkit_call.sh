#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
bed_path="/mnt/lustre/genome/hg19/bedfiles"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

sample_tumour=$1
sample_blood=$2


if [[ ! -d $mydirec/Result/CNV_kit_$id ]];
then
	mkdir $mydirec/Result/CNV_kit_$id
else
	exit 1
fi


python $cnv_kit_path/cnvkit.py batch $mydirec/test_data/$sample_tumour.sort.bam --normal $mydirec/test_data/$sample_blood.sort.bam \
	--targets $bed_path/panel_GSIC.v1.bed \
	--fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
	--access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
	--output-reference $mydirec/Result/CNV_kit_$id/$sample_blood.reference.cnn --output-dir $mydirec/Result/CNV_kit_$id \
	--diagram --scatter

cp $mydirec/$script_name $mydirec/Result/CNV_kit_$id/.
