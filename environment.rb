require 'active_record'

Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder + '/*.rb').each do |file|
    require file
  end
end

options = {
  adapter: 'sqlite3',
  database: 'data/gcb535.sqlite3'
}

ActiveRecord::Base.establish_connection(options)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'go_terms'
    create_table :go_terms do |t|
      t.string :go_id
      t.string :go_term
      t.boolean :immune_related
    end
  end
end
