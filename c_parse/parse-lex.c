#include <stdlib.h>
#include <stddef.h>
#include <assert.h>

#include "parse-lex.h"
#include "parse-charset.h"
#include "parse-hash.h"
#include "global.h"


const LEX_STRING null_lex_str  =  {NULL, 0};
const LEX_STRING empty_lex_str =  {(char *) "", 0};
const LEX_STRING all_lex_str   =  {"*",1 };
const LEX_STRING param_lex_str = {"?",1};
const LEX_STRING curuser_lex_str = {"CURRENT_USER",12};
const LEX_STRING default_lex_str = {"DEFAULT",7};
const LEX_STRING on_lex_str = {"on",2};
const LEX_STRING sall_lex_str = {"ALL",3};
const LEX_STRING binary_lex_str = {"BINARY",6};






static const gchar *long_str = "2147483647";
static const guint  long_len = 10;
static const gchar *signed_long_str = "-2147483648";
static const gchar *longlong_str = "9223372036854775807";
static const guint  longlong_len = 19;
static const gchar *signed_longlong_str = "-9223372036854775808";
static const guint  signed_longlong_len = 19;
static const gchar *unsigned_longlong_str = "18446744073709551615";
static const guint  unsigned_longlong_len = 20;


static LEX_STRING get_token(Lex_input_stream *lip, guint skip, guint length);
static LEX_STRING get_quoted_token(Lex_input_stream *lip, guint skip, guint length, gchar quote);

static guint int_token(const gchar *str,guint length);
static gchar *get_text(Lex_input_stream *lip, gint pre_skip, gint post_skip);





/*static void body_utf8_start(Lex_input_stream *lip, SQLPARSELEX *sqlparselex, const gchar *begin_ptr);*/
static void body_utf8_append(Lex_input_stream *lip, const gchar *ptr, const gchar *end_ptr);
static void body_utf8_append0(Lex_input_stream *lip, const gchar *ptr);
static void body_utf8_append_literal(Lex_input_stream *lip, SQLPARSELEX *sqlparselex, const LEX_STRING *txt, const CHARSET_INFO *txt_cs, const gchar *end_ptr);

static gint find_keyword(Lex_input_stream *lip, guint len, gboolean function);




/**
  Prepare Lex_input_stream instance state for use for handling next SQL statement.

  It should be called between two statements in a multi-statement query.
  The operation resets the input stream to the beginning-of-parse state,
  but does not reallocate m_cpp_buf.
*/

void reset(Lex_input_stream *lip, gchar *buffer, guint length)
{
    lip->yylineno = 1;
    lip->yytoklen = 0;
    lip->yylval = NULL;
    lip->lookahead_token = -1;
    lip->lookahead_yylval = NULL;
    lip->m_ptr = buffer;
    lip->m_tok_start = NULL;
    lip->m_tok_end = NULL;
    lip->m_end_of_query = buffer + length;
    lip->m_tok_start_prev = NULL;
    lip->m_buf = buffer;
    lip->m_buf_length = length;
    lip->m_echo = TRUE;
    lip->m_cpp_tok_start = NULL;
    lip->m_cpp_tok_start_prev = NULL;
    lip->m_cpp_tok_end = NULL;
    lip->m_body_utf8 = NULL;
    lip->m_cpp_utf8_processed_ptr = NULL;
    lip->next_state = MY_LEX_START;
    lip->found_semicolon = NULL;
    lip->ignore_space = MY_TEST(lip->m_sqlparselex->sql_mode & MODE_IGNORE_SPACE);
    lip->stmt_prepare_mode = TRUE;
    lip->multi_statements = TRUE;
    lip->in_comment = NO_COMMENT;
    lip->m_underscore_cs = NULL;
    lip->m_cpp_ptr = lip->m_cpp_buf;
}



void *lexalloc(SQLPARSELEX *sqlparselex, gsize length)
{
    return mem_alloc((sqlparselex->sql_mem_root), length);
}

void *lexalloc0(SQLPARSELEX *sqlparselex, gsize length)
{
    return mem_alloc0((sqlparselex->sql_mem_root), length);
}

gchar *lexstrmake(SQLPARSELEX *sqlparselex, const gchar *str, gsize length)
{
    return mem_strmake((sqlparselex->sql_mem_root), str,length);
}
void fieldprealloc(SQLPARSELEX *sqlparselex)
{
    sqlparselex->field_free_list =  (PARSEFIELD *)lexalloc(sqlparselex,sizeof(PARSEFIELD) * PARSE_PREALLOC_FILED);
    sqlparselex->field_used_num = 0;
}
void *fieldalloc(SQLPARSELEX *sqlparselex)
{
    PARSEFIELD *field;
    if(sqlparselex->field_used_num >= PARSE_PREALLOC_FILED) {
        fieldprealloc(sqlparselex);
    }

    field = sqlparselex->field_free_list + sqlparselex->field_used_num;
    (sqlparselex->field_used_num)++;
    
//    field = lexalloc(sqlparselex,sizeof(PARSEFIELD));
    if(field == NULL) {
        return NULL;
    }

    field->field_type = UNUSED_FIELD;
    field->field_valtype = UNUSED_FIELD;

    field->field_db = NULL;
    field->field_table = NULL;
    field->field_name.str = NULL;
    field->field_name.length = 0;
    field->field_name_as = NULL;   

    field->field_long = -1; 
    field->field_interval = INTERVAL_NONE;
    field->field_timestamp_type = TIMESTAMP_NONE;
    field->field_datetime_precision = 0;
    field->field_ws_nweights = 0;
    field->field_ws_levels = 0;
    field->field_weightstrleng[0] = 0;
    field->field_vartype = OPT_DEFAULT;    
    field->field_fulltext = 0;   
    field->field_casttype = ITEM_CAST_NONE;
    field->field_union_opt = UNION_DEFAULT;
    

    field->field_argc = 0;
    field->field_argv = NULL;
    field->field_arg.head = NULL;
    field->field_arg.fcount = 0;


    field->field_joinlist.head = NULL;
    field->field_joinlist.tail = NULL;
    field->field_joinlist.fcount = 0;

    field->field_in = NULL;
    field->field_for = NULL;
    field->field_from = NULL;
    field->field_against = NULL;
    
    field->next = NULL;

    return (void *)field;
}

void *fieldcolumn(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table, 
                  LEX_STRING field_name)
{
    PARSEFIELD *field;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }

    field->field_type = COLUMN_FIELD;

    field->field_db = field_db;
    field->field_table = field_table;
    field->field_name.str = field_name.str;
    field->field_name.length = field_name.length;

    return (void *)field;
}

void *fieldsp(SQLPARSELEX *sqlparselex, gchar *field_db, LEX_STRING field_name)
{

    PARSEFIELD *field;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }

    field->field_type = SP_FIELD;

    field->field_db = field_db;
    field->field_name.str = field_name.str;
    field->field_name.length = field_name.length;

    return (void *)field;
}
void *fieldstring(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table, 
                  LEX_STRING field_name)
{
    PARSEFIELD *field;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }

    field->field_type = STRING_FIELD;

    field->field_db = field_db;
    field->field_table = field_table;
    field->field_name.str = field_name.str;
    field->field_name.length = field_name.length;

    return (void *)field;
}


void *fieldflist(SQLPARSELEX *sqlparselex, PARSEFLIST flist)
{
    PARSEFIELD *field;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }

    field->field_type = FIELDLIST_FIELD;

    field->field_arg.head = flist.head;
    field->field_arg.tail = flist.head;
    field->field_arg.fcount = flist.fcount;

    return (void *)field;
}

void *fieldtable(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table)
{
    PARSEFIELD *field;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }

    field->field_type = TABLE_FIELD;

    field->field_db = field_db;
    field->field_table = field_table;

    return (void *)field;
}

void *fieldappend(SQLPARSELEX *sqlparselex, PARSEFIELD *field, LEX_STRING append)
{
    gchar *fieldnm = field->field_name.str;
    gsize  fieldlen = field->field_name.length;

    field->field_name.length = fieldlen + append.length; 

    field->field_name.str = (gchar *)lexalloc(sqlparselex,
                                             field->field_name.length + 1);
    if(field->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field->field_name.str, fieldnm, fieldlen);
    memcpy(field->field_name.str + fieldlen, append.str , append.length);
    field->field_name.str[field->field_name.length] = '\0';
    
    return (void *)field;
        
}

void *fieldnum(SQLPARSELEX *sqlparselex,  LEX_STRING field_value)
{
    PARSEFIELD  *field = NULL;

    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }


    field->field_type = NUM_FIELD;
    field->field_name.str = field_value.str;
    field->field_name.length = field_value.length;

    /*
    gchar       *end_ptr = NULL;
    gint         errnum = 0;
    end_ptr= (gchar*) field_value.str + field_value.length;    
    field->field_long = parse_strtoll10(field_value.str, &end_ptr, &errnum);;
    */
    return (void *)field;
}

void *fieldparam(SQLPARSELEX *sqlparselex,  gint offset)
{
    PARSEFIELD  *field = NULL;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }


    field->field_type = PARAM_FIELD;
    field->field_name.length = 2;
    
    field->field_name.str = (gchar *)lexalloc(sqlparselex,
                                             field->field_name.length);
    if(field->field_name.str == NULL) {
        return NULL;
    }

    field->field_name.str[0] = '?';
    field->field_name.str[1] = '\0';
   
    sqlparselex->sql_paramnum++;

    field->field_paramoffset = offset;
    field->field_paramnum = sqlparselex->sql_paramnum;

    return (void *)field;
}


