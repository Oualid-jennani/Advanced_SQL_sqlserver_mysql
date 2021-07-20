-- 1 
-- Creer un d ́eclencheur qui apr`es l’insertion d’une personne dans la table PERSONNE, 
-- cree un lien d’amiti ́e entre elle et Elvia. 
-- V ́erifier que le d ́eclencheur marche en ins ́erant une nouvelle personne et en v ́erifiant qu’elle devient amie d’Elvia

CREATE TRIGGER R1
AFTER INSERT ON PERSONNE
FOR EACH ROW
INSERT INTO AMI VALUES (NEW.idPersonne, 1);

-- Vérification
INSERT INTO PERSONNE VALUES (17, 'Bonnie', 17);

INSERT INTO AMI VALUES (17, 1);


SELECT * FROM AMI WHERE idPersonne2 = 1

-- 2 
-- Creer un d ́eclencheur qui avant l’insertion d’une personne dans la table PERSONNE, 
-- v ́erifie que son nom n’existe pas. Si le nom existe, un message d’erreur est retourn ́e `a l’utilisateur.
-- Vérifier que le déclencheur est correct en insérant la ligne (18, 'Elvia', 28) dans la table PERSONNE.


DELIMITER $$
CREATE TRIGGER R2
BEFORE INSERT ON PERSONNE
FOR EACH ROW
IF exists(SELECT nomPersonne FROM PERSONNE WHERE nomPersonne =  NEW.nomPersonne) 
THEN	
	signal sqlstate '45000' set message_text = 'Tentative d''insertion d''un nom qui existe';
END IF;
$$ 
DELIMITER ;



-- Vérification
INSERT INTO PERSONNE VALUES (18, 'Elvia', 28);

SELECT 
    *
FROM
    PERSONNE;

-- 3
-- Créer un déclencheur qui après l'insertion de deux personnes
--  dans la table FAMILLE, crée un lien d'amitié entre ces deux
--  personnes. Si on insère la paire (x,y) dans la table FAMILLE, on
--  doit retrouver la paire (x,y) dans la table AMI.


DELIMITER $$
CREATE TRIGGER R31
AFTER INSERT ON FAMILLE
FOR EACH ROW
IF 
    (NOT EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            AMI
        WHERE
            idPersonne1 = NEW.idPersonne1
                AND idPersonne2 = NEW.idPersonne2))
AND
    (NOT EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            AMI
        WHERE
            idPersonne2 = NEW.idPersonne1
                AND idPersonne1 = NEW.idPersonne2))

THEN	
	INSERT INTO AMI VALUES (NEW.idPersonne1, NEW.idPersonne2);
END IF;
$$ 
DELIMITER ;

-- ou 

DELIMITER $$
CREATE TRIGGER R32
AFTER INSERT ON FAMILLE
FOR EACH ROW
IF 
((NEW.idPersonne1, NEW.idPersonne2) NOT IN (SELECT idPersonne1, idPersonne2 FROM AMI))
AND
((NEW.idPersonne1, NEW.idPersonne2) NOT IN (SELECT idPersonne2, idPersonne1 FROM AMI))

THEN	
	INSERT INTO AMI VALUES (NEW.idPersonne1, NEW.idPersonne2);
END IF;
$$ 
DELIMITER ;

-- Vérification
INSERT INTO FAMILLE VALUES (15,3);
SELECT 
    *
FROM
    AMI
WHERE
    idPersonne1 = 15;

-- 4 
-- Créer un déclencheur, qui avant l'insertion dans la table
--  FAMILLE d'une paire (x,y) vérifie que cette paire n'existe pas dans
--  la table FAMILLE, ni sous la forme (x,y) ni sous la forme (y,x). Si
--  la paire existe, elle n'est pas insérée et un message d'erreur est
--  retourné à l'utilisateur. 

DELIMITER $$
CREATE TRIGGER R4
BEFORE INSERT ON FAMILLE
FOR EACH ROW
IF 
    (EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            FAMILLE
        WHERE
            idPersonne1 = NEW.idPersonne1
                AND idPersonne2 = NEW.idPersonne2))
OR
    (EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            FAMILLE
        WHERE
            idPersonne2 = NEW.idPersonne1
                AND idPersonne1 = NEW.idPersonne2))

THEN	
	signal sqlstate '45000' 
		set message_text = 'Tentative d''insertion d''une paire de personnes dans FAMILLE qui existe.';

END IF;
$$ 
DELIMITER ;

-- Vérification
INSERT INTO FAMILLE VALUES (4,6);




-- 5
-- Créer un déclencheur qui supprime le lien d'amitié entre deux
--  personnes, si le lien de famille entre ces deux personnes est
--  supprimé. Si la paire (x,y) n'est plus dans FAMILLE, la paire est
--  automatiquement supprimée de AMI. 

DELIMITER $$
CREATE TRIGGER R5
AFTER DELETE ON FAMILLE
FOR EACH ROW BEGIN
IF 
    (EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            AMI
        WHERE
            idPersonne1 = OLD.idPersonne1
                AND idPersonne2 = OLD.idPersonne2))
THEN	
	DELETE FROM AMI 
	WHERE
		idPersonne1 = OLD.idPersonne1
		AND idPersonne2 = OLD.idPersonne2;

