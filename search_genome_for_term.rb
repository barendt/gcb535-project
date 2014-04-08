require_relative 'environment'

data_path = 'data/gene-associations/homo_sapiens/gene_association.goa_human'

File.open(data_path, 'rb') do |f|
  f.each_line do |line|
    next if line.start_with?('!')

    goa_line = GoaLine.new(line)

    if GoTerm.where(go_id: goa_line.go_id).any?
      HumanHit.create_from_goa_line(goa_line).save
    end
  end
end
