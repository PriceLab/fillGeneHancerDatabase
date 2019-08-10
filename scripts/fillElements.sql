\connect gh411;
\copy elements from '/local/users/pshannon/github/fillGeneHancerDatabase/rawData/GeneHancer_elements.txt' delimiter E'\t' CSV HEADER NULL as 'NULL';
