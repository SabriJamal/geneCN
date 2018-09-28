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


if [[ ! -d $mydirec/Antitarget4TumourOnly ]];
then
	mkdir $mydirec/Antitarget4TumourOnly
else
	echo "Folder already exists why are you running me again? Delete folder echo me out"
	echo "Exiting..."
	exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_RMH200.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_RMH200.antitarget.bed
ln -s $mydirec/Antitarget4TumourOnly/panel_RMH200.antitarget.bed $mod_bed_path/panel_RMH200.antitarget.bed

python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_GSIC.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_GSIC.antitarget.bed
ln -s $mydirec/Antitarget4TumourOnly/panel_GSIC.antitarget.bed $mod_bed_path/panel_GSIC.antitarget.bed

python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_OGT.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_OGT.antitarget.bed
ln -s $mydirec/Antitarget4TumourOnly/panel_OGT.antitarget.bed $mod_bed_path/panel_OGT.antitarget.bed


#####################################
## Writing called script to folder ##
#####################################
cat << EOF > $mydirec/Antitarget4TumourOnly/cnvkit_create_antitarget.out.sh
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


if [[ ! -d $mydirec/Antitarget4TumourOnly ]];
then
        mkdir $mydirec/Antitarget4TumourOnly
else
        echo "Folder already exists why are you running me again? Delete folder echo me out"
        echo "Exiting..."
        exit 1
fi

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_RMH200.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_RMH200.antitarget.bed
python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_GSIC.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_GSIC.antitarget.bed
python $cnv_kit_path/cnvkit.py antitarget $mod_bed_path/panel_OGT.bed -g $cnv_kit_path/data/access-5k-mappable.hg19.bed -o $mydirec/Antitarget4TumourOnly/panel_OGT.antitarget.bed

EOF
