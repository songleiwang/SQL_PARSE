#include "parse-lex.h"
#include "parse-charset.h"

char sql_command[100][100];

int sql_selcount = 0;
int field_selcount = 0;


void printtree(SQLPARSELEX lex);
void printoptions(SQLPARSESEL *Select);

void printselect(SQLPARSESEL *sel);
void printinsert(SQLPARSESEL *sel);
void printupdate(SQLPARSESEL *sel);
void printdelete(SQLPARSESEL *sel);
void printset(SQLPARSESEL *sel);
void printcommit(SQLPARSESEL *sel);
void printshow(SQLPARSESEL *sel);
void printbegin(SQLPARSESEL *sel);





void printfield(PARSEFIELD  *field, int offset);
void printfieldlist(PARSEFLIST fieldlist,int offset);





void sql_command_init()
{
    
    strcpy(sql_command[SQLCOM_SELECT],"SELECT");
    strcpy(sql_command[SQLCOM_INSERT] , "INSERT");    

    strcpy(sql_command[SQLCOM_UPDATE] , "UPDATE");
    strcpy(sql_command[SQLCOM_DELETE] , "DELETE");
    strcpy(sql_command[SQLCOM_SET_OPTION] , "SET_OPTION");    

    strcpy(sql_command[SQLCOM_COMMIT] , "COMMIT");
    strcpy(sql_command[SQLCOM_ROLLBACK] , "ROLLBACK");
    strcpy(sql_command[SQLCOM_ROLLBACK_TO_SAVEPOINT] , "ROLLBACK_TO_SAVEPOINT");


    strcpy(sql_command[SQLCOM_SHOW_DATABASES] , "SHOW_DATABASES");
    strcpy(sql_command[SQLCOM_SHOW_TABLES] , "SHOW_TABLES");
    strcpy(sql_command[SQLCOM_SHOW_TRIGGERS] , "SHOW_TRIGGERS");
    strcpy(sql_command[SQLCOM_SHOW_EVENTS] , "SHOW_EVENTS");
    strcpy(sql_command[SQLCOM_SHOW_TABLE_STATUS] , "SHOW_TABLE_STATUS");

    strcpy(sql_command[SQLCOM_SHOW_OPEN_TABLES] , "SHOW_OPEN_TABLES");
    strcpy(sql_command[SQLCOM_SHOW_PLUGINS] , "SHOW_PLUGINS");
    strcpy(sql_command[SQLCOM_SHOW_ENGINE_STATUS] , "SHOW_ENGINE_STATUS");
    strcpy(sql_command[SQLCOM_SHOW_ENGINE_MUTEX] , "SHOW_ENGINE_MUTEX");
    strcpy(sql_command[SQLCOM_SHOW_ENGINE_LOGS] , "SHOW_ENGINE_LOGS");

    strcpy(sql_command[SQLCOM_SHOW_FIELDS] , "SHOW_FIELDS");
    strcpy(sql_command[SQLCOM_SHOW_BINLOGS] , "SHOW_BINLOGS");
    strcpy(sql_command[SQLCOM_SHOW_SLAVE_HOSTS] , "SHOW_SLAVE_HOSTS");
    strcpy(sql_command[SQLCOM_SHOW_BINLOG_EVENTS] , "SHOW_BINLOG_EVENTS");
    strcpy(sql_command[SQLCOM_SHOW_RELAYLOG_EVENTS] , "SHOW_RELAYLOG_EVENTS");

    strcpy(sql_command[SQLCOM_SHOW_KEYS] , "SHOW_KEYS");
    strcpy(sql_command[SQLCOM_SHOW_STORAGE_ENGINES] , "SHOW_STORAGE_ENGINES");
    strcpy(sql_command[SQLCOM_SHOW_PRIVILEGES] , "SHOW_PRIVILEGES");
    strcpy(sql_command[SQLCOM_SHOW_WARNSCOUNT] , "SHOW_WARNSCOUNT");
    strcpy(sql_command[SQLCOM_SHOW_ERRORSCOUNT] , "SHOW_ERRORSCOUNT");

    strcpy(sql_command[SQLCOM_SHOW_WARNS] , "SHOW_WARNS");
    strcpy(sql_command[SQLCOM_SHOW_ERRORS] , "SHOW_ERRORS");
    strcpy(sql_command[SQLCOM_SHOW_PROFILES] , "SHOW_PROFILES");
    strcpy(sql_command[SQLCOM_SHOW_PROFILE] , "SHOW_PROFILE");
    strcpy(sql_command[SQLCOM_SHOW_STATUS] , "SHOW_STATUS");
    strcpy(sql_command[SQLCOM_SHOW_PROCESSLIST] , "SHOW_PROCESSLIST");


    strcpy(sql_command[SQLCOM_SHOW_VARIABLES] , "SHOW_VARIABLES");
    strcpy(sql_command[SQLCOM_SHOW_CHARSETS] , "SHOW_CHARSETS");
    strcpy(sql_command[SQLCOM_SHOW_COLLATIONS] , "SHOW_COLLATIONS");
    strcpy(sql_command[SQLCOM_SHOW_GRANTS] , "SHOW_GRANTS");
    strcpy(sql_command[SQLCOM_SHOW_CREATE_DB] , "SHOW_CREATE_DB");
    strcpy(sql_command[SQLCOM_SHOW_CREATE] , "SHOW_CREATE");

    strcpy(sql_command[SQLCOM_SHOW_MASTER_STAT] , "SHOW_MASTER_STAT");
    strcpy(sql_command[SQLCOM_SHOW_SLAVE_STAT] , "SHOW_SLAVE_STAT");
    strcpy(sql_command[SQLCOM_SHOW_CREATE_PROC] , "SHOW_CREATE_PROC");
    strcpy(sql_command[SQLCOM_SHOW_CREATE_FUNC] , "SHOW_CREATE_FUNC");
    strcpy(sql_command[SQLCOM_SHOW_CREATE_TRIGGER] , "SHOW_CREATE_TRIGGER");

    strcpy(sql_command[SQLCOM_SHOW_STATUS_PROC] , "SHOW_STATUS_PROC");
    strcpy(sql_command[SQLCOM_SHOW_STATUS_FUNC] , "SHOW_STATUS_FUNC");
    strcpy(sql_command[SQLCOM_SHOW_PROC_CODE] , "SHOW_PROC_CODE");
    strcpy(sql_command[SQLCOM_SHOW_CREATE_EVENT] , "SHOW_CREATE_EVENT");
    strcpy(sql_command[SQLCOM_SHOW_FUNC_CODE] , "SHOW_FUNC_CODE");

    strcpy(sql_command[SQLCOM_BEGIN],"BEGIN/START");
    

}