void *fieldvariable(SQLPARSELEX *sqlparselex, LEX_STRING field_var_nm, enum enum_var_type vartype)
{
    PARSEFIELD  *field = NULL;
    
    field = fieldalloc(sqlparselex);
    if(field == NULL) {
        return NULL;
    }


    field->field_type = VAR_FIELD;
    field->field_name.length = field_var_nm.length;
    field->field_name.str = field_var_nm.str;
    
    field->field_vartype = vartype;
    

    return (void *)field;
}

void *fieldva(SQLPARSELEX *sqlparselex, enum enum_field_type optype, gint arg_num, ...)
{
    int            i = 0;
    va_list        arg_ptr;
    PARSEFIELD    *arg_field, *field_op;

    field_op = fieldalloc(sqlparselex);
    if(field_op == NULL) {
        return NULL;
    }

    field_op->field_type = optype;

    va_start(arg_ptr,arg_num);

    for(i = 0; i < arg_num; i++)
    {
        arg_field = va_arg(arg_ptr,PARSEFIELD *);
        addarg(field_op,arg_field);
    }

    return (void *)field_op;
}

void *fieldoprate(SQLPARSELEX *sqlparselex, enum enum_field_type optype,
                  gchar *op, PARSEFIELD *arg_field1,PARSEFIELD *arg_field2)
{
    gint        oplen = 0;
    PARSEFIELD *field_oprate = NULL;

    field_oprate = fieldva(sqlparselex,optype,2,arg_field1,arg_field2);
    if(field_oprate == NULL) {
        return NULL;
    }

    oplen = strlen(op);
    field_oprate->field_name.length =  oplen;
    field_oprate->field_name.str = (gchar *)lexalloc0(sqlparselex, oplen + 1);
    if(field_oprate->field_name.str == NULL) {
        return NULL;
    }
    memcpy(field_oprate->field_name.str, op, oplen); 
/*    
    oplen = strlen(op);
    field_oprate->field_name.length =  arg_field1->field_name.length 
                                     + arg_field2->field_name.length + oplen;
    field_oprate->field_name.str = (gchar *)lexalloc0(sqlparselex,
                                            field_oprate->field_name.length + 1);
    if(field_oprate->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field_oprate->field_name.str, arg_field1->field_name.str, 
           arg_field1->field_name.length);
    memcpy(field_oprate->field_name.str + arg_field1->field_name.length, 
           op, oplen);
    memcpy(field_oprate->field_name.str + arg_field1->field_name.length + oplen, 
           arg_field2->field_name.str, arg_field2->field_name.length);

    field_oprate->field_name.str[field_oprate->field_name.length] = '\0';
*/
    return (void *)field_oprate;
}

void *fieldneg(SQLPARSELEX *sqlparselex, enum enum_field_type optype, PARSEFIELD *arg_field)
{
    gint         newlen = 0;
    gchar       *newname = NULL;    
    PARSEFIELD  *field_neg = arg_field;

    if(field_neg->field_valtype == UNUSED_FIELD)
        field_neg->field_valtype = field_neg->field_type;

    field_neg->field_type = optype;
    
    newlen = field_neg->field_name.length + 1;
    newname = (gchar *)lexalloc0(sqlparselex,newlen + 1);


    if(optype == NEG_FIELD) {
        newname[0] = '-';
    }else if(optype == BITNEG_FIELD) {
        newname[0] = '~';
    }else {
        newname[0] = ' ';
    }

    memcpy(newname + 1, field_neg->field_name.str, field_neg->field_name.length);

    field_neg->field_name.length =  newlen;
    field_neg->field_name.str = newname;

/*
    field_neg->field_name.length =  arg_field->field_name.length + 1 ;
    field_neg->field_name.str = (gchar *)lexalloc0(sqlparselex,field_neg->field_name.length + 1);
    if(field_neg->field_name.str == NULL) {
        return NULL;
    }

    if(optype == NEG_FIELD) {
        field_neg->field_name.str[0] = '-';
        field_neg->field_long = 0 - arg_field->field_long; 
    }else if(optype == BITNEG_FIELD) {
        field_neg->field_name.str[0] = '~';
        field_neg->field_long = ~arg_field->field_long;
    }else {
        field_neg->field_name.str[0] = ' ';
    }


    memcpy(field_neg->field_name.str + 1, arg_field->field_name.str, arg_field->field_name.length - 1);

    field_neg->field_name.str[field_neg->field_name.length] = '\0';
*/
    return (void *)field_neg;
}

void *fieldjoin(SQLPARSELEX *sqlparselex, enum join_type join_type, PARSEFIELD *arg_field1, PARSEFIELD *arg_field2)
{
    PARSEFIELD *field_join;

    field_join = fieldva(sqlparselex,JOIN_FIELD,2,arg_field1,arg_field2);
    if(field_join == NULL) {
        return NULL;
    }

    field_join->field_join_type = join_type;

    return (void *)field_join;
    
}

void *fieldnot(SQLPARSELEX *sqlparselex, PARSEFIELD *arg_field)
{
    PARSEFIELD *field_neg;

    field_neg = fieldva(sqlparselex,NOT_FIELD,1,arg_field);
    if(field_neg == NULL) {
        return NULL;
    }

/*
    field_neg->field_name.length =  arg_field->field_name.length + 4;
    field_neg->field_name.str = (gchar *)lexalloc0(sqlparselex,field_neg->field_name.length + 1);
    if(field_neg->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field_neg->field_name.str , "not ", 4);
    memcpy(field_neg->field_name.str + 4, arg_field->field_name.str, arg_field->field_name.length - 4);
    field_neg->field_name.str[field_neg->field_name.length] = '\0';
*/
    return (void *)field_neg;
}

void *fieldsubsel(SQLPARSELEX *sqlparselex, SQLPARSESEL *subsel)
{
    PARSEFIELD *field_subsel;
        
    field_subsel = fieldalloc(sqlparselex);
    if(field_subsel == NULL) {
        return NULL;
    }

    field_subsel->field_type = SUBSEL_FIELD;

    field_subsel->subselect = (void *)subsel;

    return (void *)field_subsel;

}


void *fieldf(SQLPARSELEX *sqlparselex, enum enum_field_type optype)
{
    PARSEFIELD *field_func;

    field_func = fieldva(sqlparselex,optype,0);
    if(field_func == NULL) {
        return NULL;
    }

/*
    field_func->field_name.length =  4;
    field_func->field_name.str = (gchar *)lexalloc0(sqlparselex,field_func->field_name.length+1);
    if(field_func->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field_func->field_name.str , "FUNC",5);
*/
    return (void *)field_func;
}

void *fieldfuser(SQLPARSELEX *sqlparselex, enum enum_field_type optype)
{
    PARSEFIELD *field_func;

    field_func = fieldva(sqlparselex,optype,0);
    if(field_func == NULL) {
        return NULL;
    }
/*
    field_func->field_name.length = user.length ;
    field_func->field_name.str = (gchar *)lexalloc0(sqlparselex,field_func->field_name.length + 1);
    if(field_func->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field_func->field_name.str ,user.str ,user.length);
    memcpy(field_func->field_name.str + user.length ,"()", 2);
*/  

    return (void *)field_func;
}


void *fieldfone(SQLPARSELEX *sqlparselex, enum enum_field_type optype, PARSEFIELD *arg_field)
{
    PARSEFIELD *field_func;

    field_func = fieldva(sqlparselex,optype,1,arg_field);
    if(field_func == NULL) {
        return NULL;
    }



/*
    field_func->field_name.length =  arg_field->field_name.length + 6;
    field_func->field_name.str = (gchar *)lexalloc0(sqlparselex,field_func->field_name.length);
    if(field_func->field_name.str == NULL) {
        return NULL;
    }

    memcpy(field_func->field_name.str , "FUNC(",5);
    memcpy(field_func->field_name.str + 5, arg_field->field_name.str, arg_field->field_name.length);
    field_func->field_name.str[5+arg_field->field_name.length] = ')';
*/
    return (void *)field_func;
}






void addarg(PARSEFIELD *field, PARSEFIELD *arg_field)
{
    if(field == NULL)
        return;
    if(arg_field == NULL) 
        return;
/*
    arg_field->next = field->field_argv;
    field->field_argv = arg_field;
    (field->field_argc)++;
*/
    if(field->field_arg.fcount == 0) {
        field->field_arg.head = arg_field;
    } else {
        field->field_arg.tail->next = arg_field;        
    }
    field->field_arg.tail = arg_field;        

    (field->field_arg.fcount)++;

}

void addarglist(PARSEFIELD *field, PARSEFLIST *arg_list)
{
    if(field == NULL)
        return;
    if(arg_list->fcount == 0)
        return;

    if(field->field_arg.fcount == 0) {
        field->field_arg.head = arg_list->head;
    } else {
        field->field_arg.tail->next = arg_list->head;        
    }
    field->field_arg.tail = arg_list->tail;  

    field->field_arg.fcount = field->field_arg.fcount + arg_list->fcount;

/*
    if(arg_list->tail != NULL && arg_list->head != NULL) {
        arg_list->tail->next = field->field_argv;
        field->field_argv = arg_list->head;
        field->field_argc = field->field_argc + arg_list->fcount;
    }
*/
}


