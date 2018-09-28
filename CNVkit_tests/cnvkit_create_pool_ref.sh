#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

mkdir $mydirec/PooledReference/Reference

for panel in $(ls $mydirec/PooledReference/Coverage/);
do
	python $cnv_kit_path/cnvkit.py reference $mydirec/PooledReference/Coverage/$panel/*coverage.cnn -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -o $mydirec/PooledReference/Coverage/$panel/$panel.reference.cnn
	ln -s $mydirec/PooledReference/Coverage/$panel/$panel.reference.cnn $mydirec/PooledReference/Reference/$panel.reference.cnn
done


#####################################
## Writing called script to folder ##
#####################################
cat << EOF > $mydirec/PooledReference/Coverage/cnvkit_create_pool_ref.sh 

#!/bin/bash

module load apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419

mydirec=$(pwd)
cnv_kit_path="/mnt/lustre/users/sjamal/1.Projects/Python_projects/cnvkit"
mod_bed_path="/mnt/lustre/users/sjamal/3.Tests/CNVkit_tests/ModifiedBeds"
fastq_path="/mnt/lustre/genome/hg19"
script_name=`basename "$0"`

mkdir $mydirec/PooledReference/Reference

for panel in $(ls $mydirec/PooledReference/Coverage/);
do
        python $cnv_kit_path/cnvkit.py reference $panel/*coverage.cnn -f /mnt/lustre/users/sjamal/1.Projects/Python_projects/bam-matcher/hg19.fa -o $panel/$panel.reference.cnn
        ln -s $panel/$panel.reference.cnn $mydirec/PooledReference/Reference/$panel.reference.cnn
done

EOF
