// Copyright 2012, Google Inc. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Copyright 2015 The kingshard Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"): you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.

%{
package sqlparser

import "bytes"





func SetParseTree(yylex interface{}, stmt Statement) {
  yylex.(*Tokenizer).ParseTree = stmt
}

func SetAllowComments(yylex interface{}, allow bool) {
  yylex.(*Tokenizer).AllowComments = allow
}

func SetStorage(yylex interface{}, storage []byte) {
    
  if !bytes.Equal(bytes.ToLower(storage), []byte("innodb")) {
    yylex.(*Tokenizer).Storage = storage
  }
  
}


func ForceEOF(yylex interface{}) {
  yylex.(*Tokenizer).ForceEOF = true
}

func ReadPos(yylex interface{}) (pos int) {
  pos = yylex.(*Tokenizer).Position
  if pos > len(yylex.(*Tokenizer).Sql) {
      pos = 0 
  }
  return
}


func ReadLastPos(yylex interface{}) (pos int) {
  pos = yylex.(*Tokenizer).LastPos
  if pos > len(yylex.(*Tokenizer).Sql) {
      pos = 0 
  }

  return
}

func AddParam(yylex interface{}, param *Param) () {
  yylex.(*Tokenizer).ParamList = append(yylex.(*Tokenizer).ParamList, param)
  return
}



/*we use interval '[)' to read sql*/
func ReadSql(yylex interface{}, s, end int) (b []byte){

  if s == 0 && end == 0 {
    b =  []byte(yylex.(*Tokenizer).Sql)
  } else if s == 0 && end != 0 {
    b =  []byte(yylex.(*Tokenizer).Sql[:end-1])
  } else if s != 0 && end == 0 {
    b =  []byte(yylex.(*Tokenizer).Sql[s-1:])
  } else {
    b =  []byte(yylex.(*Tokenizer).Sql[s-1:end-1])
  }
  
  return
}

/*we use interval '....)' to read sql*/
func ReadBefore(yylex interface{}, end int) (b []byte) {
  if end == 0 {
    b =  []byte(yylex.(*Tokenizer).Sql)
  } else {
    b =  []byte(yylex.(*Tokenizer).Sql[:end-1])

  }   

  return
}

/*we use interval '[....' to read sql*/
func ReadAfter(yylex interface{}, s int) (b []byte) {
  if s == 0 {
    b =  []byte{}
  } else{
    b =  []byte(yylex.(*Tokenizer).Sql[s-1:])
  } 
 
  return
}

var (
  SHARE =        []byte("share")
  MODE  =        []byte("mode")
  IF_BYTES =     []byte("if")
  VALUES_BYTES = []byte("values")
)

%}

%union {
  empty       struct{}
  statement   Statement
  selStmt     SelectStatement
  byt         byte
  bytes       []byte
  bytes2      [][]byte
  str         string
  selectExprs SelectExprs
  selectExpr  SelectExpr
  columns     Columns
  colName     *ColName
  tableExprs  TableExprs
  tableExpr   TableExpr
  smTableExpr SimpleTableExpr
  tableName   *TableName
  indexHints  *IndexHints
  expr        Expr
  boolExpr    BoolExpr
  valExpr     ValExpr
  tuple       Tuple
  ValTuple    ValTuple
  valExprs    ValExprs
  values      Values
  subquery    *Subquery
  caseExpr    *CaseExpr
  whens       []*When
  when        *When
  orderBy     OrderBy
  order       *Order
  limit       *Limit
  insRows     InsertRows
  updateExprs UpdateExprs
  updateExpr  *UpdateExpr

  Algorithm   *Algorithm
  Partnum     *Partnum
  PartKey     *PartKey

  DdlPartition  DdlPartition
  PartExpr      *PartExpr
  PartColumns   PartColumns
  PartValLess   PartValLess
  PartValIn     PartValIn
  PartValues    PartValues
  PartOptExprs  PartOptExprs
  PartInfos     PartInfos
  PartInfo      *PartInfo
  CreateField   *CreateField
  CreateFields  CreateFields
  DdlTableName  *DdlTableName
  AlterOption   AlterOption
  DdlString     DdlString
  CreateTable   *CreateTable
  read_pos      int
  LockTables    *LockTables 
  TblLocks      []*TblLock
  TblLock       *TblLock
  LockType      int
  SetExprs      SetExprs
}

%token LEX_ERROR
%token <empty> SELECT INSERT UPDATE DELETE FROM WHERE GROUP HAVING ORDER BY LIMIT FOR
%token <empty> ALL DISTINCT AS EXISTS IN IS LIKE BETWEEN NULL ASC DESC VALUES INTO  KEY DEFAULT SET LOCK TABLES READ WRITE UNLOCK
%token <bytes> ID STRING NUMBER VALUE_ARG COMMENT PARAM
%token <empty> LE GE NE NULL_SAFE_EQUAL
%token <empty> '(' '=' '<' '>' '~'

%left <empty> UNION MINUS EXCEPT INTERSECT
%left <empty> ','
%left <empty> JOIN STRAIGHT_JOIN LEFT RIGHT INNER OUTER CROSS NATURAL USE FORCE
%left <empty> ON
%left <empty> AND OR
%right <empty> NOT
%left <empty> '&' '|' '^'
%left <empty> '+' '-'
%left <empty> '*' '/' '%'
%nonassoc <empty> '.'
%left <empty> UNARY
%right <empty> CASE, WHEN, THEN, ELSE
%left  <bytes> END



// Replace
%token <empty> REPLACE

// admin
%token <empty>  ADMIN 

//collate
%token <empty> COLLATE

// DDL Tokens
%token <empty> CREATE ALTER DROP RENAME
%token <empty> TABLE INDEX  TO IGNORE IF UNIQUE USING

// CREATETABLE Token

%token <bytes>  DATABASE SCHAME INT TINYINT SMALLINT MEDIUMINT BIGINT REAL DOUBLE FLOAT
    	          BIT BOOL BOOLEAN CHAR NCHAR VARBINARY NVARCHAR TINYBLOB BLOB 
                MEDIUMBLOB LONGBLOB TINYTEXT TEXT MEDIUMTEXT LONGTEXT DECIMAL NUMERIC
    	          FIXED ENUM SERIAL VARCHAR  BINARY UNICODE BYTE YEAR DATE TIME
                TIMESTAMP DATETIME NOW DATA LESS COMMENT_TOKEN
                TRUE FALSE SIGNED UNSIGNED ZEROFILL PRECISION NATIONAL CHARSET VARYING
                LONG GEOMETRY POINT MULTIPOINT LINESTRING POLYGON VALUE PRIMARY DYNAMIC
    	          STORAGE DISK MEMORY REFERENCES MATCH FULL PARTIAL SIMPLE RESTRICT CASCADE
    		        NO ACTION TYPE HASH BTREE RTREE FULLTEXT INDEXES WITH PARSER SPATIAL
    	          FOREIGN ENGINE LAST FIRST DIRECTORY LINEAR KEYS AFTER
                MAX_ROWS MIN_ROWS PASSWORD PACK_KEYS CHECKSUM CHECK ROW_FORMAT COMPRESSED
                REDUNDANT COMPACT TABLESPACE CONNECTION ALGORITHM RANGE LIST COLUMNS THAN
                MAX_VALUE NODEGROUP PARTITION PARTITIONING PARTITIONS SUBPARTITION SUBPARTITIONS
                AVG_ROW_LENGTH GEOMETRYCOLLECTION MULTILINESTRING MULTIPOLYGON AUTO_INC COLUMN_FORMAT
                STATS_AUTO_RECALC STATS_PERSISTENT STATS_SAMPLE_PAGES TABLE_CHECKSUM DELAY_KEY_WRITE
                INSERT_METHOD KEY_BLOCK_SIZE CONSTRAINT
                ADD DISCARD IMPORT MODIFY DISABLE ENABLE CONVERT VALIDATION WITHOUT REBUILD
                OPTIMIZE ANALYZE REPAIR COALESCE TRUNCATE EXCHANGE REORGANIZE COLUMN CHANGE
                OFFSET NAMES BEGIN TRANSACTION COMMIT ROLLBACK START DUPLICATE HELP ASCII
                GENERATED ALWAYS VIRTUAL STORED GLOBAL SESSION LOCAL

%start any_command

