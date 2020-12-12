#Title: Homework4
#Author: Johnny Le
#Date: 12/11/20
Create environment. 

```
conda activate ee282
```
##Summaries of partitions
Retrieve fasta files and md5sum and conduct a check. 

```
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz"" -O dmel-all-chromosome-r6.36.fasta.gz
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/md5sum.txt" -O md5sum.txt
md5sum --check md5sum.txt
```
Then partitional sequences with first greater than 100kb. 
```
infile=/pub/jje/ee282/dmel-all-chromosome-r6.23.fasta.gz
outname=~/dmelrel6_filtered
faFilter \
  -minSize=100000 <(zcat $infile) /dev/stdout \
| tee $outname.fa \
| faSize -detailed /dev/stdin \
| sort -rnk 2,2 \
> $outname.sizes

3R      32079331
3L      28110227
2R      25286936
X       23542271
2L      23513712
Y       3667352
4       1348131
```
Then conduct summaries on my partition. 
```
faSize dmelrel6_filtered.fa
137547960 bases (490385 N's 137057575 real 137057575 upper 0 lower) in 7 sequences in 1 files
Total size: mean 19649708.6 sd 12099037.5 min 1348131 (4) max 32079331 (3R) median 23542271
N count: mean 70055.0 sd 92459.2
U count: mean 19579653.6 sd 12138278.9
L count: mean 0.0 sd 0.0
%0.00 masked total, %0.00 masked real
```
I do the same for sequences less than or equal to 100 kb. 
```
faFilter \
  -maxSize=100000 <(zcat $infile) /dev/stdout \
> $outname.fa 

faSize dmelrel6_filtered.fa
6178042 bases (662593 N's 5515449 real 5515449 upper 0 lower) in 1863 sequences in 1 files
Total size: mean 3316.2 sd 7116.2 min 544 (211000022279089) max 88768 (Unmapped_Scaffold_8_D1580_D1567) median 1567
N count: mean 355.7 sd 1700.6
U count: mean 2960.5 sd 6351.5
L count: mean 0.0 sd 0.0
%0.00 masked total, %0.00 masked real
```
Putting it together, for > 100 kb: 1) 137547960, 2)490385, 3) 7 sequences. 
For <= 100 kb: 1) 6178042, 2)662593, 3)1863 sequences


outname=~/dmelrel6_filtered
bioawk -c fastx '{ print $name,length($seq),gc($seq) }' dmelrel6_filtered.fa \
|column -t \
> $outname.txt


outname=~/dmelrel6_filtered
bioawk -c fastx '{ print length($seq)}' dmelrel6_filtered.fa \
|column -t \
|sort -rn \
> $outname.txt

#For cumulative 
outname=~/dmelrel6_filtered
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 {print $0 "\t" $2 / tot} ' \
| cut -f1 \
> $outname.sizes.txt

