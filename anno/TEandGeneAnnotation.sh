## add TE annotation steps and Gene annotation

#clone this [repo](https://github.com/usadellab/Helixer)

source /data01/mlandi/software/Helixer/env/bin/activate
#version -Helixer.py 0.3.6

/data01/mlandi/software/Helixer/Helixer.py --lineage land_plant \
--fasta-path StarAppleCHR.fa  \
--species gambeya_albida --gff-output-path StarApple.gff3

#get protein sequences
samtools faidx StarAppleCHR.fa
gffread StarApple.gff3 -g StarAppleCHR.fa -y StarAppleProtein.fa

#run eggnog
export EGGNOG_DATA_DIR=/data01/mlandi/databases/eggnog-data/
emapper.py -i ../StarAppleProteinClean.fa  --decorate_gff ../StarApple.gff3  -o star --cpu 20 -m diamond \
--data_dir /data01/mlandi/databases/eggnog-data

#run InterProScan
interproscan.sh -i ../StarAppleProteinClean.fa -d res -f TSV,GFF3,XML -appl Pfam,PANTHER,Gene3D,TIGRFAM,CDD --cpu 16 

#run blastp
database (https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/)

makeblastdb -in uniprot_sprot.fasta -dbtype prot -out swissprot.db
blastp -query ../StarAppleProteinClean.fa -db swissprot.db \
-out star.outfmt6 -outfmt 6 -evalue 1e-6 -num_threads 20 -max_target_seqs 1

#filtered 
awk '$3 >= 40 && $4 >= 100' star.outfmt6 > star.filtered.outfmt6

#final parsing annotations
agat_sp_manage_functional_annotation.pl -f ../eggnog/star.emapper.decorated.gff \
-b ../blastp/star.filtered.outfmt6 -d /data01/mlandi/databases/uniprot/uniprot_sprot.fasta \
-i ../interproscan/res/StarAppleProteinClean.fa.tsv \
--clean_dbxref --clean_name --clean_product --pcd --pe 3 -o StarAppleFinal --cpu 10


### run EDTA
perl edta.pl --genome StarAppleCHR.fa --overwrite 1 --sensitive 1 --threads 10 --anno 1