%type <statement> command
%type <selStmt> select_statement
%type <statement> insert_statement update_statement delete_statement set_statement
%type <statement> create_statement alter_statement rename_statement drop_statement
%type <bytes2> comment_opt comment_list 
%type <str> union_op
%type <str> distinct_opt
%type <selectExprs> select_expression_list
%type <selectExpr> select_expression 
%type <bytes> as_lower_opt as_opt ident_or_text 
%type <expr> expression
%type <tableExprs> table_expression_list
%type <tableExpr> table_expression
%type <str> join_type
%type <smTableExpr> simple_table_expression
%type <tableName> dml_table_expression
%type <indexHints> index_hint_list
%type <bytes2> index_list
%type <boolExpr> where_expression_opt
%type <boolExpr> boolean_expression condition
%type <str> compare
%type <insRows> row_list
%type <valExpr> value  value_expression
%type <tuple> tuple
%type <valExprs> value_expression_list 
%type <values> tuple_list
%type <bytes> keyword_as_func
%type <subquery> subquery
%type <byt> unary_operator
%type <colName> column_name
%type <caseExpr> case_expression
%type <whens> when_expression_list
%type <when> when_expression
%type <valExpr> value_expression_opt else_expression_opt
%type <valExprs> group_by_opt
%type <boolExpr> having_opt
%type <orderBy> order_by_opt order_list
%type <order> order
%type <str> asc_desc_opt
%type <limit> limit_opt
%type <str> lock_opt
%type <columns> column_list_opt column_list
%type <updateExprs> on_dup_opt
%type <updateExprs> update_list
%type <updateExpr> update_expression
%type <empty>   ignore_opt to_opt constraint_opt using_opt
%type <bytes> sql_id keyword u_id
%type <empty> force_eof

%type <statement> begin_statement commit_statement rollback_statement
%type <statement> replace_statement
%type <statement> admin_statement
%type <statement> use_statement
%type <statement> lock_table_statement
%type <statement> unlock_table_statement

%type <str>  not_exists_opt opt_linear  option_type opt_option_type
%type <str> type int_type spatial_type real_type nchar nvarchar varchar long_varchar
%type <CreateField> field_spec column_def field_list_item
%type <CreateFields> create_field_list create_table_def create_item_list
%type <PartKey>  opt_sub_part part_type_def
%type <DdlPartition>  opt_create_partitioning
%type <Partnum> opt_num_parts opt_num_subparts
%type <Algorithm> opt_key_algo
%type <PartColumns> part_field_item_list part_column_list part_field_list
%type <PartExpr> part_expr
%type <colName> part_column_name 
%type <PartValLess> part_func_max
%type <PartValIn> part_values_in part_value_list
%type <PartValues> opt_part_values
%type <ValTuple> part_value_item
%type <valExprs> part_value_item_list  
%type <valExpr> part_value_expr_item 
%type <PartOptExprs> opt_part_options opt_part_option_list
%type <PartInfos> part_def_list opt_part_defs
%type <PartInfo> part_definition 
%type <updateExpr> opt_part_option
%type <bytes>  opt_place
%type <DdlTableName> ddl_table_id
%type <AlterOption> alter_operation 
%type <DdlString> opt_on_uddb  exists_opt_pos not_exists_opt_pos
%type <CreateTable> create_table
%type <read_pos> read_pos read_last_pos
%type <TblLocks> table_locks
%type <TblLock> table_lock
%type <LockType> lock_type 

%type <SetExprs> no_option_type_option_value option_value_list_continued option_value_list option_value

%%

any_command:
  command
  {
    SetParseTree(yylex, $1)
  }

command:
  select_statement
  {
    $$ = $1
  }
| insert_statement
| update_statement
| delete_statement
| set_statement
| create_statement
| alter_statement
| rename_statement
| drop_statement
| begin_statement
| commit_statement
| rollback_statement
| replace_statement
| admin_statement
| use_statement
| lock_table_statement
| unlock_table_statement

select_statement:
  SELECT comment_opt distinct_opt select_expression_list
  {
    $$ = &SimpleSelect{Comments: Comments($2), Distinct: $3, SelectExprs: $4, ParamList: yylex.(*Tokenizer).ParamList}
  }
| SELECT comment_opt distinct_opt select_expression_list FROM table_expression_list where_expression_opt group_by_opt having_opt order_by_opt limit_opt lock_opt
  {
    $$ = &Select{Comments: Comments($2), Distinct: $3, SelectExprs: $4, From: $6, Where: NewWhere(AST_WHERE, $7), GroupBy: GroupBy($8), Having: NewWhere(AST_HAVING, $9), OrderBy: $10, Limit: $11, Lock: $12, ParamList: yylex.(*Tokenizer).ParamList}
  }
| select_statement union_op select_statement %prec UNION
  {
    $$ = &Union{Type: $2, Left: $1, Right: $3}
  }


insert_statement:
  INSERT comment_opt INTO dml_table_expression column_list_opt row_list on_dup_opt
  {
    $$ = &Insert{Comments: Comments($2), Table: $4, Columns: $5, Rows: $6, OnDup: OnDup($7), ParamList: yylex.(*Tokenizer).ParamList}
  }
| INSERT comment_opt INTO dml_table_expression SET update_list on_dup_opt
  {
    cols := make(Columns, 0, len($6))
    vals := make(ValTuple, 0, len($6))
    for _, col := range $6 {
      cols = append(cols, &NonStarExpr{Expr: col.Name})
      vals = append(vals, col.Expr)
    }
    $$ = &Insert{Comments: Comments($2), Table: $4, Columns: cols, Rows: Values{vals}, OnDup: OnDup($7), ParamList: yylex.(*Tokenizer).ParamList}
  }

replace_statement:
  REPLACE comment_opt INTO dml_table_expression column_list_opt row_list
  {
    $$ = &Replace{Comments: Comments($2), Table: $4, Columns: $5, Rows: $6,ParamList: yylex.(*Tokenizer).ParamList}
  }
| REPLACE comment_opt INTO dml_table_expression SET update_list
  {
    cols := make(Columns, 0, len($6))
    vals := make(ValTuple, 0, len($6))
    for _, col := range $6 {
      cols = append(cols, &NonStarExpr{Expr: col.Name})
      vals = append(vals, col.Expr)
    }
    $$ = &Replace{Comments: Comments($2), Table: $4, Columns: cols, Rows: Values{vals},ParamList: yylex.(*Tokenizer).ParamList}
  }


update_statement:
  UPDATE comment_opt dml_table_expression SET update_list where_expression_opt order_by_opt limit_opt
  {
    $$ = &Update{Comments: Comments($2), Table: $3, Exprs: $5, Where: NewWhere(AST_WHERE, $6), OrderBy: $7, Limit: $8,ParamList: yylex.(*Tokenizer).ParamList}
  }

delete_statement:
  DELETE comment_opt FROM dml_table_expression where_expression_opt order_by_opt limit_opt
  {
    $$ = &Delete{Comments: Comments($2), Table: $4, Where: NewWhere(AST_WHERE, $5), OrderBy: $6, Limit: $7,ParamList: yylex.(*Tokenizer).ParamList}
  }

set_statement:
  SET comment_opt no_option_type_option_value option_value_list_continued
  {
      if len($4) != 0 {
          $3 = append($3,$4...)
      }
      $$ = &Set{Comments: Comments($2), SetExprs: $3}  
  }

| SET comment_opt option_type update_expression option_value_list_continued
  {
    tmpSet := SetExprs{&SetOption{Opttype:$3, Expr:$4}}
    if len($5) != 0 {
        tmpSet = append(tmpSet,$5...)
    }
    $$ = &Set{Comments: Comments($2), SetExprs: tmpSet}    
  }


no_option_type_option_value:
  update_expression 
  {
    $$ =  SetExprs{&SetOption{Opttype:OPTION_SESSION, Expr:$1}} 
  }
|  NAMES value_expression 
  {
    $$ =  SetExprs{&SetOption{Opttype:OPTION_SESSION, Expr:&UpdateExpr{Name: &ColName{Name:[]byte("names")}, Expr: $2}}}
  }
| NAMES value_expression COLLATE value_expression
  {
    $$ = SetExprs{&SetOption{Opttype:OPTION_SESSION, Expr :&UpdateExpr{ Name: &ColName{Name:[]byte("names")}, Expr: $2}},
                   &SetOption{Opttype:OPTION_SESSION, Expr :&UpdateExpr{ Name: &ColName{Name:[]byte("collate")}, Expr: $4}},
                 }
  }
| '@' ident_or_text equal value_expression
  {
      $$ =  SetExprs{&SetOption{Opttype:OPTION_SESSION, Expr:&UpdateExpr{Name: &ColName{Name:$2}, Expr: $4}},}
  }
