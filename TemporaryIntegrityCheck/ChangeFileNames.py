import subprocess as subp
import os
import re
#import pdb ##Debugging
#pdb.set_trace() #Debugging

def extract_system_name(item):
    file = re.search("b\'(.*)\\\\n", str(item)).group(1)
    file = file.strip()
    return(file)

## Get current working directory
mydirec = subp.Popen("pwd", stdout=subp.PIPE, shell=True)
mydirec.wait()
mydirec = extract_system_name(mydirec.stdout.read()) ## Sorted out things thus far


def ChangeFileNames(GTFile, report_out):
##Read GT list of names
    with open(report_out, "w") as report_out:
        with open(GTFile, "r") as GTFile_IN:
            for line in GTFile_IN:
                line = line.strip()
                match = re.split("\t", line)
                run_folder = match[0]
                sample_name = re.match('([0-9]+\-[a-zA-Z0-9]+)|([a-zA-Z0-9]+)', match[1]).group()
                #print(sample_name) #Debugging
        #For each line regex, loop thugh files in directory from GT list and find file with MolDx number

                list_direc = subp.Popen("ls " + os.path.join(mydirec,run_folder), stdout=subp.PIPE, shell=True)
                list_direc_check = subp.Popen("ls " + os.path.join(mydirec,run_folder), stdout=subp.PIPE, shell=True)
                #list_direc.wait()
                #list_direc_check.wait()

                #Error checking if folder in GT list exists
                if(str(list_direc_check.stdout.readlines()) == "[]"):
                    report_out.write("Folder does not exist => " + run_folder + "\t" + "Sample not changed => " + sample_name + "\n")
                    continue #Skip iteration

                for file in list_direc.stdout.readlines():
                    file = extract_system_name(file)
                    if("fastq.gz" in file and sample_name in file):
                        try:
                            moldx = re.match('([0-9]+\-[0-9]+)|([0-9]+)', file).group()
                        except AttributeError:
                            report_out.write("Regex not able to determine moldx ID" + "\t" + file + "\n")
                            moldx = "" #reset
                            continue #Skip iteration if regex gets no match. Probably not a real sample
                            #print("Regex could not find moldx for " + file) ##Debugging
                        suffix = file.split("_")
                        suffix = "_".join(suffix[1:len(suffix)])
                        if(moldx in sample_name):
                            report_out.write("Name changed" + "\t" + file + " => " + moldx + "_" + suffix + "\n")
                            subp.Popen("mv " + os.path.join(mydirec,run_folder,file) + " " + os.path.join(mydirec,run_folder,moldx + "_" + suffix), stdout=subp.PIPE, shell=True).wait()
                            moldx = "" #reset
                            sample_name = "" #reset

                            #print("Match Found") #Debugging

#                        else:
#                            report_out.write(moldx + "\t" + sample_name + "\t" + "No match found" + "\n")
#                            sample_name = "" #reset
                            #print("Error Match Not Found... Check this.") #Debugging
                    else:
                        continue #skip iteration when reading other files


ChangeFileNames("/Users/sjamal/Documents/Work/2.Scripts/Python/RemoveNonAnonymisedIdentifier/InputDatafolder/NonAnonymised_data_afterRemovingDuplicates_checkedRS.txt", "test")
