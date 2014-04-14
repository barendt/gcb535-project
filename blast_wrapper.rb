#!/usr/bin/env ruby

require_relative 'environment'

require 'bio'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Runs local BLAST and adds results to a SQLite database

Usage:
       ruby blast_wrapper.rb [options]
where [options] are:
EOS

  opt :blastdb, 'Local BLAST database', type: :string
  opt :querysequences, 'Query sequences in FASTA format', type: :string
  opt :queryspecies, 'Query species', type: :string
  opt :targetspecies, 'Target species', type: :string
end

[:blastdb, :querysequences, :queryspecies, :targetspecies].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

report = Bio::Blast::Report.new(`blastp -db #{opts[:blastdb]} -query #{opts[:querysequences]} -outfmt 6`)

report.each_hit do |hit|
  if hit.evalue < 1e-10
    bh = BlastHit.new
    bh.evalue = hit.evalue
    bh.overlap = hit.overlap
    bh.query_id = hit.query_id
    bh.query_len = hit.query_len
    bh.query_seq = hit.query_seq
    bh.target_id = hit.target_id
    bh.target_len = hit.target_len
    bh.target_seq = hit.target_seq
    bh.query_start = hit.query_start
    bh.query_end = hit.query_end
    bh.target_start = hit.target_start
    bh.target_end = hit.target_end
    bh.query_species = opts[:queryspecies]
    bh.target_species = opts[:targetspecies]
    bh.save
  end
end