| '@' '@'  opt_option_type update_expression
  {
    $$ =  SetExprs{&SetOption{Opttype:$3, Expr:$4},}
  }


option_value_list_continued:
    /* empty */           { $$= SetExprs{} }
  | ',' option_value_list { $$= $2 }


option_value_list:
  option_value
  {
    $$= $1
  }
| option_value_list ',' option_value
  {
     $$= append($1,$3...)
  }


option_value:
  option_type update_expression
  {
    $$ =  SetExprs{&SetOption{Opttype:$1, Expr:$2}}
  }
| no_option_type_option_value { $$= $1 }




option_type:
  GLOBAL  { $$=OPTION_GLOBAL}
| LOCAL   { $$=OPTION_SESSION }
| SESSION { $$=OPTION_SESSION }


opt_option_type:
  /* empty */ { $$=OPTION_SESSION }
| GLOBAL '.'  { $$=OPTION_GLOBAL }
| LOCAL '.'   { $$=OPTION_SESSION }
| SESSION '.' { $$=OPTION_SESSION }





begin_statement:
  BEGIN
  {
    $$ = &Begin{}
  }
| START TRANSACTION
  {
    $$ = &Begin{}
  }


commit_statement:
  COMMIT
  {
    $$ = &Commit{}
  }

rollback_statement:
  ROLLBACK
  {
    $$ = &Rollback{}
  }

admin_statement:
  ADMIN dml_table_expression column_list_opt row_list
  {
    $$ = &Admin{Region : $2, Columns : $3,Rows:$4}
  }
| ADMIN HELP
  {
    $$ = &AdminHelp{}
  }

use_statement:
  USE sql_id
  {
	$$= &UseDB{DB : string($2)}
  }

create_statement:
  CREATE DATABASE not_exists_opt_pos u_id opt_on_uddb opt_create_database_options
  {
    $$ = &DbDdl{Action: AST_CREATE, Existed: string($3.String), DbName: $4, UdbId: $5.String, ReBefore: ReadBefore(yylex,$3.Pos), ReAfter:ReadAfter(yylex,$5.Pos)}
  }
| CREATE SCHAME not_exists_opt_pos u_id opt_on_uddb opt_create_database_options
  {
    $$ = &DbDdl{Action: AST_CREATE, Existed:string($3.String), DbName: $4, UdbId: $5.String, ReBefore: ReadBefore(yylex,$3.Pos), ReAfter:ReadAfter(yylex,$5.Pos)}
  }
| CREATE TABLE not_exists_opt  create_table  
  {
     $4.Existed = $3
     $$ = $4
  }
| CREATE constraint_opt INDEX sql_id using_opt ON read_pos ddl_table_id '(' force_eof
  {
    $$ = &TableDdl{Action: AST_CREATE, Table: $8.Table, ReBefore: ReadBefore(yylex,$7), ReAfter:ReadAfter(yylex,$8.Pos)}
  }


alter_statement:
  ALTER DATABASE read_pos u_id read_pos create_database_options
  {
    $$ = &DbDdl{Action: AST_ALTER, DbName: $4, ReBefore: ReadBefore(yylex,$3), ReAfter: ReadAfter(yylex, $5)}
  }
| ALTER SCHAME read_pos u_id read_pos create_database_options
  {
    $$ = &DbDdl{Action: AST_ALTER, DbName: $4,  ReBefore: ReadBefore(yylex,$3), ReAfter: ReadAfter(yylex, $5)}
  }
| ALTER ignore_opt TABLE read_pos ddl_table_id alter_operation force_eof
  {
    $$ = &AlterTable{Table: $5.Table, Option: $6, ReBefore: ReadBefore(yylex,$4), ReAfter:ReadAfter(yylex,$5.Pos)}
  }


rename_statement:
  RENAME TABLE ddl_table_id TO ddl_table_id
  {
    var opt AlterOption
    opt = &RenameTable{NewTable: $5.Table}
    $$ = &AlterTable{Table: $3.Table, Option: opt, ReBefore: []byte("rename table "), ReAfter:ReadAfter(yylex,$3.Pos)}
  }

drop_statement:
  DROP DATABASE exists_opt_pos u_id read_pos force_eof
  {
    $$ = &DbDdl{Action: AST_DROP, Existed:string($3.String), DbName: $4, ReBefore: ReadBefore(yylex,$3.Pos), ReAfter:ReadAfter(yylex,$5)}
  }
| DROP SCHAME  exists_opt_pos u_id read_pos force_eof
  {
    $$ = &DbDdl{Action: AST_DROP, Existed:string($3.String),  DbName: $4, ReBefore: ReadBefore(yylex,$3.Pos), ReAfter:ReadAfter(yylex,$5)}
  }
| DROP TABLE exists_opt_pos ddl_table_id force_eof
  {
    $$ = &TableDdl{Action: AST_DROPTABLE, Existed:string($3.String), Table: $4.Table, ReBefore: ReadBefore(yylex,$3.Pos), ReAfter:ReadAfter(yylex,$4.Pos)}
  }
| DROP INDEX sql_id ON read_pos ddl_table_id opt_index_lock_algorithm force_eof
  {
    $$ = &TableDdl{Action: AST_DROP, Table: $6.Table, ReBefore: ReadBefore(yylex,$5), ReAfter:ReadAfter(yylex,$6.Pos)}
  }


comment_opt:
  {
    SetAllowComments(yylex, true)
  }
  comment_list
  {
    $$ = $2
    SetAllowComments(yylex, false)
  }

comment_list:
  {
    $$ = nil
  }
| comment_list COMMENT
  {
    $$ = append($1, $2)
  }

union_op:
  UNION
  {
    $$ = AST_UNION
  }
| UNION ALL
  {
    $$ = AST_UNION_ALL
  }
| MINUS
  {
    $$ = AST_SET_MINUS
  }
| EXCEPT
  {
    $$ = AST_EXCEPT
  }
| INTERSECT
  {
    $$ = AST_INTERSECT
  }

distinct_opt:
  {
    $$ = ""
  }
| DISTINCT
  {
    $$ = AST_DISTINCT
  }

select_expression_list:
  select_expression
  {
    $$ = SelectExprs{$1}
  }
| select_expression_list ',' select_expression
  {
    $$ = append($$, $3)
  }

select_expression:
  '*'
  {
    $$ = &StarExpr{}
  }
| expression as_lower_opt
  {
    $$ = &NonStarExpr{Expr: $1, As: $2}
  }
| u_id '.' '*'
  {
    $$ = &StarExpr{TableName: $1}
  }

expression:
  boolean_expression
  {
    $$ = $1
  }
| value_expression
  {
    $$ = $1
  }

as_lower_opt:
  {
    $$ = nil
  }
| sql_id
  {
    $$ = $1
  }
| AS sql_id
  {
    $$ = $2
  }

table_expression_list:
  table_expression
  {
    $$ = TableExprs{$1}
  }
| table_expression_list ',' table_expression
  {
    $$ = append($$, $3)
  }

table_expression:
  simple_table_expression as_opt index_hint_list
  {
    $$ = &AliasedTableExpr{Expr:$1, As: $2, Hints: $3}
  }
| '(' table_expression ')'
  {
    $$ = &ParenTableExpr{Expr: $2}
  }
| table_expression join_type table_expression %prec JOIN
  {
    $$ = &JoinTableExpr{LeftExpr: $1, Join: $2, RightExpr: $3}
  }
| table_expression join_type table_expression ON boolean_expression %prec JOIN
  {
    $$ = &JoinTableExpr{LeftExpr: $1, Join: $2, RightExpr: $3, On: $5}
  }

as_opt:
  {
    $$ = nil
  }
| u_id
  {
    $$ = $1
  }
| AS u_id
  {
    $$ = $2
  }

join_type:
  JOIN
  {
    $$ = AST_JOIN
  }
| STRAIGHT_JOIN
  {
    $$ = AST_STRAIGHT_JOIN
  }
| LEFT JOIN
  {
    $$ = AST_LEFT_JOIN
  }
| LEFT OUTER JOIN
  {
    $$ = AST_LEFT_JOIN
  }
| RIGHT JOIN
  {
    $$ = AST_RIGHT_JOIN
  }
| RIGHT OUTER JOIN
  {
    $$ = AST_RIGHT_JOIN
  }
| INNER JOIN
  {
    $$ = AST_JOIN
  }
| CROSS JOIN
  {
    $$ = AST_CROSS_JOIN
  }
| NATURAL JOIN
  {
    $$ = AST_NATURAL_JOIN
  }

simple_table_expression:
u_id
  {
    $$ = &TableName{Name: $1}
  }
