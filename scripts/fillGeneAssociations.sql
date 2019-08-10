\connect gh411;
\copy associations from '/local/users/pshannon/github/fillGeneHancerDatabase/rawData/GeneHancer_gene_associations.txt' delimiter E'\t' CSV HEADER NULL as 'NULL';
