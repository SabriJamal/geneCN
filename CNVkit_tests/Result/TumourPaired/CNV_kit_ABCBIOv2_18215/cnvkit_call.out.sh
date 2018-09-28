
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
#bed_path="/mnt/lustre/genome/hg19/bedfiles"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_call.sh
id=28348

sample_tumour=test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/1605701-L011-T.sort.bam
sample_blood=test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/151707-L011-B.sort.bam
vcf=test_data/CNVSamples/DataFromValidation/ABCBIOV2/VCFs/*L011*.vcf
target_bed=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_ABCBIO.bed
experiment=ABCBIOv2


if [[ ! -d /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215 ]];
then
        mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215
else
        exit 1
fi

echo /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215

vcf_id1=
vcf_id2=
vcf_prefix=.

awk '{if( != "GT:AD:DP") print cnvkit_call.sh}' test_data/CNVSamples/DataFromValidation/ABCBIOV2/VCFs/*L011*.vcf  > /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py batch test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/1605701-L011-T.sort.bam --normal test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/151707-L011-B.sort.bam         --targets /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds/panel_ABCBIO.bed         --fasta /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa         --access /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/data/access-5k-mappable.hg19.bed         --output-reference /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215/test_data/CNVSamples/DataFromValidation/ABCBIOV2/Alignments/151707-L011-B.sort.bam.reference.cnn --output-dir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215         --diagram --scatter

sample_name=1605701-L011-T
sample_name=1605701-L011-T.sort.sort

python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter         /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215/1605701-L011-T.sort.cnr         -s /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215/1605701-L011-T.sort.cns         -v /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/test_data/CNVSamples/VCFs/..MOD.gvcf         -o /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215/1605701-L011-T.sort.call.pdf

cp /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/cnvkit_call.sh /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/Result/CNV_kit_ABCBIOv2\_18215/.

