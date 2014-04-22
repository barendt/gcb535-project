class GeneproductMapping < ActiveRecord::Base
  validates_presence_of :taxon, :product_id, :uniprot_id
end
