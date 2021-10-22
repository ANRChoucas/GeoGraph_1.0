// --------------------------------------------------------------------------------------------------------------
// 29. création des :Toponymes
MATCH (n:Nymie) with distinct n.id as id 
CREATE (t:ObjetGeo:Toponyme:sourceBDTOPO:v2021 {
	name:"",
	id:"TN."+id,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
    creationType="cypherCreate:matchId"
});
// Added 76744 labels, created 19186 nodes, set 76744 properties, completed after 805 ms.

// --------------------------------------------------------------------------------------------------------------
CALL apoc.periodic.iterate(
	"match (t:Toponyme) match (n:Nymie {id:replace(t.id,'TN.','')})--(g:geom) return t,n,g",
	"create (n)-[:isNymieOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:'cypherCreate:matchId'}]->(t)
	 create (t)-[:hasGeometry {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:'cypherCreate:matchId'}]->(g)",
	 {batchSize: 10000}
);
// total: 19939, "relationshipsCreated": 39878, "propertiesSet": 79756, 

// --------------------------------------------------------------------------------------------------------------
// transfer des labels
:param couchesNymies =>["Bati", "Hydro", "LieuxNommés", "ServicesActivités", "Transport"];
MATCH (t:Toponyme)--(n:Nymie) with t,[lab in labels(n) where lab in $couchesNymies|lab] as labels
CALL apoc.create.addLabels( t, labels )
YIELD node
RETURN count(node);
// ok

// --------------------------------------------------------------------------------------------------------------
// transfert type t.type=collect(n.type)[0] 
match (t:Toponyme)--(n:Nymie) with t,collect(n.type)[0] as type set t.type=type;
// Set 19186 properties, completed after 254 ms.

// --------------------------------------------------------------------------------------------------------------
// transfert nymie.name -> toponyme.name (arbitrairement 1e de la liste pour avoir une valeur par défaut, 
// inutile sur ce jeu de données car tous les ObjetRepère correspondant ont une valeur pour name - cf overwrite ci-dessous
match (t:Toponyme:sourceBDTOPO)--(n:Nymie) with t,collect(n.name)[0] as name set t.name=name;
// Set 19186 properties, completed after 410 ms.

// --------------------------------------------------------------------------------------------------------------
// création liens :Toponyme - ObjetRepère NB: il faut précisier le label ObjetGeo pour que l'index sur les id soit utilisé
CALL apoc.periodic.iterate(
	"match (t:Toponyme) match (o:ObjetRepère:ObjetGeo {id:replace(t.id,'TN.','')}) return t,o",
	"create (t)-[:isToponymeOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:'cypherCreate'}]->(o)",
	 {batchSize: 10000}
);
// total	15606

// --------------------------------------------------------------------------------------------------------------
// overwrite t.name avec o.name si Toponyme est relié à ObjetRepère
match (t:Toponyme)-[:isToponymeOf]-(o:ObjetRepère) where o.name <> "" and o.name <>"NR" set t.name=o.name;
// Set 15606 properties, completed after 184 ms.
	
// --------------------------------------------------------------------------------------------------------------
// suppression des :geom multiples pour les :Toponymes avec plusieurs :Nymies
match (t:Toponyme)--(g:geom)
with t, collect(g) as geoms,count(g) as count, size(collect(g)) as max where count>1
with t,geoms[1..max] as geomToSuppress
call spatial.removeNodes("points",geomToSuppress) yield count
unwind geomToSuppress as geomNode
detach delete geomNode;
// Deleted 753 nodes, deleted 1506 relationships, completed after 8132 ms.

// suppress :hasGeometry de :Nymie
match (:Nymie)-[r:hasGeometry]-(:geom) delete r
// Deleted 19186 relationships, completed after 137 ms.
