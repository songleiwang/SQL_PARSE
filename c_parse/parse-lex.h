#ifndef SQL_LEX_INCLUDED
#define SQL_LEX_INCLUDED

#include <string.h>
#include <stdio.h>
#include <stdarg.h> 

#include "parse-struct.h"
#include "parse-yacc.h"
#include "util-mem.h"
#include "parse.h"

#define reg1 register

#define MY_CS_PRIMARY    32     /* if primary collation           */

#define MYSQL_VERSION_ID        50619

#define MODE_PIPES_AS_CONCAT            2
#define MODE_ANSI_QUOTES                4
#define MODE_IGNORE_SPACE               8
#define MODE_NO_BACKSLASH_ESCAPES       (65536L << 4)
#define MODE_HIGH_NOT_PRECEDENCE        (65536L << 8) //todo fix me

#define    _MY_U    01    /* Upper case */
#define    _MY_L    02    /* Lower case */
#define    _MY_NMR    04    /* Numeral (digit) */
#define    _MY_SPC    010    /* Spacing character */
#define    _MY_PNT    020    /* Punctuation */
#define    _MY_CTR    040    /* Control character */
#define    _MY_B    0100    /* Blank */
#define    _MY_X    0200    /* heXadecimal digit */

#define    my_tocntrl(c)    ((c) & 31)
#define    my_isspace(s, c)  (((s)->ctype+1)[(guchar) (c)] & _MY_SPC)
#define    my_isalnum(s, c)  (((s)->ctype+1)[(guchar) (c)] & (_MY_U | _MY_L | _MY_NMR))
#define    my_isdigit(s, c)  (((s)->ctype+1)[(guchar) (c)] & _MY_NMR)
#define    my_isxdigit(s, c) (((s)->ctype+1)[(guchar) (c)] & _MY_X)
#define    my_iscntrl(s, c)  (((s)->ctype+1)[(guchar) (c)] & _MY_CTR)
#define    my_isalpha(s, c)  (((s)->ctype+1)[(guchar) (c)] & (_MY_U | _MY_L))

#define MY_TEST(a)        ((a) ? 1 : 0)
#define uint4korr(A)    (guint32) (*((guint32 *) (A)))

#define HA_LEX_CREATE_TMP_TABLE	1
#define HA_LEX_CREATE_IF_NOT_EXISTS 2
#define HA_LEX_CREATE_TABLE_LIKE 4
#define HA_OPTION_NO_CHECKSUM	(1L << 17)
#define HA_OPTION_NO_DELAY_KEY_WRITE (1L << 18)
#define HA_MAX_REC_LENGTH	65535U

#define PARSE_MEM_SIZE           100*1024
#define PARSE_PREALLOC_FILED     100

//todo fix me
//typedef unsigned int uint;

extern const LEX_STRING null_lex_str;
extern const LEX_STRING empty_lex_str;
extern const LEX_STRING all_lex_str;
extern const LEX_STRING curuser_lex_str;
extern const LEX_STRING param_lex_str;
extern const LEX_STRING default_lex_str;
extern const LEX_STRING on_lex_str;
extern const LEX_STRING sall_lex_str;
extern const LEX_STRING binary_lex_str;

extern guchar to_upper_lex[];