| u_id '.' u_id
  {
    $$ = &TableName{Qualifier: $1, Name: $3}
  }
| subquery
  {
    $$ = $1
  }

dml_table_expression:
u_id
  {
    $$ = &TableName{Name: $1}
  }
| u_id '.' u_id
  {
    $$ = &TableName{Qualifier: $1, Name: $3}
  }

index_hint_list:
  {
    $$ = nil
  }
| USE INDEX '(' index_list ')'
  {
    $$ = &IndexHints{Type: AST_USE, Indexes: $4}
  }
| IGNORE INDEX '(' index_list ')'
  {
    $$ = &IndexHints{Type: AST_IGNORE, Indexes: $4}
  }
| FORCE INDEX '(' index_list ')'
  {
    $$ = &IndexHints{Type: AST_FORCE, Indexes: $4}
  }

index_list:
  sql_id
  {
    $$ = [][]byte{$1}
  }
| index_list ',' sql_id
  {
    $$ = append($1, $3)
  }

where_expression_opt:
  {
    $$ = nil
  }
| WHERE boolean_expression
  {
    $$ = $2
  }

boolean_expression:
  condition
| boolean_expression AND boolean_expression
  {
    $$ = &AndExpr{Left: $1, Right: $3}
  }
| boolean_expression OR boolean_expression
  {
    $$ = &OrExpr{Left: $1, Right: $3}
  }
| NOT boolean_expression
  {
    $$ = &NotExpr{Expr: $2}
  }
| '(' boolean_expression ')'
  {
    $$ = &ParenBoolExpr{Expr: $2}
  }

condition:
  value_expression compare value_expression
  {
    $$ = &ComparisonExpr{Left: $1, Operator: $2, Right: $3}
  }
| value_expression IN tuple
  {
    $$ = &ComparisonExpr{Left: $1, Operator: AST_IN, Right: $3}
  }
| value_expression NOT IN tuple
  {
    $$ = &ComparisonExpr{Left: $1, Operator: AST_NOT_IN, Right: $4}
  }
| value_expression LIKE value_expression
  {
    $$ = &ComparisonExpr{Left: $1, Operator: AST_LIKE, Right: $3}
  }
| value_expression NOT LIKE value_expression
  {
    $$ = &ComparisonExpr{Left: $1, Operator: AST_NOT_LIKE, Right: $4}
  }
| value_expression BETWEEN value_expression AND value_expression
  {
    $$ = &RangeCond{Left: $1, Operator: AST_BETWEEN, From: $3, To: $5}
  }
| value_expression NOT BETWEEN value_expression AND value_expression
  {
    $$ = &RangeCond{Left: $1, Operator: AST_NOT_BETWEEN, From: $4, To: $6}
  }
| value_expression IS NULL
  {
    $$ = &NullCheck{Operator: AST_IS_NULL, Expr: $1}
  }
| value_expression IS NOT NULL
  {
    $$ = &NullCheck{Operator: AST_IS_NOT_NULL, Expr: $1}
  }
| EXISTS subquery
  {
    $$ = &ExistsExpr{Subquery: $2}
  }

compare:
  '='
  {
    $$ = AST_EQ
  }
| '<'
  {
    $$ = AST_LT
  }
| '>'
  {
    $$ = AST_GT
  }
| LE
  {
    $$ = AST_LE
  }
| GE
  {
    $$ = AST_GE
  }
| NE
  {
    $$ = AST_NE
  }
| NULL_SAFE_EQUAL
  {
    $$ = AST_NSE
  }

row_list:
  VALUES tuple_list
  {
    $$ = $2
  }
| select_statement
  {
    $$ = $1
  }

tuple_list:
  tuple
  {
    $$ = Values{$1}
  }
| tuple_list ',' tuple
  {
    $$ = append($1, $3)
  }

tuple:
  '(' value_expression_list ')'
  {
    $$ = ValTuple($2)
  }
| subquery
  {
    $$ = $1
  }

subquery:
  '(' select_statement ')'
  {
    $$ = &Subquery{$2}
  }

value_expression_list:
  value_expression
  {
    $$ = ValExprs{$1}
  }
| value_expression_list ',' value_expression
  {
    $$ = append($1, $3)
  }

value_expression:
  value
  {
    $$ = $1
  }
| column_name
  {
    $$ = $1
  }
| tuple
  {
    $$ = $1
  }
| value_expression '&' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_BITAND, Right: $3}
  }
| value_expression '|' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_BITOR, Right: $3}
  }
| value_expression '^' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_BITXOR, Right: $3}
  }
| value_expression '+' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_PLUS, Right: $3}
  }
| value_expression '-' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_MINUS, Right: $3}
  }
| value_expression '*' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_MULT, Right: $3}
  }
| value_expression '/' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_DIV, Right: $3}
  }
| value_expression '%' value_expression
  {
    $$ = &BinaryExpr{Left: $1, Operator: AST_MOD, Right: $3}
  }
| unary_operator value_expression %prec UNARY
  {
    if num, ok := $2.(NumVal); ok {
      switch $1 {
      case '-':
        $$ = append(NumVal("-"), num...)
      case '+':
        $$ = num
      default:
        $$ = &UnaryExpr{Operator: $1, Expr: $2}
      }
    } else {
      $$ = &UnaryExpr{Operator: $1, Expr: $2}
    }
  }
| sql_id '(' ')'
  {
    $$ = &FuncExpr{Name: $1}
  }
| sql_id '(' select_expression_list ')'
  {
    $$ = &FuncExpr{Name: $1, Exprs: $3}
  }
| sql_id '(' DISTINCT select_expression_list ')'
  {
    $$ = &FuncExpr{Name: $1, Distinct: true, Exprs: $4}
  }
| keyword_as_func '(' select_expression_list ')'
  {
    $$ = &FuncExpr{Name: $1, Exprs: $3}
  }
| case_expression
  {
    $$ = $1
  }

keyword_as_func:
  IF
  {
    $$ = IF_BYTES
  }
| VALUES
  {
    $$ = VALUES_BYTES
  }

unary_operator:
  '+'
  {
    $$ = AST_UPLUS
  }
| '-'
  {
    $$ = AST_UMINUS
  }
| '~'
  {
    $$ = AST_TILDA
  }

case_expression:
  CASE value_expression_opt when_expression_list else_expression_opt END
  {
    $$ = &CaseExpr{Expr: $2, Whens: $3, Else: $4}
  }

value_expression_opt:
  {
    $$ = nil
  }
| value_expression
  {
    $$ = $1
  }

when_expression_list:
  when_expression
  {
    $$ = []*When{$1}
  }
| when_expression_list when_expression
  {
    $$ = append($1, $2)
  }

when_expression:
  WHEN boolean_expression THEN value_expression
  {
    $$ = &When{Cond: $2, Val: $4}
  }

else_expression_opt:
  {
    $$ = nil
  }
| ELSE value_expression
  {
    $$ = $2
  }

column_name:
  sql_id
  {
    $$ = &ColName{Name: $1}
  }
| u_id '.' sql_id
  {
    $$ = &ColName{Qualifier: $1, Name: $3}
  }

value:
  STRING
  {
    $$ = StrVal($1)
  }
| NUMBER
  {
    $$ = NumVal($1)
  }
| VALUE_ARG
  {
    $$ = ValArg($1)
  }
| NULL
  {
    $$ = &NullVal{}
  }
| PARAM
  {
    $$ = &Param{Expr:ParVal($1)}
    AddParam(yylex,$$.(*Param))
  }

group_by_opt:
  {
    $$ = nil
  }
| GROUP BY value_expression_list
  {
    $$ = $3
  }

having_opt:
  {
    $$ = nil
  }
| HAVING boolean_expression
  {
    $$ = $2
  }

order_by_opt:
  {
    $$ = nil
  }
| ORDER BY order_list
  {
    $$ = $3
  }

order_list:
  order
  {
    $$ = OrderBy{$1}
  }
| order_list ',' order
  {
    $$ = append($1, $3)
  }

order:
  value_expression asc_desc_opt
  {
    $$ = &Order{Expr: $1, Direction: $2}
  }

asc_desc_opt:
  {
    $$ = AST_ASC
  }
| ASC
  {
    $$ = AST_ASC
  }
| DESC
  {
    $$ = AST_DESC
  }

limit_opt:
  {
    $$ = nil
  }
| LIMIT value_expression
  {
    $$ = &Limit{Rowcount: $2}
  }
| LIMIT value_expression ',' value_expression
  {
    $$ = &Limit{Offset: $2, Rowcount: $4}
  }
