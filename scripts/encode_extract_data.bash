## listing files in 1000 genomes repository in vcf format 
curl ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ 

##
wget -r -c --tries=75 ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/*.genotypes.vcf.gz
