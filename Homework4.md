##Title: Homework4, Author: Johnny Le, Date: 12/11/20

Create environment. 

```
conda activate ee282
```
#Summaries of partitions

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

Answer to the first portion: 
Putting it together, for > 100 kb: 1) 137547960, 2)490385, 3) 7 sequences. 
For <= 100 kb: 1) 6178042, 2)662593, 3)1863 sequences

#Plots of Sequences less than or greater than 100 kb. 

First I find the length of less than or equal to 100 kb. 

```
outnamelenless=~/dmelrel6_filtered_len_Less
bioawk -c fastx '{ print length($seq)}' dmelrel6_filtered.fa \
|column -t \
|sort -rn \
> $outnamelenless.txt
```
Then take txt file and import to R and runn ggplot to make histogram conducting log 10 transformation and 10 breaks. 
```
library(ggplot2)
dmelrel6_filtered$V1 <- log10(dmelrel6_filtered_len_Less$V1)
dmelrel6_filtered$V1 <- cut(x=dmelrel6_filtered_Len_Less$V1,breaks = 10)
p <- ggplot(data=dmelrel6_filtered)
p + geom_bar(mapping=aes(x=V1))
```

Then, find the GC%s

```
outnameGCless=~/dmelrel6_filtered_GC_Less
bioawk -c fastx '{ print gc($seq)}' dmelrel6_filtered.fa \
|column -t \
> $outnameGCless.txt
```
Then take txt file and import to R and runn ggplot to make histogram conducting 10 breaks. 
```
library(ggplot2)
dmelrel6_filtered_GC_Less$V1 <- cut(x=dmelrel6_filtere_GC_Lessd$V1,breaks = 10)
p <- ggplot(data=dmelrel6_filtered_GC_Less)
p + geom_bar(mapping=aes(x=V1))
```
Then conduct cumulative sequence sizes from largest to smallest sequences for less than 100 kb and plotCDF. 

```
outnameCDF=~/dmelrel6_filtered_Less
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 {print $0 "\t" $2 / tot} ' \
| cut -f1 \
> $outnameCDF.sizes.txt

plotCDF dmelrel6_filtered_Less.sizes.txt /dev/stdout \
| tee CDF_less_100kb.png \
| display
```
Do the same above as for greater than 100 kb. 

```
outname=~/dmelrel6_filtered_len_Great
bioawk -c fastx '{ print length($seq)}' dmelrel6_filtered.fa \
|column -t \
|sort -rn \
> $outname.txt

outname=~/dmelrel6_filtered_GC_Great
bioawk -c fastx '{ print gc($seq)}' dmelrel6_filtered.fa \
|column -t \
> $outname.txt

outname=~/dmelrel6_filtered_Great
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 {print $0 "\t" $2 / tot} ' \
| cut -f1 \
> $outname.sizes.txt

plotCDF ~/*.sizes.txt /dev/stdout \
| tee CDF_Great_100kb.png \
| display
```
For histograms in R, I used the following code

```
library(ggplot2)
dmelrel6_filtered_GC_Great$V1 <- cut(x=dmelrel6_filtere_GC_Greatd$V1,breaks = 10)
p <- ggplot(data=dmelrel6_filtered_GC_Great)
p + geom_bar(mapping=aes(x=V1))

library(ggplot2)
dmelrel6_filtered$V1 <- log10(dmelrel6_filtered_len_Great$V1)
dmelrel6_filtered$V1 <- cut(x=dmelrel6_filtered_Len_Great$V1,breaks = 10)
p <- ggplot(data=dmelrel6_filtered)
p + geom_bar(mapping=aes(x=V1))
```

#Genome Assembly 

First, retrieve file. Unzip and give it a call, reads.fq

```
wget https://hpc.oit.uci.edu/~solarese/ee282/iso1_onp_a2_1kb.fastq.gz -O iso1_onp_a2_1kb.fastq.gz
gunzip iso1_onp_a2_1kb.fastq.gz
ln -sf iso1_onp_a2_1kb.fastq reads.fq
```
Then I used Dr. Emerson's minimap and miniasm assembly code. 

```
minimap -t 32 -Sw5 -L100 -m0 reads.fq{,} \
| gzip -1 \
> onp.paf.gz
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

miniasm -f reads.fq onp.paf.gz \
> reads.gfa

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
I converted the gfa file into fa file. 

```
awk '/^S/{print ">"$2"\n"$3}' reads.gfa | fold > out.fa
```

#Assembly assessment

To find the n50, I utilized bioawk and gawk to find the n50. 

```
outname=~/iso1_onp_a2_1kb_assemb
bioawk -c fastx '{ print length($seq)}' out.fa \
|column -t \
|sort -rn \
> $outname.txt

gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 && $2/tot >= 0.5 {print $1} ' | head -1

```

My answer is 4494246 which is less than the community's contig N50 of 21,485,538. My question is, what does that mean? Why is it less than.
Does it mean that my sequencing method is inferior to that of the community's? 

I then adapted prior script to plot on contiguity plot and compare with the contig and scaffold assemblies from Dr. Emerson's pipeline. 

```
#For cumulative 
outname=~/iso1_onp_a2_1kb_assemb
gawk '{ tot=tot+$1; print $1 "\t" tot} END {print tot}' $outname.txt \
| sort -k1,1rn \
| gawk 'NR ==1 {tot = $1 } NR > 1 {print $0 "\t" $2 / tot} ' \
| cut -f1 \
> classrepos/pipeline/data/processed/$outname.sizes.txt

plotCDF {ISO1.r6.ctg.sorted.sizes.txt, ISO1.r6.scaff.sorted.sizes.txt, iso1_onp_a2_1kb_assemb.sizes.txt} /dev/stdout \
| tee classrepos/pipeline/data/processed/CDF.png \
| display

```
Describe which plot is which. 

Finally I calculated BUSCO scores of both my assembly and the contig assembly to compare. 

```
busco -c 32 -i out.fa -l diptera_odb10 -o dmel.busco.output -m genome 	
	
	Results from dataset diptera_odb10              
	C:0.2%[S:0.2%,D:0.0%],F:2.0%,M:97.8%,n:3285      
	7	Complete BUSCOs (C)                       
	7	Complete and single-copy BUSCOs (S)       
	0	Complete and duplicated BUSCOs (D)        
	66	Fragmented BUSCOs (F)                     
	3212	Missing BUSCOs (M)                        
	3285	Total BUSCO groups searched               
	BUSCO analysis done. Total running time: 5532 seconds
  	Results written in /data/homezvol1/johnnl15/dmel.busco.output

busco -c 32 -i ISO1.r6.ctg.fa -l diptera_odb10 -o dmel.busco.ctg.output -m genome 

	Results from dataset diptera_odb10               
	C:99.5%[S:99.1%,D:0.4%],F:0.2%,M:0.3%,n:3285     
	3269	Complete BUSCOs (C)                       
	3255	Complete and single-copy BUSCOs (S)     
	14	Complete and duplicated BUSCOs (D)        
	5	Fragmented BUSCOs (F)                     
	11	Missing BUSCOs (M)                        
	3285	Total BUSCO groups searched       
	BUSCO analysis done. Total running time: 2981 seconds
	Results written in /data/homezvol1/johnnl15/classrepos/pipeline/data/raw/dmel.busco.ctg.output
```

Interesting, that my assembly was only 0.2% complete. Is this due to the RNA sequencing method being not as good as the community's method which achieved 99.5% completion? It seems to be the case. 

