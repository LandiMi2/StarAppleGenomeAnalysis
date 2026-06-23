#kmer analysis - pre assembly analysis jellyfish 2.2.8
jellyfish count -C -m 21 -s 1000000000 -t 20 <(zcat ./../data/HiFi_filtered/filtered_cells_merged.fastq.gz) -o StarApple.jr
jellyfish histo -t 20 StarApple.jr > StarApple.histo
#view the plots on genomescope2 - genetated figure 2a
/usr/bin/Rscript /data01/mlandi/software/genomescope2.0/genomescope.R -i StarApple.histo -o StarApple -k 21

#Ploidy estimation using smudgeplot v0.5.4 - figure 2b
FastK -v -t4 -k31 -M16 -T4 /data01/mlandi/Inqaba/data/HiFi_filtered/filtered_cells_merged.fastq.gz -NStatKmer21
smudgeplot.py hetmers -L 12 -t 4 -o kmerpairs --verbose StatKmer31
python3.11 /usr/local/bin/smudgeplot.py all -o trialKmer31 kmerpairs.smu -ylim 100


