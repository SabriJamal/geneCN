#!/bin/bash
import subprocess as subp
import os
import re
import pandas as pd
import numpy as np
import seaborn as sns; sns.set()
import matplotlib.pyplot as plt
import math
import pdb ##Debugging
#pdb.set_trace() #Debugging

########################################################################################
## General funciton to extract system file/directory name without trailing characters ##
########################################################################################
def extract_system_name(item):
    file = re.search("b\'(.*)\\\\n", str(item)).group(1)
    return(file)

###########################################################################################
## Takes path to bed file as input and selects only genes from bed file for heatmap plot ##
###########################################################################################
def important_genes(bed):
    bed = bed ##Collect important genes from bed file
    cmd = "awk '{print $4'}" + " " + bed + " | " + "sort" + " | " + "uniq"
    uniq_genes = subp.Popen(cmd, stdout=subp.PIPE, shell=True)

    uniq_genes_list = []
    for gene in uniq_genes.stdout.readlines():
        gene = extract_system_name(gene)
        uniq_genes_list.append(gene)
    return(uniq_genes_list)


########################################################
## Function to collect data from FeatureCounts output ##
########################################################
def collect_data_FeatureCount(bed):
    module = "FeatureCounts"
    feature_dict={}
    genes = important_genes(bed)
    gene_list = []
    sample_list = []
    gene_length = 0
    fpk_val = 0
    norm_factor = 0
    files_read = []

    ## Get current working directory
    mydirec = subp.Popen("pwd", stdout=subp.PIPE, shell=True)
    mydirec.wait()
    mydirec = extract_system_name(mydirec.stdout.read()) ## Sorted out things thus far

    ##List all *count files in directory
    list_direc = subp.Popen("ls *counts " + os.path.join(mydirec), stdout=subp.PIPE, shell=True)
    list_direc.wait()

    for count_file in list_direc.stdout.readlines():
        count_file = extract_system_name(count_file)
        count_check = re.split("\.", count_file)
        count_check = count_check[len(count_check) - 1 ]

        if(count_check == "counts" and count_file not in files_read):
            files_read.append(count_file)
            sample_name = re.split("\-", count_file)[0] ## Extracts name, this could create error if format would ever change and does not include trial ID. join to collect all
            sample_list.append(sample_name)
            header = 0
            print("Reading file =======>" + os.path.join(mydirec, count_file))
            with open(os.path.join(mydirec, count_file), "r") as count_IN:
                for line in count_IN:
                    line = line.strip()

                    if(header < 2):
                        #skip first two lines
                        header += 1
                        continue

                    match = re.split("\t", line)

                    if(match):
                        gene = match[0]
                        count = float(match[ len(match) - 1 ])
                        gene_length = float(match[ len(match) - 2 ])
                        fpkm_val = fpk_val * 10**6
                        fpk_val = count/gene_length
                        norm_factor = norm_factor + fpk_val

                        gene_list.append(gene)
                        if(gene not in feature_dict):
                            feature_dict[gene] = [sample_name + ":" + str(fpkm_val) ]
                        elif(gene in feature_dict):
                            new_data_point = feature_dict[gene]
                            new_data_point.append(sample_name + ":" + str(fpkm_val) )
                            feature_dict[gene] = new_data_point
                    else:
                        print("Error... No tabs in line, EOF?")
        else:
            print("Ignoring files not containing counts")
    output = [feature_dict, genes, sample_list, module, norm_factor]
    return(output)

