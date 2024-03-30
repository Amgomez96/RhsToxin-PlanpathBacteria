from Bio import SeqIO
from Bio.SeqFeature import SeqFeature, FeatureLocation

# This command extracts the specified region around a locus tag
def extract_region(genbank_file, locus_tag, upstream=5000, downstream=3000):
    
# Parse it with the GenBank file
    records = SeqIO.parse(genbank_file, 'genbank')
    

        # Find the feature corresponding to the main locus tag
        main_feature = None
        for feature in record.features:
            if 'locus_tag' in feature.qualifiers and feature.qualifiers['locus_tag'][0].strip().lower() == locus_tag.strip().lower():
                main_feature = feature
                break

        if main_feature is not None:
            # Define the region of interest
            region_start = max(0, main_feature.location.start - upstream)
            region_end = min(len(record.seq), main_feature.location.end + downstream)

            # Create a new record with the specified region
            new_record = record[region_start:region_end]

            # Print the header and features to the console
            print(new_record.format('genbank'))

            # Save the new record to a new GenBank file
            output_filename = f"{locus_tag}_{record.id}.gb"
            with open(output_filename, 'w') as output_file:
                SeqIO.write(new_record, output_file, 'genbank')

            print(f"GenBank file saved as {output_filename}")

# Specify your list of GenBank files and locus tags
genbank_files = [''
]

locus_tags = [''
]


# Iterate over each combination of GenBank file and locus tag
for genbank_file, locus_tag in zip(genbank_files, locus_tags):
    extract_region(genbank_file, locus_tag)



