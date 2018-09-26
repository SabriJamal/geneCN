#!/bin/bash

## Initialising variables ##
############################
mydirec=$(pwd)
bedfile=$1 # Target bedfile to prepare
panel=$2 # Name of bed file e.g RMH200
script=`basename $0`

chrom_order="chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY"


## Create Chromosme order list ##
#################################
if [ -f $mydirec/OUTPUT/chromosomes_in_order.txt ];
then
	rm $mydirec/OUTPUT/chromosomes_in_order.txt
fi	
	for chr in $chrom_order;
	do
       		echo $chr >> $mydirec/OUTPUT/chromosomes_in_order.txt
	done

## Create gene list from bed file ##
####################################
#NOTE! Grep might be specific to exclude non gene targets
#Gene list for pipeline
awk '{print $4}' $bedfile | grep -v "chr" | grep -v "QC" | grep -v "ANTRX2" | grep -v "C19MC" | grep -v "FAM46C" | grep -v "upstream" | grep -v "YqCEN" | grep -v "RhoA" | cut -d"_" -f1 | sort | uniq > $mydirec/OUTPUT/panel_$panel.gene.list

#Gene list for UCSC
mkdir  $mydirec/OUTPUT/UCSC
awk '{print $4}' $bedfile | grep -v "chr" | grep -v "QC" | grep -v "ANTRX2" | grep -v "C19MC" | grep -v "FAM46C" | grep -v "upstream" | grep -v "YqCEN" | grep -v "RhoA" | cut -d"_" -f1 | sort | uniq > $mydirec/OUTPUT/UCSC/panel_$panel.UCSC.gene.list

## Check if sufficient args given ##
####################################
if [[ $bedfile == "" ]] || [[ $panel == "" ]];
then
	echo "Insufficient arguments pased"
	echo "Example call => $script <FULL_PATH>/*.bed <PANEL>"
	echo "Exiting..."
	exit 1
else
	echo "Script called => $script $bedfile $panel"
fi


## Check Output folder exists ##
################################
if [ ! -d $mydirec/OUTPUT ];
then

	mkdir $mydirec/OUTPUT

fi

## BODY Create window ##
########################

bedtools sort -faidx $mydirec/OUTPUT/chromosomes_in_order.txt -i $bedfile | bedtools merge | bedtools makewindows -w 375 -b -| awk '{if (($3-$2) >= 90) print}' | bedtools nuc -fi $mydirec/REFERENCES/hg19.fa -bed - | cut -f 1-3,5 | sed 1d > $mydirec/OUTPUT/panel_$panel.gc.bed

ln -s $mydirec/OUTPUT/panel_$panel.gc.bed $mydirec/REFERENCES/panel_$panel.gc.TumourAsRef.bed 


## Echo outputted file ##
#########################
if [ -f $mydirec/OUTPUT/panel_$panel.gc.bed ];
then
	echo "Wrote $mydirec/OUTPUT/panel_$panel.gc.bed\n"
fi

#Intention was to write error if file is empty
#elif [ -s $mydirec/OUTPUT/panel_$panel.gc.bed ];
#then
#	echo -e "Output data contains data\n"
#else
#	echo -e "ERROR! Wrote empty windows bed\n"
#fi

if [ ! -f $mydirec/OUTPUT/UCSC/USCSC_geneTranscripts.out ];
then
	echo "USCSC gene transcript list not found please create using gene list in $mydirec/OUTPUT/USCSC folder, name file $mydirec/OUTPUT/UCSC/USCSC_geneTranscripts.out and run script again"
	echo "Please see image file in $mydirec/UCSC_instrucitons/UCSC_instructions_transcript_generation for chosen inputs when generating transcript file"
	echo "Use $mydirec/OUTPUT/UCSC/panel_<panel>.gene.list as input"
	echo "Exiting..."
	exit 1
fi

## Create Gene genomic windows, genes for CNA identification ##
###############################################################
perl ../supporting_scripts/find_gene_windows.pl -t $mydirec/OUTPUT/UCSC/USCSC_geneTranscripts.out -g $mydirec/OUTPUT/panel_$panel.gene.list -o $mydirec/OUTPUT/panel_$panel.geneOmicWindow.bed -e 10000

## Annotate targets (CNA identication targets) and background and concatenate ##
################################################################################
bedtools intersect -a $mydirec/OUTPUT/panel_$panel.gc.bed -b $mydirec/OUTPUT/panel_$panel.geneOmicWindow.bed -wb | cut -f 1-4,8 > $mydirec/OUTPUT/panel_$panel.annotated.targets
bedtools subtract -a $mydirec/OUTPUT/panel_$panel.gc.bed -b $mydirec/OUTPUT/panel_$panel.annotated.targets | awk '{print $1"\t"$2"\t"$3"\t"$4"\t""background"}' > $mydirec/OUTPUT/panel_$panel.annotated.background 
cat $mydirec/OUTPUT/panel_$panel.annotated.targets $mydirec/OUTPUT/panel_$panel.annotated.background | bedtools sort -faidx $mydirec/OUTPUT/chromosomes_in_order.txt -i - > $mydirec/OUTPUT/panel_$panel.gc.annotated.bed

ln -s $mydirec/OUTPUT/panel_$panel.gc.annotated.bed REFERENCES/panel_$panel.gc.annotated.bed
