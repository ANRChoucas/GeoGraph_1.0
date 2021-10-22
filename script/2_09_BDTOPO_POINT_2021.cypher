// --------------------------------------------------------------------------------------------------------------
// 1. :Nymie:Bati
:param importFile => "2_11_BDTOPO_TOPONYMIE_BATI.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:Nymie:Bati:sourceBDTOPO {
	name: map.GRAPHIE,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	classe:map.CLASSE,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 1925 labels, created 385 nodes, set 3465 properties, created 385 relationships, completed after 502 ms.

// --------------------------------------------------------------------------------------------------------------
// 2. :Construction (points)
:param importFile => "2_12_BDTOPO_CONSTRUCTION_PONCTUELLE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:Construction:sourceBDTOPO:v2021 {
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 14567 labels, created 2081 nodes, set 16648 properties, created 2081 relationships, completed after 2677 ms.

// --------------------------------------------------------------------------------------------------------------
// 3. :DetailHydro
:param importFile => "2_13_BDTOPO_DETAIL_HYDROGRAPHIQUE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:DetailHydro:sourceBDTOPO:v2021 {
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 21903 labels, created 3129 nodes, set 25032 properties, created 3129 relationships, completed after 6135 ms.

// --------------------------------------------------------------------------------------------------------------
// 4. :Nymie:Hydro
:param importFile => "2_14_BDTOPO_TOPONYMIE_HYDROGRAPHIE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:Nymie:Hydro:sourceBDTOPO {
	name: map.GRAPHIE,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	classe:map.CLASSE,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 8650 labels, created 1730 nodes, set 15570 properties, created 1730 relationships, completed after 6167 ms.

// --------------------------------------------------------------------------------------------------------------
// 5. :DetailOro
:param importFile => "2_15_BDTOPO_DETAIL_OROGRAPHIQUE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:DetailOro:sourceBDTOPO:v2021 {
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 25228 labels, created 3604 nodes, set 28832 properties, created 3604 relationships, completed after 13487 ms.

// --------------------------------------------------------------------------------------------------------------
// 6. :Nymie:LieuxNommés
:param importFile => "2_16_BDTOPO_LIEUX_NOMMES.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:Nymie:LieuxNommés:sourceBDTOPO {
	name: map.GRAPHIE,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	classe:map.CLASSE,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 67950 labels, created 13590 nodes, set 122310 properties, created 13590 relationships, completed after 65582 ms.

// --------------------------------------------------------------------------------------------------------------
// 7. :Nymie:ServicesActivités
:param importFile => "2_17_BDTOPO_TOPONYMIE_SERVICES_ET_ACTIVITES.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:Nymie:ServicesActivités:sourceBDTOPO {
	name: map.GRAPHIE,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	classe:map.CLASSE,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 16640 labels, created 3328 nodes, set 29952 properties, created 3328 relationships, completed after 32687 ms.

// --------------------------------------------------------------------------------------------------------------
// 8. :Nymie:Transport
:param importFile => "2_18_BDTOPO_TOPONYMIE_TRANSPORT.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:Nymie:Transport:sourceBDTOPO {
	name: map.GRAPHIE,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	classe:map.CLASSE,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 4530 labels, created 906 nodes, set 8154 properties, created 906 relationships, completed after 10375 ms.

// --------------------------------------------------------------------------------------------------------------
// 9. :Pylone
:param importFile => "2_19_BDTOPO_PYLONE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('points',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:Pylone:sourceBDTOPO:v2021 {
    name: replace(map.ID,'000000',' ')
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.ID
    ,hauteur:map.HAUTEUR
})-[:hasGeometry]->(node);
// Added 16632 labels, created 2376 nodes, set 19008 properties, created 2376 relationships, completed after 27769 ms.

