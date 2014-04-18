#!/usr/bin/env ruby

require_relative '../environment'

go_term_counts = Hash.new(0)

BlastHit.where(target_species: 'Cae').each do |hit|
  HumanHit.where(uniprot_id: hit.uniprot_id).each do |human|
    go_term_counts[human.go_id] += 1
    #puts "#{hit.target_id},#{hit.uniprot_id},#{human.go_id}"
  end
end

go_term_counts.each do |term, count|
  puts "#{term},#{count}"
end
