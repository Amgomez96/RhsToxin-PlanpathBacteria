#!/bin/bash

# Add to the directory containing the .fa files
cd "Your/Filename/directory"

# Create a CSV file and add headers
echo "Filename,Locus_tag,Protein_Length" > Rhsprotein_length.csv

# Loop through each .fa file in the directory
for file in *.fa; do
  # Get the filename without path
  filename=$(basename "$file")

  # Extract each entry from the file
  while IFS= read -r entry; do
    # Skip lines starting with ">" (which indicates a new entry)
    if [[ $entry == ">"* ]]; then
      entry_name="${entry:1}"
    else
      # Calculate the protein length
      protein_length=$(echo -n "$entry" | wc -m)
      # Output filename, entry name, and protein length to CSV
      echo "$filename,$entry_name,$protein_length" >> Rhsprotein_length.csv
    fi
  done < "$file"
done
