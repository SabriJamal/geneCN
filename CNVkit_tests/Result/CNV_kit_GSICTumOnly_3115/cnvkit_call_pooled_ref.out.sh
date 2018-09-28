
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call_pooledRef.sh
id=10930

sample_tumour=test_data/CNVSamples/DataFromValidation/GSIC/Alignments/157654-CMPRMH43840009-T.sort.bam
pooled_ref=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly/GSIC.flatref.cnn
vcf=test_data/CNVSamples/DataFromValidation/GSIC/VCFs/*CMPRMH43840009*.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_GSIC.bed
experiment=GSICTumOnly


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115 ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115
else
        exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if( != "GT:AD:DP") print cnvkit_call_pooledRef.sh}' test_data/CNVSamples/DataFromValidation/GSIC/VCFs/*CMPRMH43840009*.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/GSIC/Alignments/157654-CMPRMH43840009-T.sort.bam -r /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/FlatrefTumourOnly/GSIC.flatref.cnn         --targets /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_GSIC.bed         --fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa         --access /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed         --output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115/.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115         --diagram --scatter

sample_name=157654-CMPRMH43840009-T
sample_name=157654-CMPRMH43840009-T.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter         /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115/157654-CMPRMH43840009-T.sort.cnr         -s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115/157654-CMPRMH43840009-T.sort.cns         -v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf         -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115/157654-CMPRMH43840009-T.sort.call.pdf


cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call_pooledRef.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_GSICTumOnly\_3115/.
