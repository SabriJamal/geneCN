
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call_bloods.sh
id=30001

sample_blood=test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/1604650-L077-B.sort.bam
pooled_ref=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/ABCBIO.reference.cnn
vcf=test_data/CNVSamples/DataFromValidation/ABCBIOV2/VCFs/*L077*.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_ABCBIO.bed
experiment=ABCBIO_Bloods


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926 ]];
then
	mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926
else
	exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if($9 != "GT:AD:DP") print $0}' test_data/CNVSamples/DataFromValidation/ABCBIOV2/VCFs/*L077*.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/1604650-L077-B.sort.bam -r /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/ABCBIO.reference.cnn 	--output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926/test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/1604650-L077-B.sort.bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926 	--diagram --scatter

sample_name=1604650-L077-B
sample_name=1604650-L077-B.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter 	/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926/1604650-L077-B.sort.cnr 	-s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926/1604650-L077-B.sort.cns 	-v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf 	-o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926/1604650-L077-B.sort.call.pdf


cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call_bloods.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIO_Bloods\_6926/.

