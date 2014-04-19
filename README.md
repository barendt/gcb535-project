gcb535-project
==============


## Old Process

5. Download the Homo sapiens genome annotations from http://www.ebi.ac.uk/GOA/human_release.
6. Run `search_genome_for_term.rb` to search the human genome GOA file for selected annotations.
...

. Run `makeblastdb -in Cae_filtered_protein_sequences.fasta -dbtype prot -out cae.db` (or similar)
. Run `blast_wrapper` to BLAST a FASTA file of GO hits from a model organism against a target BLAST database.

## New Process

Overview:
- Make local BLAST databases for target species (*Caerostris darwini* and *Nephila clavipes*)
- Select ontology terms
- Search annotated species data for gene products annotated with selected terms
- BLAST the selected gene products against the local BLAST databases (`blast_wrapper`)
- Generate some deliverable output
  - visualizations?
  - mapping of annotated organism gene name to spider transcript identifier


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

### Selecting proteins from annotated genomes

1. Download the annotated genome's GOA-formatted file (http://www.geneontology.org/GO.downloads.annotations.shtml)
2. Run `search_genome_for_term.rb` against the unzipped GOA-formatted file:

    ruby search_genome_for_term.rb  -i data/gene-associations/homo_sapiens/gene_association.goa_human