void parseaddupfield(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
/*
    field->next = sqlparsesel->sql_ins_upd_field;
    sqlparsesel->sql_ins_upd_field = field;
    sqlparsesel->sql_ins_upd_field_count++;
*/
    if(sqlparsesel->sql_ins_upd_fieldlist.fcount == 0) {
        sqlparsesel->sql_ins_upd_fieldlist.head = field;
    } else {
        sqlparsesel->sql_ins_upd_fieldlist.tail->next = field;
    }

    sqlparsesel->sql_ins_upd_fieldlist.tail = field;

    sqlparsesel->sql_ins_upd_fieldlist.fcount++;
}

void parseaddfield(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
/*
    field->next = sqlparsesel->sql_field;
    sqlparsesel->sql_field = field;
    sqlparsesel->sql_field_count++;
*/
    if(sqlparsesel->sql_fieldlist.fcount == 0) {
        sqlparsesel->sql_fieldlist.head = field;
    } else {
        sqlparsesel->sql_fieldlist.tail->next = field;
    }

    sqlparsesel->sql_fieldlist.tail = field;

    sqlparsesel->sql_fieldlist.fcount++;
}

void parseaddset(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
    /*
    field->next = sqlparsesel->sql_set;
    sqlparsesel->sql_set = field;
    sqlparsesel->sql_set_count++;
    */
    if(sqlparsesel->sql_setlist.fcount == 0) {
        sqlparsesel->sql_setlist.head = field;
    } else {
        sqlparsesel->sql_setlist.tail->next = field;
    }

    sqlparsesel->sql_setlist.tail = field;

    sqlparsesel->sql_setlist.fcount++;
}

void parseaddtable(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
    /*
    field->next = sqlparsesel->sql_table;
    sqlparsesel->sql_table = field;
    sqlparsesel->sql_table_count++;
    */
    if(sqlparsesel->sql_tablelist.fcount == 0) {
        sqlparsesel->sql_tablelist.head = field;
    } else {
        sqlparsesel->sql_tablelist.tail->next = field;
    }
    sqlparsesel->sql_tablelist.tail = field;
    sqlparsesel->sql_tablelist.fcount++;
}

void parseaddfromtable(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
 /*
    field->next = sqlparsesel->sql_from_table;
    sqlparsesel->sql_from_table = field;
    sqlparsesel->sql_from_table_count++;
*/
    if(sqlparsesel->sql_from_tablelist.fcount == 0) {
        sqlparsesel->sql_from_tablelist.head = field;
    } else {
        sqlparsesel->sql_from_tablelist.tail->next = field;
    }
    sqlparsesel->sql_from_tablelist.tail = field;
    sqlparsesel->sql_from_tablelist.fcount++;
}

void parseaddvalue(SQLPARSESEL *sqlparsesel, PARSEFLIST *fieldlist)
{
    if(fieldlist == NULL)
        return;

    if(sqlparsesel->sql_value_count == 0)
    {
        sqlparsesel->sql_value = fieldlist;
    }
    else
    {
        sqlparsesel->sql_value_tail->next = fieldlist;
    }
    sqlparsesel->sql_value_tail = fieldlist;
    sqlparsesel->sql_value_count++;
}

void parseaddparam(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
/*
    field->next = sqlparsesel->sql_param;
    sqlparsesel->sql_param = field;
    sqlparsesel->sql_param_count++;
*/
    if(sqlparsesel->sql_paramlist.fcount == 0) {
        sqlparsesel->sql_paramlist.head = field;
    } else {
        sqlparsesel->sql_paramlist.tail->next = field;
    }
    sqlparsesel->sql_paramlist.tail = field;
    sqlparsesel->sql_paramlist.fcount++;
}

void parseaddorder(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
    /*
    field->next = sqlparsesel->sql_order;
    sqlparsesel->sql_order = field;
    sqlparsesel->sql_order_count++;
    */

    if(sqlparsesel->sql_orderlist.fcount == 0) {
        sqlparsesel->sql_orderlist.head = field;
    } else {
        sqlparsesel->sql_orderlist.tail->next = field;
    }
    sqlparsesel->sql_orderlist.tail = field;
    sqlparsesel->sql_orderlist.fcount++;
}

void parseaddgroup(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
/*
    field->next = sqlparsesel->sql_group;
    sqlparsesel->sql_group = field;
    sqlparsesel->sql_group_count++;
*/

    if(sqlparsesel->sql_grouplist.fcount == 0) {
        sqlparsesel->sql_grouplist.head = field;
    } else {
        sqlparsesel->sql_grouplist.tail->next = field;
    }
    sqlparsesel->sql_grouplist.tail = field;
    sqlparsesel->sql_grouplist.fcount++;
}

void parseaddindexhint(SQLPARSESEL *sqlparsesel, PARSEFIELD *field)
{
    if(field == NULL)
        return;
/*
    field->next = sqlparsesel->sql_index_hint;
    sqlparsesel->sql_index_hint = field;
    sqlparsesel->sql_index_hint_count++;
*/
    if(sqlparsesel->sql_index_hintlist.fcount == 0) {
        sqlparsesel->sql_index_hintlist.head = field;
    } else {
        sqlparsesel->sql_index_hintlist.tail->next = field;
    }
    sqlparsesel->sql_index_hintlist.tail = field;
    sqlparsesel->sql_index_hintlist.fcount++;
}

void parseaddlist(PARSEFLIST *parselist, PARSEFIELD *field)
{
    if(parselist->fcount == 0) {
        parselist->head = field;
    } else {
        parselist->tail->next = field;
    }
    parselist->tail = field;
    parselist->fcount++;
}

/**
  Perform initialization of Lex_input_stream instance.

  Basically, a buffer for pre-processed query. This buffer should be large
  enough to keep multi-statement query. The allocation is done once in
  Lex_input_stream::init() in order to prevent memory pollution when
  the server is processing large multi-statement queries.
*/

gboolean init(Lex_input_stream *lip, SQLPARSELEX *sqlparselex,
              gchar* buff, guint length)
{

    lip->m_cpp_buf = (gchar*) lexalloc(sqlparselex, length + 1);

    if (lip->m_cpp_buf == NULL)
        return TRUE;

    lip->m_sqlparselex = sqlparselex;
    reset(lip, buff, length);

    return FALSE;
}



#define set_echo(lip,echo) (lip->m_echo = echo)
/*
void set_echo(Lex_input_stream *lip, gboolean echo)
{
    lip->m_echo = echo;
}
*/

#define save_in_comment_state(lip) \
{\
    lip->m_echo_saved = lip->m_echo;\
    lip->in_comment_saved = lip->in_comment;\
}

/*
void save_in_comment_state(Lex_input_stream *lip)
{
    lip->m_echo_saved = lip->m_echo;
    lip->in_comment_saved = lip->in_comment;
}
*/

#define restore_in_comment_state(lip) \
{\
    lip->m_echo = lip->m_echo_saved; \
    lip->in_comment = lip->in_comment_saved;\
}

/*
void restore_in_comment_state(Lex_input_stream *lip)
{
    lip->m_echo = lip->m_echo_saved;
    lip->in_comment = lip->in_comment_saved;
}
*/

#define skip_binary(lip,n) \
{\
    if (lip->m_echo) {\
        memcpy(lip->m_cpp_ptr, lip->m_ptr, n);\
        lip->m_cpp_ptr += n;\
    }\
    lip->m_ptr += n;\
}

/*
void skip_binary(Lex_input_stream *lip, gint n)
{
    if (lip->m_echo) {
        memcpy(lip->m_cpp_ptr, lip->m_ptr, n);
        lip->m_cpp_ptr += n;
    }
    lip->m_ptr += n;
}
*/
#define yyGet(lip,c) \
{\
    c = *(lip->m_ptr)++;\
    if (lip->m_echo)\
        *(lip->m_cpp_ptr)++ = c;\
}
/*
guchar yyGet(Lex_input_stream *lip)
{
    gchar c = *(lip->m_ptr)++;
    if (lip->m_echo)
        *(lip->m_cpp_ptr)++ = c;
    return c;
}
*/


/**
   Get the last character accepted.
   @return the last character accepted.
*/

#define yyGetLast(lip) ((guchar)(lip->m_ptr[-1]))
/*
guchar yyGetLast(Lex_input_stream *lip)
{
    return lip->m_ptr[-1];
}
*/
/**
   Look at the next character to parse, but do not accept it.
*/

#define yyPeek(lip) ((guchar)(lip->m_ptr[0]))

/*
guchar yyPeek(Lex_input_stream *lip)
{
    return lip->m_ptr[0];
}
*/
/**
   Look ahead at some character to parse.
   @param n offset of the character to look up
*/

#define yyPeekn(lip,n) ((guchar)(lip->m_ptr[n]))

/*
guchar yyPeekn(Lex_input_stream *lip, gint n)
{
    return lip->m_ptr[n];
}
*/
/**
   Cancel the effect of the last yyGet() or yySkip().
   Note that the echo mode should not change between calls to yyGet / yySkip
   and yyUnget. The caller is responsible for ensuring that.
*/


#define yyUnget(lip) \
{\
    lip->m_ptr--;\
    if (lip->m_echo)\
        lip->m_cpp_ptr--;\
}

