
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call_bloods.sh
id=20762

sample_blood=test_data/CNVSamples/DataFromValidation/PAED/Alignments/1602635-007-B.sort.bam
pooled_ref=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/PAED.reference.cnn
vcf=test_data/CNVSamples/DataFromValidation/PAED/VCFs/MUT.1606998-007-T.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed
experiment=PAED_Bloods


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774 ]];
then
	mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774
else
	exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if($9 != "GT:AD:DP") print $0}' test_data/CNVSamples/DataFromValidation/PAED/VCFs/MUT.1606998-007-T.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/PAED/Alignments/1602635-007-B.sort.bam -r /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/PAED.reference.cnn 	--output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774/test_data/CNVSamples/DataFromValidation/PAED/Alignments/1602635-007-B.sort.bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774 	--diagram --scatter

sample_name=1602635-007-B
sample_name=1602635-007-B.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter 	/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774/1602635-007-B.sort.cnr 	-s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774/1602635-007-B.sort.cns 	-v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf 	-o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774/1602635-007-B.sort.call.pdf


cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call_bloods.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED_Bloods\_30774/.

