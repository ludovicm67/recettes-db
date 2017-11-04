-- Création de la table users
CREATE TABLE "users" (
	"id" int NOT NULL,
	"pseudo" varchar2(25) NOT NULL,
	"mail" varchar2(255) NOT NULL,
	"password" varchar2(255) NOT NULL,
	"display_name" varchar2(255),
	"localisation" varchar2(255),
	CONSTRAINT USERS_PK PRIMARY KEY ("id"),
	CONSTRAINT USERS_U UNIQUE ("pseudo", "mail"),
	CONSTRAINT USERS_MAIL_CK CHECK ("mail" LIKE '%_@_%')
);

-- Création de la table recettes
CREATE TABLE "recettes" (
	"id" int NOT NULL,
	"nom" varchar2(255) NOT NULL,
	"description" CLOB,
	"auteur" int NOT NULL,
	"difficulte" int NOT NULL,
	"prix" int NOT NULL,
	"nbre_personnes" int NOT NULL,
	"duree_totale" int NOT NULL,
	"calories" int NOT NULL,
	"lipides" numeric(5, 5) NOT NULL,
	"glucides" numeric(5, 5) NOT NULL,
	"glucides_dont_sucres" numeric(5, 5) NOT NULL,
	"protides" numeric(5, 5) NOT NULL,
	CONSTRAINT RECETTES_PK PRIMARY KEY ("id"),
	CONSTRAINT RECETTES_DIFF_CK CHECK ("difficulte" BETWEEN 1 AND 5),
	CONSTRAINT RECETTES_PRIX_CK CHECK ("prix" BETWEEN 1 AND 5),
	CONSTRAINT RECETTES_NBPERS_CK CHECK ("nbre_personnes" > 0),
	CONSTRAINT RECETTES_DUREE_CK CHECK ("duree_totale" > 0),
	CONSTRAINT RECETTES_CAL_CK CHECK ("calories" >= 0),
	CONSTRAINT RECETTES_LIP_CK CHECK ("lipides" >= 0),
	CONSTRAINT RECETTES_GLU_CK CHECK ("glucides" >= 0),
	CONSTRAINT RECETTES_SUCRES_CK CHECK (
		"glucides_dont_sucres" >= 0
		AND "glucides_dont_sucres" <= "glucides"
	),
	CONSTRAINT RECETTES_PRO_CK CHECK ("protides" >= 0)
);

-- Création de la table regime
CREATE TABLE "regime" (
	"id" int NOT NULL,
	"nom" varchar2(255) NOT NULL,
	CONSTRAINT REGIME_PK PRIMARY KEY ("id"),
	CONSTRAINT REGIME_U UNIQUE ("nom")
);

-- Création de la table ingredients
CREATE TABLE "ingredients" (
	"id" int NOT NULL,
	"nom" varchar2(255) NOT NULL,
	"auteur" int NOT NULL,
	"calories" int NOT NULL,
	"lipides" numeric(5, 5) NOT NULL,
	"glucides" numeric(5, 5) NOT NULL,
	"glucides_dont_sucres" numeric(5, 5) NOT NULL,
	"protides" numeric(5, 5) NOT NULL,
	"unite" int NOT NULL,
	"dispo_par_defaut" number(1) DEFAULT 0 NOT NULL,
	"popularite" int NOT NULL,
	CONSTRAINT INGREDIENTS_PK PRIMARY KEY ("id"),
	CONSTRAINT INGREDIENTS_U UNIQUE ("nom"),
	CONSTRAINT INGR_CAL_CK CHECK ("calories" >= 0),
	CONSTRAINT INGR_LIP_CK CHECK ("lipides" >= 0),
	CONSTRAINT INGR_GLU_CK CHECK ("glucides" >= 0),
	CONSTRAINT INGR_SUCRES_CK CHECK (
		"glucides_dont_sucres" >= 0
		AND "glucides_dont_sucres" <= "glucides"
	),
	CONSTRAINT INGR_PRO_CK CHECK ("protides" >= 0),
	CONSTRAINT INGR_POP_CK CHECK ("popularite" >= 0)
);

-- Création de la table unites
CREATE TABLE "unites" (
	"id" int NOT NULL,
	"nom" varchar2(100) NOT NULL,
	"symbol" varchar2(10),
	CONSTRAINT UNITES_PK PRIMARY KEY ("id"),
	CONSTRAINT UNITES_U UNIQUE ("nom", "symbol")
);

-- Création de la table categories_ingredients
CREATE TABLE "categories_ingredients" (
	"id" int NOT NULL,
	"nom" varchar2(120) NOT NULL,
	CONSTRAINT CATEGORIES_INGR_PK PRIMARY KEY ("id"),
	CONSTRAINT CATEGORIES_INGR_U UNIQUE ("nom")
);

-- Création de la table ingredients_interdits_regime
CREATE TABLE "ingredients_interdits_regime" (
	"regime" int NOT NULL,
	"ingredient" int NOT NULL,
	CONSTRAINT INGR_INTERDITS_REGIME_PK PRIMARY KEY ("regime","ingredient")
);