| LIMIT value_expression OFFSET value_expression
  {
	$$ = &Limit{Offset: $4, Rowcount: $2}
  }

lock_opt:
  {
    $$ = ""
  }
| FOR UPDATE
  {
    $$ = AST_FOR_UPDATE
  }
| LOCK IN sql_id sql_id
  {
    if !bytes.Equal($3, SHARE) {
      yylex.Error("expecting share")
      return 1
    }
    if !bytes.Equal($4, MODE) {
      yylex.Error("expecting mode")
      return 1
    }
    $$ = AST_SHARE_MODE
  }

column_list_opt:
  {
    $$ = nil
  }
| '(' column_list ')'
  {
    $$ = $2
  }

column_list:
  column_name
  {
    $$ = Columns{&NonStarExpr{Expr: $1}}
  }
| column_list ',' column_name
  {
    $$ = append($$, &NonStarExpr{Expr: $3})
  }

on_dup_opt:
  {
    $$ = nil
  }
| ON DUPLICATE KEY UPDATE update_list
  {
    $$ = $5
  }

update_list:
  update_expression
  {
    $$ = UpdateExprs{$1}
  }
| update_list ',' update_expression
  {
    $$ = append($1, $3)
  }

update_expression:
  column_name '=' value_expression
  {
    $$ = &UpdateExpr{Name: $1, Expr: $3} 
  }



not_exists_opt:
  { $$ = "" }
| IF NOT EXISTS
  { $$ = U_EXIST_NOT }

ignore_opt:
  { $$ = struct{}{} }
| IGNORE
  { $$ = struct{}{} }



create_table_options_space_separated:
  create_table_option {}
| create_table_option create_table_options_space_separated {}



alter_operation:
  ADD opt_column sql_id type opt_place
  {
      $$ = &AddColumn{FieldName: $3, FieldType: $4, FieldPlace: $5}
  }
| ADD opt_column '(' create_field_list ')'
  {
      $$ = &AddColumns{Fields: $4}
  }
| DROP opt_column sql_id  
  {
     $$ = &DropColumn{FieldName: $3}
  }
| CHANGE opt_column sql_id sql_id type opt_attribute opt_place  
  { 
    $$ = &ChangeColumn{OldName:$3, NewName: $4, NewType: $5, FieldPlace: $7} 
  }
| MODIFY opt_column sql_id type opt_attribute opt_place
  { 
    $$ = &ChangeColumn{NewName: $3, NewType: $4, FieldPlace: $6} 
  }
| ADD key_def { $$ = &AlterOther{} }
| DROP FOREIGN KEY  { $$ = &AlterOther{} }
| DROP PRIMARY KEY  { $$ = &AlterOther{} }
| DROP normal_key_type  { $$ = &AlterOther{} }
| DISCARD TABLESPACE  { $$ = &AlterOther{} }
| IMPORT TABLESPACE  { $$ = &AlterOther{} }
| DISABLE KEYS  { $$ = &AlterOther{} }
| ENABLE KEYS { $$ = &AlterOther{} }
| ALTER opt_column  sql_id SET DEFAULT signed_literal { $$ = &AlterOther{} }
| ALTER opt_column  sql_id DROP DEFAULT { $$ = &AlterOther{} }
| RENAME normal_key_type  { $$ = &AlterOther{} }
| CONVERT TO  { $$ = &AlterOther{} }
| FORCE  { $$ = &AlterOther{} }
| create_table_options_space_separated  { $$ = &AlterOther{} }
| ORDER BY  { $$ = &AlterOther{} }
| ALGORITHM  { $$ = &AlterOther{} }
| LOCK  { $$ = &AlterOther{} }
| WITH VALIDATION  { $$ = &AlterOther{} }
| WITHOUT VALIDATION { $$ = &AlterOther{} }
| ADD PARTITION { $$ = &AlterPartition{} }
| DROP PARTITION { $$ = &AlterPartition{} }
| REBUILD PARTITION { $$ = &AlterPartition{} }
| OPTIMIZE PARTITION { $$ = &AlterPartition{} }
| ANALYZE PARTITION { $$ = &AlterPartition{} }
| CHECK PARTITION { $$ = &AlterPartition{} }
| REPAIR PARTITION { $$ = &AlterPartition{} }
| COALESCE PARTITION { $$ = &AlterPartition{} }
| TRUNCATE PARTITION { $$ = &AlterPartition{} }
| EXCHANGE PARTITION { $$ = &AlterPartition{} }
| DISCARD PARTITION { $$ = &AlterPartition{} }
| IMPORT PARTITION { $$ = &AlterPartition{} }
| REORGANIZE PARTITION  { $$ = &AlterPartition{} }
| RENAME to_opt ddl_table_id 
  {
     $$ = &RenameTable{NewTable: $3.Table}
  }


opt_place:
  /* empty */ 
  {
     $$ = []byte{}
  }
| AFTER sql_id 
  {
     $$ = $2

     
  }
| FIRST
  {
     $$ = []byte("first key")
  }
        


  opt_column:
    {}
  | COLUMN {}

to_opt:
  { $$ = struct{}{} }
| TO
  { $$ = struct{}{} }
| AS
  { $$ = struct{}{} }

constraint_opt:
  { $$ = struct{}{} }
| UNIQUE
  { $$ = struct{}{} }

using_opt:
  { $$ = struct{}{} }
| USING sql_id
  { $$ = struct{}{} }

sql_id:
  u_id
  {
    $$ = bytes.ToLower($1)
  }

force_eof:
{
  ForceEOF(yylex)
}




ddl_table_id:
u_id
  {
    $$ = &DdlTableName{Table: &TableName{Name: $1}, Pos: ReadLastPos(yylex)}
  }
| u_id '.' u_id
  {
    $$ = &DdlTableName{Table: &TableName{Qualifier: $1, Name: $3}, Pos: ReadPos(yylex)}

  }
| '.' u_id
  {
    $$ = &DdlTableName{Table: &TableName{Name: $2}, Pos: ReadLastPos(yylex)}
  }


create_table:
  ddl_table_id create_table_def read_last_pos opt_create_partitioning
  {
     $$ = &CreateTable{Table: $1.Table, CreateFields:$2, Partitions: $4.Partitions, Remain: ReadSql(yylex,$1.Pos,$3)}
  }
| ddl_table_id LIKE ddl_table_id
  {
     $$ = &CreateTable{Table: $1.Table, LikeTable: $3.Table}
  }
| ddl_table_id'(' LIKE ddl_table_id ')'
  {
      $$ = &CreateTable{Table: $1.Table, LikeTable: $4.Table}
  }


create_table_def:
'(' create_item_list')' opt_create_table_options { $$=$2 }


create_item_list:
  field_list_item 
  { 
    if $1 != nil {
      $$ = CreateFields {$1} 
    }
  }
| create_item_list ',' field_list_item 
  {
    if $3 != nil {
      $$ =append($1,$3)
    }
  }

create_field_list:
  column_def 
  {
      $$ = CreateFields {$1} 
  }
| create_field_list ',' column_def
  {
      $$ =append($1,$3)
  }

field_list_item:
  column_def { $$ = $1 }
| key_def { $$ = nil }


column_def:
  field_spec opt_check_constraint {$$ = $1}
| field_spec references {$$ = $1}

field_spec:
  sql_id type opt_attribute 
  {
      $$ = &CreateField{FieldName: $1, FieldType: $2}
  }
| sql_id type  opt_collate_explicit opt_generated_always AS '(' value_expression ')' opt_stored_attribute opt_gcol_attribute_list 
  {
      $$ = &CreateField{FieldName: $1, FieldType: $2}
  }

opt_collate_explicit:
  /* empty */ {  }
| COLLATE collation_name { }


collation_name:
  ident_or_text { }

opt_generated_always:
  /* empty */ {}
| GENERATED ALWAYS {}
        
opt_stored_attribute:
  /* empty */ {}
| VIRTUAL     {}
| STORED      {}

opt_gcol_attribute_list:
  /* empty */           {}
| gcol_attribute_list   {}


gcol_attribute_list:
  gcol_attribute_list gcol_attribute {}
| gcol_attribute {}


gcol_attribute:
  UNIQUE         {}
| UNIQUE KEY     {}
| COMMENT_TOKEN STRING {}
| NOT NULL       {}
| NULL             {}
| opt_primary KEY  {}


type:
  int_type opt_field_length field_options { $$=$1 }
