#!/bin/bash
  
## Initialising variables ##
############################
mydirec=$(pwd)
panel=$1 # Target TumourAsRef bedfile containing first 4 columns [chr, pos1, pos2, GC]
script=`basename $0`

## Check if sufficient args given ##
####################################
if [[ $panel == "" ]]; 
then
        echo "Insufficient arguments pased"
        echo "Example call => $script <PANEL>"
        echo "Exiting..."
        exit 1
else
        echo "Script called => $script $bedfile $panel"
fi

data_path="$mydirec/TEST_DATA/$panel"

for bam in $(ls $data_path | grep "bam$");
do
	sample_ID=$(echo $bam | cut -d"." -f1)
	## Create sample coverage data ##
	#################################
	if [ ! -d $mydirec/OUTPUT/Coverage ];
	then
		mkdir $mydirec/OUTPUT/Coverage
	fi
	#perl $mydirec/../depth-for-geneCN.pl -b $mydirec/REFERENCES/panel_$panel.gc.annotated.complete.bed -o $mydirec/OUTPUT/Coverage/$sample_ID.coverage $data_path/$bam

	## Run CNV analysis 					 ##
	## NOTE! Bedfile is probably last bedfile with 6 columns ##
	###########################################################
	Rscript $mydirec/../geneCN.R $mydirec/OUTPUT/Coverage/$sample_ID.coverage $mydirec/REFERENCES/panel_$panel.gc.annotated.complete*bed $sample_ID $mydirec/REFERENCES/hg.19.fa #THRESHOLDS_FILE female

done


for bam in $(ls $mydirec/TEST_DATA/TumourAsReference | grep "bam$");
do
        ## Investigating Tumours that can be used as reference         ##
        #################################################################
	sample_ID=$(echo $bam | cut -d"." -f1)
	#Rscript ../no_normal_panel_available/prelimPlots.R $mydirec/TEST_DATA/TumourAsReference/$bam $mydirec/REFERENCES/panel_$panel.gc.TumourAsRef.bed $sample_ID  
	#sh $mydirec/investigating_TumoursAsNormalCohort.sh $mydirec/TEST_DATA/TumourAsReference/$bam $mydirec/REFERENCES/panel_$panel.gc.TumourAsRef.bed $sample_ID
done

