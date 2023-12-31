/*

Pregunta
===========================================================================

Escriba una consulta que para cada valor único de la columna `t0.c2,` 
calcule la suma de todos los valores asociados a las claves en la columna 
`t0.c6`.

Apache Hive se ejecutará en modo local (sin HDFS).

Escriba el resultado a la carpeta `output` de directorio de trabajo.

*/

DROP TABLE IF EXISTS tbl0;
CREATE TABLE tbl0 (
    c1 INT,
    c2 STRING,
    c3 INT,
    c4 DATE,
    c5 ARRAY<CHAR(1)>, 
    c6 MAP<STRING, INT>
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY ':'
MAP KEYS TERMINATED BY '#'
LINES TERMINATED BY '\n';
LOAD DATA LOCAL INPATH 'data0.csv' INTO TABLE tbl0;

/*
    >>> Escriba su respuesta a partir de este punto <<<
*/

DROP TABLE IF EXISTS conteo;
CREATE TABLE conteo AS SELECT c2 as letras,  valores FROM tbl0
    LATERAL VIEW explode(map_values(c6)) tbl0 as valores;

INSERT OVERWRITE LOCAL DIRECTORY 'output'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT letras, sum(valores) FROM conteo GROUP BY letras;