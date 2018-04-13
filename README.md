
# geneCN

GeneCN is designed to perform gene-specific copy number analysis from sequence capture data of cancer samples.  It requires [Bio-DB-HTS][] [version 2.10][BDHv210] or higher. Preparation of the input bed file requires [bedtools].

[Bio-DB-HTS]: https://github.com/Ensembl/Bio-DB-HTS
[BDHv210]:    https://github.com/Ensembl/Bio-DB-HTS/releases/tag/2.10
[bedtools]:   http://bedtools.readthedocs.io/en/latest/index.html

GeneCN consists of two scripts. The first is a Perl script, called `depth-for-geneCN.pl`, which generates coverage data for the sample of interest. The second is an R script, called `geneCN.R`, which normalises the coverage data from `depth-for-geneCN.pl` and generates copy number plots and calls for specific genes of interest.

## Preparing the input bed file

Both scripts take as input a 'bedplus' file of genomic windows. The first three columns of this file are bed standard format (i.e. contig name, zero-based start coordinate, one-based end coordinate), the fourth column is the GC content of the coordinate window on the reference genome, the fifth column is the name of the gene/feature that the window belongs to for copy number state calling, and the sixth column is the median depth for that window in a cohort of unmatched normal samples that have been analysed on the same sequence-capture panel as the sample of interest. (If you do not have a panel of unmatched normal data see the folder _no_normal_panel_available_ for a workaround strategy.) 

The starting point for building this file should be the bed file of regions that are captured by the panel you are using. For example, for Agilent SureSelect panels this will be the first three columns of the _*_Covered.bed_ file that Agilent generates for the design (with the header lines removed). Design files based on GRCh37 can be lifted over to GRCh38 if the data to be analysed will be aligned to the latest genome build. We use the [Ensembl Assembly Converter][] for this but remember to add the 'chr' prefixes back to your contig names after liftover as the Converter strips them off. 

[Ensembl Assembly Converter]: http://www.ensembl.org/Homo_sapiens/Tools/AssemblyConverter

We then split the bed file into small windows of not more than 375bp (five times read length assuming data is 75bp, paired-end is fine), removing any windows that end up less than 90bp wide (20% larger than read length) and adding the proportion of GC to the fourth column. Sorting and merging the initial file first is a good idea, particularly if it has been lifted over:

    bedtools sort -faidx CHROMOSOMES-IN-GENOME-ORDER -i COVERED_REGIONS_FILE | bedtools merge | bedtools makewindows -w 375 -b -| awk '{if (($3-$2) >= 90) print}' | bedtools nuc -fi REF_FILE -bed - | cut -f 1-3,5 | sed 1d > OUTPUT_FILE

Note that the copy number plots generated by geneCN will have the chromosomes ordered in the same order as presented in this file i.e. it needs to be sorted in genome order (chr1, chr2, chr3 etc) not lexicographic order (chr1, chr10, chr11 etc). This is achieved using `bedtools sort` with either `-g` or `-faidx` specified. We have provided the chromosomes-in-genome-order files for use with either option for convenience.

The output file from the above command line then needs to be annotated with feature names. To do this we first generate a set of genomic windows for the genes covered by the sequence-capture experiment. This does not need be every gene covered by the sequence capture, just those for which we will later want to call the copy number state. The genomic windows are generated by the script `find_gene_windows.pl`, which is available in the folder _supporting_scripts_. The required inputs are a text file list of the gene names (one per line) and a tab-delimited text file of chromosome, transcription start, transcription end and gene name, such as can be downloaded from the [UCSC genome browser][] (genome.ucsc.edu/cgi-bin/hgTables), using 'selected fields from primary and related tables' in the output format drop-down menu to select `chrom`, `txStart`, `txEnd`, `name2`. We recommend setting `-e` to 10000, which adds 10kb of flanking sequence to each gene window.

[UCSC genome browser]: http://genome.ucsc.edu/cgi-bin/hgTables

Once the genomic windows for genes of copy number interest are defined, we use them to annotate the previously produced output file:

    bedtools intersect -a PREVIOUS_OUTPUT_FILE -b GENE_WINDOWS_FILE -wb | cut -f 1-4,8 > ANNOTATED_OUTPUT_FILE_1

Windows in the previous output file that do not correspond to genes of copy number interest are used to define the background copy number state and are annotated accordingly:

    bedtools subtract -a PREVIOUS_OUTPUT_FILE -b ANNOTATED_OUTPUT_FILE_1 | sed 's/$/<TAB>background/' > ANNOTATED_OUTPUT_FILE_2

