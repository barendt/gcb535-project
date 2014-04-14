require 'spec_helper'

require_relative '../../environment.rb'
require_relative '../../lib/models/spider_transcript'

describe SpiderTranscript do

  it 'should be able to be created' do
    SpiderTranscript.new
  end

  context 'Finding a CDS' do

    it 'should replace T with U' do
      subject.transcript = 'ATG'
      subject.transcript.should == 'AUG'
    end

    it 'should strip any newline characters in the transcript' do
      subject.transcript = "ATG\nGGA"
      subject.transcript.should == 'AUGGGA'
    end

    it 'should raise an exception if no start codon is found' do
      expect {
        subject.transcript = 'UGAAAGU' 
      }.to raise_exception(StartCodonNotFoundError)
    end

    it 'should have the translated CDS' do
      subject.transcript = 'ATGGGATCATGA'
      subject.translated_sequence.should == 'MGS*'
    end

    it 'should translate only to the first stop codon' do
      subject.transcript = 'ATGGGATCATGA'*2
      subject.translated_sequence.should == 'MGS*'
    end

  end

end