plotCDF ~/*.sizes.txt /dev/stdout \
| tee CDF.png \
| display

#N50
#For cumulative 
outname=~/dmelrel6_filtered
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 && $2/tot >= 0.5 {print $1} ' | head -1

#in R do the following commands
dmelrel6_filtered$V1 <- log10(dmelrel6_filtered$V1)
dmelrel6_filtered$V1 <- cut(x=dmelrel6_filtered$V1,breaks = 10)
p <- ggplot(data=dmelrel6_filtered)
p + geom_bar(mapping=aes(x=V1))

wget https://hpc.oit.uci.edu/~solarese/ee282/iso1_onp_a2_1kb.fastq.gz -O iso1_onp_a2_1kb.fastq.gz
gunzip iso1_onp_a2_1kb.fastq.gz
ln -s iso1_onp_a2_1kb.fastq.gz reads.fq
miniconda3/pkgs/minimap2-2.17-hed695b0_3/bin/minimap2 -x ava-pb -t8 reads.fq reads.fq | gzip -1 > reads.paf.gz
miniasm/miniasm -f reads.fq reads.paf.gz > reads.gfa

miniasm/miniasm -f reads.fq overlaps.paf > reads.gfa
miniconda3/pkgs/minimap2-2.17-hed695b0_3/bin/minimap2 -x ava-pb reads.fq iso1_onp_a2_1kb.fastq.gz > overlaps.paf

miniconda3/pkgs/minimap2-2.17-hed695b0_3/bin/minimap2 -Sw5 -L100 -m0 iso1_onp_a2_1kb.fastq.gz{,} \
| gzip -1 > reads.paf.gz

basedir=~/
projname=nanopore_assembly
basedir=$basedir/$projname
raw=$basedir/$projname/data/raw
processed=$basedir/$projname/data/processed
figures=$basedir/$projname/output/figures
reports=$basedir/$projname/output/reports

createProject $projname $basedir
ln -sf iso1_onp_a2_1kb.fastq reads.fq

minimap -t 32 -Sw5 -L100 -m0 reads.fq{,} \
| gzip -1 \
> onp.paf.gz

```
[M::mm_idx_gen::65.584*1.99] collected minimizers
[M::mm_idx_gen::88.736*2.60] sorted minimizers
[M::main::88.736*2.60] loaded/built the index for 506762 target sequence(s)
[M::main] max occurrences of a minimizer to consider: 172
[M::mm_idx_gen::278.109*10.21] collected minimizers
[M::mm_idx_gen::278.662*10.21] sorted minimizers
[M::main::278.662*10.21] loaded/built the index for 23704 target sequence(s)
[M::main] max occurrences of a minimizer to consider: 28
[M::main] Version: 0.2-r123
[M::main] CMD: minimap -t 32 -Sw5 -L100 -m0 reads.fq reads.fq
[M::main] Real time: 312.386 sec; CPU: 3304.826 sec
```

miniasm -f reads.fq onp.paf.gz \
> reads.gfa

```
[M::main] ===> Step 1: reading read mappings <===
[M::ma_hit_read::48.642*1.00] read 42603741 hits; stored 49491864 hits and 438202 sequences (3972983071 bp)
[M::main] ===> Step 2: 1-pass (crude) read selection <===
[M::ma_hit_sub::54.592*1.00] 415518 query sequences remain after sub
[M::ma_hit_cut::55.346*1.00] 43109275 hits remain after cut
[M::ma_hit_flt::56.023*1.00] 28320679 hits remain after filtering; crude coverage after filtering: 45.18
[M::main] ===> Step 3: 2-pass (fine) read selection <===
[M::ma_hit_sub::57.154*1.00] 411417 query sequences remain after sub
[M::ma_hit_cut::57.569*1.00] 26855876 hits remain after cut
[M::ma_hit_contained::58.205*1.00] 25394 sequences and 234066 hits remain after containment removal
[M::main] ===> Step 4: graph cleaning <===
[M::ma_sg_gen] read 205931 arcs
[M::main] ===> Step 4.1: transitive reduction <===
[M::asg_arc_del_trans] transitively reduced 131795 arcs
[M::asg_arc_del_multi] removed 1509 multi-arcs
[M::asg_arc_del_asymm] removed 2683 asymmetric arcs
[M::main] ===> Step 4.2: initial tip cutting and bubble popping <===
[M::asg_cut_tip] cut 887 tips
[M::asg_pop_bubble] popped 655 bubbles and trimmed 4 tips
[M::main] ===> Step 4.3: cutting short overlaps (3 rounds in total) <===
[M::asg_arc_del_multi] removed 0 multi-arcs
[M::asg_arc_del_asymm] removed 2484 asymmetric arcs
[M::asg_arc_del_short] removed 10704 short overlaps
[M::asg_cut_tip] cut 422 tips
[M::asg_pop_bubble] popped 215 bubbles and trimmed 5 tips
[M::asg_arc_del_multi] removed 0 multi-arcs
[M::asg_arc_del_asymm] removed 301 asymmetric arcs
[M::asg_arc_del_short] removed 397 short overlaps
[M::asg_cut_tip] cut 110 tips
[M::asg_pop_bubble] popped 31 bubbles and trimmed 4 tips
[M::asg_arc_del_multi] removed 0 multi-arcs
[M::asg_arc_del_asymm] removed 148 asymmetric arcs
[M::asg_arc_del_short] removed 164 short overlaps
[M::asg_cut_tip] cut 57 tips
[M::asg_pop_bubble] popped 14 bubbles and trimmed 2 tips
[M::main] ===> Step 4.4: removing short internal sequences and bi-loops <===
[M::asg_cut_internal] cut 45 internal sequences
[M::asg_cut_biloop] cut 88 small bi-loops
[M::asg_cut_tip] cut 4 tips
[M::asg_pop_bubble] popped 0 bubbles and trimmed 0 tips
[M::main] ===> Step 4.5: aggressively cutting short overlaps <===
[M::asg_arc_del_multi] removed 0 multi-arcs
[M::asg_arc_del_asymm] removed 75 asymmetric arcs
[M::asg_arc_del_short] removed 95 short overlaps
[M::asg_cut_tip] cut 27 tips
[M::asg_pop_bubble] popped 6 bubbles and trimmed 2 tips
[M::main] ===> Step 5: generating unitigs <===
[M::main] Version: 0.3-r179
[M::main] CMD: miniasm -f reads.fq onp.paf.gz
[M::main] Real time: 66.911 sec; CPU: 66.753 sec
```
awk '/^S/{print ">"$2"\n"$3}' reads.gfa | fold > out.fa

outname=~/iso1_onp_a2_1kb_assemb
bioawk -c fastx '{ print length($seq)}' out.fa \
|column -t \
|sort -rn \
> $outname.txt

outname=~/iso1_onp_a2_1kb_assemb
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 && $2/tot >= 0.5 {print $1} ' | head -1

```
My answer is 4494246
```

#For cumulative 
outname=~/iso1_onp_a2_1kb_assemb
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 {print $0 "\t" $2 / tot} ' \
| cut -f1 \
> $outname.sizes.txt

plotCDF ~/*.sizes.txt /dev/stdout \
| tee CDF.png \
| display

