# DuocUC ORACLE 21c XE Line Up

El objetivo de este repositorio es facilitar la implementacion de algunas tecnologías requeridas por _Duoc UC_, por medio de una descarga, configuración e instalación automatizada para levantar una base de datos __ORACLE 21c Express Edition (XE)__ necesaria para practicar y aprender en local. Esto debido a que la práctica para algunas evaluaciones se ve limitada al usar __ORACLE Cloud Infraestructure (OCI)__.

---

## Tecnologías Utilizadas
*   **Docker / Docker Compose**: Contenedorización del motor para evitar instalaciones nativas complejas.
*   **Oracle Database 21c XE**: Motor de base de datos relacional (edición oficial gratuita).
*   **Bash Scripting & SQL*Plus**: Automatización interna para la creación del usuario e inserción de datos.

---

## Componentes del Repositorio

El repositorio está diseñado bajo el principio de infraestructura como código. Cada archivo cumple un rol específico en el proceso de automatización:

### 1. `docker-compose.yaml`
Orquesta la creación del contenedor. Descarga la imagen oficial de Oracle 21c Slim y realiza dos montajes de volúmenes críticos:
*   Mapea los archivos del esquema HR en la ruta nativa del motor (`ORACLE_HOME`), permitiendo que los scripts internos se localicen sin alterar sus rutas originales.
*   Inyecta el script de automatización en la carpeta `/container-entrypoint-initdb.d/`, un directorio nativo de la imagen que ejecuta cualquier script en su interior de forma automática durante el primer arranque.

### 2. `init-hr-schema.sh / init-hr-schema.bat`
Script en Bash/Batch que se ejecuta de fondo una vez que el motor de Oracle está encendido. Ejecuta un bloque de comandos silencioso mediante SQL*Plus que:
*   Conmuta la sesión a la Pluggable Database (`XEPDB1`) para aislar los datos académicos de la raíz del sistema.
*   Crea el usuario `hr` con la contraseña predefinida `sys`.
*   Asigna cuotas ilimitadas de almacenamiento en el tablespace `USERS`.
*   Invoca de manera transparente el instalador oficial de Oracle pasándole las variables requeridas en segundo plano.

### 3. Carpeta `human_resources/`
Contiene los archivos oficiales de Oracle para el esquema de demostración (tablas, datos, índices y procedimientos). No requiere ninguna modificación manual ya que el entorno simula su ubicación de fábrica.

---

## Instrucciones de Uso (Despliegue en 2 Pasos)

Para clonar y levantar todo el ambiente académico de manera automatizada, ejecuta en tu terminal:

### Paso 1: Clonar y dar permisos al script
```bash
git clone <url-de-tu-repositorio>
cd duocuc-oracle-lineup
chmod +x init-hr-schema.sh
```

### Paso 2: Levantar el contenedor
```bash
docker compose up -d
```

### Monitoreo del Proceso
La base de datos puede tardar un par de minutos en realizar su primera configuración. Puedes revisar el progreso en tiempo real con el siguiente comando:
```bash
docker logs -f oracle21xe
```
O bien en Docker Compose (GUI).\
Una vez que visualices el mensaje `DATABASE IS READY TO USE` y `Despliegue del esquema HR finalizado con exito`, el entorno estará operativo.

---

## Datos de Conexión (Ambiente Local)

Puedes conectar herramientas externas de modelado (como Oracle SQL Developer, DBeaver o VS Code) utilizando los siguientes parámetros fijos:

*   **Usuario**: `hr`
*   **Contraseña**: `sys`
*   **Host**: `localhost`
*   **Puerto**: `1521`
*   **Service Name (Servicio)**: `XEPDB1`

