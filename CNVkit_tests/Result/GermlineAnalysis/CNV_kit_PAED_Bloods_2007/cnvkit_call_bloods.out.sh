
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call_bloods.sh
id=26498

sample_blood=test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam
pooled_ref=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/PAED.reference.cnn
vcf=test_data/CNVSamples/DataFromValidation/PAED/VCFs/*IE0010*.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed
experiment=PAED_Bloods


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007 ]];
then
	mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007
else
	exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if($9 != "GT:AD:DP") print $0}' test_data/CNVSamples/DataFromValidation/PAED/VCFs/*IE0010*.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam -r /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/PAED.reference.cnn 	--output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007/test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007 	--diagram --scatter

sample_name=*IE0010-B*bam
sample_name=*IE0010-B*bam.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter 	/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007/*IE0010-B*bam.sort.cnr 	-s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007/*IE0010-B*bam.sort.cns 	-v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf 	-o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007/*IE0010-B*bam.sort.call.pdf


cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call_bloods.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_2007/.

