#!/usr/bin/env ruby

# This script processes the original transcriptome FASTA files and writes
# the sequences we want to STDOUT in FASTA format for import with `makeblastdb`

require 'bio'
require_relative './environment'

input_fasta = 'data/spider-transcriptomes/Cae_transcriptome_010814.fasta'

Bio::FlatFile.open(Bio::FastaFormat, input_fasta) do |ff|
  ff.each do |entry|
    begin
      st = SpiderTranscript.new
      st.species = 'Cae'
      st.transcript = entry.data
    rescue StartCodonNotFoundError => e
      next
    end

    unless st.translated_sequence.length < 21
      puts Bio::Sequence.new(st.translated_sequence).to_fasta(entry.entry_id, 60)
    end
  end
end

