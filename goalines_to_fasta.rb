#!/usr/bin/env ruby

require_relative 'environment'

require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Generates a FASTA file from previously process GOA records

Usage:
       ruby goalines_to_fasta.rb [options]
where [options] are:
EOS

  opt :taxon, 'The taxon whose sequences should be used ', type: :integer
end

[:taxon].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

uniprot_ids = Array.new
exception_count = 0

GoaLine.where(taxon: opts[:taxon]).each do |gl|
  begin
    uniprot_ids << gl.uniprot_id
  rescue ProductIdNotFoundException => e
    exception_count += 1
  end
end

unless uniprot_ids.empty?
  batch = uniprot_ids.pop(25)
  puts GoaLine.fasta_for_uniprot_ids batch
end
