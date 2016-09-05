#
#format:
#  [create] 
#  dbname.tablename:sql
#
#if there is no tags, sql will be ignore
# 1. check uddb_sysdb.table_config in meta 
# 2. check  all execute nodes 
# 3. check table define
# 4. check show create table
#

[CREATE]
#CREATE TABLE `test_tbl_one` ( 
#   `intpk` INT PRIMARY KEY, 
#   `inttype` INT,
#   `intautoincrement` INT  AUTO_INCREMENT,
#   `intnull` INT NULL,
#   `intnotnull` INT NOT NULL, 
#   `tinyintunsigned` TINYINT NOT NULL,
#   `mediumintdefault` MEDIUMINT NOT NULL DEFAULT '0', 
#   `intcomment` INT NOT NULL DEFAULT '0' COMMENT 'hotdb', 
#   `intzerofill` INT(16) ZEROFILL NOT NULL DEFAULT '0' COMMENT 'hotdb', 
#   `timestampdefault` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
#   `timestamponupdate` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, 
#   `time` TIME,
#   `char20` CHAR(20),
#   `varcharcharset` VARCHAR(32) CHARSET latin1, 
#   `varcharcharacterset` VARCHAR(32) CHARACTER SET latin1, 
#   `varcharcollate` VARCHAR(32) CHARACTER SET latin1 COLLATE latin1_general_cs, 
#   `partindex` VARCHAR(32), 
#   `fulltextindex` TEXT, 
#   `blob` TINYBLOB,
#   `doubletype` DOUBLE, 
#   `floattype` FLOAT, 
#   KEY `idx_intnull` (`intautoincrement`), 
#   KEY `idx_multicolindex` (`intnull`,`intnotnull`), 
#   KEY `idx_partindex` (`partindex`(8))
#) ENGINE=InnoDB DEFAULT CHARSET=utf8/*bf=intpk policy=exp*/;
test_db_one.test_tbl_one: CREATE TABLE `test_tbl_one` ( `intpk` INT PRIMARY KEY, `inttype` INT, `intautoincrement` INT  AUTO_INCREMENT, `intnull` INT NULL,`intnotnull` INT NOT NULL, `tinyintunsigned` TINYINT NOT NULL,`mediumintdefault` MEDIUMINT NOT NULL DEFAULT '0', `intcomment` INT NOT NULL DEFAULT '0' COMMENT 'hotdb', `intzerofill` INT(16) ZEROFILL NOT NULL DEFAULT '0' COMMENT 'hotdb', `timestampdefault` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `timestamponupdate` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, `time` TIME,`char20` CHAR(20),`varcharcharset` VARCHAR(32) CHARSET latin1, `varcharcharacterset` VARCHAR(32) CHARACTER SET latin1, `varcharcollate` VARCHAR(32) CHARACTER SET latin1 COLLATE latin1_general_cs, `partindex` VARCHAR(32), `fulltextindex` TEXT, `blob` TINYBLOB,`doubletype` DOUBLE, `floattype` FLOAT, KEY `idx_intnull` (`intautoincrement`), KEY `idx_multicolindex` (`intnull`,`intnotnull`), KEY `idx_partindex` (`partindex`(8))) ENGINE=InnoDB DEFAULT CHARSET=utf8/*bf=intpk policy=exp*/;
#CREATE TABLE  `test_tbl_two`(
#  data INT(10) NOT NULL,
#  time INT NOT NULL DEFAULT '0',
#  comment VARCHAR(1000),
#  year YEAR,
#  timestamp CHAR(20) NOT NULL DEFAULT 'timestamp',
#  PRIMARY KEY (data)
#)ENGINE = INNODB COMMENT='data or time'/*bf=id policy=exp*/  
#PARTITION BY HASH (data)
#PARTITIONS 5;
test_db_one.test_tbl_two:CREATE TABLE  `test_tbl_two`( data INT(10) NOT NULL, time INT NOT NULL DEFAULT '0', comment VARCHAR(1000), year YEAR, timestamp CHAR(20) NOT NULL DEFAULT 'timestamp', PRIMARY KEY (data))ENGINE = INNODB COMMENT='data or time'/*bf=id policy=exp*/  PARTITION BY HASH (data) PARTITIONS 5;
#CREATE TABLE  test_db_one.test_tbl_three( 
#  `select` INT(10) NOT NULL, 
#  `insert` INT NOT NULL DEFAULT 0, 
#  `update` FLOAT(8,4), 
#  `delete` DECIMAL(10) UNSIGNED ZEROFILL 
#) 
#PARTITION BY RANGE (`select`) 
#SUBPARTITION BY HASH(`insert`)  
#SUBPARTITIONS 4  
#(  
#PARTITION P1 VALUES LESS THAN (2),  
#PARTITION P2 VALUES LESS THAN (4),   
#PARTITION P3 VALUES LESS THAN (6), 
#PARTITION P4 VALUES LESS THAN MAXVALUE);
test_db_one.test_tbl_three: CREATE TABLE test_db_one.test_tbl_three( `select` INT(10) NOT NULL, `insert` INT NOT NULL DEFAULT 0, `update` FLOAT(8,4), `delete` DECIMAL(10) UNSIGNED ZEROFILL ) PARTITION BY RANGE(`select`) SUBPARTITION BY HASH(`insert`) SUBPARTITIONS 4(PARTITION P1 VALUES LESS THAN (2),PARTITION P2 VALUES LESS THAN (4),PARTITION P3 VALUES LESS THAN (6), PARTITION P4 VALUES LESS THAN MAXVALUE);
#CREATE TABLE  `test_db_two`.`test_tbl_func_one` ( 
#  `mydate` DATE NOT NULL, 
#  `mydatatime` DATETIME 
#) 
#PARTITION BY RANGE (day(`mydate`)) 
#SUBPARTITION BY HASH(dayofyear(`mydatatime`)) 
#SUBPARTITIONS 2 
#( 
#PARTITION P1 VALUES LESS THAN (15),  
#PARTITION PM VALUES LESS THAN MAXVALUE);
test_db_two.test_tbl_func_one: CREATE TABLE  `test_db_two`.`test_tbl_func_one` ( `mydate` DATE NOT NULL, `mydatatime` DATETIME ) PARTITION BY RANGE (day(`mydate`)) SUBPARTITION BY HASH(dayofyear(`mydatatime`)) SUBPARTITIONS 2 ( PARTITION P1 VALUES LESS THAN (15),  PARTITION PM VALUES LESS THAN MAXVALUE);
#CREATE TABLE test_db_two.test_tbl_list_one 
#( 
# `date`      DATE, 
# `create`    SMALLINT  as ('column1') COMMENT 'create column', 
# `alter`     BINARY UNIQUE KEY, 
# `drop`      VARCHAR(200) BINARY CHARACTER SET utf8, 
# `truncate`  BLOB COMMENT 'unused' COLUMN_FORMAT DEFAULT 
#) 
#PARTITION BY LIST (`alter`)  
#SUBPARTITION BY HASH(year(`date`))  
#SUBPARTITIONS 2 
#( 
#PARTITION P1 VALUES IN (2,3,4),  
#PARTITION P4 VALUES IN (100,2324,1,100,23));
test_db_two.test_tbl_list_one:CREATE TABLE test_db_two.test_tbl_list_one( `date`  DATE, `create`  SMALLINT  as ('column1') COMMENT 'create column', `alter`     BINARY UNIQUE KEY, `drop`      VARCHAR(200) BINARY CHARACTER SET utf8, `truncate`  BLOB COMMENT 'unused' COLUMN_FORMAT DEFAULT ) PARTITION BY LIST (`alter`)  SUBPARTITION BY HASH(year(`date`))  SUBPARTITIONS 2 ( PARTITION P1 VALUES IN (2,3,4),  PARTITION P4 VALUES IN (100,2324,1,100,23));
#CREATE like table
test_db_one.test_tbl_five: CREATE TABLE IF NOT EXISTS test_tbl_five LIKE test_tbl_two;
test_db_two.test_tbl_four: CREATE TABLE test_db_two.test_tbl_four LIKE test_db_one.test_tbl_three;

