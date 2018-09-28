#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

sample_blood=$1
target_bed=$2
antitarget_bed=$3


if [[ ! -d $mydirec/Result/CNV_kit_$experiment\_$id ]];
then
	mkdir $mydirec/PooledReference/Coverage
else
	exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py coverage $sample_blood $target_bed -o $mydirec/PooledReference/Coverage/$sample_blood.targetcoverage.cnn
python $cnv_kit_path/cnvkit.py coverage $sample_blood $antitarget_bed -o $mydirec/PooledReference/Coverage/$sample_blood.antitargetcoverage.cnn

#####################################
## Writing called script to folder ##
#####################################
cat << EOF > $mydirec/PooledReference/Coverage/cnvkit_gen_analysisFiles.out.sh 

#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

sample_blood=$1
target_bed=$2
antitarget_bed=$3


if [[ ! -d $mydirec/Result/CNV_kit_$experiment\_$id ]];
then
        mkdir $mydirec/PooledReference/Coverage
else
        exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py coverage $sample_blood $target_bed -o $mydirec/PooledReference/Coverage/$sample_blood.targetcoverage.cnn
python $cnv_kit_path/cnvkit.py coverage $sample_blood $antitarget_bed -o $mydirec/PooledReference/Coverage/$sample_blood.antitargetcoverage.cnn

EOF
