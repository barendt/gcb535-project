# gcb535-project

## Prerequisites

- Ruby
- SQLite
- Rubygems
- Local BLAST ()

## Detailed Process

### BLAST database creation

1. Run `transcripts_to_fasta.rb` with a transcriptome FASTA file as input:

    ruby transcripts_to_fasta.rb -i data/spider-transcriptomes/Cae_transcriptome_010814.fasta > Cae_filtered_protein_sequences.fasta

2. Run `makeblastdb` using the generated FASTA file:

    makeblastdb -in Cae_filtered_protein_sequences.fasta -dbtype prot -out cae.db

### GO Term Selection

1. Download the full GO file: http://www.geneontology.org/ontology/obo_format_1_2/gene_ontology_ext.obo
   - Place the file inside the `data` subdirectory
2. Run `go_term_selection.rb > go_terms.txt'
3. View `go_terms.txt` in Numbers and enter 'Y' in a third column for annotations that should be used in further analyses
4. Run `curated_list_to_sqlite.rb` to add these terms to `data/gcb535.sqlite`

### Mapping gene products to UniProt entries

1. Download gp2protein mapping files from http://www.geneontology.org/gp2protein.
2. Load the gp2protein data into the SQLite database, specifying the path to the file and the taxon of the species to which the mapping applies:

    ruby load_geneproduct_mappings.rb -m path/to/gp2protein/file -t 7227

### Selecting proteins from annotated genomes

1. Download the annotated genome's GOA-formatted file (http://www.geneontology.org/GO.downloads.annotations.shtml)
2. Run `search_genome_for_term.rb` against the unzipped GOA-formatted file:

    ruby search_genome_for_term.rb  -i data/gene-associations/homo_sapiens/gene_association.goa_human

### Generating a FASTA file from selected proteins

    ruby goalines_to_fasta.rb -t 7227 > drosophila.fasta

### Running BLAST

Run BLAST by using the wrapper and passing in the local db to use and the taxon of the organism to use for queries:

    ruby blast_wrapper.rb -b blastdb/cae.db -t 9606

BLAST results stored in a text file have the following columns:
- Query ID
- Subject ID
- % identity
- alignment length
- mismatches
- gap opens
- q.start
- q.end
- s.start
- s.end
- evalue
- bit score

### Generating mappings between spider transcripts and model organism gene products

Run `generate_gene_to_transcript_map.rb` and specify the query species taxon ID and the local BLAST db to use.

   ruby generate_gene_to_transcript_map.rb -q 7227 -b blastdb/cae.db

This script will create a directory, `results/gene2transcript`, if it doesn't already exist. The results of this script will be stored in a CSV-formatted
file of the format "#{query_taxon}_#{target_taxon}.csv" (e.g., `7227_cae.csv`).