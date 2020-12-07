wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz"" -O dmel-all-chromosome-r6.36.fasta.gz

wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/md5sum.txt" -O md5sum.txt

md5sum --check md5sum.txt


#minimumsize 100000

conda activate ee282
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

faSize dmelrel6_filtered.fa
137547960 bases (490385 N's 137057575 real 137057575 upper 0 lower) in 7 sequences in 1 files
Total size: mean 19649708.6 sd 12099037.5 min 1348131 (4) max 32079331 (3R) median 23542271
N count: mean 70055.0 sd 92459.2
U count: mean 19579653.6 sd 12138278.9
L count: mean 0.0 sd 0.0
%0.00 masked total, %0.00 masked real

#maximum size 100000
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
