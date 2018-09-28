#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

#sample_tumour=$1
#sample_blood=$2
#vcf=$3
#experiment=$4

direc="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_22475/Test"

mkdir $direc/Result/VCFtest_$id

python $cnv_kit_path/cnvkit.py scatter \
        $direc/../1808489-182-T.sort.cnr \
        -s $direc/../1808489-182-T.sort.cns \
        -v FabricatedVCF/GATK.1808490-182-B.MOD_FAB.gvcf \
        -o $direc/Result/VCFtest_$id/1808489-182-T.sort.call.pdf

cp $direc/$script_name $direc/Result/VCFtest_$id/.
