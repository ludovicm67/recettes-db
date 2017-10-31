-- Ajout de quelques utilisateurs
INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  1,
  'john',
  'john@example.com',
  '$2a$12$rk37Q34TKIqlMFVV.FBwJOREztNbGrsBdwT0n83RBOUc.xbbt/QHe',
  'John Doe'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  2,
  'jane',
  'jane@example.com',
  '$2a$04$8JVd1X2Z0i/OvQoFysyUEOCEpNL676G6QdIOOaiNUxqWaiNZ3MXV2',
  'Jane Doe'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  3,
  'kikoudu67',
  'cestmoilekikouudu67@hotmail.fr',
  '$2a$04$3Ey1sQ0p4jFYJOrqlW/DteB1.ecjzi2arvF.sp/cKIxiPhO54cjRq',
  'Le Kikoooouuu du 67 wesh'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  4,
  'imabanana',
  'imabanana@example.com',
  '$2a$04$ju9O2AASGTp0vItnOiZOaesvlDgSciBSZ8..YuDA2cOarlZBxVj4.',
  'I''m a banana'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  5,
  'unicorn',
  'rainbow@example.com',
  '$2a$04$Ft6Q8BxhrbuX3WDeBhTIaOXqxrtNf1xjKn48rmhry/Mf4r1xuopym',
  'Unicorns lover <3'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  6,
  'john2',
  'john2@example.com',
  '$2a$04$eYZq2Ec3qgO09v4Kq6.qN.UQCiVfPHgVsSUF8jgF6HNkUf7y5pfyW',
  'John Doe Doe #Dodo :D'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  7,
  'cuisto2000',
  'jonnycuisto@example.com',
  '$2a$04$pIw7aTHL1AUbwXCd9IJvFOLBogwPrzoDsIFJHJuwuaruhfTB8xwfq',
  'Jonny le cuisto'''
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  8,
  'jamescook',
  'explorer-not-ie@example.com',
  '$2a$04$pmYa9hhtlmkJyrQszaxSFOVlzMfqdX4oANtViNhumrbSGlgHwTmeO',
  'James Cook'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  9,
  'sweetcookie',
  'sweetcookie@example.com',
  '$2a$04$rnFs3JkAUzCVamT5vyyoJO3gYhGTbccegIFePOBMlolqRN4g9raX2',
  'Sweet cookie'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name"
) VALUES (
  10,
  'hungry123',
  'hungry42@example.com',
  '$2a$12$susEYDVridobNuvpaimlheByCaQv6ut9BKDp30e1J2Z9sQHL1T9LS',
  'I''M HUNGRYYY !!!'
);


-- On ajoute les unités de base
INSERT INTO "unites" (
  "id",
  "nom",
  "symbol"
) VALUES (
  1,
  'Sans unité',
  NULL
);

INSERT INTO "unites" (
  "id",
  "nom",
  "symbol"
) VALUES (
  2,
  'Gramme',
  'g'
);

INSERT INTO "unites" (
  "id",
  "nom",
  "symbol"
) VALUES (
  3,
  'Litre',
  'L'
);

INSERT INTO "unites" (
  "id",
  "nom",
  "symbol"
) VALUES (
  4,
  'Cuillère à café (tea spoon)',
  'tsp'
);



-- Insertion de quelques ingrédients
INSERT INTO "ingredients" (
  "id",
  "nom",
  "calories",
  "lipides",
  "glucides",
  "glucides_dont_sucres",
  "protides",
  "unite",
  "dispo_par_defaut",
  "popularite"
) VALUES (
  1,
  'Eau en poudre',
  0,
  0,
  0,
  0,
  0,
  4,
  0,
  5
);

INSERT INTO "ingredients" (
  "id",
  "nom",
  "calories",
  "lipides",
  "glucides",
  "glucides_dont_sucres",
  "protides",
  "unite",
  "dispo_par_defaut",
  "popularite"
) VALUES (
  2,
  'Eau',
  0,
  0,
  0,
  0,
  0,
  3,
  1,
  32
);


-- Insertion de quelques recettes sympathiques
INSERT INTO "recettes" (
  "id",
  "nom",
  "description",
  "auteur",
  "difficulte",
  "prix",
  "nbre_personnes",
  "duree_totale",
  "calories",
  "lipides",
  "glucides",
  "glucides_dont_sucres",
  "protides"
) VALUES (
  1,
  'Eau en poudre',
  'Magnifique recette d''eau en poudre. Une recette à zéro calories ! Bon pour la santé tousa toussa !!',
  1,
  1,
  1,
  1,
  1,
  0,
  0,
  0,
  0,
  0
);

-- On indique les ingrédients utilisés par les recettes
INSERT INTO "ingredients_recette" (
  "recette",
  "ingredient",
  "quantite"
) VALUES (
  1,
  1,
  2
);

INSERT INTO "ingredients_recette" (
  "recette",
  "ingredient",
  "quantite"
) VALUES (
  1,
  2,
  0.02
);



-- Les recettes qui ont moins de 200 calories par personne
SELECT "id", "nom"
  FROM "recettes"
  WHERE "calories" / "nbre_personnes" < 200;
