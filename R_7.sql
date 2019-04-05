DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Rq7`(
    IN `p_quantite` INT(20),
    IN `p_date` VARCHAR(50),
    IN `p_typeequipement` VARCHAR(50),
    IN `p_divinite` VARCHAR(50),
    IN `p_pouvoir` VARCHAR(50),
    IN `p_lieu` VARCHAR(50),
    IN `p_demidieu` VARCHAR(50),
    IN `p_decoration` VARCHAR(50),
    IN `p_oberonOr` INT(11),
    IN `p_oberonArgent` INT(11),
    IN `p_oberonFer` INT(11),
    IN `p_artisan` VARCHAR(50)



)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
START TRANSACTION;
    SELECT Decoration.ID AS ID_decoration FROM Decoration WHERE Denomination = p_decoration;

    INSERT INTO vente(Quantite, `Date`, ID_TypeEquipement, ID_Divinite, ID_Pouvoir, ID_Lieu, ID_DemiDieu) 
    VALUES(
        p_quantite,
        p_date,
        (SELECT TypeEquipement.ID AS ID_typeequipement FROM TypeEquipement WHERE Denomination = p_typeequipement),
        (SELECT Divinite.ID AS ID_divinite FROM Divinite WHERE Nom = p_divinite),
        (SELECT Pouvoir.ID AS ID_pouvoir FROM Pouvoir WHERE Denomination = p_pouvoir),
        (SELECT Lieu.ID AS ID_lieu FROM Lieu WHERE Nom = p_lieu),
        (SELECT DemiDieu.ID AS ID_demidieu FROM DemiDieu WHERE Nom = p_demidieu) );
      INSERT INTO possede(ID, ID_Decoration) VALUES(
        (SELECT LAST_INSERT_ID()), 
        (SELECT ID FROM decoration WHERE Denomination = p_decoration));
    
    INSERT INTO rapporte(ID, ID_Oberon, Quantite) VALUES(
        (SELECT LAST_INSERT_ID()),
        (SELECT ID FROM oberon WHERE Denomination = 'Or'),
        p_oberonOr);
        
    INSERT INTO rapporte(ID, ID_Oberon, Quantite) VALUES(
        (SELECT LAST_INSERT_ID()),
         (SELECT ID FROM oberon WHERE Denomination = 'Argent'),
         p_oberonArgent);
        
    INSERT INTO rapporte(ID, ID_Oberon, Quantite) VALUES(
        (SELECT LAST_INSERT_ID()),
        (SELECT ID FROM oberon WHERE Denomination = 'Fer'),
        p_oberonFer);
    
    INSERT INTO fabrique(ID, ID_Artisan) VALUES(
        (SELECT LAST_INSERT_ID()),
        (SELECT ID FROM Artisan WHERE Nom = p_artisan));
        
        COMMIT;

END$$
