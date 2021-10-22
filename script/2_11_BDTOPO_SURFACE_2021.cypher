// --------------------------------------------------------------------------------------------------------------
// 16. :Construction surfacique
:param importFile => "2_26_BDTOPO_CONSTRUCTION_SURFACIQUE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:Construction:sourceBDTOPO:v2021 {
	id:map.ID,
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	nature:map.NATURE
})-[:hasGeometry]->(node);
// Added 1085 labels, created 155 nodes, set 1240 properties, created 155 relationships, completed after 100 ms.

// --------------------------------------------------------------------------------------------------------------
// 17. :SurfaceHydro
:param importFile => "2_27_BDTOPO_SURFACE_HYDRO.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:SurfaceHydro:sourceBDTOPO:v2021 {
	name: map.NOM_P_EAU,
    creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 20412 labels, created 2916 nodes, set 23328 properties, created 2916 relationships, completed after 3100 ms.

// --------------------------------------------------------------------------------------------------------------
// 18. :PlanEau
:param importFile => "2_28_BDTOPO_PLAN_D_EAU.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:PlanEau:sourceBDTOPO:v2021 {
	name: map.TOPONYME,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	id:map.ID,
	type:map.NATURE
})-[:hasGeometry]->(node);
// Added 1680 labels, created 240 nodes, set 1920 properties, created 240 relationships, completed after 694 ms.
					
// --------------------------------------------------------------------------------------------------------------
// 19. :ZoneActivitéIntérêt
:param importFile => "2_29_BDTOPO_ZAI.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:ZoneActivitéIntérêt:sourceBDTOPO:v2021 {
	name: map.TOPONYME
	,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:'import'
    ,importFile:$importFile
    ,id:map.ID
    ,type:map.NATURE
})-[:hasGeometry]->(node);
// Added 35714 labels, created 5102 nodes, set 40816 properties, created 5102 relationships, completed after 11881 ms.

// --------------------------------------------------------------------------------------------------------------
// 20. :EquipementTransport
:param importFile => "2_30_BDTOPO_EQUIPEMENT_TRANSPORT.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:EquipementTransport:sourceBDTOPO:v2021 {
	name: map.TOPONYME
	,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:'import'
    ,importFile:$importFile
    ,id:map.ID
    ,type:map.NATURE
})-[:hasGeometry]->(node);
// Added 9387 labels, created 1341 nodes, set 10728 properties, created 1341 relationships, completed after 5198 ms.

// --------------------------------------------------------------------------------------------------------------
// 21. :Commune
:param importFile => "2_31_BDTOPO_COMMUNE.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:RefLocalisation:Commune:sourceBDTOPO:v2021 {
    name: map.NOM
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:'import'
    ,importFile:$importFile
    ,id:map.ID
    ,insee_com:map.INSEE_COM
})-[:hasGeometry]->(node);
// Added 1488 labels, created 186 nodes, set 1488 properties, created 186 relationships, completed after 1223 ms.

// --------------------------------------------------------------------------------------------------------------
// 22. :ZoneHabitation
:param importFile => "2_32_BDTOPO_ZONE_D_HABITATION.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
with map,node
create (:ObjetGeo:ObjetRepère:ZoneHabitation:sourceBDTOPO:v2021 {
    name: map.TOPONYME
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:'import'
    ,importFile:$importFile
    ,id:map.ID
    ,type:map.NATURE
})-[:hasGeometry]->(node);
// Added 44576 labels, created 6368 nodes, set 50944 properties, created 6368 relationships, completed after 30284 ms.

					
					
