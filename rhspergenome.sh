#!/bin/bash

# Add the directory containing the .fa files
cd "Your/Filename/directory"

# Create the CSV file with headers
echo "Filename,RHS_per_genome" > rhs_pergenome.csv

# Loop through each .fa file
for file in *.fa; do
    # Count the number of RHS per genome in the file
    rhs_count=$(grep -c '^>' "$file")
    # Append the filename and RHS count to the CSV file
    echo "$file,$rhs_count" >> rhspergenome.csv
done