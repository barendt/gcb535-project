#!/usr/bin/env ruby

require_relative 'environment'

require 'bio'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Runs local BLAST and adds results to a SQLite database

Usage:
       ruby blast_wrapper.rb [options]
where [options] are:
EOS

  opt :blastdb, 'Local BLAST database', type: :string
  opt :matrix, 'Matrix to use (default: BLOSUM62)', type: :string, default: 'BLOSUM62'
  opt :taxon, 'Taxon to use as query species ', type: :integer
end

[:blastdb, :taxon].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

fasta_file_path = "data/fasta/#{opts[:taxon]}.fasta"
unless File.exists?(fasta_file_path)
  uniprot_ids = Array.new
  GoaLine.where(taxon: opts[:taxon]).each do |gl|
    begin
      uniprot_ids << gl.uniprot_id
    rescue ProductIdNotFoundException => e
    end
  end

  count = 0
  File.open(fasta_file_path, 'w') do |fh|
    while uniprot_ids.length > 0
      batch = uniprot_ids.pop(25)
      fh.write(GoaLine::fasta_for_uniprot_ids(batch))
    end
  end
end

BlastHit.where(query_taxon: opts[:taxon], blastdb: opts[:blastdb], matrix: opts[:matrix]).delete_all

blast_results_file = "data/query-#{opts[:taxon]}_#{opts[:blastdb].split('/').last().gsub('.db', '')}.out"
`blastp -db #{opts[:blastdb]} -query #{fasta_file_path} -outfmt 6 > #{blast_results_file}`

File.open(blast_results_file, 'rb') do |fh|
  report = Bio::Blast::Report.new(fh.read)

  report.each_hit do |hit|
    if hit.evalue < 1e-10
      bh = BlastHit.new
      bh.matrix = opts[:matrix]
      bh.evalue = hit.evalue
      bh.bit_score = hit.bit_score
      bh.identity = hit.identity
      bh.percent_identity = hit.percent_identity
      bh.overlap = hit.overlap
      bh.query_id = hit.query_id
      bh.query_len = hit.query_len
      bh.query_seq = hit.query_seq
      bh.target_id = hit.target_id
      bh.target_len = hit.target_len
      bh.target_seq = hit.target_seq
      bh.query_start = hit.query_start
      bh.query_end = hit.query_end
      bh.target_start = hit.target_start
      bh.target_end = hit.target_end
      bh.query_taxon = opts[:taxon]
      bh.blastdb = opts[:blastdb]
      bh.save
    end
  end

end
