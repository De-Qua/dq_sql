#!/bin/bash

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
DUMP_DIR="$CUR_DIR/../db_dump"

declare -A DUMP_FILES
DUMP_FILES[opendata_ve_pg]="opendata.sql" 
DUMP_FILES[dequa_internal]="internal.sql" 
DUMP_FILES[dequa_collected_data]="collected.sql" 
DUMP_FILES[dequa_config_data]="config.sql" 
DUMP_FILES[dequa_geotag]="geotag.sql" 

CONTAINER_NAME=dq_postgres
POSTGRES_USER=dequa

DUMP_PATH=$(cd $DUMP_DIR && pwd)

for db in "${!DUMP_FILES[@]}"
do
    file=${DUMP_FILES[$db]}
    echo "Copying $file in docker"
    docker cp $DUMP_PATH/$file $CONTAINER_NAME:/tmp/
    echo "Restoring db $db"
    docker exec -i $CONTAINER_NAME psql -U $POSTGRES_USER -d $db -f /tmp/$file
done