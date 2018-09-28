#!/bin/bash

#python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py call 1608211-MOLDX-T.sort.cns -v ../../test_data/CNVSamples/VCFs/MUT.1608211-MOLDX-T.vcf -o 1608211-MOLDX-T.call.sort.cns

## **Didn't work due to Mutect having only ~2 loci where germline heterzygous SNV present ** ## 
#python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter 1608211-MOLDX-T.sort.cnr -s 1608211-MOLDX-T.call.sort.cns -v ../../test_data/CNVSamples/VCFs/MUT.1608211-MOLDX-T.vcf -o 1608211-MOLDX-T.call.sort.pdf


python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py scatter 1608211-MOLDX-T.sort.cnr -s 1608211-MOLDX-T.call.sort.cns -v ../../test_data/CNVSamples/VCFs/GATK.1608212-MOLDX-B.MOD.gvcf -o 1608211-MOLDX-T.call.sort.pdf

#cnvkit.py scatter -v ../../test_data/CNVSamples/VCFs/GATK.1608212-MOLDX-B.MOD.gvcf -o 1608211-MOLDX-T.VAFplot.pdf
