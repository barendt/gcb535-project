require 'active_record'

Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each do |file|
 require file
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

  unless ActiveRecord::Base.connection.tables.include? 'goa_lines'
    create_table :goa_lines do |t|
      t.string :line
      t.string :db
      t.string :db_object_id
      t.string :db_object_symbol
      t.string :db_object_name
      t.string :go_id
      t.string :taxon
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
      t.string :query_taxon
      t.string :blastdb

      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'geneproduct_mappings'
    create_table :geneproduct_mappings do |t|
      t.integer :taxon
      t.string :product_id
      t.string :uniprot_id

      t.timestamps
    end
  end
end
