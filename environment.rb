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

  unless ActiveRecord::Base.connection.tables.include? 'human_hits'
    create_table :human_hits do |t|
      t.string :go_id
      t.string :uniprot_id
      t.string :description
      t.string :goa_record
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'spider_transcripts'
    create_table :spider_transcripts do |t|
      t.string :species
      t.string :transcript
      t.string :cds
      t.string :translated_sequence
      t.boolean :include_in_analysis
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