/*
void yyUnget(Lex_input_stream *lip)
{
    lip->m_ptr--;
    if (lip->m_echo)
        lip->m_cpp_ptr--;
}
*/
/**
   Accept a character, by advancing the input stream.
*/

#define yySkip(lip) \
{\
    if (lip->m_echo)\
        *(lip->m_cpp_ptr)++ = *(lip->m_ptr)++;\
    else\
        lip->m_ptr++;\
}

/*
void yySkip(Lex_input_stream *lip)
{
    if (lip->m_echo)
        *(lip->m_cpp_ptr)++ = *(lip->m_ptr)++;
    else
        lip->m_ptr++;
}
*/
/**
   Accept multiple characters at once.
   @param n the number of characters to accept.
*/

#define yySkipn(lip,n) \
{\
    if (lip->m_echo) {\
        memcpy(lip->m_cpp_ptr, lip->m_ptr, n);\
        lip->m_cpp_ptr += n;\
    }\
    lip->m_ptr += n;\
}

/*
void yySkipn(Lex_input_stream *lip, gint n)
{
    if (lip->m_echo) {
        memcpy(lip->m_cpp_ptr, lip->m_ptr, n);
        lip->m_cpp_ptr += n;
    }
    lip->m_ptr += n;
}
*/
/**
   Puts a character back into the stream, canceling
   the effect of the last yyGet() or yySkip().
   Note that the echo mode should not change between calls
   to unput, get, or skip from the stream.
*/
gchar *yyUnput(Lex_input_stream *lip, gchar ch)
{
    *--(lip->m_ptr) = ch;
    if (lip->m_echo)
        lip->m_cpp_ptr--;
    return lip->m_ptr;
}

/**
   Inject a character into the pre-processed stream.
   
   Note, this function is used to inject a space instead of multi-character
   C-comment. Thus there is no boundary checks here (basically, we replace
   N-chars by 1-char here).
*/
gchar *cpp_inject(Lex_input_stream *lip, gchar ch)
{
    *lip->m_cpp_ptr = ch;
    return ++(lip->m_cpp_ptr);
}

/**
   End of file indicator for the query text to parse.
   @return true if there are no more characters to parse
*/

#define eof(lip) (lip->m_ptr >= lip->m_end_of_query)

/*
gboolean eof(Lex_input_stream *lip)
{
    return (lip->m_ptr >= lip->m_end_of_query);
}
*/
/**
   End of file indicator for the query text to parse.
   @param n number of characters expected
   @return true if there are less than n characters to parse
*/
#define eofn(lip,n) ((lip->m_ptr + n) >= lip->m_end_of_query)
/*
gboolean eofn(Lex_input_stream *lip, gint n)
{
    return ((lip->m_ptr + n) >= lip->m_end_of_query);
}
*/
/** Get the raw query buffer. */
const gchar *get_buf(Lex_input_stream *lip)
{
    return lip->m_buf;
}
/** Get the pre-processed query buffer. */

#define get_cpp_buf(lip) (lip->m_cpp_buf)

/*
const gchar *get_cpp_buf(Lex_input_stream *lip)
{
    return lip->m_cpp_buf;
}
*/
/** Get the end of the raw query buffer. */
#define get_end_of_query(lip) (lip->m_end_of_query)
/*
const gchar *get_end_of_query(Lex_input_stream *lip)
{
    return lip->m_end_of_query;
}
*/
/** Mark the stream position as the start of a new token. */


#define start_token(lip) \
{\
    lip->m_tok_start_prev = lip->m_tok_start;\
    lip->m_tok_start = lip->m_ptr;\
    lip->m_tok_end = lip->m_ptr;\
\
    lip->m_cpp_tok_start_prev = lip->m_cpp_tok_start;\
    lip->m_cpp_tok_start = lip->m_cpp_ptr;\
    lip->m_cpp_tok_end = lip->m_cpp_ptr;\
}

/*
void start_token(Lex_input_stream *lip)
{
    lip->m_tok_start_prev = lip->m_tok_start;
    lip->m_tok_start = lip->m_ptr;
    lip->m_tok_end = lip->m_ptr;

    lip->m_cpp_tok_start_prev = lip->m_cpp_tok_start;
    lip->m_cpp_tok_start = lip->m_cpp_ptr;
    lip->m_cpp_tok_end = lip->m_cpp_ptr;
}
*/
/**
   Adjust the starting position of the current token.
   This is used to compensate for starting whitespace.
*/

#define restart_token(lip) \
{\
    lip->m_tok_start = lip->m_ptr;\
    lip->m_cpp_tok_start = lip->m_cpp_ptr;\
}

/*
void restart_token(Lex_input_stream *lip)
{
    lip->m_tok_start = lip->m_ptr;
    lip->m_cpp_tok_start = lip->m_cpp_ptr;
}
*/
/** Get the token start position, in the raw buffer. */
const gchar *get_tok_start(Lex_input_stream *lip)
{
    return lip->m_tok_start;
}
/** Get the token start position, in the pre-processed buffer. */
const gchar *get_cpp_tok_start(Lex_input_stream *lip)
{
    return lip->m_cpp_tok_start;
}
/** Get the token end position, in the raw buffer. */
const gchar *get_tok_end(Lex_input_stream *lip)
{
    return lip->m_tok_end;
}
/** Get the token end position, in the pre-processed buffer. */
const gchar *get_cpp_tok_end(Lex_input_stream *lip)
{
    return lip->m_cpp_tok_end;
}
/** Get the previous token start position, in the raw buffer. */
#define get_tok_start_prev(lip) (lip->m_tok_start_prev)
/*
const gchar *get_tok_start_prev(Lex_input_stream *lip)
{
    return lip->m_tok_start_prev;
}
*/
/** Get the current stream pointer, in the raw buffer. */
#define get_ptr(lip) (lip->m_ptr)
/*
const gchar *get_ptr(Lex_input_stream *lip)
{
    return lip->m_ptr;
}
*/
/** Get the current stream pointer, in the pre-processed buffer. */
#define get_cpp_ptr(lip) (lip->m_cpp_ptr)
/*
const gchar *get_cpp_ptr(Lex_input_stream *lip)
{
    return lip->m_cpp_ptr;
}
*/
/** Get the length of the current token, in the raw buffer. */
#define yyLength(lip) ((guint) ((lip->m_ptr - lip->m_tok_start) - 1))
/*
guint yyLength(Lex_input_stream *lip)
{    
    return (guint) ((lip->m_ptr - lip->m_tok_start) - 1);
}
*/
/** Get the utf8-body string. */
#define get_body_utf8_str(lip) (lip->m_body_utf8)
/*
const gchar *get_body_utf8_str(Lex_input_stream *lip)
{
    return lip->m_body_utf8;
}
*/
/** Get the utf8-body length. */
#define get_body_utf8_length(lip) ((guint) (lip->m_body_utf8_ptr - lip->m_body_utf8))
/*
guint get_body_utf8_length(Lex_input_stream *lip)
{
    return (guint) (lip->m_body_utf8_ptr - lip->m_body_utf8);
}
*/

/**
  Given a stream that is advanced to the first contained character in 
  an open comment, consume the comment.  Optionally, if we are allowed, 
  recurse so that we understand comments within this current comment.

  At this level, we do not support version-condition comments.  We might 
  have been called with having just passed one in the stream, though.  In 
  that case, we probably want to tolerate mundane comments inside.  Thus,
  the case for recursion.

  @retval  Whether EOF reached before comment is closed.
*/
gboolean consume_comment(Lex_input_stream *lip, int remaining_recursions_permitted)
{
    reg1 guchar c;
    while (! eof(lip)) {
//        c = yyGet(lip);
        yyGet(lip,c);

        if (remaining_recursions_permitted > 0) {
            if ((c == '/') && (yyPeek(lip) == '*')) {
                yySkip(lip); /* Eat asterisk */
                consume_comment(lip, remaining_recursions_permitted-1);
                continue;
            }
        }

        if (c == '*') {
            if (yyPeek(lip) == '/') {
                yySkip(lip); /* Eat slash */
                return FALSE;
            }
        }

        if (c == '\n')
            lip->yylineno++;
    }

    return TRUE;
}



/* make a copy of token before ptr and set yytoklen */

static LEX_STRING get_token(Lex_input_stream *lip, guint skip, guint length)
{
    LEX_STRING tmp;
    yyUnget(lip);                       // ptr points now after last token char
    tmp.length = lip->yytoklen=length;
    tmp.str = lexstrmake(lip->m_sqlparselex, get_tok_start(lip) + skip, tmp.length);

    lip->m_cpp_text_start = get_cpp_tok_start(lip) + skip;
    lip->m_cpp_text_end = lip->m_cpp_text_start + tmp.length;

    return tmp;
}

/*
 todo:
   There are no dangerous charsets in mysql for function
   get_quoted_token yet. But it should be fixed in the
   future to operate multichar strings (like ucs2)
*/

static LEX_STRING get_quoted_token(Lex_input_stream *lip,
                                   guint skip, guint length, gchar quote)
{
    LEX_STRING      tmp;
    const gchar    *from, *end;
    gchar          *to;
    yyUnget(lip);                       // ptr points now after last token char
    tmp.length = lip->yytoklen=length;
    tmp.str = (gchar*) lexalloc0(lip->m_sqlparselex, tmp.length+1);
    from = get_tok_start(lip) + skip;
    to = tmp.str;
    end = to+length;

    lip->m_cpp_text_start = get_cpp_tok_start(lip) + skip;
    lip->m_cpp_text_end = lip->m_cpp_text_start + length;

    for ( ; to != end; ) {
        if ((*to++= *from++) == quote) {
            from++;                                   // Skip double quotes
            lip->m_cpp_text_start++;
        }
    }
    *to = 0;                                       // End null for safety
    return tmp;
}


