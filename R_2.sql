SELECT T2.Numero_Equipement, T2.Nom_Equipement, AVG(Oberon_De_Bronze/T2.QuantiteEquipement) AS Prix_Moyen_en_Ob
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
ORDER BY T2.Numero_Equipement
