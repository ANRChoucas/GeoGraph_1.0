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
:param importFile => "2_07_C2C_ROUTE_2021.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with distinct map.id as id, map, node													   
create (iti:ObjetGeo:ObjetRepère:ITI:sourceC2c:v2021 {
	name: map.name,
	id:"ITI."+map.id,
	importFile:$importFile,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	mainWaypointId:map.main_waypoint_id,
	activities: map.activities,
	routeTypes:map.route_types
})
WITH iti,map.waypoints as waypoints
UNWIND apoc.convert.fromJsonList(waypoints) as r
match (poi:sourceC2c:POI:v2021 {id:"POI."+toString(r)})
	create (iti) <-[:c2cAssociation {importFile:$importFile,creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"import"}]-(poi);
// Added 3185 labels, created 637 nodes, set 10640 properties, created 1848 relationships, completed after 17229 ms.
	

// import des géométries en 4326 et suppression des objets hors zone d'étude 
// (sans geom car pas dans fichier import geom)
:param importFile => "2_07_C2C_ROUTE_2021.csv";
call apoc.load.csv($importFile) YIELD map
call spatial.addWKT("lines",map.WKT) yield node 
with node, map
match (o:sourceC2c:ITI:v2021 {id:"ITI."+toString(map.id)})
merge (o)-[:hasGeometry]->(node)
	on create set node:geom:Tech, 
				node.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),
				node.creationType="import";
// Added 1274 labels, set 1274 properties, created 637 relationships, completed after 13690 ms.
	

match (n:sourceC2c:v2021) where not exists((n)--(:geom)) delete n;

													   
													   