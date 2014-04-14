#!/usr/bin/env ruby

require 'bio'

require_relative '../environment'

input_fasta = 'data/spider-transcriptomes/Cae_transcriptome_010814.fasta'

exit if SpiderTranscript.any?

no_start_count = 0

Bio::FlatFile.open(Bio::FastaFormat, input_fasta) do |ff|
  ff.each do |entry|
    begin
      st = SpiderTranscript.new
      st.species = 'Cae'
      st.transcript = entry.data
    rescue StartCodonNotFoundError => e
      no_start_count += 1
    end

    st.save
  end
end

puts "Loaded #{SpiderTranscript.all.count} transcripts"
puts "Ignored #{no_start_count} transcripts with no start codon"

