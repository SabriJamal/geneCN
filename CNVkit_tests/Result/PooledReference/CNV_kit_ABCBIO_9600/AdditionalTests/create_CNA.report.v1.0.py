#!/bin/env python

import os
import re
#import pdb #debugging
#pdb.set_trace() #debugging

###################################################################################
## Calculates and outputs ROIs above and below thresh hold as tab delimited file ##
###################################################################################
def get_CNA(CNA_in, CNA_out, bed, thresh=0.2, ploidy=2):
	file_in = CNA_in
	file_out = CNA_out
	CNA_dict = {}
	header = 0
	ROI_tot_count_dict = Extract_ROI_per_gene(bed) #Collect number of exons/roi targets for each gene

	with open(file_in, "r") as IN:

		for line in IN:
			line = line.rstrip()

			if(header == 0):
				header = line
				continue

			match = re.split("\t", line)

			if(match):
				## If control region, reconstruct annotation e.g 1q_TEL_rsXXXX => 1qTEL_rsXXXX ##
				#################################################################################
				control = re.search(r'([0-9]+)(q|p)_(TEL|CEN)_([a-zA-Z0-9]+)', match[0])
				if(control):
					match[0] = control.group(1) + control.group(2) + control.group(3) + "_" + control.group(4)

			####################################
			## Store CNA stat data per target ##
			####################################
			try:
				log2 = match[4]
				depth = match[5]
				weight = match[6]
				nr_bins = match[7]
				segment_weight = match[8]
				segment_probes = match[9]
			except IndexError:
				print("Index error was caught, does report contain empty lines at EOF?")

			######################################################################
			## Collect CNA data for each target called 							##
			## stores in array in form [ [exon1, exon2], [ [stat1], [stat2] ] ] ##
			######################################################################
			if(match):
				gene = re.split(r'_', match[0])
				if(gene[0] not in CNA_dict):
					CNA_dict[gene[0]] = [ [ gene[1] ], [ [log2,depth,weight,nr_bins,segment_weight, segment_probes] ] ]
				elif(gene[0] in CNA_dict):
					data_tuple = CNA_dict[gene[0]]
					data_tuple[0].append(gene[1])
					data_tuple[1].append([log2,depth,weight,nr_bins,segment_weight, segment_probes])
					CNA_dict[gene[0]] = data_tuple

