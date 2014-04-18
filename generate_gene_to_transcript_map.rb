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

  opt :queryspecies, "Query species (e.g., 'Homo sapiens')", type: :string
  opt :targetspecies, "Target species ('Nep' or 'Cae')", type: :string
end

[:queryspecies, :targetspecies].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

BlastHit
  .where(query_species: opts[:queryspecies], target_species: opts[:targetspecies])
  .select(:query_species, :target_species, :query_id, :target_id).distinct.each do |hit|

  puts hit.to_csv
end