test_db_one.test_tbl_one:CREATE INDEX test_tbl_index1 ON test_tbl_one(intnotnull);
test_db_one.test_tbl_three:CREATE UNIQUE INDEX test_tbl_index2 USING HASH ON test_tbl_three(`insert`);

#
#format:
#  [alter] 
#  dbname.tablename:sql
#
#  run all the case, then check the reference table.
#  check show create table and table define
#


[ALTER]
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD COLUMN addint INT;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD COLUMN addintafter INT AFTER intnotnull;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD addonlyint int;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD addintfirst INT FIRST;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one DROP COLUMN addint;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD KEY idx_inttype(addintfirst);
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ADD KEY idx_inttype_inplace (tinyintunsigned)
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one CHANGE inttype intnotnulltype INT NOT NULL;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one CHANGE doubletype doubletype INT NOT NULL AFTER addonlyint;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one CHANGE doubletype doubletype INT NOT NULL FIRST;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one DROP PRIMARY KEY;
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ALTER tinyintunsigned SET DEFAULT '1';
test_db_one.test_tbl_one:ALTER TABLE test_tbl_one ALTER mediumintdefault DROP DEFAULT;
test_db_one.test_tbl_one:DROP INDEX idx_multicolindex ON test_tbl_one



test_db_one.test_tbl_two:ALTER TABLE test_tbl_two ADD INDEX idx_timestamp(timestamp);
test_db_one.test_tbl_two:ALTER TABLE test_tbl_two ADD INDEX idx_timebtree(time) USING BTREE;
test_db_one.test_tbl_two:ALTER TABLE test_tbl_two ADD UNIQUE idx_uiqueyearindex (year);
test_db_one.test_tbl_two:ALTER TABLE test_tbl_two ADD FULLTEXT idx_fulltext (comment);
test_db_one.test_tbl_two:ALTER TABLE test_tbl_two DROP PRIMARY KEY;
test_db_one.test_tbl_two:ALTER TABLE test_tbl_two ADD PRIMARY KEY (year);
test_db_one.test_tbl_two:DROP INDEX idx_timestamp ON test_tbl_two LOCK=DEFAULT



