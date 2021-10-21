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
Pour y arriver, un travail d’appariement des schémas des sources de données sur l’ontologie des objets 
de repère a été réalisée.

> Ref: papier à l'ICC


# Modélisation

![png](https://github.com/ANRChoucas/GeoGraph_1.0/blob/main/img/modele_geograph_2_0.png)


# Guide d'installation

## Installation de neo4j

1. Télécharger et installer Neo4j desktop depuis le site de [neo4j](https://neo4j.com/download)

2. Créer une base Neo4j 4.3.3

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

Ca y est la base est prête à être chargée

## Chargement des données

1. Dans la fenêtre Neo4j desktop Cliquer sur start pour lancer la base de données.

2. Placer les sources dans le répertoire import de la BD

3. Ouvrir browser

4. Dans le browser, exécuter les scripts:

| Script          | Données chargées |
| --------------- | ------ |
| 0_CONFIG.cypher | Créer des couches spatiales vides, les contraintes et les index de la base de données. |
| 1_XXX.cypher    | Intégrer les différentes sources de données |
| 2_1_OOR_import_et_corrections.cypher | Intègre l’OOR |
| 2_2_OOR_instanciation.cypher | Création des relations _:isInstanceOf_ entre les _:ObjetGeo_ en base et les classes de l’ontologie _:ClassOOR_ |
| 2.3.selectionClass.import.cypher créer les noeuds :ClassSelection et les rattachent par une relation :isEquivalentTo à la :ClassOOR correspondante |
| 3.1.appariements multicriteres POI et ITI.cypher | importe la sélection des appariements calculés sur les données 2018, si les objet 2021 ont le même nom, le même type et la même géométrie |


## Affichage de GeoGraph dans QGis

Le script _QgisQueryGeoGraph.py_ permet d'afficher des résultats de requête cypher dans QGis 
en tant que couche de données spatiales. Le script n'est pas robuste, il s'adresse aux personnes 
qui savent modifier du python.