char field_type[256][100];

void sql_field_type_init()
{
    strcpy(field_type[STRING_FIELD],"STRING");
    strcpy(field_type[COLUMN_FIELD],"COLUMN");
    strcpy(field_type[SP_FIELD],"SP");
    
    
    strcpy(field_type[ORDERBY_FIELD],"ORDERBY");
    strcpy(field_type[DATESTRING_FIELD],"DATESTRING");
    strcpy(field_type[TIMESTRING_FIELD],"TIMESTRING");
    strcpy(field_type[TIMESTAMPSTRING_FIELD],"TIMESTAMPSTRING");
    
    strcpy(field_type[NUM_FIELD],"NUM");
    strcpy(field_type[LONGNUM_FIELD],"LONGNUM");
    strcpy(field_type[ULONGLONGNUM_FIELD],"ULONGLONGNUM");
    strcpy(field_type[DECIMALNUM_FIELD],"DECIMALNUM");
    strcpy(field_type[FLOATNUM_FIELD],"FLOATNUM");
    strcpy(field_type[HEXNUM_FIELD],"HEXNUM");
    strcpy(field_type[BINNUM_FIELD],"BINNUM");
    
    

    strcpy(field_type[NULL_FIELD],"NULL");
    strcpy(field_type[TRUE_FIELD],"TRUE");
    strcpy(field_type[FALSE_FIELD],"FALSE");
    

    strcpy(field_type[OR_FIELD],"OR");
    strcpy(field_type[AND_FIELD],"AND");
    strcpy(field_type[XOR_FIELD],"XOR");

    strcpy(field_type[OR_OR_FIELD],"OR_OR");
    strcpy(field_type[NEG_FIELD],"NEG");
    strcpy(field_type[BITNEG_FIELD],"BITNEG");
    strcpy(field_type[NOT_FIELD],"NOT");

    strcpy(field_type[BITOR_FIELD],"BITOR");
    strcpy(field_type[BITAND_FIELD],"BITAND");
    strcpy(field_type[SHIFTLEFT_FIELD],"SHIFTLEFT");
    strcpy(field_type[SHIFTRIGHT_FIELD],"SHIFTRIGHT");
    strcpy(field_type[BITXOR_FIELD],"BITXOR");
    strcpy(field_type[PLUS_FIELD],"PLUS");
    strcpy(field_type[MINUS_FIELD],"MINUS");
    strcpy(field_type[MUL_FIELD],"MUL");
    strcpy(field_type[DIV_FIELD],"DIV");
    strcpy(field_type[MOD_FIELD],"MOD");
    strcpy(field_type[SETVAR_FIELD],"SETVAR");
    strcpy(field_type[EQUAL_FIELD],"EQUAL");
    strcpy(field_type[COMPOP_FIELD],"COMPOP");

    
    strcpy(field_type[ROW_FIELD],"ROW");
    strcpy(field_type[BINARY_FIELD],"BINARY");
    strcpy(field_type[DEFAULT_FIELD],"DEFAULT");
    strcpy(field_type[INSERTVALUE_FIELD],"INSERTVALUE");
    strcpy(field_type[PARAM_FIELD],"PARAM");
    strcpy(field_type[VAR_FIELD],"VARIABLE");
    strcpy(field_type[TABLE_FIELD],"TABLE");
    strcpy(field_type[JOIN_FIELD],"JOIN");



    strcpy(field_type[ISNULL_FIELD],"ISNULL");
    strcpy(field_type[NOTNULL_FIELD],"NOTNULL");
    strcpy(field_type[ISTRUE_FIELD],"ISTRUE");
    strcpy(field_type[NOTTRUE_FIELD],"NOTTRUE");
    strcpy(field_type[ISFALSE_FIELD],"ISFALSE");
    strcpy(field_type[NOTFALSE_FIELD],"NOTFALSE");
    strcpy(field_type[NOTNULL_FIELD],"NOTNULL");
    strcpy(field_type[NOTNULL_FIELD],"NOTNULL");


    strcpy(field_type[OUTFILE_FIELD],"OUTFILE");
    strcpy(field_type[DUMPFILE_FIELD],"DUMPFILE");
    strcpy(field_type[PASSWORD_FIELD],"PASSWORD");
    

    strcpy(field_type[FUNC_CHAR_FIELD],"FUNC_CHAR");
    strcpy(field_type[FUNC_CURUSER_FIELD],"FUNC_CURUSER");
    strcpy(field_type[FUNC_DATE_FIELD],"FUNC_DATE");
    strcpy(field_type[FUNC_DAY_FIELD],"FUNC_DAY");
    strcpy(field_type[FUNC_HOUR_FIELD],"FUNC_HOUR");
    strcpy(field_type[FUNC_HOUR_FIELD],"FUNC_HOUR");
    strcpy(field_type[FUNC_INSERT_FIELD],"FUNC_INSERT");
    strcpy(field_type[FUNC_INTERVAL_FIELD],"FUNC_INTERVAL");
    strcpy(field_type[FUNC_LEFT_FIELD],"FUNC_LEFT");
    strcpy(field_type[FUNC_RIGHT_FIELD],"FUNC_RIGHT");
    strcpy(field_type[FUNC_MINUTE_FIELD],"FUNC_MINUTE");
    strcpy(field_type[FUNC_MONTH_FIELD],"FUNC_MONTH");
    strcpy(field_type[FUNC_SECOND_FIELD],"FUNC_SECOND");
    strcpy(field_type[FUNC_TIME_FIELD],"FUNC_TIME");
    strcpy(field_type[FUNC_TIMESTAMP_FIELD],"FUNC_TIMESTAMP");
    strcpy(field_type[FUNC_TRIM_FIELD],"FUNC_TRIM");    
    strcpy(field_type[FUNC_LTRIM_FIELD],"FUNC_LTRIM");    
    strcpy(field_type[FUNC_RTRIM_FIELD],"FUNC_RTRIM");    
    strcpy(field_type[FUNC_BTRIM_FIELD],"FUNC_BTRIM");    
    strcpy(field_type[FUNC_YEAR_FIELD],"FUNC_YEAR");    
    strcpy(field_type[FUNC_USER_FIELD],"FUNC_USER");    
    
    strcpy(field_type[FUNC_ADDDATE_FIELD],"FUNC_ADDDATE");
    strcpy(field_type[FUNC_CURDATE_FIELD],"FUNC_CURDATE");
    strcpy(field_type[FUNC_CURTIME_FIELD],"FUNC_CURTIME");
    strcpy(field_type[FUNC_DATEADDINTERVAL_FIELD],"FUNC_DATEADDINTERVAL");
    strcpy(field_type[FUNC_DATESUBINTERVAL_FIELD],"FUNC_DATESUBINTERVAL");
    strcpy(field_type[FUNC_EXTRACT_FIELD],"FUNC_EXTRACT");
    strcpy(field_type[FUNC_GETFORMAT_FIELD],"FUNC_GETFORMAT");
    strcpy(field_type[FUNC_NOW_FIELD],"FUNC_NOW");
    strcpy(field_type[FUNC_POSITION_FIELD],"FUNC_POSITION");
    strcpy(field_type[FUNC_SUBDATE_FIELD],"FUNC_SUBDATE");
    strcpy(field_type[FUNC_SUBSTRING_FIELD],"FUNC_SUBSTRING");
    strcpy(field_type[FUNC_SYSDATE_FIELD],"FUNC_SYSDATE");
    strcpy(field_type[FUNC_TIMESTAMPADD_FIELD],"FUNC_TIMESTAMPADD");
    strcpy(field_type[FUNC_TIMESTAMPDIFF_FIELD],"FUNC_TIMESTAMPDIFF");
    strcpy(field_type[FUNC_UTCDATE_FIELD],"FUNC_UTCDATE");
    strcpy(field_type[FUNC_UTCTIME_FIELD],"FUNC_UTCTIME");
    strcpy(field_type[FUNC_UTCTIMESTAMP_FIELD],"FUNC_UTCTIMESTAMP");
    
    
    strcpy(field_type[FUNC_UDF_FUNC],"USER_DEFINE_FUNC");
    

    strcpy(field_type[FUNC_ASCII_FIELD],"FUNC_ASCII");
    strcpy(field_type[FUNC_CHARSET_FIELD],"FUNC_CHARSET");
    strcpy(field_type[FUNC_COALESCE_FIELD],"FUNC_COALESCE");
    strcpy(field_type[FUNC_COLLATION_FIELD],"FUNC_COLLATION");
    strcpy(field_type[FUNC_DATABASE_FIELD],"FUNC_DATABASE");
    strcpy(field_type[FUNC_IF_FIELD],"FUNC_IF");
    strcpy(field_type[FUNC_FORMAT_FIELD],"FUNC_FORMAT");
    strcpy(field_type[FUNC_MICROSECOND_FIELD],"FUNC_MICROSECOND");
    strcpy(field_type[FUNC_MOD_FIELD],"FUNC_MOD");
    strcpy(field_type[FUNC_OLDPASSWORD_FIELD],"FUNC_OLDPASSWORD");
    strcpy(field_type[FUNC_PASSWORD_FIELD],"FUNC_PASSWORD");
    strcpy(field_type[FUNC_QUARTER_FIELD],"FUNC_QUARTER");
    strcpy(field_type[FUNC_REPEAT_FIELD],"FUNC_REPEAT");
    strcpy(field_type[FUNC_REPLACE_FIELD],"FUNC_REPLACE");
    strcpy(field_type[FUNC_REVERSE_FIELD],"FUNC_REVERSE");
    strcpy(field_type[FUNC_ROWCOUNT_FIELD],"FUNC_ROWCOUNT");
    strcpy(field_type[FUNC_TRUNCATE_FIELD],"FUNC_TRUNCATE");
    strcpy(field_type[FUNC_WEEK_FIELD],"FUNC_WEEK");
    strcpy(field_type[FUNC_WEIGHTSTRING_FIELD],"FUNC_WEIGHTSTRING");

    strcpy(field_type[FUNC_CONTAINS_FIELD],"FUNC_CONTAINS");
    strcpy(field_type[FUNC_GEOMETRYCOLLECTION_FIELD],"FUNC_GEOMETRYCOLLECTION");
    strcpy(field_type[FUNC_LINESTRING_FIELD],"FUNC_LINESTRING");
    strcpy(field_type[FUNC_MULTILINESTRING_FIELD],"FUNC_MULTILINESTRING");
    strcpy(field_type[FUNC_MULTIPOINT_FIELD],"FUNC_MULTIPOINT");
    strcpy(field_type[FUNC_MULTIPOLYGON_FIELD],"FUNC_MULTIPOLYGON");
    strcpy(field_type[FUNC_POINT_FIELD],"FUNC_POINT");
    strcpy(field_type[FUNC_POLYGON_FIELD],"FUNC_POLYGON");

    strcpy(field_type[FUNC_COLLATE_FIELD],"FUNC_COLLATE");

    strcpy(field_type[FUNC_AVG_FIELD],"FUNC_AVG");
    strcpy(field_type[FUNC_AVGDISTINCT_FIELD],"FUNC_AVGDISTINCT");
    strcpy(field_type[FUNC_BITAND_FIELD],"FUNC_BITAND");
    strcpy(field_type[FUNC_BITOR_FIELD],"FUNC_BITOR");
    strcpy(field_type[FUNC_BITXOR_FIELD],"FUNC_BITXOR");
    strcpy(field_type[FUNC_COUNT_FIELD],"FUNC_COUNT");
    strcpy(field_type[FUNC_COUNTALL_FIELD],"FUNC_COUNTALL");
    strcpy(field_type[FUNC_COUNTDISTINCT_FIELD],"FUNC_COUNTDISTINCT");
    strcpy(field_type[FUNC_MIN_FIELD],"FUNC_MIN");
    strcpy(field_type[FUNC_MINDISTINCT_FIELD],"FUNC_MINDISTINCT");
    strcpy(field_type[FUNC_MAX_FIELD],"FUNC_MAX");
    strcpy(field_type[FUNC_MAXDISTINCT_FIELD],"FUNC_MAXDISTINCT");
    strcpy(field_type[FUNC_STD_FIELD],"FUNC_STD");
    strcpy(field_type[FUNC_VARIANCE_FIELD],"FUNC_VARIANCE");
    strcpy(field_type[FUNC_STDDEVSAMP_FIELD],"FUNC_STDDEVSAMP");
    strcpy(field_type[FUNC_VARSAMP_FIELD],"FUNC_VARSAMP");
    strcpy(field_type[FUNC_SUM_FIELD],"FUNC_SUM");
    strcpy(field_type[FUNC_SUMDISTINCT_FIELD],"FUNC_SUMDISTINCT_FIELD");
    strcpy(field_type[FUNC_GROUPCONCAT_FIELD],"FUNC_GROUPCONCAT");
    strcpy(field_type[FUNC_GROUPCONCATDISTINCT_FIELD],"FUNC_GROUPCONCATDISTINCT");
    
 



    
    strcpy(field_type[FUNC_MATCH_FIELD],"FUNC_MATCH");
    strcpy(field_type[FUNC_EXISTS_FIELD],"FUNC_EXISTS");
    strcpy(field_type[FUNC_CAST_FIELD],"FUNC_CAST");
    strcpy(field_type[FUNC_CASE_FIELD],"FUNC_CASE");
    strcpy(field_type[FUNC_CONVERT_FIELD],"FUNC_CONVERT");
    strcpy(field_type[FUNC_PASSWORD_FIELD],"FUNC_PASSWORD");
    strcpy(field_type[FUNC_OLDPASSWORD_FIELD],"FUNC_OLDPASSWORD");

    strcpy(field_type[FUNC_NAMES_FIELD],"FUNC_NAMES");
    



    


    strcpy(field_type[SUBSEL_FIELD],"SUBSEL");
    strcpy(field_type[FIELDLIST_FIELD],"FIELDLIST");

}




