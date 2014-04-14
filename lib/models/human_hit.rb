require 'net/http'

class HumanHit < ActiveRecord::Base

  def to_fasta
    # url = URI.parse("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=uniprotkb;id=#{uniprot_id}&format=fasta&style=raw")
    # req = Net::HTTP::Get.new(url.path)
    # res = Net::HTTP.start(url.host, url.port)
    Net::HTTP.get('www.ebi.ac.uk', "/Tools/dbfetch/dbfetch?db=uniprotkb;id=#{uniprot_id}&format=fasta&style=raw")
  end

  def self.create_from_goa_line(goa_line)
    hit = HumanHit.new
    hit.go_id = goa_line.go_id
    hit.uniprot_id = goa_line.uniprot_id
    hit.description = goa_line.description
    hit.goa_record = goa_line.line

    return hit
  end

end
