
// MASSIFS
:param importFile =>"0_MASSIFS_DEP_38.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("polygons",map.WKT) yield node 
with node, map
merge (n:ObjetGeo:ObjetRepère:Massif:RefLocalisation:sourceChoucas:v2018  {
	id:"massif-"+toString(map.id),
	name:map.name,
	importFile:$importFile,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import"
})-[:hasGeometry]->(node)
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";
// Added 21 labels, created 7 nodes, set 14 properties, created 7 relationships
 

// ZONE ETUDE
:param importFile =>"1_ZONE_ETUDE_DEP_38.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("polygons",map.WKT) yield node 
with map,node
merge (n:ObjetGeo:ObjetRepère:RefLocalisation:sourceChoucas:v2018 {
	id:"zoneEtude",
	name:"zone d'étude Choucas",
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile }
	 )-[:hasGeometry]->(node)
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";

