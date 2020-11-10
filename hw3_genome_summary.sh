wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz"" -O dmel-all-chromosome-r6.36.fasta.gz
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/md5sum.txt" -O md5sum.txt
md5sum --check md5sum.txt
faSize dmel-all-chromosome-r6.36.fasta.gz
