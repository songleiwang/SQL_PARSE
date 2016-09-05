/*sqlparse.yy*/
%pure_parser                                    
%expect  106 


%{
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#include "parse-struct.h"
#include "parse-lex.h"
#include "parse-charset.h"


%}

%union {
    int                 num;
    unsigned long       ulong_num;
    char               *simple_string;
    PARSEFIELD         *field;
    PARSEFLIST          fieldlist;
    PARSEFLIST         *flistptr;
    LEX_STRING          lex_str;
    CHARSET_INFO       *charset;        /*CHARSET_INFO* */
    LEX_STRING          charstring;
    LEX_SYMBOL          symbol;
    SQLPARSESEL        *select_lex;
    LEX_USER           *lex_user;
    

    enum thr_lock_type          lock_type;
    enum interval_type          interval;
    enum enum_timestamp_type    date_time_type;
    enum enum_var_type          field_vartype;
    enum cast_type              cast_type;
    enum index_hint_type        index_hint;
    enum join_type              join_type;
    enum enum_tx_isolation      tx_isolation;
    enum enum_yes_no_unknown    yes_no_unknown;
    
}


%{


#define YYPARSE_PARAM inlex
#define YYLEX_PARAM inlex

#define Lex    ((SQLPARSELEX *)inlex)
#define Select (((SQLPARSELEX *)inlex)->sql_cursel)
#define Lip    ((Lex_input_stream *)(((SQLPARSELEX *)inlex)->lip))

#define MY_YYABORT \
{                  \
    const char *token= get_tok_start(Lip); \
    if (!token)    \
        token= ""; \
    fprintf(stderr, "You have an error in your SQL syntax near %s line %d ",token,Lip->yylineno); \
    YYABORT;\
} 


int yylex(void* yylval, void* inlex);


int yyerror (char *err)
{
/*
    SQLPARSELEX *curlex = parse_getcurlex();
    Lex_input_stream *curlip = (Lex_input_stream *)(((SQLPARSELEX *)curlex)->lip);
    
    const char *token= get_tok_start(curlip); 
    if (!token)    
        token= ""; 
    fprintf(stderr, "You have an error in your SQL syntax near '%s' line %d ",token,curlip->yylineno); 
*/
    return 1;
}

int check_reserved_words(LEX_STRING *name)
{
    if (strcmp(name->str, "GLOBAL") == 0) 
        return OPT_GLOBAL;
    if (strcmp(name->str, "LOCAL") == 0) 
        return OPT_SESSION;
    if (strcmp(name->str, "SESSION") == 0)
        return OPT_SESSION;

    return -1;
}

%}

%token  ABORT_SYM                     /* INTERNAL (used in lex) */
%token  ACCESSIBLE_SYM
%token  ACTION                        /* SQL-2003-N */
%token  ADD                           /* SQL-2003-R */
%token  ADDDATE_SYM                   /* MYSQL-FUNC */
%token  AFTER_SYM                     /* SQL-2003-N */
%token  AGAINST
%token  AGGREGATE_SYM
%token  ALGORITHM_SYM
%token  ALL                           /* SQL-2003-R */
%token  ALTER                         /* SQL-2003-R */
%token  ANALYSE_SYM
%token  ANALYZE_SYM
%token  AND_AND_SYM                   /* OPERATOR */
%token  AND_SYM                       /* SQL-2003-R */
%token  ANY_SYM                       /* SQL-2003-R */
%token  AS                            /* SQL-2003-R */
%token  ASC                           /* SQL-2003-N */
%token  ASCII_SYM                     /* MYSQL-FUNC */
%token  ASENSITIVE_SYM                /* FUTURE-USE */
%token  AT_SYM                        /* SQL-2003-R */
%token  AUTOEXTEND_SIZE_SYM
%token  AUTO_INC
%token  AVG_ROW_LENGTH
%token  AVG_SYM                       /* SQL-2003-N */
%token  BACKUP_SYM
%token  BEFORE_SYM                    /* SQL-2003-N */
%token  BEGIN_SYM                     /* SQL-2003-R */
%token  BETWEEN_SYM                   /* SQL-2003-R */
%token  BIGINT                        /* SQL-2003-R */
%token  BINARY                        /* SQL-2003-R */
%token  BINLOG_SYM
%token  BIN_NUM
%token  BIT_AND                       /* MYSQL-FUNC */
%token  BIT_OR                        /* MYSQL-FUNC */
%token  BIT_SYM                       /* MYSQL-FUNC */
%token  BIT_XOR                       /* MYSQL-FUNC */
%token  BLOB_SYM                      /* SQL-2003-R */
%token  BLOCK_SYM
%token  BOOLEAN_SYM                   /* SQL-2003-R */
%token  BOOL_SYM
%token  BOTH                          /* SQL-2003-R */
%token  BTREE_SYM
%token  BY                            /* SQL-2003-R */
%token  BYTE_SYM
%token  CACHE_SYM
%token  CALL_SYM                      /* SQL-2003-R */
%token  CASCADE                       /* SQL-2003-N */
%token  CASCADED                      /* SQL-2003-R */
%token  CASE_SYM                      /* SQL-2003-R */
%token  CAST_SYM                      /* SQL-2003-R */
%token  CATALOG_NAME_SYM              /* SQL-2003-N */
%token  CHAIN_SYM                     /* SQL-2003-N */
%token  CHANGE
%token  CHANGED
%token  CHARSET
%token  CHAR_SYM                      /* SQL-2003-R */
%token  CHECKSUM_SYM
%token  CHECK_SYM                     /* SQL-2003-R */
%token  CIPHER_SYM
%token  CLASS_ORIGIN_SYM              /* SQL-2003-N */
%token  CLIENT_SYM
%token  CLOSE_SYM                     /* SQL-2003-R */
%token  COALESCE                      /* SQL-2003-N */
%token  CODE_SYM
%token  COLLATE_SYM                   /* SQL-2003-R */
%token  COLLATION_SYM                 /* SQL-2003-N */
%token  COLUMNS
%token  COLUMN_SYM                    /* SQL-2003-R */
%token  COLUMN_FORMAT_SYM
%token  COLUMN_NAME_SYM               /* SQL-2003-N */
%token  COMMENT_SYM
%token  COMMITTED_SYM                 /* SQL-2003-N */
%token  COMMIT_SYM                    /* SQL-2003-R */
%token  COMPACT_SYM
%token  COMPLETION_SYM
%token  COMPRESSED_SYM
%token  CONCURRENT
%token  CONDITION_SYM                 /* SQL-2003-R, SQL-2008-R */
%token  CONNECTION_SYM
%token  CONSISTENT_SYM
%token  CONSTRAINT                    /* SQL-2003-R */
%token  CONSTRAINT_CATALOG_SYM        /* SQL-2003-N */
%token  CONSTRAINT_NAME_SYM           /* SQL-2003-N */
%token  CONSTRAINT_SCHEMA_SYM         /* SQL-2003-N */
%token  CONTAINS_SYM                  /* SQL-2003-N */
%token  CONTEXT_SYM
%token  CONTINUE_SYM                  /* SQL-2003-R */
%token  CONVERT_SYM                   /* SQL-2003-N */
%token  COUNT_SYM                     /* SQL-2003-N */
%token  CPU_SYM
%token  CREATE                        /* SQL-2003-R */
%token  CROSS                         /* SQL-2003-R */
%token  CUBE_SYM                      /* SQL-2003-R */
%token  CURDATE                       /* MYSQL-FUNC */
%token  CURRENT_SYM                   /* SQL-2003-R */
%token  CURRENT_USER                  /* SQL-2003-R */
%token  CURSOR_SYM                    /* SQL-2003-R */
%token  CURSOR_NAME_SYM               /* SQL-2003-N */
%token  CURTIME                       /* MYSQL-FUNC */
%token  DATABASE
%token  DATABASES
%token  DATAFILE_SYM
%token  DATA_SYM                      /* SQL-2003-N */
%token  DATETIME
%token  DATE_ADD_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SUB_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SYM                      /* SQL-2003-R */
%token  DAY_HOUR_SYM
%token  DAY_MICROSECOND_SYM
%token  DAY_MINUTE_SYM
%token  DAY_SECOND_SYM
%token  DAY_SYM                       /* SQL-2003-R */
%token  DEALLOCATE_SYM                /* SQL-2003-R */
%token  DECIMAL_NUM
%token  DECIMAL_SYM                   /* SQL-2003-R */
%token  DECLARE_SYM                   /* SQL-2003-R */
%token  DEFAULT                       /* SQL-2003-R */
%token  DEFAULT_AUTH_SYM              /* INTERNAL */
%token  DEFINER_SYM
%token  DELAYED_SYM
%token  DELAY_KEY_WRITE_SYM
%token  DELETE_SYM                    /* SQL-2003-R */
%token  DESC                          /* SQL-2003-N */
%token  DESCRIBE                      /* SQL-2003-R */
%token  DES_KEY_FILE
%token  DETERMINISTIC_SYM             /* SQL-2003-R */
%token  DIAGNOSTICS_SYM               /* SQL-2003-N */
%token  DIRECTORY_SYM
%token  DISABLE_SYM
%token  DISCARD
%token  DISK_SYM
%token  DISTINCT                      /* SQL-2003-R */
%token  DIV_SYM
%token  DOUBLE_SYM                    /* SQL-2003-R */
%token  DO_SYM
%token  DROP                          /* SQL-2003-R */
%token  DUAL_SYM
%token  DUMPFILE
%token  DUPLICATE_SYM
%token  DYNAMIC_SYM                   /* SQL-2003-R */
%token  EACH_SYM                      /* SQL-2003-R */
%token  ELSE                          /* SQL-2003-R */
%token  ELSEIF_SYM
%token  ENABLE_SYM
%token  ENCLOSED
%token  END                           /* SQL-2003-R */
%token  ENDS_SYM
%token  END_OF_INPUT                  /* INTERNAL */
%token  ENGINES_SYM
%token  ENGINE_SYM
%token  ENUM
%token  EQ                            /* OPERATOR */
%token  EQUAL_SYM                     /* OPERATOR */
%token  ERROR_SYM
%token  ERRORS
%token  ESCAPED
%token  ESCAPE_SYM                    /* SQL-2003-R */
%token  EVENTS_SYM
%token  EVENT_SYM
%token  EVERY_SYM                     /* SQL-2003-N */
%token  EXCHANGE_SYM
%token  EXECUTE_SYM                   /* SQL-2003-R */
%token  EXISTS                        /* SQL-2003-R */
%token  EXIT_SYM
%token  EXPANSION_SYM
%token  EXPIRE_SYM
%token  EXPORT_SYM
%token  EXTENDED_SYM
%token  EXTENT_SIZE_SYM
%token  EXTRACT_SYM                   /* SQL-2003-N */
%token  FALSE_SYM                     /* SQL-2003-R */
%token  FAST_SYM
%token  FAULTS_SYM
%token  FETCH_SYM                     /* SQL-2003-R */
%token  FILE_SYM
%token  FIRST_SYM                     /* SQL-2003-N */
%token  FIXED_SYM
%token  FLOAT_NUM
%token  FLOAT_SYM                     /* SQL-2003-R */
%token  FLUSH_SYM
%token  FORCE_SYM
%token  FOREIGN                       /* SQL-2003-R */
%token  FOR_SYM                       /* SQL-2003-R */
%token  FORMAT_SYM
%token  FOUND_SYM                     /* SQL-2003-R */
%token  FROM
%token  FULL                          /* SQL-2003-R */
%token  FULLTEXT_SYM
%token  FUNCTION_SYM                  /* SQL-2003-R */
%token  GE
%token  GENERAL
%token  GEOMETRYCOLLECTION
%token  GEOMETRY_SYM
%token  GET_FORMAT                    /* MYSQL-FUNC */
%token  GET_SYM                       /* SQL-2003-R */
%token  GLOBAL_SYM                    /* SQL-2003-R */
%token  GRANT                         /* SQL-2003-R */
%token  GRANTS
%token  GROUP_SYM                     /* SQL-2003-R */
%token  GROUP_CONCAT_SYM
%token  GT_SYM                        /* OPERATOR */
%token  HANDLER_SYM
%token  HASH_SYM
%token  HAVING                        /* SQL-2003-R */
%token  HELP_SYM
%token  HEX_NUM
%token  HIGH_PRIORITY
%token  HOST_SYM
%token  HOSTS_SYM
%token  HOUR_MICROSECOND_SYM
%token  HOUR_MINUTE_SYM
%token  HOUR_SECOND_SYM
%token  HOUR_SYM                      /* SQL-2003-R */
%token  IDENT
%token  IDENTIFIED_SYM
%token  IDENT_QUOTED
%token  IF
%token  IGNORE_SYM
%token  IGNORE_SERVER_IDS_SYM
%token  IMPORT
%token  INDEXES
%token  INDEX_SYM
%token  INFILE
%token  INITIAL_SIZE_SYM
%token  INNER_SYM                     /* SQL-2003-R */
%token  INOUT_SYM                     /* SQL-2003-R */
%token  INSENSITIVE_SYM               /* SQL-2003-R */
%token  INSERT                        /* SQL-2003-R */
%token  INSERT_METHOD
%token  INSTALL_SYM
%token  INTERVAL_SYM                  /* SQL-2003-R */
%token  INTO                          /* SQL-2003-R */
%token  INT_SYM                       /* SQL-2003-R */
%token  INVOKER_SYM
%token  IN_SYM                        /* SQL-2003-R */
%token  IO_AFTER_GTIDS                /* MYSQL, FUTURE-USE */
%token  IO_BEFORE_GTIDS               /* MYSQL, FUTURE-USE */
%token  IO_SYM
%token  IPC_SYM
%token  IS                            /* SQL-2003-R */
%token  ISOLATION                     /* SQL-2003-R */
%token  ISSUER_SYM
%token  ITERATE_SYM
%token  JOIN_SYM                      /* SQL-2003-R */
%token  KEYS
%token  KEY_BLOCK_SIZE
%token  KEY_SYM                       /* SQL-2003-N */
%token  KILL_SYM
%token  LANGUAGE_SYM                  /* SQL-2003-R */
%token  LAST_SYM                      /* SQL-2003-N */
%token  LE                            /* OPERATOR */
%token  LEADING                       /* SQL-2003-R */
%token  LEAVES
%token  LEAVE_SYM
%token  LEFT                          /* SQL-2003-R */
%token  LESS_SYM
%token  LEVEL_SYM
%token  LEX_HOSTNAME
%token  LIKE                          /* SQL-2003-R */
%token  LIMIT
%token  LINEAR_SYM
%token  LINES
%token  LINESTRING
%token  LIST_SYM
%token  LOAD
%token  LOCAL_SYM                     /* SQL-2003-R */
%token  LOCATOR_SYM                   /* SQL-2003-N */
%token  LOCKS_SYM
%token  LOCK_SYM
%token  LOGFILE_SYM
%token  LOGS_SYM
%token  LONGBLOB
%token  LONGTEXT
%token  LONG_NUM
%token  LONG_SYM
%token  LOOP_SYM
%token  LOW_PRIORITY
%token  LT                            /* OPERATOR */
%token  MASTER_AUTO_POSITION_SYM
%token  MASTER_BIND_SYM
%token  MASTER_CONNECT_RETRY_SYM
%token  MASTER_DELAY_SYM
%token  MASTER_HOST_SYM
%token  MASTER_LOG_FILE_SYM
%token  MASTER_LOG_POS_SYM
%token  MASTER_PASSWORD_SYM
%token  MASTER_PORT_SYM
%token  MASTER_RETRY_COUNT_SYM
%token  MASTER_SERVER_ID_SYM
%token  MASTER_SSL_CAPATH_SYM
%token  MASTER_SSL_CA_SYM
%token  MASTER_SSL_CERT_SYM
%token  MASTER_SSL_CIPHER_SYM
%token  MASTER_SSL_CRL_SYM
%token  MASTER_SSL_CRLPATH_SYM
%token  MASTER_SSL_KEY_SYM
%token  MASTER_SSL_SYM
%token  MASTER_SSL_VERIFY_SERVER_CERT_SYM
%token  MASTER_SYM
%token  MASTER_USER_SYM
%token  MASTER_HEARTBEAT_PERIOD_SYM
%token  MATCH                         /* SQL-2003-R */
%token  MAX_CONNECTIONS_PER_HOUR
%token  MAX_QUERIES_PER_HOUR
%token  MAX_ROWS
%token  MAX_SIZE_SYM
%token  MAX_SYM                       /* SQL-2003-N */
%token  MAX_UPDATES_PER_HOUR
%token  MAX_USER_CONNECTIONS_SYM
%token  MAX_VALUE_SYM                 /* SQL-2003-N */
%token  MEDIUMBLOB
%token  MEDIUMINT
%token  MEDIUMTEXT
%token  MEDIUM_SYM
%token  MEMORY_SYM
%token  MERGE_SYM                     /* SQL-2003-R */
%token  MESSAGE_TEXT_SYM              /* SQL-2003-N */
%token  MICROSECOND_SYM               /* MYSQL-FUNC */
%token  MIGRATE_SYM
%token  MINUTE_MICROSECOND_SYM
%token  MINUTE_SECOND_SYM
%token  MINUTE_SYM                    /* SQL-2003-R */
%token  MIN_ROWS
%token  MIN_SYM                       /* SQL-2003-N */
%token  MODE_SYM
%token  MODIFIES_SYM                  /* SQL-2003-R */
%token  MODIFY_SYM
%token  MOD_SYM                       /* SQL-2003-N */
%token  MONTH_SYM                     /* SQL-2003-R */
%token  MULTILINESTRING
%token  MULTIPOINT
%token  MULTIPOLYGON
%token  MUTEX_SYM
%token  MYSQL_ERRNO_SYM
%token  NAMES_SYM                     /* SQL-2003-N */
%token  NAME_SYM                      /* SQL-2003-N */
%token  NATIONAL_SYM                  /* SQL-2003-R */
%token  NATURAL                       /* SQL-2003-R */
%token  NCHAR_STRING
%token  NCHAR_SYM                     /* SQL-2003-R */
%token  NDBCLUSTER_SYM
%token  NE                            /* OPERATOR */
%token  NEG
%token  NEW_SYM                       /* SQL-2003-R */
%token  NEXT_SYM                      /* SQL-2003-N */
%token  NODEGROUP_SYM
%token  NONE_SYM                      /* SQL-2003-R */
%token  NOT2_SYM
%token  NOT_SYM                       /* SQL-2003-R */
%token  NOW_SYM
%token  NO_SYM                        /* SQL-2003-R */
%token  NO_WAIT_SYM
%token  NO_WRITE_TO_BINLOG
%token  NULL_SYM                      /* SQL-2003-R */
%token  NUM
%token  NUMBER_SYM                    /* SQL-2003-N */
%token  NUMERIC_SYM                   /* SQL-2003-R */
%token  NVARCHAR_SYM
%token  OFFSET_SYM
%token  OLD_PASSWORD
%token  ON                            /* SQL-2003-R */
%token  ONE_SYM
%token  ONLY_SYM                      /* SQL-2003-R */
%token  OPEN_SYM                      /* SQL-2003-R */
%token  OPTIMIZE
%token  OPTIONS_SYM
%token  OPTION                        /* SQL-2003-N */
%token  OPTIONALLY
%token  OR2_SYM
%token  ORDER_SYM                     /* SQL-2003-R */
%token  OR_OR_SYM                     /* OPERATOR */
%token  OR_SYM                        /* SQL-2003-R */
%token  OUTER
%token  OUTFILE
%token  OUT_SYM                       /* SQL-2003-R */
%token  OWNER_SYM
%token  PACK_KEYS_SYM
%token  PAGE_SYM
%token  PARAM_MARKER
%token  PARSER_SYM
%token  PARTIAL                       /* SQL-2003-N */
%token  PARTITION_SYM                 /* SQL-2003-R */
%token  PARTITIONS_SYM
%token  PARTITIONING_SYM
%token  PASSWORD
%token  PHASE_SYM
%token  PLUGIN_DIR_SYM                /* INTERNAL */
%token  PLUGIN_SYM
%token  PLUGINS_SYM
%token  POINT_SYM
%token  POLYGON
%token  PORT_SYM
%token  POSITION_SYM                  /* SQL-2003-N */
%token  PRECISION                     /* SQL-2003-R */
%token  PREPARE_SYM                   /* SQL-2003-R */
%token  PRESERVE_SYM
%token  PREV_SYM
%token  PRIMARY_SYM                   /* SQL-2003-R */
%token  PRIVILEGES                    /* SQL-2003-N */
%token  PROCEDURE_SYM                 /* SQL-2003-R */
%token  PROCESS
%token  PROCESSLIST_SYM
%token  PROFILE_SYM
%token  PROFILES_SYM
%token  PROXY_SYM
%token  PURGE
%token  QUARTER_SYM
%token  QUERY_SYM
%token  QUICK
%token  RANGE_SYM                     /* SQL-2003-R */
%token  READS_SYM                     /* SQL-2003-R */
%token  READ_ONLY_SYM
%token  READ_SYM                      /* SQL-2003-N */
%token  READ_WRITE_SYM
%token  REAL                          /* SQL-2003-R */
%token  REBUILD_SYM
%token  RECOVER_SYM
%token  REDOFILE_SYM
%token  REDO_BUFFER_SIZE_SYM
%token  REDUNDANT_SYM
%token  REFERENCES                    /* SQL-2003-R */
%token  REGEXP
%token  RELAY
%token  RELAYLOG_SYM
%token  RELAY_LOG_FILE_SYM
%token  RELAY_LOG_POS_SYM
%token  RELAY_THREAD
%token  RELEASE_SYM                   /* SQL-2003-R */
%token  RELOAD
%token  REMOVE_SYM
%token  RENAME
%token  REORGANIZE_SYM
%token  REPAIR
%token  REPEATABLE_SYM                /* SQL-2003-N */
%token  REPEAT_SYM                    /* MYSQL-FUNC */
%token  REPLACE                       /* MYSQL-FUNC */
%token  REPLICATION
%token  REQUIRE_SYM
%token  RESET_SYM
%token  RESIGNAL_SYM                  /* SQL-2003-R */
%token  RESOURCES
%token  RESTORE_SYM
%token  RESTRICT
%token  RESUME_SYM
%token  RETURNED_SQLSTATE_SYM         /* SQL-2003-N */
%token  RETURNS_SYM                   /* SQL-2003-R */
%token  RETURN_SYM                    /* SQL-2003-R */
%token  REVERSE_SYM
%token  REVOKE                        /* SQL-2003-R */
%token  RIGHT                         /* SQL-2003-R */
%token  ROLLBACK_SYM                  /* SQL-2003-R */
%token  ROLLUP_SYM                    /* SQL-2003-R */
%token  ROUTINE_SYM                   /* SQL-2003-N */
%token  ROWS_SYM                      /* SQL-2003-R */
%token  ROW_FORMAT_SYM
%token  ROW_SYM                       /* SQL-2003-R */
%token  ROW_COUNT_SYM                 /* SQL-2003-N */
%token  RTREE_SYM
%token  SAVEPOINT_SYM                 /* SQL-2003-R */
%token  SCHEDULE_SYM
%token  SCHEMA_NAME_SYM               /* SQL-2003-N */
%token  SECOND_MICROSECOND_SYM
%token  SECOND_SYM                    /* SQL-2003-R */
%token  SECURITY_SYM                  /* SQL-2003-N */
%token  SELECT_SYM                    /* SQL-2003-R */
%token  SENSITIVE_SYM                 /* FUTURE-USE */
%token  SEPARATOR_SYM
%token  SERIALIZABLE_SYM              /* SQL-2003-N */
%token  SERIAL_SYM
%token  SESSION_SYM                   /* SQL-2003-N */
%token  SERVER_SYM
%token  SERVER_OPTIONS
%token  SET                           /* SQL-2003-R */
%token  SET_VAR
%token  SHARE_SYM
%token  SHIFT_LEFT                    /* OPERATOR */
%token  SHIFT_RIGHT                   /* OPERATOR */
%token  SHOW
%token  SHUTDOWN
%token  SIGNAL_SYM                    /* SQL-2003-R */
%token  SIGNED_SYM
%token  SIMPLE_SYM                    /* SQL-2003-N */
%token  SLAVE
%token  SLOW
%token  SMALLINT                      /* SQL-2003-R */
%token  SNAPSHOT_SYM
%token  SOCKET_SYM
%token  SONAME_SYM
%token  SOUNDS_SYM
%token  SOURCE_SYM
%token  SPATIAL_SYM
%token  SPECIFIC_SYM                  /* SQL-2003-R */
%token  SQLEXCEPTION_SYM              /* SQL-2003-R */
%token  SQLSTATE_SYM                  /* SQL-2003-R */
%token  SQLWARNING_SYM                /* SQL-2003-R */
%token  SQL_AFTER_GTIDS               /* MYSQL */
%token  SQL_AFTER_MTS_GAPS            /* MYSQL */
%token  SQL_BEFORE_GTIDS              /* MYSQL */
%token  SQL_BIG_RESULT
%token  SQL_BUFFER_RESULT
%token  SQL_CACHE_SYM
%token  SQL_CALC_FOUND_ROWS
%token  SQL_NO_CACHE_SYM
%token  SQL_SMALL_RESULT
%token  SQL_SYM                       /* SQL-2003-R */
%token  SQL_THREAD
%token  SSL_SYM
%token  STARTING
%token  STARTS_SYM
%token  START_SYM                     /* SQL-2003-R */
%token  STATS_AUTO_RECALC_SYM
%token  STATS_PERSISTENT_SYM
%token  STATS_SAMPLE_PAGES_SYM
%token  STATUS_SYM
%token  STDDEV_SAMP_SYM               /* SQL-2003-N */
%token  STD_SYM
%token  STOP_SYM
%token  STORAGE_SYM
%token  STRAIGHT_JOIN
%token  STRING_SYM
%token  SUBCLASS_ORIGIN_SYM           /* SQL-2003-N */
%token  SUBDATE_SYM
%token  SUBJECT_SYM
%token  SUBPARTITIONS_SYM
%token  SUBPARTITION_SYM
%token  SUBSTRING                     /* SQL-2003-N */
%token  SUM_SYM                       /* SQL-2003-N */
%token  SUPER_SYM
%token  SUSPEND_SYM
%token  SWAPS_SYM
%token  SWITCHES_SYM
%token  SYSDATE
%token  TABLES
%token  TABLESPACE
%token  TABLE_REF_PRIORITY
%token  TABLE_SYM                     /* SQL-2003-R */
%token  TABLE_CHECKSUM_SYM
%token  TABLE_NAME_SYM                /* SQL-2003-N */
%token  TEMPORARY                     /* SQL-2003-N */
%token  TEMPTABLE_SYM
%token  TERMINATED
%token  TEXT_STRING
%token  TEXT_SYM
%token  THAN_SYM
%token  THEN_SYM                      /* SQL-2003-R */
%token  TIMESTAMP                     /* SQL-2003-R */
%token  TIMESTAMP_ADD
%token  TIMESTAMP_DIFF
%token  TIME_SYM                      /* SQL-2003-R */
%token  TINYBLOB
%token  TINYINT
%token  TINYTEXT
%token  TO_SYM                        /* SQL-2003-R */
%token  TRAILING                      /* SQL-2003-R */
%token  TRANSACTION_SYM
%token  TRIGGERS_SYM
%token  TRIGGER_SYM                   /* SQL-2003-R */
%token  TRIM                          /* SQL-2003-N */
%token  TRUE_SYM                      /* SQL-2003-R */
%token  TRUNCATE_SYM
%token  TYPES_SYM
%token  TYPE_SYM                      /* SQL-2003-N */
%token  UDF_RETURNS_SYM
%token  ULONGLONG_NUM
%token  UNCOMMITTED_SYM               /* SQL-2003-N */
%token  UNDEFINED_SYM
%token  UNDERSCORE_CHARSET
%token  UNDOFILE_SYM
%token  UNDO_BUFFER_SIZE_SYM
%token  UNDO_SYM                      /* FUTURE-USE */
%token  UNICODE_SYM
%token  UNINSTALL_SYM
%token  UNION_SYM                     /* SQL-2003-R */
%token  UNIQUE_SYM
%token  UNKNOWN_SYM                   /* SQL-2003-R */
%token  UNLOCK_SYM
%token  UNSIGNED
%token  UNTIL_SYM
%token  UPDATE_SYM                    /* SQL-2003-R */
%token  UPGRADE_SYM
%token  USAGE                         /* SQL-2003-N */
%token  USER                          /* SQL-2003-R */
%token  USE_FRM
%token  USE_SYM
%token  USING                         /* SQL-2003-R */
%token  UTC_DATE_SYM
%token  UTC_TIMESTAMP_SYM
%token  UTC_TIME_SYM
%token  VALUES                        /* SQL-2003-R */
%token  VALUE_SYM                     /* SQL-2003-R */
%token  VARBINARY
%token  VARCHAR                       /* SQL-2003-R */
%token  VARIABLES
%token  VARIANCE_SYM
%token  VARYING                       /* SQL-2003-R */
%token  VAR_SAMP_SYM
%token  VIEW_SYM                      /* SQL-2003-N */
%token  WAIT_SYM
%token  WARNINGS
%token  WEEK_SYM
%token  WEIGHT_STRING_SYM
%token  WHEN_SYM                      /* SQL-2003-R */
%token  WHERE                         /* SQL-2003-R */
%token  WHILE_SYM
%token  WITH                          /* SQL-2003-R */
%token  WITH_CUBE_SYM                 /* INTERNAL */
%token  WITH_ROLLUP_SYM               /* INTERNAL */
%token  WORK_SYM                      /* SQL-2003-N */
%token  WRAPPER_SYM
%token  WRITE_SYM                     /* SQL-2003-N */
%token  X509_SYM
%token  XA_SYM
%token  XML_SYM
%token  XOR
%token  YEAR_MONTH_SYM
%token  YEAR_SYM                      /* SQL-2003-R */
%token  ZEROFILL


