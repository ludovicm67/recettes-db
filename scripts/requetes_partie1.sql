-- Les recettes qui ont moins de 200 calories par personne
-- dont tous les ingrédients sont sans gluten
-- et qui apparaissent sur le planning d'un utilisateur
-- (interprétation : il existe au moins un planning dans lequel se trouve la recette)
SELECT "id", "nom"
  FROM "recettes" r
  WHERE "calories" / "nbre_personnes" < 200
    AND r."id" NOT IN (
      SELECT "id"
        FROM "recettes"
        WHERE "id" IN (
          SELECT "recette"
            FROM "ingredients_recette"
            WHERE "ingredient" IN (
              SELECT iir."ingredient"
                FROM "regime" r, "ingredients_interdits_regime" iir
                WHERE r."id" = iir."regime" AND r."nom" = 'Sans gluten'
            )
        )
    )
    AND r."id" IN (
      SELECT DISTINCT "recette"
      FROM "planning"
      WHERE "recette" = r."id"
    );


-- La recette la plus présente dans un planning d'un utilisateur
-- (interprétation : recette la plus ajoutée à un planning)
SELECT "nom"
  FROM "recettes"
  WHERE "id" IN (
    SELECT "recette"
      FROM "planning"
      HAVING COUNT("recette") = (
        SELECT MAX(COUNT("recette"))
          FROM "planning"
          GROUP BY "recette"
      )
      GROUP BY "recette"
  );

-- La recette la plus présente dans un planning d'un utilisateur
-- (interprétation : recette la plus ajoutée à un planning pour chaque utilisateur)
SELECT u."pseudo", r."nom"
  FROM "planning" p, "users" u, "recettes" r
  WHERE p."user" = u."id" AND p."recette" = r."id"
  HAVING COUNT(r."nom") = (
    SELECT MAX(COUNT(r2."id"))
      FROM "planning" p2, "users" u2, "recettes" r2
      WHERE p2."user" = u2."id" AND p2."recette" = r2."id" AND u2."pseudo" = u."pseudo"
      GROUP BY r2."id"
  )
  GROUP BY u."pseudo", r."nom";


-- Pour chaque ingrédient, nombre de recette et nombre de catégorie dans lesquelles il apparaît
SELECT i."nom",
    COUNT(DISTINCT ir."recette") AS "nb_recettes",
    COUNT(DISTINCT ic."categorie") AS "nb_categories"
  FROM "ingredients" i, "ingredients_recette" ir, "ingredients_categories" ic
  WHERE i."id" = ir."ingredient" AND i."id" = ic."ingredient"
  GROUP BY i."nom";


-- Les utilisateurs qui n'ont ajouté que des recettes végétariennes
SELECT u."pseudo"
  FROM "users" u, "recettes" r
  WHERE u."id" = r."auteur" AND r."auteur" NOT IN (
    SELECT "auteur"
      FROM "recettes"
      WHERE "id" IN (
        SELECT "recette"
          FROM "ingredients_recette"
          WHERE "ingredient" IN (
            SELECT iir."ingredient"
              FROM "regime" r, "ingredients_interdits_regime" iir
              WHERE r."id" = iir."regime" AND r."nom" = 'Végétarien'
          )
      )
  );


-- Pour chaque utilisateur, son login, son nom, son adresse, son nombre de
-- recette créé, son nombre d'ingrédients enregistrés, le nombre de recettes
-- qu'il a prévu de réaliser (ici les requêtes imbriquées offrent une lisibilité
-- sans égal)
SELECT
  "pseudo",
  "display_name" AS "nom / prénom",
  "localisation" AS "adresse",
  (SELECT COUNT("id")
    FROM "recettes"
    WHERE "auteur" = "users"."id") AS "nb recettes créées",
  (SELECT COUNT("id")
    FROM "ingredients"
    WHERE "auteur" = "users"."id") AS "nb ingrédients créées",
  (SELECT COUNT(*)
    FROM "ingredients_user"
    WHERE "user" = "users"."id") AS "nb ingrédients chez lui",
  (SELECT COUNT(*)
    FROM "planning"
    WHERE "user" = "users"."id" AND "at" >= SYSDATE) AS "nb recettes prévu de réaliser"
  FROM "users";







--
-- BONUS
--

-- Les étapes d'une recette
SELECT "nom", "description", CONCAT("duree", ' min') AS "duree"
  FROM "etapes"
  WHERE "recette" = 1
  ORDER BY "ordre";

-- Ingrédients végétariens
SELECT *
  FROM "ingredients"
  WHERE "id" NOT IN (
    SELECT iir."ingredient"
      FROM "regime" r, "ingredients_interdits_regime" iir
      WHERE r."id" = iir."regime" AND r."nom" = 'Végétarien'
  );

-- Ingrédients sans gluten
SELECT *
  FROM "ingredients"
  WHERE "id" NOT IN (
    SELECT iir."ingredient"
      FROM "regime" r, "ingredients_interdits_regime" iir
      WHERE r."id" = iir."regime" AND r."nom" = 'Sans gluten'
  );
