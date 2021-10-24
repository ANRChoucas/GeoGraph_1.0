// ================================================================================================
// import ClassOOR et altLabels
:param importFile => "210719.GGexportOOR.json";
call apoc.load.json($importFile) YIELD value as item 
with item
where item.`@type`[0] = "http://www.w3.org/2002/07/owl#Class"
create (classOOR:ClassOOR:`Catégorisation` {
	id:item.`@id`,
	creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
	creationType:"import",
	prefLabelFr : [prefLabel in item.`http://www.w3.org/2000/01/rdf-schema#prefLabel` where prefLabel.`@language` = 'fr' | prefLabel.`@value`][0],
	prefLabelEn : [prefLabel in item.`http://www.w3.org/2000/01/rdf-schema#prefLabel` where prefLabel.`@language` = 'en' | prefLabel.`@value`][0],
	commentFr : [comment in item.`http://www.w3.org/2000/01/rdf-schema#comment` where comment.`@language` = 'fr' | comment.`@value`],
	commentEn : [comment in item.`http://www.w3.org/2000/01/rdf-schema#comment` where comment.`@language` = 'en' | comment.`@value`], 
	importFile:$importFile
})
WITH item.`http://www.w3.org/2000/01/rdf-schema#altLabel` as altLabels,classOOR
UNWIND altLabels  as altLabel  
	MERGE (n:AltLabel:`Catégorisation` {name:altLabel.`@value`})
			ON CREATE SET n.lang=coalesce(altLabel.`@language`, ''),n.creationDateTime=localdatetime({ timezone: 'Europe/Paris' }),n.creationType="import",n.importFile=$importFile 
	MERGE (n)-[:isAltLabelOf {importFile:$importFile,creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"import"}]->(classOOR);
// Added 2326 labels, created 1163 nodes, set 8833 properties, created 698 relationships, completed after 713 ms.


// ajout des liens subclass
call apoc.load.json($importFile) YIELD value as item 
with item
where item.`@type`[0] = "http://www.w3.org/2002/07/owl#Class" and exists(item.`http://www.w3.org/2000/01/rdf-schema#subClassOf`)
UNWIND item.`http://www.w3.org/2000/01/rdf-schema#subClassOf` as subClassOf
	WITH subClassOf.`@id` as subClassOfId,item.`@id` as itemId 
	MATCH (classOOR:ClassOOR {id:itemId}),(superClassOOR:ClassOOR {id:subClassOfId})
	CREATE (classOOR)-[:isSubClassOf  {
		importFile:$importFile,
		creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
		creationType:"import"}]->(superClassOOR) ;
// Set 1500 properties, created 500 relationships, completed after 1065 ms.


// altLabel par langue
MATCH (n:AltLabel) where n.lang="fr" set n:AltLabelFr remove n.lang, n:AltLabel; 
// Added 333 labels, removed 333 labels, set 333 properties, completed after 26 ms.
MATCH (n:AltLabel) where n.lang="en" set n:AltLabelEn remove n.lang, n:AltLabel;
// Added 349 labels, removed 349 labels, set 349 properties, completed after 13 ms.

																	  
// suppress empty comment
match (c:ClassOOR) where c.commentFr = [] set c.commentFr = null;
// 
match (c:ClassOOR) where c.commentEn = [] set c.commentEn = null;
// Set 240 properties, completed after 10 ms.


// ================================================================================================
// *** corrections de OOR

:param idUrl => "urn:absolute:ANR_Choucas/OntologieObjetsRéférence";

// fusion des id château_d_eau et château_d'eau
match (c:ClassOOR {prefLabelFr:"château d'eau"}) where not exists(c.commentFr) detach delete c; 
//  
match (c1:ClassOOR {id:$idUrl+"#château_d'eau"}),(c2:ClassOOR {prefLabelFr:"infrastructure de gestion d'eau douce"})
	create (c1)-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherModify"}]->(c2);
// Set 2 properties, created 1 relationship, completed after 6 ms.

// prefLabelFr manquante -> calcul <- id
match (c:ClassOOR) where not exists(c.prefLabelFr ) set c.prefLabelFr = replace(replace(c.id,$idUrl+'#',''),'_',' '),c.creationType="cypherModify";
// no changes, no records)

// agglomération prefLabelFr = ville
match (c:ClassOOR {id:$idUrl+"#agglomération"}) set c.prefLabelFr="agglomération",c.creationType="cypherModify"; 
// Set 2 properties, completed after 1 ms.
match (a:AltLabelFr {name:"agglomération"}) detach delete a; 
// (no changes, no records)

