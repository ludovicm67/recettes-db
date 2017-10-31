-- Création de la table users
CREATE TABLE "users" (
	"id" int,
	"pseudo" varchar2(255),
	"mail" varchar2(255),
	"password" varchar2(255),
	"display_name" varchar2(255),
	CONSTRAINT USERS_PK PRIMARY KEY ("id")
);

-- Création de la table recettes
CREATE TABLE "recettes" (
	"id" int,
	"nom" varchar2(255),
	"description" CLOB,
	"auteur" int,
	"difficulte" int,
	"prix" int,
	"nbre_personnes" int,
	"duree_totale" int,
	"calories" int,
	"lipides" decimal,
	"glucides" decimal,
	"glucides_dont_sucres" decimal,
	"protides" decimal,
	CONSTRAINT RECETTES_PK PRIMARY KEY ("id")
);

-- Création de la table regime
CREATE TABLE "regime" (
	"id" int,
	"nom" varchar2(255),
	CONSTRAINT REGIME_PK PRIMARY KEY ("id")
);

-- Création de la table ingredients
CREATE TABLE "ingredients" (
	"id" int,
	"nom" varchar2(255),
	"calories" int,
	"lipides" decimal,
	"glucides" decimal,
	"glucides_dont_sucres" decimal,
	"protides" decimal,
	"unite" int,
	"dispo_par_defaut" number(1) DEFAULT 0,
	"popularite" int,
	CONSTRAINT INGREDIENTS_PK PRIMARY KEY ("id")
);

-- Création de la table unites
CREATE TABLE "unites" (
	"id" int,
	"nom" varchar2(100),
	"symbol" varchar2(10),
	CONSTRAINT UNITES_PK PRIMARY KEY ("id")
);

-- Création de la table categories_ingredients
CREATE TABLE "categories_ingredients" (
	"id" int,
	"nom" varchar2(120),
	CONSTRAINT CATEGORIES_INGR_PK PRIMARY KEY ("id")
);

-- Création de la table ingredients_interdits_regime
CREATE TABLE "ingredients_interdits_regime" (
	"regime" int,
	"ingredient" int,
	CONSTRAINT INGR_INTERDITS_REGIME_PK PRIMARY KEY ("regime","ingredient")
);

-- Création de la table ingredients_recette
CREATE TABLE "ingredients_recette" (
	"recette" int,
	"ingredient" int,
	"quantite" decimal,
	CONSTRAINT INGREDIENTS_RECETTE_PK PRIMARY KEY ("recette","ingredient")
);

-- Création de la table etape_types
CREATE TABLE "etape_types" (
	"id" int,
	"nom" varchar2(100),
	CONSTRAINT ETAPE_TYPES_PK PRIMARY KEY ("id")
);

-- Création de la table etapes
CREATE TABLE "etapes" (
	"id" int,
	"recette" int,
	"type" int,
	"nom" varchar2(255),
	"description" CLOB,
	"duree" int,
	"ordre" int,
	CONSTRAINT ETAPES_PK PRIMARY KEY ("id")
);

-- Création de la table medias
CREATE TABLE "medias" (
	"id" int,
	"recette" int,
	"type" int,
	"url" varchar2(255),
	CONSTRAINT MEDIAS_PK PRIMARY KEY ("id")
);

-- Création de la table media_types
CREATE TABLE "media_types" (
	"id" int,
	"nom" varchar2(100),
	"is_video" number(1) DEFAULT 0,
	CONSTRAINT MEDIA_TYPES_PK PRIMARY KEY ("id")
);

-- Création de la table ingredients_user
CREATE TABLE "ingredients_user" (
	"user" int,
	"ingredient" int,
	"quantite" decimal,
	CONSTRAINT INGREDIENTS_USER_PK PRIMARY KEY ("user","ingredient")
);

-- Création de la table planning
CREATE TABLE "planning" (
	"recette" int,
	"user" int,
	"at" date,
	CONSTRAINT PLANNING_PK PRIMARY KEY ("recette","user")
);

-- Création de la table planning_archive
CREATE TABLE "planning_archive" (
	"recette" int,
	"user" int,
	"at" date,
	CONSTRAINT PLANNING_ARCHIVE_PK PRIMARY KEY ("recette","user")
);

-- Création de la table user_achat_ingredients
CREATE TABLE "user_achat_ingredients" (
	"user" int,
	"ingredient" int,
	"quantite" decimal,
	"date" date,
	CONSTRAINT USER_ACHAT_INGR_PK PRIMARY KEY ("user","ingredient")
);

