#We first generated python enviromemt with packages for the mapping steps

#one can install package s
pip install -r requirements.txt
#activate env
source /data01/mlandi/software/mapOmnic/bin/activate
#map OmniC reads on final
bwa index StarAppleGenome.fa
bwa mem -SP -T0 -t 30 StarAppleGenome.fa \
/data01/mlandi/Inqaba/data/OmniC_filtered/new/trimmed_omniC_R1.fastq.gz \
/data01/mlandi/Inqaba/data/OmniC_filtered/new/trimmed_omniC_R2.fastq.gz | \

#run pairtools 
pairtools parse --min-mapq 0 --walks-policy 5unique \
--max-inter-align-gap 30 --nproc-in 4 --nproc-out 4 \
--chroms-path StarAppleGenome.fa.fai.sizes | \
pairtools sort --tmpdir=/data01/mlandi/Inqaba/NewGenomeAnalysis/MapScaf/MapFinalOmniC/tmp --nproc 8 \
| pairtools dedup --nproc-in 4 \
--nproc-out 4 --mark-dups --output-stats stats.txt | pairtools split --nproc-in 4 \
--nproc-out 4 --output-pairs FinalOmniCmapped.pairs --output-sam - | samtools view -bS -@8 | \
samtools sort -@8 -o FinalOmniCmapped.bam ;samtools index FinalOmniCmapped.bam

#runing yahs - this was not run within the enviroment 
yahs StarAppleGenome.fa FinalOmniCmapped.bam -o StarAppleGenome.fa

#map OmniC reads on scaffold
bwa index StarAppleScaf.fa
bwa mem -SP -T0 -t 12 StarAppleScaf.fa \
/data01/mlandi/Inqaba/data/OmniC_filtered/new/trimmed_omniC_R1.fastq.gz \
/data01/mlandi/Inqaba/data/OmniC_filtered/new/trimmed_omniC_R2.fastq.gz | \
pairtools parse --min-mapq 0 --walks-policy 5unique \
--max-inter-align-gap 30 --nproc-in 4 --nproc-out 4 \
--chroms-path StarAppleScaf.fa.fai.sizes | \
pairtools sort --tmpdir=/data01/mlandi/Inqaba/NewGenomeAnalysis/MapScaf/MapScafOmnic/tmp --nproc 8 \
| pairtools dedup --nproc-in 4 \
--nproc-out 4 --mark-dups --output-stats stats.txt | pairtools split --nproc-in 4 \
--nproc-out 4 --output-pairs ScafOmniCmapped.pairs --output-sam - | samtools view -bS -@8 | \
samtools sort -@8 -o ScafOmniCmapped.bam ;samtools index ScafOmniCmapped.bam

#run to generate pretexmap
samtools view -h ScafOmniCmapped.bam | PretextMap -o mapScaf.pretext --sortby length --sortorder descend --mapq 10

#Manual curation 

#Gap filling 
/data01/mlandi/software/LR_Gapcloser/src/LR_Gapcloser.sh -i ../../asm/newCurated/StarAppleScaf.curated.fa \
-l ../../../data/HiFi_filtered/filtered.fasta -s pacbio -t 10



