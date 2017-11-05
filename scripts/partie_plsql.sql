-------------------
-- PARTIE PL/SQL --
-------------------

-- 1.Fonction qui permet de remplacer le nom d'un ingrédient par un autre dans les étapes
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



-- 2.fonction qui retourne la liste des ingrédients où la quantité d'ingrédients a
-- été adapté pour un autre nombre de personnes
CREATE OR REPLACE FUNCTION replace_quantite(
  v_id_recette IN "recettes"."id"%TYPE,
  v_nb_persones IN "recettes"."nbre_personnes"%TYPE
) RETURN CLOB IS
BEGIN
  DECLARE
    v_nb_persones_origin "recettes"."nbre_personnes"%TYPE;
    CURSOR c_ingrs IS
      SELECT ir."ingredient", ir."quantite", i."nom", u."symbol"
        FROM "ingredients_recette" ir, "ingredients" i, "unites" u
        WHERE ir."ingredient" = i."id" AND i."unite" = u."id" AND ir."recette" = v_id_recette;
    v_res CLOB := 'INGREDIENTS :' || CHR(10);
  BEGIN
    -- on récupère le nombre original de personnes
    SELECT "nbre_personnes" INTO v_nb_persones_origin
      FROM "recettes"
      WHERE "id" = v_id_recette;

    -- on parcourt chaque ingrédient et on effectue le calcul
    FOR v_ingr IN c_ingrs LOOP
      v_res := v_res || '  * ' || v_ingr."nom" || ' (quantité : ' || (v_ingr."quantite" / v_nb_persones_origin) * v_nb_persones || ' ' || v_ingr."symbol" || ')' || CHR(10);
    END LOOP;

    RETURN v_res;
  END;
END;
/

-- pour tester :
BEGIN
  dbms_output.put_line(replace_quantite(1, 4));
END;
/



-- -- 3.remplace l'ingrédient v_ingr_a_changer par un de la même catégorie
-- -- (la logique est bonne, mais Oracle pue un peu ici pour le coup..)
-- -- (de toute façon se sera fait dans la partie web)
-- CREATE OR REPLACE PROCEDURE copy_recette(
--   v_id_recette IN "recettes"."id"%TYPE,
--   v_nb_persones IN "recettes"."id"%TYPE,
--   v_ingr_a_changer IN "ingredients"."id"%TYPE
-- ) IS
-- BEGIN
--   DECLARE
--     v_ingr_de_remplacement "ingredients"."id"%TYPE := NULL;
--     v_ingr_cat "ingredients_categories"."categorie"%TYPE;
--     v_next_id "recettes"."id"%TYPE;
--     v_next_id_step "etapes"."id"%TYPE;
--     v_recette_origin "recettes"%ROWTYPE;
--     v_ingr_src "ingredients"."nom"%TYPE;
--     v_ingr_dst "ingredients"."nom"%TYPE;
--     CURSOR c_etapes IS SELECT * FROM "etapes" WHERE "recette" = v_id_recette;
--     CURSOR c_ingrs IS SELECT * FROM "ingredients_recette" WHERE "recette" = v_id_recette;
--   BEGIN
--     SELECT LOWER("nom") INTO v_ingr_src
--       FROM "ingredients"
--       WHERE "id" = v_ingr_a_changer;

--     SELECT "categorie" INTO v_ingr_cat
--       FROM "ingredients_categories"
--       WHERE "ingredient" = v_ingr_a_changer;

--     IF v_ingr_cat IS NOT NULL THEN
--       SELECT "ingredient" INTO v_ingr_de_remplacement
--         FROM "ingredients_categories"
--         WHERE "categorie" = v_ingr_cat AND "ingredient" != v_ingr_a_changer AND ROWNUM < 1;
--     END IF;

--     -- si jamais on n'a rien trouvé pour changer, on ne change rien
--     IF v_ingr_de_remplacement IS NULL THEN
--       v_ingr_de_remplacement := v_ingr_a_changer;
--     END IF;

--     SELECT LOWER("nom") INTO v_ingr_dst
--       FROM "ingredients"
--       WHERE "id" = v_ingr_de_remplacement;

--     -- on récupère la recette
--     SELECT * INTO v_recette_origin
--       FROM "recettes"
--       WHERE "id" = v_id_recette;

