#
#format:
#  [tag name] 
#  dbname:sql
#
#  [tag name2]
#  dbname:sql
#
#if there is no tags, sql will be ignore
#it will check uddb_sysdb.db_config in meta node and all execute nodes 
#
[CREATE]
test_db_one:DROP DATABASE IF EXISTS test_db_one;
test_db_one:CREATE DATABASE test_db_one;
test_db_two:DROP DATABASE IF EXISTS test_db_two;
test_db_two:CREATE DATABASE test_db_two DEFAULT CHARACTER SET utf8 COLLATE = utf8_general_ci;

[DROP]
test_db_two:DROP DATABASE go_test_db
test_db_one:DROP DATABASE go_test_like_db
