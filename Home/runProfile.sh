#!/bin/bash
#BSUB -P DMPMXHAAC
#BSUB -J CrNPGSIC
#BSUB -n 2
#BSUB -e CrNPGSIC.e
#BSUB -o CrNPGSIC.o

#sh 2.createNP_profile.sh ABCBIO normals
#sh 2.createNP_profile.sh RMH200 tumours
#sh 2.createNP_profile.sh PAED normals
sh 2.createNP_profile.sh GSIC normals
