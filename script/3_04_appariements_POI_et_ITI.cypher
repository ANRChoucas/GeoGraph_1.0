// Set 186 properties, created 93 relationships, completed after 140 ms.
// POI c2c 2021
:param importFile => "3_01_appariement_c2c_BDTOPO.csv";
call apoc.load.csv($importFile,{sep:";"}) YIELD map
with map 
match (a:sourceC2c:v2021:POI {id:"POI."+map.c2c}),(b:sourceBDTOPO:v2021 {id:map.BDTOPO})
	create (a)-[r:sameAs_multicriteriaAlgo {
		creationDateTime:localdatetime({ timezone: 'Europe/Paris' }),
		creationType:"import",
		dateSrc:"2021-06-17",
		importFile:$importFile}]->(b) ;
