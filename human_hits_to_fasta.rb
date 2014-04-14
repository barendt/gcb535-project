require_relative 'environment'

require 'bio'

uniprot_ids = Array.new

HumanHit.all.each do |hit|
  uniprot_ids << hit.uniprot_id
end

while uniprot_ids.length > 0
  batch = uniprot_ids.pop(25)
  puts Net::HTTP.get('www.ebi.ac.uk', "/Tools/dbfetch/dbfetch?db=uniprotkb;id=#{batch.join(",")}&format=fasta&style=raw")
end