static void body_utf8_append(Lex_input_stream *lip, const gchar *ptr,
                                        const gchar *end_ptr)
{
/*
  DBUG_ASSERT(lip->m_cpp_buf <= ptr && ptr <= lip->m_cpp_buf + lip->m_buf_length);
  DBUG_ASSERT(lip->m_cpp_buf <= end_ptr && end_ptr <= lip->m_cpp_buf + lip->m_buf_length);
*/
    if (!lip->m_body_utf8)
        return;

    if (lip->m_cpp_utf8_processed_ptr >= ptr)
        return;

    int bytes_to_copy = ptr - lip->m_cpp_utf8_processed_ptr;

    memcpy(lip->m_body_utf8_ptr, lip->m_cpp_utf8_processed_ptr, bytes_to_copy);
    lip->m_body_utf8_ptr += bytes_to_copy;
    *lip->m_body_utf8_ptr = 0;

    lip->m_cpp_utf8_processed_ptr = end_ptr;
}


static void body_utf8_append_literal(Lex_input_stream *lip, SQLPARSELEX *sqlparselex,
                                                const LEX_STRING *txt,
                                                const CHARSET_INFO *txt_cs,
                                                const gchar *end_ptr)
{
    if (!lip->m_cpp_utf8_processed_ptr)
        return;

    LEX_STRING utf_txt;

    //todo add mb
    utf_txt.str = txt->str;
    utf_txt.length = txt->length;

    /* NOTE: utf_txt.length is in bytes, not in symbols. */

    memcpy(lip->m_body_utf8_ptr, utf_txt.str, utf_txt.length);
    lip->m_body_utf8_ptr += utf_txt.length;
    *lip->m_body_utf8_ptr = 0;

    lip->m_cpp_utf8_processed_ptr = end_ptr;
}

static void body_utf8_append0(Lex_input_stream *lip, const gchar *ptr)
{
    body_utf8_append(lip, ptr, ptr);
}

static guint int_token(const gchar *str,guint length)
{
    if (length < long_len)      // quick normal case
        return NUM;
    gboolean neg = 0;

    if (*str == '+') {          // Remove sign and pre-zeros
        str++; length--;
    } else if (*str == '-') {
        str++; length--;
        neg = 1;
    }

    while (*str == '0' && length) {
        str++; length --;
    }
    if (length < long_len)
        return NUM;

    uint         smaller,bigger;
    const gchar *cmp;
    if (neg) {
        if (length == long_len) {
            cmp = signed_long_str+1;
            smaller = NUM;                // If <= signed_long_str
            bigger = LONG_NUM;                // If >= signed_long_str
        }
        else if (length < signed_longlong_len)
            return LONG_NUM;
        else if (length > signed_longlong_len)
            return DECIMAL_NUM;
        else {
            cmp = signed_longlong_str+1;
            smaller = LONG_NUM;                // If <= signed_longlong_str
            bigger = DECIMAL_NUM;
        }
    } else {
        if (length == long_len) {
            cmp = long_str;
            smaller = NUM;
            bigger = LONG_NUM;
        } else if (length < longlong_len)
            return LONG_NUM;
        else if (length > longlong_len) {
            if (length > unsigned_longlong_len)
                return DECIMAL_NUM;
                    cmp = unsigned_longlong_str;
            smaller = ULONGLONG_NUM;
            bigger = DECIMAL_NUM;
        } else {
            cmp = longlong_str;
            smaller = LONG_NUM;
            bigger = ULONGLONG_NUM;
        }
    }
    while (*cmp && *cmp++ == *str++) ;
    return ((guchar) str[-1] <= (guchar) cmp[-1]) ? smaller : bigger;
}


/*
  Return an unescaped text literal without quotes
  Fix sometimes to do only one scan of the string
*/

static gchar *get_text(Lex_input_stream *lip, gint pre_skip, gint post_skip)
{
    reg1 guchar c,sep,d;
    guint found_escape=0;

    lip->tok_bitmap= 0;
    sep= yyGetLast(lip);                        // String should end with this
    while (! eof(lip)) {
//        c= yyGet(lip);
        yyGet(lip,c);
        lip->tok_bitmap|= c;

        if (c == '\\' &&
            !(lip->m_sqlparselex->sql_mode & MODE_NO_BACKSLASH_ESCAPES)) {                    
            // Escaped character
            found_escape=1;
            if (eof(lip))
                return 0;
            yySkip(lip);
        } else if (c == sep) {
            yyGet(lip,d);
//            if (c == yyGet(lip)) {            // Check if two separators in a row
            if(c == d) {
                found_escape=1;                 // duplicate. Remember for delete
                continue;
            }
            else
                yyUnget(lip);

            /* Found end. Unescape and return string */
            const gchar *str, *end;
            gchar *start;

            str= get_tok_start(lip);
            end= get_ptr(lip);
            /* Extract the text from the token */
            str += pre_skip;
            end -= post_skip;
            /*      DBUG_ASSERT(end >= str);*/

            if (!(start= (gchar*) lexalloc0(lip->m_sqlparselex, (uint) (end-str)+1)))
                return (gchar*) "";        // Sql_alloc has set error flag

            lip->m_cpp_text_start= get_cpp_tok_start(lip) + pre_skip;
            lip->m_cpp_text_end= get_cpp_ptr(lip) - post_skip;

            if (!found_escape) {
                lip->yytoklen=(uint) (end-str);
                memcpy(start,str,lip->yytoklen);
                start[lip->yytoklen]=0;
            } else {
                gchar *to;

                for (to=start ; str != end ; str++) {
                    if (!(lip->m_sqlparselex->sql_mode 
                        & MODE_NO_BACKSLASH_ESCAPES) && *str == '\\' && str+1 != end) {
                        switch(*++str) {
                            case 'n':
                                *to++='\n';
                                break;

                            case 't':
                                *to++= '\t';
                                break;

                            case 'r':
                                *to++ = '\r';
                                break;

                            case 'b':
                                *to++ = '\b';
                                break;

                            case '0':
                                *to++= 0;            // Ascii null
                                break;

                            case 'Z':            // ^Z must be escaped on Win32
                                *to++='\032';
                                break;

                            case '_':
                            case '%':
                                *to++= '\\';        // remember prefix for wildcard
                                /* Fall through */
                            default:
                                *to++= *str;
                                break;
                        }
                    } else if (*str == sep)
                        *to++= *str++;        // Two ' or "
                    else
                        *to++ = *str;
                }
                *to=0;
                lip->yytoklen=(uint) (to-start);
            }
            return start;
        }
    }
    return 0;                    // unexpected end of query
}


static gint find_keyword(Lex_input_stream *lip, guint len, gboolean function)
{
    const gchar *tok= get_tok_start(lip);

    SYMBOL *symbol= get_hash_symbol(tok, len, function);
    if (symbol) {
        lip->yylval->symbol.symbol=symbol;
        lip->yylval->symbol.str= (char*) tok;
        lip->yylval->symbol.length=len;

        if ((symbol->tok == NOT_SYM) &&
           (lip->m_sqlparselex->sql_mode & MODE_HIGH_NOT_PRECEDENCE))
            return NOT2_SYM;
        if ((symbol->tok == OR_OR_SYM) &&
           !(lip->m_sqlparselex->sql_mode & MODE_PIPES_AS_CONCAT))
            return OR2_SYM;

        return symbol->tok;
    }
    return 0;
}


int proxy_lex(gpointer arg, gpointer inlex)
{
    SQLPARSELEX *sqlparselex= (SQLPARSELEX *)inlex;
    Lex_input_stream *lip= (Lex_input_stream *)sqlparselex->lip;
    YYSTYPE *yylval=(YYSTYPE*) arg;
    gint token;

    if (lip->lookahead_token >= 0) {
        /*
           The next token was already parsed in advance,
           return it.
           */
        token= lip->lookahead_token;
        lip->lookahead_token= -1;
        *yylval= *(lip->lookahead_yylval);
        lip->lookahead_yylval= NULL;
        return token;
    }

    token= lex_one_token(arg, sqlparselex);

    switch(token) {
        case WITH:
            /*
               Parsing 'WITH' 'ROLLUP' or 'WITH' 'CUBE' requires 2 look ups,
               which makes the grammar LALR(2).
               Replace by a single 'WITH_ROLLUP' or 'WITH_CUBE' token,
               to transform the grammar into a LALR(1) grammar,
               which sql_yacc.yy can process.
               */
            token= lex_one_token(arg, sqlparselex);
            switch(token) {
                case CUBE_SYM:
                    return WITH_CUBE_SYM;

                case ROLLUP_SYM:
                    return WITH_ROLLUP_SYM;

                default:
                    /*
                       Save the token following 'WITH'
                       */
                    lip->lookahead_yylval= lip->yylval;
                    lip->yylval= NULL;
                    lip->lookahead_token= token;
                    return WITH;
            }
            break;

        default:
            break;
    }

    return token;
}



