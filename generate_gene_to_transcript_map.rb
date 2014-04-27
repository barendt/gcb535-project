#!/usr/bin/env ruby

require_relative 'environment'

require 'fileutils'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Generates CSV-formatted results of a previous local BLAST

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

rows = Array.new

BlastHit.where(query_taxon: opts[:querytaxon], blastdb: opts[:blastdb], matrix: 'BLOSUM62').select(:query_taxon, :blastdb, :query_id, :target_id, :percent_identity, :evalue).distinct.each do |hit|
  gl = GoaLine.where(db_object_id: hit.product_id).first
  rows << [hit.target_id, gl.db_object_name, gl.uniprot_id, hit.percent_identity, hit.evalue]
end

results_dir = File.join($app_root, 'results', 'gene2transcript')
unless File.exists? results_dir
  FileUtils::mkdir_p results_dir
end

target_taxon = opts[:blastdb].split('/')[1].gsub('.db', '')
csv_file = File.join(results_dir, "#{opts[:querytaxon]}_#{target_taxon}.csv")
File.open(csv_file, 'w') do |f|
  rows.each do |r|
   f.write('"' + r.join('","') + '"' + "\n")
  end
end
