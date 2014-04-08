require 'csv'

require_relative 'environment'

CSV.foreach('data/go-terms-curated.csv', headers: true) do |row|
  go_id = row[0]
  go_term = row[1]
  immune_related = row[2].eql?('Y') ? true : false

  if immune_related && !GoTerm.where(go_id: go_id).any?
    term = GoTerm.create({
                      go_id: go_id,
                      go_term: go_term,
                      immune_related: immune_related
                      })
  end
end
