CREATE TEMPORARY TABLE t1
SELECT rapporte.ID, SUM(rapporte.Quantite*oberon.CoefficientDeConversion) AS ObelosDeBronze
FROM rapporte JOIN oberon ON (rapporte.ID_Oberon = oberon.ID)
GROUP BY rapporte.ID;

UPDATE t1, vente
SET t1.ObelosDeBronze = (t1.ObelosDeBronze / vente.quantite) WHERE vente.ID = t1.ID;

CREATE TEMPORARY TABLE t2
SELECT vente.ID, t1.ObelosDeBronze, vente.ID_Divinite, fabrique.ID_Artisan
FROM t1
INNER JOIN vente ON t1.ID = vente.ID
INNER JOIN fabrique ON fabrique.ID = t1.ID
WHERE vente.ID_Divinite IS NOT NULL AND fabrique.ID_Artisan IS NOT NULL;

CREATE TEMPORARY TABLE t3
SELECT ID_Artisan, ID_divinite, MAX(t2.ObelosDeBronze) AS Prixmaxi FROM t2 GROUP BY t2.ID_Artisan;

_____________________________________________________________________________________________________

SELECT rapporte.ID, ROUND(SUM((rapporte.Quantite * oberon.CoefficientDeConversion)/vente.Quantite))
FROM rapporte
LEFT JOIN oberon ON rapporte.ID_Oberon = oberon.ID
LEFT JOIN vente ON rapporte.ID = vente.ID
GROUP BY rapporte.ID
