CREATE TEMPORARY TABLE equipement
(
    id_equipement INT,
    prix_equipement BIGINT
);

CREATE TEMPORARY TABLE don_guerre
(
    id_guerre INT,
    annee_guerre INT,
    id_lieu INT,
    id_equipement INT,
    id_demidieu INT
);

CREATE TEMPORARY TABLE vente_guerre
(
	date_vente INT,
	prix_total BIGINT,
	id_demidieu INT,
	id_lieu INT,
	id_equipement INT
);

CREATE TEMPORARY TABLE vente_guerre_plus_un
(
	date_vente INT,
	prix_total BIGINT,
	id_demidieu INT,
	id_lieu INT,
	id_equipement INT
);

INSERT INTO don_guerre
SELECT T0.ID, T0.Annee, T0.ID_Lieu, vente.ID_TypeEquipement, T0.ID_DemiDieu
FROM (SELECT guerre.ID, guerre.Annee, participe.ID_DemiDieu, guerre.ID_Lieu
    FROM guerre
    NATURAL JOIN participe
    WHERE guerre.ID_Lieu IS NOT NULL) AS T0, vente
WHERE vente.ID_DemiDieu = T0.ID_DemiDieu
AND SUBSTRING_INDEX(vente.`Date`, ",", 1) = T0.Annee;

INSERT INTO equipement
SELECT T2.Numero_Equipement/*, T2.Nom_Equipement*/, AVG(Oberon_De_Bronze/T2.QuantiteEquipement) AS Prix_Moyen_en_Ob
FROM
    (SELECT t1.ID_Vente AS Numero_Vente, SUM(t1.Prix_Bronze) AS Oberon_De_Bronze, vente.ID_TypeEquipement AS Numero_Equipement, typeequipement.Denomination AS Nom_Equipement, vente.Quantite AS QuantiteEquipement
    FROM(SELECT rapporte.ID AS ID_Vente, rapporte.Quantite, oberon.CoefficientDeConversion, oberon.CoefficientDeConversion*rapporte.Quantite AS Prix_Bronze FROM `rapporte` 
         LEFT JOIN oberon ON oberon.ID=rapporte.`ID_Oberon`  
         ORDER BY rapporte.ID) AS T1
    LEFT JOIN vente ON t1.ID_Vente=vente.ID
    LEFT JOIN typeequipement ON vente.ID_TypeEquipement=typeequipement.ID
    GROUP BY ID_Vente
    ORDER BY ID_Vente) AS T2
GROUP BY T2.Numero_Equipement
ORDER BY T2.Numero_Equipement;

INSERT INTO vente_guerre
SELECT SUBSTRING_INDEX(vente.DATE, ",", 1), (oberon.CoefficientDeConversion * rapporte.Quantite), vente.ID_DemiDieu, vente.ID_Lieu, vente.ID_TypeEquipement
FROM rapporte
LEFT JOIN vente ON rapporte.ID = vente.ID
LEFT JOIN oberon ON rapporte.ID_Oberon = oberon.ID;

INSERT INTO vente_guerre_plus_un
SELECT SUBSTRING_INDEX(vente.DATE, ",", 1), (oberon.CoefficientDeConversion * rapporte.Quantite), vente.ID_DemiDieu, vente.ID_Lieu, vente.ID_TypeEquipement
FROM rapporte
LEFT JOIN vente ON rapporte.ID = vente.ID
LEFT JOIN oberon ON rapporte.ID_Oberon = oberon.ID;

SELECT vente_guerre.date_vente, don_guerre.annee_guerre, vente_guerre.id_equipement, SUM(vente_guerre.prix_total) AS `Revenus sur l'année et sur l'objet`, equipement.prix_equipement AS `Prix unitaire moyen de l'equipement`, SUM(vente_guerre_plus_un.prix_total) AS `Revenus sur l'année suivante et sur l'objet`
FROM vente_guerre
LEFT JOIN equipement ON vente_guerre.id_equipement = equipement.id_equipement
LEFT JOIN don_guerre ON vente_guerre.date_vente = don_guerre.annee_guerre
LEFT JOIN vente_guerre_plus_un ON vente_guerre.id_equipement = vente_guerre_plus_un.id_equipement
WHERE don_guerre.annee_guerre = vente_guerre.date_vente
AND don_guerre.id_equipement = vente_guerre.id_equipement
AND don_guerre.annee_guerre + 1 = vente_guerre_plus_un.date_vente
AND don_guerre.id_equipement = vente_guerre_plus_un.id_equipement
AND vente_guerre.date_vente + 1 = vente_guerre_plus_un.date_vente
GROUP BY don_guerre.annee_guerre;

DROP TEMPORARY TABLE equipement;
DROP TEMPORARY TABLE don_guerre;
DROP TEMPORARY TABLE vente_guerre;
DROP TEMPORARY TABLE vente_guerre_plus_un;