--     SELECT MAX("id") + 1 INTO v_next_id FROM "recettes";
--     INSERT INTO "recettes" (
--       "id",
--       "nom",
--       "description",
--       "auteur",
--       "difficulte",
--       "prix",
--       "nbre_personnes",
--       "duree_totale",
--       "calories",
--       "lipides",
--       "glucides",
--       "glucides_dont_sucres",
--       "protides"
--     ) VALUES (
--       v_next_id,
--       REPLACE(LOWER(v_recette_origin."nom"), v_ingr_src, v_ingr_dst),
--       REPLACE(LOWER(v_recette_origin."description"), v_ingr_src, v_ingr_dst),
--       v_recette."auteur",
--       v_recette."difficulte",
--       v_recette."prix",
--       v_nb_persones,
--       v_recette."duree_totale",
--       (v_recette."calories" / v_recette."nbre_personnes") * v_nb_persones,
--       (v_recette."lipides" / v_recette."nbre_personnes") * v_nb_persones,
--       (v_recette."glucides" / v_recette."nbre_personnes") * v_nb_persones,
--       (v_recette."glucides_dont_sucres" / v_recette."nbre_personnes") * v_nb_persones,
--       (v_recette."protides" / v_recette."nbre_personnes") * v_nb_persones
--     );

--     -- on insert les étapes de la nouvelle recette
--     FOR v_etape IN c_etapes LOOP
--       SELECT MAX("id") + 1 INTO v_next_id_step FROM "etapes";
--       INSERT INTO "etapes" (
--         "id",
--         "recette",
--         "type",
--         "nom",
--         "description",
--         "duree",
--         "ordre"
--       ) VALUES (
--         v_next_id_step,
--         v_next_id,
--         v_etape."type",
--         REPLACE(LOWER(v_etape."nom"), v_ingr_src, v_ingr_dst),
--         REPLACE(LOWER(v_etape."description"), v_ingr_src, v_ingr_dst),
--         v_etape."duree",
--         v_etape."ordre"
--       );
--     END LOOP;

--     -- on insert les ingrédients utilisées par la nouvelle recette
--     FOR v_ingr IN c_ingrs LOOP
--       IF v_ingr."ingredient" = v_ingr_a_changer THEN
--         INSERT INTO "ingredients_recette" (
--           "recette",
--           "ingredient",
--           "quantite"
--         ) VALUES (
--           v_next_id,
--           v_ingr_de_remplacement,
--           (v_ingr."quantite" / v_recette."nbre_personnes") * v_nb_persones
--         );
--       ELSE
--         INSERT INTO "ingredients_recette" (
--           "recette",
--           "ingredient",
--           "quantite"
--         ) VALUES (
--           v_next_id,
--           v_ingr."ingredient",
--           (v_ingr."quantite" / v_recette."nbre_personnes") * v_nb_persones
--         );
--       END IF;
--     END LOOP;
--   EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--       -- si on a pas d'ingrédient de remplacement
--       v_ingr_de_remplacement := NULL;
--       -- si on a pas de catégorie renseignée
--       v_ingr_cat := NULL;
--   END;
-- END;
-- /
-- SHOW ERRORS;



-- 4.définir une fonction qui retourne un booléen si la recette est compatible avec un régime
CREATE OR REPLACE FUNCTION is_recette_compatible_regime(
  v_id_recette IN "recettes"."id"%TYPE,
  v_regime IN "regime"."nom"%TYPE
) RETURN BOOLEAN IS
BEGIN
  DECLARE
    v_res BOOLEAN := TRUE;
    CURSOR c_recettes IS
      SELECT "recette"
        FROM "ingredients_recette"
        WHERE "ingredient" IN (
          SELECT iir."ingredient"
            FROM "regime" r, "ingredients_interdits_regime" iir
            WHERE r."id" = iir."regime" AND UPPER(r."nom") = UPPER(v_regime)
        );
  BEGIN
    
    FOR v_recette IN c_recettes LOOP
      IF v_recette."recette" = v_id_recette THEN
        v_res := FALSE;
      END IF;
    END LOOP;

    RETURN v_res;
  END;
END;
/

-- pour tester :
BEGIN
  IF is_recette_compatible_regime(1, 'Végétarien') THEN
    dbms_output.put_line(' => La recette est bien végétarienne !');
  ELSE
    dbms_output.put_line(' => La recette n''est pas végétarienne !');
  END IF;
END;
/



-- 5.Générer liste d'ingrédients à acheter
-- J'ai de gros soucis avec Oracle lorsque je fais des INSERT en PL/SQL (voir 3. par exemple)
-- mais en gros la logique serait de parcourir le planing et de regarder chaque recette qu'il y a
-- vérifier dans les quantité des ingrédients que possède l'utilisateur pour voir s'il a déjà
-- ce qu'il faut ou pas, et en vérifiant ce qu'il y a déjà sur les listes d'achat (en faisant attention
-- aux dates), et insérer si besoin dans la liste d'achat à une date avant la date prévue du planning.




-- 6.génère le code html correspondant à une recette
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


-- 1.Pas plus de 20 ingrédients par recette
CREATE OR REPLACE TRIGGER number_ingredients
  BEFORE INSERT
  ON "ingredients_recette"
  FOR EACH ROW
