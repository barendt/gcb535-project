#!/usr/bin/env ruby

require_relative '../environment'

require 'gchart'

go_term_counts = Hash.new(0)

BlastHit.where(query_taxon: 7227, blastdb: 'blastdb/cae.db').each do |hit|
  puts hit.to_yaml
  exit
  GoaLine.where(taxon: 7227, line: "'%#{hit.product_id}%'").each do |gl|
    puts gl.go_id
  end
end

puts go_term_counts

chart = Gchart.new(
                   type: 'pie',
                   data: [20, 35, 45],
                   filename: '/Users/barendt/chart.png'
                   )

chart.file