void printtree(SQLPARSELEX lex)
{
    SQLPARSESEL *sel = lex.sql_sellist.head;
    
    printf("-------\n");
    printf("%s (main)",sql_command[sel->sql_command]);

    printoptions(sel);



    if(sel->sql_command == SQLCOM_SELECT) {
        printselect(sel);

        sel = sel->next;

        while(sel != NULL)
        {
            printf("\n\n****************************************************\n");
            printf("****************************************************\n\n");            
                
            sql_selcount++;
            printf("-------\n");
            printf("%s (%dth SUBSEL)",sql_command[sel->sql_command],sql_selcount);
            printselect(sel);
            sel = sel->next;
        }
    } else if (sel->sql_command == SQLCOM_INSERT) {
        printinsert(sel);

        sel = sel->next;

        while(sel != NULL)
        {
            printf("\n\n****************************************************\n");
            printf("****************************************************\n\n");            
                
            sql_selcount++;
            printf("-------\n");
            printf("%s (%dth SUBSEL)",sql_command[sel->sql_command],sql_selcount);
            printselect(sel);
            sel = sel->next;
        }

    } else if(sel->sql_command == SQLCOM_UPDATE) {
        printupdate(sel);
            
    } else if(sel->sql_command == SQLCOM_DELETE){
        printdelete(sel);
            
    } else if(sel->sql_command ==SQLCOM_SET_OPTION){
        printset(sel);
            
    } else if(sel->sql_command ==SQLCOM_COMMIT || sel->sql_command ==SQLCOM_ROLLBACK || sel->sql_command ==SQLCOM_ROLLBACK_TO_SAVEPOINT){
        printcommit(sel);
            
    } else if(sel->sql_command ==SQLCOM_BEGIN) {
        printbegin(sel);
    } else {
        printshow(sel);
        
    }

    printf("\n");
    
}