####################################################
## Function to collect data from StringTie output ##
####################################################
def collect_data_StringTie(bed):
    module = "StringTie"
    feature_dict={}
    genes = important_genes(bed)
    gene_list = []
    sample_list = []
    gene_length = 0
    fpk_val = 0
    norm_factor = 0
    files_read = []

    ## Get current working directory
    mydirec = subp.Popen("pwd", stdout=subp.PIPE, shell=True)
    mydirec.wait()
    mydirec = extract_system_name(mydirec.stdout.read()) ## Sorted out things thus far

    ##List all *count files in directory
    list_direc = subp.Popen("ls *abundance.bed " + os.path.join(mydirec), stdout=subp.PIPE, shell=True)
    list_direc.wait()

    for count_file in list_direc.stdout.readlines():
        count_file = extract_system_name(count_file)
        count_check = re.split("\.", count_file)
        count_check = count_check[len(count_check) - 1 ]

        if(count_check == "bed" and count_file not in files_read): ##Change what count_check should equal in the future bed is too generic
            files_read.append(count_file)
            sample_name = re.split("\-", count_file)[0] ##Extract sample name, This could create error if format would ever change and does not include trial ID. join to collect all
            sample_list.append(sample_name)
            header = 0
            print("Reading file =======>" + os.path.join(mydirec, count_file))
            with open(os.path.join(mydirec, count_file), "r") as count_IN:
                for line in count_IN:
                    line = line.strip()

                    if(header < 1):
                        #skip first line
                        header += 1
                        continue

                    match = re.split("\t", line)

                    if(match):
                        gene = match[1]

                        #Last column = TPM i.e len(match) - 1
                        #Second last column = FPKM i.e len(match) - 2
                        norm_count = float(match[ len(match) - 2 ])

                        gene_list.append(gene)
                        if(gene not in feature_dict):
                            feature_dict[gene] = [sample_name + ":" + str(norm_count) ]
                        elif(gene in feature_dict):
                            new_data_point = feature_dict[gene]
                            new_data_point.append(sample_name + ":" + str(norm_count) )
                            feature_dict[gene] = new_data_point
                    else:
                        print("Error... No tabs in line, EOF?")
        else:
            print("Ignoring files not containing counts")
    output = [feature_dict, genes, sample_list, module]
    return(output)

###############################
## Function to plot heat map ##
###############################
def plot_heatmap(data):
    observation = []
    count = 0
    features = []
    genes_discarded = []
    gene_expression_list = []
    feature_dict = data[0] #feature_dict is of form key = Gene | val = [Sample1, Expression1,...,SampleN, ExpressionN]
    genes = data[1]
    sample_list = data[2]
    module = data[3]

    if(len(data) == 5):
        norm_factor = data[4]
    else:
        norm_factor = 1
        print("Values were already converted, no normalization factor needed")


    #############################################################################################
    ## Stores expression values for each gene in a list. Preparing format to create Data frame ##
    #############################################################################################
    for gene, feature_list in feature_dict.items():
        if(gene in genes):
            gene_expression_list.append(gene)
            feature_obs = ":".join(feature_list)
            feature_obs = re.split(":", feature_obs)
            for item in feature_obs:
                count += 1
                if(count % 2 == 0):
                    item = float(item)/norm_factor
                    observation.append(item)
                else:
                    continue #Skip to avoid catching sample names
            features.append(observation) # nested list where each new list is expresison for a gene
            observation = [] #reset

        else:
            ## i.e all other genes in genome
            genes_discarded.append(gene)

    #############################################################################
    ## Create data frame. Create mask for all 0 values to be masked in heatmap ##
    #############################################################################
    feature_df = pd.DataFrame(features, columns=sample_list, index=gene_expression_list) ##Generate Panda dataframe
    feature_df.applymap(np.log2).replace(float('-inf'),0)
    mask = feature_df.isin(values=[0])

    ##############################################################################
    ## Agglomerative Hiearchical clustering fused with heatmap with dendrogram  ##
    ## Issue - labels do not fit properly                                       ##
    ##############################################################################

    ## Limiting which labels to be shown https://stackoverflow.com/questions/27037241/changing-the-rotation-of-tick-labels-in-seaborn-heatmap ##

    ##Normalization factors, z_score used before
        #z_score or=1
        #standard_scale=1
#    plt.figure(figsize=(30,30)) ##Setting figure size
    sns.clustermap(feature_df, metric="euclidean", method="ward", mask=mask, cmap="Blues")
    plt.savefig("heatmap_clustered_{module}.png".format(module=module))

    pdb.set_trace()

    #######################################
    ## Create heatmap without dendrogram ##
    #######################################
#    plt.figure(figsize=(30,30)) ##Setting figure size
#    ax = sns.heatmap(feature_df, annot=True) ##Plot heatmap
#    plt.savefig('heatmap_RNAExpression_30x30_{module}_sqrt_FPKM.png'.format(module=module))
#
#    ## Create heatmap of NaN values, VISUALIZATION
#    sns.heatmap(feature_df.isnull(), cbar=False)
#
#    ## Create heatmap of 0 based values, VISUALIZATION
#    sns.heatmap(feature_df.isin(values=[0]), cbar=False)

