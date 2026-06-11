#hifiasm assembly 
#hifiasm v0.16.1-r375
hifiasm -o StarApple -t 15 filtered_cells_merged.fastq.gz --primary

#version canu 2.3
canu -d hiCanu.asm -p StarApple -pacbio-hifi filtered_cells_merged.fastq.gz \
genomeSize=800m -useGrid=false -merylThreads=4 -merylMemory=8 corOverlapper=ovl 2> hicanu.log

#version 2.9.5-b1801
flye --pacbio-hifi ../data/HiFi_filtered/filtered_cells_merged.fastq.gz \
-o StarAppleFlye --genome-size 800m --threads 15 --keep-haplotypes 2> flye.log

#genome statisticis using quast (v5.1.0rc1)
quast.py genome1 genome2 genome3 ...