| real_type opt_precision field_options { $$=$1 }
| FLOAT float_options field_options { $$=U_COLTYPE_FLOAT }
| BIT { $$=U_COLTYPE_BIT }
| BIT field_length { $$=U_COLTYPE_BIT }
| BOOL { $$=U_COLTYPE_BOOL }
| BOOLEAN { $$=U_COLTYPE_BOOLEAN }
| CHAR field_length opt_binary { $$=U_COLTYPE_CHAR }
| CHAR opt_binary { $$=U_COLTYPE_CHAR }
| nchar field_length opt_bin_mod { $$=$1 }
| nchar opt_bin_mod { $$=$1 }
| BINARY field_length { $$=U_COLTYPE_BINARY }
| BINARY { $$=U_COLTYPE_BINARY }
| varchar field_length opt_binary {$$=$1 }
| nvarchar field_length opt_bin_mod {$$=$1}
| VARBINARY field_length {$$=U_COLTYPE_VARBINARY}
| YEAR opt_field_length field_options {$$=U_COLTYPE_YEAR}
| DATE {$$=U_COLTYPE_DATE}
| TIME type_datetime_precision {$$=U_COLTYPE_TIME}
| TIMESTAMP type_datetime_precision {$$=U_COLTYPE_TIMESTAMP}
| DATETIME type_datetime_precision { $$=U_COLTYPE_DATETIME}
| TINYBLOB { $$=U_COLTYPE_TINYBLOB }
| BLOB opt_field_length { $$=U_COLTYPE_BLOB}
| spatial_type { $$ = $1}
| MEDIUMBLOB {$$=U_COLTYPE_MEDIUMBLOB}
| LONGBLOB {$$=U_COLTYPE_LONGBLOB}
| LONG VARBINARY {$$=U_COLTYPE_LONG_VARBINARY}
| long_varchar opt_binary { $$ = $1}
| TINYTEXT opt_binary {$$=U_COLTYPE_TINYTEXT}
| TEXT opt_field_length opt_binary {$$=U_COLTYPE_TEXT}
| MEDIUMTEXT opt_binary {$$ = U_COLTYPE_MEDIUMTEXT}
| LONGTEXT opt_binary {$$ = U_COLTYPE_LONGTEXT}
| DECIMAL float_options field_options {$$ = U_COLTYPE_DECIMAL}
| NUMERIC float_options field_options {$$ = U_COLTYPE_NUMERIC}
| FIXED float_options field_options {$$ = U_COLTYPE_FIXED}
| ENUM { $$ = U_COLTYPE_ENUM}
| SET {$$ = U_COLTYPE_SET}
| LONG opt_binary { $$ = U_COLTYPE_LONG}
| SERIAL { $$ = U_COLTYPE_SERIAL}


spatial_type:
  GEOMETRY        {$$ = U_COLTYPE_GEOMETRY}
| GEOMETRYCOLLECTION  { $$ = U_COLTYPE_GEOMETRYCOLLECTION}
| POINT { $$ = U_COLTYPE_POINT}
| MULTIPOINT          {$$ = U_COLTYPE_MULTIPOINT}
| LINESTRING          {$$ = U_COLTYPE_LINESTRING}
| MULTILINESTRING     {$$ = U_COLTYPE_MULTILINESTRING}
| POLYGON             {$$ = U_COLTYPE_POLYGON}
| MULTIPOLYGON        {$$ = U_COLTYPE_MULTIPOLYGON}


int_type:
  INT       { $$=U_COLTYPE_INT }
| TINYINT   { $$=U_COLTYPE_TINYINT }
| SMALLINT  { $$=U_COLTYPE_SMALLINT }
| MEDIUMINT { $$=U_COLTYPE_MEDIUMINT }
| BIGINT    { $$=U_COLTYPE_BIGINT }

opt_field_length:
  /* empty */  { }
| field_length { }

field_length:
  '(' NUMBER ')' {}

field_options:
  /* empty */ {}
| field_opt_list {}

field_opt_list:
  field_opt_list field_option {}
| field_option {}

field_option:
  SIGNED {}
| UNSIGNED {}
| ZEROFILL {}



real_type:
  REAL { $$=U_COLTYPE_REAL }
| DOUBLE { $$=U_COLTYPE_DOUBLE }
| DOUBLE PRECISION { $$=U_COLTYPE_DOUBLE_PRECISION }

opt_precision:
  {}
| precision {} 

precision:
  '(' NUMBER ',' NUMBER ')' {}


float_options:
  /* empty */ {}
| field_length {}
| precision {}

nchar:
  NCHAR {$$ = U_COLTYPE_NCHAR }
| NATIONAL CHAR { $$ = U_COLTYPE_NATIONNAL_NCHAR}


opt_binary:
 /* empty */ {}
| ascii {}
| unicode {}
| BYTE {}
| charset charset_name opt_bin_mod {}
| BINARY {}
| BINARY charset charset_name { }

ascii:
  ASCII {} 
| BINARY ASCII {}
| ASCII BINARY {}

unicode:
  UNICODE {}
| UNICODE BINARY  {}
| BINARY UNICODE  {}

charset:
  CHAR SET {}
| CHARSET {}

charset_name:
  u_id {}
| BINARY {}

opt_bin_mod:
  /* empty */ { }
| BINARY {}

long_varchar:
  LONG CHAR VARYING { $$=U_COLTYPE_LONG_CHAR_VARYING }
| LONG VARCHAR { $$= U_COLTYPE_LONG_VARCHAR }

varchar:
  CHAR VARYING { $$=U_COLTYPE_CHAR_VARYING }
| VARCHAR { $$= U_COLTYPE_VARCHAR }

nvarchar:
  NATIONAL VARCHAR { $$=U_COLTYPE_NATIONNAL_VARCHAR }
| NVARCHAR { $$=U_COLTYPE_NVARCHAR }
| NCHAR VARCHAR {$$=U_COLTYPE_NCHAR_VARCHAR}
| NATIONAL CHAR VARYING { $$=U_COLTYPE_NATIONNAL_CHAR_VARYING }
| NCHAR VARYING {$$=U_COLTYPE_NCHAR_VARYING}

type_datetime_precision:
  /* empty */                {}
| '(' NUMBER ')'             {}


opt_attribute:
  /* empty */ {}
| opt_attribute_list {}

opt_attribute_list:
  opt_attribute_list attribute {}
| attribute

attribute:
  NULL { }
| NOT NULL {}
| DEFAULT now_or_signed_literal {}
| ON UPDATE now {}
| AUTO_INC {}
| SERIAL DEFAULT VALUE { }
| opt_primary KEY { }
| UNIQUE { }
| UNIQUE KEY { }
| COMMENT_TOKEN STRING {}
| COLLATE ident_or_text { }
| COLUMN_FORMAT DEFAULT { }
| COLUMN_FORMAT FIXED { }
| COLUMN_FORMAT DYNAMIC { }
| STORAGE DEFAULT { }
| STORAGE DISK { }
| STORAGE MEMORY {}

now_or_signed_literal:
  now {}
| signed_literal {}

now:
  NOW func_datetime_precision { }

func_datetime_precision:
  /* empty */ {}
| '(' ')'     {}
| '(' NUMBER ')' {}

signed_literal:
  literal {}
| '+' NUM_literal {}
| '-' NUM_literal { }

literal:
  text_literal {  }
| NUM_literal {  }
| temporal_literal {}
| NULL { }
| FALSE { }
| TRUE { }
| NUMBER { }
| u_id NUMBER { }

NUM_literal:
  NUMBER {}

text_literal:
  STRING { }
| u_id STRING { }
| text_literal STRING { }

temporal_literal:
  DATE STRING { }
| TIME STRING { }
| TIMESTAMP STRING { }

opt_primary:
  /* empty */ {}
| PRIMARY {}


ident_or_text:
  u_id     
  {
    $$ = ($1)
  }
| STRING 
  {
    $$ = ($1)
  }


opt_check_constraint:
  /* empty */
| CHECK '(' expression ')'

          
references:
  REFERENCES ddl_table_id opt_ref_list opt_match_clause opt_on_update_delete {}
;


opt_ref_list:
  /* empty */ {}
| '(' ref_list ')' {}

ref_list:
  ref_list ',' u_id { }
| u_id {}

opt_match_clause:
  /* empty */ {}
| MATCH FULL {}
| MATCH PARTIAL {}
| MATCH SIMPLE {}

opt_on_update_delete:
  /* empty */{}
| ON UPDATE delete_option { }
| ON DELETE delete_option { }
| ON UPDATE delete_option ON DELETE delete_option { }
| ON DELETE delete_option ON UPDATE delete_option { }

