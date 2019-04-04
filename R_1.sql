SELECT Nom AS Province, rt.Dieu
  FROM
     (
         SELECT Nom, 
                ID_Divinite,                 
                Compte, 
                T1.Dieu,
                @rank  := IF(nom = @prev_nom, @rank + 1 , 1) as rank,
                @prev_nom := nom as prev_nom

         FROM (
         SELECT T0.ID,vente.ID_Divinite, COUNT(vente.ID_Divinite) AS Compte, T0.Nom, divinite.Nom AS Dieu
           FROM vente
        LEFT JOIN lieu ON vente.ID_Lieu=lieu.ID
            LEFT JOIN (SELECT * FROM lieu WHERE lieu.ID_Lieu IS NULL) AS T0 ON (lieu.ID_Lieu=T0.ID) OR (lieu.ID=T0.ID)
            LEFT JOIN divinite ON Vente.ID_Divinite=divinite.ID
            WHERE vente.ID_Lieu IS NOT NULL
            GROUP BY T0.ID, vente.ID_Divinite 
            ORDER BY T0.ID, COUNT(vente.ID_Divinite) DESC
         ) AS T1
         ,(SELECT @rank := 0, @prev_nom := 0) r 
         ORDER BY nom ASC, compte DESC
           )  rt
     WHERE rank <= 5 AND Nom IS NOT NULL
  ORDER BY nom ASC, rank ASC
