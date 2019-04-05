CREATE TEMPORARY TABLE don_guerre
(
    guerre_id INT,
    guerre_an INT,
    guerre_lieu_id INT,
    guerre_equipement_id INT
);

INSERT INTO don_guerre
SELECT T0.ID, T0.Annee, T0.ID_Lieu, vente.ID_TypeEquipement
FROM (SELECT guerre.ID, guerre.Annee, participe.ID_DemiDieu, guerre.ID_Lieu
    FROM guerre
    NATURAL JOIN participe
    WHERE guerre.ID_Lieu IS NOT NULL) AS T0, vente
WHERE vente.ID_DemiDieu = T0.ID_DemiDieu
AND SUBSTRING_INDEX(vente.`Date`, ",", 1) = T0.Annee;

SELECT SUM(T1.Quantite) AS `Quantite d'objets vendu dans la province en guerre`, T1.`date` AS `Date des ventes`, T1.guerre_an AS `Date du don et de la guerre`, T1.`lieu` AS `Lieu de la guerre`
FROM
(
    SELECT vente.Quantite, SUBSTRING_INDEX(vente.`date`, ",", 1) AS `date`, don_guerre.guerre_an, lieu.Nom AS `lieu`
    FROM vente
    LEFT JOIN don_guerre ON vente.ID_Lieu = don_guerre.guerre_lieu_id
    LEFT JOIN lieu ON vente.ID_Lieu = lieu.ID
    WHERE ((SUBSTRING_INDEX(vente.DATE, ",", 1) - 1) = don_guerre.guerre_an) OR ((SUBSTRING_INDEX(vente.DATE, ",", 1)) = don_guerre.guerre_an)
) AS T1
GROUP BY T1.`date`;

DROP TEMPORARY TABLE don_guerre;