%token UPSQL_COMMIT_SYM               /*add by upsql 0.0.2*/

%left   JOIN_SYM INNER_SYM STRAIGHT_JOIN CROSS LEFT RIGHT
/* A dummy token to force the priority of table_ref production in a join. */
%left   TABLE_REF_PRIORITY
%left   SET_VAR
%left   OR_OR_SYM OR_SYM OR2_SYM
%left   XOR
%left   AND_SYM AND_AND_SYM
%left   BETWEEN_SYM CASE_SYM WHEN_SYM THEN_SYM ELSE
%left   EQ EQUAL_SYM GE GT_SYM LE LT NE IS LIKE REGEXP IN_SYM
%left   '|'
%left   '&'
%left   SHIFT_LEFT SHIFT_RIGHT
%left   '-' '+'
%left   '*' '/' '%' DIV_SYM MOD_SYM
%left   '^'
%left   NEG '~'
%right  NOT_SYM NOT2_SYM
%right  BINARY COLLATE_SYM
%left  INTERVAL_SYM







%type <NONE> select select_item_list  select_item select_var_list_init select_var_list subselect_start subselect_end
%type <NONE> opt_limit_clause optional_braces opt_procedure_analyse_params opt_field_length opt_binary opt_outer field_length 
%type <NONE> ascii unicode charset precision opt_ignore
%type <NONE> union_clause union_list  

%type <join_type> normal_join

%type <NONE> insert insert2 fields values_list no_braces 

%type <NONE> update

%type <NONE> delete opt_delete_options opt_delete_option single_multi table_wild_list table_alias_ref_list table_alias_ref

%type <NONE> set

%type <NONE> commit rollback 

%type <NONE>
        '-' '+' '*' '/' '%' '(' ')'
        ',' '!' '{' '}' '&' '|' AND_SYM OR_SYM OR_OR_SYM BETWEEN_SYM CASE_SYM
        THEN_SYM WHEN_SYM DIV_SYM MOD_SYM OR2_SYM AND_AND_SYM DELETE_SYM

/*num*/

%type <num>  union_opt union_option  opt_distinct

             

%type <num>  fulltext_options opt_natural_language_mode opt_query_expansion
             all_or_any order_dir
             index_hint_clause
             select_derived_init
             transaction_access_mode_types
             opt_union_order_or_limit
             opt_work opt_if_not_exists
             opt_start_transaction_option_list start_transaction_option_list start_transaction_option

/*ulonglong_number*/
%type <ulong_num> procedure_analyse_param

                  

%type <ulong_num> func_datetime_precision  
            opt_ws_levels ws_level_list_or_range ws_level_list ws_level_list_item ws_level_number ws_level_flag_desc ws_level_flag_reverse
            ws_level_flags ws_nweights
            real_ulong_num ws_level_range ulong_num ulonglong_num

/*simple_string*/

%type <simple_string>
        remember_name remember_end opt_db
            

%type <field>
        expr bool_pri predicate bit_expr in_sum_expr sum_expr udf_expr opt_expr expr_or_default
        table_wild simple_expr simple_ident simple_ident_q simple_ident_nospvar now order_ident
        literal text_literal NUM_literal temporal_literal
        function_call_generic geometry_function function_call_keyword function_call_nonkeyword  function_call_conflict
        param_marker variable variable_aux
        opt_else opt_escape
        limit_option
        insert_ident sp_name
        

%type <fieldlist>
        expr_list opt_udf_expr_list udf_expr_list opt_expr_list
        when_list ident_list_arg ident_list


%type <fieldlist>
        join_table_list derived_table_list   
        using_list opt_use_partition use_partition select_derived_union  select_derived

%type <field> table_ident table_factor table_ref esc_table_ref join_table table_ident_opt_wild
         


%type <lex_str> IDENT IDENT_QUOTED TEXT_STRING DECIMAL_NUM FLOAT_NUM NUM LONG_NUM LEX_HOSTNAME ULONGLONG_NUM
        NCHAR_STRING HEX_NUM BIN_NUM

/*boolfunc2creator*/
%type <lex_str> comp_op EQ equal 



%type <lex_str> ident IDENT_sys select_alias TEXT_STRING_sys ident_or_text 
                TEXT_STRING_literal TEXT_STRING_filesystem text_string 
                opt_table_alias opt_component 
                opt_gconcat_separator

%type <field>  text_or_password


/*symbol*/
%type <symbol>
        keyword keyword_sp


%type <cast_type> cast_type


/*select_lex*/
%type <select_lex> query_expression_body subselect get_select_lex  query_specification

%type <charstring> charset_name old_or_new_charset_name_or_default charset_name_or_default  old_or_new_charset_name collation_name_or_default
             collation_name opt_load_data_charset opt_collate


/*interval*/
%type <interval> interval interval_time_stamp


/*date_time_type*/
%type <date_time_type> date_time_type


/*var type*/
%type <field_vartype> opt_var_ident_type option_type opt_var_type


/*index_hint*/
%type <index_hint> index_hint_type

/*lock_type*/
%type <lock_type>  insert_lock_option opt_low_priority

/*variable*/
%type <field> internal_variable_name set_expr_or_default


/*tx_isolation*/
%type <tx_isolation> isolation_types

/*lex_user*/
%type <lex_user> user

/*m_yes_no_unk*/
%type <yes_no_unknown> opt_chain opt_release


%type <flistptr> values opt_values


%%


query:
          END_OF_INPUT  {}
        | verb_clause ';' opt_end_of_input {}
        | verb_clause END_OF_INPUT 

        ;

verb_clause:
          statement
        | begin
        ;

opt_end_of_input:
          /* empty */ {}
        | END_OF_INPUT {}
        ;

statement:
         select  { }
        | insert { }
        | update { }
        | delete { }
        | set    { }
        | commit
        | rollback
        | show
        | start
        ;

begin:
          BEGIN_SYM
          {
            Select->sql_command = SQLCOM_BEGIN;
            Select->sql_start_trx_opt= 0;
          }
          opt_work {}
        ;

opt_work:
          /* empty */ { $$ = 0;}
        | WORK_SYM  {$$ = 1;}
        ;


start:
        START_SYM TRANSACTION_SYM opt_start_transaction_option_list
        {
            Select->sql_command = SQLCOM_BEGIN;
            Select->sql_start_trx_opt = $3;
        }
        ;

opt_start_transaction_option_list:
          /* empty */
          {
            $$= 0;
          }
        | start_transaction_option_list
          {
            $$= $1;
          }
        ;

start_transaction_option_list:
          start_transaction_option
          {
            $$= $1;
          }
        | start_transaction_option_list ',' start_transaction_option
          {
            $$= $1 | $3;
          }
        ;

start_transaction_option:
          WITH CONSISTENT_SYM SNAPSHOT_SYM
          {
            $$= MYSQL_START_TRANS_OPT_WITH_CONS_SNAPSHOT;
          }
        | READ_SYM ONLY_SYM
          {
            $$= MYSQL_START_TRANS_OPT_READ_ONLY;
          }
        | READ_SYM WRITE_SYM
          {
            $$= MYSQL_START_TRANS_OPT_READ_WRITE;
          }
        ;

select:

        select_init 
        {
            Select->sql_command = SQLCOM_SELECT;
        }
        ;
 


select_init:
          SELECT_SYM select_init2 {}
        | '(' select_paren ')' union_opt {}
        ;




select_init2:
        select_part2
        {
        }
        union_clause {}
        ;

select_paren:
          SELECT_SYM select_part2 {}
        | '(' select_paren ')' {}
        ;

union_opt:
          /* Empty */ { $$= 0; }
        | union_list { $$= 1; }
        | union_order_or_limit { $$= 1; }
        ;





select_part2:
        select_options select_item_list select_into 
        {
        }
        select_lock_type {}

        ;

