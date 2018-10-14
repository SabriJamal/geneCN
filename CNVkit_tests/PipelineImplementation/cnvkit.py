#!/bin/env python

#################
## Description ##
#################
#	- This python script is a template for parsing arguments properly and should be used for all python scripts
###########
## Input ##
###########
  # Input given at call of script.
      # - file_in -> <File to be processed>
      # - output_script -> <Name of output file>

  # Static input (hard coded)
      # - nr_arguments -> Number of arguments given when calling script
      # - script -> Name of script

#####################
## Related scripts ##
#####################
#	- <None>

##################
## Related Docs ##
##################
#	- https://docs.python.org/2/library/getopt.html

        #By: Sabri Jamal
        #Date: 20180410
##------------------------------------------------------------------------------------------------------------------------------------------##


import re
import getopt
import sys
#import pdb ##Debugging

def Write_Script(
output_script,
genome,
tumour,
baseline,
reference,
gatk_grp,
bed,
panel,
genome_build,
mappable_genome,
analysis_dir,
proj_id,
num_cpu
):


	#Instantiating new variables
	with open("/scratch/DMP/DUDMP/TRANSGEN/transgen-mdx/ngs/XTESTINGX/debug.cnvkit.log", "w") as dbug:
		dbug.write("python script entered")

    script_path="" #part of script location will be pushed as input from resource file

	h_doc_command = '''\
#!/bin/bash

source activate CNVkit

## Create CNV folder ##
#######################
if [[ ! -d {analysis_dir}/CNVs/CNVkit/{gatk_grp} ]];
then
	mkdir {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{gatk_grp}
else
	echo "analysis folder already exists."
    echo "Data might be overwritten in {analysis_dir}/CNVs/CNVkit/{gatk_grp}..."
fi

## Call CNAs ##
###############
python {script_path} cnvkit.py batch {analysis_dir}/Alignments/{tumour}.sort.bam -r {reference} \\
  --output-dir {analysis_dir}/CNVs/CNVkit/{gatk_grp} \\
  --output-reference {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{baseline}.reference.cnn \\
  --diagram \\
  --scatter

## Detecting LOH ##
#######################################################
awk '{if($9 != "GT:AD:DP") print $0}' {analysis_dir}/Variants/{gatk_grp}/{tumour}.gvcf > {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{tumour}.excludeWT.gvcf

python {script_path} cnvkit.py scatter {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{tumour}.sort.cnr \\
	-s {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{tumour}.sort.cns \\
	-v {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{tumour}.excludeWT.gvcf \\
	-o {analysis_dir}/CNVs/CNVkit/{gatk_grp}/{tumour}.sort.scatter.AF.pdf


	'''.format(
    output_script=output_script,
    genome=genome,
    tumour=tumour,
    baseline=baseline,
    reference=reference,
    gatk_grp=gatk_grp,
    bed=bed,
    panel=panel,
    genome_build=genome_build,
    mappable_genome=mappable_genome,
    analysis_dir=analysis_dir,
    proj_id=proj_id,
    num_cpu=num_cpu
	) #end of here doc

	with open(output_script, "w") as OUT_DOC:
		OUT_DOC.write(h_doc_command)

def main(argv):
	#file_in = ""
	#output_script = ""
	nr_arguments = 13 #Number of arguments required
	script = sys.argv[0] #Name of script

	#Stores flags with arguments in opts (both flag in and input stored) and flags with no input in args
	#try:
	opts, args = getopt.getopt(argv, "o:a:b:c:d:e:f:g:i:j:k:l:h", ["output_script=", "genome=", "tumour=", "baseline=", "reference=", "gatk_grp=", "bed=", "panel=", "genome_build=", "mappable_genome=", "analysis_dir=", "proj_id=", "num_cpu=", "help="])
	#except getopt.GetoptError: # If no argument given
	print(script + ' -i <in_file> -o <out_file>')
	#sys.exit(2)
	#Loop through flags (opt) and arguments (arg) from opts. Store appropriately
	for opt, arg in opts:
		if opt in ("-h", "--help"):
			print(script + ' -i <in_file> -o <out_file>')
			sys.exit(2)
        elif opt in ("o", "--output_script"):
            output_script = arg
        elif opt in ("a", "--genome"):
            genome = arg
        elif opt in ("b", "--tumour"):
            tumour = arg
        elif opt in ("c", "--baseline"):
            baseline = arg
        elif opt in ("d", "--reference"):
            reference = arg
        elif opt in ("e", "--gatk_grp"):
            gatk_grp = arg
        elif opt in ("f", "--bed"):
            bed = arg
        elif opt in ("g", "--panel"):
            panel = arg
        elif opt in ("h", "--genome_build"):
            genome_build = arg
        elif opt in ("i", "--mappable_genome"):
            mappable_genome = arg
        elif opt in ("j", "--analysis_dir"):
            analysis_dir = arg
        elif opt in ("k", "--proj_id"):
            proj_id = arg
        elif opt in ("l", "--num_cpu"):
            num_cpu = arg
	#If only in or out given print usage and error
	if len(argv)/2 < nr_arguments:
		print("You submitted " + str(int(len(argv)/2)) + " arguments, expected " + str(nr_arguments))
		print('not enough arguments.... see below for run usage:')
		print(script + ' -i <in_file> -o <out_file>')
		for opt, arg in opts:
			print(opt)
		sys.exit(2)

	#pdb.set_trace() #Debugging
	Write_Script(output_script, genome, tumour, baseline, reference, gatk_grp, bed, panel, genome_build, mappable_genome, analysis_dir, proj_id, num_cpu)

	#print('In file is {} and outfile is {}'.format(file_in, output_script))

if __name__ == "__main__":
	main(sys.argv[1:])
