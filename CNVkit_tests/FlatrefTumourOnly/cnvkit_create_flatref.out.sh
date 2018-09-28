
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_create_flatref.sh

#sample_blood=
#target_bed=
#antitarget_bed=


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly
else
        echo "Folder already exists why are you running me again? Delete folder echo me out"
        echo "Exiting..."
        exit 1
fi

sample_name=
sample_name=.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_RMH200.bed -a /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_RMH200.antitarget.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly/RMH200.flatref.cnn

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_GSIC.bed -a /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_GSIC.antitarget.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly/GSIC.flatref.cnn


python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_OGT.bed  -a /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_OGT.antitarget.bed -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly/OGT.flatref.cnn

