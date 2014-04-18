gcb535-project
==============

1. Download the full GO ontology file. http://www.geneontology.org/ontology/obo_format_1_2/gene_ontology_ext.obo
2. Run `go_term_selection.rb` to generated a tab-delimited list of ID and names for candidate annotations.
3. Manually curate the generated file and enter 'Y' in a third column for annotations to include in further analyses.
4. Run `curated_list_to_sqlite.rb` to add these terms to `data/gcb535.sqlite`.
5. Download the Homo sapiens genome annotations from http://www.ebi.ac.uk/GOA/human_release.
6. Run `search_genome_for_term.rb` to search the human genome GOA file for selected annotations.
...

. Run `makeblastdb -in Cae_filtered_protein_sequences.fasta -dbtype prot -out cae.db` (or similar)
. Run `blast_wrapper` to BLAST a FASTA file of GO hits from a model organism against a target BLAST database.