-- Création de la table user_achat_ingredients_archive
CREATE TABLE "user_achat_ingredients_archive" (
	"user" int,
	"ingredient" int,
	"quantite" decimal,
	"date" date,
	CONSTRAINT USER_ACHAT_INGR_ARCHIVE_PK PRIMARY KEY ("user","ingredient")
);

-- Création de la table user_regime
CREATE TABLE "user_regime" (
	"user" int,
	"regime" int,
	CONSTRAINT USER_REGIME_PK PRIMARY KEY ("user","regime")
);

-- Création de la table ingredients_categories
CREATE TABLE "ingredients_categories" (
	"ingredient" int,
	"categorie" int,
	CONSTRAINT INGREDIENTS_CATEGORIES_PK PRIMARY KEY ("ingredient","categorie")
);


-- On ajoute les contraintes sur les clés étrangères
ALTER TABLE "recettes"
	ADD CONSTRAINT "recettes_fk0"
	FOREIGN KEY ("auteur")
	REFERENCES "users" ("id");

ALTER TABLE "ingredients"
	ADD CONSTRAINT "ingr_fk0"
	FOREIGN KEY ("unite")
	REFERENCES "unites" ("id");

ALTER TABLE "ingredients_interdits_regime"
	ADD CONSTRAINT "ingr_interdits_regime_fk0"
	FOREIGN KEY ("regime")
	REFERENCES "regime" ("id");

ALTER TABLE "ingredients_interdits_regime"
	ADD CONSTRAINT "ingr_interdits_regime_fk1"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "ingredients_recette"
	ADD CONSTRAINT "ingr_recette_fk0"
	FOREIGN KEY ("recette")
	REFERENCES "recettes" ("id");

ALTER TABLE "ingredients_recette"
	ADD CONSTRAINT "ingr_recette_fk1"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "etapes"
	ADD CONSTRAINT "etapes_fk0"
	FOREIGN KEY ("recette")
	REFERENCES "recettes" ("id");

ALTER TABLE "etapes"
	ADD CONSTRAINT "etapes_fk1"
	FOREIGN KEY ("type")
	REFERENCES "etape_types" ("id");

ALTER TABLE "medias"
	ADD CONSTRAINT "medias_fk0"
	FOREIGN KEY ("recette")
	REFERENCES "recettes" ("id");

ALTER TABLE "medias"
	ADD CONSTRAINT "medias_fk1"
	FOREIGN KEY ("type")
	REFERENCES "media_types" ("id");

ALTER TABLE "ingredients_user"
	ADD CONSTRAINT "ingr_user_fk0"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "ingredients_user"
	ADD CONSTRAINT "ingr_user_fk1"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "planning"
	ADD CONSTRAINT "planning_fk0"
	FOREIGN KEY ("recette")
	REFERENCES "recettes" ("id");

ALTER TABLE "planning"
	ADD CONSTRAINT "planning_fk1"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "planning_archive"
	ADD CONSTRAINT "planning_archive_fk0"
	FOREIGN KEY ("recette")
	REFERENCES "recettes" ("id");

ALTER TABLE "planning_archive"
	ADD CONSTRAINT "planning_archive_fk1"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "user_achat_ingredients"
	ADD CONSTRAINT "user_achat_ingr_fk0"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "user_achat_ingredients"
	ADD CONSTRAINT "user_achat_ingr_fk1"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "user_achat_ingredients_archive"
	ADD CONSTRAINT "user_achat_ingr_archive_fk0"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "user_achat_ingredients_archive"
	ADD CONSTRAINT "user_achat_ingr_archive_fk1"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "user_regime"
	ADD CONSTRAINT "user_regime_fk0"
	FOREIGN KEY ("user")
	REFERENCES "users" ("id");

ALTER TABLE "user_regime"
	ADD CONSTRAINT "user_regime_fk1"
	FOREIGN KEY ("regime")
	REFERENCES "regime" ("id");

ALTER TABLE "ingredients_categories"
	ADD CONSTRAINT "ingr_categories_fk0"
	FOREIGN KEY ("ingredient")
	REFERENCES "ingredients" ("id");

ALTER TABLE "ingredients_categories"
	ADD CONSTRAINT "ingr_categories_fk1"
	FOREIGN KEY ("categorie")
	REFERENCES "categories_ingredients" ("id");