delete_option:
  RESTRICT      {}
| CASCADE       {}
| SET NULL  {}
| NO ACTION {} 
| SET DEFAULT   {}


key_def:
  normal_key_type opt_ident key_alg '(' key_list ')' normal_key_options { }
| FULLTEXT opt_key_or_index opt_ident  '(' key_list ')' fulltext_key_options { }
| SPATIAL opt_key_or_index opt_ident  '(' key_list ')' spatial_key_options { }
| opt_constraint constraint_key_type opt_ident key_alg '(' key_list ')' normal_key_options { }
| opt_constraint FOREIGN KEY opt_ident '(' key_list ')' references { }
| opt_constraint CHECK '(' expression ')' { }

normal_key_type:
  KEY {}
| INDEX {}

opt_ident:
  /* empty */ {}
| u_id {}

key_alg:
  /* empty */ {}  
| key_using_alg {}

key_using_alg:
  USING btree_or_rtree {}
| TYPE btree_or_rtree  {}

btree_or_rtree:
  BTREE {}
| RTREE {}
| HASH  {}

key_list:
  key_list ',' key_part asc_desc_opt {}
| key_part asc_desc_opt {}

key_part:
  u_id { }
| u_id '(' NUMBER ')' { }

normal_key_options:
  /* empty */ {}
| normal_key_opts

normal_key_opts:
  normal_key_opt {}
| normal_key_opts normal_key_opt {}

normal_key_opt:
  all_key_opt {}
| key_using_alg {}

all_key_opt:
  KEY_BLOCK_SIZE opt_equal NUMBER {}
| COMMENT_TOKEN STRING { }

opt_key_or_index:
  /* empty */ {}
| normal_key_type {}


fulltext_key_options:
  /* empty */ {}
| fulltext_key_opts {}

fulltext_key_opts:
  fulltext_key_opt {}
| fulltext_key_opts fulltext_key_opt {}

fulltext_key_opt:
  all_key_opt {}
| WITH PARSER u_id { }

spatial_key_options:
  /* empty */ {}
| spatial_key_opts {}

spatial_key_opts:
  all_key_opt {}
| spatial_key_opts all_key_opt {}

opt_constraint:
  /* empty */ {}
| CONSTRAINT opt_ident {}

constraint_key_type:
  PRIMARY KEY {}
| UNIQUE opt_key_or_index {}


opt_create_table_options:
  /* empty */
| create_table_options

create_table_options:
  create_table_option
| create_table_option     create_table_options
| create_table_option ',' create_table_options

create_table_option:
  ENGINE opt_equal ident_or_text 
  {
    SetStorage(yylex,$3)
  }
| MAX_ROWS opt_equal NUMBER  { }
| MIN_ROWS opt_equal NUMBER { }
| AVG_ROW_LENGTH opt_equal NUMBER { }
| PASSWORD opt_equal STRING { }
| COMMENT_TOKEN opt_equal ident_or_text { }
| AUTO_INC opt_equal NUMBER { }
| PACK_KEYS opt_equal NUMBER { }
| PACK_KEYS opt_equal DEFAULT { }
| STATS_AUTO_RECALC opt_equal NUMBER { }
| STATS_AUTO_RECALC opt_equal DEFAULT {}
| STATS_PERSISTENT opt_equal NUMBER { }
| STATS_PERSISTENT opt_equal DEFAULT { }
| STATS_SAMPLE_PAGES opt_equal NUMBER { }
| STATS_SAMPLE_PAGES opt_equal DEFAULT { }
| CHECKSUM opt_equal NUMBER { }
| TABLE_CHECKSUM opt_equal NUMBER { }
| DELAY_KEY_WRITE opt_equal NUMBER { }
| ROW_FORMAT opt_equal row_types { }
| UNION opt_equal '(' opt_table_list ')' { }
| default_charset { }
| default_collation { }
| INSERT_METHOD opt_equal merge_insert_types { }
| DATA DIRECTORY opt_equal STRING { }
| INDEX DIRECTORY opt_equal STRING { }
| TABLESPACE u_id {}
| STORAGE DISK {}
| STORAGE MEMORY {}
| CONNECTION opt_equal STRING { }
| KEY_BLOCK_SIZE opt_equal NUMBER { }
;

equal:
  '=' {}
| SET {}

opt_equal:
  /* empty */ {}
| equal {}

row_types:
  DEFAULT    { }
| FIXED      {  }
| DYNAMIC    {  }
| COMPRESSED {  }
| REDUNDANT  {  }
| COMPACT    {  }

opt_table_list:
  /* empty */  {}
| table_list {}

table_list:
  ddl_table_id
| table_list ',' ddl_table_id


default_charset:
  opt_default charset opt_equal charset_name_or_default { }

default_collation:
  opt_default COLLATE opt_equal collation_name_or_default { }

opt_default:
  /* empty */ {}
| DEFAULT {}

charset_name_or_default:
  charset_name {  }
| DEFAULT    {  }

collation_name_or_default:
  ident_or_text { }
| DEFAULT    { }

merge_insert_types:
  NO          {}
| FIRST       { }
| LAST        {}





opt_create_partitioning:
  /* empty */ {$$ = DdlPartition{Pos:ReadPos(yylex), Partitions:nil} }
| PARTITION read_last_pos BY part_type_def opt_num_parts opt_sub_part opt_num_subparts opt_part_defs
{
  $$ = DdlPartition{Pos:$2 , Partitions:&Partitions{PartKey: $4, PartNum: $5, SubPartKey: $6, SubPartNum: $7, PartInfos: $8}}
}

part_type_def:
  opt_linear KEY opt_key_algo '(' part_field_list ')' 
  {
    $$ = &PartKey{Linear:$1, Key:U_PART_KEY, Algorithm:$3, PartExprs:$5 } 
  }
| opt_linear HASH  '(' part_expr  ')'
  {
    $$ = &PartKey{Linear:$1, Key:U_PART_HASH, PartExprs: $4 }
  }
| RANGE '(' part_expr  ')' 
  {
    $$ = &PartKey{Key:U_PART_RANGE, PartExprs: $3 } 
  }

| RANGE part_column_list 
  {
    $$ = &PartKey{Key:U_PART_RANGE, PartExprs: $2 }  
  }
| LIST '(' part_expr  ')' 
  {
    $$ = &PartKey{ Key:U_PART_LIST, PartExprs: $3 }  
  }
| LIST part_column_list 
  {
    $$ = &PartKey{ Key:U_PART_LIST, PartExprs: $2 }   
  }

opt_linear:
  /* empty */ 
  { 
    $$="" 
  }
| LINEAR 
  { 
    $$ = U_LINEAR 
  }

opt_key_algo:
 /* empty */ 
  {     
    $$ = nil 
  }
| ALGORITHM '=' NUMBER 
  { 
    $$ = &Algorithm{ Num: NumVal($3) }
  }


part_field_list:
  /* empty */ 
  {
     $$ = nil
  }
| part_field_item_list 
  {
     $$ = $1
  }

part_field_item_list:
  part_column_name 
  {
    $$ = PartColumns{&PartExpr{Expr: $1}}
  }
| part_field_item_list ',' part_column_name 
  {
    $$ = append($$, &PartExpr{Expr: $3})
  }

part_column_name:
  sql_id
  {
    $$ = &ColName{Name: $1}
  }

part_expr:
  value_expression
  {
    $$ = &PartExpr{Expr: $1}
  }

part_column_list:
  COLUMNS '(' part_field_list ')' 
  {
     $$ = $3
  }

opt_num_parts:
  /* empty */ { $$ = nil}
| PARTITIONS NUMBER 
  {
    $$ = &Partnum{ Num: $2 } 
  }

opt_sub_part:
  /* empty */ {}
| SUBPARTITION BY opt_linear HASH '(' part_expr  ')'  
  {
    $$ = &PartKey{Sub:U_SUB, Linear:$3, Key:U_PART_HASH ,PartExprs: $6 }
  }
| SUBPARTITION BY opt_linear KEY opt_key_algo '(' part_field_item_list ')'  
  {
    $$ = &PartKey{Sub:U_SUB, Linear:$3, Key:U_PART_KEY , Algorithm:$5, PartExprs:$7 } 
  }

opt_num_subparts:
  /* empty */ { $$ = nil }
| SUBPARTITIONS NUMBER 
  {
    $$ = &Partnum{ Sub:U_SUB, Num: $2 }
  }


opt_part_defs:
  /* empty */ { $$ = PartInfos{} }
| '(' part_def_list ')' 
   {
      $$ = $2 
   }

