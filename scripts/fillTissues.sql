\connect gh411;
\copy tissues from '/local/users/pshannon/github/fillGeneHancerDatabase/rawData/GeneHancer_tissues.txt' delimiter E'\t' CSV HEADER NULL as 'NULL';