enum my_lex_states
{
    MY_LEX_START, MY_LEX_CHAR, MY_LEX_IDENT, 
    MY_LEX_IDENT_SEP, MY_LEX_IDENT_START,
    MY_LEX_REAL, MY_LEX_HEX_NUMBER, MY_LEX_BIN_NUMBER,
    MY_LEX_CMP_OP, MY_LEX_LONG_CMP_OP, MY_LEX_STRING, MY_LEX_COMMENT, MY_LEX_END,
    MY_LEX_OPERATOR_OR_IDENT, MY_LEX_NUMBER_IDENT, MY_LEX_INT_OR_REAL,
    MY_LEX_REAL_OR_POINT, MY_LEX_BOOL, MY_LEX_EOL, MY_LEX_ESCAPE, 
    MY_LEX_LONG_COMMENT, MY_LEX_END_LONG_COMMENT, MY_LEX_SEMICOLON, 
    MY_LEX_SET_VAR, MY_LEX_USER_END, MY_LEX_HOSTNAME, MY_LEX_SKIP, 
    MY_LEX_USER_VARIABLE_DELIMITER, MY_LEX_SYSTEM_VAR,
    MY_LEX_IDENT_OR_KEYWORD,
    MY_LEX_IDENT_OR_HEX, MY_LEX_IDENT_OR_BIN, MY_LEX_IDENT_OR_NCHAR,
    MY_LEX_STRING_OR_DELIMITER
};


/**
  The state of the lexical parser, when parsing comments.
  */
enum enum_comment_state
{
    NO_COMMENT,
    PRESERVE_COMMENT,
    DISCARD_COMMENT
};


typedef struct lex_input_stream Lex_input_stream;


struct lex_input_stream
{

    struct sqlparselex_t   *m_sqlparselex;
    guint                   yylineno;
    guint                   yytoklen;

    YYSTYPE                *yylval;
    gint                    lookahead_token;
    YYSTYPE                *lookahead_yylval;

    gchar                  *m_ptr;
    const gchar            *m_tok_start;
    const gchar            *m_tok_end;
    const gchar            *m_end_of_query;
    const gchar            *m_tok_start_prev;
    const gchar            *m_buf;
    guint                   m_buf_length;
    gboolean                m_echo;
    gboolean                m_echo_saved;

    gchar                  *m_cpp_buf;
    gchar                  *m_cpp_ptr;

    const gchar            *m_cpp_tok_start;
    const gchar            *m_cpp_tok_start_prev;
    const gchar            *m_cpp_tok_end;
    gchar                  *m_body_utf8;

    gchar                  *m_body_utf8_ptr;
    const gchar            *m_cpp_utf8_processed_ptr;
    enum my_lex_states      next_state;
    const gchar            *found_semicolon;
    guchar                  tok_bitmap;
    gboolean                ignore_space;
    gboolean                stmt_prepare_mode;
    gboolean                multi_statements;
    enum enum_comment_state in_comment;
    enum enum_comment_state in_comment_saved;

    const gchar            *m_cpp_text_start;
    const gchar            *m_cpp_text_end;
    struct charset_info    *m_underscore_cs;
};



/*lex Ïà¹Ø²Ù×÷*/
void restart_token(Lex_input_stream *lip);

void reset(Lex_input_stream *lip, gchar *buff, guint length);
gboolean init(Lex_input_stream *lip, SQLPARSELEX *sqlparselex, gchar* buff, guint length); 

void *lexalloc(SQLPARSELEX *sqlparselex, gsize length);
void *lexalloc0(SQLPARSELEX *sqlparselex, gsize length);

gchar *lexstrmake(SQLPARSELEX *sqlparselex, const gchar *str, gsize length);

void *fieldalloc(SQLPARSELEX *sqlparselex);

void *fieldstring(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table, LEX_STRING field_name);
void *fieldcolumn(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table, LEX_STRING field_name);
void *fieldtable(SQLPARSELEX *sqlparselex, gchar *field_db, gchar *field_table);
void *fieldsp(SQLPARSELEX *sqlparselex, gchar *field_db, LEX_STRING field_name);

void *fieldappend(SQLPARSELEX *sqlparselex, PARSEFIELD *field, LEX_STRING append);
void *fieldvariable(SQLPARSELEX *sqlparselex, LEX_STRING field_var_nm, enum enum_var_type vartype);
void *fieldparam(SQLPARSELEX *sqlparselex,  gint offset);
void *fieldflist(SQLPARSELEX *sqlparselex, PARSEFLIST flist);


