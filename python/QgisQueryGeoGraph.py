'''
Author: Véronique Gendner
Copyright (C) 2021 Institut National de l'Information Géographique et Forestière 
Licence: CC BY-ND 4.0
'''

from neo4j import GraphDatabase

# *** script d'affichage du contenu de la base Neo4j GeoGraph - projet http://choucas.ign.fr/ - Veronique.Gendner@e-tissage.net - juillet 2021 ***

# les conditions de filtrage sont a modifier dans les paramêtres ci-dessous

# les contraintes sur regex appliqué à property / UserLstClassOOR ou lstClassOORdistinctLayers / whereObjectLabel sont cumulatives
# 1. l'expression régulière est appliquée sur la propriété définie par la variable property (name,type,id...) des noeuds
#       NB: bien mettre une côte simple au début et à la fin de regex, 
#           enlever .* au début et à la fin pour ne matcher que la chaine exacte
#           (?i) en début de regexp rend le match case insensitive
#           \\\\b indique une word boundary
# 2. UserLstClassOOR permet de préciser une ou plusiseurs prefLabelFr de classOOR
#    si lstClassOORdistinctLayers est utilisé, les différentes classes seront générées dans des couches distinctes
# 3. whereObjectLabel permet de restreindre aux noeuds avec un certain label
# labelClass permet de préciser la version de l'OOR utilisée (pour BD contenant plusieurs version de l'OOR)

# regexp
regex = "'(?i).*ravin du chevalet.*'" #"'(?i).*refuge de la pra.*'"  #  "'(?i).*vianney.*'" #"'(?i).*\\\\bretenue\\\\b.*'"#"'(?i).*\\\\bpisse\\\\b.*'" # "'(?i).*\\\\bmuzelle\\\\b.*'" ## "'.*point d.eau.*'"  -----     (?i) case insensitive \\\\b word boundary
# property à laquelle appliquer regexp
property = "name" # "type" ou "name" ou "id"
# ClassOOR
UserLstClassOOR = ""#"['refuge']" # '["réseau hydrographique naturel", "île", "surface d'+"'"+'eau", "nappe d'+"'"+'eau", "lac", "marais", "cascade", "glacier", "moraine", "névé", "corniche de neige", "diffluence", "sérac", "manteau", "rive", "cours d'+"'"+'eau", "ruisseau", "rivière", "fleuve", "plage", "banc", "noeud du réseau hydrographique", "confluence", "source", "source captée", "exutoire", "perte", "infrastructure de transport d'+"'"+'eau", "canalisation", "conduite forcée", "cours d'+"'"+'eau artificiel", "bief", "fossé", "égout", "canal d'+"'"+'irrigation", "canal", "aqueduc", "infrastructure de déplacement maritime ou fluvial", "amer", "écluse", "port", "quai", "canal de navigation"]' #"['lac']" #forêt','forêt de conifères','forêt de feuillus
    # '["lieu de culte", "couvent", "chapelle", "temple bouddhiste", "mosquée", "temple hindouiste", "église", "cathédrale", "synagogue"]'
lstClassOORdistinctLayers = ""# ["['barage']","['camping']","['parking']","['ruine']","[ 'glacier']","[ 'grotte']","['fontaine']","['gorge']","['croix']"] # ,"['forêt']" "['refuge']",,"['cascade']","['col']","['sommet']","['chapelle']",
# labels
whereObjectLabel = ""#" and o:VoieNommée"  #"and o:RouteNommée" #"and o:ITI:v2018" # "and o:sourceBDTOPO:v2021"# "and o:RouteNommée" #"and o:v2021" #" and o:Toponyme" "and o:sourceBDTOPO:v2021"

userNomCouches = "" # écrase le calcul automatique des noms de couche à partir des paramêtres définis
labelClass = "ClassOOR" # à ne modifier que si la BD contient différents jeux de ClassOOR

# si lstIds tronconId lstClassOOR2 ou regexLine sont différents de "", les paramêtres ci-dessus sont ignorés

