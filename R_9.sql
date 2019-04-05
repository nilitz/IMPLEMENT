DELIMITER $$
CREATE PROCEDURE requete_neuf (IN artisan_id INT)
BEGIN
		SELECT SUBSTRING_INDEX(vente.DATE, ",", 1) AS date_actuelle, fabrique.ID_Artisan AS `artisan`, SUM(vente.Quantite) AS quantite
		FROM vente
		LEFT JOIN fabrique ON vente.ID = fabrique.ID
		WHERE fabrique.ID_Artisan = artisan_id
		GROUP BY fabrique.ID_Artisan, SUBSTRING_INDEX(vente.DATE, ",", 1);
END $$
