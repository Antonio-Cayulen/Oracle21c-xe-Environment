#!/bin/bash

# Colores corregidos para el comando echo -e
ERR_COL='\e[38;5;160;1m'
SUC_COL='\e[38;5;82;1m'
INF_COL='\e[38;5;214;1m'
DEF_COL='\e[0m'

# Permitir que el script continúe si un subcomando maneja su propio error
set +e

echo -e "${INF_COL}[!] Iniciando configuración automatizada del esquema HR...${DEF_COL}"
sleep 5

sqlplus -s sys/sys@localhost:1521/XEPDB1 as sysdba <<EOF
ALTER SESSION SET CONTAINER = XEPDB1;

BEGIN
   EXECUTE IMMEDIATE 'DROP USER hr CASCADE';
EXCEPTION
   WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF;
END;
/

CREATE USER hr IDENTIFIED BY sys;
ALTER USER hr DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER hr TEMPORARY TABLESPACE TEMP;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO hr;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE TO hr;
GRANT EXECUTE ON sys.dbms_stats TO hr;

CONNECT hr/sys@localhost:1521/XEPDB1;

ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

@?/demo/schema/human_resources/hr_cre
@?/demo/schema/human_resources/hr_popul
@?/demo/schema/human_resources/hr_idx
@?/demo/schema/human_resources/hr_code
@?/demo/schema/human_resources/hr_comnt
@?/demo/schema/human_resources/hr_analz

EXIT;
EOF

if [ $? -ne 0 ]; then
    echo -e "${ERR_COL}[!] Ocurrió un error inesperado durante la ejecución en Oracle.${DEF_COL}"
    exit 1
else
    echo -e "${SUC_COL}[+] Despliegue del esquema HR finalizado con éxito.${DEF_COL}"
fi