-- Création de la table ingredients_recette
CREATE TABLE "ingredients_recette" (
	"recette" int NOT NULL,
	"ingredient" int NOT NULL,
	"quantite" numeric(5, 5) NOT NULL,
	CONSTRAINT INGREDIENTS_RECETTE_PK PRIMARY KEY ("recette","ingredient"),
	CONSTRAINT INGRRECET_QTE_CK CHECK ("quantite" >= 0)
);

-- Création de la table etape_types
CREATE TABLE "etape_types" (
	"id" int NOT NULL,
	"nom" varchar2(100) NOT NULL,
	CONSTRAINT ETAPE_TYPES_PK PRIMARY KEY ("id"),
	CONSTRAINT ETAPE_TYPES_U UNIQUE ("nom")
);

-- Création de la table etapes
CREATE TABLE "etapes" (
	"id" int NOT NULL,
	"recette" int NOT NULL,
	"type" int NOT NULL,
	"nom" varchar2(255) NOT NULL,
	"description" CLOB,
	"duree" int NOT NULL,
	"ordre" int NOT NULL,
	CONSTRAINT ETAPES_PK PRIMARY KEY ("id"),
	CONSTRAINT ETAPES_DUR_CK CHECK ("duree" >= 0)
);

-- Création de la table medias
CREATE TABLE "medias" (
	"id" int NOT NULL,
	"recette" int NOT NULL,
	"type" int NOT NULL,
	"url" varchar2(255) NOT NULL,
	CONSTRAINT MEDIAS_PK PRIMARY KEY ("id")
);

-- Création de la table media_types
CREATE TABLE "media_types" (
	"id" int NOT NULL,
	"nom" varchar2(100) NOT NULL,
	"is_video" number(1) DEFAULT 0 NOT NULL,
	CONSTRAINT MEDIA_TYPES_PK PRIMARY KEY ("id"),
	CONSTRAINT MEDIA_TYPES_U UNIQUE ("nom")
);

-- Création de la table ingredients_user
CREATE TABLE "ingredients_user" (
	"user" int NOT NULL,
	"ingredient" int NOT NULL,
	"quantite" numeric(5, 5) NOT NULL,
	CONSTRAINT INGREDIENTS_USER_PK PRIMARY KEY ("user","ingredient"),
	CONSTRAINT INGRUSR_QTE_CK CHECK ("quantite" >= 0)
);

-- Création de la table planning
CREATE TABLE "planning" (
	"recette" int NOT NULL,
	"user" int NOT NULL,
	"at" date NOT NULL,
	CONSTRAINT PLANNING_PK PRIMARY KEY ("recette","user", "at")
);

-- Création de la table planning_archive
CREATE TABLE "planning_archive" (
	"recette" int NOT NULL,
	"user" int NOT NULL,
	"at" date NOT NULL,
	CONSTRAINT PLANNING_ARCHIVE_PK PRIMARY KEY ("recette","user", "at")
);

-- Création de la table user_achat_ingredients
CREATE TABLE "user_achat_ingredients" (
	"user" int NOT NULL,
	"ingredient" int NOT NULL,
	"quantite" numeric(5, 5) NOT NULL,
	"date" date NOT NULL,
	CONSTRAINT USER_ACHAT_INGR_PK PRIMARY KEY ("user","ingredient"),
	CONSTRAINT USRACHAT_QTE_CK CHECK ("quantite" >= 0)
);

-- Création de la table user_achat_ingredients_archive
CREATE TABLE "user_achat_ingredients_archive" (
	"user" int NOT NULL,
	"ingredient" int NOT NULL,
	"quantite" numeric(5, 5) NOT NULL,
	"date" date NOT NULL,
	CONSTRAINT USER_ACHAT_INGR_ARCHIVE_PK PRIMARY KEY ("user","ingredient"),
	CONSTRAINT USRACHAT_A_QTE_CK CHECK ("quantite" >= 0)
);

-- Création de la table user_regime
CREATE TABLE "user_regime" (
	"user" int NOT NULL,
	"regime" int NOT NULL,
	CONSTRAINT USER_REGIME_PK PRIMARY KEY ("user","regime")
);

-- Création de la table ingredients_categories
CREATE TABLE "ingredients_categories" (
	"ingredient" int NOT NULL,
	"categorie" int NOT NULL,
	CONSTRAINT INGREDIENTS_CATEGORIES_PK PRIMARY KEY ("ingredient","categorie")
);


-- On ajoute les contraintes sur les clés étrangères
ALTER TABLE "recettes"
	ADD CONSTRAINT "recettes_fk0"
	FOREIGN KEY ("auteur")
	REFERENCES "users" ("id");

ALTER TABLE "ingredients"
	ADD CONSTRAINT "ingr_fk0"
	FOREIGN KEY ("auteur")
	REFERENCES "users" ("id");

ALTER TABLE "ingredients"
	ADD CONSTRAINT "ingr_fk1"
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
