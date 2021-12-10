// ITI visorando
:param importFile => "2_05_ITI_VISORANDO_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with map,node
merge (:ObjetGeo:ObjetRepère:ITI:v2018:sourceVisorando {
	id:map.id_cle,
	name:map.nom,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	parc:map.parc
} )-[:hasGeometry]->(node)
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";
// Added 917 labels, created 131 nodes, set 1048 properties, created 131 relationships, completed after 978 ms.

