#!/bin/bash

#perl ../../supporting_scripts/copy_number_NPbuild.pl \
# -b /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/REFERENCES/panel_$panel.gc.annotated.bed \
# -o /scratch/DMP/DUDMP/TRANSGEN/sjamal/2.Scripts/geneCN/Home/OUTPUT/panel_$panel.gc.annotated.NP.bed \
# -s sample_gender.list /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700375-TruQ1-T.sort.bam /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700376-TruQ2-T.sort.bam /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700377-TruQ3-T.sort.bam /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700378-TruQ4-T.sort.bam /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700379-TruQ5-T.sort.bam /Users/sjamal/Documents/Work/2.scripts/geneCN/Home/test/1700380-TruQ6-T.sort.bam
#
## Initialising variables ##
############################
mydirec=$(pwd)
panel=$1 # Name of bed file e.g RMH200
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
        echo "Script called => $script $panel"
fi

#For normal cohort, design IF statment incase TumourAsReference used, will need added input tumours/normals
for bam in $(ls /scratch/DMP/DUDMP/TRANSGEN/sjamal/2.Scripts/geneCN/Home/TEST_DATA/NormalCohort/$panel/);
do
	bams="$bams /scratch/DMP/DUDMP/TRANSGEN/sjamal/2.Scripts/geneCN/Home/TEST_DATA/NormalCohort/$panel/$bam"
done

echo $bams
