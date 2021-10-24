
// ------------------------------------------------------------------------------------------------
// massifs
match (o:Massif),(classOOR:ClassOOR {prefLabelFr:"massif"}) 
	create (o)-[:isInstanceOf {rule:"label",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);
// communes
match (o:Commune),(classOOR:ClassOOR {prefLabelFr:"commune"}) 
	create (o)-[:isInstanceOf {rule:"label",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);

// ------------------------------------------------------------------------------------------------
// ligne électrique
// instanciation dans OOR (si voltage inconnu -> haute tension 
match (e:LigneElectrique:v2021:sourceBDTOPO) where toInteger(replace(split(e.voltage," ")[0],"<",""))<100 or  e.voltage ="Inconnue"
with e
match (classOOR:ClassOOR {prefLabelFr:"ligne électrique de haute tension"})
merge (e)-[:isInstanceOf {rule:"label",creaDateTime:localdatetime({ timezone: 'Europe/Paris' })}]->(classOOR);

match (e:LigneElectrique:v2021:sourceBDTOPO) where toInteger(replace(split(e.voltage," ")[0],"<",""))>=100
with e
match (classOOR:ClassOOR {prefLabelFr:"ligne électrique de très haute tension"})
merge (e)-[:isInstanceOf {rule:"label",creaDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);

match (o:LigneElectrique) where not exists((o)-[:isInstanceOf]-(:ClassOOR))
with o match (classOOR:ClassOOR {prefLabelFr:"ligne électrique"}) 
	create (o)-[:isInstanceOf {rule:"label",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);

// ------------------------------------------------------------------------------------------------
// pylones
match (o:Pylone),(classOOR:ClassOOR {prefLabelFr:"pylône électrique"}) 
	create (o)-[:isInstanceOf {rule:"label",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);


// ------------------------------------------------------------------------------------------------
// voies nommées type_voie restreint
match (o:VoieNommée) where o.type in ["route","chemin","pont","parking","rue","sentier"] 
match (classOOR:ClassOOR {prefLabelFr:o.type})
	create (o)-[:isInstanceOf {rule:"label-type_voie",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);

// ------------------------------------------------------------------------------------------------
// cours d'eau (sans type par construction de l'import)
match (o:CoursEau),(classOOR:ClassOOR {prefLabelFr:"cours d'eau"}) 
where not exists((o)-[:isInstanceOf]-(:ClassOOR))
	create (o)-[:isInstanceOf {rule:"label",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);


// ------------------------------------------------------------------------------------------------
// *** par o.type = classOOR.prefLabelFr 
match (o:ObjetGeo) where 
not exists((o)-[:isInstanceOf]-(:ClassOOR)) and not o:VoieNommée
match (classOOR:ClassOOR) where apoc.text.compareCleaned(o.type,classOOR.prefLabelFr )
	create (o)-[:isInstanceOf {rule:"oType-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);


// ------------------------------------------------------------------------------------------------
// *** par o.type = altLabelFr de classOOR
match (o:ObjetGeo) where
not exists((o)-[:isInstanceOf]-(:ClassOOR)) and not o:VoieNommée
match (altLab:AltLabelFr)-[rel:isAltLabelOf]-(classOOR:ClassOOR) 
where  apoc.text.compareCleaned(o.type, altLab.name ) 
	create (o)-[:isInstanceOf {rule:"oType-ClassOORaltLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR) 
	create (o)-[:instanceMatchesAltLabel {rule:"oType-ClassOORaltLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(altLab);


// ------------------------------------------------------------------------------------------------
// *** o.type = variante orthographique
match (o:ObjetGeo) where
not exists((o)-[:isInstanceOf]-(:ClassOOR))  and not o:VoieNommée
match (var:VariantSpellingFr)-[rel:isVariantSpellingOf]-(classOOR:ClassOOR) 
where  apoc.text.compareCleaned(o.type, var.name ) 
	create (o)-[:isInstanceOf {rule:"oType-ClassOORVariantSpellingFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR) 
	create (o)-[:instanceMatchesVariantSpellingFr {rule:"oType-ClassOORVariantSpellingFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(var);


// ------------------------------------------------------------------------------------------------
// *** HYDRO premier et deuxième de mot de name 

// dans les 4 règles, "sources" est ajouté en dur pour éviter de faire règle supplémentaire sur VariantSpelling juste pour cette variante

// *** réinstanciation ["réseau hydrographique naturel","cours d'eau"] - point eau altLabel
match (cHydro:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"hydrographie"})
with "sources"+collect(distinct cHydro.prefLabelFr) as hydrographie
match (cInfra:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"infrastructure eau"})
with hydrographie,collect(distinct cInfra.prefLabelFr) as infraEau
match (o:ObjetGeo)-[rOld:isInstanceOf]->(cOld:ClassOOR) where cOld.prefLabelFr in ["réseau hydrographique naturel","cours d'eau"]
with rOld,o, toLower(split(o.name," ")[0]) as premierMot where premierMot in hydrographie or premierMot in infraEau
match (c:ClassOOR) where  apoc.text.compareCleaned(c.prefLabelFr, premierMot ) 
	create (o)-[:isInstanceOf {rule:"nameFirstWord-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c) 
	delete rOld;


match (cHydro:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"hydrographie"})
with "sources"+collect(distinct cHydro.prefLabelFr) as hydrographie
match (cInfra:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"infrastructure eau"})
with hydrographie,collect(distinct cInfra.prefLabelFr) as infraEau
match (o:ObjetGeo)-[rOld:isInstanceOf]->(cOld:ClassOOR) where cOld.prefLabelFr in ["réseau hydrographique naturel","cours d'eau"]
with rOld,o, toLower(split(o.name," ")[1]) as deuxiemeMot where deuxiemeMot in hydrographie or deuxiemeMot in infraEau
match (c:ClassOOR) where  apoc.text.compareCleaned(c.prefLabelFr, deuxiemeMot ) 
	create (o)-[:isInstanceOf {rule:"nameSecondWord-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c) 
	delete rOld;


// ajout d'instanciations pour o:DetailHydro or o:CoursEau or o:SurfaceHydro or o:PlanEau or o:Hydro
// 1e mot
match (cHydro:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"hydrographie"})
with "sources"+collect(distinct cHydro.prefLabelFr) as hydrographie
match (cInfra:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"infrastructure eau"})
with hydrographie,collect(distinct cInfra.prefLabelFr) as infraEau
match (o:ObjetGeo) where (o:DetailHydro or o:CoursEau or o:SurfaceHydro or o:PlanEau or o:Hydro)
and not exists((o)-[:isInstanceOf]-(:ClassOOR))
with o, toLower(split(o.name," ")[0]) as premierMot where premierMot in hydrographie or premierMot in infraEau
match (c:ClassOOR) where  apoc.text.compareCleaned(c.prefLabelFr, premierMot ) 
	create (o)-[:isInstanceOf {rule:"nameFirstWord-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c) ;


// suppression de rel :instanceMatchesAltLabel devenues non pertinentes suite à réinstanciation hydro
match (c:ClassOOR)-[:isInstanceOf]-(:ObjetGeo)-[r:instanceMatchesAltLabel]->(a) where not exists ((a)-[:isAltLabelOf]-(c)) delete r


// 2e mot
match (cHydro:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"hydrographie"})
with collect(distinct cHydro.prefLabelFr) as hydrographie
match (cInfra:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"infrastructure eau"})
with hydrographie,collect(distinct cInfra.prefLabelFr) as infraEau
match (o:ObjetGeo) where (o:DetailHydro or o:CoursEau or o:SurfaceHydro or o:PlanEau or o:Hydro)
and not exists((o)-[:isInstanceOf]-(:ClassOOR))
with o, toLower(split(o.name," ")[1]) as deuxiemeMot where deuxiemeMot in hydrographie or deuxiemeMot in infraEau
match (c:ClassOOR) where  apoc.text.compareCleaned(c.prefLabelFr, deuxiemeMot ) 
	create (o)-[:isInstanceOf {rule:"nameSecondWord-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c) ;


// *** bâtiment religieux / Culte chrétien
// prefLabelFr - 1e mot
match (c:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"bâtiment religieux"})
with collect(distinct c.prefLabelFr) as sousDomaine
match (o:ObjetGeo {type:"Culte chrétien"}) where not exists((o)-[:isInstanceOf]-(:ClassOOR)) 
with o, toLower(split(o.name," ")[0]) as premierMot where premierMot in sousDomaine
match (c:ClassOOR) where  apoc.text.compareCleaned(c.prefLabelFr, premierMot ) 
	create (o)-[:isInstanceOf {rule:"nameFirstWord-ClassOORprefLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c) ;


// altLabelFr - 1e mot
match (a:AltLabelFr)--(:ClassOOR)-[:isSubClassOf*]->(:ClassOOR {prefLabelFr:"bâtiment religieux"})
with collect(distinct a.name) as sousDomaine
match (o:ObjetGeo {type:"Culte chrétien"}) where not exists((o)-[:isInstanceOf]-(:ClassOOR)) 
with o, toLower(split(o.name," ")[0]) as premierMot where premierMot in sousDomaine
match (c:ClassOOR)--(a:AltLabelFr) where apoc.text.compareCleaned(a.name, premierMot ) 
	create (o)-[:isInstanceOf {rule:"nameFirstWord-ClassOORaltLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(c)
	create (o)-[:instanceMatchesAltLabel {rule:"nameFirstWord-ClassOORaltLabelFr",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(a);


// *** en anglais

// par o.type = classOOR.prefLabelEn 
match (o:ObjetGeo) where
not exists((o)-[:isInstanceOf]-(:ClassOOR)) and not o:VoieNommée
match (classOOR:ClassOOR) where apoc.text.compareCleaned(o.type,classOOR.prefLabelEn )
	create (o)-[:isInstanceOf {rule:"oType-ClassOORprefLabelEn",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR);


// par o.type = altLabelEn de classOOR
match (o:ObjetGeo) where
not exists((o)-[:isInstanceOf]-(:ClassOOR))  and not o:VoieNommée
match (altLab:AltLabelEn)-[rel:isAltLabelOf]-(classOOR:ClassOOR) 
where  apoc.text.compareCleaned(o.type, altLab.name ) 
	create (o)-[:isInstanceOf {rule:"oType-ClassOORaltLabelEn",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(classOOR) 
	create (o)-[:instanceMatchesAltLabel {rule:"oType-ClassOORaltLabelEn",creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),creationType:"cypherCreate"}]->(altLab);


// *** calcul des propriétés ClassOOR.instancesDirectes et ClassOOR.instancesCumulees 

// instances directes
match (c:ClassOOR) set c.instancesDirectes=0;
match (c:ClassOOR) where exists(c.cumulDone) remove c.cumulDone;

match (c:ClassOOR)<-[:isInstanceOf]-(o:ObjetGeo) 
	with c, count(distinct o) as count set c.instancesDirectes=count ;
	
// instances cumulée à partir de la hierarchie de classOOR
match (c:ClassOOR) set c.instancesCumulees =0;

match (c:ClassOOR)<-[:isInstanceOf]-(o:ObjetGeo) 
	with c, count(distinct o) as count set c.instancesCumulees=count;

match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf*6]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;
	
match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf*5]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;

match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf*4]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;

match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf*3]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;

match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf*2]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;

match (c:ClassOOR)-[:isSubClassOf]->(c1:ClassOOR)-[:isSubClassOf]->(racine:ClassOOR {id:"racine"})
	where not exists(c1.cumulDone)
	with c1,sum(distinct c.instancesCumulees) as count
	set c1.instancesCumulees= c1.instancesCumulees+count, c1.cumulDone=true;

match (c:ClassOOR)-[:isSubClassOf]->(racine:ClassOOR {id:"racine"})
	with racine,sum(distinct c.instancesCumulees) as count
	set racine.instancesCumulees= racine.instancesCumulees+count;

match (c:ClassOOR) where exists(c.cumulDone) remove c.cumulDone;


// *** calcul des propriétés AltLabel.usedToInstanciate 
match (a) where (a:AltLabelFr  or a:AltLabelEn) and exists(a.usedToInstanciate) remove a.usedToInstanciate;

match (c:ClassOOR)-[:isInstanceOf]-(o:ObjetGeo)-[:instanceMatchesAltLabel]-(a ) where (a:AltLabelFr  or a:AltLabelEn) 
with a, c.prefLabelFr as prefLabel, count(distinct o) as count 
with a, collect(prefLabel+":"+toString(count)) as usedToInstanciate
set  a.usedToInstanciate=usedToInstanciate;


match (c:ClassOOR)-[:isInstanceOf]-(o:ObjetGeo)-[:instanceMatchesVariantSpelling]-(v:VariantSpellingFr ) 
with v, c.prefLabelFr as prefLabel, count(distinct o) as count 
with v, collect(prefLabel+":"+toString(count)) as usedToInstanciate
set  v.usedToInstanciate=usedToInstanciate;


// *** calcul des propriétés classOOR.hasObjectInstanceInLayer
match (c:ClassOOR) where exists(c.hasObjectInstanceInLayer) remove c.hasObjectInstanceInLayer;

match (c:ClassOOR)-[:isInstanceOf]-(:ObjetRepère)-[:hasGeometry]-(g:geom)
with collect(distinct split(g.WKT," ")[0]) as WKT,c
set c.hasObjectInstanceInLayer=WKT;


// *** hasToponyme
match (c:ClassOOR) where exists(c.hasToponyme) remove c.hasToponyme;

match (c:ClassOOR)-[:isInstanceOf]-(:Toponyme) with distinct c set c.hasToponyme=true;
