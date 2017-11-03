-- Ajout de quelques utilisateurs
INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  1,
  'john',
  'john@example.com',
  '$2a$12$rk37Q34TKIqlMFVV.FBwJOREztNbGrsBdwT0n83RBOUc.xbbt/QHe',
  'John Doe',
  'Strasbourg'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  2,
  'jane',
  'jane@example.com',
  '$2a$04$8JVd1X2Z0i/OvQoFysyUEOCEpNL676G6QdIOOaiNUxqWaiNZ3MXV2',
  'Jane Doe',
  'Strasbourg'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  3,
  'kikoudu67',
  'cestmoilekikouudu67@hotmail.fr',
  '$2a$04$3Ey1sQ0p4jFYJOrqlW/DteB1.ecjzi2arvF.sp/cKIxiPhO54cjRq',
  'Le Kikoooouuu du 67 wesh',
  'Paris, France'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  4,
  'imabanana',
  'imabanana@example.com',
  '$2a$04$ju9O2AASGTp0vItnOiZOaesvlDgSciBSZ8..YuDA2cOarlZBxVj4.',
  'I''m a banana',
  'Banana City, BananaLand'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  5,
  'unicorn',
  'rainbow@example.com',
  '$2a$04$Ft6Q8BxhrbuX3WDeBhTIaOXqxrtNf1xjKn48rmhry/Mf4r1xuopym',
  'Unicorns lover <3',
  'PinkClouds'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  6,
  'john2',
  'john2@example.com',
  '$2a$04$eYZq2Ec3qgO09v4Kq6.qN.UQCiVfPHgVsSUF8jgF6HNkUf7y5pfyW',
  'John Doe Doe #Dodo :D',
  'Strasbourg'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  7,
  'cuisto2000',
  'jonnycuisto@example.com',
  '$2a$04$pIw7aTHL1AUbwXCd9IJvFOLBogwPrzoDsIFJHJuwuaruhfTB8xwfq',
  'Jonny le cuisto''',
  'Cuisinella hahaha'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  8,
  'jamescook',
  'explorer-not-ie@example.com',
  '$2a$04$pmYa9hhtlmkJyrQszaxSFOVlzMfqdX4oANtViNhumrbSGlgHwTmeO',
  'James Cook',
  'Bateau d''explorateur'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  9,
  'sweetcookie',
  'sweetcookie@example.com',
  '$2a$04$rnFs3JkAUzCVamT5vyyoJO3gYhGTbccegIFePOBMlolqRN4g9raX2',
  'Sweet cookie',
  'Strasbourg'
);

INSERT INTO "users" (
  "id",
  "pseudo",
  "mail",
  "password",
  "display_name",
  "localisation"
) VALUES (
  10,
  'hungry123',
  'hungry42@example.com',
  '$2a$12$susEYDVridobNuvpaimlheByCaQv6ut9BKDp30e1J2Z9sQHL1T9LS',
  'I''M HUNGRYYY !!!',
  NULL
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


-- Création des régimes
INSERT INTO "regime" (
  "id",
  "nom"
) VALUES (
  1,
  'Sans gluten'
);

INSERT INTO "regime" (
  "id",
  "nom"
) VALUES (
  2,
  'Végétarien'
);


-- Insertion de quelques ingrédients
INSERT INTO "ingredients" (
  "id",
  "nom",
  "auteur",
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
  8,
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
  "auteur",
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
  8,
  0,
  0,
  0,
  0,
  0,
  3,
  1,
  32
);


-- On créer les catégories d'ingrédients et on les range
INSERT INTO "categories_ingredients" (
  "id",
  "nom"
) VALUES (
  1,
  'Eau'
);

INSERT INTO "categories_ingredients" (
  "id",
  "nom"
) VALUES (
  2,
  'Une autre catégorie'
);

INSERT INTO "ingredients_categories" (
  "ingredient",
  "categorie"
) VALUES (
  1,
  1
);

INSERT INTO "ingredients_categories" (
  "ingredient",
  "categorie"
) VALUES (
  2,
  1
);

INSERT INTO "ingredients_categories" (
  "ingredient",
  "categorie"
) VALUES (
  2,
  2
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
  2,
  'Un truc super calorique',
  'Les calories, c''est chouette !',
  2,
  3,
  3,
  4,
  20,
  123456,
  1452,
  412,
  411,
  42
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


-- Définition de quelques types d'étapes
INSERT INTO "etape_types" (
  "id",
  "nom"
) VALUES (
  1,
  'Préparation'
);

INSERT INTO "etape_types" (
  "id",
  "nom"
) VALUES (
  2,
  'Cuisson'
);

INSERT INTO "etape_types" (
  "id",
  "nom"
) VALUES (
  3,
  'Dégustation'
);


-- Et voici quelques étapes de recettes
INSERT INTO "etapes" (
  "id",
  "recette",
  "type",
  "nom",
  "description",
  "duree",
  "ordre"
) VALUES (
  1,
  1,
  1,
  'Prenez le bocal d''eau en poudre',
  NULL,
  0,
  1
);

INSERT INTO "etapes" (
  "id",
  "recette",
  "type",
  "nom",
  "description",
  "duree",
  "ordre"
) VALUES (
  2,
  1,
  1,
  'Prenez une petite cuillère dans votre main préférée',
  NULL,
  0,
  2
);

INSERT INTO "etapes" (
  "id",
  "recette",
  "type",
  "nom",
  "description",
  "duree",
  "ordre"
) VALUES (
  3,
  1,
  1,
  'Versez 2 cuillères d''eau en poudre dans un verre',
  NULL,
  0,
  3
);

INSERT INTO "etapes" (
  "id",
  "recette",
  "type",
  "nom",
  "description",
  "duree",
  "ordre"
) VALUES (
  4,
  1,
  3,
  'Buvez et savourez cette eau de qualité ! ;p',
  NULL,
  0,
  5
);

INSERT INTO "etapes" (
  "id",
  "recette",
  "type",
  "nom",
  "description",
  "duree",
  "ordre"
) VALUES (
  5,
  1,
  1,
  'Versez de l''eau et mélangez bien, c''est très important !',
  'Prenez l''eau, et versez la sur votre eau en poudre. Prenez ensuite une cuillère et mélangez bien jusqu''à ce que la poudre soit complètement dilluée.',
  0,
  4
);


-- On ajoute des recettes dans les plannings d'utilisateurs
INSERT INTO "planning" (
  "recette",
  "user",
  "at"
) VALUES (
  1,
  2,
  TO_DATE('2017/11/20 8:30', 'YYYY/MM/DD HH24:MI')
);

INSERT INTO "planning" (
  "recette",
  "user",
  "at"
) VALUES (
  1,
  2,
  TO_DATE('2017/11/20 18:30', 'YYYY/MM/DD HH24:MI')
);

INSERT INTO "planning" (
  "recette",
  "user",
  "at"
) VALUES (
  2,
  2,
  TO_DATE('2017/11/21 11:30', 'YYYY/MM/DD HH24:MI')
);

INSERT INTO "planning" (
  "recette",
  "user",
  "at"
) VALUES (
  1,
  4,
  TO_DATE('2017/11/20 12:00', 'YYYY/MM/DD HH24:MI')
);

-- - Jus d'arc en ciel de licorne
-- - Steak de porc végétarien
-- - Pattes de lapin sans gluten et sans chance
