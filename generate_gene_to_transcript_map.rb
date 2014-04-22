#!/usr/bin/env ruby

require_relative 'environment'

require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Prints CSV-formatted results of a previous local BLAST to STDOUT

Usage:
    ruby generate_gene_to_transcript_map.rb [options]
where [options] are:
EOS

  opt :querytaxon, "Query species taxon (e.g., '7227')", type: :integer
  opt :blastdb, "The BLAST database used ('blastdb/cae.db')", type: :string
end

[:querytaxon, :blastdb].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

BlastHit
  .where(query_taxon: opts[:querytaxon], blastdb: opts[:blastdb])
  .select(:query_taxon, :blastdb, :query_id, :target_id).distinct.each do |hit|

  puts hit.to_csv
end
