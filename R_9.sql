DELIMITER $$
CREATE PROCEDURE requete_neuf (IN artisan_id INT)
BEGIN
		SELECT SUBSTRING_INDEX(vente.DATE, ",", 1) AS `Date (Année)`, fabrique.ID_Artisan AS `ID de l'artisan`, SUM(vente.Quantite) AS `Quantité vendue par l'artisan`
		FROM vente
		LEFT JOIN fabrique ON vente.ID = fabrique.ID
		WHERE fabrique.ID_Artisan = artisan_id
		GROUP BY fabrique.ID_Artisan, SUBSTRING_INDEX(vente.DATE, ",", 1);
END $$
