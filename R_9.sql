SELECT T0.date_actuelle, T0.`artisan`, T0.quantite
FROM 
(
	SELECT (SUBSTRING_INDEX(vente.DATE, ",", 1)-1) AS date_posterieur, SUBSTRING_INDEX(vente.DATE, ",", 1) AS date_actuelle, fabrique.ID_Artisan AS `artisan`, SUM(vente.Quantite) AS quantite
	FROM vente
	LEFT JOIN fabrique ON vente.ID = fabrique.ID
	WHERE fabrique.ID_Artisan = '1'
	GROUP BY fabrique.ID_Artisan, SUBSTRING_INDEX(vente.DATE, ",", 1)
	
) AS T0
