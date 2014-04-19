#!/usr/bin/env ruby

# This script takes a GOA-formatted data file and adds proteins with one of our
# selected GO terms (pulled from GoTerm model) to the SQLite database for
# later use

require_relative 'environment'

require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Processes a GOA-formatted file and adds records with selected GO terms to SQLite
for later use

Usage:
        ruby search_genome_for_term.rb [options]
where [options] are:
EOS

  opt :input, 'Input file (GOA)', type: :string
end

[:input].each do |key|
  Trollop::die key, "must be specified" unless opts[key]
end

File.open(opts[:input], 'rb') do |f|
  f.each_line do |line|
    next if line.start_with?('!')

    goa_line = GoaLine.new(line: line)

    if GoTerm.where(go_id: goa_line.go_id).any?
      goa_line.save
    end
  end
end
