#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)

cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"

mkdir $mydirec/DataFromValidation/ABCBIO
mkdir $mydirec/DataFromValidation/PAED
mkdir $mydirec/DataFromValidation/ABCBIO/Noise
mkdir $mydirec/DataFromValidation/PAED/Noise

cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO*/test_data/CNVSamples/DataFromValidation/ABCBIOV*/Alignments/*reference* $mydirec/DataFromValidation/ABCBIO/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO*/*-B*antitargetcoverage.cnn $mydirec/DataFromValidation/ABCBIO/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO*/*.cnr $mydirec/DataFromValidation/ABCBIO/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO*/*.cns $mydirec/DataFromValidation/ABCBIO/.

cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED*/test_data/CNVSamples/DataFromValidation/PAED*/Alignments/*reference* $mydirec/DataFromValidation/PAED/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED*/*-B*antitargetcoverage.cnn $mydirec/DataFromValidation/PAED/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED*/*.cnr $mydirec/DataFromValidation/PAED/.
cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED*/*.cns $mydirec/DataFromValidation/PAED/.

#Investigate sample noise 
python $cnv_kit_path/cnvkit.py metrics $mydirec/DataFromValidation/ABCBIO/*.cnr -s $mydirec/DataFromValidation/ABCBIO/*.cns -o $mydirec/DataFromValidation/ABCBIO/Noise/ABCBIO_normal.noise 
python $cnv_kit_path/cnvkit.py metrics $mydirec/DataFromValidation/PAED/*.cnr -s $mydirec/DataFromValidation/PAED/*.cns -o $mydirec/DataFromValidation/PAED/Noise/PAED_normal.noise

#Pooling samples
#python $cnv_kit_path/cnvkit.py
