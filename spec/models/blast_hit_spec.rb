require 'spec_helper'

require_relative '../../environment'
require_relative '../../lib/models/blast_hit'

describe BlastHit do

  it 'can extract a UniProt ID from its query ID' do
    subject.stub(:query_id).and_return('sp|Q9Y572|RIPK3_HUMAN')

    subject.uniprot_id.should == 'Q9Y572'
  end

  it 'can return itself as a CSV-formatted string' do
    subject.stub(:query_species).and_return('Homo sapiens')
    subject.stub(:query_id).and_return('sp|Q9Y572|RIPK3_HUMAN')
    subject.stub(:target_species).and_return('Nep')
    subject.stub(:target_id).and_return('comp1733840_c1_seq7')

    expected_csv = 'Nep,comp1733840_c1_seq7,Homo sapiens,sp|Q9Y572|RIPK3_HUMAN'
    subject.to_csv.should == expected_csv
  end

end
