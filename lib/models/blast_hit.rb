class BlastHit < ActiveRecord::Base

  def to_csv
    "#{blastdb},#{target_id},#{query_taxon},#{query_id}"
  end

  def product_id
    query_id.split('|')[1]
  end

  def uniprot_id
    product_id
  end

end
