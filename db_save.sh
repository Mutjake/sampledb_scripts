#!/bin/bash

if [ $# != 5 ]
	then
		echo "Adds a key value pair to the designated database for the designated file."
		echo "Usage: $0 db_file sample_path filename key value"
		exit 1
fi

DBPATH=$1
SAMPLE_PATH=$2
FILENAME=$3 
KEY=$4
VALUE=$5

# ensure file is in db
sqlite3 $DBPATH "PRAGMA foreign_keys = ON; \
BEGIN TRANSACTION; \
INSERT OR IGNORE INTO paths(path) VALUES ('$SAMPLE_PATH'); \
INSERT OR IGNORE INTO sample_files(filename) VALUES ('$FILENAME'); \
COMMIT;"

# save key value pair
sqlite3 $DBPATH "PRAGMA foreign_keys = ON; \
BEGIN TRANSACTION; \
INSERT OR IGNORE INTO keys(key) VALUES ('$KEY'); \
INSERT OR IGNORE INTO values_table(value) VALUES ('$VALUE'); \
INSERT OR IGNORE INTO sample_metadata(file_id, path_id, key_id, value_id) SELECT sample_files.file_id, paths.path_id, keys.key_id, values_table.value_id \
FROM sample_files, paths, keys, values_table WHERE sample_files.filename='$FILENAME' AND paths.path='$SAMPLE_PATH' AND keys.key='$KEY' AND values_table.value='$VALUE'; \
COMMIT;"