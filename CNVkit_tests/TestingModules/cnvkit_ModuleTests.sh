#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
bed_path="/mnt/lustre/genome/hg19/bedfiles"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
echo $script_name
id=$RANDOM


#python $cnv_kit_path/cnvkit.py target /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/PaediatricsV2_hg19_25aug2016_capture_targets.bed --annotate /mnt/lustre/genome/hg19/annotations/refFlat.txt --split -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAED_CNVkitGen.bed

python $cnv_kit_path/cnvkit.py coverage /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/1709560-118-B.sort.bam /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/panel_PAED_CNVkitGen.antitarget.bed -o  /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/1709560-118-B.antitargetcoverage.cnn

python $cnv_kit_path/cnvkit.py coverage /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/1709561-118-T.sort.bam /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/panel_PAED_CNVkitGen.antitarget.bed -o  /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/1709561-118-T.sort.bam.antitargetcoverage.cnn


python $cnv_kit_path/cnvkit.py coverage /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/1709560-118-B.sort.bam /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/panel_PAED_CNVkitGen.target.bed -o  /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/1709560-118-B.targetcoverage.cnn

python $cnv_kit_path/cnvkit.py coverage /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/1709561-118-T.sort.bam /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/panel_PAED_CNVkitGen.target.bed -o  /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_4852_CNVkitBed/1709561-118-T.sort.bam.targetcoverage.cnn
