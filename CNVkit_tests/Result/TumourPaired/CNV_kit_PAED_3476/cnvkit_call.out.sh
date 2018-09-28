
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call.sh
id=15595

sample_tumour=test_data/CNVSamples/DataFromValidation/PAED/Alignments/1609532-111015-T.sort.bam
sample_blood=test_data/CNVSamples/DataFromValidation/PAED/Alignments/1609537-111015-B.sort.bam
vcf=test_data/CNVSamples/DataFromValidation/PAED/VCFs/MUT.1609532-111015-T.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed
experiment=PAED


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476 ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476
else
        exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if( != "GT:AD:DP") print cnvkit_call.sh}' test_data/CNVSamples/DataFromValidation/PAED/VCFs/MUT.1609532-111015-T.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/PAED/Alignments/1609532-111015-T.sort.bam --normal test_data/CNVSamples/DataFromValidation/PAED/Alignments/1609537-111015-B.sort.bam         --targets /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_PAEDV2.bed         --fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa         --access /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed         --output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476/test_data/CNVSamples/DataFromValidation/PAED/Alignments/1609537-111015-B.sort.bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476         --diagram --scatter

sample_name=1609532-111015-T
sample_name=1609532-111015-T.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter         /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476/1609532-111015-T.sort.cnr         -s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476/1609532-111015-T.sort.cns         -v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf         -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476/1609532-111015-T.sort.call.pdf

cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_PAED\_3476/.

