#!/bin/bash

if [ $# != 3 ]
	then
		echo "Fetch absolute paths of files where key=value"
		echo "Usage: $0 db_file key value"
		exit 1
fi

DBPATH=$1
KEY=$2
VALUE=$3

sqlite3 $DBPATH "SELECT filename, path FROM (SELECT path_id, file_id FROM sample_metadata WHERE key_id IN ( SELECT key_id FROM keys \
WHERE key='$KEY' ) AND value_id IN ( SELECT value_id FROM values_table WHERE value='$VALUE' ) ) s \
INNER JOIN paths p ON s.path_id=p.path_id \
INNER JOIN sample_files f ON s.file_id=f.file_id;"