void *fieldnum(SQLPARSELEX *sqlparselex, LEX_STRING field_value);
void *fieldva(SQLPARSELEX *sqlparselex, enum enum_field_type optype, gint arg_num, ...);
void *fieldneg(SQLPARSELEX *sqlparselex, enum enum_field_type optype, PARSEFIELD *arg_field);
void *fieldoprate(SQLPARSELEX *sqlparselex, enum enum_field_type optype, gchar *op, 
                  PARSEFIELD *arg_field1,PARSEFIELD *arg_field2);
void *fieldnot(SQLPARSELEX *sqlparselex, PARSEFIELD *arg_field);
void *fieldjoin(SQLPARSELEX *sqlparselex, enum join_type join_type,PARSEFIELD *arg_field1, PARSEFIELD *arg_field2);
void *fieldsubsel(SQLPARSELEX *sqlparselex, SQLPARSESEL *subsel);




void *fieldf(SQLPARSELEX *sqlparselex, enum enum_field_type optype);
void *fieldfuser(SQLPARSELEX *sqlparselex, enum enum_field_type optype);
void *fieldfone(SQLPARSELEX *sqlparselex, enum enum_field_type optype, PARSEFIELD *arg_field);

void addarg(PARSEFIELD *field, PARSEFIELD *arg_field);
void addarglist(PARSEFIELD *field, PARSEFLIST *arg_list);


void parseaddlist(PARSEFLIST *parselist, PARSEFIELD *field);

