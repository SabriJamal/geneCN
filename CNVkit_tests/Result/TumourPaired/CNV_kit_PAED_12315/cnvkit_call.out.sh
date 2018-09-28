
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call.sh
id=10651

sample_tumour=test_data/CNVSamples/DataFromValidation/PAED/Alignments/1801004-IE0010-T.sort.bam
sample_blood=test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam
vcf=test_data/CNVSamples/DataFromValidation/PAED/VCFs/*IE0010*.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed
experiment=PAED


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315 ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315
else
        exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if( != "GT:AD:DP") print cnvkit_call.sh}' test_data/CNVSamples/DataFromValidation/PAED/VCFs/*IE0010*.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/PAED/Alignments/1801004-IE0010-T.sort.bam --normal test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam         --targets /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed         --fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa         --access /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed         --output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315/test_data/CNVSamples/DataFromValidation/PAED/Alignments/*IE0010-B*bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315         --diagram --scatter

sample_name=1801004-IE0010-T
sample_name=1801004-IE0010-T.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter         /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315/1801004-IE0010-T.sort.cnr         -s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315/1801004-IE0010-T.sort.cns         -v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf         -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315/1801004-IE0010-T.sort.call.pdf

cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_12315/.

