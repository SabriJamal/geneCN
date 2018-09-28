#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

sample_tumour=$1
sample_blood=$2
experiment=$3


if [[ ! -d $mydirec/Result/CNV_kit_$experiment\_$id ]];
then
	mkdir $mydirec/Result/CNV_kit_$experiment\_$id
else
	exit 1
fi

echo $mydirec/Result/CNV_kit_$experiment\_$id

python $cnv_kit_path/cnvkit.py batch $sample_tumour --normal $sample_blood \
	--targets $mod_bed_path/panel_PAED_V2_NoTEL_NoCEN.bed \
	--fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
	--access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
	--output-reference $mydirec/Result/CNV_kit_$experiment\_$id/$sample_blood.reference.cnn --output-dir $mydirec/Result/CNV_kit_$experiment\_$id \
	--diagram --scatter

cp $mydirec/$script_name $mydirec/Result/CNV_kit_$experiment\_$id/.
