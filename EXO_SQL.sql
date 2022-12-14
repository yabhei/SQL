-- 1)
SELECT nom_lieu 
FROM lieu
WHERE nom_lieu LIKE '%um';

----------------------------------------
-- 2)
SELECT  nom_lieu ,COUNT(nom_lieu) AS number_personnage
FROM lieu
INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu
GROUP BY nom_lieu
ORDER BY number_personnage DESC;

----------------------------------------
-- 3)
--triés par lieu :

SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage 
INNER JOIN specialite ON specialite.id_specialite= personnage.id_specialite
INNER JOIN lieu ON lieu.id_lieu= personnage.id_lieu
ORDER BY nom_lieu ;

--triés par nom de personnage :

SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage 
INNER JOIN specialite ON specialite.id_specialite= personnage.id_specialite
INNER JOIN lieu ON lieu.id_lieu= personnage.id_lieu
ORDER BY nom_personnage;

----------------------------------------
--4)
SELECT  nom_specialite ,COUNT(nom_specialite) AS number_personnage
FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY nom_specialite
ORDER BY number_personnage DESC;

----------------------------------------
--5)
SELECT  nom_bataille,DATE_FORMAT(date_bataille, "%d/%m/%Y") AS date,nom_lieu
FROM bataille
INNER JOIN lieu ON lieu.id_lieu = bataille.id_lieu
ORDER BY date_bataille DESC;

----------------------------------------
--6)
SELECT nom_potion, SUM(cout_ingredient*qte) AS coût_de_réalisation
FROM composer
INNER JOIN ingredient ON ingredient.id_ingredient=composer.id_ingredient
INNER JOIN potion ON potion.id_potion= composer.id_potion
GROUP BY nom_potion
ORDER BY coût_de_réalisation DESC;

----------------------------------------
--7)
SELECT nom_ingredient, cout_ingredient, qte
FROM composer
INNER JOIN ingredient ON composer.id_ingredient=ingredient.id_ingredient
INNER JOIN potion ON composer.id_potion=potion.id_potion
WHERE nom_potion = 'Santé';

----------------------------------------
--8)
-- SELECT nom_personnage, MAX(qte) AS le_plus_de_casques
-- FROM prendre_casque 
-- INNER JOIN  personnage ON prendre_casque.id_personnage = personnage.id_personnage
-- INNER JOIN  bataille ON prendre_casque.id_bataille = bataille.id_bataille
-- INNER JOIN  casque ON prendre_casque.id_casque = casque.id_casque
-- WHERE nom_bataille = 'Bataille du village gaulois'
-- GROUP BY nom_personnage;
SELECT p.nom_personnage, SUM(pc.qte) AS nb_casques
FROM prendre_casque pc 
INNER JOIN personnage p ON p.id_personnage = pc.id_personnage 
INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
WHERE b.nom_bataille = 'Bataille du village gaulois'
GROUP BY p.id_personnage 
HAVING nb_casques >= ALL(
            SELECT SUM(pc.qte)
            FROM prendre_casque pc
            INNER JOIN bataille b ON b.id_bataille = pc.id_bataille 
            WHERE b.nom_bataille = 'Bataille du village gaulois'
            GROUP BY pc.id_personnage

)

----------------------------------------
--10)
SELECT b.nom_bataille, SUM(pc.qte) AS nb_casques
FROM prendre_casque pc 
INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
GROUP BY b.id_bataille
HAVING nb_casques >= ALL(
        SELECT SUM(pc.qte)
        FROM prendre_casque pc 
        INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
        GROUP BY b.id_bataille
)

----------------------------------------
--11)

SELECT tc.nom_type_casque, COUNT(c.nom_casque) AS nb_casques, SUM(c.cout_casque) AS cout_total
FROM casque c , type_casque tc
WHERE c.id_type_casque = tc.id_type_casque
GROUP BY tc.id_type_casque

----------------------------------------
--12)
SELECT nom_potion 
FROM potion p , ingredient i, composer c 
WHERE c.id_potion = p.id_potion 
AND c.id_ingredient = i.id_ingredient 
AND i.nom_ingredient = 'Poisson frais'

----------------------------------------
--13)
SELECT nom_lieu , COUNT(id_personnage) AS nb_habitants
FROM  personnage p 
INNER JOIN lieu l ON l.id_lieu = p.id_lieu
WHERE  nom_lieu != 'Village gaulois'
GROUP BY l.id_lieu
HAVING nb_habitants >= ALL(
        SELECT COUNT(id_personnage)
        FROM personnage p 
        INNER JOIN lieu l ON l.id_lieu = p.id_lieu 
        WHERE nom_lieu != 'Village gaulois'
        GROUP BY l.id_lieu
)

----------------------------------------
--14)

SELECT p.id_personnage, p.nom_personnage, SUM(b.dose_boire) AS total
FROM personnage p 
LEFT JOIN boire b ON p.id_personnage = b.id_personnage
GROUP BY p.id_personnage
HAVING total IS NULL;

-- ou

SELECT p.id_personnage, p.nom_personnage
FROM personnage p 
HAVING p.id_personnage NOT IN (
		SELECT b.id_personnage
		FROM boire b
		INNER JOIN personnage p ON b.id_personnage = p.id_personnage		
) 

----------------------------------------
--15)

SELECT p.nom_personnage, pt.nom_potion
FROM autoriser_boire ab
INNER JOIN personnage p ON p.id_personnage = ab.id_personnage
INNER JOIN potion pt ON pt.id_potion = ab.id_potion
WHERE pt.nom_potion != 'Potion V'



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


-- A)

INSERT INTO personnage  (nom_personnage,adresse_personnage,id_lieu,id_specialite)
VALUES ('Champdeblix', ' Hantassion de Rotomagus',6,12)

----------------------------------------
-- B)

INSERT INTO autoriser_boire(id_potion,id_personnage)
VALUES (7,12)

----------------------------------------
-- C)

DELETE FROM casque 
WHERE id_casque != ALL(
		SELECT id_casque 
		FROM prendre_casque 
)

----------------------------------------
-- D)

UPDATE personnage 
SET adresse_personnage = 'En prison' , id_lieu = 9
WHERE nom_personnage = 'Zérozérosix'

----------------------------------------
-- E)

DELETE FROM composer 
WHERE id_potion = 9 
AND id_ingredient = 19

----------------------------------------
-- F)

INSERT INTO prendre_casque (id_casque,id_personnage,id_bataille,qte)
VALUES (14,5,9,28)