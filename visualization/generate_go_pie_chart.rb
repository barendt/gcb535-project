#!/usr/bin/env ruby

require_relative '../environment'

require 'gchart'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Generates a CSV file GO terms and counts for chart generation

Usage:
       ruby generate_go_pie_chart.rb [options]
where [options] are:
EOS

  opt :querytaxon, 'Query taxon', type: :integer
  opt :blastdb, 'BLAST database', type: :string
end

[:querytaxon, :blastdb].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

go_term_counts = Hash.new(0)

BlastHit.where(query_taxon: opts[:querytaxon], blastdb: opts[:blastdb]).each do |hit|
  GoaLine.where(taxon: opts[:querytaxon], db_object_id: hit.product_id).each do |gl|
    go_term_counts[gl.go_id] += 1
  end
end

target_taxon = opts[:blastdb].split('/')[1].gsub('.db', '')
csv_file = File.join($app_root, 'results', "gochartdata-#{opts[:querytaxon]}_#{target_taxon}.csv")
File.open(csv_file, 'w') do |f|
  go_term_counts.each do |k, v|
    gt = GoTerm.where(go_id: k).first
    f.write "\"#{gt.go_term}\",\"#{v}\"\n"
  end
end
