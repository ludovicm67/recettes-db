-- PARTIE PL/SQL


DECLARE
  v_pseudo "users"."pseudo"%TYPE;
BEGIN
  SELECT "pseudo" INTO v_pseudo FROM "users" WHERE "id" = 1;
  dbms_output.put_line('Pseudo : ' || v_pseudo);
END;
/


DECLARE
  v_res CLOB := '<div class="hrecipe">' || CHR(10);
  v_id_recette "recettes"."id"%TYPE := 1;
  v_recette "recettes"%ROWTYPE;
  v_recette_auteur "users"."pseudo"%TYPE;
  v_recette_auteur_dname "users"."display_name"%TYPE;
BEGIN

  -- On remplit les variables avec les valeurs requises
  SELECT * INTO v_recette
    FROM "recettes"
    WHERE "id" = v_id_recette;
  SELECT "pseudo", "display_name" INTO v_recette_auteur, v_recette_auteur_dname
    FROM "users"
    WHERE "id" = v_recette."auteur";

  v_res := v_res || '  <h1 class="fn">' || v_recette."nom" || '</h1>' || CHR(10);

  -- Si la recette possède une description, alors on l'affiche
  IF v_recette."description" IS NOT NULL THEN
    v_res := v_res || '  <p class="summary">' || v_recette."description" || '</p>' || CHR(10);
  END IF;

  -- Si l'auteur de la recette a retourné un nom d'afffichage (nom/prénom en général) ou pas
  IF v_recette_auteur_dname IS NOT NULL THEN
    v_res := v_res || '  <p>Auteur : ' || v_recette_auteur_dname || ' (@' || v_recette_auteur || ')</p>' || CHR(10);
  ELSE
    v_res := v_res || '  <p>Auteur : ' || v_recette_auteur || '</p>' || CHR(10);
  END IF;

  v_res := v_res || '</div>' || CHR(10);
  dbms_output.put_line(v_res);
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
