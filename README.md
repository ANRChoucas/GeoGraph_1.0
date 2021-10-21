# GeoGraph 1.0

## _Development & Contributions_

License:  TODO

Institute: IGN + ANR

### Authors

Développeur: Véronique Gendner

Encadrants: Marie-Dominique Van Damme, Véronique Gendner


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

```

Ca y est la base est prête à être chargée

## Chargement des données

Dans la fenêtre Neo4j desktop Cliquer sur start pour lancer la base de données.