int lex_one_token(gpointer arg, gpointer inlex)
{
    reg1    guchar c= 0, mypara = 0, d= 0;
    gboolean comment_closed;
    gint    tokval, result_state;
    guint length;
    enum my_lex_states state;
    SQLPARSELEX *sqlparselex= (SQLPARSELEX *)inlex;
    Lex_input_stream *lip=(Lex_input_stream *)sqlparselex->lip;
    YYSTYPE *yylval=(YYSTYPE*) arg;
    const CHARSET_INFO *cs= sqlparselex->charset;
    guchar *state_map= cs->state_map;
    guchar *ident_map= cs->ident_map;

    lip->yylval=yylval;            // The global state

    start_token(lip);
    state=lip->next_state;
    lip->next_state=MY_LEX_OPERATOR_OR_IDENT;
    for (;;) {
        //printf("current state:%d.\n", state);

        switch (state) {
            case MY_LEX_OPERATOR_OR_IDENT:    // Next is operator or keyword
            case MY_LEX_START:            // Start of token
                // Skip starting whitespace
                while(state_map[c= yyPeek(lip)] == MY_LEX_SKIP) {
                    if (c == '\n')
                        lip->yylineno++;

                    yySkip(lip);
                }

                /* Start of real token */
                restart_token(lip);
                yyGet(lip,c);
                
//                c= yyGet(lip);
                state= (enum my_lex_states) state_map[c];
                break;

            case MY_LEX_ESCAPE:
                yyGet(lip,d);                
                if (d == 'N') {
//				                if (yyGet(lip) == 'N') {
                    // Allow \N as shortcut for NULL
                    yylval->lex_str.str=(char*) "\\N";
                    yylval->lex_str.length=2;
                    return NULL_SYM;
                }

            case MY_LEX_CHAR:            // Unknown or single char token
            case MY_LEX_SKIP:            // This should not happen
                if (c == '-' && yyPeek(lip) == '-' &&
                        (my_isspace(cs,yyPeekn(lip,1)) ||
                         my_iscntrl(cs,yyPeekn(lip,1)))) {
                    state=MY_LEX_COMMENT;
                    break;
                }

                if (c != ')')
                    lip->next_state= MY_LEX_START;    // Allow signed numbers

                if (c == ',') {
                    /*
Warning:
This is a work around, to make the "remember_name" rule in
sql/sql_yacc.yy work properly.
The problem is that, when parsing "select expr1, expr2",
the code generated by bison executes the *pre* action
remember_name (see select_item) *before* actually parsing the
first token of expr2.
*/
                    restart_token(lip);
                } else {
                    /*
          Check for a placeholder: it should not precede a possible identifier
          because of binlogging: when a placeholder is replaced with
          its value in a query for the binlog, the query must stay
          grammatically correct.
        */
                    if (c == '?' && lip->stmt_prepare_mode && !ident_map[yyPeek(lip)])
                        return(PARAM_MARKER);
                }

                return((gint) c);

            case MY_LEX_IDENT_OR_NCHAR:
                if (yyPeek(lip) != '\'') {
                    state= MY_LEX_IDENT;
                    break;
                }
                /* Found N'string' */
                yySkip(lip);                         // Skip '
                if (!(yylval->lex_str.str = get_text(lip, 2, 1))) {
                    state= MY_LEX_CHAR;             // Read char by char
                    break;
                }
                yylval->lex_str.length= lip->yytoklen;
                return(NCHAR_STRING);

            case MY_LEX_IDENT_OR_HEX:
                if (yyPeek(lip) == '\'') {
                    // Found x'hex-number'
                    state= MY_LEX_HEX_NUMBER;
                    break;
                }

            case MY_LEX_IDENT_OR_BIN:
                if (yyPeek(lip) == '\'') {
                    // Found b'bin-number'
                    state= MY_LEX_BIN_NUMBER;
                    break;
                }

            case MY_LEX_IDENT: 
                //todo add mb

//                for (result_state= c; ident_map[c= yyGet(lip)]; result_state|= c) ;
                result_state= c;
                yyGet(lip,c);                
                while( ident_map[c])
                {
                    result_state|= c;
                    yyGet(lip,c);
                }
                /* If there were non-ASCII characters, mark that we must convert */
                result_state= result_state & 0x80 ? IDENT_QUOTED : IDENT;

                gchar *start;                
                length= yyLength(lip);
                start= (gchar *)get_ptr(lip);
                if (lip->ignore_space) {
                    /*
                       If we find a space then this can't be an identifier. We notice this
                       below by checking start != lex->ptr.
                       */
//                    for (; state_map[c] == MY_LEX_SKIP ; c= yyGet(lip)) ;
                    for (; state_map[c] == MY_LEX_SKIP ;)
                    {
                        yyGet(lip,c);
                    } 
                }
                if (start == get_ptr(lip) && c == '.' && ident_map[yyPeek(lip)])
                    lip->next_state=MY_LEX_IDENT_SEP;
                else {                    // '(' must follow directly if function
                    yyUnget(lip);
                    if ((tokval = find_keyword(lip, length, c == '('))) {
                        lip->next_state= MY_LEX_START;    // Allow signed numbers
                        return(tokval);        // Was keyword
                    }
                    yySkip(lip);                  // next state does a unget
                }
                yylval->lex_str=get_token(lip, 0, length);

                /*
Note: "SELECT _bla AS 'alias'"
_bla should be considered as a IDENT if charset haven't been found.
So we don't use MYF(MY_WME) with get_charset_by_csname to avoid
producing an error.
*/

                if (yylval->lex_str.str[0] == '_') {
                    CHARSET_INFO *cs= NULL;      //todo fix me

                    if (cs) {
                        yylval->charset= cs;
                        lip->m_underscore_cs= cs;

                        body_utf8_append(lip,lip->m_cpp_text_start,
                                get_cpp_tok_start(lip) + length);
                        return(UNDERSCORE_CHARSET);
                    }
                }

                body_utf8_append0(lip,lip->m_cpp_text_start);

                body_utf8_append_literal(lip,sqlparselex, &yylval->lex_str, cs,
                        lip->m_cpp_text_end);

                return(result_state);            // IDENT or IDENT_QUOTED


            case MY_LEX_IDENT_SEP:        // Found ident and now '.'
                yylval->lex_str.str= (char*) get_ptr(lip);
                yylval->lex_str.length= 1;
//                c= yyGet(lip);                  // should be '.'
                        yyGet(lip,c);
                
                lip->next_state= MY_LEX_IDENT_START;// Next is an ident (not a keyword)
                if (!ident_map[yyPeek(lip)])            // Probably ` or "
                    lip->next_state= MY_LEX_START;
                return((gint) c);

            case MY_LEX_NUMBER_IDENT:        // number or ident which num-start
                if (yyGetLast(lip) == '0') {
                        yyGet(lip,c);
                    
//                    c= yyGet(lip);
                    if (c == 'x') {
//                        while (my_isxdigit(cs,(c = yyGet(lip)))) ;
                while (1)
                {
                            yyGet(lip,c);
                            if(my_isxdigit(cs, c) == 0)
                                break;
                } 
                        if ((yyLength(lip) >= 3) && !ident_map[c]) {
                            /* skip '0x' */
                            yylval->lex_str=get_token(lip, 2, yyLength(lip)-2);
                            return (HEX_NUM);
                        }
                        yyUnget(lip);
                        state= MY_LEX_IDENT_START;
                        break;
                    } else if (c == 'b') {
//                        while ((c= yyGet(lip)) == '0' || c == '1') ;
                        while (1)
                        {
                            yyGet(lip,c);
                            if(c != '0' && c !='1')
                                break;
                        } ;
                        if ((yyLength(lip) >= 3) && !ident_map[c]) {
                            /* Skip '0b' */
                            yylval->lex_str= get_token(lip, 2, yyLength(lip)-2);
                            return (BIN_NUM);
                        }
                        yyUnget(lip);
                        state= MY_LEX_IDENT_START;
                        break;
                    }
                    yyUnget(lip);
                }

//                while (my_isdigit(cs, (c = yyGet(lip)))) ;
                while (1)
                {
                            yyGet(lip,c);
                            if(my_isdigit(cs, c) == 0)
                                break;
                } 
                if (!ident_map[c]) {                    // Can't be identifier
                    state=MY_LEX_INT_OR_REAL;
                    break;
                }
                if (c == 'e' || c == 'E') {
                    // The following test is written this way to allow numbers of type 1e1
                    yyGet(lip,c);

                    if (my_isdigit(cs,yyPeek(lip)) ||
//                        (c=(yyGet(lip))) == '+' || c == '-') {                // Allow 1E+10
                        (c) == '+' || c == '-') {                // Allow 1E+10
                        if (my_isdigit(cs,yyPeek(lip))) {     // Number must have digit after sign
                            yySkip(lip);
                   //         while (my_isdigit(cs,yyGet(lip))) ;
                            while (1)
                            {
                                yyGet(lip,c);
                                if(my_isdigit(cs, c) == 0)
                                    break;
                            } 
                            yylval->lex_str=get_token(lip, 0, yyLength(lip));
                            return(FLOAT_NUM);
                        }
                    }
                    yyUnget(lip);
                }
                // fall through
            case MY_LEX_IDENT_START:            // We come here after '.'
                result_state= IDENT;
                // todo add mb
                //for (result_state=0; ident_map[c= yyGet(lip)]; result_state|= c) ;
                result_state= 0;
                yyGet(lip,c);                
                while( ident_map[c])
                {
                    result_state|= c;
                    yyGet(lip,c);
                }
                /* If there were non-ASCII characters, mark that we must convert */
                result_state= result_state & 0x80 ? IDENT_QUOTED : IDENT;
                if (c == '.' && ident_map[yyPeek(lip)])
                    lip->next_state=MY_LEX_IDENT_SEP;// Next is '.'

                yylval->lex_str= get_token(lip, 0, yyLength(lip));

                body_utf8_append0(lip,lip->m_cpp_text_start);

                body_utf8_append_literal(lip,sqlparselex, &yylval->lex_str, cs,
                        lip->m_cpp_text_end);

                return(result_state);

            case MY_LEX_USER_VARIABLE_DELIMITER:    // Found quote char
                mypara = 0;
                guint double_quotes= 0;
                gchar quote_char= c;                       // Used char
                for(;;) {
//                    c= yyGet(lip);
                yyGet(lip,c) ;               
                   
                    if (c == 0) {
                        yyUnget(lip);
                        return ABORT_SYM;                     // Unmatched quotes
                    }

                    //todo add mb
                    if (c == quote_char) {
                        if (yyPeek(lip) != quote_char)
                            break;
//                        c=yyGet(lip);
                yyGet(lip,c) ;               
                        
                        double_quotes++;
                        continue;
                    }

                    //todo add mb
                }
                if (double_quotes)
                    yylval->lex_str=get_quoted_token(lip, 1,
                                    yyLength(lip) - double_quotes -1, quote_char);
                else
                    yylval->lex_str=get_token(lip, 1, yyLength(lip) -1);
                if (c == quote_char)
                    yySkip(lip);                  // Skip end `
                lip->next_state= MY_LEX_START;

                body_utf8_append0(lip,lip->m_cpp_text_start);

                body_utf8_append_literal(lip,sqlparselex, &yylval->lex_str, cs,
                        lip->m_cpp_text_end);

                return(IDENT_QUOTED);

            case MY_LEX_INT_OR_REAL:        // Complete int or incomplete real
                if (c != '.') {                    // Found complete integer number.
                    yylval->lex_str=get_token(lip, 0, yyLength(lip));
                    return int_token(yylval->lex_str.str, (uint) yylval->lex_str.length);
                }

                // fall through
            case MY_LEX_REAL:            // Incomplete real number
//                while (my_isdigit(cs,c = yyGet(lip))) ;
                            while (1)
                            {
                                yyGet(lip,c);
                                if(my_isdigit(cs, c) == 0)
                                    break;
                            } ;
                if (c == 'e' || c == 'E') {
//                    c = yyGet(lip);
                yyGet(lip,c)   ;             
                    
                    if (c == '-' || c == '+')
                yyGet(lip,c) ;               
//                        c = yyGet(lip);                     // Skip sign
                    if (!my_isdigit(cs,c)) {                // No digit after sign
                        state= MY_LEX_CHAR;
                        break;
                    }
//                    while (my_isdigit(cs,yyGet(lip))) ;
                                            while (1)
                            {
                                yyGet(lip,c);
                                if(my_isdigit(cs, c) == 0)
                                    break;
                            } 
                    yylval->lex_str=get_token(lip, 0, yyLength(lip));
                    return(FLOAT_NUM);
                }
                yylval->lex_str=get_token(lip, 0, yyLength(lip));
                return(DECIMAL_NUM);

            case MY_LEX_HEX_NUMBER:        // Found x'hexstring'
                yySkip(lip);                    // Accept opening '
//                while (my_isxdigit(cs, (c= yyGet(lip)))) ;
                           while (1)
                            {
                                yyGet(lip,c);
                                if(my_isxdigit(cs, c) == 0)
                                    break;
                            } 
                if (c != '\'')
                    return(ABORT_SYM);              // Illegal hex constant
                yySkip(lip);                    // Accept closing '
                length= yyLength(lip);          // Length of hexnum+3
                if ((length % 2) == 0)
                    return(ABORT_SYM);              // odd number of hex digits
                yylval->lex_str=get_token(lip,
                        2,          // skip x'
                        length-3);  // don't count x' and last '
                return (HEX_NUM);

            case MY_LEX_BIN_NUMBER:           // Found b'bin-string'
                yySkip(lip);                  // Accept opening '
//                while ((c= yyGet(lip)) == '0' || c == '1') ;
                  while (1)
                        {
                            yyGet(lip,c);
                            if(c != '0' && c !='1')
                                break;
                        } 
                if (c != '\'')
                    return(ABORT_SYM);            // Illegal hex constant
                yySkip(lip);                  // Accept closing '
                length= yyLength(lip);        // Length of bin-num + 3
                yylval->lex_str= get_token(lip,
                                 2,         // skip b'
                                 length-3); // don't count b' and last '
                return (BIN_NUM);

            case MY_LEX_CMP_OP:            // Incomplete comparison operator
                if (state_map[yyPeek(lip)] == MY_LEX_CMP_OP ||
                        state_map[yyPeek(lip)] == MY_LEX_LONG_CMP_OP)
                    yySkip(lip);
                if ((tokval = find_keyword(lip, yyLength(lip) + 1, 0))) {
                    lip->next_state= MY_LEX_START;    // Allow signed numbers
                    return(tokval);
                }
                state = MY_LEX_CHAR;        // Something fishy found
                break;

            case MY_LEX_LONG_CMP_OP:        // Incomplete comparison operator
                if (state_map[yyPeek(lip)] == MY_LEX_CMP_OP ||
                        state_map[yyPeek(lip)] == MY_LEX_LONG_CMP_OP) {
                    yySkip(lip);
                    if (state_map[yyPeek(lip)] == MY_LEX_CMP_OP)
                        yySkip(lip);
                }
                if ((tokval = find_keyword(lip, yyLength(lip) + 1, 0))) {
                    lip->next_state= MY_LEX_START;    // Found long op
                    return(tokval);
                }
                state = MY_LEX_CHAR;        // Something fishy found
                break;

            case MY_LEX_BOOL:
                if (c != yyPeek(lip)) {
                    state=MY_LEX_CHAR;
                    break;
                }
                yySkip(lip);
                tokval = find_keyword(lip,2,0);    // Is a bool operator
                lip->next_state= MY_LEX_START;    // Allow signed numbers
                return(tokval);

            case MY_LEX_STRING_OR_DELIMITER:
                if (sqlparselex->sql_mode & MODE_ANSI_QUOTES) {
                    state= MY_LEX_USER_VARIABLE_DELIMITER;
                    break;
                }

                /* " used for strings */
            case MY_LEX_STRING:            // Incomplete text string
                if (!(yylval->lex_str.str = get_text(lip, 1, 1))) {
                    state= MY_LEX_CHAR;        // Read char by char
                    break;
                }
                yylval->lex_str.length=lip->yytoklen;

                body_utf8_append0(lip,lip->m_cpp_text_start);

                body_utf8_append_literal(lip,sqlparselex, &yylval->lex_str,
                        lip->m_underscore_cs ? lip->m_underscore_cs : cs,
                        lip->m_cpp_text_end);

                lip->m_underscore_cs= NULL;

                return(TEXT_STRING);

            case MY_LEX_COMMENT:            //  Comment
//                while ((c = yyGet(lip)) != '\n' && c) ;
                        while (1)
                        {
                            yyGet(lip,c);
                            if(c == '\n' || c == 0)
                                break;
                        } 
                yyUnget(lip);                   // Safety against eof
                state = MY_LEX_START;        // Try again
                break;
            case MY_LEX_LONG_COMMENT:        /* Long C comment? */
                if (yyPeek(lip) != '*') {
                    state=MY_LEX_CHAR;        // Probable division
                    break;
                }
                /* Reject '/' '*', since we might need to turn off the echo */
                yyUnget(lip);

                save_in_comment_state(lip);

                if (yyPeekn(lip,2) == '!') {
                    lip->in_comment= DISCARD_COMMENT;
                    /* Accept '/' '*' '!', but do not keep this marker. */
                    set_echo(lip,FALSE);
                    yySkip(lip);
                    yySkip(lip);
                    yySkip(lip);

                    /*
                       The special comment format is very strict:
                       '/' '*' '!', followed by exactly
                       1 digit (major), 2 digits (minor), then 2 digits (dot).
                       32302 -> 3.23.02
                       50032 -> 5.0.32
                       50114 -> 5.1.14
                       */
                    gchar version_str[6];
                    version_str[0]= yyPeekn(lip,0);
                    version_str[1]= yyPeekn(lip,1);
                    version_str[2]= yyPeekn(lip,2);
                    version_str[3]= yyPeekn(lip,3);
                    version_str[4]= yyPeekn(lip,4);
                    version_str[5]= 0;
                    if (my_isdigit(cs, version_str[0])
                        && my_isdigit(cs, version_str[1])
                        && my_isdigit(cs, version_str[2])
                        && my_isdigit(cs, version_str[3])
                        && my_isdigit(cs, version_str[4])) {

                        gulong version;
                        version=strtol(version_str, NULL, 10);

                        if (version <= MYSQL_VERSION_ID) {
                            /* Accept 'M' 'm' 'm' 'd' 'd' */
                            yySkipn(lip,5);
                            /* Expand the content of the special comment as real code */
                            set_echo(lip,TRUE);
                            state=MY_LEX_START;
                            break;  /* Do not treat contents as a comment.  */
                        } else {
                            /*
                               Patch and skip the conditional comment to avoid it
                               being propagated infinitely (eg. to a slave).
                               */
                            gchar *pcom= yyUnput(lip,' ');
                            comment_closed= ! consume_comment(lip, 1);
                            if (! comment_closed) {
                                *pcom= '!';
                            }
                            /* version allowed to have one level of comment inside. */
                        }
                    } else {
                        /* Not a version comment. */
                        state=MY_LEX_START;
                        set_echo(lip,TRUE);
                        break;
                    }
                } else {
                    lip->in_comment= PRESERVE_COMMENT;
                    yySkip(lip);                  // Accept /
                    yySkip(lip);                  // Accept *
                    comment_closed= ! consume_comment(lip, 0);
                    /* regular comments can have zero comments inside. */
                }
                /*
Discard:
- regular '/' '*' comments,
- special comments '/' '*' '!' for a future version,
by scanning until we find a closing '*' '/' marker.

Nesting regular comments isn't allowed.  The first 
'*' '/' returns the parser to the previous state.

/#!VERSI oned containing /# regular #/ is allowed #/

Inside one versioned comment, another versioned comment
is treated as a regular discardable comment.  It gets
no special parsing.
*/

                /* Unbalanced comments with a missing '*' '/' are a syntax error */
                if (! comment_closed)
                    return (ABORT_SYM);
                state = MY_LEX_START;             // Try again
                restore_in_comment_state(lip);
                break;
            case MY_LEX_END_LONG_COMMENT:
                if ((lip->in_comment != NO_COMMENT) && yyPeek(lip) == '/') {
                    /* Reject '*' '/' */
                    yyUnget(lip);
                    /* Accept '*' '/', with the proper echo */
                    set_echo(lip,lip->in_comment == PRESERVE_COMMENT);
                    yySkipn(lip,2);
                    /* And start recording the tokens again */
                    set_echo(lip,TRUE);

                    /*
                       C-style comments are replaced with a single space (as it
                       is in C and C++).  If there is already a whitespace 
                       character at this point in the stream, the space is
                       not inserted.

                       See also ISO/IEC 9899:1999 5.1.1.2  
                       ("Programming languages C")
                       */
                    if (!my_isspace(cs, yyPeek(lip)) &&
                            get_cpp_ptr(lip) != get_cpp_buf(lip) &&
                            !my_isspace(cs, *(get_cpp_ptr(lip) - 1)))
                        cpp_inject(lip,' ');

                    lip->in_comment=NO_COMMENT;
                    state=MY_LEX_START;
                }
                else
                    state=MY_LEX_CHAR;        // Return '*'
                break;

            case MY_LEX_SET_VAR:        // Check if ':='
                if (yyPeek(lip) != '=') {
                    state=MY_LEX_CHAR;        // Return ':'
                    break;
                }
                yySkip(lip);
                return (SET_VAR);

            case MY_LEX_SEMICOLON:            // optional line terminator
                state= MY_LEX_CHAR;               // Return ';'
                break;

            case MY_LEX_EOL:
                if (eof(lip)) {
                    yyUnget(lip);                 // Reject the last '\0'
                    set_echo(lip,FALSE);
                    yySkip(lip);
                    set_echo(lip,TRUE);
                    /* Unbalanced comments with a missing '*' '/' are a syntax error */
                    if (lip->in_comment != NO_COMMENT)
                        return (ABORT_SYM);
                    lip->next_state=MY_LEX_END;     // Mark for next loop
                    return(END_OF_INPUT);
                }
                state=MY_LEX_CHAR;
                break;
            case MY_LEX_END:
                lip->next_state=MY_LEX_END;
                return(0);            // We found end of input last time

                /* Actually real shouldn't start with . but allow them anyhow */
            case MY_LEX_REAL_OR_POINT:
                if (my_isdigit(cs,yyPeek(lip)))
                    state = MY_LEX_REAL;        // Real
                else {
                    state= MY_LEX_IDENT_SEP;    // return '.'
                    yyUnget(lip);                 // Put back '.'
                }
                break;

            case MY_LEX_USER_END:        // end '@' of user@hostname
                switch (state_map[yyPeek(lip)]) {
                    case MY_LEX_STRING:
                    case MY_LEX_USER_VARIABLE_DELIMITER:
                    case MY_LEX_STRING_OR_DELIMITER:
                        break;

                    case MY_LEX_USER_END:
                        lip->next_state=MY_LEX_SYSTEM_VAR;
                        break;

                    default:
                        lip->next_state=MY_LEX_HOSTNAME;
                        break;
                }
                yylval->lex_str.str=(char*) get_ptr(lip);
                yylval->lex_str.length=1;
                return((int) '@');

            case MY_LEX_HOSTNAME:        // end '@' of user@hostname
//                for (c=yyGet(lip) ;
//                        my_isalnum(cs,c) || c == '.' || c == '_' ||  c == '$';
//                        c= yyGet(lip)) ;
                yyGet(lip,c);
                for ( ;
                        my_isalnum(cs,c) || c == '.' || c == '_' ||  c == '$';
                       ) 
                {
                yyGet(lip,c);
                    
                }
                yylval->lex_str=get_token(lip, 0, yyLength(lip));
                return(LEX_HOSTNAME);

            case MY_LEX_SYSTEM_VAR:
                yylval->lex_str.str=(char*) get_ptr(lip);
                yylval->lex_str.length=1;
                yySkip(lip);                                    // Skip '@'
                lip->next_state= (state_map[yyPeek(lip)] ==
                        MY_LEX_USER_VARIABLE_DELIMITER ?
                        MY_LEX_OPERATOR_OR_IDENT :
                        MY_LEX_IDENT_OR_KEYWORD);
                return((int) '@');

            case MY_LEX_IDENT_OR_KEYWORD:
                /*
                   We come here when we have found two '@' in a row.
                   We should now be able to handle:
                   [(global | local | session) .]variable_name
                   */

//                for (result_state= 0; ident_map[c= yyGet(lip)]; result_state|= c) ;
                                result_state= 0;
                yyGet(lip,c) ;               
                while( ident_map[c])
                {
                    result_state|= c;
                    yyGet(lip,c);
                }
                /* If there were non-ASCII characters, mark that we must convert */
                result_state= result_state & 0x80 ? IDENT_QUOTED : IDENT;

                if (c == '.')
                    lip->next_state=MY_LEX_IDENT_SEP;
                length= yyLength(lip);
                if (length == 0)
                    return(ABORT_SYM);              // Names must be nonempty.
                if ((tokval= find_keyword(lip, length,0))) {
                    yyUnget(lip);                         // Put back 'c'
                    return(tokval);                // Was keyword
                }
                yylval->lex_str=get_token(lip, 0, length);

                body_utf8_append0(lip,lip->m_cpp_text_start);

                body_utf8_append_literal(lip,sqlparselex, &yylval->lex_str, cs,
                        lip->m_cpp_text_end);

                return(result_state);
        }
    }
}


