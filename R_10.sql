CREATE TEMPORARY TABLE T1
SELECT rapporte.ID, SUM((rapporte.Quantite * oberon.CoefficientDeConversion)/vente.Quantite) AS O_Bronze
FROM rapporte
LEFT JOIN oberon ON rapporte.ID_Oberon = oberon.ID
LEFT JOIN vente ON rapporte.ID = vente.ID
GROUP BY rapporte.ID;

CREATE TEMPORARY TABLE T2
SELECT vente.ID, T1.O_Bronze, vente.ID_Divinite, fabrique.ID_Artisan
FROM T1
INNER JOIN vente ON T1.ID = vente.ID
INNER JOIN fabrique ON fabrique.ID = T1.ID
WHERE vente.ID_Divinite IS NOT NULL AND fabrique.ID_Artisan IS NOT NULL;

CREATE TEMPORARY TABLE T3
SELECT ID_Artisan, artisan.Nom AS Artisans, ID_divinite, divinite.Nom AS Divinités, ROUND(AVG(T2.O_Bronze)) AS `Prix moyen des ventes de l'artisan`
FROM T2
INNER JOIN artisan ON T2.ID_artisan = artisan.ID
INNER JOIN divinite ON T2.ID_divinite = divinite.ID
GROUP BY T2.ID_Artisan;

SELECT Artisans AS `Nom de l'artisan`, Divinités AS `Divinité la plus rentable pour l'artisan`, `Prix moyen des ventes de l'artisan` FROM T3 ORDER BY `Prix moyen des ventes de l'artisan` DESC;

DROP TABLE T1, T2, T3; 
