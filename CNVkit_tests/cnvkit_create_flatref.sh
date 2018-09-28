#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

#sample_blood=$1
#target_bed=$2
#antitarget_bed=$3


if [[ ! -d $mydirec/FlatrefTumourOnly ]];
then
	mkdir $mydirec/FlatrefTumourOnly
else
	echo "Folder already exists why are you running me again? Delete folder echo me out"
	echo "Exiting..."
	exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_RMH200.bed -a $mod_bed_path/panel_RMH200.antitarget.bed -o $mydirec/FlatrefTumourOnly/RMH200.flatref.cnn

python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_GSIC.bed -a $mod_bed_path/panel_GSIC.antitarget.bed -o $mydirec/FlatrefTumourOnly/GSIC.flatref.cnn


python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_OGT.bed  -a $mod_bed_path/panel_OGT.antitarget.bed -o $mydirec/FlatrefTumourOnly/OGT.flatref.cnn


#####################################
## Writing called script to folder ##
#####################################
cat << EOF > $mydirec/FlatrefTumourOnly/cnvkit_create_flatref.out.sh 

#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

#sample_blood=$1
#target_bed=$2
#antitarget_bed=$3


if [[ ! -d $mydirec/FlatrefTumourOnly ]];
then
        mkdir $mydirec/FlatrefTumourOnly
else
        echo "Folder already exists why are you running me again? Delete folder echo me out"
        echo "Exiting..."
        exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_RMH200.bed -a $mod_bed_path/panel_RMH200.antitarget.bed -o $mydirec/FlatrefTumourOnly/RMH200.flatref.cnn

python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_GSIC.bed -a $mod_bed_path/panel_GSIC.antitarget.bed -o $mydirec/FlatrefTumourOnly/GSIC.flatref.cnn


python $cnv_kit_path/cnvkit.py reference -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -t $mod_bed_path/panel_OGT.bed  -a $mod_bed_path/panel_OGT.antitarget.bed -o $mydirec/FlatrefTumourOnly/OGT.flatref.cnn

EOF
