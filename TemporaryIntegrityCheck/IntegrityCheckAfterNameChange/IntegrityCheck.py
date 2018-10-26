import subprocess as subp
import os
import re
#import pdb ##Debugging
#pdb.set_trace() #Debugging
import random

def extract_system_name(item):
    file = re.search("b\'(.*)\\\\n", str(item)).group(1)
    return(file)

## Get current working directory
mydirec = subp.Popen("pwd", stdout=subp.PIPE, shell=True)
mydirec.wait()
mydirec = extract_system_name(mydirec.stdout.read()) ## Sorted out things thus far


## List folders and store in array to later loop
list_direc = subp.Popen("ls -d " + os.path.join(mydirec, "*/"), stdout=subp.PIPE, shell=True)
list_direc.wait()

## For each folder loop and list/store md5sum files as vars
md5before_bol = False
md5after_bol = False
md5_b4_dict = {}
md5_after_dict = {}
bef = 0
aff = 0
for folder in list_direc.stdout.readlines():

    folder = extract_system_name(folder)
    list_folder = subp.Popen("ls " + os.path.join(mydirec, folder), stdout=subp.PIPE, shell=True)
    list_folder.wait()

    for file in list_folder.stdout.readlines():
        file = extract_system_name(file)
        if(file):
            if(".md5sum.tx" in file):
                md5before = file
                md5before_bol = True
            if(".md5sum.RDS.txt" in file):
                md5after = file
                md5after_bol = True
        else:
            print("Error, unexpected formatting when listing")

        if(md5before_bol and md5after_bol):
            with open(os.path.join(mydirec, folder, md5before), "r") as md5b4:
                for line in md5b4:
                    bef += 1
                    line = line.rstrip()
                    key = re.split("/s*", line)[0].strip()
                    run_name = re.split("/", line)
                    run_name = run_name[len(run_name) - 5]

                    sample = re.split("/", line)
                    sample = sample[len(sample) - 1]
                    suffix = sample.split("_")
                    suffix = "_".join(suffix[1:len(suffix)])
                    sample = re.match('([0-9]{2}\-[0-9]+)|([A-Za-z0-9]+)', sample).group()
                    sample = run_name + ":" + sample + suffix


                    if(key and sample and sample != "" and key != ""):
                        if(sample in md5_b4_dict):
                            print(sample)
                        md5_b4_dict[sample] = key
                        key = "" #reset
                        sample = "" #reset
                        md5before = "" #reset
                        md5before_bol = False #reset


            with open(os.path.join(mydirec, folder, md5after), "r") as md5AF:
                count = 0
                for line in md5AF:
                    aff += 1
                    line = line.rstrip()
                    key = re.split("/s*", line)[0].strip()
                    run_name = re.split("/", line)
                    run_name = run_name[len(run_name) - 2]
                    sample = re.split("/", line)
                    sample = sample[len(sample) - 1]
                    suffix = sample.split("_")
                    suffix = "_".join(suffix[1:len(suffix)])
                    sample = re.match('([0-9]{2}\-[0-9]+)|([A-Za-z0-9]+)', sample).group() 
                    sample = run_name + ":" + sample + suffix

                    if(key and sample and sample != "" and key != ""):
                        if(sample in md5_after_dict):
                            print("Reporting non-unique name, check manually.. => " + sample)
                        md5_after_dict[sample] = key
                        key = "" #reset
                        sample = "" #reset
                        md5after = "" #reset
                        md5after_bol = False

with open(os.path.join(mydirec, "integrity_report.txt"), "w") as int_report_out:
    ## Check if equal if true  write report file to system
    for sample,md_key in md5_b4_dict.items():
        if(md5_after_dict[sample]):
            if(md5_b4_dict[sample] == md5_after_dict[sample]):
                int_report_out.write(sample + "\t" "Integrity Maintained\n")
            else:
                int_report_out.write(sample + "\t" "Integrity Lost\n")
        else:
            print("Error, sample was never transferred for sample => " + sample)
            int_report_out.write(sample + "\t" "Never transferred")


## Loop through integrity_report and check all
## md5 as correct, report percentage maintained/lost
sample = ""
md_result = ""
count_fail = 0
count_succ = 0
count_tot = 0
perc_fail = 0
perc_succ = 0
with open(os.path.join(mydirec, "integrity_report.txt"), "r") as IN:
    for line in IN:
        line = line.rstrip()
        match = re.split("\t", line)
        sample = match[0]
        md_result = match[1]

        if("Integrity Maintained" in md_result):
            count_succ += 1
            count_tot += 1
        elif("Integrity Lost" in md_result):
            count_fail += 1
            count_tot += 1

with open(os.path.join(mydirec, "integrity_summary.txt"), "w") as int_report_out:
    perc_fail = count_fail/count_tot * 100
    perc_succ = count_succ/count_tot * 100
    int_report_out.write("Integrity report" + "\n" "Maintained => " + str(perc_succ) + "%" + "\n" + "Lost => " + str(perc_fail) + "%")


count = 0
for key,val in md5_b4_dict.items():
        count += 1

print("Before dict => " + str(bef) + "\n")

count = 0
for key,val in md5_after_dict.items():
        count += 1

print("After dict => " + str(aff) + "\n")
