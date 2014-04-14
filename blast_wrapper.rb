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
end

Trollop::die :blastdb, "must be specified" unless opts[:blastdb]
Trollop::die :querysequences, "must be specified" unless opts[:querysequences]

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
    bh.save
  end
end

# local_blast_factory = Bio::Blast.local('blastp','cae.db')
# results = local_blast_factory.query('IKTLQNISIQNYFHSKSKTVKFVEVSLANPK*')

# puts results