// erreur de langue sur prefLabel
match (c:ClassOOR {prefLabelFr:"bridleway"}) set c.prefLabelFr="chemin" , c.prefLabelEn="bridleway",c.creationType="cypherModify"; 
// (no changes, no records)
match (c:ClassOOR {prefLabelEn:"bassin fermé"}) set c:prefLabelFr , c.creationType="cypherModify" remove c:prefLabelEn;
// (no changes, no records)
 
// mise en cohérence prefLabelFr / id
match (c:ClassOOR {prefLabelFr:"gare"}) set c.prefLabelFr="gare ferrovière",c.creationType="cypherModify"; 
// (no changes, no records)
match (c:ClassOOR) where replace(replace(c.id,$idUrl+'#',''),"_"," ") <> c.prefLabelFr 
	set c.id =$idUrl+"#"+replace(c.prefLabelFr,' ','_'),c.creationType="cypherModify";
// Set 10 properties, completed after 21 ms.

// err de lang sur altLabel
match (a:AltLabelFr {name:"winter sport resort"}) set a:AltLabelEn,a.creationType="cypherModify" remove a:AltLabelFr; 
// no changes, no records)
with ["colonie de vacances", "ravine","maquis","torrent","intersection"] as labs
unwind labs as altLabelFr
	match (a:AltLabelEn {name:altLabelFr}) set a:AltLabelFr,a.creationType="cypherModify" remove a:AltLabelEn;
// (no changes, no records)
 
// err de lang sur comment
with ["surplomb","terril","toit","volcan","col","colline","cratère" ] as prefLabels
unwind prefLabels as prefLabel
	match (c:ClassOOR {prefLabelFr:prefLabel}) set c.commentFr=c.commentEn,c.creationType="cypherModify" remove c.commentEn;
// Set 14 properties, completed after 12 ms.

// erreur de nom d'attribut : altLabelFr -> comment
with ["Vallée étroite et encaissée", "Remblai de terre ou de pierre", 
"Entaille pratiquée dans le sol", "Une partie creuse dans une paroie, neige, etc. qui peut servir de voie d'accès",
"Construction  à l'utilisation des piétons, constituée d'une suite régulière de\nmarches reliant deux lieux d'altitudes différentes.",
"Batiment ayant le rôle d'abriter les humains" ] as definitions 
unwind definitions as definition
	match (a)--(c:ClassOOR) where (a:AltLabelEn or a:AltLabelFr ) and a.name = definition detach delete a
	set c.commentFr= definition,c.creationType="cypherModify";
// (no changes, no records)

// err orthographe -> changer prefLabelFr et id
match (c:ClassOOR {prefLabelFr:"puit"}) set c.prefLabelFr="puits",c.id=$idUrl+"#puits",c.creationType="cypherModify"; 
// (no changes, no records)
match (c:AltLabelFr {name:"temple boudhiste"}) set c.name="temple bouddhiste",c.id=$idUrl+"#temple_bouddhiste",c.creationType="cypherModify"; 
// (no changes, no records)
match (a:AltLabelFr {name:"banlieu"}) set a.name="banlieue",a.creationType="cypherModify"; 
// (no changes, no records)

// suppr altLabel 
match (a:AltLabelFr {name:"établissement d'enseignement"}) detach delete a; 
// (no changes, no records)
match (a:AltLabelFr {name:"pipeline"}) detach delete a; 
// (no changes, no records)
match (a:AltLabelFr {name:"station"})--(:ClassOOR {prefLabelFr:"agglomération"}) detach delete a; 
// (no changes, no records)
match (a:AltLabelFr {name:"préfecture"})--(:ClassOOR {prefLabelFr:"mairie"}) detach delete a; 
// (no changes, no records)
match (a:AltLabelEn {name:"barracks"}) detach delete a; 
// (no changes, no records)

					  
// supprime relation de Class vers elle-même ("établissement d'enseignement" et "objet de repère")
match (n)-[r:isSubClassOf]-(n) delete r; 
// (no changes, no records)

// ville, vilage
match (c:ClassOOR {id:$idUrl+"#vilage"}) set c.id=$idUrl+"#village", c.prefLabelEn="village", c.prefLabelFr="village",c.creationType="cypherModify"; 
// (no changes, no records)

// ajout altlabel manquant
match (:ClassOOR)--(a {name:"salto"}) set a:AltLabelFr:Catégorisation,a.creationType="cypherModify" remove n:AltLabel; 
match (:ClassOOR)--(a {name:"établissement thermal"}) set a:AltLabelFr:Catégorisation,a.creationType="cypherModify" remove n:AltLabel; 
match (:ClassOOR)--(a {name:"parc"}) set a:AltLabelFr:Catégorisation,a.creationType="cypherModify" remove n:AltLabel; 


// *** ajout racine
create (racine:ClassOOR:Catégorisation {id:"racine",prefLabelEn:"landmark object", prefLabelFr:"objet de repère",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})
with racine
match (c:ClassOOR) where not exists((c)-->(:ClassOOR)) 
	create (c)-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(racine);
