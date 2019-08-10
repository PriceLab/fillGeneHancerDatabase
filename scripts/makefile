default:
	@echo create.elements create.associations

create.elements:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f createElementsTable.sql)

create.associations:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f createGeneAssociationsTable.sql)
create.tfbs:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f createTFBsTable.sql)
create.tissues:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f createTissuesTable.sql)

fill.elements:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f fillElements.sql)
fill.associations:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f fillGeneAssociations.sql)
fill.tfbs:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f fillTFBSs.sql)

fill.tissues:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411 -f fillTissues.sql)

psql.session:
	(export PGPASSWORD=trena; psql -h khaleesi -U trena gh411)


