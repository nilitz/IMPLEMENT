SELECT T1.Nom, ROUND(T1.Moyenne) AS `ventes divinité fêtée`, Round(T2.Moyenne) AS `ventes moyennes divinités non fêtées`, ROUND(T1.Moyenne / T2.Moyenne * 100, 2) AS `Rapport en %`
FROM
(
    SELECT AVG(T0.somme) AS Moyenne, T0.nom
    FROM
    (
        SELECT mois.Nom, mois.ID_Divinite AS ID_divinites_fetees, vente.ID_Divinite, SUM(vente.Quantite) AS somme
        FROM vente 
        LEFT JOIN Mois ON SUBSTRING_INDEX(SUBSTRING_INDEX(vente.`date`, " ", 2), " ", -1) = mois.Nom
        GROUP BY mois.Nom, vente.ID_Divinite
    ) AS T0
    WHERE T0.ID_divinites_fetees = T0.ID_divinite
    GROUP BY T0.Nom
) AS T1
LEFT JOIN 
(
    SELECT AVG(T0.somme) AS Moyenne, T0.nom
    FROM
    (
        SELECT mois.Nom, mois.ID_Divinite AS ID_divinites_fetees, vente.ID_Divinite, SUM(vente.Quantite) AS somme
        FROM vente 
        LEFT JOIN Mois ON SUBSTRING_INDEX(SUBSTRING_INDEX(vente.`date`, " ", 2), " ", -1) = mois.Nom
        GROUP BY mois.Nom, vente.ID_Divinite
    ) AS T0
    WHERE T0.ID_divinites_fetees != T0.ID_divinite
    GROUP BY T0.Nom
) AS T2
ON T1.Nom = T2.Nom
