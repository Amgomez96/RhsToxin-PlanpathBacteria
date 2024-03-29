#! /usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

#2008-05-05
#- fork of gb2fasta_pep_loc.pl
#- modified to handle DNA and peptide export
#2008-04-30
#- if there is no locus_tag, look for a gene tag

my $genetcode = 11;
my $use_gene_tag;
my $new_loc;
my $dna;
# my $format = 'fasta';



GetOptions(	"code=s" => \$genetcode,
 		"gene" => \$use_gene_tag,
		"new=s" => \$new_loc,
		"dna" => \$dna);

if ($use_gene_tag && $new_loc) { 
	print "Can't apply a new locus tag and use the gene tag in the same time!\n";
	exit;
}


if($#ARGV<1){
	print "Usage: $0 <gb file> <taxa name>\n";
	print "This program export CDSs from a genbank file to a fasta file\n";
	print "Options:\n\t-code <number>: NCBI genetic code [default=11]
\t-gene: Use the gene tag if the locus_tag is not available [default=OFF]
\t-new <tag>: Apply a new locus tag to each CDS starting form <tag>1
\t-dna: Export DNA sequences instead of proteins\n";
	exit;
}

my $ext = '.pep.loc.fasta';
if($dna) { $ext = '.dna.loc.fasta' }
my $sp=$ARGV[1];
open OUT,">$ARGV[1]$ext";
	
my $seqio_object = Bio::SeqIO->new(-file => $ARGV[0], -format =>'genbank');

my $n = 0;

while (my $seq_object = $seqio_object->next_seq) {
	for my $feat_object ($seq_object->get_SeqFeatures) {
		if ($feat_object->primary_tag eq "CDS") {
			if($new_loc) {
				++$n;
				print OUT ">${new_loc}${n}\n";
				if($dna) { print OUT $feat_object->spliced_seq->seq, "\n"; }
				else { print OUT $feat_object->spliced_seq->translate(-codontable_id => $genetcode)->seq, "\n"; }
			}
			else {
				if ($feat_object->has_tag('locus_tag')) {
					for my $val ($feat_object->get_tag_values('locus_tag')){
						print OUT ">$val\n";
						if($dna) { print OUT $feat_object->spliced_seq->seq, "\n" }
						else { print OUT $feat_object->spliced_seq->translate(-codontable_id => $genetcode)->seq, "\n" }
					}
				}
				elsif ($use_gene_tag) {
					if ($feat_object->has_tag('gene')) {
						for my $val ($feat_object->get_tag_values('gene')){
			# 				print OUT ">$sp","_$val\n";
							print OUT ">$val\n";
							if($dna) { print OUT $feat_object->spliced_seq->seq, "\n" }
							else { print OUT $feat_object->spliced_seq->translate(-codontable_id => $genetcode)->seq, "\n" }
						}
					}
					else { 
						print "Can't find a locus_tag or a gene name for this CDS:\n"; 
							for my $tag ($feat_object->get_all_tags) {
								print "  tag: ", $tag, "\n";
								for my $value ($feat_object->get_tag_values($tag)) {
									print "    value: ", $value, "\n";
								}
							}
					}
				}
				else {
					print "Can't find a locus_tag for this CDS:\n"; 
					for my $tag ($feat_object->get_all_tags) {
						print "  tag: ", $tag, "\n";
						for my $value ($feat_object->get_tag_values($tag)) {
								print "    value: ", $value, "\n";
						}
					}
				}
			}
		}
	}
}

