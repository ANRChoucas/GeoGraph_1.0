// 3. POI refuges Info
:param importFile => "2_03_REFUGES_INFO_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("points",map.WKT) yield node 
with map,node, toFLoat(replace(split(map.WKT, ' ')[1],"(","")) as long, 
toFloat(replace(split(map.WKT, ' ')[2],")","")) as lat
merge (:ObjetGeo:Toponyme:POI:v2018:sourceRefugeInfo {
	id: "riPOI"+toString( map.id),
	name:map.nom,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	type:toLower(map.type),
	location:coalesce(point({latitude:lat,longitude:long}),"unknown")
})-[:hasGeometry]->(node)
	on create set node:geom:Tech, node.dateImport=localdatetime({ timezone: 'Europe/Paris' });

// Added 2128 labels, created 304 nodes, set 2432 properties, created 304 relationships, completed after 537 ms.
