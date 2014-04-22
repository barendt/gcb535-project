require 'spec_helper'

describe BlastHit do

  it 'can extract a UniProt ID from its query ID' do
    subject.stub(:query_id).and_return('sp|Q9Y572|RIPK3_HUMAN')

    subject.uniprot_id.should == 'Q9Y572'
  end

  it 'can return itself as a CSV-formatted string' do
    subject.stub(:query_taxon).and_return('9606')
    subject.stub(:query_id).and_return('sp|Q9Y572|RIPK3_HUMAN')
    subject.stub(:blastdb).and_return('blastdb/nep.db')
    subject.stub(:target_id).and_return('comp1733840_c1_seq7')

    expected_csv = 'blastdb/nep.db,comp1733840_c1_seq7,9606,sp|Q9Y572|RIPK3_HUMAN'
    subject.to_csv.should == expected_csv
  end

end
