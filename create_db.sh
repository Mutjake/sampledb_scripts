#!/bin/bash
if [ $# != 1 ]
	then
		echo "This script creates the sample database."
		echo "Wrong number of arguments, usage: $0 db_file_to_create"
		exit 1
fi

DBFILEPATH=$1

sqlite3 $DBFILEPATH "PRAGMA foreign_keys = ON; \
BEGIN TRANSACTION; \
CREATE TABLE version(version_number INTEGER, info TEXT); \
INSERT INTO version(version_number, info) VALUES (2, 'paths referenced in metadata instead of sample_files'); \
CREATE TABLE paths(path_id INTEGER PRIMARY KEY, path TEXT NOT NULL, UNIQUE(path)); \
CREATE TABLE IF NOT EXISTS sample_files(file_id INTEGER PRIMARY KEY, filename TEXT NOT NULL, UNIQUE(filename)); \
CREATE TABLE keys(key_id INTEGER PRIMARY KEY, key TEXT NOT NULL, UNIQUE(key)); \
CREATE TABLE values_table(value_id INTEGER PRIMARY KEY, value TEXT NOT NULL, UNIQUE(value)); \
CREATE TABLE IF NOT EXISTS sample_metadata(id INTEGER PRIMARY KEY, file_id INTEGER NOT NULL, \
	path_id INTEGER NOT NULL, key_id INTEGER NOT NULL, value_id INTEGER NOT NULL, \
	FOREIGN KEY(file_id) REFERENCES sample_files(file_id), FOREIGN KEY(key_id) REFERENCES keys(key_id), \
	FOREIGN KEY(path_id) REFERENCES paths(path_id), FOREIGN KEY(value_id) REFERENCES values_table(value_id)); \
COMMIT;"