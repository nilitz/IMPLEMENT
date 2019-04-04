SELECT lieu.Nom AS Nom_Lieux,divinite.nom AS Nom_Dieux
FROM
    (SELECT T0.ID AS ID_Lieu,vente.ID_Divinite AS ID_Divinite, COUNT(vente.ID_Divinite) AS Count
    FROM vente
    LEFT JOIN lieu ON vente.ID_Lieu=lieu.ID
    LEFT JOIN (SELECT * FROM lieu WHERE lieu.ID_Lieu IS NULL) AS T0 ON (lieu.ID_Lieu=T0.ID) OR (lieu.ID=T0.ID)
    WHERE vente.ID_Lieu IS NOT NULL
    GROUP BY T0.ID, vente.ID_Divinite
    ORDER BY T0.ID, COUNT(vente.ID_Divinite) DESC) AS T1
    LEFT JOIN lieu ON T1.ID_Lieu=lieu.ID
    LEFT JOIN divinite ON T1.ID_Divinite=divinite.ID
GROUP BY T1.ID_Lieu
