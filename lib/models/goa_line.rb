class GoaLine < ActiveRecord::Base

  after_initialize :init

  def taxon=(value)
    write_attribute(:taxon, value.split(":").last)
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
end
