require 'active_record'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/models/*.rb'].each {|file| require file }

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

  unless ActiveRecord::Base.connection.tables.include? 'annotated_genes'
    create_table :annotated_genes do |t|
      t.string :species
      t.string :go_id
      t.string :db_id
      t.string :db_id_type
      t.string :description
      t.string :goa_record

      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'blast_hits'
    create_table :blast_hits do |t|
      t.string :evalue
      t.integer :overlap
      t.string :query_id
      t.integer :query_len
      t.string :query_seq
      t.string :target_id
      t.integer :target_len
      t.string :target_seq
      t.integer :query_start
      t.integer :query_end
      t.integer :target_start
      t.integer :target_end
      t.string :query_species
      t.string :target_species

      t.timestamps
    end
  end
end
