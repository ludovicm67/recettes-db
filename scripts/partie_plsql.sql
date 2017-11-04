-- PARTIE PL/SQL

-- On active l'affichage
SET SERVEROUTPUT ON SIZE 10000;




DECLARE
  v_pseudo "users"."pseudo"%TYPE;
BEGIN
  SELECT "pseudo" INTO v_pseudo FROM "users" WHERE "id" = 1;
  dbms_output.put_line('Pseudo : ' || v_pseudo);
END;
/





SELECT * FROM "ingredients_recette";