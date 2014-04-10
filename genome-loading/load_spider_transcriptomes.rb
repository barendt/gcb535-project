#!/usr/bin/env ruby

require 'bio'

input_fasta = 'data/spider-transcriptomes/Cae_transcriptome_010814.fasta'

Bio::FlatFile.open(Bio::FastaFormat, input_fasta) do |ff|
  ff.each do |entry|
    puts entry
    exit
  end
end

