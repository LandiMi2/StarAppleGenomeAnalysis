# quality control - trimming of both HiFi reads and OmniC reads
#fastp 0.23.4
#hifi reads 
fastp -i hifi_reads.fastq.gz -o filtered_cells_merged.fastq.gz --length_required 10000 --length_limit 30000 -x -f 15

#omniC reads trimmed 
fastp -i /data2/StarApple/OminC/FC2001016-BCC_L01_Read1_Sample_Library_LA-African_Star_Apple_lane_1.fastq.gz -o trimmed_omniC_R1.fastq.gz \
-I /data2/StarApple/OminC/FC2001016-BCC_L01_Read2_Sample_Library_LA-African_Star_Apple_lane_1.fastq.gz -O trimmed_omniC_R2.fastq.gz \
--length_required 50 -f 14 -F 14

