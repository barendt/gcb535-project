#!/usr/bin/env ruby

# This script processes the original transcriptome FASTA files and writes
# the sequences we want to STDOUT in FASTA format for import with `makeblastdb`

require_relative './environment'

require 'bio'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Translates selected sequences from a transcriptome FASTA file and outputs the
resulting protein sequences in FASTA format to STDOUT

Usage:
        ruby transcripts_to_fasta.rb [options]
where [options] are:
EOS
  
  opt :input, 'Input file (FASTA)', type: :string
  opt :cutoff, 'Cut-off length; AA sequences < cutoff will not be included', default: 100
end

[:input, :cutoff].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

Bio::FlatFile.open(Bio::FastaFormat, opts[:input]) do |ff|
  ff.each do |entry|
    transcript = entry.data.gsub("\n", '')
    next unless transcript.length > opts[:cutoff]*3

    begin
      st = SpiderTranscript.new
      st.transcript = transcript
    rescue StartCodonNotFoundError => e
      next
    end

    unless st.translated_sequence.length < opts[:cutoff]
      puts Bio::Sequence.new(st.translated_sequence).to_fasta(entry.entry_id, 60)
    end
  end
end