######################################################
## Plots expression levels against e.g. median/mean ##
######################################################
def plot_df_data_points(dataframe):
    feature_df = dataframe.copy()

    ## Adding median and mean columns ##
    feature_df["median"] = feature_df.median(axis=1)
    feature_df["mean"] = feature_df.mean(axis=1)

    ####################################################################################
    ## Create scatter plot where annotating data points in graph fulfilling condition ##
    ####################################################################################
    for col in feature_df.columns[0:len(feature_df.columns) - 2]:
        feature_df.plot.scatter(x=col, y="median")
        for samp,med, mean in zip(feature_df[col].iteritems(), feature_df["median"], feature_df["mean"]):
            label = samp[0]
            value = samp[1]
            data_point = [value, med]

            ##Annotate all data points
            #plt.annotate(label,data_point)

            ##Annotate only values larger than median
            #if(value >= med):
            #    plt.annotate(label, data_point)

            ##Annotate only values larger than mean
            if(value >= mean):
                plt.annotate(label, data_point)

        ## Plots and saves all figures seperately
        #plt.savefig("Median." + col + ".png")
        plt.show()

###############################################################################
## Function to perform clustering and investigate occurence of cluster joins ##
###############################################################################
def agglom_clustering(dataframe):
    feature_df = dataframe.copy()

    #############################
    ## Hierarchical clustering ##
    #############################
    ## Import relevant machine learning packages
    ## Tutorial => https://joernhees.de/blog/2015/08/26/scipy-hierarchical-clustering-and-dendrogram-tutorial/
    import scipy
    import sklearn
    from scipy.cluster.hierarchy import dendrogram, linkage, fcluster, cophenet
    from scipy.spatial.distance import pdist
    from sklearn.cluster import AgglomerativeClustering
    X = feature_df.iloc[:,0:len(feature_df.columns) - 2]
    Z = linkage(X, 'ward')
    dendrogram(Z)
    plt.show() #Plot dendrogram
#   plt.savefig("Cluster_dendrogram.png")

    ##############################################################
    ## Plots PCA analysis of 3 features using two components.   ##
    ## Issue - This needs to be looked into. Seems like         ##
    ## analysis is incorrect as each principal component should ##
    ## be its own feature/gene                                  ##
    ##############################################################
    pca_analysis(feature_df)
    plt.show()

################################################################
## Function to perform pca_analysis, dimensionality reduction ##
################################################################
def pca_analysis(dataframe):
    feature_df = dataframe.copy()
    from sklearn.preprocessing import StandardScaler
    from sklearn.decomposition import PCA


    X = feature_df.iloc[:,0:6] ##Hard coded, expects 6 columns are samples
    X = StandardScaler().fit_transform(X) ## Standardize values and sttore as numpy/matrix
    pca = PCA()
    principal_components = pca.fit_transform(X)
    principal_df = pd.DataFrame(data=principal_components, columns=["P1","P2","P3","P4","P5","P6"])
    finalDf = principal_df.copy()
    finalDf["target"] = feature_df.index
    fig = plt.figure(figsize = (8,8))
    ax = fig.add_subplot(1,1,1)
    ax.set_xlabel('Principal Component 1', fontsize = 15)
    ax.set_ylabel('Principal Component 2', fontsize = 15)
    ax.set_title('2 component PCA', fontsize = 20)
    targets = feature_df.index[0:3]
    colors = ['r', 'g', 'b']
    for target, color in zip(targets,colors):
        indicesToKeep = finalDf['target'] == target
        ax.scatter(finalDf.loc[indicesToKeep, ["P1","P2","P3","P4","P5","P6"]]
        , finalDf.loc[indicesToKeep, ["P1","P2","P3","P4","P5","P6"]]
        , c = color
        , s = 50)
        ax.legend(targets)
        ax.grid()





#important_genes(("/Users/sjamal/Documents/Work/2.scripts/Python/bed_files/panel_PAEDV2.bed"))
feature_data_list = collect_data_FeatureCount("/Users/sjamal/Documents/Work/2.scripts/Python/bed_files/panel_PAEDV2.bed")
#feature_data_list = collect_data_StringTie("/Users/sjamal/Documents/Work/2.scripts/Python/bed_files/panel_PAEDV2.bed")
plot_heatmap(feature_data_list)


## (NOTE additional things can be collected to
## measure chimeric reads etc.)
