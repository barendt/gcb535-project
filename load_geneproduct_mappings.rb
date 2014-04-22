#!/usr/bin/env ruby

require_relative 'environment'

require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Loads gp2protein mapping data

Usage:
       ruby load_geneproduct_mappings.rb [options]
where [options] are:
EOS

  opt :mappingfile, 'Path to the mapping file', type: :string
  opt :taxon, 'Taxon to apply this mapping for ', type: :integer
end

[:mappingfile, :taxon].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

if GeneproductMapping.where(taxon: opts[:taxon]).any?
  puts 'Deleting existing mappings for this taxon'
  GeneproductMapping.where(taxon: opts[:taxon]).delete_all
end

File.foreach(opts[:mappingfile]) do |line|
  product, uniprot = line.split("\t")
  product_id = product.split(':').last

  uniprot.split(';').each do |uniprot_id|
    gm = GeneproductMapping.new
    gm.taxon = opts[:taxon]
    gm.product_id = product_id
    gm.uniprot_id = uniprot_id.split(':').last
    gm.save
  end
end
