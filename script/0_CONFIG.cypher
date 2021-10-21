//  création des couches spatiales (nécessite le plugin spatial)
CALL spatial.addLayer("points","wkt","WKT");
CALL spatial.addLayer("lines","wkt","WKT");
CALL spatial.addLayer("polygons","wkt","WKT");

// contraintes
CREATE CONSTRAINT ON ( o:v2021 ) ASSERT o.id IS UNIQUE;
CREATE CONSTRAINT ON (o:ObjetGeo) ASSERT exists(o.name);
CREATE CONSTRAINT ON (o:ObjetGeo) ASSERT exists(o.id);
CREATE CONSTRAINT ON ( objetgeo:ObjetGeo ) ASSERT exists(objetgeo.creationDateTime);
CREATE CONSTRAINT ON ( objetgeo:ObjetGeo ) ASSERT exists(objetgeo.creationType);

CREATE CONSTRAINT ON (objetR:ObjetRepère) ASSERT exists(objetR.importFile);
// toponyme c2c etc ont un importFile mais les toponymes de bdtopo, créés à partir des Nymie 
// n'ont pas de importFile -> pas contrainte sur objetGeo

// index
CREATE INDEX ObjeGeoId FOR (n:ObjetGeo) ON (n.id);
CREATE INDEX NymieId FOR (n:Nymie) ON (n.id);
CREATE INDEX gtype FOR (n:geom) ON (n.gtype);
CREATE INDEX name FOR (n:ObjetGeo) ON (n.name);

// @@ à voir : index fulltext