union_clause:
          /* empty */ {}
        | union_list {}
        ;

union_list:
          UNION_SYM union_option 
          {
              SQLPARSESEL *sel;   
              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }

              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;

              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,sel);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }
              field_subsel->field_union_opt = $2;

              parseaddlist(&(Select->sql_unionlist), field_subsel);


              sel->sql_command = SQLCOM_SELECT;
              sel->prev = Select;
             
              Select = sel;
          }             
          select_init 
          {
              Select = Select->prev;
          }
        ;

union_order_or_limit:
          order_or_limit {}
        ;



select_options:
          /* empty*/
        | select_option_list {}
        ;

select_item_list:
          select_item_list ',' select_item 
        | select_item 
        | '*' 
        {
            PARSEFIELD *field;
            field = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,all_lex_str);
            if(field == NULL) {
                MY_YYABORT;
            }
            parseaddfield(Select,field);
        }
        ;

select_into:
          opt_order_clause opt_limit_clause 
        | into 
        | select_from 
        | into select_from 
        | select_from into 
        ;

select_lock_type:
        | FOR_SYM UPDATE_SYM 
          {
              Select->sql_locktp = TL_WRITE;
          }
        | LOCK_SYM IN_SYM SHARE_SYM MODE_SYM 
          {
              Select->sql_locktp = TL_READ_WITH_SHARED_LOCKS; 
          }
        ;

union_option:
          /* empty */ { $$=UNION_DISTINCT; }
        | DISTINCT  { $$=UNION_DISTINCT; }
        | ALL       { $$=UNION_ALL; }
        ;

order_or_limit:
          order_clause opt_limit_clause_init {}
        | limit_clause {}
        ;







select_option_list:
          select_option_list select_option {}
        | select_option {}
        ;

select_item:
          remember_name table_wild remember_end
          {
              parseaddfield(Select,$2);
          }
        | remember_name expr remember_end select_alias 
        {
            if ($4.str)
            {
            /*    if (Select->sql_command == SQLCOM_CREATE_VIEW && check_column_name($4.str))*/
                $2->field_name_as = $4.str;          
            }
            parseaddfield(Select,$2);
        }
        ;

opt_order_clause:
          /* empty */
        | order_clause 
        ;

opt_limit_clause:
          /* empty */ {}
        | limit_clause {}
        ;

into:
          INTO into_destination {}
        ;

select_from:
          FROM join_table_list where_clause group_clause having_clause opt_order_clause opt_limit_clause procedure_analyse_clause 
          {
              Select->sql_from_tablelist.head = $2.head;
              Select->sql_from_tablelist.tail = $2.tail;
              Select->sql_from_tablelist.fcount = $2.fcount;
              
          }
        | FROM DUAL_SYM where_clause opt_limit_clause {}
        ;

order_clause:
          ORDER_SYM BY order_list 
        ;

opt_limit_clause_init:
          /* empty */ 
          {
              Select->sql_sel_limit = NULL;
              Select->sql_off_limit = NULL;
          }
        | limit_clause {}
        ;

limit_clause:
          LIMIT limit_options {}
        ;







select_option:
          query_expression_option {}
        | SQL_NO_CACHE_SYM 
          {
             /* 
              Allow this flag only on the first top-level SELECT statement, if
              SQL_CACHE wasn't specified, and only once per query.
             */
                
              Select->sql_options&= ~OPTION_TO_QUERY_CACHE;
          }
        | SQL_CACHE_SYM 
          {
              /* 
              Allow this flag only on the first top-level SELECT statement, if
              SQL_NO_CACHE wasn't specified, and only once per query.
             */
              Select->sql_options|= OPTION_TO_QUERY_CACHE;
          }
        ;

remember_name:
          {

              $$= (char*)get_cpp_tok_start(Lip);

          }
        ;

