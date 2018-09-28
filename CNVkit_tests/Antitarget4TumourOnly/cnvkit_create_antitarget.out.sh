#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_create_antitarget.sh

#sample_blood=
#target_bed=
#antitarget_bed=


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Antitarget4TumourOnly ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Antitarget4TumourOnly
else
        echo "Folder already exists why are you running me again? Delete folder echo me out"
        echo "Exiting..."
        exit 1
fi

sample_name=
sample_name=.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py antitarget /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_RMH200.bed -g /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Antitarget4TumourOnly/panel_RMH200.antitarget.bed
python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py antitarget /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_GSIC.bed -g /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Antitarget4TumourOnly/panel_GSIC.antitarget.bed
python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py antitarget /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_OGT.bed -g /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Antitarget4TumourOnly/panel_OGT.antitarget.bed

