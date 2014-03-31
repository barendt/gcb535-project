#!/usr/bin/env ruby

terms_to_find = Array.new
if File.exists?('go-terms-curated.csv')
  File.open('go-terms-curated.csv', 'r') do |f|
    while (line = f.gets)
      pieces = line.split(',')
      if pieces[2] == 'Y'
        terms_to_find << pieces[0]
      end
    end
  end
end

puts terms_to_find.join("\n")