void printoptions(SQLPARSESEL *Select)
{
    int          gcout = 0;

    printf("\n-------\n");
    printf("options:\n");
    
    
    if(Select->sql_options & SELECT_STRAIGHT_JOIN) {
        gcout++;
        printf("STRAIGHT_JOIN  ");
    }

    if(Select->sql_options & SELECT_HIGH_PRIORITY){
        gcout++;
        printf("HIGH_PRIORITY  ");
    }
    if(Select->sql_options & SELECT_DISTINCT){
        gcout++;
        printf("DISTINCT  ");
    }
    if(Select->sql_options & SELECT_SMALL_RESULT){
        gcout++;
        printf("SQL_SMALL_RESULT  ");
    }
    if(Select->sql_options & SELECT_BIG_RESULT){
        gcout++;
        printf("SQL_BIG_RESULT  ");
    }
    if(Select->sql_options & OPTION_BUFFER_RESULT){
        gcout++;
        printf("SQL_BUFFER_RESULT  ");
    }
    if(Select->sql_options & OPTION_FOUND_ROWS){
        gcout++;
        printf("SQL_CALC_FOUND_ROWS  ");
    }
    if(Select->sql_options & SELECT_ALL){
        gcout++;
        printf("ALL  ");
    }
    if(Select->sql_options & OPTION_TO_QUERY_CACHE){
        gcout++;
        printf("SQL_CACHE  ");
    }
        if(Select->sql_options & OPTION_QUICK){
        gcout++;
        printf("QUICK  ");
    }
    if(Select->sql_ignore == 1) {
        printf("IGNORE  ");
    }

    if(Select->sql_upsql_commit == 1) {
        printf("UPSQL_COMMIT  ");
    }

    
}

void printprofileoptions(SQLPARSESEL *Select)
{
    if(Select->sql_profile_options & PROFILE_CPU) {
        printf("PROFILE_CPU  ");
    }
    if(Select->sql_profile_options & PROFILE_MEMORY) {
        printf("PROFILE_MEMORY  ");
    }
    if(Select->sql_profile_options & PROFILE_BLOCK_IO) {
        printf("PROFILE_BLOCK_IO  ");
    }
    if(Select->sql_profile_options & PROFILE_CONTEXT) {
        printf("PROFILE_CONTEXT  ");
    }
    if(Select->sql_profile_options & PROFILE_PAGE_FAULTS) {
        printf("PROFILE_PAGE_FAULTS  ");
    }
    if(Select->sql_profile_options & PROFILE_IPC) {
        printf("PROFILE_IPC  ");
    }
    if(Select->sql_profile_options & PROFILE_SWAPS) {
        printf("PROFILE_SWAPS  ");
    }
    if(Select->sql_profile_options & PROFILE_SOURCE) {
        printf("PROFILE_SOURCE  ");
    }
    if((Select->sql_profile_options ^ PROFILE_ALL) == 0) {
        printf("PROFILE_ALL  ");
    }

}

void printbegin(SQLPARSESEL *sel)
{
    
    if(sel->sql_start_trx_opt != 0) {
        printf("\n");
        printf("start_trx_opt:%d",sel->sql_start_trx_opt);
    } 
    
}

