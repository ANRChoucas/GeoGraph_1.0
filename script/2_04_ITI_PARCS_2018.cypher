// ITI Vercors et Ecrins
:param importFile => "2_04_ITI_PARCS_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with map,node
merge (:ObjetGeo:ObjetRepère:ITI:v2018 {
	id:map.id_cle,
	name:map.nom,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	parc:map.parc
	} )-[:hasGeometry]->(node)
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";
// Added 390 labels, created 65 nodes, set 520 properties, created 65 relationships, completed after 534 ms.

match (n:ITI:v2018 {importFile:'2_4_ITI_PARCS_2018.csv'}) where n.id starts with "GV"  set n:sourceRandoVercors;
// Added 38 labels, completed after 12 ms.

match (n:ITI:v2018 {importFile:'2_4_ITI_PARCS_2018.csv'}) where n.id starts with "GE"  set n:sourceRandoEcrins;
// Added 27 labels, completed after 9 ms.

 
