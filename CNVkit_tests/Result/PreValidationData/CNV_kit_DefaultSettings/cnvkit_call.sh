#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
bed_path="/mnt/lustre/genome/hg19/bedfiles"
fastq_path="/mnt/lustre/genome/hg19"


python $cnv_kit_path/cnvkit.py batch $mydirec/test_data/1709561-118-T.sort.bam --normal $mydirec/test_data/1709560-118-B.sort.bam \
	--targets $bed_path/panel_PAED_V2.bed \
	--fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
	--access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
	--output-reference $mydirec/Result/118_reference.cnn --output-dir $mydirec/Result \
	--diagram --scatter
