require 'spec_helper'

describe GoaLine do

  before (:all) do
    @line = "UniProtKB\tA0A183\tLCE6A\t\tGO:0031424\tGO_REF:0000037\tIEA\tUniProtKB-KW:KW-0417\tP\tLate cornified envelope protein 6A\tLCE6A_HUMAN|LCE6A|C1orf44\tprotein\ttaxon:9606\t20140315\tUniProt\t\t\n"
  end

  it 'can be instantiated' do
    GoaLine.new(line: @line)
  end

  it 'stores only the taxon ID piece of the taxon field' do
    gl = GoaLine.new(line: @line)
    gl.taxon.should == '9606'
  end

  it 'processes the line into appropriate attributes' do
    gl = GoaLine.new(line: @line)
    gl.db.should eql('UniProtKB')
    gl.db_object_id.should eql('A0A183')
    gl.db_object_symbol.should eql('LCE6A')
    gl.go_id.should eql('GO:0031424')
    gl.taxon.should eql('9606')
  end

end
