class BlastHit < ActiveRecord::Base

  def to_csv
    "#{blastdb},#{target_id},#{query_taxon},#{query_id}"
  end

  def product_id
    uniprot_id = query_id.split('|')[1]

    return uniprot_id if query_taxon == 9606

    return GeneproductMapping.where(uniprot_id: uniprot_id).first.product_id
  end

  def uniprot_id
    product_id
  end

end
