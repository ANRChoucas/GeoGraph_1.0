// --------------------------------------------------------------------------------------------------------------
// 10. :Construction (lines)
:param importFile => "2_20_BDTOPO_CONSTRUCTION_LINEAIRE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('lines',map.WKT) yield node 
with map,node
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
create (:ObjetGeo:ObjetRepère:Construction:sourceBDTOPO:v2021 {
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 40348 labels, created 5764 nodes, set 46112 properties, created 5764 relationships, completed after 42481 ms.

// --------------------------------------------------------------------------------------------------------------
// 11. :VoieNommée
:param importFile => "2_21_BDTOPO_VOIE_NOMMEE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('lines',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:VoieNommée:sourceBDTOPO:v2021 {
	name: map.NOM_MIN,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.TYPE_VOIE
})-[:hasGeometry]->(node);
// Added 116725 labels, created 16675 nodes, set 133400 properties, created 16675 relationships, completed after 208774 ms.

// --------------------------------------------------------------------------------------------------------------
// 12. :LigneElectrique
:param importFile => "2_22_BDTOPO_LIGNE_ELECTRIQUE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('lines',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:LigneElectrique:sourceBDTOPO:v2021 {
    name: replace(map.ID,'000000',' ')
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.ID
})-[:hasGeometry]->(node);
// Added 1645 labels, created 235 nodes, set 1645 properties, created 235 relationships, completed after 4090 ms.

// --------------------------------------------------------------------------------------------------------------
// 13. :CoursEau
:param importFile => "2_23_BDTOPO_COURS_D_EAU.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('lines',map.WKT) yield node 
with map,node
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
create (:ObjetGeo:ObjetRepère:CoursEau:sourceBDTOPO:v2021 {
    name: map.TOPONYME
	,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.ID
})-[:hasGeometry]->(node);
// Added 7441 labels, created 1063 nodes, set 7441 properties, created 1063 relationships, completed after 20706 ms.

// --------------------------------------------------------------------------------------------------------------
// 14. :ITIautre
:param importFile => "2_24_BDTOPO_ITI_AUTRE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:ITIautre:sourceBDTOPO:v2021 {
    name: ""
	//replace(map.ID,'000000',' ')
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.ID
    ,type:map.NATURE
})-[:hasGeometry]->(node);
// Added 854 labels, created 122 nodes, set 976 properties, created 122 relationships, completed after 682 ms.

// --------------------------------------------------------------------------------------------------------------
// 15. :TransportCable
:param importFile =>'2_25_BDTOPO_TRANSPORT_PAR_CABLE.csv';
call apoc.load.csv($importFile) YIELD map 
call spatial.addWKT('lines',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:TransportCable:sourceBDTOPO:v2021 {
    name: map.TOPONYME
	,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.ID
    ,type:map.NATURE
})-[:hasGeometry]->(node);
// Added 2135 labels, created 305 nodes, set 2440 properties, created 305 relationships, completed after 6035 ms.

