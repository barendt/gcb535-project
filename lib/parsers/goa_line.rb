class GoaLine
  attr_accessor :line, :uniprot_id, :go_id, :description

  def initialize(line)
    self.line = line
    process_line
  end

  private

  def process_line
    pieces = line.split("\t")
    self.uniprot_id = pieces[1]
    self.go_id = pieces[4]
    self.description = pieces[9]
  end
end
