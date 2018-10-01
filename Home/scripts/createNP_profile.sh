#!/bin/bash

## Initialising variables ##
############################
mydirec=$(pwd)
panel=$1 # Name of bed file e.g RMH200
cohort=$2 #Choose Normal or TumourAsReference as cohort
script=`basename $0`

## Check if sufficient args given ##
####################################
if [[ $panel == "" ]] || [[ $cohort == "" ]];
then
        echo "Insufficient arguments pased"
        echo "Example call => $script <PANEL> <COHORT>"
        echo "Exiting..."
        exit 1
else
        echo "Script called => $script $panel $cohort"
fi

#For normal cohort, design IF statment incase TumourAsReference used, will need added input tumours/normals

if [[ $cohort == "normals" ]];
then
	echo $mydirec/TEST_DATA/NormalCohort/$panel/panel_$panel.sample.gender.list
	if [[ -f $mydirec/TEST_DATA/NormalCohort/$panel/panel_$panel.sample.gender.list ]];
	then
		gender_list="$mydirec/TEST_DATA/NormalCohort/$panel/panel_$panel.sample.gender.list"
		echo "Sample gender list exist, using $mydirec/TEST_DATA/NormalCohort/$panel/panel_$panel.sample.gender.list"
	else
		echo "Sample gender list is missing, please create tab delimited sample gender list to create NP profile."
		echo "Exiting..."
		exit 1
	fi
	for bam in $(ls $mydirec/TEST_DATA/NormalCohort/$panel/ | grep ".sort.bam$");
	do
		bams="$bams $mydirec/TEST_DATA/NormalCohort/$panel/$bam"
	done
fi

if [[ $cohort == "tumours" ]];
then
        if [[ -f $mydirec/TEST_DATA/TumourAsReference/$panel/panel_$panel.sample.gender.list ]];
        then
		gender_list="$mydirec/TEST_DATA/TumourAsReference/$panel/panel_$panel.sample.gender.list"
                echo "Sample gender list exist, using $mydirec/TEST_DATA/TumourAsReference/$panel/panel_$panel.sample.gender.list"
        else
                echo "Sample gender list is missing, please create tab delimited sample gender list to create NP profile."
                echo "Exiting..."
                exit 1
        fi
        for bam in $(ls $mydirec/TEST_DATA/TumourAsReference/$panel/ | grep ".sort.bam$");
        do
                bams="$bams $mydirec/TEST_DATA/TumourAsReference/$panel/$bam"
        done
fi


perl ../supporting_scripts/copy_number_NPbuild.pl \
 -b $mydirec/REFERENCES/panel_$panel.gc.annotated.bed \
 -o $mydirec/OUTPUT/panel_$panel.gc.annotated.NP.bed \
 -s $gender_list $bams

ln -s $mydirec/OUTPUT/panel_$panel.gc.annotated.NP.bed $mydirec/REFERENCES/panel_$panel.gc.annotated.NP.bed