void printshow(SQLPARSESEL *sel)
{
    int  offset = 0;
    
    if(sel->sql_wild != NULL) {
        printf("\n");
        printf("like:%s",sel->sql_wild);
    } 

    if(sel->sql_db != NULL) {
        printf("\n");
        printf("sqldb:%s",sel->sql_db);
    } 

    if(sel->sql_verbose !=0) {
        printf("\n");
        printf("sql_verbose:FULL");
    }

    if(sel->sql_engine !=NULL) {
        printf("\n");
        printf("engine:%s",sel->sql_engine);
    }


    if(sel->sql_profile_query_id !=0) {
        printf("\n");
        printf("profile_query_id:%d",sel->sql_profile_query_id);
    }

    if(sel->sql_mi_log_file_name != NULL) {
        printf("\n");
        printf("log(%s:%d)",sel->sql_mi_log_file_name,sel->sql_mi_pos);
    }
    if(sel->sql_create_info_options != 0) {
        printf("\n");
        printf("IF not EXIST");
    }

    if(sel->sql_command == SQLCOM_SHOW_STATUS || sel->sql_command == SQLCOM_SHOW_VARIABLES) {
    printf("\n");
    printf("sql_opttype:%s",sel->sql_opttype == OPT_GLOBAL ? "GLOABL" : "SESSION");

    }

    if(sel->sql_grant_user != NULL) {
        printf(" [host %s user %s]",sel->sql_grant_user->host.str,sel->sql_grant_user->user.str);
    }  

    if(sel->sql_where != NULL) {
        printf("\n-----------\n");
        printf("where:");       
        
        printfield(sel->sql_where, offset);
        printf("\n");    
    }

    if(sel->sql_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("table:"); 
        printfieldlist(sel->sql_tablelist,offset);
    }

    if(sel->sql_sel_limit != NULL) {
        printf("\n-----------\n");
        printf("limit:");  
        printf("\n");
        printf("%*slimit:%s",offset,"",sel->sql_sel_limit->field_name.str);
        
    if(sel->sql_off_limit != NULL) {
        printf("  offset:%s",sel->sql_off_limit->field_name.str);
        
    }
    }   

    if(sel->sql_command ==SQLCOM_SHOW_PROFILE) {
        printf("\n-----------\n");
        printf("profile options:\n");
        printprofileoptions(sel);  
    }

    if(sel->sql_sp != NULL) {
        printf("\n-----------\n");
        printf("sp:");       
        
        printfield(sel->sql_sp, offset);
        printf("\n");    
    }

}


void printcommit(SQLPARSESEL *sel)
{
    printf("\n-----------\n");
    
    if(sel->sql_tx_work != 0){
    printf("\n");
    printf("tx_work:%d",sel->sql_tx_work);
    }    

    if(sel->sql_tx_chain != TVL_UNKNOWN){
    printf("\n");
    printf("tx_chain:%d",sel->sql_tx_chain);
    }

    if(sel->sql_tx_release != TVL_UNKNOWN){
    
    printf("\n");
    printf("tx_release:%d",sel->sql_tx_release);
    }

   if(sel->sql_saveident != NULL) {
        printf("\n");
        printf("saveident:%s",sel->sql_saveident);
    } 
}

void printset(SQLPARSESEL *sel)
{
    int  offset = 0;
    

    if(sel->sql_setlist.fcount != 0) {
        printf("\n-----------\n");
        printf("set:"); 
        printfieldlist(sel->sql_setlist,offset);
    }


    printf("\n-----------\n");

    printf("\n");
    printf("sql_opttype:%s",sel->sql_opttype == OPT_GLOBAL ? "GLOABL" : "SESSION");
    
    
    printf("\n");
    printf("txisolation:%d",sel->sql_txisolation);
    printf("\n");
    printf("txaccessmode:%d",sel->sql_txaccessmode);
    
}

void printdelete(SQLPARSESEL *sel)
{
    int  offset = 0;
    

    if(sel->sql_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("table:"); 
        printfieldlist(sel->sql_tablelist,offset);
    }
    if(sel->sql_from_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("from table:"); 
        printfieldlist(sel->sql_from_tablelist,offset);
    }
    if(sel->sql_using_tablelist.fcount != 0) {
    printf("\n-----------\n");
        printf("using table:"); 
        printfieldlist(sel->sql_using_tablelist,offset);
    }


       if(sel->sql_where != NULL) {
    printf("\n-----------\n");
    printf("where:");       
        
        printfield(sel->sql_where, offset);
        printf("\n");    
    }

    if(sel->sql_paramlist.fcount != 0) {
        printf("\n-----------\n");
        printf("param:"); 
        printfieldlist(sel->sql_paramlist,offset);
    }


        printf("\n-----------\n");
    
    if(sel->sql_locktp != TL_IGNORE) {
        printf("\n");
        printf("locktp:%d",sel->sql_locktp);
    } 

}


