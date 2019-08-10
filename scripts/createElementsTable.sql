\connect gh411;
drop table elements;



create table elements(chr char(8),
                      element_start int,
                      element_end int,
                      GHid varchar,
                      is_elite boolean,
                      type char(24)
                      );

grant all on table "elements" to trena;

