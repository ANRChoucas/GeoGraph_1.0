# GeoGraph 1.0

## _Development & Contributions_

License:  TODO

Institute: IGN + ANR

### Authors

Développeur: Véronique Gendner

Encadrants: Marie-Dominique Van Damme, Ana-Maria Raimond


# Plan
- [Introduction](#Introduction)
- [Modélisation](#Modélisation)
- [Installation](#Installation)


# Introduction
Les personnes perdues en montagne décrivent aux secouristes leur environnement spatial, en retraçant leur itinéraire 
et en énumérant les points de repère le jalonnant. Leur localisation s’avère une tâche difficile malgré 
l’existence des applications de géolocalisation. Le projet [CHOUCAS](http://choucas.ign.fr/), 
financé par l’Agence Nationale de la Recherche, vise à améliorer le temps de recherche des victimes 
en proposant des méthodes et outils innovants. 

Les principaux objectifs de ce travail a été la mise en place d'une base graphe avec [Neo4j](https://neo4j.com/) 
et de proposer une méthode d’intégration sémantique de données géographiques multi-sources dans la base de données.

L'intégration s'appuie sur une ontologie des objets géographiques pouvant servir d'objets de référence, 
l'ontologie des objets de repères [OOR](http://choucas.ign.fr/doc/ontologies/index-fr.html). 
Pour y arriver, un travail d’appariement des schémas des différentes sources de données sur l’ontologie des objets 
de repère a été réalisée.

> Ref: papier à l'ICC 2021


# Modélisation

![png](https://github.com/ANRChoucas/GeoGraph_1.0/blob/main/img/modele_geograph_2_0.png)


# Données 

Les données importées concernent les données du département de l'Isère (38):
* la zone d'étude du projet CHOUCAS, les massifs alpins de la zone d'étude. 
Ces données ont été construites dans le cadre de ce projet.
* 




# Guide d'installation

## Installation de neo4j

1. Télécharger et installer Neo4j desktop depuis le site de [neo4j](https://neo4j.com/download)

2. Créer une base Neo4j 4.3.3 "GeoGraph_1_0"

3. Installer le plugin APOC avec l'installeur des plugins de Neo4j

4. Pour le plugin spatial, ouvrir le répertoire où doivent se trouver les plugins de la base.
Puis y placer le plugin spatial téléchargé [ici](https://github.com/neo4j-contrib/spatial/releases)

5. Ajouter les lignes suivantes aux settings de la base:
```cypher
dbms.security.procedures.unrestricted=spatial.*
apoc.import.file.enabled=true
apoc.export.file.enabled=true
cypher.lenient_create_relationship = true
```

Ca y est, maintenant la base est prête à être chargée.

## 1ère option - Chargement des données

1. Dans la fenêtre Neo4j Desktop, cliquer sur _start_ pour lancer la base de données.

2. Placer les sources, c'est à dire les fichiers CSV du répertoire _data_ dans le répertoire _import_ de la base de données 
(clic sur "..." puis sur "Open folder")

3. Ouvrir l'application Neo4j Browser

4. Exécuter les scripts de chargement:

| Script                                | Données chargées                                                                       |
| --------------------------------------| -------------------------------------------------------------------------------------- |
| 0_CONFIG.cypher                       | Créer des couches spatiales vides, les contraintes et les index de la base de données. |
| 1_DATA_MASSIF_ZE.cypher               | Intégrer les contours des massifs  |
| 2_01_PNR_VERCORS_2018.cypher          | Intégrer les POI du site https://rando.parc-du-vercors.fr |
| 2_02_PN_ECRINS_2018.cypher            | Intégrer les POI du site https://rando.ecrins-parcnational.fr/ |
| 2_03_REFUGES_INFO_2018.cypher         | Intégrer les POI du site https://www.refuges.info/ |
| 2_04_ITI_PARCS_2018.cypher            | Intégrer les itinéraires des parcs (Vercors et Ecrins) recalés sur le réseau de la BDTOPO.  |
| 2_05_ITI_VISORANDO_2018.cypher        | Intégrer les itinéraires de https://www.visorando.com/ recalés sur le réseau de la BDTOPO.  |
| 2_06_C2C_2021.cypher                  | Intégrer les POIS et les route du site https://www.camptocamp.org/ |
| 2_07_OSM_2018.cypher                  | Intégrer les stations de ski d'OSM https://www.openstreetmap.org |
| 2_08_ENEDIS_2018.cypher               | Intégrer les lignes électriques d'ENEDIS https://www.enedis.fr/open-data |
| 2_09_BDTOPO_POINT_2021.cypher         | Intégrer les données ponctuelles et les toponymes de la BDTOPO |
| 2_10_BDTOPO_LIGNE_2021.cypher         | Intégrer les données linéraires de la BDTOPO |
| 2_11_BDTOPO_SURFACE_2021.cypher       | Intégrer les données surfaciques de la BDTOPO |
| 3_01_BDTOPO_CREATION_TOPONYME.cypher  | Création des noeuds Toponymes à partir des objets de repères et des nymies |
| 3_02_OOR_import_et_corrections.cypher | Intègre l’OOR |
| 3_03_OOR_instanciation.cypher         | Création des relations _:isInstanceOf_ entre les _:ObjetGeo_ en base et les classes de l’ontologie _:ClassOOR_ |
| 3_04_appariements_POI_et_ITI.cypher   | importe la sélection des appariements calculés sur les données 2018, si les objet 2021 ont le même nom, le même type et la même géométrie |


## Affichage de GeoGraph dans QGis

Le script _QgisQueryGeoGraph.py_ permet d'afficher des résultats de requête cypher dans QGis 
en tant que couche de données spatiales. Le script n'est pas robuste, il s'adresse aux personnes 
qui savent modifier du python.






