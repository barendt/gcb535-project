class ProductIdNotFoundException < Exception
end

class GoaLine < ActiveRecord::Base
  after_initialize :init

  def taxon=(value)
    write_attribute(:taxon, value.split(":").last)
  end

  def to_fasta
    fasta_for_uniprot_id self.uniprot_id
  end

  def uniprot_id
    return self.db_object_id if self.db.eql?('UniProtKB')

    gm = GeneproductMapping
      .where(taxon: self.taxon, product_id: self.db_object_id)
      .first

    return gm.uniprot_id unless gm.nil?

    raise ProductIdNotFoundException.new "Unable to find a uniprot_id for #{self.db_object_id}"
  end

  def self.fasta_for_uniprot_ids(uniprot_ids)
    Net::HTTP.get('www.ebi.ac.uk', "/Tools/dbfetch/dbfetch?db=uniprotkb;id=#{uniprot_ids.join(",")}&format=fasta&style=raw")
  end

  private

  def init
    process_line
  end

  def process_line
    pieces = line.split("\t")
    self.db = pieces[0]
    self.db_object_id = pieces[1]
    self.db_object_symbol = pieces[2]
    self.go_id = pieces[4]
    self.db_object_name = pieces[9]
    self.taxon = pieces[12]
  end

  def fasta_for_uniprot_id(uniprot_id)
    Net::HTTP.get('www.ebi.ac.uk', "/Tools/dbfetch/dbfetch?db=uniprotkb;id=#{uniprot_id}&format=fasta&style=raw")
  end
end