void printupdate(SQLPARSESEL *sel)
{
    int  offset = 0;
    

    if(sel->sql_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("update table:"); 
        printfieldlist(sel->sql_tablelist,offset);
    }
    if(sel->sql_fieldlist.fcount != 0) {
        printf("\n-----------\n");
        printf("field:"); 
        printfieldlist(sel->sql_fieldlist,offset);
    }


    if(sel->sql_where != NULL) {
    printf("\n-----------\n");
    printf("where:");       
        
        printfield(sel->sql_where, offset);
        printf("\n");    
    }

    if(sel->sql_orderlist.fcount != 0) {
    printf("\n-----------\n");
    printf("order:");     
        printfieldlist(sel->sql_orderlist, offset);
        printf("\n");    
    }

    if(sel->sql_paramlist.fcount != 0) {
        printf("\n-----------\n");
        printf("param:"); 
        printfieldlist(sel->sql_paramlist,offset);
    }

    if(sel->sql_sel_limit != NULL) {
        printf("\n-----------\n");
        printf("limit:");  
        printf("\n");
        printf("%*slimit:%s",offset,"",sel->sql_sel_limit->field_name.str);
        
    if(sel->sql_off_limit != NULL) {
        printf("  offset:%s",sel->sql_off_limit->field_name.str);
        
    }
    }   

    printf("\n-----------\n");
    
    if(sel->sql_locktp != TL_IGNORE) {
        printf("\n");
        printf("locktp:%d",sel->sql_locktp);
    } 

}
void printinsert(SQLPARSESEL *sel)
{
    int  i, j;
    int  offset = 0;
    PARSEFLIST *value;
    PARSEFIELD *field;
    

    if(sel->sql_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("into:"); 
        printfieldlist(sel->sql_tablelist,offset);
    }
    if(sel->sql_fieldlist.fcount != 0) {
        printf("\n-----------\n");
        printf("field(%d):",sel->sql_fieldlist.fcount); 
        printfieldlist(sel->sql_fieldlist,offset);
    }


    if(sel->sql_value_count != 0) {
        printf("\n-----------\n");
        printf("values:");
        value =  sel->sql_value;
        for(i = 0;i < sel->sql_value_count; i++)
        {
            printf("\n");
            field = value->head;
            for(j = 0; j<value->fcount; j++)
            {
                printf("[%s:",field_type[field->field_type]);
                if(field->field_type == SUBSEL_FIELD) {
                    field_selcount++;
                    printf("%dth SUBSEL]",field_selcount);
                }else {
                    printf("%s]\n ",field->field_name.str);
                }
                field = field->next;
            }
            value = value->next;
        }
    }

    if(sel->sql_ins_upd_fieldlist.fcount != 0) {
        printf("\n-----------\n");
        printf("ins_upd:"); 
        printfieldlist(sel->sql_ins_upd_fieldlist,offset);
    }

 
    if(sel->sql_paramlist.fcount != 0) {
        printf("\n-----------\n");
        printf("param:"); 
        printfieldlist(sel->sql_paramlist,offset);
    }

    printf("\n-----------\n");
    
    if(sel->sql_locktp != TL_IGNORE) {
        printf("\n");
        printf("locktp:%d",sel->sql_locktp);
    } 


    

    
}
void printselect(SQLPARSESEL *sel)
{
    int  offset = 0;


    printf("\n-----------\n");
    printf("select field:");
    offset = 4;    
    printfieldlist(sel->sql_fieldlist,offset);
    

    if(sel->sql_separator != NULL) {
        printf("\n");
        printf("separator:%s",sel->sql_separator);
        printf("\n");
        
    }
    if(sel->sql_length != NULL) {
        printf("\n");
        printf("(cast)length:%s  ",sel->sql_length);
        printf("\n");
        
    }
    if(sel->sql_dec != NULL) {
        printf("\n");
        
        printf("(cast)dec:%s",sel->sql_dec);
        printf("\n");
    }

    if(sel->sql_charset != NULL || sel->sql_charset_bin != NULL) {
        printf("\n");
        
        printf("charset:");
        if(sel->sql_charset != NULL)
            printf("%s  ",sel->sql_charset);
        if(sel->sql_charset_bin != NULL)
            printf("%s  ",sel->sql_charset_bin);

        printf("\n");
    }
        

  
    if(sel->sql_from_tablelist.fcount != 0) {
        printf("\n-----------\n");
        printf("from:"); 
        printfieldlist(sel->sql_from_tablelist,offset);
    }

    
    if(sel->sql_index_hintlist.fcount != 0) {

        printf("\n");
        printf("index_hint:");   
        printfieldlist(sel->sql_index_hintlist,offset);
    if(sel->sql_index_hint_type != 0) {
        printf("\n");
        printf("index_hint_type:%d",sel->sql_index_hint_type);
        
    }
    if(sel->sql_index_hint_clause != 0) {
        printf("\n");
        printf("index_hint_clause:%d",sel->sql_index_hint_clause);
        
    }
    }



    if(sel->sql_intolist.fcount != 0) {
            
    printf("\n-----------\n");
    printf("into:");   
        printfieldlist(sel->sql_intolist, offset);
    
  
    if(sel->sql_into_terminate != 0) {
        printf("\n");
        printf("into_terminate:%s",sel->sql_into_terminate);
    }    
    if(sel->sql_into_optionally != 0) {
        printf("\n");
        printf("into_optionally_enclose:%s",sel->sql_into_optionally);
        
    }
    if(sel->sql_into_enclosed != 0) {
        printf("\n");
        printf("into_enclosed:%s",sel->sql_into_enclosed);
        
    }
    if(sel->sql_into_escape != 0) {
        printf("\n");
        printf("into_escape:%s",sel->sql_into_escape);
        
    }
    if(sel->sql_into_lineterminate != 0) {
        printf("\n");
        printf("into_lineterminate:%s",sel->sql_into_lineterminate);
        
    }
    if(sel->sql_into_linestart != 0) {
        printf("\n");
        printf("into_linestart:%s",sel->sql_into_linestart);
        
    }

    }




 
    
    if(sel->sql_where != NULL) {
    printf("\n-----------\n");
    printf("where:");       
        
        printfield(sel->sql_where, offset);
        printf("\n");    
    }


    if(sel->sql_having != NULL) {
    printf("\n-----------\n");
    printf("having:");        
        printfield(sel->sql_having, offset);
        printf("\n");    
    }

 

    if(sel->sql_gorderlist.fcount != 0) {
    printf("\n-----------\n");
        printf("gorder:");       
        
        printfieldlist(sel->sql_gorderlist, offset);
        printf("\n");    
    }

   

    if(sel->sql_orderlist.fcount != 0) {
    printf("\n-----------\n");
    printf("order:");     
        printfieldlist(sel->sql_orderlist, offset);
        printf("\n");    
    }

    if(sel->sql_grouplist.fcount != 0) {
        printf("\n-----------\n");
        printf("group:");     
        printfieldlist(sel->sql_grouplist, offset);
        printf("\n");    
        
    if(sel->olap_type != UNSPECIFIED_OLAP_TYPE) {
        printf("\n");
        printf("group_olap_type:%d",sel->olap_type);
        
    }

    }

    if(sel->sql_sel_limit != NULL) {
        printf("\n-----------\n");
        printf("limit:");  
        printf("\n");
        printf("%*slimit:%s",offset,"",sel->sql_sel_limit->field_name.str);
        
    if(sel->sql_off_limit != NULL) {
        printf("  offset:%s",sel->sql_off_limit->field_name.str);
        
    }
    }


    if(sel->sql_locktp != TL_IGNORE) {
        printf("\n");
        printf("locktp:%d",sel->sql_locktp);
        
    }

    if(sel->sql_proc_analyse_treeelement != 0) {
        printf("\n");
        printf("proc_analyse_treeelement:%ld",sel->sql_proc_analyse_treeelement);
        
    }

    if(sel->sql_proc_analyse_treemem != 0) {
        printf("\n");
        printf("proc_analyse_treemem:%ld",sel->sql_proc_analyse_treemem);
        
    }
    if(sel->sql_unionlist.fcount != 0) {
    printf("\n-----------\n");
        printf("union:");       
        
        printfieldlist(sel->sql_unionlist, offset);
        printf("\n");    
    }


    if(sel->sql_paramlist.fcount != 0) {
        printf("\n-----------\n");
        printf("param:"); 
        printfieldlist(sel->sql_paramlist,offset);
    }

}

void printfieldlist(PARSEFLIST fieldlist,int offset)
{
    int    field_count,i = 0;
    PARSEFIELD  *field;

    field  = fieldlist.head;
    field_count = fieldlist.fcount;
    for(i = 0; i<field_count; i++)
    {
        printfield(field, offset);
        field = field->next;
    }
}