void parseaddset(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddupfield(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddfield(SQLPARSESEL *sqlparselex, PARSEFIELD *field);
void parseaddparam(SQLPARSESEL *sqlparselex, PARSEFIELD *field);
void parseaddorder(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddgroup(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddindexhint(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddtable(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);
void parseaddfromtable(SQLPARSESEL *sqlparsesel, PARSEFIELD *field);

void parseaddvalue(SQLPARSESEL *sqlparsesel, PARSEFLIST *fieldlist);





gint lex_casecmp(const gchar *s, const gchar *t, guint len);
gint lex_one_token(gpointer arg, gpointer sqlparselex);
gchar *thd_strmake(SQLPARSELEX *sqlparselex, const gchar *str, gsize size);



void set_echo(Lex_input_stream *lip, gboolean echo);
void save_in_comment_state(Lex_input_stream *lip);
void restore_in_comment_state(Lex_input_stream *lip);
void skip_binary(Lex_input_stream *lip, gint n);

guchar yyGet(Lex_input_stream *lip);
guchar yyGetLast(Lex_input_stream *lip);
guchar yyPeek(Lex_input_stream *lip);
guchar yyPeekn(Lex_input_stream *lip, gint n);
void yyUnget(Lex_input_stream *lip);
void yySkip(Lex_input_stream *lip);
void yySkipn(Lex_input_stream *lip, gint n);
gchar *yyUnput(Lex_input_stream *lip, gchar ch);
guint yyLength(Lex_input_stream *lip);


gchar *cpp_inject(Lex_input_stream *lip, gchar ch);
gboolean eof(Lex_input_stream *lip);
gboolean eofn(Lex_input_stream *lip, gint n);

const gchar *get_buf(Lex_input_stream *lip);
const gchar *get_cpp_buf(Lex_input_stream *lip);
const gchar *get_end_of_query(Lex_input_stream *lip);

const gchar *get_tok_start(Lex_input_stream *lip);
const gchar *get_cpp_tok_start(Lex_input_stream *lip);
const gchar *get_tok_end(Lex_input_stream *lip);
const gchar *get_cpp_tok_end(Lex_input_stream *lip);
const gchar *get_tok_start_prev(Lex_input_stream *lip);
const gchar *get_ptr(Lex_input_stream *lip);
const gchar *get_cpp_ptr(Lex_input_stream *lip);


const gchar *get_body_utf8_str(Lex_input_stream *lip);
guint get_body_utf8_length(Lex_input_stream *lip);
gboolean consume_comment(Lex_input_stream *lip, int remaining_recursions_permitted);

gint proxy_lex(gpointer arg, gpointer inlex);


#define SELECT_DISTINCT         (1ULL << 0)     // SELECT, user
#define SELECT_STRAIGHT_JOIN    (1ULL << 1)     // SELECT, user
#define SELECT_DESCRIBE         (1ULL << 2)     // SELECT, user
#define SELECT_SMALL_RESULT     (1ULL << 3)     // SELECT, user
#define SELECT_BIG_RESULT       (1ULL << 4)     // SELECT, user
#define OPTION_FOUND_ROWS       (1ULL << 5)     // SELECT, user
#define OPTION_TO_QUERY_CACHE   (1ULL << 6)     // SELECT, user
#define SELECT_NO_JOIN_CACHE    (1ULL << 7)     // intern
#define OPTION_AUTOCOMMIT       (1ULL << 8)    // THD, user
#define OPTION_BIG_SELECTS      (1ULL << 9)     // THD, user
#define OPTION_LOG_OFF          (1ULL << 10)    // THD, user
#define OPTION_QUOTE_SHOW_CREATE (1ULL << 11)   // THD, user, unused
#define TMP_TABLE_ALL_COLUMNS   (1ULL << 12)    // SELECT, intern
#define OPTION_WARNINGS         (1ULL << 13)    // THD, user
#define OPTION_AUTO_IS_NULL     (1ULL << 14)    // THD, user, binlog
#define OPTION_FOUND_COMMENT    (1ULL << 15)    // SELECT, intern, parser
#define OPTION_SAFE_UPDATES     (1ULL << 16)    // THD, user
#define OPTION_BUFFER_RESULT    (1ULL << 17)    // SELECT, user
#define OPTION_BIN_LOG          (1ULL << 18)    // THD, user
#define OPTION_NOT_AUTOCOMMIT   (1ULL << 19)    // THD, user
#define OPTION_BEGIN            (1ULL << 20)    // THD, intern
#define OPTION_TABLE_LOCK       (1ULL << 21)    // THD, intern
#define OPTION_QUICK            (1ULL << 22)    // SELECT (for DELETE)
#define SELECT_ALL              (1ULL << 24)    // SELECT, user, parser
#define OPTION_NO_FOREIGN_KEY_CHECKS    (1ULL << 26) // THD, user, binlog
#define OPTION_RELAXED_UNIQUE_CHECKS    (1ULL << 27) // THD, user, binlog
#define SELECT_NO_UNLOCK                (1ULL << 28) // SELECT, intern
#define OPTION_SCHEMA_TABLE             (1ULL << 29) // SELECT, intern
#define OPTION_SETUP_TABLES_DONE        (1ULL << 30) // intern
#define OPTION_SQL_NOTES                (1ULL << 31) // THD, user
#define TMP_TABLE_FORCE_MYISAM          (1ULL << 32)
#define OPTION_PROFILING                (1ULL << 33)
#define SELECT_HIGH_PRIORITY            (1ULL << 34)     // SELECT, user
#define OPTION_MASTER_SQL_ERROR (1ULL << 35)
#define OPTION_ALLOW_BATCH              (ULL(1) << 36) // THD, intern (slave)


#define PROFILE_NONE         (uint)0
#define PROFILE_CPU          (guint)(1<<0)
#define PROFILE_MEMORY       (guint)(1<<1)
#define PROFILE_BLOCK_IO     (guint)(1<<2)
#define PROFILE_CONTEXT      (guint)(1<<3)
#define PROFILE_PAGE_FAULTS  (guint)(1<<4)
#define PROFILE_IPC          (guint)(1<<5)
#define PROFILE_SWAPS        (guint)(1<<6)
#define PROFILE_SOURCE       (guint)(1<<16)
#define PROFILE_ALL          (guint)(~0)

gint proxy_parse(gpointer inlex);
gint parse_selinit(SQLPARSESEL **sel ,SQLPARSELEX *parse_lex);


#endif



