#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
bed_path="/mnt/lustre/genome/hg19/bedfiles"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

if [[ ! -d $mydirec/Result/CNV_kit_$id ]];
then
	mkdir $mydirec/Result/CNV_kit_$id
else
	exit 1
fi


python $cnv_kit_path/cnvkit.py batch $mydirec/test_data/1709561-118-T.sort.bam --normal $mydirec/test_data/1709560-118-B.sort.bam \
	--targets $mydirec/ModifiedBeds/panel_PAED_V2_NoTEL_NoCEN.bed \
	--fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
	--access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
	--output-reference $mydirec/Result/CNV_kit_$id/118_reference.cnn --output-dir $mydirec/Result/CNV_kit_$id \
	--diagram --scatter

cp $mydirec/$script_name $mydirec/Result/CNV_kit_$id/.
