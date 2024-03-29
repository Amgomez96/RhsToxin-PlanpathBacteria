##This command forms a list
#ls *.gbff > list


for x in `List`
do

##this command makes a protein CDS type version 
perl gb2cds.pl $x"_genomic.gbff" $x

##This command searches the file for Rhs proteins using the RHS HMM model
hmmsearch 54_42_Model $x".pep.loc.fasta" > "results_"$x
grep ">>" "results_"$x > "RhsL_"$x
sed 's/>//g' "RhsL_"$x  | sed 's/ //g' > "RhsList_"$x

##This command indexes the database (the whole protein genome file)
esl-sfetch --index $x".pep.loc.fasta" 

## This command uses the list generated from the pipeline to fetch/present the proteins from the database and save them into another file 
esl-sfetch -f $x".pep.loc.fasta" "RhsList_"$x > $x"_FinalRhsList.fa"

done 



