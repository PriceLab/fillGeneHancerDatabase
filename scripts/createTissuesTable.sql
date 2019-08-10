\connect gh411;
drop table tissues;

create table tissues(GHid char(16),
                    source char(16),
		    tissue char(64),
		    category char(64)
                    );

grant all on table "tissues" to trena;

