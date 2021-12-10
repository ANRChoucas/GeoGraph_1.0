// 1. POI Vercors
:param importFile => "2_01_PNR_VERCORS_2018.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("points",map.WKT) yield node 
with map,node, toFLoat(replace(split(map.WKT, ' ')[1],"(","")) as long, 
toFloat(replace(split(map.WKT, ' ')[2],")","")) as lat
merge (:ObjetGeo:Toponyme:POI:v2018:sourceRandoVercors {
	id: "VPOI"+toString( map.id),
	name:map.nom,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	importFile:$importFile,
	type:toLower(map.type),
	location:coalesce(point({latitude:lat,longitude:long}),"unknown")
})-[:hasGeometry]->(node)
	on create set node:geom:Tech, node.dateImport=localdatetime({ timezone: 'Europe/Paris' });

// Added 812 labels, created 116 nodes, set 928 properties, created 116 relationships, completed after 379 ms.