############################
## Output CNA report file ##
############################
	with open(file_out, "w") as OUT:
		OUT.write("Gene" + "\t" + "Min_log2"  + "\t" + "Max_log2"  + "\t" + "nr_ROI"  + "\t" + "nr_Exons_del"  + "\t" + "Exons_del_names"  + "\t" + "nr_Exons_amp"  + "\t" + "Exons_amp_names"  + "\t" + "perc_Exon_del" + "\t" + "perc_Exon_amp"  + "\t" + "Min_copy_number"  + "\t" + "Max_copy_number" + "\n")
		for gene_name,val_array in CNA_dict.items():
			#print(gene_name)
			del_exon_counter = 0
			del_exon_names = ""
			del_exon_perc = 0
			amp_exon_counter = 0
			amp_exon_names = ""
			amp_exon_perc = 0
			min_log2 = 0
			max_log2 = 0
			min_copies = 0
			max_copies = 0

			nr_ROI = ROI_tot_count_dict[gene_name]
			new_gene_min = 1
			new_gene_max = 1
			## Loop through each exon (to extract stats)
			for i in range(0, len(val_array[0])):
				exon_name = val_array[0][i]
				log2_value = float(val_array[1][i][0])

				#Find exons called as deletions
				if(log2_value < -thresh): # log2 value
					del_exon_counter += 1
					if(del_exon_names == ""):
						del_exon_names = exon_name
					else:
						del_exon_names = del_exon_names + "," + exon_name

				#Find exons called as amplifications
				if(log2_value > thresh):
					amp_exon_counter += 1
					if(amp_exon_names == ""):
						amp_exon_names = exon_name
					else:
						amp_exon_names = amp_exon_names + "," + exon_name

				#Set initial min value
				if(new_gene_min == 1):
					min_log2 = log2_value
					new_gene_min = 0

				#Set initial max value
				if(new_gene_max == 1):
					max_log2 = log2_value
					new_gene_max = 0

				#Replace min value if higher
				if(log2_value < min_log2):
					min_log2 = log2_value

				#Replace max value if higher
				if(log2_value > max_log2):
					max_log2 = log2_value

				##################################################################
				## Loop through each stat (for each exon)						##
				## Note! Disabled funcitonality, (not outputted to report)		##
				## Reason is that currently it is assumed that every exon		##
				## in a gene will have the same stat i.e. Come from the same	##
				## segment														##
				##################################################################
				for k in range(1, len(val_array[1][i])):
					if(k == 1):
						data_as_text = val_array[1][i][k]
					elif(k <= len(val_array[1][i])):
						data_as_text = data_as_text + "\t" + val_array[1][i][k]
					#elif(k == len(val_array[1][i])):
					#	data_as_text = data_as_text + "\t" + val_array[1][i][k]


			##Calc percentage exons called as deletions & amplification
			del_exon_perc = (del_exon_counter/nr_ROI)*100
			amp_exon_perc = (amp_exon_counter/nr_ROI)*100
			min_copies = ploidy*2**(min_log2)
			max_copies = ploidy*2**(max_log2)

			OUT.write(gene_name + "\t" + str(min_log2) + "\t" + str(max_log2) + "\t" + str(nr_ROI) + "\t" + str(del_exon_counter) + "\t" + del_exon_names + "\t" + str(amp_exon_counter) + "\t" + amp_exon_names + "\t" + str(del_exon_perc) + "\t" + str(amp_exon_perc) + "\t" + str(min_copies) + "\t" + str(max_copies) + "\n")

			#Below writes segmentation data to file as well. Although assumes that a gene cannot exist in two segments
			#OUT.write(gene_name + "\t" + str(min_log2) + "\t" + str(max_log2) + "\t" + str(nr_ROI) + "\t" + str(del_exon_counter) + "\t" + del_exon_names + "\t" + str(amp_exon_counter) + "\t" + amp_exon_names + "\t" + str(del_exon_perc) + "\t" + str(amp_exon_perc) + "\t" + data_as_text + "\n")

###############################################################
## Reads in bed file to extract number of ROIs for each gene ##
###############################################################
def Extract_ROI_per_gene(bed):
	file_in = bed
	ROI_dict = {}

	with open(file_in, "r") as IN:

		for line in IN:
			line = line.rstrip()
			match = re.split("\t", line)

			if(match):
				## If control region, reconstruct annotation e.g 1q_TEL_rsXXXX => 1qTEL_rsXXXX ##
				#################################################################################
				control = re.search(r'([0-9]+)(q|p)_(TEL|CEN)_([a-zA-Z0-9]+)', match[3])
				if(control):
					match[3] = control.group(1) + control.group(2) + control.group(3) + "_" + control.group(4)

				roi = re.split(r'_', match[3])

				if(roi[0] not in ROI_dict):
					ROI_dict[roi[0]] = [ roi[1] ]
				elif(roi[0] in ROI_dict):
					add_exon = ROI_dict[roi[0]]
					add_exon.append(roi[1])
					ROI_dict[roi[0]] = add_exon

	###################################################
	## Count number of ROIs per target from bed file ##
	###################################################
	ROI_tot_count_dict = {}
	for key,val in ROI_dict.items():
		for i in range(1, len(val) + 1):
			if(key not in ROI_tot_count_dict):
				ROI_tot_count_dict[key] = i
			elif(key in ROI_tot_count_dict):
				add_count = ROI_tot_count_dict[key]
				add_count += 1
				ROI_tot_count_dict[key] = add_count

	return(ROI_tot_count_dict)

	##Debugging
	#for key, val in ROI_tot_count_dict.items():
	#	print(key + " | " + str(val))



get_CNA("gene_CNA_events.txt", "test.txt", "/Users/sjamal/Documents/Work/2.scripts/geneCN/CNVkit_tests/Result/PooledReference/CNV_kit_ABCBIO_9600/ABCBIO.reference.target-tmp.bed")
