#!/bin/env python

import os
import re

def get_CNA(CNA_in, CNA_out):
	file_in = CNA_in
	file_out = CNA_out

	with open(file_out, "w") as OUT:
		with open(file_in, "r") as IN:
			for line in IN:
				line = line.rstrip()
				match = re.split("\t", line)

				if(match):
					gene = re.findall(r'[a-zA-Z0-9]+(_)', match[0])
					print(gene)

get_CNA("gene_CNA_events.txt", "test.txt")
