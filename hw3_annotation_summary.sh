wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/gtf/dmel-all-r6.36.gtf.gz"
wget "ftp://ftp.flybase.net/genomes//Drosophila_melanogaster/dmel_r6.36_FB2020_05/gtf/md5sum.txt"
md5sum --check md5sum.txt
gunzip dmel-all-r6.36.gtf.gz

cut -f3 'dmel-all-r6.36.gtf.gz'\
|sort\
|uniq -c\
|sort -nr