part_def_list:
  part_definition 
  {
    $$ = PartInfos{$1}
  }
| part_def_list ',' part_definition 
  {
    $$ = append($1,$3)
  }

part_definition:
  PARTITION u_id opt_part_values opt_part_options opt_sub_partition 
  {
    $$ = &PartInfo{ PartName: ($2), PartValues:$3, PartOptExprs:$4}
  }

opt_part_values:
  /* empty */ 
  {
    $$ = nil 
  }
| VALUES LESS THAN part_func_max 
  {
    $$ = $4
  }
| VALUES IN part_values_in 
  {
    $$ = $3
  }


part_func_max:
  MAX_VALUE 
  {
     $$ = PartValLess(ValTuple(ValExprs{NumVal("maxvalue")})) 
  }
| part_value_item 
  {
     $$ = PartValLess($1)
  }

part_value_item:
  '(' part_value_item_list ')' 
  {
    $$ = ValTuple($2)
  }


part_value_item_list:
  part_value_expr_item 
  {
    $$ = ValExprs{$1}
  }
| part_value_item_list ',' part_value_expr_item 
  {
    $$ = append($$, $3)    
  }

part_value_expr_item:
  MAX_VALUE 
  {
    $$ = NumVal("maxvalue") 
  }
| value_expression 
  {
    $$ = $1
  }



part_values_in:
  part_value_item 
  {
    $$ = PartValIn{$1}
  }
| '(' part_value_list ')' 
  {
    $$ =  $2
  }

part_value_list:
  part_value_item 
  {
    $$ =  PartValIn{$1}
  }
| part_value_list ',' part_value_item 
  {
    $$ = append($1, $3)    
  }



opt_part_options:
  /* empty */ { $$ = PartOptExprs{} }
| opt_part_option_list 
  {
    $$ = $1
  }

opt_part_option_list:
  opt_part_option_list opt_part_option 
  {
    $$ = append($1, $2)
  }
| opt_part_option 
  {
    $$ = PartOptExprs{$1}
  }

opt_part_option:
  TABLESPACE opt_equal ident_or_text 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("tablespace")}, Expr: StrVal($3)}     
  }
| opt_storage ENGINE opt_equal ident_or_text 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("engine")}, Expr: StrVal($4)}  
    SetStorage(yylex,$4) 
   
  }
| NODEGROUP opt_equal NUMBER 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("nodegroup")}, Expr: NumVal($3)}     
  }
| MAX_ROWS opt_equal NUMBER 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("max_rows")}, Expr:  NumVal($3)}     
  }
| MIN_ROWS opt_equal NUMBER 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("min_rows")}, Expr:  NumVal($3)}     
  }
| DATA DIRECTORY opt_equal STRING 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("data directory")}, Expr: StrVal($4)}     
  }
| INDEX DIRECTORY opt_equal STRING 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("index directory")}, Expr: StrVal($4)}     
  }
| COMMENT_TOKEN opt_equal STRING 
  {
    $$ = &UpdateExpr{Name: &ColName{Name: []byte("comment directory")}, Expr: StrVal($3)}     
  }

opt_storage:
  /* empty */
| STORAGE {}


opt_sub_partition:
  /* empty */ { }
| '(' sub_part_list ')' 
  {
  }

sub_part_list:
  sub_part_definition 
  {
    
  }
| sub_part_list ',' sub_part_definition 
  {
    
  }

sub_part_definition:
  SUBPARTITION ident_or_text opt_part_options 
  {
    
  }

opt_on_uddb:
  {
    $$ = DdlString{Pos:ReadLastPos(yylex)} 
  }
| ON STRING 
  { 
    $$ = DdlString{Pos:ReadPos(yylex), String: ($2)}
  } 


opt_create_database_options:
  /* empty */ {}
| create_database_options {}
;
create_database_options:
  create_database_option {}
| create_database_options create_database_option {}
;

create_database_option:
  default_collation {}
| default_charset {}
;

u_id:
  ID { $$=$1 }
| keyword
  {
     $$ = $1
  }


keyword:
 ASCII  {$$ = $1}
| BEGIN            
| DUPLICATE          
| DYNAMIC            
| ENUM                    
| ENGINE             
| EXCHANGE           
| ENABLE             
| FULL                     
| FIRST              
| FIXED              
| GEOMETRY            
| GEOMETRYCOLLECTION       
| HASH                
| IMPORT                  
| INDEXES                
| INSERT_METHOD           
| KEY_BLOCK_SIZE          
| LAST              
| LESS               
| LINESTRING              
| LIST               
| MAX_ROWS                 
| MEMORY             
| MIN_ROWS               
| MODIFY              
| MULTILINESTRING         
| MULTIPOINT             
| MULTIPOLYGON             
| NAMES              
| NATIONAL            
| NCHAR              
| NODEGROUP           
| NVARCHAR            
| OFFSET              
| PACK_KEYS           
| PARTITIONING       
| PARTITIONS         
| PASSWORD               
| POINT              
| POLYGON                  
| REBUILD            
| REDUNDANT           
| REORGANIZE          
| ROW_FORMAT         
| RTREE            
| SERIAL            
| SIMPLE            
| STATS_AUTO_RECALC    
| STATS_PERSISTENT    
| STATS_SAMPLE_PAGES  
| STORAGE              
| SUBPARTITION        
| SUBPARTITIONS     
| TABLE_CHECKSUM       
| TABLESPACE              
| TEXT                
| THAN                
| TRANSACTION    
| YEAR          
| VALUE            
| BYTE     
| CHARSET 
| CHECKSUM
| COMMENT_TOKEN 
| COMMIT   
| START 
| HELP
| NO 
| PARSER  
| REPAIR 
| ROLLBACK 
| SIGNED   
| TRUNCATE  
| UNICODE   
| ACTION    
| AFTER    
| ALGORITHM 
| AUTO_INC    
| AVG_ROW_LENGTH  
| BIT    
| BOOL   
| BOOLEAN 
| BTREE   
| COALESCE  
| COLUMN_FORMAT  
| COLUMNS  
| COMPACT 
| COMPRESSED  
| CONNECTION  
| DATA     
| DATETIME 
| DELAY_KEY_WRITE  
| DIRECTORY  
| DISABLE        
| DISCARD   
| DISK    
| TIMESTAMP               
| TIME              
| DATE    
| TYPE               
| END  {$$ = $1}    

opt_index_lock_algorithm:
  /* empty */
| alter_lock_option
| alter_algorithm_option
| alter_lock_option alter_algorithm_option
| alter_algorithm_option alter_lock_option

alter_algorithm_option:
  ALGORITHM opt_equal DEFAULT { }
| ALGORITHM opt_equal ID { }

alter_lock_option:
  LOCK opt_equal DEFAULT { }
| LOCK opt_equal ID { }

exists_opt_pos:
  { 
    $$ = DdlString{Pos:ReadLastPos(yylex)} 
  }
| IF EXISTS
  { 
    $$ = DdlString{Pos:ReadPos(yylex), String: []byte("if exists")}
  } 


not_exists_opt_pos:
  { 
    $$ = DdlString{Pos:ReadLastPos(yylex)} 
  }
| IF NOT EXISTS
  { 
    $$ = DdlString{Pos:ReadPos(yylex), String: []byte("if not exists")}
  } 

read_pos:
{
  $$ = ReadPos(yylex)
}
read_last_pos:
{
  $$ = ReadLastPos(yylex)
}

lock_table_statement:
    LOCK TABLES table_locks
    {
        $$ = &LockTables{ TblLocks: $3 }
    }

table_locks:
    table_lock
    {
        $$ = TblLocks{$1}
    }   
|   table_locks ',' table_lock    
    {
       $$ = append($$, $3) 
    }

table_lock:
    u_id as_opt
    {
        $$=&TblLock{TblName:$1, As:$2}
    }

table_lock:
    u_id lock_type
    {
        $$=&TblLock{TblName:$1, LockType:$2} 
    }
|   u_id as_opt lock_type
    {
        $$=&TblLock{TblName:$1, As:$2, LockType:$3}
    }

lock_type:
    READ
    {
        $$=1
    }
|   READ LOCAL /*对于innodb，READ LOCAL和READ效果一样*/
    {
        $$=1
    }
|   WRITE 
    {
        $$=2
    }
/**
LOW_PRIORITY mysql 5.6.5 版本之后将不再支持，而udb目前是5.6.20
| LOW_PRIORITY WRITE
*/

unlock_table_statement:
    UNLOCK TABLES
    {
        $$=&UnlockTables{}
    }                      
