class HumanHit < ActiveRecord::Base

  def self.create_from_goa_line(goa_line)
    hit = HumanHit.new
    hit.go_id = goa_line.go_id
    hit.uniprot_id = goa_line.uniprot_id
    hit.description = goa_line.description
    hit.goa_record = goa_line.line

    return hit
  end

end
