\connect gh411;
\copy tfbs from '/local/users/pshannon/github/fillGeneHancerDatabase/rawData/GeneHancer_TFBSs.txt' delimiter E'\t' CSV HEADER NULL as 'NULL';

