#!/bin/bash

grep -i "Amplification" PAEDAllReported_180906 >  AmplificaitonsPAED
grep -i "Deletion" PAEDAllReported_180906 > DeletionsPAED
grep -iv "Amplification" PAEDAllReported_180906 | grep -iv "Deletion" > negativesPAED

grep -i "Amplification" ABCBIO_ReportedVariants.txt >  AmplificaitonsABCBIO
grep -i "Deletion" ABCBIO_ReportedVariants.txt > DeletionsABCBIO
grep -iv "Amplification" ABCBIO_ReportedVariants.txt | grep -iv "Deletion" > negativesABCBIO

grep -i "Amplification" GSIC_ReportedVariants.txt >  AmplificaitonsGSIC
grep -i "Deletion" GSIC_ReportedVariants.txt > DeletionsGSIC
grep -iv "Amplification" GSIC_ReportedVariants.txt | grep -iv "Deletion" > negativesGSIC
