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

wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230078/suppl/GSM4230078_Wounded_1_scRNA-Seq.mtx.gz" -O GSM4230078_Wounded_1_scRNA-Seq.mtx.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230078/suppl/GSM4230078_barcodes_Wounded_1_scRNA-Seq.tsv.gz" -O GSM4230078_barcodes_Wounded_1_scRNA-Seq.tsv.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230078/suppl/GSM4230078_genes_Wounded_1_scRNA-Seq.tsv.gz" -O GSM4230078_genes_Wounded_1_scRNA-Seq.tsv.gz 

gunzip GSM4230078_Wounded_1_scRNA-Seq.mtx.gz 
gunzip GSM4230078_genes_Wounded_1_scRNA-Seq.tsv.gz
gunzip GSM4230078_barcodes_Wounded_1_scRNA-Seq.tsv.gz

mv GSM4230078_barcodes_Wounded_1_scRNA-Seq.tsv barcodes.tsv
mv GSM4230078_genes_Wounded_1_scRNA-Seq.tsv genes.tsv
mv GSM4230078_Wounded_1_scRNA-Seq.mtx matrix.mtx

wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230079/suppl/GSM4230079_Wounded_2_scRNA-Seq.mtx.gz" -O GSM4230079_Wounded_2_scRNA-Seq.mtx.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230079/suppl/GSM4230079_barcodes_Wounded_2_scRNA-Seq.tsv.gz" -O GSM4230079_barcodes_Wounded_2_scRNA-Seq.tsv.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230079/suppl/GSM4230079_genes_Wounded_2_scRNA-Seq.tsv.gz" -O GSM4230079_genes_Wounded_2_scRNA-Seq.tsv.gz 

gunzip GSM4230079_Wounded_2_scRNA-Seq.mtx.gz 
gunzip GSM4230079_genes_Wounded_2_scRNA-Seq.tsv.gz
gunzip GSM4230079_barcodes_Wounded_2_scRNA-Seq.tsv.gz

mv GSM4230079_barcodes_Wounded_2_scRNA-Seq.tsv barcodes.tsv
mv GSM4230079_genes_Wounded_2_scRNA-Seq.tsv genes.tsv
mv GSM4230079_Wounded_2_scRNA-Seq.mtx matrix.mtx

wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230080/suppl/GSM4230080_Wounded_3_scRNA-Seq.mtx.gz" -O GSM4230080_Wounded_3_scRNA-Seq.mtx.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230080/suppl/GSM4230080_barcodes_Wounded_3_scRNA-Seq.tsv.gz" -O GSM4230080_barcodes_Wounded_3_scRNA-Seq.tsv.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230080/suppl/GSM4230080_genes_Wounded_3_scRNA-Seq.tsv.gz" -O GSM4230080_genes_Wounded_3_scRNA-Seq.tsv.gz 

gunzip GSM4230080_Wounded_3_scRNA-Seq.mtx.gz 
gunzip GSM4230080_genes_Wounded_3_scRNA-Seq.tsv.gz
gunzip GSM4230080_barcodes_Wounded_3_scRNA-Seq.tsv.gz

mv GSM4230080_barcodes_Wounded_3_scRNA-Seq.tsv barcodes.tsv
mv GSM4230080_genes_Wounded_3_scRNA-Seq.tsv genes.tsv
mv GSM4230080_Wounded_3_scRNA-Seq.mtx matrix.mtx

wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230076/suppl/GSM4230076_Un-Wounded_1_scRNA-Seq.mtx.gz" -O GSM4230076_Un-Wounded_1_scRNA-Seq.mtx.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230076/suppl/GSM4230076_barcodes_Un-Wounded_1_scRNA-Seq.tsv.gz" -O GSM4230076_barcodes_Un-Wounded_1_scRNA-Seq.tsv.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230076/suppl/GSM4230076_genes_Un-Wounded_1_scRNA-Seq.tsv.gz" -O GSM4230076_genes_Un-Wounded_1_scRNA-Seq.tsv.gz 

gunzip GSM4230076_Un-Wounded_1_scRNA-Seq.mtx.gz 
gunzip GSM4230076_genes_Un-Wounded_1_scRNA-Seq.tsv.gz
gunzip GSM4230076_barcodes_Un-Wounded_1_scRNA-Seq.tsv.gz

mv GSM4230076_barcodes_Un-Wounded_1_scRNA-Seq.tsv barcodes.tsv
mv GSM4230076_genes_Un-Wounded_1_scRNA-Seq.tsv genes.tsv
mv GSM4230076_Un-Wounded_1_scRNA-Seq.mtx matrix.mtx

wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230077/suppl/GSM4230077_Un-Wounded_2_scRNA-Seq.mtx.gz" -O GSM4230077_Un-Wounded_2_scRNA-Seq.mtx.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230077/suppl/GSM4230077_barcodes_Un-Wounded_2_scRNA-Seq.tsv.gz" -O GSM4230077_barcodes_Un-Wounded_2_scRNA-Seq.tsv.gz
wget "ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4230nnn/GSM4230077/suppl/GSM4230077_genes_Un-Wounded_2_scRNA-Seq.tsv.gz -O GSM4230077_genes_Un-Wounded_2_scRNA-Seq.tsv.gz 

gunzip GSM4230077_Un-Wounded_2_scRNA-Seq.mtx.gz 
gunzip GSM4230077_genes_Un-Wounded_2_scRNA-Seq.tsv.gz
gunzip GSM4230077_barcodes_Un-Wounded_2_scRNA-Seq.tsv.gz

mv GSM4230077_barcodes_Un-Wounded_2_scRNA-Seq.tsv barcodes.tsv
mv GSM4230077_genes_Un-Wounded_2_scRNA-Seq.tsv genes.tsv
mv GSM4230077_Un-Wounded_2_scRNA-Seq.mtx matrix.mtx