// Added 2 labels, created 1 node, set 17 properties, created 6 relationships, completed after 26 ms.

// *** ajout de VariantSpelling pour pluriels
match (c:ClassOOR:`Catégorisation` {prefLabelFr:"rocher"}) create (a:VariantSpellingFr {name:"rochers",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
match (c:ClassOOR:`Catégorisation` {prefLabelFr:"source"}) create (a:VariantSpellingFr {name:"sources",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
match (c:ClassOOR:`Catégorisation` {prefLabelFr:"ruine"}) create (a:VariantSpellingFr {name:"ruines",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
match (c:ClassOOR:`Catégorisation` {prefLabelFr:"glacier"}) create (a:VariantSpellingFr {name:"glacier, névé",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
match (c:ClassOOR:`Catégorisation` {prefLabelFr:"télécabine"}) create (a:VariantSpellingFr {name:"télécabine, téléphérique",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
//#match (c:ClassOOR:`Catégorisation` {prefLabelFr:"site d'escalade"}) create (a:VariantSpellingFr {name:"site d escalade",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})-[:isVariantSpellingOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
// Added 1 label, created 1 node, set 5 properties, created 1 relationship, completed after 3 ms.

// *** batiment religieux
MATCH (a:AltLabelFr {name: "chapelle"}) detach delete a; 
MATCH (a:AltLabelEn {name: "chapel"}) detach delete a; 
match (batRel:ClassOOR {prefLabelFr:"bâtiment religieux"})
with batRel,["mosquée","église","synagogue","cathédrale","temple bouddhiste","temple hindouiste"] as ListPrefLabelFr,
["mosque","church","synaguoge","cathedral","buddhist temple","hindu temple"] as ListPrefLabelEn
UNWIND range(0, size(ListPrefLabelFr)-1) AS i
	match (a:AltLabelFr {name:ListPrefLabelFr[i]}) detach delete a
	merge (batRel)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-
	(:ClassOOR:Catégorisation {id:$idUrl+"#"+ListPrefLabelFr[i],prefLabelFr:ListPrefLabelFr[i],prefLabelEn:ListPrefLabelEn[i],creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});


match (eglise:ClassOOR {prefLabelFr:"église"})
with eglise,["collégiale","abbatiale","basilique","clocher","steeple","basilica","protestant church","temple","temple protestant"] as liste
unwind liste as item
	match (a)-[r]-(:ClassOOR) where (a:AltLabelEn or a:AltLabelFr) and a.name= item
	delete r
	merge (eglise)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);


with ["buddhist temple", "cathedral", "church", "hindu temple", "synaguoge"] as liste
unwind liste as item
	match (a:AltLabelEn {name:item}) detach delete a;


MATCH (a:AltLabelEn {name: "minaret"})-[r]-(:ClassOOR),(c:ClassOOR {prefLabelFr:"mosquée"})
	delete r
	merge (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);

MATCH (a:AltLabelEn {name: "minaret"}) set a:AltLabelFr,a.creationType="cypherModify" remove a:AltLabelEn;


// hydro
MATCH (c:ClassOOR {prefLabelFr: "source"})
	merge (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-
	(:ClassOOR:Catégorisation {id:$idUrl+"#source_captée",prefLabelFr:"source captée",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});

MATCH (c:ClassOOR {prefLabelFr: "point d'eau"}) detach delete c; 
MATCH (c:ClassOOR {prefLabelFr: "réseau hydrographique naturel"})
	merge (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:"point d'eau",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})
	merge (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelEn:Catégorisation {name:"water point",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});


with ["écoulement naturel","retenue","plan d'eau de gravière","réservoir-bassin","retenue-barrage"] as ListAltLab,
["ruisseau","retenue d'eau","nappe d'eau","réservoir","barrage"] as ListClass
UNWIND range(0, size(ListClass)-1) AS i
match (c:ClassOOR {prefLabelFr:ListClass[i]})
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:ListAltLab[i],creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});


match (a:AltLabelFr {name:"conduite forcée"}) detach delete a; 



MATCH (a:AltLabelFr {name: "forêt"}) detach delete a; 
MATCH (c:ClassOOR {prefLabelFr: "massif boisé"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#forêt",prefLabelFr:"forêt",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});

MATCH (a:AltLabelFr {name: "autoroute"}) detach delete a; 
MATCH (c:ClassOOR {prefLabelFr: "infrastructure de transport routier"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#autoroute",prefLabelFr:"autoroute",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});

MATCH (a:AltLabelFr {name: "rue"}) detach delete a; 
MATCH (c:ClassOOR {prefLabelFr: "infrastructure de transport routier"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#rue",prefLabelFr:"rue",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});


MATCH (a:AltLabelFr {name: "lieu-dit"})-[r:isAltLabelOf]-(), (c:ClassOOR {prefLabelFr: "zonage"}) 
	set a:ClassOOR, a.prefLabelFr=a.name,a.id=$idUrl+"#lieu-dit" remove a:AltLabelFr,a.name,a.usedToInstanciate delete r
	create (a)-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c);
MATCH (c:ClassOOR {prefLabelFr: "lieu-dit"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#lieu-dit_habité",prefLabelFr:"lieu-dit habité",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#lieu-dit_non_habité",prefLabelFr:"lieu-dit non habité",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});


match (a:AltLabelFr {name:"ruelle"})-[r:isAltLabelOf]->(),(c:ClassOOR {prefLabelFr:"rue"})
	delete r
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	
match (a:AltLabelFr {name:"allée"}),(c:ClassOOR {prefLabelFr:"rue"})
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	
match (a:AltLabelFr {name:"bretelle"})-[r:isAltLabelOf]->(),(c:ClassOOR {prefLabelFr:"autoroute"})
	delete r
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	
match (a:AltLabelFr {name:"voie rapide"})-[r:isAltLabelOf]->(),(c:ClassOOR {prefLabelFr:"autoroute"})
	delete r
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	
match (a:AltLabelFr {name:"sente"})-[r:isAltLabelOf]->(),(c:ClassOOR {prefLabelFr:"sentier"})
	delete r
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	
match (a:AltLabelFr {name:"sentier équestre"})-[r:isAltLabelOf]->(),(c:ClassOOR {prefLabelFr:"sentier"})
	delete r
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(a);
	

MATCH (c:ClassOOR {prefLabelFr: "route"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#tronçon_de_route",prefLabelFr:"tronçon de route",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});
MATCH (c:ClassOOR {prefLabelFr: "forêt"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#forêt_de_feuillus",prefLabelFr:"forêt de feuillus",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});
MATCH (c:ClassOOR {prefLabelFr: "forêt"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#forêt_de_conifères",prefLabelFr:"forêt de conifères",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});
MATCH (c:ClassOOR {prefLabelFr: "gare ferrovière"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#gare_funiculaire",prefLabelFr:"gare funiculaire",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});
MATCH (c:ClassOOR {prefLabelFr: "végétation basse"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#lande_ligneuse",prefLabelFr:"lande ligneuse",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});
MATCH (c:ClassOOR {prefLabelFr: "antenne"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#antenne_GSM",prefLabelFr:"antenne GSM",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});

MATCH (c:ClassOOR {prefLabelFr: "pylône"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#pylône_électrique",prefLabelFr:"pylône électrique",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:ClassOOR:Catégorisation {id:$idUrl+"#pylône_de_remontée mécanique",prefLabelFr:"pylône de remontée mécanique",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"});

MATCH (subClass:ClassOOR {prefLabelFr: "pylône électrique"}), (c:ClassOOR {prefLabelFr: "infrastructure électricité"})
	create (c)<-[:isSubClassOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(subClass);


	

MATCH (c:ClassOOR {prefLabelFr: "zone bâtie"})
	set c.prefLabelFr="zone d'habitation", c.creationType="cypherModify" ,c.creationDateTime = localdatetime({ timezone: 'Europe/Paris' }),c.id=$idUrl+"#zone_d'habitation", c.commentFr="Délimitation de fait d'une zone contenant un ou plusieurs batiments d'habitation";

MATCH (c:ClassOOR {prefLabelFr: "funiculaire"})
	set c.prefLabelFr="voie funiculaire", c.creationType="cypherModify" ,c.creationDateTime = localdatetime({ timezone: 'Europe/Paris' }),c.id=$idUrl+"#voie_funiculaire";

MATCH (c:ClassOOR {prefLabelFr: "station"})--(a:AltLabelFr {name:"station de sports d'hiver"})
	set c.prefLabelFr="station de sports d'hiver",c.creationType="cypherModify" ,c.creationDateTime = localdatetime({ timezone: 'Europe/Paris' }),c.id=$idUrl+"#station_de_sports_d'hiver", a.name="station";



match (c:ClassOOR {prefLabelFr:"forêt de feuillus"})
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:"forêt fermée de feuillus"});

match (c:ClassOOR {prefLabelFr:"forêt de conifères"}) 
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:"forêt fermée de conifères"});

match (c:ClassOOR {prefLabelFr:"forêt"}) 
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:"forêt ouverte"})
	create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelFr:Catégorisation {name:"forêt fermée mixte"});

match (c:ClassOOR {prefLabelFr:"site d'escalade"}) create (c)<-[:isAltLabelOf {creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]-(:AltLabelEn:Catégorisation {name:"climbing outdoor"});