BEGIN
  DECLARE
    v_nb_ingr NUMBER;
  BEGIN
    SELECT COUNT("ingredient") INTO v_nb_ingr
      FROM "ingredients_recette"
      WHERE "recette" = :new."recette";
    IF v_nb_ingr >= 20 THEN
      raise_application_error(-20000, 'Pas plus de 20 ingrédients par recette !');
    END IF;
  END;
END;
/


-- 2.La liste des ingrédients à acheter ne peut pas être générée plus d'un mois à l'avance
CREATE OR REPLACE TRIGGER date_list_ingr
  BEFORE INSERT OR UPDATE
  ON "user_achat_ingredients"
  FOR EACH ROW
BEGIN
  BEGIN
    IF :new."date" >= ADD_MONTHS(SYSDATE, 1) THEN
      raise_application_error(-20000, 'La liste des ingrédients à acheter ne peut pas être générée plus d''un mois à l''avance !');
    END IF;
  END;
END;
/


-- 3.La durée d'une recette est égale au moins au minimum de la durée de ses étapes
CREATE OR REPLACE TRIGGER duration_recette
  BEFORE INSERT OR UPDATE
  ON "recettes"
  FOR EACH ROW
BEGIN
  DECLARE
    v_duree_etapes "recettes"."duree_totale"%TYPE;
    v_duree_recette "recettes"."duree_totale"%TYPE;
  BEGIN
    SELECT SUM("duree") INTO v_duree_etapes
      FROM "etapes"
      WHERE "recette" = :new."id";
    SELECT "duree_totale" INTO v_duree_recette
      FROM "recettes"
      WHERE "id" = :new."id";
    IF v_duree_recette < v_duree_etapes THEN
      raise_application_error(-20000, 'La durée d''une recette doit être égale au moins au minimum de la durée de ses étapes !');
    END IF;
  EXCEPTION
    -- s'il n'y a pas encore d'étapes à cette recette, on ne fait rien.
    WHEN NO_DATA_FOUND THEN NULL;
  END;
END;
/

-- 4.un peu la même chose, mais là lorsque l'on change une étape
CREATE OR REPLACE TRIGGER duration_recette_step
  BEFORE INSERT OR UPDATE
  ON "etapes"
  FOR EACH ROW
BEGIN
  DECLARE
    v_duree_etapes "recettes"."duree_totale"%TYPE;
    v_duree_recette "recettes"."duree_totale"%TYPE;
  BEGIN
    SELECT SUM("duree") INTO v_duree_etapes
      FROM "etapes"
      WHERE "recette" = :new."recette";
    SELECT "duree_totale" INTO v_duree_recette
      FROM "recettes"
      WHERE "id" = :new."recette";
    IF v_duree_recette < v_duree_etapes THEN
      raise_application_error(-20000, 'La durée d''une recette doit être égale au moins au minimum de la durée de ses étapes !');
    END IF;
  END;
END;
/



-- -- 5.Le nombre de calories d'une recette est similaire à celui de la somme des calories de ses ingrédients (+/- 20%)
-- -- (ici Oracle fait aussi un peut n'importe quoi; de toute façon ce sera gérée au niveau de l'UI du site...)
-- CREATE OR REPLACE TRIGGER cal_recette_etapes
--   AFTER INSERT OR UPDATE
--   ON "ingredients_recette"
--   FOR EACH ROW
-- BEGIN
--   DECLARE
--     v_cal_etapes "ingredients"."calories"%TYPE;
--     v_cal_recette "ingredients"."calories"%TYPE;
--   BEGIN
--     SELECT SUM(i."calories" * ir."quantite") INTO v_cal_etapes
--       FROM "ingredients_recette" ir, "ingredients" i
--       WHERE "recette" = :new."recette" AND ir."ingredient" = i."id";
--     SELECT "calories" INTO v_cal_recette
--       FROM "recettes"
--       WHERE "id" = :new."recette";
    
--     IF
--       ((v_cal_recette < (v_cal_etapes * 0.8) OR v_cal_recette > (v_cal_etapes * 1.2))
--         AND
--       (v_cal_etapes < (v_cal_recette * 0.8) OR v_cal_etapes > (v_cal_recette * 1.2)))
--     THEN
--       raise_application_error(-20000, 'Le nombre de calories d''une recette est similaire à celui de la somme des calories de ses ingrédients (+/- 20%)');
--     END IF;
-- END;
-- /
-- SHOW ERRORS;


-- 6.Les plannings de recettes et la liste des courses sont archivés lorsqu'ils sont supprimés ou une fois les dates associées dépassées
-- ...trigger lors des deletes => vite insérer la ligne dans _archive, et ensuite seulement delete.
-- ...schudele périodique, qui va check les dates. si "at" ou "date" < SYSDATE, alors archiver.
-- la logique est marqué au-dessus, mais j'ai des soucis pour faire des INSERT dans du PL/SQL
-- ce sera fait au niveau du site web de toute façon; et là Oracle commence sérieusement à me casser les pieds :'(
