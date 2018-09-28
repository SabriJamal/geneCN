#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

sample_tumour=$1
sample_blood=$2
vcf=$3
target_bed=$4
experiment=$5


if [[ ! -d $mydirec/Result/CNV_kit_$experiment\_$id ]];
then
	mkdir $mydirec/Result/CNV_kit_$experiment\_$id
else
	exit 1
fi

echo $mydirec/Result/CNV_kit_$experiment\_$id

vcf_id1=$(echo $vcf | cut -d"/" -f11 | cut -d"." -f1)
vcf_id2=$(echo $vcf | cut -d"/" -f11 | cut -d"." -f2)
vcf_prefix=$vcf_id1.$vcf_id2

awk '{if($9 != "GT:AD:DP") print $0}' $vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/$vcf_prefix.MOD.gvcf

python $cnv_kit_path/cnvkit.py batch $sample_tumour --normal $sample_blood \
	--targets $target_bed \
	--fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
	--access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
	--output-reference $mydirec/Result/CNV_kit_$experiment\_$id/$sample_blood.reference.cnn --output-dir $mydirec/Result/CNV_kit_$experiment\_$id \
	--diagram --scatter

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py scatter \
	$mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.cnr \
	-s $mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.cns \
	-v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/$vcf_prefix.MOD.gvcf \
	-o $mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.call.pdf


cp $mydirec/$script_name $mydirec/Result/CNV_kit_$experiment\_$id/.

#####################################
## Writing called script to folder ##
#####################################
cat << EOF > $mydirec/Result/CNV_kit_$experiment\_$id/cnvkit_call.out.sh 

#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`
id=$RANDOM

sample_tumour=$1
sample_blood=$2
vcf=$3
target_bed=$4
experiment=$5


if [[ ! -d $mydirec/Result/CNV_kit_$experiment\_$id ]];
then
        mkdir $mydirec/Result/CNV_kit_$experiment\_$id
else
        exit 1
fi

echo $mydirec/Result/CNV_kit_$experiment\_$id

vcf_id1=$(echo $vcf | cut -d"/" -f11 | cut -d"." -f1)
vcf_id2=$(echo $vcf | cut -d"/" -f11 | cut -d"." -f2)
vcf_prefix=$vcf_id1.$vcf_id2

awk '{if($9 != "GT:AD:DP") print $0}' $vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/$vcf_prefix.MOD.gvcf

python $cnv_kit_path/cnvkit.py batch $sample_tumour --normal $sample_blood \
        --targets $target_bed \
        --fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa \
        --access $cnv_kit_path/data/access-5k-mappable.hg19.bed \
        --output-reference $mydirec/Result/CNV_kit_$experiment\_$id/$sample_blood.reference.cnn --output-dir $mydirec/Result/CNV_kit_$experiment\_$id \
        --diagram --scatter

sample_name=$(echo $sample_tumour | cut -d"/" -f6 | cut -d"." -f1)
sample_name=$sample_name.sort

python $cnv_kit_path/cnvkit.py scatter \
        $mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.cnr \
        -s $mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.cns \
        -v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/$vcf_prefix.MOD.gvcf \
        -o $mydirec/Result/CNV_kit_$experiment\_$id/$sample_name.call.pdf

cp $mydirec/$script_name $mydirec/Result/CNV_kit_$experiment\_$id/.

EOF