If your capture only includes gene regions then a subset of the genes can be selected as background and the rest as genomic features for copy number calling. The selection of genes to function as 'background' is described in the paper 'The Driver Mutational Landscape of Ovarian Squamous Cell Carcinomas Arising in Mature Cystic Teratoma', published in Clin Cancer Res. 2017 Dec 15;23(24):7633-7640. 

Both of the annotated files are then combined and sorted:

    cat ANNOTATED_OUTPUT_FILE_1 ANNOTATED_OUTPUT_FILE_2 | bedtools sort -faidx chromosomes-in-genome-order -i - > MERGED_OUTPUT

The normal cohort medians are then added to the sixth column using the script `copy_number_NPbuild.pl`, which is available in the folder _supporting_scripts_. The merged output file produced above is given to the `-b` option and a tab-delimited text file of the input bam file paths with the gender of the sample is given to the `-s` option (if you don't know the genders of the normal samples use the preliminary plotting method described in the folder _no_normal_panel_available_ to generate a copy number plot including the sex chromosomes and use that to assign the genetic sex of the normal panel samples). The script recognises genders of 'female' and 'male' (case insensitive), at least three samples of each gender are required for the script to run. If your sequence-capture panel does not include any regions on chrX or chrY you can use the `-x` option (ignore genders, no file needed) instead of `-s`.

You can perform optional checks on your final bed file. The script `copy_number_NPbuild.pl` will warn of any features that have fewer than three genomic windows. It is recommended that such features have their feature name changed from the gene name to 'other', as they will not have enough data points for robust copy number calling. We recommend that you check the distribution of the median values and exclude windows that have abnormally low or high depth compared to the majority of the median values as these will give noisy data points on the copy number plots.

## Preparing the thresholds file (recommended)

The script `geneCN.R` optionally takes as input a tab-delimited text file of thresholds for each genomic feature. In the absence of this file geneCN outputs a score for every genomic feature and requires subsequent manual filtering based on arbitrary thresholds. When a thresholds file is provided, geneCN only outputs scores for genes that have a copy number state that is different from the normal panel samples. This allows more robust detection of copy number changes in low cellularity tumours. 

The thresholds file is a 6-column tab-delimited text file with headers `#Chr`, `Feature`, `upper_limit_female`, `lower_limit_female`, `upper_limit_male`, `lower_limit_male`. The file has one line per genomic feature annotated in the bed file (excluding 'background' and 'other'), with the feature name in column 2 and the chromosome that the feature is on in column 1. For features on the autosomes the upper and lower limits for male and female samples are the same, for features on chrX the upper and lower limits should be calculated from female samples only and for features on chrY the limits should be calculated from male samples only. This prevents features on chrX/Y from being consistently called as deletions in male and female samples respectively.

To calculate the upper and lower limit values, run geneCN on the unmatched normal cohort samples. Calculate the lower limit threshold for each feature as the mean value minus three standard deviations for that feature across the normal cohort and the upper limit as the mean value plus three standard deviations.

## Running geneCN

`depth-for-geneCN.pl` takes as input a bam file for the sample of interest and the bed file described above. An output file name can be specified, if it is not the output will default to a file called _coverage.tmp_.

`geneCN.R` requires 4 command line arguments given in the following order:

1. the output file from `depth-for-geneCN.pl` (e.g., _coverage.tmp_)
2. The bedfile described above
3. A text string of the name of the sample (used in output file names and header lines)
4. A text string of the name of the reference genome used (included as a header line in the output call file)
5. The thresholds tab-delimited text file described above (optional)
6. The gender of the sample (optional)

For example:

```sh
perl depth-for-geneCN.pl -b BEDFILE -o SAMPLE_A.COVERAGE SAMPLE_A.BAM

Rscript geneCN.R SAMPLE_A.COVERAGE BEDFILE SAMPLE_A GRCh38 THRESHOLDS_FILE female
```

## Output files and formats

GeneCN outputs the following files:
1. A tab-delimited text file, called <SAMPLEID>_CNcalls.txt. The file contains a header section including a datestamp, SampleID, Genome build, a QC value and a description of each of the columns in the body of the file. The QC value indicates the level of noise in the data, with higher noise leading to a higher QC value. Note that noisy data might give less reliable calls. The body of the file contains the genomic features of interest and a score reflecting the log2ratio of the sample to the unmatched normal cohort, such that a score of 0 indicates 2 copies.
2. A genome-wide copy number plot, called <SAMPLEID>_CNplot.pdf. Consecutive chromosomes are plotted in alternating colours, with data points in the same order as in the input bed file. Note that bin index rather than chromosomal coordinate is plotted on the x-axis, meaning that the resolution between data points is variable.
3. A series of chromosome plots with each chromosome in a separate file. Background data points are plotted in black, while feature data points are plotted in green and purple with colours alternating between adjacent features.