# si liste d'ID <> "" les autres conditions sont ignorées 
lstIds =  "" #"['TN.EQ_RESEA0000000327504286', 'TN.EQ_RESEA0000000130194355', 'TN.EQ_RESEA0000000343255224', 'TN.EQ_RESEA0000000130194223', 'TN.EQ_RESEA0000000326576621', 'TN.EQ_RESEA0000000130194224', 'TN.EQ_RESEA0000000289033686', 'TN.EQ_RESEA0000000130194199', 'TN.EQ_RESEA0000002203891940', 'TN.EQ_RESEA0000000323016217', 'TN.EQ_RESEA0000000257347031', 'TN.EQ_RESEA0000000328165418', 'TN.EQ_RESEA0000000130194236','VOIE____0000000346213395', 'VOIE____0000002201859192', 'VOIE____0000002215974179', 'VOIE____0000000346200936', 'VOIE____0000002202163766', 'VOIE____0000002215974180', 'VOIE____0000002215974177', 'VOIE____0000000346213393', 'VOIE____0000000346218399', 'VOIE____0000000346202811', 'VOIE____0000000346218401', 'VOIE____0000000346200920', 'VOIE____0000002215974181', 'VOIE____0000000346213388', 'VOIE____0000000346200927', 'VOIE____0000000346200950']" 

# si tronconId <> '' les autres conditions sont ignorées et les tronçons reliés à celui indiqué sont affichés
tronconId = ""#'TRONROUT0000000008079602'

# ce type de requête est impossible dans GeoGraph 2.0 qui ne contient pas de relation isCloseTo
# si lstClassOOR2 <> '' ou regexLine <> '' la requête recherche un lineLabel relié par distRel à un objet  dans UserLstClassOOR et un autre dans lstClassOOR2
# si regex <> '' elle s'applique à property de UserLstClassOOR et si regex2 <> '' elle s'applique à lstClassOOR2
lstClassOOR2 = ""#"['parking']"#  "['cascade']" #"['construction', 'église', 'chapelle', 'commune', 'hameau', 'antenne', 'barrage','fontaine', 'calvaire', 'parking', 'camping', 'tunnel', 'abri de montagne', 'cabane', 'refuge', 'bivouac', 'ligne électrique', 'lac', 'réservoir', 'rivière', 'ruisseau', 'glacier', 'cascade', 'source', 'canal', 'canal', 'sommet', 'col', 'canyon', 'grotte', 'pic', 'plaine', 'crête', 'gorge', 'chemin', 'route', 'pont', 'forêt', 'lande ligneuse', 'forêt de feuillus', 'forêt de conifères', 'tronçon de route']"
regex2 = ""# "'(?i).*\\\\bsapet\\\\b.*'"  #"'(?i).*\\\\bvianney\\\\b.*'" 
regexLine = ""#"'(?i).*\\\\bpalastre\\\\b.*'" #"'(?i).*\\\\bsaut du laire\\\\b.*'" 
#match (:ClassSelection)--(c:ClassOOR) where c.instancesDirectes<>0 and "POINT" in c.hasObjectInstanceInLayer   return collect(distinct c.prefLabelFr)
#"['sommet']" #"['lac']" !!'cours d'eau' 'nappe d'eau', 
distRel = "['isCloseTo_200m']"
lineLabel = "l:ITI" # or l:TronçonRout RouteNommée VoieNommée ITI

##### fin du paramétrage


if len(lstClassOOR2) > 15 :
    lstClassOOR2name = "ClassSelection"
else :
    lstClassOOR2name = lstClassOOR2


# la requête cypherCouche doit retourner au moins un WKT aliasé sur wkt. tous les autres champs retournés sont mis dans la table d'attribut 
def extractLayer(geoTypeStr,cypherCouche,nomCouche,color = QColor.fromRgb(255,128,0)):
    
    # data retrieval Ch0uk@s 11003
    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "Choucas"), encrypted=False)

    session = driver.session()
        
    result = session.run(cypherCouche)
    
    if result.peek() != None :
        # layers creation
        ly = QgsVectorLayer (geoTypeStr+"?crs=epsg:4326", nomCouche, "memory")
        pr = ly.dataProvider()
        lstAttbt = []
        for key in result.keys() :
            if key != "wkt" :
                lstAttbt.append(QgsField(key, QVariant.String))
        pr.addAttributes(lstAttbt)
        ly.updateFields()
        
        nbRes = 0
        for record in result:
            nbRes += 1
            
            fet = QgsFeature()
            fet.setGeometry(QgsGeometry.fromWkt(record["wkt"]))
            
            lstValue = []
            for key in record.keys() :
                if key != "wkt" :
                    lstValue.append(record[key])
            fet.setAttributes(lstValue)
            pr.addFeatures([fet])

        ly.setName(nomCouche+" ("+str(nbRes)+")")
        
        # symbologie
        single_symbol_renderer = ly.renderer()
        symbolLine = single_symbol_renderer.symbol()
        symbolLine.setColor(color)
        if geoTypeStr == "multilineString" :
            symbolLine.setWidth(1.5)
        ly.updateExtents()
        QgsProject.instance().addMapLayer(ly)
        
        print(str(nbRes)+" "+geoTypeStr+"s")
    else :
        print("0 "+geoTypeStr)
    
    driver.close()

