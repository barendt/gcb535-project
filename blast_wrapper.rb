#!/usr/bin/env ruby

require_relative 'environment'

require 'bio'

report = Bio::Blast::Report.new(`blastp -db cae.db -query human_hits.fasta -outfmt 6`)

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
