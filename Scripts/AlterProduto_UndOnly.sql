/*
  Correcao rapida: adiciona somente a coluna UND se estiver faltando.
  Use se o script principal parou antes de criar UND.
*/

SET TERM ^ ;

EXECUTE BLOCK
AS
BEGIN
  IF (NOT EXISTS(
        SELECT 1
        FROM RDB$RELATION_FIELDS
        WHERE RDB$RELATION_NAME = 'PRODUTO'
          AND RDB$FIELD_NAME = 'UND'
      )) THEN
    EXECUTE STATEMENT 'ALTER TABLE PRODUTO ADD UND VARCHAR(6)';
END
^

SET TERM ; ^

UPDATE PRODUTO SET UND = '' WHERE UND IS NULL;

COMMIT;
