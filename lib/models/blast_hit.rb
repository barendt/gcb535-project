class BlastHit < ActiveRecord::Base

  def uniprot_id
    query_id.split('|')[1]
  end

end
