#!/usr/bin/env ruby

require_relative '../environment'

require 'fileutils'
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
individual_hits = Hash.new
product_list = Array.new

BlastHit.where(query_taxon: opts[:querytaxon], blastdb: opts[:blastdb]).each do |hit|
  next if product_list.include?(hit.product_id)
  product_list << hit.product_id

  GoaLine.where(taxon: opts[:querytaxon], db_object_id: hit.product_id).each do |gl|
    go_term_counts[gl.go_id] += 1
    term = GoTerm.where(go_id: gl.go_id).first
    if individual_hits.has_key?(gl.go_id)
      individual_hits[gl.go_id] << gl.db_object_name
    else
      individual_hits[gl.go_id] = [gl.db_object_name]
    end
  end
end

target_taxon = opts[:blastdb].split('/')[1].gsub('.db', '')
csv_file = File.join($app_root, 'results', "gochartdata-#{opts[:querytaxon]}_#{target_taxon}.csv")
File.open(csv_file, 'w') do |f|
  go_term_counts.each do |k, v|
    gt = GoTerm.where(go_id: k).first
    f.write "\"#{k}\",\"#{gt.go_term}\",\"#{v}\"\n"
  end
end

term_results_path = File.join($app_root, 'results', 'go_terms', "#{opts[:querytaxon]}_#{target_taxon}")
unless File.exists? term_results_path
  FileUtils::mkdir_p term_results_path
end

individual_hits.each do |go_id, objects|
  objects.uniq!
  term_file = File.join(term_results_path, "#{go_id.split(':').last}.csv")
  term = GoTerm.where(go_id: go_id).first.go_term
  File.open(term_file, 'w') do |f|
    f.write("\"#{go_id}\",\"#{term.go_term}\"\n")
    objects.each do |object|
      f.write("\"#{object}\"\n")
    end
  end
end


