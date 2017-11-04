-------------------
-- PARTIE PL/SQL --
-------------------

-- Fonction qui permet de remplacer le nom d'un ingrédient par un autre dans les étapes
-- (On demande une fonction, donc je retourne simplement une chaîne de 
-- caractères avec les modifications sans vraiment les effectuer)
CREATE OR REPLACE FUNCTION replace_ingredient(
  v_id_recette IN "recettes"."id"%TYPE,
  v_source IN "ingredients"."id"%TYPE,
  v_dest IN "ingredients"."id"%TYPE
) RETURN CLOB IS
BEGIN
  DECLARE
    CURSOR c_etapes IS
      SELECT LOWER("nom") AS "name",
             LOWER("description") AS "desc",
             CONCAT("duree", ' min') AS "duration"
        FROM "etapes"
        WHERE "recette" = v_id_recette
        ORDER BY "ordre";
    v_ingr_src "ingredients"."nom"%TYPE;
    v_ingr_dst "ingredients"."nom"%TYPE;
    v_res CLOB := '';
  BEGIN
    SELECT LOWER("nom") INTO v_ingr_src
      FROM "ingredients"
      WHERE "id" = v_source;
    SELECT LOWER("nom") INTO v_ingr_dst
      FROM "ingredients"
      WHERE "id" = v_dest;

    -- on parcourt chaque étape
    FOR v_etape IN c_etapes LOOP
      v_res := v_res || UPPER(REPLACE(v_etape."name", v_ingr_src, v_ingr_dst));
      v_res := v_res || ' (' || v_etape."duration" || ')' || CHR(10);

      -- s'il y a une description cpmplémentaire pour l'étape
      IF v_etape."desc" IS NOT NULL THEN
        v_res := v_res || '  ' || REPLACE(v_etape."desc", v_ingr_src, v_ingr_dst) || CHR(10);
      END IF;

      v_res := v_res || CHR(10);
    END LOOP;

    RETURN v_res;
  END;
END;
/

-- pour tester :
BEGIN
  dbms_output.put_line(replace_ingredient(1, 1, 2));
END;
/


