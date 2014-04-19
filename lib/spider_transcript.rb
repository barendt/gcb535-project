require 'bio'

class StartCodonNotFoundError < StandardError
end

class SpiderTranscript

  attr_accessor :transcript, :cds, :translated_sequence, :species

  def transcript=(value)
    @transcript = value.upcase.gsub("\n", '').gsub('T', 'U')
    process_transcript
  end

  private
  def find_and_storecds
    start_codon_idx = @transcript.index('AUG')

    if start_codon_idx.nil?
      raise StartCodonNotFoundError.new "No start codon found"
    end

    @cds = @transcript[start_codon_idx..-1]
  end

  def process_transcript
    find_and_storecds
    translate_cds
  end

  def translate_cds
    iupac_aa = Bio::Sequence.auto(@cds).translate
    first_stop_idx = iupac_aa.index('*')
    first_stop_idx ||= -1

    @translated_sequence = iupac_aa[0..first_stop_idx]
  end

end
