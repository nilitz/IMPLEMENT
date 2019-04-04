CREATE TABLE requete_12v2
SELECT *
FROM
(SELECT T2.id_Province, T2.Nom_province, SUM(Oberon_De_Bronze) AS Prix
FROM
    (SELECT t1.ID_Vente AS Numero_Vente, SUM(t1.Prix_Bronze) AS Oberon_De_Bronze, T0.ID AS id_Province, T0.Nom AS Nom_province
    FROM(SELECT rapporte.ID AS ID_Vente, rapporte.Quantite, oberon.CoefficientDeConversion, oberon.CoefficientDeConversion*rapporte.Quantite AS Prix_Bronze FROM `rapporte` 
         LEFT JOIN oberon ON oberon.ID=rapporte.`ID_Oberon`  
         ORDER BY rapporte.ID) AS T1
    LEFT JOIN vente ON t1.ID_Vente=vente.ID
    LEFT JOIN lieu ON vente.ID_Lieu=lieu.ID
    LEFT JOIN (SELECT * FROM lieu WHERE lieu.ID_Lieu IS NULL) AS T0 ON (lieu.ID_Lieu=T0.ID) OR (lieu.ID=T0.ID)
    GROUP BY ID_Vente
    ORDER BY ID_Vente) AS T2
    WHERE T2.Nom_province IS NOT NULL 
GROUP BY T2.Nom_province
ORDER BY T2.Nom_province) AS T3projet;

SELECT *
FROM requete_12v2;
