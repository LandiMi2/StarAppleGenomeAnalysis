#align reads using minimap2 (v2.24-r1122)
minimap2 -t 10 -x map-hifi ../asm/StarApple.p.fasta \
../../data/HiFi_filtered/filtered_cells_merged.fastq.gz | gzip -c > PrimAligned.paf.gz
pbcstat PrimAligned.paf.gz
calcuts PB.stat > cutoffs 2> calcuts.log
purge_dups -2 -T cutoffs -c PB.base.cov StarApplePrim.split.self.paf.gz \
> dups.bed 2> purge_dups.log
get_seqs -e dups.bed ../asm/StarApple.p.fasta

#run busco 
cd busco
busco -m genome -i ../purged.fa -o firstRoundPurge -l eudicots_odb10 -c 10

cd ../purgeRound2

#run purge 2
minimap2 -t 10 -x map-hifi ../purged.fa \
../../../data/HiFi_filtered/filtered_cells_merged.fastq.gz | gzip -c > PurgeAligned.paf.gz
pbcstat PurgeAligned.paf.gz 
calcuts PB.stat > cutoffs 2> calcuts.log

#runsplit command 
split_fa ../purged.fa > StarApplePurge.split
minimap2 -t 10 -xasm5 -DP StarApplePurge.split \
StarApplePurge.split | gzip -c > StarApplePurge.split.self.paf.gz
#coverage
purge_dups -2 -T cutoffs -c PB.base.cov StarApplePurge.split.self.paf.gz \
> dups.bed 2> purge_dups.log
get_seqs -e dups.bed ../purged.fa

cd ../busco
busco -m genome -i ../purgeRound2/purged.fa -o secondRoundPurge -l eudicots_odb10 -c 10

split_fa ../asm/StarApple.p.fasta > StarApplePrim.split
minimap2 -t 10 -xasm5 -DP StarApplePrim.split \
StarApplePrim.split | gzip -c > StarApplePrim.split.self.paf.gz
