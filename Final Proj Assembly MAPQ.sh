wget "ftp://ftp.sra.ebi.ac.uk/vol1/run/SRR107/SRR10751968/Wounded_1_scRNA_Seq.bam" Wounded_1_scRNA_Seq.bam
wget "ftp://ftp.sra.ebi.ac.uk/vol1/run/SRR107/SRR10751966/Un_Wounded_1_scRNA_Seq.bam" Un_Wounded_1_scRNA_Seq.bam
wget "ftp://ftp.sra.ebi.ac.uk/vol1/run/SRR107/SRR10751969/Wounded_2_scRNA_Seq.bam" Wounded_2_scRNA_Seq.bam
wget "ftp://ftp.sra.ebi.ac.uk/vol1/run/SRR107/SRR10751967/Un_Wounded_2_scRNA_Seq.bam" Un_Wounded_2_scRNA_Seq.bam
wget "ftp://ftp.sra.ebi.ac.uk/vol1/run/SRR107/SRR10751970/Wounded_3_scRNA_Seq.bam" Wounded_3_scRNA_Seq.bam

samtools view Wounded_1_scRNA_Seq.bam | awk -F "\t" '{print $5}' \
|sort \
|uniq -c \
|sort -nr \
> Wounded_1_scRNA_Seq.MapQ.txt

samtools view Wounded_2_scRNA_Seq.bam | awk -F "\t" '{print $5}' \
|sort \
|uniq -c \
|sort -nr \
> Wounded_2_scRNA_Seq.MapQ.txt

samtools view Wounded_3_scRNA_Seq.bam | awk -F "\t" '{print $5}' \
|sort \
|uniq -c \
|sort -nr \
> Wounded_3_scRNA_Seq.MapQ.txt

samtools view Unwounded_1_scRNA_Seq.bam | awk -F "\t" '{print $5}' \
|sort \
|uniq -c \
|sort -nr \
> Unwounded_1_scRNA_Seq.MapQ.txt

samtools view Unwounded_2_scRNA_Seq.bam | awk -F "\t" '{print $5}' \
|sort \
|uniq -c \
|sort -nr \
> Unwounded_2_scRNA_Seq.MapQ.txt


