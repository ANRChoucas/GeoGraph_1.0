// 2. POI Ecrins
:param importFile => "2_2_PN_ECRINS_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("points",map.WKT) yield node 
with map,node, toFLoat(replace(split(map.WKT, ' ')[1],"(","")) as long, 
toFloat(replace(split(map.WKT, ' ')[2],")","")) as lat
merge (:ObjetGeo:Toponyme:POI:v2018:sourceRandoEcrins {
	id: "EPOI"+toString( map.id),
	name:map.nom,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	type:toLower(map.type), 
	location:coalesce(point({latitude:lat,longitude:long}),"unknown")
})-[:hasGeometry]->(node)
	on create set node:geom:Tech, node.dateImport=localdatetime({ timezone: 'Europe/Paris' });

// Added 1722 labels, created 246 nodes, set 1968 properties, created 246 relationships, completed after 626 ms.