test_db_one.test_tbl_three:ALTER TABLE test_tbl_three MODIFY `update` INT NOT NULL;
test_db_one.test_tbl_three:ALTER TABLE test_tbl_three MODIFY `insert` BIGINT NOT NULL AFTER `delete`;
test_db_one.test_tbl_three:ALTER TABLE test_tbl_three MODIFY `delete` INT NOT NULL FIRST;
test_db_one.test_tbl_three:ALTER TABLE test_tbl_three ADD PRIMARY KEY (`delete`);
test_db_one.test_tbl_three:DROP INDEX `PRIMARY` ON test_tbl_three




test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four DISABLE KEYS;
test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four ENABLE KEYS;
test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four RENAME test_db_two.test_tbl_four_rename;
test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four_rename RENAME TO test_db_two.test_tbl_four;
test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four RENAME AS test_db_two.test_tbl_four_rename_as;
test_db_two.test_tbl_four_new:ALTER TABLE test_db_two.test_tbl_four_rename_as CONVERT TO CHARACTER SET utf8mb4;
test_db_two.test_tbl_four_new:RENAME TABLE test_db_two.test_tbl_four_rename_as TO test_db_two.test_tbl_four_new;

#
#format:
#  [drop] 
#  dbname.tablename:sql
#
#  1. check uddb_sysdb.table_config in meta 
#  2. check  all execute nodes
#

[DROP]
test_db_one.test_tbl_one:DROP TABLE test_tbl_one
test_db_two.test_tbl_two:DROP TABLE IF EXISTS test_tbl_two
test_db_two.test_tbl_four_new:DROP TABLE test_db_two.test_tbl_four_new