END IF;
IF 
    (EXISTS( SELECT 
            idPersonne1, idPersonne2
        FROM
            AMI
        WHERE
            idPersonne2 = OLD.idPersonne1
                AND idPersonne1 = OLD.idPersonne2))
THEN
	DELETE FROM AMI 
	WHERE
		idPersonne1 = OLD.idPersonne2
		AND idPersonne2 = OLD.idPersonne1;

END IF;
END;
$$ 
DELIMITER ;

-- Vérification

INSERT INTO FAMILLE VALUES (1,17);
INSERT INTO AMI VALUES (1,17);
DELETE FROM FAMILLE 
WHERE
    idPersonne1 = 1 AND idPersonne2 = 17;
SELECT 
    *
FROM
    AMI;

-- 6
-- Créer un déclencheur qui supprime toutes les références à une
-- personne dans la table FAMILLE et dans la table AMI si cette
-- personne est supprimée.


DELIMITER $$
CREATE TRIGGER R6
BEFORE DELETE ON PERSONNE
FOR EACH ROW BEGIN
IF exists(SELECT idPersonne1 FROM AMI WHERE idPersonne1 =  OLD.idPersonne) 
THEN	
DELETE FROM AMI WHERE idPersonne1 = OLD.idPersonne;
END IF;
IF exists(SELECT idPersonne2 FROM AMI WHERE idPersonne2 =  OLD.idPersonne) 
THEN	
DELETE FROM AMI WHERE idPersonne2 = OLD.idPersonne;
END IF;
IF exists(SELECT idPersonne1 FROM FAMILLE WHERE idPersonne1 =  OLD.idPersonne) 
THEN	
DELETE FROM FAMILLE WHERE idPersonne1 = OLD.idPersonne;
END IF;
IF exists(SELECT idPersonne2 FROM FAMILLE WHERE idPersonne2 =  OLD.idPersonne) 
THEN	
DELETE FROM FAMILLE WHERE idPersonne2 = OLD.idPersonne;
END IF;
END;
$$ 
DELIMITER ;

DELETE FROM PERSONNE WHERE idPersonne = 14;


-- Intégrité référentielle


-- 1 
-- Enlever toutes les clés étrangères de la table AMI
ALTER TABLE AMI DROP FOREIGN KEY ami_ibfk_1;
ALTER TABLE AMI DROP FOREIGN KEY ami_ibfk_2;

INSERT INTO AMI VALUES (20,30);
SELECT * FROM AMI;
DELETE FROM AMI WHERE idPersonne1 = 20;

-- 2
-- Créer un déclencheur qui implémente le comportement des clés
-- étrangères supprimées par la requête précédente. Si une paire
-- $(x,y)$ est insérée dans AMI, le déclencheur s'assure que $x$ et $y$
-- se trouvent dans PERSONNE.

DELIMITER $$
CREATE TRIGGER R7
BEFORE INSERT ON AMI
FOR EACH ROW
IF (NOT exists(SELECT idPersonne FROM PERSONNE WHERE idPersonne =  NEW.idPersonne1))
OR (NOT exists(SELECT idPersonne FROM PERSONNE WHERE idPersonne =  NEW.idPersonne2))
THEN	
	signal sqlstate '45000' 
		set message_text = 'Tentative d''insertion d''une personne qui n''existe pas.';
END IF;
$$ 
DELIMITER ;


-- 3
-- Créer un déclencheur qui implémente la cascade des mises à
-- jour à partir de la table PERSONNE vers la table AMI. Si
--  l'identifiant d'une personne $x$ change et qu'elle existe dans la
--  table AMI, son identifiant est automatiquement mis à jour.
DROP TRIGGER IF EXISTS R8;

DELIMITER $$
CREATE TRIGGER R8
AFTER UPDATE ON PERSONNE
FOR EACH ROW
IF (exists(SELECT idPersonne1, idPersonne2 FROM AMI 
WHERE idPersonne1 =  OLD.idPersonne OR idPersonne2 = OLD.idPersonne))
THEN	
	UPDATE AMI SET idPersonne1 = NEW.idPersonne WHERE idPersonne1 = OLD.idPersonne;
	UPDATE AMI SET idPersonne2 = NEW.idPersonne WHERE idPersonne2 = OLD.idPersonne;
END IF;
$$ 
DELIMITER ;

-- Verification
UPDATE PERSONNE SET idPersonne = 20 WHERE idPersonne = 16;

SELECT * FROM AMI;

-- 4
-- Créer un déclencheur qui implémente la cascade des suppressions
-- à partir de la table PERSONNE vers la table AMI. Si
-- l'identifiant d'une personne $x$ change et qu'elle existe dans la
-- table AMI, son identifiant est automatiquement mis à jour.

DELIMITER $$
CREATE TRIGGER R9
AFTER DELETE ON PERSONNE
FOR EACH ROW
IF (exists(SELECT idPersonne1, idPersonne2 FROM AMI 
WHERE idPersonne1 =  OLD.idPersonne OR idPersonne2 = OLD.idPersonne))
THEN	
	DELETE FROM AMI WHERE idPersonne1 = OLD.idPersonne;
	DELETE FROM AMI WHERE idPersonne2 = OLD.idPersonne;
END IF;
$$ 
DELIMITER ;

-- Verification
DELETE FROM PERSONNE WHERE idPersonne = 20;

SELECT * FROM AMI;

