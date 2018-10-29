#!/bin/bash

PATH=/usr/lib/jvm/jre-1.8.0/bin/:$PATH:$HOME/bin
JAVA_HOME=/usr/lib/jvm/jre-1.8.0/bin/

export JAVA_HOME
export PATH

module load apps/bwa/0.7.12/gcc-4.4.7 apps/bowtie2/2.2.6/gcc-4.4.7 apps/bedtools/2.22.0/gcc-4.4.7 apps/cufflinks/2.2.2.20150701/gcc-4.4.7+boost-1.55.0+samtools-0.1.19+eigen-3.2.4 apps/mutect/1.1.4/bin apps/oncotator/1.5.1.0/gcc-4.4.7+python-2.7.8+cython-0.20+numpy-1.9.2+pandas-0.14.0+biopython-1.63+pysam-0.7.5
module load apps/samtools/1.2/gcc-4.4.7 
module load apps/perl/5.20.2/gcc-4.4.7
module load apps/picard/1.130/bin apps/R/3.2.1/gcc-4.4.7+lapack-3.5.0+blas-20110419 apps/tophat/2.0.13/gcc-4.4.7+boost-1.58.0 libs/bioconductor/2.14/gcc-4.4.7+R-3.2.1 libs/bioperl/1.6.923/gcc-4.4.7+samtools-0.1.19 apps/python3/3.4.3/gcc-4.4.7  libs/pandas/0.17.0/gcc-4.4.7+python-2.7.8+numpy-1.9.2
module load apps/gatk/3.5.0/noarch libs/pybedtools
module load libs/seaborn
module load apps/stampy/1.0.22.1848
module load apps/ead
module load apps/pypy3
module load apps/manta/0.29.6/gcc-5.1.0+python-2.7.8+boost-1.58.0

#perl /mnt/lustre/users/lchen/9.Scripts/0.pipeline_managers/pipeline_manager.pl --samples /mnt/lustre/analysis//Pool_805_NEXTSEQ/SampleSheet.hpc.csv --analyses_cmd bcl2fastq
#perl /mnt/lustre/users/lchen/9.Scripts/0.pipeline_managers/pipeline_manager.pl --samples /mnt/lustre/analysis//Pool_805_NEXTSEQ/SampleSheet.hpc.csv --analyses_cmd bcl2fastq,bwa,qc,gatk,mutect,cnv,manta
perl /mnt/lustre/users/lchen/9.Scripts/0.pipeline_managers/pipeline_manager.pl --samples /mnt/lustre/analysis//Pool_805_NEXTSEQ/SampleSheet.hpc.csv --analyses_cmd bwa,qc,gatk,mutect,cnv,manta
#perl /mnt/lustre/users/lchen/9.Scripts/0.pipeline_managers/pipeline_manager.pl --samples /mnt/lustre/analysis//Pool_805_NEXTSEQ/SampleSheet.hpc.csv --analyses_cmd qc

