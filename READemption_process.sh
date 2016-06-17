main(){  
    create_folders
    move_files
    unzip_files
    SRA_TK
    run_Cutadapt
}
INPUT_ref=/home/diarmaid/MA/06-16/READemption/READemption_Me/in_ref
INPUT_ann=/home/diarmaid/MA/06-16/READemption/READemption_Me/in_ann
INPUT_read=/home/diarmaid/MA/06-16/READemption/READemption_Me/in_read
OUTPUT_ref=/home/diarmaid/MA/06-16/READemption/READemption_Me/out_ref
OUTPUT_ann=/home/diarmaid/MA/06-16/READemption/READemption_Me/out_ann
OUTPUT_read=/home/diarmaid/MA/06-16/READemption/READemption_Me/out_read
INPUT_BASIC=/home/diarmaid/MA/06-16/READemption/READemption_Me
FASTQ_DUMP=/home/diarmaid/MA/06-16/bin/sratoolkit.2.6.3-ubuntu64/bin

create_folders(){
     mkdir -p $INPUT_ref $INPUT_ann $INPUT_read $OUTPUT_ref \
	  $OUTPUT_ann $OUTPUT_read
}

move_files(){
    mv $INPUT_BASIC/*fna.gz $INPUT_ref
    mv $INPUT_BASIC/*gff.gz $INPUT_ann
    mv $INPUT_BASIC/*.sra $INPUT_read

}
unzip_files(){
    for FILE in $(ls $INPUT_ann/*.gz $INPUT_ref/*.gz)
    do
	gunzip $FILE
	echo 'unzipping files'
    done    
}

SRA_TK(){
for FILE in $(ls $INPUT_read/*.sra)
do

    $FASTQ_DUMP/fastq-dump $FILE
    echo '.sra file(s) converted to fastq'
done
}

run_cutadapt(){
    for FILE in $(ls $INPUT_read/*.fastq)
    do

	cutadapt -q 15,10 $FILE | \
	    cutadapt -m20 -a A{8} -o $(basename $FILE)_trimmed $FILE
	echo 'fastq file(s) quality- and adapter-trimmed'
    done
}	


