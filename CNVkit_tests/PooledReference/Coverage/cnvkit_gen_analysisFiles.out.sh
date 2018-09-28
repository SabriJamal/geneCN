
#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=cnvkit_create_pool_ref.sh

mkdir /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference

for panel in ABCBIO
cnvkit_gen_analysisFiles.out.sh
PAED
test_data;
do
        python /mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit/cnvkit.py reference test_data/*coverage.cnn -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -o test_data/test_data.reference.cnn
        ln -s test_data/test_data.reference.cnn /mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/PooledReference/Reference/test_data.reference.cnn
done