if lstIds !="" :
    whereObject = " and o.id in "+lstIds
    lstClass = [""]
else :
    if regex != "" :
        whereObject = " and o."+property+" =~ "+regex
    else :
        whereObject = ""

    if regex2 != "" :
        whereObject2 = " and o2."+property+" =~ "+regex2
    else :
        whereObject2 = "" 
        
    if regexLine != "" :
        whereLine = " and l.name =~ "+regexLine
    else :
        whereLine = "" 
        
    if lstClassOOR2 != "" :
        whereClassOOR2 = " and c2.prefLabelFr in "+ lstClassOOR2 
    else :
        whereClassOOR2 = ""
              
    if UserLstClassOOR==""  and (lstClassOOR2 != "" or regexLine != "") :
        lstClass = ["ClassOOR"]
    elif lstClassOORdistinctLayers != "" :
        lstClass = lstClassOORdistinctLayers
    else :
        lstClass = [UserLstClassOOR]

gtype = {'Points':"1",'Lines':"5",'Polygons':"6"}

for lstClassOOR in lstClass :
    cypherCouche= {} 
    layerName={}
    
    if lstClassOOR != "ClassOOR" :
        whereClassOOR = " and c.prefLabelFr in "+ lstClassOOR 
    else :
        whereClassOOR = ""
    
    if tronconId != "" :
        cypherCouche['Lines'] = """match (o1:TronçonRout)-[:connected*0..5]-(o2:TronçonRout) where o1.id ='"""+tronconId+"""' 
            with o1+collect(o2) as oList
            match (o:ObjetGeo)-[:hasGeometry]-(g:geom) where o in oList
            optional match (o)--(c:"""+labelClass+""")
            return g.WKT as wkt, o.name as name, o.id as id, o.type as type, apoc.text.join(collect(c.prefLabelFr), ',') as classOOR,
            apoc.text.join([lab in labels(o) where not lab starts with "v20" and not lab="ObjetGeo" and not lab starts with "source" | lab], ',') as labels ,
            replace([lab in labels(o) where lab starts with "source" | lab][0],'source','') as source,o.importFile as importFile,
            [lab in labels(o) where lab starts with "v20" | lab][0]  as version
            """
        layerName['Lines'] = "tronçons connectedTo "+tronconId
    elif (lstClassOOR2 != "" or regexLine != "") :
        cypherCouche['Points'] = """match (c:"""+labelClass+""" )<-[:isInstanceOf]-(o)-[r1]-(l)-[r2]-(o2)-[:isInstanceOf]->(c2:"""+labelClass+""") 
            where true """+whereClassOOR+ whereClassOOR2+""" 
            and type(r1) in """+distRel+""" and type(r2) in """+distRel+whereObject+whereObject2+"""
            and ("""+lineLabel+""") """+whereLine+"""
            with collect (distinct o)+collect(distinct o2) as objects
            unwind objects as o
            match (c:"""+labelClass+""")--(o:ObjetGeo)-[:hasGeometry]-(g:geom) 
            return g.WKT as wkt, o.name as name, o.id as id, o.type as type, apoc.text.join(collect(distinct c.prefLabelFr), ',') as classOOR,
            apoc.text.join([lab in labels(o) where not lab starts with "v20" and not lab="ObjetGeo" and not lab starts with "source" | lab], ',') as labels,
            replace([lab in labels(o) where lab starts with "source" | lab][0],'source','') as source,o.importFile as importFile,
            [lab in labels(o) where lab starts with "v20" | lab][0]  as version order by version,source,classOOR
            """
        layerName['Points'] = lstClassOOR+" "+regex
        if lstClassOOR2name !="" or regex2 != "" :
            layerName['Points'] = layerName['Points'] +" et "+ lstClassOOR2name+" "+regex2
        layerName['Points'] =layerName['Points'] + " "+distRel+" "+lineLabel
        cypherCouche['Lines'] = """match (c:"""+labelClass+""" )<-[:isInstanceOf]-(o)-[r1]-(l)-[r2]-(o2)-[:isInstanceOf]->(c2:"""+labelClass+""") 
            where true """+whereClassOOR+ whereClassOOR2 +""" 
            and type(r1) in """+distRel+""" and type(r2) in """+distRel+whereObject+whereObject2+"""
            and ("""+lineLabel+""") """+whereLine+"""
            with l
            match (l)-[:hasGeometry]-(g:geom) 
            optional match (l)--(c:"""+labelClass+""")
            return g.WKT as wkt, l.name as name, l.id as id, l.type as type, apoc.text.join(collect(c.prefLabelFr), ',') as classOOR,
            apoc.text.join([lab in labels(l) where not lab starts with "v20" and not lab="ObjetGeo" and not lab starts with "source" | lab], ',') as labels,
            replace([lab in labels(l) where lab starts with "source" | lab][0],'source','') as source,l.importFile as importFile,
            [lab in labels(l) where lab starts with "v20" | lab][0]  as version order by version,source,classOOR
            """
        layerName['Lines'] = lineLabel+" "+distRel+" "
        if whereLine != ""  :
            layerName['Lines']=layerName['Lines']+" "+ whereLine
        if lstClassOOR != "ClassOOR" or regex!= "" :
            layerName['Lines']=layerName['Lines']+lstClassOOR+" "+regex
        if lstClassOOR2name != "" or regex2!= "" :
            layerName['Lines']=layerName['Lines']+" et "+ lstClassOOR2name+" "+regex2
        
    elif lstClassOOR != "" :
        for typeGeom in ['Points','Lines','Polygons'] :
            cypherCouche[typeGeom] = """match (c:"""+labelClass+""")--(o:ObjetGeo)-[:hasGeometry]-(g:geom) 
            where g.gtype in ["""+gtype.get(typeGeom)+"""] """+whereClassOOR+whereObject+whereObjectLabel+"""
            return g.WKT as wkt, o.name as name, o.id as id, o.type as type, apoc.text.join(collect(c.prefLabelFr), ',') as classOOR,
            apoc.text.join([lab in labels(o) where not lab starts with "v20" and not lab="ObjetGeo" and not lab starts with "source" | lab], ',') as labels,
            replace([lab in labels(o) where lab starts with "source" | lab][0],'source','') as source,o.importFile as importFile,
            [lab in labels(o) where lab starts with "v20" | lab][0]  as version order by version,source,classOOR
            """
    else :
        for typeGeom in ['Points','Lines','Polygons'] :
            cypherCouche[typeGeom] = """match (o:ObjetGeo)-[:hasGeometry]-(g:geom) where g.gtype in ["""+gtype.get(typeGeom)+"""] """+whereObject+whereObjectLabel+"""
            optional match (o)--(c:"""+labelClass+""")
            return g.WKT as wkt, o.name as name, o.id as id, o.type as type, apoc.text.join(collect(c.prefLabelFr), ',') as classOOR,
            apoc.text.join([lab in labels(o) where not lab starts with "v20" and not lab="ObjetGeo" and not lab starts with "source" | lab], ',') as labels ,
            replace([lab in labels(o) where lab starts with "source" | lab][0],'source','') as source,o.importFile as importFile,
            [lab in labels(o) where lab starts with "v20" | lab][0]  as version order by version,source,classOOR
            """

    if userNomCouches == "" :
        if regex != "" :
            nomCouches=lstClassOOR+" "+property+":"+regex+" "+whereObjectLabel
        else :
            nomCouches=lstClassOOR+" "+whereObjectLabel
    else :
        nomCouches=userNomCouches

    if not 'Points' in layerName.keys():
        layerName['Points'] = nomCouches+" points"
    if not 'Lines' in layerName.keys() :
        layerName['Lines']=nomCouches+" lines"
    if not 'Polygons' in layerName.keys() :
        layerName['Polygons']=nomCouches+" polygons"

    #print(cypherCouche['Points'])
    #print(cypherCouche['Lines'])
    #print(cypherCouche['Polygons'])
    
    if 'Polygons' in cypherCouche.keys() :
        extractLayer("multiPolygon",cypherCouche['Polygons'],layerName['Polygons'])
    if 'Lines' in cypherCouche.keys() :
        extractLayer("multilineString",cypherCouche['Lines'],layerName['Lines'])
    if 'Points' in cypherCouche.keys() :
        extractLayer("point",cypherCouche['Points'],layerName['Points'])
       
