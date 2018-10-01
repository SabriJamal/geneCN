#!/bin/bash
#BSUB -P DMPMXHAAC
#BSUB -J CrNPPAED
#BSUB -n 2
#BSUB -e CrNPPAED.e
#BSUB -o CrNPPAED.o

#sh 2.createNP_profile.sh ABCBIO normals
#sh 2.createNP_profile.sh RMH200 tumours
sh 2.createNP_profile.sh PAED normals
