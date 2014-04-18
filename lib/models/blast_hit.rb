class BlastHit < ActiveRecord::Base

  def to_csv
    "#{target_species},#{target_id},#{query_species},#{query_id}"
  end

  def uniprot_id
    query_id.split('|')[1]
  end

end
