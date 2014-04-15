require 'spec_helper'

require_relative '../../environment'
require_relative '../../lib/models/blast_hit'

describe BlastHit do

  it 'can extract a UniProt ID from its query ID' do
    subject.stub(:query_id).and_return('sp|Q9Y572|RIPK3_HUMAN')

    subject.uniprot_id.should == 'Q9Y572'
  end

end
