


conda activate ee282
infile=/pub/jje/ee282/dmel-all-chromosome-r6.23.fasta.gz
outname=~/dmelrel6_filtered
faFilter \
  -minSize=10000 <(zcat $infile) /dev/stdout \
| tee $outname.fa \
| faSize -detailed /dev/stdin \
| sort -rnk 2,2 \
> $outname.sizes
