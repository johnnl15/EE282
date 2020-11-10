## Homework3.md

#Summarize Genome Assembly 
1) First get file from flybase, then md5sum.txt, and integrity check. 
2) Integrity check returns, dmel-all-chromosome-r6.36.fasta.gz: OK
```
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz"" -O dmel-all-chromosome-r6.36.fasta.gz

wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/md5sum.txt" -O md5sum.txt

md5sum --check md5sum.txt
>dmel-all-chromosome-r6.36.fasta.gz: OK
```
#Calculate Summaries of the Genome
1) Conduct faSize
2) Total number of nucleotides 143726002, Total number of Ns 1152978, Total number of sequences 1870
```
faSize dmel-all-chromosome-r6.36.fasta.gz
>143726002 bases (1152978 N's 142573024 real 142573024 upper 0 lower) in 1870 sequences in 1 files
>Total size: mean 76858.8 sd 1382100.2 min 544 (211000022279089) max 32079331 (3R) median 1577
>N count: mean 616.6 sd 6960.7
>U count: mean 76242.3 sd 1379508.4
>L count: mean 0.0 sd 0.0
>%0.00 masked total, %0.00 masked real
```

#Summarize an Annotation File
1) Download gtf and md5sum.txt files. 
2) Integrity check with checksum OK. 
```
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/gtf/dmel-all-r6.36.gtf.gz"

wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/gtf/md5sum.txt"

md5sum --check md5sum.txt
>dmel-all-r6.36.gtf.gz: OK 
```
#Compile a Report Summarizing the Annotation

1) Next I counted and sorted based on feature field. 
2) Sought help online from Theedward (https://stackoverflow.com/questions/4921879/getting-the-count-of-unique-values-in-a-column-in-bash). Additinally, received help on fixing the field from -f $FIELD as Theedward suggested to -f3 by Samuel Du. 

```
cut -f3 'dmel-all-r6.36.gtf.gz'\
|sort\
|uniq -c\
|sort -nr

>
189268 exon
 162578 CDS
  46664 5UTR
  33629 3UTR
  30812 start_codon
  30754 stop_codon
  30728 mRNA
  17875 gene
   3047 ncRNA
    485 miRNA
    366 pseudogene
    312 tRNA
    300 snoRNA
    262 pre_miRNA
    115 rRNA
     32 snRNA
```
