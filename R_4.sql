SELECT T1.`Year` AS Annee, T1.C1 AS `Moyenne des quantités vendues chaque année hors Ægypte`,T2.C1 AS `Moyenne des quantités vendues chaque année en Ægypte`, ROUND(((T2.C1-T1.C1)/T1.C1)*100,2) AS `Difference en %`
FROM
/* On calcule la moyenne vendu (en quantité) par annee hors Ægypte*/
	(
	SELECT T0.ID,SUBSTRING(vente.`Date`,1,3) AS `Year`,AVG(Quantite) AS C1 
	FROM vente
	LEFT JOIN lieu ON vente.ID_Lieu=lieu.ID
	LEFT JOIN (SELECT * FROM lieu WHERE lieu.ID_Lieu IS NULL) AS T0 ON (lieu.ID_Lieu=T0.ID) OR (lieu.ID=T0.ID)
	WHERE vente.ID_Lieu IS NOT NULL AND vente.ID_Lieu !=2
	GROUP BY SUBSTRING(vente.`Date`,1,3)
	) AS T1
LEFT JOIN
/* On calcule la moyenne vendu (en quantité) par annee en Ægypte*/
	(SELECT T0.ID, SUBSTRING(vente.`Date`,1,3) AS `Year` ,AVG(Quantite) AS C1
	FROM vente
	LEFT JOIN lieu ON vente.ID_Lieu=lieu.ID
	LEFT JOIN (SELECT * FROM lieu WHERE lieu.ID_Lieu IS NULL) AS T0 ON (lieu.ID_Lieu=T0.ID) OR (lieu.ID=T0.ID)
	WHERE vente.ID_Lieu IS NOT NULL AND vente.ID_Lieu =2
	GROUP BY SUBSTRING(vente.`Date`,1,3)
	) AS T2
ON T1.`Year`=T2.`Year` 
