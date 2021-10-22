// --------------------------------------------------------------------------------------------------------------
// 1. waypoints

// import waypoints - un prefixe est ajouté aux id, 
//        pour éviter doublon "par hasard" avec autre id purement numérique
:param importFile => "2_06_C2C_WAYPOINT_2021.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("points",map.WKT) yield node 
with distinct map.id as id, map, node
create (:Toponyme:ObjetGeo:POI:sourceC2c:v2021 {
	name: map.name,
	id:"POI."+map.id,
	importFile:$importFile,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	type:replace(map.type,"_"," ")
});
// Added 9130 labels, created 1826 nodes, set 10956 properties, completed after 24250 ms.

// import des géométries en 4326
:param importFile => "2_06_C2C_WAYPOINT_2021.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("points",map.WKT) yield node 
with node, map
match (o:sourceC2c:POI:v2021 {id:"POI."+toString(map.id)})
merge (o)-[:hasGeometry]->(node)
	on create set node:geom:Tech, 
				node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),
                node.creationType="import";
// Added 3652 labels, set 3652 properties, created 1826 relationships, completed after 23971 ms.


// --------------------------------------------------------------------------------------------------------------
// 2. routes

// import des routes avec liens vers waypoints - les waypoints doivent exister dans la BD
:param importFile => "c2c.v2021.routesDetails.json";
call apoc.load.json($importFile) YIELD value
UNWIND value.documents as item
create (iti:ObjetGeo:ObjetRepère:ITI:sourceC2c:v2021 {
	name: coalesce([loc in item.locales where loc.lang="fr" |loc.title][0],item.locales[0].title) ,
	id:"ITI."+item.document_id,
	importFile:$importFile,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	altitudeMax:item.elevation_max,
	altitudeMin:item.elevation_min,
	type:item.waypoint_type,
	quality:item.quality,
	heightDiffUp:item.height_diff_up,
	mainWaypointId:item.main_waypoint_id,
	recentOutingsNb:item.recent_outings.total,
	activities: item.activities,
	routeTypes:item.route_types
})
WITH iti,item.associations.waypoints as waypoints
UNWIND waypoints as wp
match (poi:sourceC2c:POI:v2021 {id:"POI."+toString(wp.document_id)})
	create (iti)<-[:c2cAssociation {importFile:$importFile,creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"import"}]-(poi);
// GG.2.0 Added 8965 labels, created 1793 nodes, set 32358 properties, created 3806 relationships, completed after 3519 ms.

// export en geojson pour conversion des géométries en 4326
// CALL apoc.export.csv.query('call apoc.load.json("c2c.v2021.routesDetails.json") YIELD value 
// UNWIND value.documents as item
// return {type: "Feature",
//		properties: {id:item.document_id,name:coalesce([loc in item.locales where loc.lang="fr" |loc.title][0],item.locales[0].title)},
//		geometry: {type: item.geometry.geom_detail.type, coordinates: item.geometry.geom_detail.coordinates }
//}
// ','c2c.routesDetails.2geojson.csv', {delim: ',',quotes:false, format: 'plain'});
 
// import des géométries en 4326 et suppression des objets hors zone d'étude (sans geom car pas dans fichier import geom)
:param importFile => "c2c.v2021.routesDetails.ZoneEtude.WKT.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with node, map
match (o:sourceC2c:ITI:v2021 {id:"ITI."+toString(map.id)})
merge (o)-[:hasGeometry]->(node)
	on create set node:geom:Tech, node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),node.creationType="import";

// GG.2.0 Added 2614 labels, set 2614 properties, created 1307 relationships, completed after 40055 ms.

// suppression des noeuds hors ZoneEtude i.e. sans geom
// match (n:sourceC2c:v2021) where not exists((n)--(:geom)) return count(n);
// match (n:sourceC2c:v2021:ITI) where not exists((n)--(:geom)) and exists ((n)--()) return count(n) -> 2

match (n:sourceC2c:v2021) where not exists((n)--(:geom)) delete n;
// old 2.0 Deleted 2992 nodes (POI+ITI), completed after 60 ms.
// GG.2.0 ITI Deleted 486 nodes, deleted 2 relationships, completed after 19 ms.