void printfieldpoint(PARSEFIELD  *field, char *name, int offset)
{
    if(field != NULL) {

        if(name != NULL)
            printf("\n%*s--%s",offset,"",name);

        while(field != NULL) {
            printfield(field, offset + 4);
            field = field->next;
        }
    }
}

void printfield(PARSEFIELD  *field, int offset)
{
    int i = 0;
    PARSEFIELD  *arg_field; 

    printf("\n");
    
    printf("%*s",offset,"");
    
//    printf("%d:",field->field_type);
    if(field->field_type == BITNEG_FIELD || field->field_type == NEG_FIELD)
    {
        printf("%s(%s):",field_type[field->field_type],field_type[field->field_valtype]);  
        
    } 
    else
    {
        printf("%s:",field_type[field->field_type]);  
    }

    if(field->field_type == SUBSEL_FIELD)
    {
        field_selcount++;
        printf("%dth SUBSEL",field_selcount);


        if(field->field_union_opt != UNION_DEFAULT) {
        printf(" [union_opt %d]",field->field_union_opt);
        }

        if(field->subselany != 0) {
        printf(" [subselelect all or any %d]",field->subselany);
        
        }    

        return;
    }

    if(field->field_db != NULL) 
        printf("%s.",field->field_db);
    if(field->field_table != NULL) 
        printf("%s.",field->field_table);

    if(field->field_name.str != NULL) 
        printf("%s",field->field_name.str);
   
    if(field->field_name_as != NULL) {
        printf(" [as %s]",field->field_name_as);
    }
    if(field->field_charset != NULL) {
        printf(" [charset %s]",field->field_charset);
    }
    if(field->field_collate != NULL) {
        printf(" [charset %s]",field->field_collate);
    }

    if(field->field_interval != INTERVAL_NONE) {
        printf(" [interval %d]",field->field_interval);
    }

    if(field->field_datetime_precision != 0) {
        printf(" [datetime_precision %lu]",field->field_datetime_precision);
    }
    

    if(field->field_timestamp_type != TIMESTAMP_NONE) {
        printf(" [timestamp_type %d]",field->field_timestamp_type);
    }

    if(field->field_ws_levels != 0) {
        printf(" [ws_levels %lu]",field->field_ws_levels);
    }

    if(field->field_ws_nweights != 0) {
        printf(" [ws_nweights %lu]",field->field_ws_nweights);
    }


     if(field->field_fulltext != 0) {
        printf(" [fulltext %u]",field->field_fulltext);
    }

     if(field->field_casttype != -1) {
        printf(" [casttype %d]",field->field_casttype);
    }
    
    if(field->field_weightstrleng[0] != 0) {
        printf(" [weightstrleng %lu %lu %lu]",field->field_weightstrleng[0],field->field_weightstrleng[1],field->field_weightstrleng[2]);
    }

    if(field->field_join_type != DEFAULT_JOIN) {
        printf(" [join_type %d]",field->field_join_type);
    }



    if(field->field_type == VAR_FIELD && field->field_vartype != OPT_DEFAULT) {
        printf("  [%s]",field->field_vartype == OPT_SESSION ? "SESSION":"GLOBAL");
    }

    if(field->field_type == ORDERBY_FIELD ) {
        printf("  [ORDERDIR %s]",field->field_order_dir == 1 ? "ASC":"DESC");
    }
    if(field->field_type == PARAM_FIELD) {
        printf(" [offset %d num %d]",field->field_paramoffset,field->field_paramnum);
    }    


    if(field->field_user != NULL) {
        printf(" [host %s user %s]",field->field_user->host.str,field->field_user->user.str);
    }  


    for(i = 0,arg_field = field->field_arg.head; i < field->field_arg.fcount; i++)
    {
        printfield(arg_field, offset + 4);
        arg_field = arg_field->next;
    }


    /*select_item*/
    printfieldpoint(field->field_from, "from", offset );
    printfieldpoint(field->field_for, "for", offset );
    printfieldpoint(field->field_in, "in", offset );
    printfieldpoint(field->field_not_in, "not-in", offset );
    printfieldpoint(field->field_like, "like", offset );
    printfieldpoint(field->field_not_like, "not-like", offset );
    printfieldpoint(field->field_between, "between", offset );
    printfieldpoint(field->field_not_between, "not-between", offset );
    printfieldpoint(field->field_regexp, "regexp", offset );
    printfieldpoint(field->field_not_regexp, "not-regexp", offset );
    printfieldpoint(field->field_escape, "escape", offset );
    printfieldpoint(field->field_against, "against", offset );
    printfieldpoint(field->field_when, "when", offset );
    printfieldpoint(field->field_else, "else", offset );


    printfieldpoint(field->field_partition, "partition", offset );
    printfieldpoint(field->field_joinlist.head, "join", offset );
    printfieldpoint(field->field_join_on, "join-on", offset );
    printfieldpoint(field->field_join_using, "join-using", offset );
   


}   


