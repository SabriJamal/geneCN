#!/bin/bash

mydirec=$(pwd)

intiialTestSampels=""
ABCBIOv3="test_data/CNVSamples/DataFromValidation/ABCBIOV3"
ABCBIOv2="test_data/CNVSamples/DataFromValidation/ABCBIOV2"
PAED="test_data/CNVSamples/DataFromValidation/PAED"
RMH200="test_data/CNVSamples/DataFromValidation/RMH200"
OGT="test_data/CNVSamples/DataFromValidation/OGT"
GSIC="test_data/CNVSamples/DataFromValidation/GSIC"

#Running CNVkit on all paired samples (142 is unpaired so not sure what will happen) 
for sample in $(ls $GSIC/Alignments | grep "\-T.sort.bam$" );
do
	trialID=$(echo $sample | cut -d"-" -f2)

	## Calling CNV pairing tumour-blood ##
	######################################
	#sh cnvkit_call.sh $GSIC/Alignments/*$trialID-T*bam $GSIC/Alignments/*$trialID-B*bam $GSIC/VCFs/*$trialID*.vcf $mydirec/ModifiedBeds/panel_ABCBIO.bed ABCBIOv3

	## Calling CNV using pool ref ##
	################################
	#sh cnvkit_call_pooledRef.sh  $GSIC/Alignments/*$trialID-T*bam $mydirec/PooledReference/Reference/ABCBIO.reference.cnn $GSIC/VCFs/*$trialID*.vcf $mydirec/ModifiedBeds/panel_ABCBIO.bed ABCBIOV3WithRMH200

	## Calling Tumour only CNV using flatref NOTE! *pooledRef.sh script is adapted for this ##
	##########################################################################################
	sh cnvkit_call_pooledRef.sh  $GSIC/Alignments/*$trialID-T*bam $mydirec/FlatrefTumourOnly/GSIC.flatref.cnn $GSIC/VCFs/*$trialID*.vcf $mydirec/ModifiedBeds/panel_GSIC.bed GSICTumOnly

	## Calling CNV on bloods ##
	###########################
	#sh cnvkit_call_bloods.sh $GSIC/Alignments/*$trialID-B*bam $mydirec/PooledReference/Reference/PAED.reference.cnn $GSIC/VCFs/*$trialID*.vcf $mydirec/ModifiedBeds/panel_PAEDV2.bed PAED_Bloods 
	
	## Calling CNVkit coverage function for generating data for pooled ref ##
	#########################################################################
	#sh cnvkit_gen_analysisFiles.sh $GSIC/Alignments/*$trialID-B*bam $mydirec/ModifiedBeds/panel_PAEDV2.target.bed $mydirec/ModifiedBeds/panel_PAEDV2.antitarget.bed 
	#sh cnvkit_gen_analysisFiles.sh $GSIC/Alignments/*$trialID-B*bam $mydirec/ModifiedBeds/panel_ABCBIO.target.bed $mydirec/ModifiedBeds/panel_ABCBIO.antitarget.bed

	#Debugging checks for duplicate samples
	#ls $GSIC/Alignments/*$trialID-T*bam
	#ls $GSIC/Alignments/*$trialID-B*bam
	#ls $GSIC/VCFs/*$trialID*.gvcf #For gvcf
	#ls $GSIC/VCFs/*$trialID*.vcf #For Mutect
	
	#echo "XXXXXxxNEEEEEEWWxxXXXXX"

done

## Creating antitarget files for Tumour only analysis ##
########################################################
#sh cnvkit_create_antitarget.sh 

## Creating flat reference file using target & antitarget files for tumour only analysis ##
###########################################################################################
#sh cnvkit_create_flatref.sh 
