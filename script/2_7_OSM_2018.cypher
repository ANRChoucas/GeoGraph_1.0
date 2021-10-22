:param importFile => "2_8_OSM_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT('polygons',map.WKT) yield node 
with map,node
set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import"
create (:ObjetGeo:ObjetRepère:sourceOSM:WinterSport:v2018 {
    name: map.name
    ,creationDateTime:localdatetime({ timezone: 'Europe/Paris' })
	,creationType:"import"
    ,importFile:$importFile
    ,id:map.id
	,type:"station"
})-[:hasGeometry]->(node);
// Added 154 labels, created 22 nodes, set 176 properties, created 22 relationships, completed after 30 ms.

