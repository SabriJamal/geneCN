import subprocess as subp
import os
import re
#import pdb ##Debugging
#pdb.set_trace() #Debugging

def extract_system_name(item):
    file = re.search("b\'(.*)\\\\n", str(item)).group(1)
    return(file)

def get_unique_list(my_list):
    unique_set = set(my_list)
    unique_list = list(unique_set)
    return(unique_list)


def extract_analysis_run_data():
    analysis_data_dict = {}

    ## Get current working directory
    mydirec = subp.Popen("pwd", stdout=subp.PIPE, shell=True)
    mydirec.wait()
    mydirec = extract_system_name(mydirec.stdout.read()) ## Sorted out things thus far


    ## List pool_ids and store in array to later loop
    list_direc = subp.Popen("ls -d " + os.path.join(mydirec, "*/"), stdout=subp.PIPE, shell=True)
    list_direc.wait()


    ## For each pool_id loop and list/store md5sum files as vars
    with open(os.path.join(mydirec, "analysis_direc.report.out.txt"), "w") as OUT:
        with open(os.path.join(mydirec, "analysis_direc.report.clean.out.txt"), "w") as clean_OUT:
            with open(os.path.join(mydirec, "analysis_direc.err.txt"), "w") as err_OUT:
                for pool_id in list_direc.stdout.readlines():
                    pool_id = extract_system_name(pool_id)
                    pool_name = re.split("/", pool_id)
                    pool_name = pool_name[len(pool_name) - 2] #Select second last in path name, NOTE! last index is empty string
                    list_pool_id = subp.Popen("ls " + os.path.join(mydirec, pool_id), stdout=subp.PIPE, shell=True)
                    list_pool_id.wait()

                    run_folder_list = [] #resets between each pool search
                    header = 0
                    for file in list_pool_id.stdout.readlines():
                        file = extract_system_name(file)

                        if(".hpc.csv" in file):
                            with open(os.path.join(mydirec, pool_id, file), "r") as hpc_csv_IN:

                                for line in hpc_csv_IN:
                                    line = line.strip()

                                    if(header == 0):
                                        header = line
                                        continue

                                    match = re.split(",", line)
                                    try:
                                        run_folder_list.append(match[5]) #Stores run folder for index X *******
                                    except IndexError:
                                        print("Index out of bounds for " + pool_name + " ====> " + str(match))

                                ## After parsed hpc.csv file
                                if( len( get_unique_list(run_folder_list) ) > 1):
                                    err_OUT.write("SampleSheet.hpc.csv contains mulitple run folders for => " + pool_name + "\n")
                                    print("SampleSheet.hpc.csv contains mulitple run folders for => " + pool_name) ##Debugging
                                elif( len( get_unique_list(run_folder_list) ) == 1):
                                    run_folder_name = run_folder_list[0]
                                    #Loop through fastq folder
                                    list_fastq_direc = subp.Popen("ls " + os.path.join(mydirec, pool_id, "fastqs"), stdout=subp.PIPE, shell=True)
                                    list_fastq_direc.wait()
                                    for fastq in list_fastq_direc.stdout.readlines():
                                        fastq = extract_system_name(fastq)
                                        if("fastq.gz" in fastq):
                                            key = pool_name + ":" + fastq
                                            if(key not in analysis_data_dict):
                                                analysis_data_dict[key] = [run_folder_name, 0]
                                            elif(key in analysis_data_dict):
                                                new_value_list = analysis_data_dict[fastq]
                                                new_value_list[1] += 1
                                                analysis_data_dict[key] = new_value_list

                for fastq_info, run_folder_list in analysis_data_dict.items():
                    OUT.write(fastq_info + "\t" + " ====> " + "\t" + str(run_folder_list) + "\n")
                    clean_OUT.write(fastq_info + "\t" + " ====> " + "\t" + str(run_folder_list[0]) + "\n")
                    #print(fastq_info + " ====> " + str(run_folder_list)) ##Debugging

extract_analysis_run_data()
