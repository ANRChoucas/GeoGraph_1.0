# GeoGraph 1.0

# Développements et contribution

<<<<<<< HEAD
- Licence du contenu du dépôt git: [CC BY-ND 4.0](LICENSE)
- Licence de la base de données GeoGraph 1.0: [CC BY SA version 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)
=======
- Licence du contenu du dépôt git: [CC BY-ND 4.0](LICENSE), [creativecommons.org](https://creativecommons.org/licenses/by-nd/4.0/deed.fr)
>>>>>>> f46a53b6720089c06e247cd797a122c7df2d828b

- Copyright (C) 2021 Institut National de l'Information Géographique et Forestière 

- Ce travail a été réalisé dans le cadre du projet CHOUCAS (ANR-16-CE23-0018), projet financé par l’ANR.
Pour de plus amples information [Site web](http://choucas.ign.fr/) 

- Contributeur: Véronique Gendner

# Plan
- [Introduction](#Introduction)
- [Modélisation](#Modélisation)
- [Données](#Données)
- [Guide d'installation](#Installation)
- [Affichage de GeoGraph](#Affichage)


# Introduction
Les personnes perdues en montagne décrivent aux secouristes leur environnement spatial, en retraçant leur itinéraire 
et en énumérant les points de repère le jalonnant. Leur localisation s’avère une tâche difficile malgré 
l’existence des applications de géolocalisation. Le projet [CHOUCAS](http://choucas.ign.fr/), 
financé par l’Agence Nationale de la Recherche, vise à améliorer le temps de recherche des victimes 
en proposant des méthodes et outils innovants. 

GeoGraph 1.0 est une base graphe réalisée avec [Neo4j](https://neo4j.com/) et qui a permis l’intégration de données géographiques multi-sources.

L'intégration s'appuie sur une ontologie des objets géographiques pouvant servir d'objets de repères, 
l'ontologie des objets de repères [OOR](http://choucas.ign.fr/doc/ontologies/index-fr.html). 
Pour y arriver, un travail d’appariement des schémas des différentes sources de données sur l’ontologie des objets 
de repère a été réalisée.


# Modélisation

![png](https://github.com/ANRChoucas/GeoGraph_1.0/blob/main/img/modele_geograph_2_0.png)


# Données 

Les données importées concernent les données du département de l'Isère (département 38) 
de la zone d'étude du projet CHOUCAS. Elles ont été téléchargées, traitées et intégrées.

**Quels traitements ?**

Les toponymes ont été intégrés tels que renseignés dans les sources. Leurs géométries ont été transformées en WGS84.

La détection des liens d'appariement des objets de repères des différentes sources de données 
a été réalisée grâce à un algorithme d'appariement multi-critères. Les résultats sont détaillés dans [1].

Les itinéraires téléchargés des sources de Rando.ecrins, Rando.Vercors, Visorando et Camptocamp
ont été recalés sur le réseau de la BDTOPO afin de construire un réseau d'itinéraires (voir [1]). 
C'est la géométrie des tronçons qui a été intégrée dans la base.

**Biblio:**

[1] Marie-Dominique Van Damme, Ana-Maria Olteanu-Raimond & Yann Méneroux (2019) 
Potential of crowdsourced data for integrating landmarks and routes for rescue in mountain areas, 
International Journal of Cartography, 5:2-3, 195-213, DOI: 10.1080/23729333.2019.1615730 

**Sources et versions des données**:

| Données          | Date du téléchargement | Source  |
| -----------------| -----------------------| -------- |
| projet CHOUCAS   | 2018       | http://choucas.ign.fr/   |
| BDTOPO           | 2021       | https://www.data.gouv.fr/fr/datasets/bd-topo-r/ |
| Camptocamp       | 2021       | https://www.camptocamp.org/ |
| Rando.Ecrins     | 2018       | https://rando.ecrins-parcnational.fr/ |
| Rando.Vercors    | 2018       | https://rando.parc-du-vercors.fr |
| Refuges.info     | 2018       | https://www.refuges.info/ |
| Openstreetmap    | 2021       | https://www.openstreetmap.org |
| Enedis           | 2021       | https://www.enedis.fr/open-data |
| Visorando        | 2018       | https://www.visorando.com/ |


# Installation

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
| 2_01_PNR_VERCORS_2018.cypher          | Intégrer les POI et les itinéraires du Parc Régional du Vercors |
| 2_02_PN_ECRINS_2018.cypher            | Intégrer les POI et les itinéraires du Parc National des Ecrins |
| 2_03_REFUGES_INFO_2018.cypher         | Intégrer les POI du site Refuges.info |
| 2_04_ITI_PARCS_2018.cypher            | Intégrer les itinéraires des parcs (Vercors et Ecrins) recalés sur le réseau de la BDTOPO.  |
| 2_05_ITI_VISORANDO_2018.cypher        | Intégrer les itinéraires de Visorando recalés sur le réseau de la BDTOPO.  |
| 2_06_C2C_2021.cypher                  | Intégrer les POIS et les route |
| 2_07_OSM_2018.cypher                  | Intégrer les stations de ski d'OSM |
| 2_08_ENEDIS_2018.cypher               | Intégrer les lignes électriques d'ENEDIS |
| 2_09_BDTOPO_POINT_2021.cypher         | Intégrer les données ponctuelles et les toponymes de la BDTOPO |
| 2_10_BDTOPO_LIGNE_2021.cypher         | Intégrer les données linéraires de la BDTOPO |
| 2_11_BDTOPO_SURFACE_2021.cypher       | Intégrer les données surfaciques de la BDTOPO |
| 3_01_BDTOPO_CREATION_TOPONYME.cypher  | Création des noeuds Toponymes à partir des objets de repères et des nymies |
| 3_02_OOR_import_et_corrections.cypher | Intègre l’OOR |
| 3_03_OOR_instanciation.cypher         | Création des relations _:isInstanceOf_ entre les _:ObjetGeo_ en base et les classes de l’ontologie _:ClassOOR_ |
| 3_04_appariements_POI_et_ITI.cypher   | importe la sélection des appariements calculés sur les données 2018, si les objet 2021 ont le même nom, le même type et la même géométrie |


## 2ème option - Chargement du dump

Le plus rapide et le plus simple est d’installer GeoGraph 1.0 à partir du fichier dump dès que la base de données est installée:
_dump/gg-1-0-neo4j-2021-10-27T074642.dump_

Pour des raisons d'espace autorisé sur github (100Mo), certaines données ont été supprimées du dump.

# Affichage

## Affichage de GeoGraph 1.0 dans QGis

Le script _python/QgisQueryGeoGraph.py_ permet d'afficher des résultats de requête cypher dans QGis 
en tant que couche de données spatiales. Le script n'est pas robuste, il s'adresse aux personnes 
qui savent modifier du python.


## Affichage de GeoGraph 1.0 dans Browser

Dans le browser Neo4j il suffit de glisser et déposer le fichier _style/GeoGraph.2.0.grass_ dans le browser Neo4j, 
pour retrouver le style (couleurs, taille. . . ) des noeuds utilisés dans le papier à l'ICC.




