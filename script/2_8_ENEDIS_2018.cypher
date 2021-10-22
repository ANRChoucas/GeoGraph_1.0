// import des lignes électriques ENEDIS

// 1. bt basse tention
:param importFile => "2_9_ENEDIS_reseau-bt.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with node,toFloat(split(replace(replace(map.geo_point_,"(2:",""),")",""),",")[1]) as long,
toFloat(split(replace(replace(map.geo_point_,"(2:",""),")",""),",")[0]) as lat ,
replace(replace(map.geo_point_,"(2:",""),")","") as id
merge (:ObjetGeo:ObjetRepère:LigneElectrique:sourceENEDIS:v2021 {
	id:id,
	name:"ligne électrique",
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	type:"ligne électrique de basse tension",
	geo_point:point({longitude:long,latitude:lat})
	})-[:hasGeometry]->(node) 
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";
// Added 171353 labels, created 24479 nodes, set 220311 properties, created 24479 relationships, completed after 55313 ms.

// 2. hta moyenne tention 
:param importFile => "2_10_ENEDIS_reseau-hta.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with node,toFloat(split(replace(replace(map.geo_point_,"(2:",""),")",""),",")[1]) as long,
toFloat(split(replace(replace(map.geo_point_,"(2:",""),")",""),",")[0]) as lat ,
replace(replace(map.geo_point_,"(2:",""),")","") as id
merge (:ObjetGeo:ObjetRepère:LigneElectrique:sourceENEDIS:v2021 {
	id:id,
	name:"ligne électrique",
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	type:"ligne électrique de moyenne tension",
	geo_point:point({longitude:long,latitude:lat})
	})-[:hasGeometry]->(node) 
on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";
// Added 37058 labels, created 5294 nodes, set 47646 properties, created 5294 relationships, completed after 41770 ms.


