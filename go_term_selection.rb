#!/usr/bin/env ruby

# This script searches a Gene Ontology OBO file and returns a
# tab-separated list of ID and names for terms that include
# one of the defined KEYWORDS

require 'gene_ontology'

KEYWORDS = %w{immun vir antibacteria defens}

go = GeneOntology.new.from_file('data/gene_ontology_ext.obo')
go.id_to_term.each do |term|
  KEYWORDS.each do |keyword|
    if term[1].name.include?(keyword)
      puts "#{term[1].id}\t#{term[1].name}"
      break
    end
  end
end
