#!/usr/bin/env ruby

require_relative './environment'

require 'bio'

query_taxa = {
  7227 => 'Drosophila melanogaster',
  9606 => 'Homo sapiens',
}

puts "\n"
puts "GO-annotated gene counts"
puts "=================="

query_taxa.each do |taxon, species_name|
  puts "#{species_name}: #{GoaLine.where(taxon: taxon).count}"
end

puts "\n"
puts "Initial transcript counts"
puts "========================="
path = "data/spider-transcriptomes"
files = ['Cae_transcriptome_010814.fasta', 'Nep_transcriptome_011314.fasta']
files.each do |fasta_file|
  Bio::FlatFile.open(Bio::FastaFormat, "#{path}/#{fasta_file}") do |ff|
    puts "#{fasta_file}: #{ff.count}"
  end
end

puts "\n"
puts "Transcripts translated and used for analysis"
puts "============================================"
files = ['Cae_filtered_protein_sequences.fasta', 'Nep_filtered_protein_sequences.fasta']
files.each do |fasta_file|
  Bio::FlatFile.open(Bio::FastaFormat, "#{path}/#{fasta_file}") do |ff|
    puts "#{fasta_file}: #{ff.count}"
  end
end

puts "\n"
puts "BLAST hits"
puts "=========="
query = {7227 => 'D. melanogaster', 9606 => 'H. sapiens'}
target = ['blastdb/cae.db', 'blastdb/nep.db']

query.each do |k, v|
  target.each do |t|
    bh = BlastHit.where(query_taxon: k, blastdb: t, matrix: 'BLOSUM62')
    puts "#{v} - #{t}: #{bh.count}"
  end
end