int main(int argc,char **argv)
{
    int       rc;
    char      sqlsta1[1024]={0};
    char      sqlsta4[2048]={0};
    

    SQLPARSELEX     parse_lex;
/*
         sprintf(sqlsta1,    " INSERT INTO mionldb.TBL_MIONL_TRANS_LOG"
						" ("
						"mi_trans_seq,"
						"mi_trans_dt, "
						"ma_trans_tm,"
						"ma_trans_dt, "
						"ma_cup_branch_ins_id_cd,"
						"trans_seq, "
						"ma_trans_seq, "
						"cup_branch_ins_id_cd, "
						"ext_trans_tp, "
						"internal_trans_tp, "
						"trans_nm, "
						"pri_acct_no, "
						"trans_at, "
						"trans_td_tm, "
						"term_seq, "
						"term_id, "
						"mchnt_cd, "
						"acpt_ins_id_cd, "
						"buss_region_cd, "
						"usr_no_tp, "
						"usr_no_region_cd,"
						"usr_no_region_addn_cd, "
						"usr_no, "
						"industry_mchnt_cd, "
						"industry_ins_id_cd, "
						"rout_industry_ins_id_cd, "
						"fee_date, "
						"trans_st, "
						"settle_dt, "
						"ma_settle_dt, to_ts, rec_upd_ts, rec_crt_ts) "
						" VALUES (111111, "
						"'mi_trans_seq', 'mi_trans_dt', 'ma_trans_tm', 'ma_trans_dt', 'ma_cup_branch_ins_id_cd',"
						"  trans_seq, 'ma_trans_seq', 'cup_branch_ins_id_cd', 'ext_trans_tp', 'internal_trans_tp',"
		    			"'trans_nm', 1546.989 ,'trans_at', 'trans_td_tm', 'term_seq',"
						"'term_id', 'mchnt_cd', 'acpt_ins_id_cd', 'buss_region_cd', 'usr_no_tp',"
						"'usr_no_region_cd', 'usr_no_region_addn_cd', 'usr_no', 'industry_mchnt_cd', 'industry_ins_id_cd',"
						"'rout_industry_ins_id_cd', 'fee_date', 'trans_st', 'settle_dt', current_timestamp, current_timestamp, current_timestamp)");


         
    sprintf(sqlsta4, "INSERT INTO mionldb.mysqltt"
        "("
        "transmsn_dt_tm, acq_ins_id_cd, sys_tra_no, "
        "tfr_in_in, related_key, acq_ins_tp, fwd_ins_tp, rcv_ins_tp, "
        "iss_ins_tp, rsn_cd, sti_in, sti_takeout_in, fee_in, cross_dist_in, "
        "disc_cd, dom_allot_cd, dif_allot_cd, trans_rcv_ts, to_ts, moni_dist, "
        "risk_in, trans_id, trans_id_conv, trans_seq, trans_seq_conv, trans_tp,"
        "resnd_num, settle_dt, settle_mon, settle_d, cycle_no, sms_dms_conv_in, "
        "msg_tp, msg_tp_conv, pri_acct_no, pri_acct_no_conv, bin, cups_card_in, "
        "cups_sig_card_in, card_class, card_attr, trans_chnl, card_media, "
        "card_brand, proc_cd, proc_cd_conv, trans_at, trans_curr_cd, fwd_settle_at, "
        "rcv_settle_at, fwd_settle_conv_rt, rcv_settle_conv_rt, fwd_settle_curr_cd, "
        "rcv_settle_curr_cd, cdhd_at, cdhd_conv_rt, cdhd_curr_cd, fwd_disc_at, "
        "rcv_disc_at, disc_curr_cd, fee_dir_in, dms_trans_id, iss_ins_id_cd, "
        "related_ins_id_cd, related_bin, loc_trans_tm, loc_trans_dt, conv_dt, "
        "mchnt_tp, acq_ins_cntry_cd, ext_pan_cntry_cd, pos_entry_md_cd, card_seq_id, "
        "pos_cond_cd, pos_cond_cd_conv, pos_pin_capture_cd, fwd_ins_id_cd, "
        "retri_ref_no, term_id, mchnt_cd, card_accptr_nm_loc, sec_related_ctrl_inf, "
        "addn_pos_inf, orig_msg_tp, orig_sys_tra_no, orig_sys_tra_no_conv, "
        "orig_transmsn_dt_tm, orig_acq_ins_id_cd, orig_fwd_ins_id_cd, rcv_ins_id_cd, "
        "resv_fld1, resv_fld2, fwd_proc_in, rcv_proc_in, trans_st, vfy_rslt, "
        "vfy_fee_cd, trans_fin_ts, expire_dt, auth_id_resp_cd, iss_resp_cd, "
        "iss_resp_cd_conv, acq_resp_cd, acq_resp_cd_conv, addn_pvt_dat, addn_at, "
        "iss_addn_dat, ic_res_dat, repl_at, iss_ins_res, auth_resp, moni_in, "
        "auth_id_resp_cd_conv, ic_flds, cups_def_fld, ext_header, track_2_dat, "
        "track_3_dat, id_no, tfr_in_acct_id, tfr_out_acct_id, cups_res, acq_ins_res, "
        "addn_priv_dat, resv_fld3, resv_fld4, resv_fld5, resv_fld6"
        ") "
        "VALUES"
        "("
        "'transmsn_dt_tm','acq_ins_id_cd','sys_tra_no','tfr_in_in',"
        "'','','','','','','','','','','','','',now(),now(),'sys_tra_no','','',"
        "'',0,0,'',0,'sys_tra_no','','','sys_tra_no','','','','sys_tra_no','','','','','','',"
        "'','','','','',0,'',0,0,0,0,'','',0,0,'',0,0,'','','','','','',"
        "'','','','','','','','','','','','sys_tra_no','','sys_tra_no','sys_tra_no','','','',"
        "'','','','','','','','','',2,9,'sys_tra_no','sys_tra_no','sys_tra_no',now(),'sys_tra_no',"
        "'sys_tra_no',1,1,1,1,'sys_tra_no','sys_tra_no','sys_tra_no','sys_tra_no','sys_tra_no','sys_tra_no','sys_tra_no','1','',"
        "'','','','sys_tra_no','sys_tra_no','','','','sys_tra_no','sys_tra_no','','','','',''"
        ")");


        sprintf(sqlsta4,  "UPDATE mionldb.mysqltt "
    "SET "
    "fwd_proc_in='fwd_proc_in', "
    "rcv_proc_in='rcv_proc_in', "
    "trans_st='trans_st', "
    "vfy_rslt='vfy_rslt', "
    "vfy_fee_cd='vfy_fee_cd', "
    "trans_fin_ts=now(), "
    "expire_dt='trans_fin_ts', "
    "auth_id_resp_cd='auth_id_resp_cd', "
    "iss_resp_cd='iss_resp_cd', "
    "iss_resp_cd_conv='iss_resp_cd_conv', "
    "acq_resp_cd='acq_resp_cd', "
    "acq_resp_cd_conv='acq_resp_cd_conv', "
    "addn_pvt_dat='addn_pvt_dat', "
    "addn_at='addn_at', "
    "iss_addn_dat='iss_addn_dat', "
    "ic_res_dat='ic_res_dat', "
    "repl_at='repl_at', "
    "iss_ins_res='iss_ins_res', "
    "auth_resp='auth_resp', "
    "moni_in='1', "
    "auth_id_resp_cd_conv='hello' "
    "WHERE "
    "transmsn_dt_tm=111111 and acq_ins_id_cd='acq_ins_id_cd' and sys_tra_no='sys_tra_no' and tfr_in_in='tfr_in_in'");
*/

    sprintf(sqlsta4,"%s",argv[1]);
    sql_command_init();
    sql_field_type_init();

    init_charset();

    parse_init(&parse_lex,"utf8");

    rc = parse_sql(&parse_lex,sqlsta4,strlen(sqlsta4));
    if(rc != 0)
    {
        printf("sql parse error\n");
        return -1;
    }
        
    printtree(parse_lex);

    return 0;
}


