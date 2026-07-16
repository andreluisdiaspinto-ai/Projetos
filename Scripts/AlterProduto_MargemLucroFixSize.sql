/*
  Corrige MARGEM_LUCRO para NUMERIC(18,2) - 2 casas decimais (alinha com o Delphi).
  Execute se o erro for "Size mismatch ... expecting: 2 actual: 4" ou o inverso.
*/

ALTER TABLE PRODUTO DROP MARGEM_LUCRO;

ALTER TABLE PRODUTO ADD MARGEM_LUCRO NUMERIC(18,2) DEFAULT 0;

UPDATE PRODUTO SET MARGEM_LUCRO = 0 WHERE MARGEM_LUCRO IS NULL;

COMMIT;
