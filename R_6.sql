SELECT T3.Nom, AVG(T3.Vente) AS 'Nombre de Vente Moyen', T3.Etat
FROM (SELECT DISTINCT t2.NOM, T2.AnnéeVente, t2.Vente, min(Etat) AS Etat
FROM (SELECT DISTINCT lieu.nom, T1.AnnéeVente, T1.Vente, IF(T1.AnnéeVente=guerre.Annee AND lieu.ID= guerre.ID_Lieu,'En guerre','En paix') AS Etat
FROM 
    (SELECT (COUNT(Vente.ID)) AS Vente, (substring_index(Vente.Date, ',', +1)) AS AnnéeVente, ID_Lieu
     FROM vente
     WHERE ID_Lieu IS NOT NULL
     GROUP BY ID_Lieu, AnnéeVente
    ) AS T1
LEFT OUTER JOIN guerre ON guerre.Annee=T1.AnnéeVente
INNER JOIN lieu on lieu.ID=T1.ID_Lieu 
ORDER BY annee, nom) AS T2
GROUP BY t2.Nom, t2.AnnéeVente, t2.Vente
ORDER BY T2.AnnéeVente, t2.Nom) AS T3
GROUP BY  T3.Nom,t3.Etat