table_wild:
          ident '.' '*' 
          {

              $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,$1.str,all_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }

                 
          }
        | ident '.' ident '.' '*' 
          {

              $$ = (PARSEFIELD *)fieldcolumn(Lex,$1.str,$3.str,all_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

remember_end:
          {

              $$= (char*)get_cpp_tok_end(Lip);
          }
        ;

expr:
          expr or expr %prec OR_SYM 
          {
              $$ = fieldf(Lex, OR_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_name.str="or";
              $$->field_name.length=2;
                
              if($1->field_type == OR_FIELD) {
                  addarglist($$,&($1->field_arg));                  
              } else {
                  addarg($$,$1);
              }
              if($3->field_type == OR_FIELD) {
                  addarglist($$,&($3->field_arg));                  
              }else {
                  addarg($$,$3);
              }
          }
        | expr XOR expr %prec XOR
          {
              $$ = fieldf(Lex, XOR_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              $$->field_name.str="xor";
              $$->field_name.length=3;

              if($1->field_type == XOR_FIELD) {
                  addarglist($$,&($1->field_arg));                  
              } else {
                  addarg($$,$1);
              }
              if($3->field_type == XOR_FIELD) {
                  addarglist($$,&($3->field_arg));                  
              }else {
                  addarg($$,$3);
              }
          }
        | expr and expr %prec AND_SYM
          {
              $$ = fieldf(Lex, AND_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              $$->field_name.str="and";
              $$->field_name.length=3;

              if($1->field_type == AND_FIELD) {
                  addarglist($$,&($1->field_arg));                  
              } else {
                  addarg($$,$1);
              }
              if($3->field_type == AND_FIELD) {
                  addarglist($$,&($3->field_arg));                  
              }else {
                  addarg($$,$3);
              }
          }
        | NOT_SYM expr %prec NOT_SYM 
          {
              $$ = fieldnot(Lex,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bool_pri IS TRUE_SYM %prec IS 
          {
              $$ = fieldfone(Lex,ISTRUE_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS not TRUE_SYM %prec IS 
          {
              $$ = fieldfone(Lex,NOTTRUE_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS FALSE_SYM %prec IS 
          {
              $$ = fieldfone(Lex,ISFALSE_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS not FALSE_SYM %prec IS 
          {
              $$ = fieldfone(Lex,NOTFALSE_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS UNKNOWN_SYM %prec IS
          {
              $$ = fieldfone(Lex,ISNULL_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS not UNKNOWN_SYM %prec IS 
          {
              $$ = fieldfone(Lex,NOTNULL_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri 
          {
              $$ = $1;
          }
        ;

into_destination:
          OUTFILE TEXT_STRING_filesystem opt_load_data_charset opt_field_term opt_line_term
          {
              PARSEFIELD  *field = NULL;
              
              field = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if(field == NULL) {
                  MY_YYABORT;
              }

              field->field_type = OUTFILE_FIELD;
              field->field_charset = $3.str;

              parseaddlist(&(Select->sql_intolist), field);

          }
        | DUMPFILE TEXT_STRING_filesystem
          {
              PARSEFIELD  *field = NULL;
              
              field = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if(field == NULL) {
                  MY_YYABORT;
              }

              field->field_type = DUMPFILE_FIELD;

              parseaddlist(&(Select->sql_intolist), field);

          }
        | select_var_list_init {}
        ;

opt_load_data_charset:
          /* Empty */ { $$ = empty_lex_str; }
        | charset charset_name_or_default { $$= $2; }
        ;

charset_name_or_default:
          charset_name { $$=$1;   }
        | DEFAULT    
          {$$ = null_lex_str;}
        ;

opt_field_term:
          /* empty */
        | COLUMNS field_term_list
        ;

field_term_list:
          field_term_list field_term
        | field_term
        ;

field_term:
          TERMINATED BY text_string 
          {
              Select->sql_into_terminate = $3.str;
          } 
        | OPTIONALLY ENCLOSED BY text_string 
          {
              Select->sql_into_optionally = $4.str;
          }
        | ENCLOSED BY text_string 
          {
              Select->sql_into_enclosed = $3.str;
          }
        | ESCAPED BY text_string 
          {
              Select->sql_into_escape = $3.str;          
          }
        ;


opt_line_term:
          /* empty */
        | LINES line_term_list
        ;

line_term_list:
          line_term_list line_term
        | line_term
        ;

line_term:
          TERMINATED BY text_string 
          {
              Select->sql_into_lineterminate = $3.str;          
          }
        | STARTING BY text_string 
          {
              Select->sql_into_linestart = $3.str;          
          }
        ;

join_table_list:
          derived_table_list  
          { 
              $$ = $1;
          }
        ;

where_clause:
          /* empty */ { Select->sql_where = NULL; }
        | WHERE 
          {
            Select->parsing_place= IN_WHERE;
          }
          expr 
          {
              Select->sql_where = $3;              
              Select->parsing_place= NO_MATTER;

          } 
        ;

group_clause:
          /* empty */ {}
        | GROUP_SYM BY group_list olap_opt {} 
        ;

having_clause:
          /* empty */ { Select->sql_having = NULL; }
        | HAVING           
          {
            Select->parsing_place= IN_HAVING;
          }
          expr 
          {
              Select->sql_having = $3;     
              Select->parsing_place= NO_MATTER;
         
          } 
        ;

procedure_analyse_clause:
          /* empty */ {}
        | PROCEDURE_SYM ANALYSE_SYM '(' opt_procedure_analyse_params ')' {}
        ;

order_list:
          order_list ',' order_ident order_dir 
          {
              parseaddorder(Select,$3);
              $3->field_order_dir = $4;
              
          }
        | order_ident order_dir 
          {
              parseaddorder(Select,$1);
              $1->field_order_dir = $2;
          }
        ;

limit_options:
          limit_option 
          {
              Select->sql_sel_limit = $1;
              Select->sql_off_limit = NULL;
          }

        | limit_option ',' limit_option 
          {
              Select->sql_sel_limit = $3;
              Select->sql_off_limit = $1;
          }
        | limit_option OFFSET_SYM limit_option
         {
              Select->sql_sel_limit = $1;
              Select->sql_off_limit = $3;
         }
        ;










query_expression_option:
          STRAIGHT_JOIN { Select->sql_options|= SELECT_STRAIGHT_JOIN; }
        | HIGH_PRIORITY 
          {
             /*check_simple_select 校验 union*/
             Select->sql_options|= SELECT_HIGH_PRIORITY;
          }
        | DISTINCT     { Select->sql_options|= SELECT_DISTINCT; }
        | SQL_SMALL_RESULT  { Select->sql_options|= SELECT_SMALL_RESULT; }
        | SQL_BIG_RESULT   { Select->sql_options|= SELECT_BIG_RESULT; }
        | SQL_BUFFER_RESULT 
          {
            /*check_simple_select 校验 union*/
             Select->sql_options|= OPTION_BUFFER_RESULT;
          }
        | SQL_CALC_FOUND_ROWS 
          {
             /*check_simple_select 校验 union*/
             Select->sql_options|= OPTION_FOUND_ROWS;
          }
        | ALL { Select->sql_options|= SELECT_ALL; }
        ;

ident:
          IDENT_sys
          {

              $$=$1;
          }   
        | keyword 
          {

            $$.str= lexstrmake(Lex, $1.str, $1.length);
            if ($$.str == NULL)
            $$.length= $1.length;
          }
        ;

or:
          OR_SYM {}
       | OR2_SYM {}
       ;

and:
          AND_SYM {}
       | AND_AND_SYM {}
       ;

bool_pri:
          bool_pri IS NULL_SYM %prec IS 
          {
              $$ = fieldfone(Lex,ISNULL_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri IS not NULL_SYM %prec IS
          {
              $$ = fieldfone(Lex,NOTNULL_FIELD,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri EQUAL_SYM predicate %prec EQUAL_SYM 
          {
              $$ = fieldf(Lex,EQUAL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$,$1);
              addarg($$,$3);
          }
        | bool_pri comp_op predicate %prec EQ 
          {
              $$ = fieldoprate(Lex, COMPOP_FIELD,$2.str,$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | bool_pri comp_op all_or_any '(' subselect ')' %prec EQ 
          { 
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,$5);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }
              field_subsel->subselany = $3;

              $$ = fieldoprate(Lex, COMPOP_FIELD,$2.str,$1,field_subsel);
              if($$ == NULL) {
                  MY_YYABORT;
              }              

          }
        | predicate 
          {
              $$=$1;
          }
        ;

not:
          NOT_SYM 
        | NOT2_SYM 
        ;

TEXT_STRING_filesystem:
          TEXT_STRING
          {
              /*不同字符集之间的编码转换*/
              $$= $1;
          }
        ;

select_var_list_init:
          select_var_list {}
        ;

derived_table_list:
          esc_table_ref  
          {
              $$.head = $1; 
              $$.tail = $1;
              $$.fcount = 1;
              
          }
        | derived_table_list ',' esc_table_ref 
          {
              $1.tail->next = $3; 
              $1.tail = $3;
              ($1.fcount)++;
              $$ = $1;
          }
        ;

group_list:
          group_list ',' order_ident order_dir 
          {
              parseaddgroup(Select,$3);
              $3->field_order_dir = $4;
          }
        | order_ident order_dir 
          {
              parseaddgroup(Select,$1);
              $1->field_order_dir = $2;
          }
        ;

olap_opt:
          /* empty */ { Select->olap_type = UNSPECIFIED_OLAP_TYPE; }
        | WITH_CUBE_SYM { Select->olap_type = CUBE_TYPE; }
        | WITH_ROLLUP_SYM { Select->olap_type = ROLLUP_TYPE; }
        ;

opt_procedure_analyse_params:
          /* empty */ {}
        | procedure_analyse_param 
          {
              Select->sql_proc_analyse_treeelement = $1;
          }
        | procedure_analyse_param ',' procedure_analyse_param 
          {
              Select->sql_proc_analyse_treeelement = $1;
              Select->sql_proc_analyse_treemem = $3;

          }
        ;
order_ident:
          expr 
          { 
              $1->field_type = ORDERBY_FIELD;
              $$=$1; 
          }
        ;

order_dir:
          /* empty */ { $$ =  1; }
        | ASC  { $$ =1; }
        | DESC { $$ =0; }
        ;

limit_option:
          ident 
          { 
              $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$1);
              if( $$ == NULL) {
                  MY_YYABORT;
              }
               
          }
        | param_marker { $$ = $1;}
        | ULONGLONG_NUM 
          {
              $$ = (PARSEFIELD *)fieldnum(Lex,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = ULONGLONGNUM_FIELD;

          }
        | LONG_NUM 
          {
              $$ = (PARSEFIELD *)fieldnum(Lex,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = LONGNUM_FIELD;

          }
        | NUM 
          {
              $$ = (PARSEFIELD *)fieldnum(Lex,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;









procedure_analyse_param:
          NUM { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        ;

IDENT_sys:
          IDENT 
          {
              $$= $1;
          }
        | IDENT_QUOTED  /*不同字符集之间的编码转换*/
          { 
              $$= $1;
          }
        ;

keyword:
          keyword_sp            {}
        | ASCII_SYM             {}
        | BACKUP_SYM            {}
        | BEGIN_SYM             {}
        | BYTE_SYM              {}
        | CACHE_SYM             {}
        | CHARSET               {}
        | CHECKSUM_SYM          {}
        | CLOSE_SYM             {}
        | COMMENT_SYM           {}
        | COMMIT_SYM            {}
        | CONTAINS_SYM          {}
        | DEALLOCATE_SYM        {}
        | DO_SYM                {}
        | END                   {}
        | EXECUTE_SYM           {}
        | FLUSH_SYM             {}
        | FORMAT_SYM            {}
        | HANDLER_SYM           {}
        | HELP_SYM              {}
        | HOST_SYM              {}
        | INSTALL_SYM           {}
        | LANGUAGE_SYM          {}
        | NO_SYM                {}
        | OPEN_SYM              {}
        | OPTIONS_SYM           {}
        | OWNER_SYM             {}
        | PARSER_SYM            {}
        | PORT_SYM              {}
        | PREPARE_SYM           {}
        | REMOVE_SYM            {}
        | REPAIR                {}
        | RESET_SYM             {}
        | RESTORE_SYM           {}
        | ROLLBACK_SYM          {}
        | SAVEPOINT_SYM         {}
        | SECURITY_SYM          {}
        | SERVER_SYM            {}
        | SIGNED_SYM            {}
        | SOCKET_SYM            {}
        | SLAVE                 {}
        | SONAME_SYM            {}
        | START_SYM             {}
        | STOP_SYM              {}
        | TRUNCATE_SYM          {}
        | UNICODE_SYM           {}
        | UNINSTALL_SYM         {}
        | WRAPPER_SYM           {}
        | XA_SYM                {}
        | UPGRADE_SYM           {}
        ;

predicate:
          bit_expr IN_SYM '(' subselect ')' 
          {
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,$4);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              $1->field_in = field_subsel;
          }
        | bit_expr not IN_SYM '(' subselect ')' 
          {
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,$5);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              $1->field_not_in = field_subsel;
          }
        | bit_expr IN_SYM '(' expr ')' 
          {
              $1->field_in = $4;
              $$ = $1;
          }
        | bit_expr IN_SYM '(' expr ',' expr_list ')'
          { 
              $4->next = $6.head;
              $1->field_in = $4;
              $$ = $1;

          }
        | bit_expr not IN_SYM '(' expr ')' 
          {
              $1->field_not_in = $5;
              $$ = $1;
          }
        | bit_expr not IN_SYM '(' expr ',' expr_list ')' 
          { 
              $5->next = $7.head;
              $1->field_not_in = $5;
              $$ = $1;

          }
        | bit_expr BETWEEN_SYM bit_expr AND_SYM predicate 
          { 
              $3->next = $5;
              $1->field_between = $3;
              $$ = $1;
          }
        | bit_expr not BETWEEN_SYM bit_expr AND_SYM predicate 
          { 
              $4->next = $6;
              $1->field_not_between = $4;
              $$ = $1;
          }
        | bit_expr SOUNDS_SYM LIKE bit_expr 
          {
              $1->field_like = $4;
              $$ = $1;
          }
        | bit_expr LIKE simple_expr opt_escape 
          {
              $1->field_like = $3;
              $1->field_escape = $4;
              $$ = $1;
          
          }
        | bit_expr not LIKE simple_expr opt_escape
          {
              $1->field_not_like = $4;
              $1->field_escape = $5;
              $$ = $1;
          
          }
        | bit_expr REGEXP bit_expr 
          {
              $1->field_regexp = $3;
              $$ = $1;
          
          }
        | bit_expr not REGEXP bit_expr 
          {
              $1->field_not_regexp = $4;
              $$ = $1;
          
          }
        | bit_expr 
          {
              $$ = $1;
          }
        ;

comp_op:
          EQ      
          {
              /*
              $$.str= lexstrmake(Lex, "=", 2);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = "=";
              $$.length= 1;
          }          
        | GE      
          {
              /*
              $$.str= lexstrmake(Lex, ">=", 3);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = ">=";
              $$.length= 2;
          }
        | GT_SYM 
          {
              /*
              $$.str= lexstrmake(Lex, ">", 2);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = ">";
              $$.length= 1;
          }
        | LE      
          {
              /*
              $$.str= lexstrmake(Lex, "<=", 3);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = "<=";
              $$.length= 2;
          }

        | LT     
          {
              /*

              $$.str= lexstrmake(Lex, "<", 2);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = "<";
              $$.length= 1;
          }
        | NE    
          {
              /*

              $$.str= lexstrmake(Lex, "!=", 3);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              */
              $$.str = "!=";
              $$.length= 2;
          }
        ;

all_or_any:
          ALL     { $$ = 1; }
        | ANY_SYM { $$ = 0; }
        ;

subselect:
          subselect_start query_expression_body subselect_end
          {
            $$= $2;
          }
          
        ;

select_var_list:
          select_var_list ',' select_var_ident  {}
        | select_var_ident {}
        ;

esc_table_ref:
        table_ref 
        { 
            $$=$1; 
            
        }
      | '{' ident table_ref '}' { $$=$3; }
      ;

param_marker:
          PARAM_MARKER  
          {
              $$ = fieldparam(Lex,  (int) (get_tok_start(Lip) - get_buf(Lip)));
              if($$ == NULL ) {
                  MY_YYABORT;
              }
          }
        ;












keyword_sp:
          ACTION                   {}
        | ADDDATE_SYM              {}
        | AFTER_SYM                {}
        | AGAINST                  {}
        | AGGREGATE_SYM            {}
        | ALGORITHM_SYM            {}
        | ANALYSE_SYM              {}
        | ANY_SYM                  {}
        | AT_SYM                   {}
        | AUTO_INC                 {}
        | AUTOEXTEND_SIZE_SYM      {}
        | AVG_ROW_LENGTH           {}
        | AVG_SYM                  {}
        | BINLOG_SYM               {}
        | BIT_SYM                  {}
        | BLOCK_SYM                {}
        | BOOL_SYM                 {}
        | BOOLEAN_SYM              {}
        | BTREE_SYM                {}
        | CASCADED                 {}
        | CATALOG_NAME_SYM         {}
        | CHAIN_SYM                {}
        | CHANGED                  {}
        | CIPHER_SYM               {}
        | CLIENT_SYM               {}
        | CLASS_ORIGIN_SYM         {}
        | COALESCE                 {}
        | CODE_SYM                 {}
        | COLLATION_SYM            {}
        | COLUMN_NAME_SYM          {}
        | COLUMN_FORMAT_SYM        {}
        | COLUMNS                  {}
        | COMMITTED_SYM            {}
        | COMPACT_SYM              {}
        | COMPLETION_SYM           {}
        | COMPRESSED_SYM           {}
        | CONCURRENT               {}
        | CONNECTION_SYM           {}
        | CONSISTENT_SYM           {}
        | CONSTRAINT_CATALOG_SYM   {}
        | CONSTRAINT_SCHEMA_SYM    {}
        | CONSTRAINT_NAME_SYM      {}
        | CONTEXT_SYM              {}
        | CPU_SYM                  {}
        | CUBE_SYM                 {}
        | CURRENT_SYM              {}
        | CURSOR_NAME_SYM          {}
        | DATA_SYM                 {}
        | DATAFILE_SYM             {}
        | DATETIME                 {}
        | DATE_SYM                 {}
        | DAY_SYM                  {}
        | DEFAULT_AUTH_SYM         {}
        | DEFINER_SYM              {}
        | DELAY_KEY_WRITE_SYM      {}
        | DES_KEY_FILE             {}
        | DIAGNOSTICS_SYM          {}
        | DIRECTORY_SYM            {}
        | DISABLE_SYM              {}
        | DISCARD                  {}
        | DISK_SYM                 {}
        | DUMPFILE                 {}
        | DUPLICATE_SYM            {}
        | DYNAMIC_SYM              {}
        | ENDS_SYM                 {}
        | ENUM                     {}
        | ENGINE_SYM               {}
        | ENGINES_SYM              {}
        | ERROR_SYM                {}
        | ERRORS                   {}
        | ESCAPE_SYM               {}
        | EVENT_SYM                {}
        | EVENTS_SYM               {}
        | EVERY_SYM                {}
        | EXCHANGE_SYM             {}
        | EXPANSION_SYM            {}
        | EXPIRE_SYM               {}
        | EXPORT_SYM               {}
        | EXTENDED_SYM             {}
        | EXTENT_SIZE_SYM          {}
        | FAULTS_SYM               {}
        | FAST_SYM                 {}
        | FOUND_SYM                {}
        | ENABLE_SYM               {}
        | FULL                     {}
        | FILE_SYM                 {}
        | FIRST_SYM                {}
        | FIXED_SYM                {}
        | GENERAL                  {}
        | GEOMETRY_SYM             {}
        | GEOMETRYCOLLECTION       {}
        | GET_FORMAT               {}
        | GRANTS                   {}
        | GLOBAL_SYM               {}
        | HASH_SYM                 {}
        | HOSTS_SYM                {}
        | HOUR_SYM                 {}
        | IDENTIFIED_SYM           {}
        | IGNORE_SERVER_IDS_SYM    {}
        | INVOKER_SYM              {}
        | IMPORT                   {}
        | INDEXES                  {}
        | INITIAL_SIZE_SYM         {}
        | IO_SYM                   {}
        | IPC_SYM                  {}
        | ISOLATION                {}
        | ISSUER_SYM               {}
        | INSERT_METHOD            {}
        | KEY_BLOCK_SIZE           {}
        | LAST_SYM                 {}
        | LEAVES                   {}
        | LESS_SYM                 {}
        | LEVEL_SYM                {}
        | LINESTRING               {}
        | LIST_SYM                 {}
        | LOCAL_SYM                {}
        | LOCKS_SYM                {}
        | LOGFILE_SYM              {}
        | LOGS_SYM                 {}
        | MAX_ROWS                 {}
        | MASTER_SYM               {}
        | MASTER_HEARTBEAT_PERIOD_SYM {}
        | MASTER_HOST_SYM          {}
        | MASTER_PORT_SYM          {}
        | MASTER_LOG_FILE_SYM      {}
        | MASTER_LOG_POS_SYM       {}
        | MASTER_USER_SYM          {}
        | MASTER_PASSWORD_SYM      {}
        | MASTER_SERVER_ID_SYM     {}
        | MASTER_CONNECT_RETRY_SYM {}
        | MASTER_RETRY_COUNT_SYM   {}
        | MASTER_DELAY_SYM         {}
        | MASTER_SSL_SYM           {}
        | MASTER_SSL_CA_SYM        {}
        | MASTER_SSL_CAPATH_SYM    {}
        | MASTER_SSL_CERT_SYM      {}
        | MASTER_SSL_CIPHER_SYM    {}
        | MASTER_SSL_CRL_SYM       {}
        | MASTER_SSL_CRLPATH_SYM   {}
        | MASTER_SSL_KEY_SYM       {}
        | MASTER_AUTO_POSITION_SYM {}
        | MAX_CONNECTIONS_PER_HOUR {}
        | MAX_QUERIES_PER_HOUR     {}
        | MAX_SIZE_SYM             {}
        | MAX_UPDATES_PER_HOUR     {}
        | MAX_USER_CONNECTIONS_SYM {}
        | MEDIUM_SYM               {}
        | MEMORY_SYM               {}
        | MERGE_SYM                {}
        | MESSAGE_TEXT_SYM         {}
        | MICROSECOND_SYM          {}
        | MIGRATE_SYM              {}
        | MINUTE_SYM               {}
        | MIN_ROWS                 {}
        | MODIFY_SYM               {}
        | MODE_SYM                 {}
        | MONTH_SYM                {}
        | MULTILINESTRING          {}
        | MULTIPOINT               {}
        | MULTIPOLYGON             {}
        | MUTEX_SYM                {}
        | MYSQL_ERRNO_SYM          {}
        | NAME_SYM                 {}
        | NAMES_SYM                {}
        | NATIONAL_SYM             {}
        | NCHAR_SYM                {}
        | NDBCLUSTER_SYM           {}
        | NEXT_SYM                 {}
        | NEW_SYM                  {}
        | NO_WAIT_SYM              {}
        | NODEGROUP_SYM            {}
        | NONE_SYM                 {}
        | NUMBER_SYM               {}
        | NVARCHAR_SYM             {}
        | OFFSET_SYM               {}
        | OLD_PASSWORD             {}
        | ONE_SYM                  {}
        | ONLY_SYM                 {}
        | PACK_KEYS_SYM            {}
        | PAGE_SYM                 {}
        | PARTIAL                  {}
        | PARTITIONING_SYM         {}
        | PARTITIONS_SYM           {}
        | PASSWORD                 {}
        | PHASE_SYM                {}
        | PLUGIN_DIR_SYM           {}
        | PLUGIN_SYM               {}
        | PLUGINS_SYM              {}
        | POINT_SYM                {}
        | POLYGON                  {}
        | PRESERVE_SYM             {}
        | PREV_SYM                 {}
        | PRIVILEGES               {}
        | PROCESS                  {}
        | PROCESSLIST_SYM          {}
        | PROFILE_SYM              {}
        | PROFILES_SYM             {}
        | PROXY_SYM                {}
        | QUARTER_SYM              {}
        | QUERY_SYM                {}
        | QUICK                    {}
        | READ_ONLY_SYM            {}
        | REBUILD_SYM              {}
        | RECOVER_SYM              {}
        | REDO_BUFFER_SIZE_SYM     {}
        | REDOFILE_SYM             {}
        | REDUNDANT_SYM            {}
        | RELAY                    {}
        | RELAYLOG_SYM             {}
        | RELAY_LOG_FILE_SYM       {}
        | RELAY_LOG_POS_SYM        {}
        | RELAY_THREAD             {}
        | RELOAD                   {}
        | REORGANIZE_SYM           {}
        | REPEATABLE_SYM           {}
        | REPLICATION              {}
        | RESOURCES                {}
        | RESUME_SYM               {}
        | RETURNED_SQLSTATE_SYM    {}
        | RETURNS_SYM              {}
        | REVERSE_SYM              {}
        | ROLLUP_SYM               {}
        | ROUTINE_SYM              {}
        | ROWS_SYM                 {}
        | ROW_COUNT_SYM            {}
        | ROW_FORMAT_SYM           {}
        | ROW_SYM                  {}
        | RTREE_SYM                {}
        | SCHEDULE_SYM             {}
        | SCHEMA_NAME_SYM          {}
        | SECOND_SYM               {}
        | SERIAL_SYM               {}
        | SERIALIZABLE_SYM         {}
        | SESSION_SYM              {}
        | SIMPLE_SYM               {}
        | SHARE_SYM                {}
        | SHUTDOWN                 {}
        | SLOW                     {}
        | SNAPSHOT_SYM             {}
        | SOUNDS_SYM               {}
        | SOURCE_SYM               {}
        | SQL_AFTER_GTIDS          {}
        | SQL_AFTER_MTS_GAPS       {}
        | SQL_BEFORE_GTIDS         {}
        | SQL_CACHE_SYM            {}
        | SQL_BUFFER_RESULT        {}
        | SQL_NO_CACHE_SYM         {}
        | SQL_THREAD               {}
        | STARTS_SYM               {}
        | STATS_AUTO_RECALC_SYM    {}
        | STATS_PERSISTENT_SYM     {}
        | STATS_SAMPLE_PAGES_SYM   {}
        | STATUS_SYM               {}
        | STORAGE_SYM              {}
        | STRING_SYM               {}
        | SUBCLASS_ORIGIN_SYM      {}
        | SUBDATE_SYM              {}
        | SUBJECT_SYM              {}
        | SUBPARTITION_SYM         {}
        | SUBPARTITIONS_SYM        {}
        | SUPER_SYM                {}
        | SUSPEND_SYM              {}
        | SWAPS_SYM                {}
        | SWITCHES_SYM             {}
        | TABLE_NAME_SYM           {}
        | TABLES                   {}
        | TABLE_CHECKSUM_SYM       {}
        | TABLESPACE               {}
        | TEMPORARY                {}
        | TEMPTABLE_SYM            {}
        | TEXT_SYM                 {}
        | THAN_SYM                 {}
        | TRANSACTION_SYM          {}
        | TRIGGERS_SYM             {}
        | TIMESTAMP                {}
        | TIMESTAMP_ADD            {}
        | TIMESTAMP_DIFF           {}
        | TIME_SYM                 {}
        | TYPES_SYM                {}
        | TYPE_SYM                 {}
        | UDF_RETURNS_SYM          {}
        | FUNCTION_SYM             {}
        | UNCOMMITTED_SYM          {}
        | UNDEFINED_SYM            {}
        | UNDO_BUFFER_SIZE_SYM     {}
        | UNDOFILE_SYM             {}
        | UNKNOWN_SYM              {}
        | UNTIL_SYM                {}
        | USER                     {}
        | USE_FRM                  {}
        | VARIABLES                {}
        | VIEW_SYM                 {}
        | VALUE_SYM                {}
        | WARNINGS                 {}
        | WAIT_SYM                 {}
        | WEEK_SYM                 {}
        | WORK_SYM                 {}
        | WEIGHT_STRING_SYM        {}
        | X509_SYM                 {}
        | XML_SYM                  {}
        | YEAR_SYM                 {}
        ;

bit_expr:
          bit_expr '|' bit_expr %prec '|' 
          {            
              $$ = fieldoprate(Lex, BITOR_FIELD,"|",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '&' bit_expr %prec '&' 
          {            
              $$ = fieldoprate(Lex, BITAND_FIELD,"&",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr SHIFT_LEFT bit_expr %prec SHIFT_LEFT
          {            
              $$ = fieldoprate(Lex, SHIFTLEFT_FIELD,"<<",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr SHIFT_RIGHT bit_expr %prec SHIFT_RIGHT 
          {            
              $$ = fieldoprate(Lex, SHIFTRIGHT_FIELD,">>",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '+' bit_expr %prec '+' 
          {            
              $$ = fieldoprate(Lex, PLUS_FIELD,"+",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '-' bit_expr %prec '-' 
          {            
              $$ = fieldoprate(Lex, MINUS_FIELD,"-",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '+' INTERVAL_SYM expr interval %prec '+' 
          {            
              $$ = fieldoprate(Lex, PLUS_FIELD,"+",$1,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $4->field_interval=$5;
          }
        | bit_expr '-' INTERVAL_SYM expr interval %prec '-'
          {            
              $$ = fieldoprate(Lex, MINUS_FIELD,"-",$1,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              $4->field_interval=$5;

          }
        | bit_expr '*' bit_expr %prec '*' 
          {            
              $$ = fieldoprate(Lex, MUL_FIELD,"*",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '/' bit_expr %prec '/' 
          {            
              $$ = fieldoprate(Lex, DIV_FIELD,"/",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '%' bit_expr %prec '%' 
          {            
              $$ = fieldoprate(Lex, MOD_FIELD,"%",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr DIV_SYM bit_expr %prec DIV_SYM
          {            
              $$ = fieldoprate(Lex, DIV_FIELD,"/",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr MOD_SYM bit_expr %prec MOD_SYM
          {            
              $$ = fieldoprate(Lex, MOD_FIELD,"%",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | bit_expr '^' bit_expr 
          {            
              $$ = fieldoprate(Lex, BITXOR_FIELD,"^",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | simple_expr 
          {
              $$ =$1;
          }
        ;

expr_list:
          expr 
          {
              $$.head = $1;
              $$.tail = $1;      
              $$.fcount = 1;
            
          }
        | expr_list ',' expr 
          {
              $1.tail->next =  $3;
              $1.tail =  $3;
              ($1.fcount)++;
              $$ = $1;             
          }
        ;

simple_expr:
          simple_ident 
          {
              $$ =$1;
          }
        | function_call_keyword 
        | function_call_nonkeyword 
        | function_call_generic
        | function_call_conflict
        | simple_expr COLLATE_SYM ident_or_text %prec NEG 
          {

              PARSEFIELD *field;
              field = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }

              $$ = fieldf(Lex,FUNC_COLLATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $1);
              addarg($$, field);
              
          }
        | literal
        | param_marker 
        | variable 
        | sum_expr
          {

          }
        | simple_expr OR_OR_SYM simple_expr 
          {
              $$ = fieldoprate(Lex, OR_OR_FIELD,"||",$1,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | '+' simple_expr %prec NEG 
          {
              $$= $2;
          }
        | '-' simple_expr %prec NEG 
          {
              $$ = fieldneg(Lex,NEG_FIELD,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | '~' simple_expr %prec NEG 
          {
              $$ = fieldneg(Lex,BITNEG_FIELD,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | not2 simple_expr %prec NEG
          {
              $$ = fieldnot(Lex,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | '(' subselect ')' 
          {
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,$2);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              $$ = field_subsel;
          }
        | '(' expr ')' { $$ = $2; }
        | '(' expr ',' expr_list ')' 
          {
              $$ = fieldf(Lex,ROW_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $2);
              addarglist($$, &($4));

          }
        | ROW_SYM '(' expr ',' expr_list ')' 
          {
              $$ = fieldf(Lex,ROW_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarglist($$, &($5));
          }
        | EXISTS '(' subselect ')'
          {
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,$3);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              $$ = fieldf(Lex,FUNC_EXISTS_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, field_subsel);              
          }
        | '{' ident expr '}' { $$ = $3;}
        | MATCH ident_list_arg AGAINST '(' bit_expr fulltext_options ')'
          {
              $$ = fieldf(Lex,FUNC_MATCH_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarglist($$, &($2));
              $$->field_against = $5;
              $5->field_fulltext = $6;
          }
        | BINARY simple_expr %prec NEG 
          {
              $2->field_type = BINARY_FIELD;
              $$=$2;
          }
        | CAST_SYM '(' expr AS cast_type ')'
          {
              $$ = fieldf(Lex,FUNC_CAST_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              $3->field_casttype = $5;
          }
        | CASE_SYM opt_expr when_list opt_else END 
          {
              $$ = fieldf(Lex,FUNC_CASE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              if($2 != NULL) {
                  addarg($$, $2);
              }
              
              if($3.fcount != 0) {
                  $$->field_when = $3.head;
              }

              if($4 != NULL) {
                  $$->field_else = $4;
              }
          }
        | CONVERT_SYM '(' expr ',' cast_type ')' 
          {
              $$ = fieldf(Lex,FUNC_CONVERT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              $3->field_casttype = $5;
          }
        | CONVERT_SYM '(' expr USING charset_name ')' 
          {
              $$ = fieldf(Lex,FUNC_CONVERT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              $3->field_charset = $5.str;
          }
        | DEFAULT '(' simple_ident ')' 
          {
              $$ = fieldf(Lex,DEFAULT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
          }
        | VALUES '(' simple_ident_nospvar ')' 
          {
              $$ = fieldf(Lex,INSERTVALUE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
          }
        | INTERVAL_SYM expr interval '+' expr %prec INTERVAL_SYM 
          {
              $$ = fieldoprate(Lex, PLUS_FIELD,"+",$2,$5);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $2->field_interval = $3;
          }
        ;

opt_escape:
          ESCAPE_SYM simple_expr  { $$ = $2; }
        | /* empty */ 
          {
              $$ = NULL;
          }

        ;

subselect_start:
          {
              SQLPARSESEL *sel;   
              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }

              sel->sql_command = SQLCOM_SELECT;

              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;


              sel->prev = Select;
              Select = sel;
          }
        ;

query_expression_body:
          query_specification opt_union_order_or_limit 
          {
              $$ = $1;
          }
        | query_expression_body UNION_SYM union_option 
          {
              SQLPARSESEL *sel;   
              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }

              sel->sql_command = SQLCOM_SELECT;

              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,sel);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }
              field_subsel->field_union_opt = $3;

              parseaddlist(&(Select->sql_unionlist), field_subsel);
              
              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;


              sel->prev = Select;
             
              Select = sel;
          }
          query_specification opt_union_order_or_limit 
          {
              Select= Select->prev;              
          }
        ;

subselect_end:
          {
              Select = Select->prev;
          }
        ;

select_var_ident:  
          '@' ident_or_text 
          {
              PARSEFIELD  *field = NULL;
              
              field = fieldvariable(Lex, $2,OPT_DEFAULT );
              if( field == NULL) {
                  MY_YYABORT;
              }
              parseaddlist(&(Select->sql_intolist), field);
          }
        | ident_or_text 
          {
              PARSEFIELD  *field = NULL;
              field = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddlist(&(Select->sql_intolist), field);
          }
        ;

table_ref:
          table_factor 
          { 
              $$=$1; 
              
          }
        | join_table { $$=$1; }
        ;










interval:
          interval_time_stamp    { $$=$1;}
        | DAY_HOUR_SYM           { $$=INTERVAL_DAY_HOUR; }
        | DAY_MICROSECOND_SYM    { $$=INTERVAL_DAY_MICROSECOND; }
        | DAY_MINUTE_SYM         { $$=INTERVAL_DAY_MINUTE; }
        | DAY_SECOND_SYM         { $$=INTERVAL_DAY_SECOND; }
        | HOUR_MICROSECOND_SYM   { $$=INTERVAL_HOUR_MICROSECOND; }
        | HOUR_MINUTE_SYM        { $$=INTERVAL_HOUR_MINUTE; }
        | HOUR_SECOND_SYM        { $$=INTERVAL_HOUR_SECOND; }
        | MINUTE_MICROSECOND_SYM { $$=INTERVAL_MINUTE_MICROSECOND; }
        | MINUTE_SECOND_SYM      { $$=INTERVAL_MINUTE_SECOND; }
        | SECOND_MICROSECOND_SYM { $$=INTERVAL_SECOND_MICROSECOND; }
        | YEAR_MONTH_SYM         { $$=INTERVAL_YEAR_MONTH; }
        ;

simple_ident:
          ident 
          {
              if ((Select->parsing_place != IN_HAVING) || Select->sql_in_sum_expr > 0) {
                  $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$1);
              } else {

                  /*ref 相关  作用*/
                  $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              }

              if ($$ == NULL)
                  MY_YYABORT;
          }
        | simple_ident_q  {$$= $1;}
        ;

function_call_keyword:
          CHAR_SYM '(' expr_list ')' 
          {
              $$ = fieldf(Lex,FUNC_CHAR_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | CHAR_SYM '(' expr_list USING charset_name ')' 
          {
              $$ = fieldf(Lex,FUNC_CHAR_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));
              $$->field_charset = $5.str;

          }
        | CURRENT_USER optional_braces
          {
              $$ = fieldf(Lex,FUNC_CURUSER_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | DATE_SYM '(' expr ')'
          {
              $$ = fieldfone(Lex,FUNC_DATE_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | DAY_SYM '(' expr ')'
          {
              $$ = fieldfone(Lex,FUNC_DAY_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | HOUR_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_HOUR_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | INSERT '(' expr ',' expr ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_INSERT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);
              addarg($$, $7);
              addarg($$, $9);

          }
        | INTERVAL_SYM '(' expr ',' expr ')' %prec INTERVAL_SYM 
          {
              $$ = fieldf(Lex,FUNC_INTERVAL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);

          }
        | INTERVAL_SYM '(' expr ',' expr ',' expr_list ')' %prec INTERVAL_SYM 
          {
              $$ = fieldf(Lex,FUNC_INTERVAL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);
              addarglist($$, &($7));

          }
        | LEFT '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_LEFT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);

          }
        | MINUTE_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MINUTE_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | MONTH_SYM '(' expr ')'
          {
              $$ = fieldfone(Lex,FUNC_MONTH_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | RIGHT '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_RIGHT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);

          }
        | SECOND_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_SECOND_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | TIME_SYM '(' expr ')'
          {
              $$ = fieldfone(Lex,FUNC_TIME_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | TIMESTAMP '(' expr ')'
          {
              $$ = fieldfone(Lex,FUNC_TIMESTAMP_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | TIMESTAMP '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_TIMESTAMP_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              addarg($$, $5);

          }
        | TRIM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_TRIM_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | TRIM '(' LEADING expr FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_LTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $4);
            
              $4->field_from = $6;

          }
        | TRIM '(' TRAILING expr FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_RTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $4);
              $4->field_from = $6;

          }
        | TRIM '(' BOTH expr FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_BTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $4);
              $4->field_from = $6;


          }
        | TRIM '(' LEADING FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_LTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              $$->field_from = $5;

          }
        | TRIM '(' TRAILING FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_RTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_from = $5;

          }
        | TRIM '(' BOTH FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_BTRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_from = $5;

          }
        | TRIM '(' expr FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_TRIM_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarg($$, $3);
              $3->field_from = $5;


          }
        | USER '(' ')' 
          {
              $$ = fieldf(Lex,FUNC_USER_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }

        | YEAR_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_YEAR_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

function_call_nonkeyword:
          ADDDATE_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_ADDDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
          }
        | ADDDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')'
          {
              $$ = fieldf(Lex,FUNC_ADDDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $6);
              
              $6->field_interval = $7;
          }
        | CURDATE optional_braces 
          {
              $$ = fieldf(Lex,FUNC_CURDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | CURTIME func_datetime_precision 
          {
              $$ = fieldf(Lex,FUNC_CURTIME_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_datetime_precision = $2;
          }

        | DATE_ADD_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')' %prec INTERVAL_SYM 
          {
              $$ = fieldf(Lex,FUNC_DATEADDINTERVAL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $6);
              
              $6->field_interval = $7;
          }
        | DATE_SUB_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')' %prec INTERVAL_SYM 
          {
              $$ = fieldf(Lex,FUNC_DATESUBINTERVAL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $6);
              
              $6->field_interval = $7;
          }
        | EXTRACT_SYM '(' interval FROM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_EXTRACT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_interval = $3;
              $$->field_from = $5;

          }
        | GET_FORMAT '(' date_time_type  ',' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_GETFORMAT_FIELD,$5);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $5->field_timestamp_type = $3;

          }
        | now { $$ = $1; }
        | POSITION_SYM '(' bit_expr IN_SYM expr ')' 
          {
              $$ = fieldf(Lex,FUNC_POSITION_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              $$->field_in = $5;

          }
        | SUBDATE_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_SUBDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
          }
        | SUBDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')' 
          {
              $$ = fieldf(Lex,FUNC_SUBDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $6);

              $6->field_interval = $7;
          }
        | SUBSTRING '(' expr ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_SUBSTRING_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
              addarg($$, $7);

          }
        | SUBSTRING '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_SUBSTRING_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
          }
        | SUBSTRING '(' expr FROM expr FOR_SYM expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_SUBSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_from = $5;
              $$->field_for = $7;


          }
        | SUBSTRING '(' expr FROM expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_SUBSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_from = $5;

          }
        | SYSDATE func_datetime_precision 
          {
              $$ = fieldf(Lex,FUNC_SYSDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_datetime_precision = $2;
          }
        | TIMESTAMP_ADD '(' interval_time_stamp ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_TIMESTAMPADD_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_interval = $3;
              addarg($$, $5);
              addarg($$, $7);
          }
        | TIMESTAMP_DIFF '(' interval_time_stamp ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_TIMESTAMPDIFF_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_interval = $3;
              addarg($$, $5);
              addarg($$, $7);
          }
        | UTC_DATE_SYM optional_braces
          {
              $$ = fieldf(Lex,FUNC_UTCDATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | UTC_TIME_SYM func_datetime_precision 
          {
              $$ = fieldf(Lex,FUNC_UTCTIME_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_datetime_precision = $2;

          }
        | UTC_TIMESTAMP_SYM func_datetime_precision
          {
              $$ = fieldf(Lex,FUNC_UTCTIMESTAMP_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_datetime_precision = $2;
          }
        ;

function_call_generic:
          IDENT_sys '(' 
          {
              Select->sql_in_sum_expr++;
          }
          opt_udf_expr_list ')' 
          {
              $$ = fieldfuser(Lex,FUNC_UDF_FUNC);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_name.str=$1.str;
              $$->field_name.length=$1.length;


              addarglist($$, &($4));
              Select->sql_in_sum_expr--;

          }
        | ident '.' ident '(' opt_expr_list ')' 
          {
              $$ = fieldfuser(Lex,FUNC_UDF_FUNC);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_name.str=$3.str;
              $$->field_name.length=$3.length;                

              $$->field_db=$1.str;
              addarglist($$, &($5));
          }
        ;

function_call_conflict:
          ASCII_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_ASCII_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | CHARSET '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_CHARSET_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | COALESCE '(' expr_list ')'
          {
              $$ = fieldf(Lex,FUNC_COALESCE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));
          }
        | COLLATION_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_COLLATION_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | DATABASE '(' ')' 
          {
              $$ = fieldf(Lex,FUNC_DATABASE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | IF '(' expr ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_IF_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
              addarg($$, $7);

          }
        | FORMAT_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_FORMAT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | FORMAT_SYM '(' expr ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_FORMAT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
              addarg($$, $7);
          }
        | MICROSECOND_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MICROSECOND_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | MOD_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_MOD_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | OLD_PASSWORD '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_OLDPASSWORD_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | PASSWORD '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_PASSWORD_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | QUARTER_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_QUARTER_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | REPEAT_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_REPEAT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | REPLACE '(' expr ',' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_REPLACE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);
              addarg($$, $7);

          }
        | REVERSE_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_REVERSE_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | ROW_COUNT_SYM '(' ')' 
          {
              $$ = fieldf(Lex,FUNC_ROWCOUNT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | TRUNCATE_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_TRUNCATE_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | WEEK_SYM '(' expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_WEEK_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | WEEK_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_WEEK_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | WEIGHT_STRING_SYM '(' expr opt_ws_levels ')' 
          {
              $$ = fieldfone(Lex,FUNC_WEIGHTSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
            
              $3->field_ws_levels = $4;
          }
        | WEIGHT_STRING_SYM '(' expr AS CHAR_SYM ws_nweights opt_ws_levels ')' 
          {
              $$ = fieldfone(Lex,FUNC_WEIGHTSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
            
              $3->field_ws_levels = $7;
              $3->field_ws_nweights = $6;

          }
        | WEIGHT_STRING_SYM '(' expr AS BINARY ws_nweights ')' 
          {
              $$ = fieldfone(Lex,FUNC_WEIGHTSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $3->field_ws_nweights = $6;

          }
        | WEIGHT_STRING_SYM '(' expr ',' ulong_num ',' ulong_num ',' ulong_num ')' 
          {
              $$ = fieldfone(Lex,FUNC_WEIGHTSTRING_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_weightstrleng[0] = $5;
              $$->field_weightstrleng[1] = $7;
              $$->field_weightstrleng[2] = $9;

          }
        | geometry_function { $$ = $1;}
        ;

ident_or_text:
          ident           { $$=$1; }
        | TEXT_STRING_sys { $$=$1; }
        | LEX_HOSTNAME  { $$=$1; }
        ;

literal:
          text_literal  { $$ = $1;}
        | NUM_literal  { $$ = $1; }
        | temporal_literal { $$= $1;}
        | NULL_SYM 
          {
              LEX_STRING lex_str   =  {"NULL", 4};
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = NULL_FIELD;

          }
        | FALSE_SYM
          {
              LEX_STRING lex_str   =  {"FALSE", 5};
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = FALSE_FIELD;

          }        
        | TRUE_SYM 
        {
              LEX_STRING lex_str   =  {"TRUE", 4};
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = TRUE_FIELD;

          }   
        | HEX_NUM 
          {
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_type = HEXNUM_FIELD;
          } 
        | BIN_NUM 
        {
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = BINNUM_FIELD;

          } 
        | UNDERSCORE_CHARSET HEX_NUM 
          {
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = HEXNUM_FIELD;
              $$->field_charset = "UNDERSCORE";
          }         
        | UNDERSCORE_CHARSET BIN_NUM 
         {
              
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = BINNUM_FIELD;
              $$->field_charset = "UNDERSCORE";
          } 
        ;

variable:
          '@' variable_aux 
          {
              $$ = $2;
          }
        ;

sum_expr:
          AVG_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_AVG_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              
          }
        | AVG_SYM '(' DISTINCT in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_AVGDISTINCT_FIELD,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }

        | BIT_AND  '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_BITAND_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | BIT_OR  '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_BITOR_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | BIT_XOR  '(' in_sum_expr ')'
          {
              $$ = fieldfone(Lex,FUNC_BITXOR_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | COUNT_SYM '(' opt_all '*' ')' 
          {

              $$ = fieldf(Lex,FUNC_COUNTALL_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | COUNT_SYM '(' in_sum_expr ')'
          {
              $$ = fieldfone(Lex,FUNC_COUNT_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 
        | COUNT_SYM '(' DISTINCT 
          { Select->sql_in_sum_expr++; }
          expr_list 
          { Select->sql_in_sum_expr--; }
          ')' 
          {
              $$ = fieldf(Lex,FUNC_COUNTDISTINCT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarglist($$, &($5));
              
          }
        | MIN_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MIN_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 

        | MIN_SYM '(' DISTINCT in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MINDISTINCT_FIELD,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 
        | MAX_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MAX_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 
        | MAX_SYM '(' DISTINCT in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_MAXDISTINCT_FIELD,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 
        | STD_SYM '(' in_sum_expr ')'
          {
              $$ = fieldfone(Lex,FUNC_STD_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | VARIANCE_SYM '(' in_sum_expr ')'
          {
              $$ = fieldfone(Lex,FUNC_VARIANCE_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | STDDEV_SAMP_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_STDDEVSAMP_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | VAR_SAMP_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_VARSAMP_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | SUM_SYM '(' in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_SUM_FIELD,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | SUM_SYM '(' DISTINCT in_sum_expr ')' 
          {
              $$ = fieldfone(Lex,FUNC_SUMDISTINCT_FIELD,$4);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }  
        | GROUP_CONCAT_SYM '(' opt_distinct 
          { Select->sql_in_sum_expr++; }
          expr_list opt_gorder_clause opt_gconcat_separator ')' 
          {
              if($3 == 0)
                  $$ = fieldf(Lex,FUNC_GROUPCONCAT_FIELD);
              else
                  $$ = fieldf(Lex,FUNC_GROUPCONCATDISTINCT_FIELD);
                  
              if($$ == NULL) {
                  MY_YYABORT;
              }
              addarglist($$, &($5));
              
              Select->sql_separator = $7.str;
              Select->sql_in_sum_expr--;
          }

        ;

not2:
          '!' {}
        | NOT2_SYM {}
        ;

ident_list_arg:
          ident_list          { $$= $1; }
        | '(' ident_list ')'  { $$= $2; }
        ;

fulltext_options:
          opt_natural_language_mode opt_query_expansion 
          { $$= $1 | $2; }          
        | IN_SYM BOOLEAN_SYM MODE_SYM 
          { $$= FT_BOOL; }
        
        ;

cast_type:
          BINARY opt_field_length
          { $$=ITEM_CAST_CHAR; }
        | CHAR_SYM opt_field_length opt_binary
          { $$=ITEM_CAST_CHAR; }
        | NCHAR_SYM opt_field_length
          { $$=ITEM_CAST_CHAR; }
        | SIGNED_SYM
          { $$=ITEM_CAST_SIGNED_INT; }
        | SIGNED_SYM INT_SYM
          { $$=ITEM_CAST_SIGNED_INT; }
        | UNSIGNED
          { $$=ITEM_CAST_UNSIGNED_INT; }
        | UNSIGNED INT_SYM
          { $$=ITEM_CAST_UNSIGNED_INT; }
        | DATE_SYM
          { $$= ITEM_CAST_DATE; }
        | TIME_SYM type_datetime_precision
          { $$= ITEM_CAST_TIME;  }
        | DATETIME type_datetime_precision
          { $$= ITEM_CAST_DATETIME;}
        | DECIMAL_SYM float_options
          { $$=ITEM_CAST_DECIMAL; }
        ;

opt_expr:
          /* empty */    { $$= NULL; }
        | expr           { $$= $1; }
        ;


when_list:
          WHEN_SYM expr THEN_SYM expr 
          {
              $$.head = $2;
              $$.tail = $4;
              $2->next = $4;
              $$.fcount = 2;
          }
        | when_list WHEN_SYM expr THEN_SYM expr 
          {
              $1.tail->next = $3;
              $3->next = $5;
              $1.tail = $5;
              $1.fcount = $1.fcount + 2;
              $$ = $1;
          }
        ;

opt_else:
          /* empty */  { $$= NULL; }
        | ELSE expr    { $$= $2; }
        ;
        ;

charset_name:
          ident_or_text { $$ = $1;}
        | BINARY  
          {
            $$ = binary_lex_str;
          }
        ;

simple_ident_nospvar:
          ident 
          {
              if ((Select->parsing_place != IN_HAVING) || Select->sql_in_sum_expr > 0) {
                  $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$1);
              } else {

                  /*ref 相关  作用*/
                  $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              }
          }
        | simple_ident_q  { $$= $1; }
        ;

query_specification:
          SELECT_SYM select_init2_derived 
          {
              $$ = (SQLPARSESEL *)Select;
          }
        | '(' select_paren_derived ')' 
          {
              $$ = (SQLPARSESEL *)Select;
          }
        ;

opt_union_order_or_limit:
	  /* Empty */ {  $$ = 0; }
	    | union_order_or_limit { $$ = 1;}
	    ;

table_factor:
     
          table_ident opt_use_partition opt_table_alias opt_key_definition 
          {
              $1->field_partition = $2.head;
              $1->field_name_as = $3.str;

              $$ = $1; 
              
          }
        | select_derived_init get_select_lex 
          {
              SQLPARSESEL *sel;   
              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }

              sel->sql_command = SQLCOM_SELECT;

              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;


              sel->prev = Select;
             
              Select = sel;
          }
          select_derived2 
          {

              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,Select);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }
              Select = Select->prev;

              $$ = field_subsel;
          }
        | '(' get_select_lex select_derived_union ')' opt_table_alias 
          { 
          
              PARSEFIELD *field_flist;
   

              field_flist = fieldflist(Lex, $3);
              if(field_flist == NULL) {
                  MY_YYABORT;
              }

              field_flist->field_name_as = $5.str;
              $$=field_flist;
          }
        ;

join_table:
          table_ref normal_join table_ref %prec TABLE_REF_PRIORITY 
          {
              $3->field_join_type = $2;
              parseaddlist(&($1->field_joinlist), $3);
              
              $$ = $1;
            
          }
        | table_ref STRAIGHT_JOIN table_factor 
          {
              $3->field_join_type = STRAIGHTJOIN_JOIN;              
              parseaddlist(&($1->field_joinlist), $3);
              
              $$ = $1;
          }
        | table_ref normal_join table_ref ON expr
          {
              $3->field_join_type = $2;              
              parseaddlist(&($1->field_joinlist), $3);

              
              $$ = $1;
              $$->field_join_on = $5;
          }
        | table_ref STRAIGHT_JOIN table_factor ON expr 
          {
              $3->field_join_type = STRAIGHTJOIN_JOIN;              
              parseaddlist(&($1->field_joinlist), $3);

              
              $$ = $1;
              $$->field_join_on = $5;
          }
        | table_ref normal_join table_ref USING '(' using_list ')' 
          {
              $3->field_join_type = $2;              
              parseaddlist(&($1->field_joinlist), $3);

              
              $$ = $1;
              $$->field_join_using = $6.head;              
          }
        | table_ref NATURAL JOIN_SYM table_factor 
          {
              $4->field_join_type = NATURAL_JOIN;              
              parseaddlist(&($1->field_joinlist), $4);

              
              $$ = $1;
          }
        | table_ref LEFT opt_outer JOIN_SYM table_ref ON expr 
          {
              $5->field_join_type = LEFT_JOIN;              
              parseaddlist(&($1->field_joinlist), $5);

              
              $$ = $1;
              $$->field_join_on = $7;
          }
        | table_ref LEFT opt_outer JOIN_SYM table_factor USING '(' using_list ')' 
          {
              $5->field_join_type = LEFT_JOIN;              
              parseaddlist(&($1->field_joinlist), $5);

              
              $$ = $1;
              $$->field_join_using = $8.head;              
          }
        | table_ref NATURAL LEFT opt_outer JOIN_SYM table_factor 
          {
              $6->field_join_type = NATURAL_LEFT_JOIN;              
              parseaddlist(&($1->field_joinlist), $6);

              
              $$ = $1;
          }
        | table_ref RIGHT opt_outer JOIN_SYM table_ref ON expr
          {
              $5->field_join_type = RIGHT_JOIN;              
              parseaddlist(&($1->field_joinlist), $5);

              
              $$ = $1;
              $$->field_join_on = $7;
          }
        | table_ref RIGHT opt_outer JOIN_SYM table_factor USING '(' using_list ')' 
          {
              $5->field_join_type = RIGHT_JOIN;              
              parseaddlist(&($1->field_joinlist), $5);

              
              $$ = $1;
              $$->field_join_using = $8.head;

          }
        | table_ref NATURAL RIGHT opt_outer JOIN_SYM table_factor 
          {
              $6->field_join_type = NATURAL_RIGHT_JOIN;              
              parseaddlist(&($1->field_joinlist), $6);

              
              $$ = $1;
          }
        ;



interval_time_stamp:
          DAY_SYM         { $$=INTERVAL_DAY; }
        | WEEK_SYM        { $$=INTERVAL_WEEK; }
        | HOUR_SYM        { $$=INTERVAL_HOUR; }
        | MINUTE_SYM      { $$=INTERVAL_MINUTE; }
        | MONTH_SYM       { $$=INTERVAL_MONTH; }
        | QUARTER_SYM     { $$=INTERVAL_QUARTER; }
        | SECOND_SYM      { $$=INTERVAL_SECOND; }
        | MICROSECOND_SYM { $$=INTERVAL_MICROSECOND; }
        | YEAR_SYM        { $$=INTERVAL_YEAR; }
        ;


simple_ident_q:
          ident '.' ident 
          {
              /*SP_TYPE_TRIGGER 相关 判断 NEW 或者 OLD 具体作用不详*/

              /*sel->no_table_names_allowed 作用*/
              if ((Select->parsing_place != IN_HAVING) || Select->sql_in_sum_expr > 0) {
                  $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,$1.str,$3);
              } else {
                  /*ref 相关  作用*/
                  $$ = (PARSEFIELD *)fieldstring(Lex,NULL,$1.str,$3);
              }

              if ($$ == NULL)
                  MY_YYABORT;
              
          }
        | '.' ident '.' ident 
          {
              /*sel->no_table_names_allowed 作用*/
              if ((Select->parsing_place != IN_HAVING) || Select->sql_in_sum_expr > 0) {
                  $$ = (PARSEFIELD *)fieldcolumn(Lex,NULL,$2.str,$4);
              } else {
                  /*ref 相关  作用*/
                  $$ = (PARSEFIELD *)fieldstring(Lex,NULL,$2.str,$4);
              }

              if ($$ == NULL)
                  MY_YYABORT;
          }
        | ident '.' ident '.' ident 
          {
              /* 客户端是否 不需要 schema thd->client_capabilities & CLIENT_NO_SCHEMA*/
             
              /*sel->no_table_names_allowed 作用*/
              if ((Select->parsing_place != IN_HAVING) || Select->sql_in_sum_expr > 0) {
                  $$ = (PARSEFIELD *)fieldcolumn(Lex,$1.str,$3.str,$5);
              } else {
                  /*ref 相关  作用*/
                  $$ = (PARSEFIELD *)fieldstring(Lex,$1.str,$3.str,$5);
              }

              if ($$ == NULL)
                  MY_YYABORT;
            
          }
        ;

optional_braces:
          /* empty */ {}
        | '(' ')' {}
        ;

func_datetime_precision:
          /* empty */    { $$ = 0; }
        | '(' ')'        { $$ = 0; }             
        | '(' NUM ')' 
          {
             int error;
             $$= (unsigned long) parse_strtoll10($2.str, NULL, &error);
              
          }
        ;

date_time_type:
          DATE_SYM  {$$= TIMESTAMP_DATE; }
        | TIME_SYM  {$$= TIMESTAMP_TIME; }
        | TIMESTAMP {$$= TIMESTAMP_DATETIME; }
        | DATETIME  {$$= TIMESTAMP_DATETIME; }
        ;

now:
          NOW_SYM func_datetime_precision 
          {
              $$ = fieldf(Lex,FUNC_NOW_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }
                
              $$->field_datetime_precision = $2;            
          }
          ;

opt_udf_expr_list:
        /* empty */     
          {
              $$.head=NULL;
              $$.tail=NULL;
              $$.fcount = 0;
          }
        | udf_expr_list 
          {
              $$ = $1;
          } 
        ;

opt_expr_list:
          /* empty */ 
          {
              $$.head=NULL;
              $$.tail=NULL;
              $$.fcount = 0;
          }
        | expr_list  
          {
              $$ = $1;
          }
        ;

opt_ws_levels:
        /* empty*/ { $$= 0; }
        | LEVEL_SYM ws_level_list_or_range { $$= $2; }
        ;

ws_nweights:
        '(' real_ulong_num ')' 
          {
              if($2 == 0) {
                  MY_YYABORT;
              }
              $$ = $2;
          }
    
        ;

ulong_num:
          NUM           { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | HEX_NUM       { $$= (unsigned long) strtol($1.str, (char**) 0, 16); }
        | LONG_NUM      { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | ULONGLONG_NUM { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | DECIMAL_NUM   { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | FLOAT_NUM     { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        ;

geometry_function:
          CONTAINS_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_CONTAINS_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | GEOMETRYCOLLECTION '(' expr_list ')'
          {
              $$ = fieldf(Lex,FUNC_GEOMETRYCOLLECTION_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | LINESTRING '(' expr_list ')' 
          {
              $$ = fieldf(Lex,FUNC_LINESTRING_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | MULTILINESTRING '(' expr_list ')'
          {
              $$ = fieldf(Lex,FUNC_MULTILINESTRING_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | MULTIPOINT '(' expr_list ')' 
          {
              $$ = fieldf(Lex,FUNC_MULTIPOINT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | MULTIPOLYGON '(' expr_list ')' 
          {
              $$ = fieldf(Lex,FUNC_MULTIPOLYGON_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        | POINT_SYM '(' expr ',' expr ')' 
          {
              $$ = fieldf(Lex,FUNC_POINT_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarg($$, $3);
              addarg($$, $5);

          }
        | POLYGON '(' expr_list ')' 
        {
              $$ = fieldf(Lex,FUNC_POLYGON_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              addarglist($$, &($3));

          }
        ;

TEXT_STRING_sys:
          TEXT_STRING 
          {
              /*不同字符集之间的编码转换*/
              $$= $1;
          }
        ;

text_literal:
          TEXT_STRING
          {
              /*不同字符集之间的编码转换*/
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | NCHAR_STRING 
          {
              /*不同字符集之间的编码转换*/
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          } 
        | UNDERSCORE_CHARSET TEXT_STRING 
          {
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_charset = "UNDERSCORE";
          }
        | text_literal TEXT_STRING_literal
          {
              $$ = fieldappend(Lex, $1, $2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

NUM_literal:
          NUM 
          { 
            $$ = (PARSEFIELD *)fieldnum(Lex,$1);
            if($$ == NULL) {
                MY_YYABORT;
            }

          }
        | LONG_NUM
          { 
            $$ = (PARSEFIELD *)fieldnum(Lex,$1);
            if($$ == NULL) {
                MY_YYABORT;
            }
            $$->field_type = LONGNUM_FIELD;
            

          }
        | ULONGLONG_NUM 
          { 
            $$ = (PARSEFIELD *)fieldnum(Lex,$1);
            if($$ == NULL) {
                MY_YYABORT;
            }
            $$->field_type = ULONGLONGNUM_FIELD;

            

          }
        | DECIMAL_NUM
          { 
            $$ = (PARSEFIELD *)fieldnum(Lex,$1);
            if($$ == NULL) {
                MY_YYABORT;
            }
            $$->field_type = DECIMALNUM_FIELD;

            

          }     
        | FLOAT_NUM 
          { 
            $$ = (PARSEFIELD *)fieldnum(Lex,$1);
            if($$ == NULL) {
                MY_YYABORT;
            }
            $$->field_type = FLOATNUM_FIELD;

          }  
        ;

temporal_literal:
          DATE_SYM TEXT_STRING 
          {
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = DATESTRING_FIELD;
          }
        | TIME_SYM TEXT_STRING 
        {
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = TIMESTRING_FIELD;

          }
        | TIMESTAMP TEXT_STRING 
        {
              $$ = (PARSEFIELD *)fieldstring(Lex,NULL,NULL,$2);
              if($$ == NULL) {
                  MY_YYABORT;
              }
              $$->field_type = TIMESTAMPSTRING_FIELD;

          }
        ;

variable_aux:
          ident_or_text SET_VAR expr 
          {
              PARSEFIELD *field;
              field = fieldvariable(Lex, $1, OPT_DEFAULT);
              if( field == NULL) {
                  MY_YYABORT;
              }

              $$ = fieldoprate(Lex, SETVAR_FIELD,":=",field,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }


          }
        | ident_or_text 
          {
              $$ = fieldvariable(Lex, $1,OPT_DEFAULT);
              if( $$ == NULL) {
                  MY_YYABORT;
              }
   
          
          }
        | '@' opt_var_ident_type ident_or_text opt_component 
          {
              $$ = fieldvariable(Lex, $3, $2);
              if( $$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

in_sum_expr:
          opt_all
          {
              Select->sql_in_sum_expr++;
          }
          expr 
          {
              Select->sql_in_sum_expr--;
              $$ = $3;
          }
        ;

opt_all:
          /* empty */  {  }
        | ALL {}
        ;

opt_distinct:
          /* empty */ { $$ = 0;  }
        | DISTINCT    { $$ = 1;}
        ;

opt_gorder_clause:
          /* empty */  {  }
        | ORDER_SYM BY gorder_list
        ;

opt_gconcat_separator:
          /* empty */  { $$ = null_lex_str; }
        | SEPARATOR_SYM text_string { $$ = $2;}
        ;

ident_list:
          simple_ident 
          {
              $$.head = $1;
              $$.tail = $1;      
              $$.fcount = 1;
          }
        | ident_list ',' simple_ident 
          {
              $1.tail->next =  $3;
              $1.tail =  $3;
              ($1.fcount)++;
              $$ = $1;        
          }
        ;

opt_natural_language_mode:
          /* nothing */                         { $$= FT_NL; }
        | IN_SYM NATURAL LANGUAGE_SYM MODE_SYM  { $$= FT_NL; }
        ;

opt_query_expansion:
          /* nothing */                         { $$= 0;         }
        | WITH QUERY_SYM EXPANSION_SYM          { $$= FT_EXPAND; }
        ;

opt_field_length:
          /* empty */ {}  
        | field_length {}
        ;

opt_binary:
          /* empty */  {}
        | ascii 
        | unicode 
        | BYTE_SYM  
          {
              Select->sql_charset = "BYTE";
          }
        | charset charset_name opt_bin_mod  
          {
              Select->sql_charset=$2.str;              
          }
        | BINARY 
          {
              Select->sql_charset_bin = "BIN";

          }
        | BINARY charset charset_name
          {
              Select->sql_charset_bin = "BIN";
              Select->sql_charset=$3.str;              
          }
        ;

type_datetime_precision:
          /* empty */   { Select->sql_dec = NULL; }           
        | '(' NUM ')'        
          {
              Select->sql_dec = $2.str;
          }       
        ;

float_options:
          /* empty */  {}
        | field_length {}
        | precision {}
        ;

select_init2_derived:
          select_part2_derived {}
        ;

select_paren_derived:
          SELECT_SYM select_part2_derived {}
        | '(' select_paren_derived ')' {}
        ;

table_ident:
          ident 
          {
              $$ = (PARSEFIELD *)fieldtable(Lex,NULL,$1.str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | ident '.' ident 
          {
              $$ = (PARSEFIELD *)fieldtable(Lex,$1.str,$3.str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | '.' ident 
          {
              $$ = (PARSEFIELD *)fieldtable(Lex,NULL,$2.str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

opt_use_partition:
          /* empty */ 
          {
              $$.head = NULL;
              $$.tail = NULL;
              $$.fcount = 0;
          }
        | use_partition { $$ = $1; }
        ;
        
opt_table_alias:
          /* empty */ { $$ = null_lex_str;  }
        | table_alias ident { $$ = $2; }
        ;

opt_key_definition:
          opt_index_hints_list {}
        ;

select_derived_init:
          SELECT_SYM {}
        ;

get_select_lex:
          /* Empty */ { $$ = (SQLPARSESEL *)Select;}
        ;

select_derived2:
          select_options select_item_list opt_select_from {}
        ;

select_derived_union:
          select_derived 
          {
              SQLPARSESEL *sel;
              PARSEFIELD  *field = $1.tail;

              if(field != NULL && field->field_type == SUBSEL_FIELD) {
                  sel = (SQLPARSESEL *)field->subselect;
                  sel->prev = Select;
                  Select = sel;
              }
                   
          
          }
          opt_union_order_or_limit 
          {
              PARSEFIELD  *field = $1.tail;
              if(field != NULL && field->field_type == SUBSEL_FIELD) {
                  Select = Select->prev;
              }
              
              if(field == NULL && $3 == 0)
                  MY_YYABORT;

              $$ = $1;
              
          }
        | select_derived_union UNION_SYM union_option 
          {
          
              SQLPARSESEL *sel;  

              PARSEFIELD  *field = $1.tail;

              if(field != NULL && field->field_type == SUBSEL_FIELD) {
                  sel = (SQLPARSESEL *)field->subselect;
                  sel->prev = Select;
                  Select = sel;
              }

              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }
              sel->sql_command = SQLCOM_SELECT;
              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;

              sel->prev = Select;
             
              Select = sel;

          }
          query_specification opt_union_order_or_limit 
          {
              PARSEFIELD *field_subsel;
              field_subsel = fieldsubsel(Lex,Select);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }
              field_subsel->field_union_opt = $3;
              Select = Select->prev;

              parseaddlist(&(Select->sql_unionlist), field_subsel);

              PARSEFIELD  *field = $1.tail;
              if(field != NULL && field->field_type == SUBSEL_FIELD) {
                  Select = Select->prev;
              }

              $$ = $1;
          }
        ;

normal_join:
          JOIN_SYM { $$ = DEFAULT_JOIN; }
        | INNER_SYM JOIN_SYM { $$ = INNER_JOIN; }
        | CROSS JOIN_SYM { $$ = $$ = CROSS_JOIN; }
        ;

using_list:
          ident 
          {
              PARSEFIELD *field = NULL;
              field = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$1);
              if(field == NULL) {
                  MY_YYABORT;
              }              

              $$.head = field;
              $$.tail = field;
              $$.fcount = 1;
          }
        | using_list ',' ident 
          {
              PARSEFIELD *field = NULL;
              field = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }         

              $1.tail->next = field;
              $1.tail = field;
              ($1.fcount)++;
              $$ = $1;
          }
        ;

opt_outer:
          /* empty */ {}
        | OUTER {}
        ;





      




udf_expr_list:
          udf_expr 
          {
              $$.head = $1;
              $$.tail = $1;      
              $$.fcount = 1;
          }
        | udf_expr_list ',' udf_expr 
          {
              $1.tail->next =  $3;
              $1.tail =  $3;
              ($1.fcount)++;
              $$ = $1;           

          }
        ;

ws_level_list_or_range:
        ws_level_list { $$= $1; }
        | ws_level_range { $$= $1; }
        ;

real_ulong_num:
          NUM           { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | HEX_NUM       { $$= (unsigned long) strtol($1.str, (char**) 0, 16); }
        | LONG_NUM      { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | ULONGLONG_NUM { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | dec_num_error { MY_YYABORT; }
        ;

TEXT_STRING_literal:
          TEXT_STRING 
          {
              /*不同字符集之间的编码转换*/
              $$= $1;
          }
        ;

opt_var_ident_type:
          /* empty */     { $$=OPT_DEFAULT; }
        | GLOBAL_SYM '.'  { $$=OPT_GLOBAL; }
        | LOCAL_SYM '.'   { $$=OPT_SESSION; }
        | SESSION_SYM '.' { $$=OPT_SESSION; }
        ;

opt_component:
          /* empty */    { $$= null_lex_str; }
        | '.' ident      { $$= $2; }
        ;


gorder_list:
          gorder_list ',' order_ident order_dir
          {
              parseaddlist(&(Select->sql_gorderlist), $3);
              $3->field_order_dir = $4;
                
          }
        | order_ident order_dir
          {
              parseaddlist(&(Select->sql_gorderlist), $1);
              $1->field_order_dir = $2;
          }
        ;

text_string:
          TEXT_STRING_literal 
          {
              $$ = $1;
          }
        | HEX_NUM
          {
              LEX_STRING hex_str  =  {"HEX_NUM", 8};
              $$ = hex_str;
          }
        | BIN_NUM 
          {
              LEX_STRING bin_str  =  {"HEX_NUM", 8};
              $$ = bin_str;
          }
        ;

field_length:
          '(' LONG_NUM ')'      { Select->sql_length= $2.str; }
        | '(' ULONGLONG_NUM ')' { Select->sql_length= $2.str; }
        | '(' DECIMAL_NUM ')'   { Select->sql_length= $2.str; }
        | '(' NUM ')'           { Select->sql_length= $2.str; }
        ;

ascii:
          ASCII_SYM 
          {
              Select->sql_charset = "LATIN1"; 
          }
        | BINARY ASCII_SYM 
          {
              Select->sql_charset = "LATIN1";
              Select->sql_charset_bin = "BIN";

          }
        | ASCII_SYM BINARY 
          {
              Select->sql_charset = "LATIN1";
              Select->sql_charset_bin = "BIN";
          }
        ;


unicode:
          UNICODE_SYM 
          {
              Select->sql_charset = "USC2";
              Select->sql_charset_bin = "BIN";              
          }
        | UNICODE_SYM BINARY 
          {
              Select->sql_charset = "USC2";
              Select->sql_charset_bin = "BIN";              
          }
        | BINARY UNICODE_SYM 
          {
              Select->sql_charset = "USC2";
              Select->sql_charset_bin = "BIN";              
          }
        ;

charset:
          CHAR_SYM SET {}
        | CHARSET {}
        ;

opt_bin_mod:
          /* empty */ { }
        | BINARY 
          {
              Select->sql_charset_bin = "BIN";
          } 
        ;

precision:
          '(' NUM ',' NUM ')'
          {
            Select->sql_length=$2.str;
            Select->sql_dec=$4.str;
          }
        ;

select_part2_derived:
          opt_query_expression_options select_item_list opt_select_from select_lock_type
        ;

use_partition:
          PARTITION_SYM '(' using_list ')' have_partitioning
          {
              $$ = $3;
          }
        ;

table_alias:
          /* empty */{}
        | AS {}
        | EQ {}
        ;

opt_index_hints_list:
          /* empty */{}
        | index_hints_list
        ;

opt_select_from:
          opt_limit_clause {}
        | select_from select_lock_type
        ;

select_derived:
          get_select_lex derived_table_list
          {
              $$ = $2;
          }
        ;





udf_expr:
          remember_name expr remember_end select_alias 
          {
            if ($4.str)
            {
                $2->field_name_as = $4.str;          
            }
            
            $$ = $2;
          }
        ;

ws_level_list:
        ws_level_list_item { $$ = $1;}
        | ws_level_list ',' ws_level_list_item { $$|= $3; }
        ;

ws_level_range:
        ws_level_number '-' ws_level_number
        {
          unsigned int start= $1;
          unsigned int end= $3;
          for ($$= 0; start <= end; start++)
            $$|= (1 << start);
        }
        ;        

dec_num_error:
          dec_num {}
        ;

opt_query_expression_options:
          /* empty */{}
        | query_expression_option_list
        ;

have_partitioning:
          /* empty */{}

index_hints_list:
          index_hint_definition
        | index_hints_list index_hint_definition
        ;















select_alias:
          /* empty */ { $$ = null_lex_str;}
        | AS ident  {$$ = $2; }
        | AS TEXT_STRING_sys { $$ = $2; } 
        | ident { $$ = $1; }
        | TEXT_STRING_sys { $$ = $1; } 
        ;

ws_level_list_item:
        ws_level_number ws_level_flags
        {
          $$= (1 | $2) << $1;
        }
        ;

ws_level_number:
        real_ulong_num
        {
          $$= $1 < 1 ? 1 : ($1 > MY_STRXFRM_NLEVELS ? MY_STRXFRM_NLEVELS : $1);
          $$--;
        }
        ;

dec_num:
          DECIMAL_NUM {}
        | FLOAT_NUM   {}
        ;

query_expression_option_list:
          query_expression_option_list query_expression_option
        | query_expression_option
        ;

index_hint_definition:
          index_hint_type key_or_index index_hint_clause '(' key_usage_list ')'
          {
              Select->sql_index_hint_type = $1;
              Select->sql_index_hint_clause = $3;
              
          }
        | USE_SYM key_or_index index_hint_clause '(' opt_key_usage_list ')'
          {
              Select->sql_index_hint_clause = $3;                           
          }
       ;





ws_level_flags:
        /* empty */ { $$= 0; } 
        | ws_level_flag_desc {$$= $1;}
        | ws_level_flag_desc ws_level_flag_reverse {$$= $1 | $2; }
        | ws_level_flag_reverse {$$= $1;}
        ;

index_hint_type:
          FORCE_SYM  { $$= INDEX_HINT_FORCE; }
        | IGNORE_SYM { $$= INDEX_HINT_IGNORE; } 
        ;

key_or_index:
          KEY_SYM {}
        | INDEX_SYM {}
        ;

index_hint_clause:
          {
            /*$$= old_mode ?  INDEX_HINT_MASK_JOIN : INDEX_HINT_MASK_ALL; */
            $$ = INDEX_HINT_MASK_JOIN;
          }
        | FOR_SYM JOIN_SYM      { $$= INDEX_HINT_MASK_JOIN;  }
        | FOR_SYM ORDER_SYM BY  { $$= INDEX_HINT_MASK_ORDER; }
        | FOR_SYM GROUP_SYM BY  { $$= INDEX_HINT_MASK_GROUP; }
        ;

key_usage_list:
          key_usage_element
        | key_usage_list ',' key_usage_element
        ;

opt_key_usage_list:
          /* empty */{}
        | key_usage_list {}
        ;

ws_level_flag_desc:
        ASC { $$= 0; }
        | DESC {$$= 1 << MY_STRXFRM_DESC_SHIFT;}
        ;

ws_level_flag_reverse:
        REVERSE_SYM { $$= 1 << MY_STRXFRM_REVERSE_SHIFT; }
        ;

key_usage_element:
          ident
          {
              PARSEFIELD *field = NULL;
              field = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,$1);
              if(field == NULL) {
                  MY_YYABORT;
              }              
              parseaddindexhint(Select,field);

          }
        | PRIMARY_SYM 
          {
              LEX_STRING lexstr={"PRIMARY", 8};
              PARSEFIELD *field = NULL;
              field = (PARSEFIELD *)fieldcolumn(Lex,NULL,NULL,lexstr);
              if(field == NULL) {
                  MY_YYABORT;
              }              
              parseaddindexhint(Select,field);
          }
        ;



















insert:
          INSERT
          {
              Select->sql_command = SQLCOM_INSERT;
              Select->sql_duplicates= DUP_ERROR; 
          }
          insert_lock_option opt_ignore insert2 insert_field_spec opt_insert_update 
          {
              Select->sql_locktp = $3;
          }
        ;

insert_lock_option:
          /* empty */ { $$ = TL_WRITE_CONCURRENT_INSERT; }
        | LOW_PRIORITY  { $$ = TL_WRITE_LOW_PRIORITY;}
        | DELAYED_SYM { $$ = TL_WRITE_DELAYED; }
        | HIGH_PRIORITY { $$ = TL_WRITE; }
        ;

opt_ignore:
          /* empty */ { Select->sql_ignore = 0; }
        | IGNORE_SYM { Select->sql_ignore = 1;}
        ;

insert2:
          INTO insert_table {}
        | insert_table {}
        ;


insert_field_spec:
          insert_values {}
        | '(' ')' insert_values {}
        | '(' fields ')' insert_values {}
        | SET ident_eq_list {}
        ;

opt_insert_update:
          /* empty */{}
        | ON DUPLICATE_SYM KEY_SYM UPDATE_SYM insert_update_list
          {
              Select->sql_duplicates = DUP_UPDATE;
          }
        ;







insert_table:
          table_name_with_opt_use_partition {}
          ;

insert_values:
          VALUES values_list {}
        | VALUE_SYM values_list {}
        | create_select  union_clause
          {
              PARSEFIELD *field_subsel;
              PARSEFLIST *valueslist;
              
              field_subsel = fieldsubsel(Lex,Select);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              Select = Select->prev;

              valueslist = (PARSEFLIST *)lexalloc0(Lex,sizeof(PARSEFLIST));
              if(valueslist == NULL ) {
                  MY_YYABORT;
              }
              valueslist->tail = field_subsel;
              valueslist->head = field_subsel;
              valueslist->fcount = 1;

              parseaddvalue(Select, valueslist);
          }
        | '(' create_select ')' union_opt 
          {
              PARSEFIELD *field_subsel;
              PARSEFLIST *valueslist;
              
              field_subsel = fieldsubsel(Lex,Select);
              if(field_subsel == NULL) {
                  MY_YYABORT;
              }

              Select = Select->prev;

              valueslist = (PARSEFLIST *)lexalloc0(Lex,sizeof(PARSEFLIST));
              if(valueslist == NULL ) {
                  MY_YYABORT;
              }
              valueslist->tail = field_subsel;
              valueslist->head = field_subsel;
              valueslist->fcount = 1;

              parseaddvalue(Select, valueslist);          
          } 
        ;

fields:
          fields ',' insert_ident 
          {
              parseaddfield(Select,$3); 
          }
        | insert_ident 
          {
              parseaddfield(Select,$1);
          }
        ;

ident_eq_list:
          ident_eq_list ',' ident_eq_value
        | ident_eq_value
        ;

insert_update_list:
          insert_update_list ',' insert_update_elem
        | insert_update_elem
        ;








table_name_with_opt_use_partition:
          table_ident opt_use_partition 
          {
              parseaddtable(Select, $1);
              $1->field_partition = $2.head;
          }

        ;

values_list:
          values_list ','  no_braces
        | no_braces
        ;

create_select:
          SELECT_SYM 
          {

          
              SQLPARSESEL *sel;   
              if(parse_selinit(&sel ,Lex)) {
                  MY_YYABORT;
              }

              sel->sql_command= SQLCOM_SELECT;

              Lex->sql_sellist.tail->next = sel;
              Lex->sql_sellist.tail = sel;
              
              sel->prev = Select;
              Select = sel;

          }
          select_options select_item_list opt_select_from
          {


          }
        ;


insert_ident:
          simple_ident_nospvar { $$ = $1;}
        | table_wild { $$ = $1; }
        ;

ident_eq_value:
          simple_ident_nospvar equal expr_or_default 
          {


              if(Select->sql_command == SQLCOM_SELECT) {
                  PARSEFIELD *field;
                  field = fieldoprate(Lex, EQUAL_FIELD,$2.str,$1,$3);
                  if(field == NULL) {
                      MY_YYABORT;
                  }
                  parseaddfield(Select,field); 
              } else if (Select->sql_command == SQLCOM_INSERT){
                  PARSEFLIST *valueslist;

                  valueslist = Select->sql_value;
                  if(valueslist == NULL) {
                      valueslist = (PARSEFLIST *)lexalloc0(Lex,sizeof(PARSEFLIST));
                      if(valueslist == NULL ) {
                          MY_YYABORT;
                      }
                      Select->sql_value = valueslist;
                      Select->sql_value_tail = valueslist;
                      Select->sql_value_count = 1;
                  }
                  parseaddfield(Select,$1); 
                  parseaddlist(valueslist, $3);
              }
          }
        ;

insert_update_elem:
          simple_ident_nospvar equal expr_or_default
          {
              PARSEFIELD *field;
              field = fieldoprate(Lex, EQUAL_FIELD,$2.str,$1,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddupfield(Select, field);
          }
         
        ;

no_braces:
          '(' opt_values ')' 
          {
              parseaddvalue(Select, $2);
          }
        ;

expr_or_default:
          expr { $$ = $1;}
        | DEFAULT 
          {
              $$ = fieldstring(Lex, NULL, NULL, default_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;

opt_values:
          /* empty */ { $$ = NULL;}
        | values { $$ = $1;}
        ;

values:
          values ','  expr_or_default 
          {
              $1->tail->next = $3;
              $1->tail = $3;
              ($1->fcount)++;
              $$ = $1;
          }
        | expr_or_default 
          {
              $$ = (PARSEFLIST *)lexalloc0(Lex,sizeof(PARSEFLIST));
              if($$ == NULL ) {
                  MY_YYABORT;
              }
              
              $$->head = $1;
              $$->tail = $1;
              $$->fcount = 1;
          }
        ;


equal:
          EQ 
          {
              $$.str= lexstrmake(Lex, "=", 2);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              $$.length= 2;
          }
        | SET_VAR 
          {
              $$.str= lexstrmake(Lex, ":=", 3);
              if ($$.str == NULL) {
                  MY_YYABORT;
              }
              $$.length= 3;
          }
        ;







update:
          UPDATE_SYM
          {
              Select->sql_command = SQLCOM_UPDATE;
              Select->sql_duplicates = DUP_ERROR; 


          } 
          opt_low_priority opt_ignore upsql_commit join_table_list SET update_list where_clause opt_order_clause delete_limit_clause 
          {
              Select->sql_tablelist.head = $6.head;
              Select->sql_tablelist.tail = $6.tail;
              Select->sql_tablelist.fcount = $6.fcount;

              Select->sql_locktp = $3;
          }
        ;


opt_low_priority:
          /* empty */ { $$= TL_WRITE_DEFAULT; }
        | LOW_PRIORITY { $$= TL_WRITE_LOW_PRIORITY; }
        ;

upsql_commit:
          /* empty */ { Select->sql_upsql_commit= 0;}
        | UPSQL_COMMIT_SYM { Select->sql_upsql_commit= 1;}
        ;

update_list:
          update_list ',' update_elem {}
        | update_elem {}
        ;

update_elem:
          simple_ident_nospvar equal expr_or_default 
          {
              PARSEFIELD *field;
              field = fieldoprate(Lex, EQUAL_FIELD,$2.str,$1,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddfield(Select,field); 
          }
        ;

delete_limit_clause:
          /* empty */ 
          {
              Select->sql_sel_limit = NULL;
          }
        | LIMIT limit_option
          {
              Select->sql_sel_limit = $2;
          }
        ;




delete:
          DELETE_SYM 
          {
            Select->sql_command= SQLCOM_DELETE;
            Select->sql_ignore= 0;
          }
          opt_delete_options single_multi
        ;

opt_delete_options:
          /* empty */ {}
        | opt_delete_option opt_delete_options {}
        ;

single_multi:
          FROM table_ident opt_use_partition where_clause opt_order_clause delete_limit_clause 
          {
              $2->field_partition = $3.head;
              parseaddfromtable(Select, $2);
              
          }
        | table_wild_list FROM join_table_list where_clause 
          {
              Select->sql_from_tablelist.head = $3.head;
              Select->sql_from_tablelist.tail = $3.tail;
              
              Select->sql_from_tablelist.fcount = $3.fcount;              
          }
        | FROM table_alias_ref_list USING join_table_list where_clause 
          {
              Select->sql_using_tablelist.head = $4.head;
              Select->sql_using_tablelist.tail = $4.tail;
              Select->sql_using_tablelist.fcount = $4.fcount;   
          }
        ;


opt_delete_option:
          QUICK        { Select->sql_options|= OPTION_QUICK; }
        | LOW_PRIORITY { Select->sql_locktp= TL_WRITE_LOW_PRIORITY; }
        | IGNORE_SYM   { Select->sql_ignore= 1; }
        ;

table_wild_list:
          table_wild_one {}
        | table_wild_list ',' table_wild_one {}
        ;

table_wild_one:
          ident opt_wild 
          {
              PARSEFIELD *field;
              field = (PARSEFIELD *)fieldtable(Lex,NULL,$1.str);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddtable(Select, field);
          }
        | ident '.' ident opt_wild 
          {
              PARSEFIELD *field;
              field = (PARSEFIELD *)fieldtable(Lex,$1.str,$3.str);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddtable(Select, field);
          }
        ;

opt_wild:
          /* empty */ {}
        | '.' '*' {}
        ;

table_alias_ref_list:
          table_alias_ref
        | table_alias_ref_list ',' table_alias_ref
        ;

table_alias_ref:
          table_ident_opt_wild
          {
              parseaddfromtable(Select, $1);
          }
        ;

table_ident_opt_wild:
          ident opt_wild 
          {
              $$ = (PARSEFIELD *)fieldtable(Lex,NULL,$1.str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | ident '.' ident opt_wild 
          {
              $$ = (PARSEFIELD *)fieldtable(Lex,$1.str,$3.str);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;










set:
          SET
          {
              Select->sql_command= SQLCOM_SET_OPTION;
              Select->sql_opttype= OPT_SESSION;
          } 
          start_option_value_list {} 
        ;


start_option_value_list:
          option_value_no_option_type option_value_list_continued {}
        | TRANSACTION_SYM transaction_characteristics {}
        | option_type start_option_value_list_following_option_type 
          {
              Select->sql_opttype= $1;
          }
        ;

option_value_no_option_type:
          internal_variable_name equal set_expr_or_default 
          {
              PARSEFIELD *field;
              field = fieldoprate(Lex, EQUAL_FIELD,$2.str,$1,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }
            
              parseaddset(Select, field);
              
              
          }
        | '@' ident_or_text equal expr 
          {
              PARSEFIELD  *field = NULL;
              PARSEFIELD  *field2 = NULL;

              
              field = fieldvariable(Lex, $2,OPT_DEFAULT);
              if( field == NULL) {
                  MY_YYABORT;
              }

              field2 = fieldoprate(Lex, EQUAL_FIELD,$3.str,field,$4);
              if(field2 == NULL) {
                  MY_YYABORT;
              }
              parseaddset(Select, field2);

             
          }
        | '@' '@' opt_var_ident_type internal_variable_name equal set_expr_or_default 
          {
              $4->field_vartype = $3;

              PARSEFIELD *field;
              field = fieldoprate(Lex, EQUAL_FIELD,$5.str,$4,$6);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddset(Select, field);

          }
        | charset old_or_new_charset_name_or_default 
          {
              PARSEFIELD *field;
              field = fieldf(Lex,FUNC_CHARSET_FIELD);
              if(field == NULL) {
                  MY_YYABORT;
              }
              field->field_charset = $2.str;
              parseaddset(Select, field);

          }
        | NAMES_SYM equal expr 
          {
              PARSEFIELD *field;
              field = fieldfone(Lex,FUNC_NAMES_FIELD,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddset(Select, field);
              

          }
        | NAMES_SYM charset_name_or_default opt_collate
          {
              PARSEFIELD *field;
              field = fieldf(Lex,FUNC_NAMES_FIELD);
              if(field == NULL) {
                  MY_YYABORT;
              }
              field->field_charset = $2.str;
              field->field_collate = $3.str;
              parseaddset(Select, field);

          }
        | PASSWORD equal text_or_password
          {
              parseaddset(Select, $3);

          } 
        | PASSWORD FOR_SYM user equal text_or_password
          {
              $5->field_user=$3;
              parseaddset(Select, $5);
          } 
        ;

option_value_list_continued:
          /* empty */{}
        | ',' option_value_list {}
        ;


transaction_characteristics:
          transaction_access_mode {}
        | isolation_level {}
        | transaction_access_mode ',' isolation_level {}
        | isolation_level ',' transaction_access_mode {}
        ;

option_type:
          GLOBAL_SYM  { $$ = OPT_GLOBAL; }
        | LOCAL_SYM   { $$ = OPT_SESSION; }
        | SESSION_SYM { $$ = OPT_SESSION; }
        ;

start_option_value_list_following_option_type:
          option_value_following_option_type option_value_list_continued {}
        | TRANSACTION_SYM transaction_characteristics {}
        ;





internal_variable_name:
          ident 
          {
              $$ = fieldvariable(Lex, $1, OPT_DEFAULT);
              if($$ == NULL) {
                  MY_YYABORT;
              }

          }
        | ident '.' ident 
          {
              int vartp;
              vartp = check_reserved_words(&$1);
              if(vartp < 0) {
                  MY_YYABORT;
              }

              $$ = fieldvariable(Lex, $3, vartp);
              if($$ == NULL) {
                  MY_YYABORT;
              }            
            
          }
        | DEFAULT '.' ident 
          {
              $$ = fieldvariable(Lex, $3, OPT_DEFAULT);
              if($$ == NULL) {
                  MY_YYABORT;
              }        
          }
        ;

set_expr_or_default:
          expr { $$=$1; }
        | DEFAULT 
          {
              $$ = fieldstring(Lex, NULL, NULL, default_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }            
          }
        | ON 
          {
              $$ = fieldstring(Lex, NULL, NULL, on_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }     
          }
        | ALL 
          {
              $$ = fieldstring(Lex, NULL, NULL, sall_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }     
          }
        | BINARY 
          {
              $$ = fieldstring(Lex, NULL, NULL, binary_lex_str);
              if($$ == NULL) {
                  MY_YYABORT;
              }     
          }
        ;

old_or_new_charset_name_or_default:
          old_or_new_charset_name { $$ = $1;}
        | DEFAULT   
          {
            $$.str= lexstrmake(Lex, "DEFAULT", 8);
            if ($$.str == NULL);
                MY_YYABORT;
            $$.length= 8;
          }
        ;

opt_collate:
          /* empty */ { $$ = null_lex_str; }
        | COLLATE_SYM collation_name_or_default { $$ = $2;}
        ;

text_or_password:
          TEXT_STRING 
          {

              $$ = fieldstring(Lex, NULL, NULL, $1);
              if($$ == NULL) {
                  MY_YYABORT;
              }  
              $$->field_type = PASSWORD_FIELD;

          }
        | PASSWORD '(' TEXT_STRING ')' 
          {
              PARSEFIELD *field;
              $$ = fieldf(Lex,FUNC_PASSWORD_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              field = fieldstring(Lex, NULL, NULL, $3);
              if($$ == NULL) {
                  MY_YYABORT;
              }  

              addarg($$,field);
          }
        | OLD_PASSWORD '(' TEXT_STRING ')' 
          {
              PARSEFIELD *field;
              $$ = fieldf(Lex,FUNC_OLDPASSWORD_FIELD);
              if($$ == NULL) {
                  MY_YYABORT;
              }

              field = fieldstring(Lex, NULL, NULL, $3);
              if($$ == NULL) {
                  MY_YYABORT;
              }  

              addarg($$,field);
          }
        ;

user:
          ident_or_text 
          {
              if (!($$=(LEX_USER*) lexalloc0(Lex,sizeof(LEX_USER))))
                  MY_YYABORT;
              $$->user= $1;
              $$->host.str= (char *) "%";
              $$->host.length= 1;
              $$->password= null_lex_str; 
              $$->plugin= empty_lex_str;
              $$->auth= empty_lex_str;
              $$->uses_identified_by_clause= 0;
              $$->uses_identified_with_clause= 0;
              $$->uses_identified_by_password_clause= 0;
              $$->uses_authentication_string_clause= 0;

          }
        | ident_or_text '@' ident_or_text 
          {
              if (!($$=(LEX_USER*) lexalloc0(Lex,sizeof(LEX_USER))))
                  MY_YYABORT;
              $$->user= $1;
              $$->host= $3;
              $$->password= null_lex_str; 
              $$->plugin= empty_lex_str;
              $$->auth= empty_lex_str;
              $$->uses_identified_by_clause= 0;
              $$->uses_identified_with_clause= 0;
              $$->uses_identified_by_password_clause= 0;
              $$->uses_authentication_string_clause= 0;
          }
        | CURRENT_USER optional_braces 
          {
              if (!($$=(LEX_USER*) lexalloc0(Lex,sizeof(LEX_USER))))
                  MY_YYABORT; 
              $$->user= curuser_lex_str;
              $$->host.str= (char *) "%";
              $$->password= null_lex_str; 
              $$->plugin= empty_lex_str;
              $$->auth= empty_lex_str;
              $$->uses_identified_by_clause= 0;
              $$->uses_identified_with_clause= 0;
              $$->uses_identified_by_password_clause= 0;
              $$->uses_authentication_string_clause= 0;
          }

option_value_list:
          option_value {}
        | option_value_list ',' option_value {}
        ;


transaction_access_mode:
          transaction_access_mode_types 
          {
              Select->sql_txaccessmode = $1;
          }
        ;

transaction_access_mode_types:
          READ_SYM ONLY_SYM { $$= 1; }
        | READ_SYM WRITE_SYM { $$= 0; }
        ;

isolation_level:
          ISOLATION LEVEL_SYM isolation_types 
          {
              Select->sql_txisolation = $3;
          }
        ;

option_value_following_option_type:
          internal_variable_name equal set_expr_or_default 
          {
              PARSEFIELD *field;
              field = fieldoprate(Lex, EQUAL_FIELD,$2.str,$1,$3);
              if(field == NULL) {
                  MY_YYABORT;
              }
              parseaddset(Select, field);
          }
        ;




old_or_new_charset_name:
          ident_or_text {  $$ = $1; }
        | BINARY 
          {
            $$ = binary_lex_str;
          }
        ;

collation_name_or_default:
          collation_name { $$ = $1; }
        | DEFAULT    
          {
            $$ = binary_lex_str;
          }
        ;

option_value:
          option_type option_value_following_option_type 
          {
              Select->sql_opttype= $1;

          }
        | option_value_no_option_type {}
        ;

isolation_types:
          READ_SYM UNCOMMITTED_SYM { $$= ISO_READ_UNCOMMITTED; }
        | READ_SYM COMMITTED_SYM   { $$= ISO_READ_COMMITTED; }
        | REPEATABLE_SYM READ_SYM  { $$= ISO_REPEATABLE_READ; }
        | SERIALIZABLE_SYM         { $$= ISO_SERIALIZABLE; }
        ;


collation_name:
          ident_or_text { $$ = $1;}
        ;






commit:
          COMMIT_SYM opt_work opt_chain opt_release 
          {
            Select->sql_command= SQLCOM_COMMIT;
            Select->sql_tx_work = $2;
            Select->sql_tx_chain= $3;
            Select->sql_tx_release= $4;
          }
        ;


opt_chain:
          /* empty */ { $$= TVL_UNKNOWN; }
        | AND_SYM NO_SYM CHAIN_SYM { $$= TVL_NO; }
        | AND_SYM CHAIN_SYM        { $$= TVL_YES; }
        ;

opt_release:
          /* empty */ { $$= TVL_UNKNOWN; }
        | RELEASE_SYM        { $$= TVL_YES; }
        | NO_SYM RELEASE_SYM { $$= TVL_NO; }

rollback:
          ROLLBACK_SYM opt_work opt_chain opt_release 
          {
            Select->sql_command= SQLCOM_ROLLBACK;
            Select->sql_tx_work = $2;
            Select->sql_tx_chain= $3;
            Select->sql_tx_release= $4;
          }
        | ROLLBACK_SYM opt_work TO_SYM opt_savepoint ident 
          {
            Select->sql_tx_work = $2;
            Select->sql_command= SQLCOM_ROLLBACK_TO_SAVEPOINT;
            Select->sql_saveident = $5.str;
          }
        ;

opt_savepoint:
          /* empty */ {}
        | SAVEPOINT_SYM {}
        ;









show:
          SHOW
          {
            Select->parsing_place= SELECT_LIST;
          }
          show_param
          {
            Select->parsing_place= NO_MATTER;
          }
        ;


show_param:
           DATABASES wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_DATABASES;
           }
         | opt_full TABLES opt_db wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_TABLES;
               Select->sql_db = $3;
           }
         | opt_full TRIGGERS_SYM opt_db wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_TRIGGERS;
               Select->sql_db = $3;

           }
         | EVENTS_SYM opt_db wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_EVENTS;
               Select->sql_db = $2;

           }
         | TABLE_SYM STATUS_SYM opt_db wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_TABLE_STATUS;
               Select->sql_db = $3;

           }
         | OPEN_SYM TABLES opt_db wild_and_where
           {
               Select->sql_command= SQLCOM_SHOW_OPEN_TABLES;
               Select->sql_db = $3;

           }
         | PLUGINS_SYM
           {
               Select->sql_command= SQLCOM_SHOW_PLUGINS;
           }
         | ENGINE_SYM known_storage_engines show_engine_param
           {
                 
           }
        | ENGINE_SYM ALL show_engine_param
          {
              Select->sql_engine = "ALL";
          }
        | opt_full COLUMNS from_or_in table_ident opt_db wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_FIELDS;
              parseaddtable(Select, $4);
              if($5)
                  $4->field_db=$5;
          }
        | master_or_binary LOGS_SYM
          {
              Select->sql_command = SQLCOM_SHOW_BINLOGS;
          }
        | SLAVE HOSTS_SYM
          {
              Select->sql_command = SQLCOM_SHOW_SLAVE_HOSTS;
          }
        | BINLOG_SYM EVENTS_SYM binlog_in binlog_from
          {
              Select->sql_command= SQLCOM_SHOW_BINLOG_EVENTS;
          } opt_limit_clause_init
        | RELAYLOG_SYM EVENTS_SYM binlog_in binlog_from
          {
              Select->sql_command= SQLCOM_SHOW_RELAYLOG_EVENTS;
          } opt_limit_clause_init
        | keys_or_index from_or_in table_ident opt_db where_clause
          {
              Select->sql_command= SQLCOM_SHOW_KEYS;
              parseaddtable(Select, $3);
              if($4)
                  $3->field_db=$4;
          }
        | opt_storage ENGINES_SYM
          {
              Select->sql_command= SQLCOM_SHOW_STORAGE_ENGINES;
          }
        | PRIVILEGES
          {
              Select->sql_command= SQLCOM_SHOW_PRIVILEGES;
          }
        | COUNT_SYM '(' '*' ')' WARNINGS
          {   Select->sql_command = SQLCOM_SHOW_WARNSCOUNT;}
        | COUNT_SYM '(' '*' ')' ERRORS
          {   Select->sql_command = SQLCOM_SHOW_ERRORSCOUNT;}
        | WARNINGS opt_limit_clause_init
          {   Select->sql_command = SQLCOM_SHOW_WARNS;}
        | ERRORS opt_limit_clause_init
          {   Select->sql_command = SQLCOM_SHOW_ERRORS;}
        | PROFILES_SYM
          {
              Select->sql_command = SQLCOM_SHOW_PROFILES;
          }
        | PROFILE_SYM opt_profile_defs opt_profile_args opt_limit_clause_init
          {
              Select->sql_command= SQLCOM_SHOW_PROFILE;
          }
        | opt_var_type STATUS_SYM wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_STATUS;
              Select->sql_opttype= $1;
          }
        | opt_full PROCESSLIST_SYM
          {   Select->sql_command= SQLCOM_SHOW_PROCESSLIST;}
        | opt_var_type  VARIABLES wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_VARIABLES;
              Select->sql_opttype= $1;
          }
        | charset wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_CHARSETS;
          }
        | COLLATION_SYM wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_COLLATIONS;
          }
        | GRANTS
          {
              Select->sql_command= SQLCOM_SHOW_GRANTS;
          }
        | GRANTS FOR_SYM user
          {
              Select->sql_command = SQLCOM_SHOW_GRANTS;
              Select->sql_grant_user = $3;
            
          }
        | CREATE DATABASE opt_if_not_exists ident
          {
              Select->sql_command = SQLCOM_SHOW_CREATE_DB;
              Select->sql_create_info_options = $3;
              Select->sql_db = $4.str;
          }
        | CREATE TABLE_SYM table_ident
          {
              Select->sql_command = SQLCOM_SHOW_CREATE;
              parseaddtable(Select, $3);

          }
        | CREATE VIEW_SYM table_ident
          {
              Select->sql_command = SQLCOM_SHOW_CREATE;
              parseaddtable(Select, $3);
          }
        | MASTER_SYM STATUS_SYM
          {
              Select->sql_command = SQLCOM_SHOW_MASTER_STAT;
          }
        | SLAVE STATUS_SYM
          {
              Select->sql_command = SQLCOM_SHOW_SLAVE_STAT;
          }
        | CREATE PROCEDURE_SYM sp_name
          {
              Select->sql_command = SQLCOM_SHOW_CREATE_PROC;
              Select->sql_sp = $3;
            
          }
        | CREATE FUNCTION_SYM sp_name
          {

              Select->sql_command = SQLCOM_SHOW_CREATE_FUNC;
              Select->sql_sp = $3;

          }
        | CREATE TRIGGER_SYM sp_name
          {
              Select->sql_command= SQLCOM_SHOW_CREATE_TRIGGER;
              Select->sql_sp = $3;

          }
        | PROCEDURE_SYM STATUS_SYM wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_STATUS_PROC;
          }
        | FUNCTION_SYM STATUS_SYM wild_and_where
          {
              Select->sql_command= SQLCOM_SHOW_STATUS_FUNC;
          }
        | PROCEDURE_SYM CODE_SYM sp_name
          {
              Select->sql_command= SQLCOM_SHOW_PROC_CODE;
              Select->sql_sp = $3;
          }
        | FUNCTION_SYM CODE_SYM sp_name
          {
              Select->sql_command= SQLCOM_SHOW_FUNC_CODE;
              Select->sql_sp = $3;

          }
        | CREATE EVENT_SYM sp_name
          {
              Select->sql_command = SQLCOM_SHOW_CREATE_EVENT;
              Select->sql_sp = $3;

          }
        ;



wild_and_where:
          /* empty */
        | LIKE TEXT_STRING_sys
          {
              Select->sql_wild = $2.str;
          }
        | WHERE expr
          {
              Select->sql_where = $2;
          }
        ;

opt_full:
          /* empty */ { Select->sql_verbose=0; }
        | FULL        { Select->sql_verbose=1; }
        ;

opt_db:
          /* empty */  { $$= 0; }
        | from_or_in ident { $$= $2.str; }
        ;

from_or_in:
          FROM
        | IN_SYM
        ;

known_storage_engines:
          ident_or_text
          {
              Select->sql_engine = $1.str;
          }
        ;

show_engine_param:
          STATUS_SYM
          { Select->sql_command= SQLCOM_SHOW_ENGINE_STATUS; }
        | MUTEX_SYM
          { Select->sql_command= SQLCOM_SHOW_ENGINE_MUTEX; }
        | LOGS_SYM
          { Select->sql_command= SQLCOM_SHOW_ENGINE_LOGS; }
        ;


master_or_binary:
          MASTER_SYM
        | BINARY
        ;


binlog_in:
          /* empty */            { Select->sql_mi_log_file_name = 0; }
        | IN_SYM TEXT_STRING_sys { Select->sql_mi_log_file_name = $2.str; }
        ;

binlog_from:
          /* empty */        { Select->sql_mi_pos = 4; /* skip magic number */ }
        | FROM ulonglong_num { Select->sql_mi_pos = $2; }
        ;

keys_or_index:
          KEYS {}
        | INDEX_SYM {}
        | INDEXES {}
        ;

opt_storage:
          /* empty */
        | STORAGE_SYM
        ;

opt_profile_defs:
        /* empty */
        | profile_defs;

profile_defs:
        profile_def
        | profile_defs ',' profile_def;

profile_def:
        CPU_SYM
        {
            Select->sql_profile_options|= PROFILE_CPU;
        }
        | MEMORY_SYM
        {
            Select->sql_profile_options|= PROFILE_MEMORY;
        }
        | BLOCK_SYM IO_SYM
        {
            Select->sql_profile_options|= PROFILE_BLOCK_IO;
        }
        | CONTEXT_SYM SWITCHES_SYM
        {
            Select->sql_profile_options|= PROFILE_CONTEXT;
        }
        | PAGE_SYM FAULTS_SYM
        {
            Select->sql_profile_options|= PROFILE_PAGE_FAULTS;
        }
        | IPC_SYM
        {
            Select->sql_profile_options|= PROFILE_IPC;
        }
        | SWAPS_SYM
        {
            Select->sql_profile_options|= PROFILE_SWAPS;
        }
        | SOURCE_SYM
        {
            Select->sql_profile_options|= PROFILE_SOURCE;
        }
        | ALL
        {
            Select->sql_profile_options|= PROFILE_ALL;
        }
        ;


opt_profile_args:
        /* empty */
        {
            Select->sql_profile_query_id= 0;
        }
        | FOR_SYM QUERY_SYM NUM
        {
            Select->sql_profile_query_id= atoi($3.str);
        }
        ;


opt_var_type:
          /* empty */ { $$=OPT_SESSION; }
        | GLOBAL_SYM  { $$=OPT_GLOBAL; }
        | LOCAL_SYM   { $$=OPT_SESSION; }
        | SESSION_SYM { $$=OPT_SESSION; }
        ;


opt_if_not_exists:
          /* empty */ { $$= 0; }
        | IF not EXISTS { $$=HA_LEX_CREATE_IF_NOT_EXISTS; }
        ;


sp_name:
          ident '.' ident
          {
              $$ = (PARSEFIELD *)fieldsp(Lex,$1.str,$3);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        | ident
          {
              $$ = (PARSEFIELD *)fieldsp(Lex,NULL,$1);
              if($$ == NULL) {
                  MY_YYABORT;
              }
          }
        ;



ulonglong_num:
          NUM           { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | ULONGLONG_NUM { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | LONG_NUM      { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | DECIMAL_NUM   { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        | FLOAT_NUM     { int error; $$= (unsigned long) parse_strtoll10($1.str, (char**) 0, &error); }
        ;