-- génère le code html correspondant à une recette
CREATE OR REPLACE FUNCTION gen_html_recette(
  v_id_recette IN "recettes"."id"%TYPE
) RETURN CLOB IS
BEGIN
  DECLARE
    v_res CLOB := '<article class="h-recipe">' || CHR(10);
    v_id_recette "recettes"."id"%TYPE := 1;
    v_recette "recettes"%ROWTYPE;
    v_recette_auteur "users"."pseudo"%TYPE;
    v_recette_auteur_dname "users"."display_name"%TYPE;
    CURSOR c_ingr_recette IS
      SELECT i."nom", u."symbol", ir."quantite"
        FROM "ingredients_recette" ir, "ingredients" i, "unites" u
        WHERE ir."ingredient" = i."id" AND i."unite" = u."id" AND ir."recette" = 1;
    CURSOR c_etapes IS
      SELECT "nom" AS "name",
             "description" AS "desc",
             CONCAT("duree", ' min') AS "duration"
        FROM "etapes"
        WHERE "recette" = v_id_recette
        ORDER BY "ordre";
  BEGIN

    -- On remplit les variables avec les valeurs requises
    SELECT * INTO v_recette
      FROM "recettes"
      WHERE "id" = v_id_recette;
    SELECT "pseudo", "display_name" INTO v_recette_auteur, v_recette_auteur_dname
      FROM "users"
      WHERE "id" = v_recette."auteur";

    v_res := v_res || '  <h1 class="p-name">' || v_recette."nom" || '</h1>' || CHR(10);

    -- Si la recette possède une description, alors on l'affiche
    IF v_recette."description" IS NOT NULL THEN
      v_res := v_res || '  <p class="p-summary">' || v_recette."description" || '</p>' || CHR(10);
    END IF;

    -- Si l'auteur de la recette a retourné un nom d'afffichage (nom/prénom en général) ou pas
    IF v_recette_auteur_dname IS NOT NULL THEN
      v_res := v_res || '  <p>Auteur : <span class="p-author">' || v_recette_auteur_dname || ' (@' || v_recette_auteur || ')</span></p>' || CHR(10);
    ELSE
      v_res := v_res || '  <p>Auteur : <span class="p-author">' || v_recette_auteur || '</span></p>' || CHR(10);
    END IF;

    -- La liste des ingrédients
    v_res := v_res || '  <h2>Ingrédients :</h2>' || CHR(10) || '  <ul>' || CHR(10);
    FOR v_ingr IN c_ingr_recette LOOP
      v_res := v_res || '    <li class="p-ingredient">' || v_ingr."nom" || ' (' || v_ingr."quantite" || ' ' || v_ingr."symbol" || ')</li>' || CHR(10);
    END LOOP;

    v_res := v_res || '  </ul>' || CHR(10);
    v_res := v_res || '  <p>Durée : <time class="dt-duration" datetime="' || v_recette."duree_totale" || 'M">' || v_recette."duree_totale" || ' min</time></p>' || CHR(10);
    v_res := v_res || '  <p>Nombre de personnes : <data class="p-yield" value="' || v_recette."nbre_personnes" || '">' || v_recette."nbre_personnes" || '</data></p>' || CHR(10);

    -- Les étapes
    v_res := v_res || '  <h2>Étapes :</h2>' || CHR(10);
    v_res := v_res || '  <div class="e-instructions">' || CHR(10) || '    <ol>' || CHR(10);

    FOR v_etape IN c_etapes LOOP
      v_res := v_res || '      <li>' || v_etape."name" || ' (' || v_etape."duration" || ')';

      -- s'il y a une description cpmplémentaire pour l'étape
      IF v_etape."desc" IS NOT NULL THEN
        v_res := v_res || '<br><em>' || v_etape."desc" || '</em>';
      END IF;

      v_res := v_res || '</li>' || CHR(10);
    END LOOP;

    v_res := v_res || '    </ol>' || CHR(10) || '  </div>' || CHR(10);

    v_res := v_res || '</article>' || CHR(10);
    RETURN v_res;
  END;
END;
/

-- pour tester :
BEGIN
  dbms_output.put_line(gen_html_recette(1));
END;
/

--
-- CONTRAINTES
--


-- Pas plus de 20 ingrédients par recette
SELECT COUNT("ingredient") AS v_nb_ingr
  FROM "ingredients_recette"
  WHERE "recette" = 1;
-- ...et vérifier si ce n'est pas supérieur à 20


-- La liste des ingrédients à acheter ne peut pas être générée plus d'un mois à l'avance
-- ...juste comparer "user_achat_ingredients"."date" <= ADD_MONTHS(SYSDATE, 1)


-- La durée d'une recette est égale au moins au minimum de la durée de ses étapes
SELECT SUM("duree") AS v_duree_etapes
  FROM "etapes"
  WHERE "recette" = 1;
SELECT "duree_totale" AS v_duree_recette
  FROM "recettes"
  WHERE "id" = 1;
-- ...et vérifier si v_duree_recette >= v_duree_etapes


-- Le nombre de calories d'une recette est similaire à celui de la somme des calories de ses ingrédients (+/- 20%)
SELECT SUM(i."calories" * ir."quantite") AS v_cal_etapes
  FROM "ingredients_recette" ir, "ingredients" i
  WHERE "recette" = 1 AND ir."ingredient" = i."id";
SELECT "calories" AS v_cal_recette
  FROM "recettes"
  WHERE "id" = 1;
-- ...et vérifier si v_cal_recette BETWEEN (v_cal_etapes * 0.8) AND (v_cal_etapes * 1.2)


-- Les plannings de recettes et la liste des courses sont archivés lorsqu'ils sont supprimés ou une fois les dates associées dépassées
-- ...trigger lors des deletes => vite insérer la ligne dans _archive, et ensuite seulement delete.
-- ...schudele périodique, qui va check les dates. si "at" ou "date" < SYSDATE, alors archiver.