gint parse_init(SQLPARSELEX *parse_lex, gchar *csname)
{
    parse_lex->sql_mem_root = ut_new(mem_root_t,1);
    if(parse_lex->sql_mem_root == NULL){
        return -1;
    }

    parse_lex->lip = ut_new(Lex_input_stream,1);
    if(parse_lex->lip == NULL){
        return -1;
    }
    mem_alloc_init(parse_lex->sql_mem_root, PARSE_MEM_SIZE);

    parse_lex->sql_paramnum = 0;
    parse_lex->sql_mode = 0;

    if(find_charset(csname,&parse_lex->charset))
        return -1;
  


    return 0;
}

gint parse_sql(SQLPARSELEX *parse_lex, gchar *input, guint inlen)
{

    init((parse_lex->lip), parse_lex, input, inlen);
    if(parse_selinit(&(parse_lex->sql_sellist.head), parse_lex))
        return -1;

    fieldprealloc(parse_lex);
    
    parse_lex->sql_sellist.tail = parse_lex->sql_sellist.head;
    parse_lex->sql_cursel = parse_lex->sql_sellist.head; 
    
    if(proxy_parse(parse_lex))
        return -1;

    return 0;
}

gint parse_selinit(SQLPARSESEL **sel ,SQLPARSELEX *parse_lex)
{
    (*sel) = (SQLPARSESEL *)lexalloc0(parse_lex, sizeof(SQLPARSESEL));
    if(*sel == NULL) {
        return -1;
    }
        
    (*sel)->sql_locktp = TL_IGNORE;
    (*sel)->sql_txisolation = ISO_REPEATABLE_READ;

    return 0;
}

gint parse_reset(SQLPARSELEX *parse_lex)
{
    mem_free_blocks(parse_lex->sql_mem_root);

    parse_lex->sql_paramnum = 0;
    parse_lex->sql_mode = 0;

    parse_lex->sql_sellist.head = NULL;
    parse_lex->sql_sellist.tail = NULL;
    parse_lex->sql_cursel = NULL;

    return 0;
}

gint parse_free(SQLPARSELEX *parse_lex)
{

    mem_free_root(parse_lex->sql_mem_root);

    ut_free(parse_lex->lip);
    ut_free(parse_lex->sql_mem_root);
    
    return 0;
}
