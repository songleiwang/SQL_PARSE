#include "parse-charset.h"
#include "util-alloc.h"

static CHARSET_INFO *all_charsets[MY_ALL_CHARSETS_SIZE]={NULL};

static unsigned long lfactor[9]=
{
  1L, 10L, 100L, 1000L, 10000L, 100000L, 1000000L, 10000000L, 100000000L
};

guchar to_upper_lex[] =
{
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
    64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
    96, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,123,124,125,126,127,
    128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
    144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
    160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
    176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
    192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
    208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
    192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
    208,209,210,211,212,213,214,247,216,217,218,219,220,221,222,255
};


guchar to_lower_lex[] =
{
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
    64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
    112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95,
    96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
    112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
    128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
    144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
    160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
    176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
    192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
    208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
    192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
    208,209,210,211,212,213,214,247,216,217,218,219,220,221,222,255
};

static guchar ctype_utf8[] = {
    0,
   32, 32, 32, 32, 32, 32, 32, 32, 32, 40, 40, 40, 40, 40, 32, 32,
   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
   72, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
  132,132,132,132,132,132,132,132,132,132, 16, 16, 16, 16, 16, 16,
   16,129,129,129,129,129,129,  1,  1,  1,  1,  1,  1,  1,  1,  1,
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, 16, 16, 16, 16, 16,
   16,130,130,130,130,130,130,  2,  2,  2,  2,  2,  2,  2,  2,  2,
    2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2, 16, 16, 16, 16, 32,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,
    3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  0
};

static guchar ctype_gbk[257] =
{
  0,			
  32,32,32,32,32,32,32,32,32,40,40,40,40,40,32,32,
  32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,
  72,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
  132,132,132,132,132,132,132,132,132,132,16,16,16,16,16,16,
  16,129,129,129,129,129,129,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,16,16,16,16,16,
  16,130,130,130,130,130,130,2,2,2,2,2,2,2,2,2,
  2,2,2,2,2,2,2,2,2,2,2,16,16,16,16,32,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,
};


CHARSET_INFO parse_charset_utf8=
{
    0,
    (gchar *)"utf8",
    NULL,
    NULL,
    ctype_utf8
};


CHARSET_INFO parse_charset_gbk=
{
    1,
    (gchar *)"gbk",
    NULL,
    NULL,
    ctype_gbk
};



gboolean init_charset()
{
    CHARSET_INFO **cs;

    memset(&all_charsets, 0, sizeof(all_charsets));

    add_charset(&parse_charset_utf8);
    add_charset(&parse_charset_gbk);
   
    for(cs=all_charsets;*cs != NULL;cs++)
    {
        if(cs[0]->ctype != NULL) {
            if(init_state_maps(*cs))
                return 1;
        }

    }
    return 0;

}

gboolean free_charset()
{
    CHARSET_INFO **cs;
    
    for(cs=all_charsets;*cs != NULL;cs++)
    {
        ut_free(cs[0]->state_map);
        ut_free(cs[0]->ident_map);
    }


    return 0;    
}


gint add_charset(CHARSET_INFO *cs)
{
    if(cs->number < 0 || cs->number > MY_ALL_CHARSETS_SIZE)
        return 1;
    all_charsets[cs->number]= cs;

    return 0;
}

gint find_charset(gchar *name,CHARSET_INFO **out_cs)
{
    CHARSET_INFO **cs;

    for(cs=all_charsets;*cs != NULL;cs++)
    {
        if(lex_casecmp(cs[0]->name,name,strlen(cs[0]->name)) == 0) {
            *out_cs = *cs;
            return 0;            
        }
    }
    return 1;
}

gint init_state_maps(CHARSET_INFO *cs)
{
    guint i;
    guchar *state_map;
    guchar *ident_map;
//    CHARSET_INFO *cs = parse_lex->charset;
/*
    if (!(cs->state_map= (guchar*) lexalloc(parse_lex,256)))  //todo fix me malloc
        return 1;

    if (!(cs->ident_map= (guchar*) lexalloc(parse_lex,256)))  //todo fix me
        return 1;
  */  
    if (!(cs->state_map= (guchar*) ut_malloc(256)))  //todo fix me malloc
        return 1;

    if (!(cs->ident_map= (guchar*) ut_malloc(256)))  //todo fix me
        return 1;

    state_map= cs->state_map;
    ident_map= cs->ident_map;

    /* Fill state_map with states to get a faster parser */
    for (i=0; i < 256 ; i++) {
        if (my_isalpha(cs,i))
            state_map[i]=(guchar) MY_LEX_IDENT;
        else if (my_isdigit(cs,i))
            state_map[i]=(guchar) MY_LEX_NUMBER_IDENT;
        //todo add mb
        else if (my_isspace(cs,i))
            state_map[i]=(guchar) MY_LEX_SKIP;
        else
            state_map[i]=(guchar) MY_LEX_CHAR;
    }
    state_map[(guchar)'_']=state_map[(guchar)'$']=(guchar) MY_LEX_IDENT;
    state_map[(guchar)'\'']=(guchar) MY_LEX_STRING;
    state_map[(guchar)'.']=(guchar) MY_LEX_REAL_OR_POINT;
    state_map[(guchar)'>']=state_map[(guchar)'=']=state_map[(guchar)'!']= (guchar) MY_LEX_CMP_OP;
    state_map[(guchar)'<']= (guchar) MY_LEX_LONG_CMP_OP;
    state_map[(guchar)'&']=state_map[(guchar)'|']=(guchar) MY_LEX_BOOL;
    state_map[(guchar)'#']=(guchar) MY_LEX_COMMENT;
    state_map[(guchar)';']=(guchar) MY_LEX_SEMICOLON;
    state_map[(guchar)':']=(guchar) MY_LEX_SET_VAR;
    state_map[0]=(guchar) MY_LEX_EOL;
    state_map[(guchar)'\\']= (guchar) MY_LEX_ESCAPE;
    state_map[(guchar)'/']= (guchar) MY_LEX_LONG_COMMENT;
    state_map[(guchar)'*']= (guchar) MY_LEX_END_LONG_COMMENT;
    state_map[(guchar)'@']= (guchar) MY_LEX_USER_END;
    state_map[(guchar) '`']= (guchar) MY_LEX_USER_VARIABLE_DELIMITER;
    state_map[(guchar)'"']= (guchar) MY_LEX_STRING_OR_DELIMITER;

    /*
    Create a second map to make it faster to find identifiers
  */
    for (i=0; i < 256 ; i++) {
        ident_map[i]= (guchar) (state_map[i] == MY_LEX_IDENT ||
                state_map[i] == MY_LEX_NUMBER_IDENT);
    }

    /* Special handling of hex and binary strings */
    state_map[(guchar)'x']= state_map[(guchar)'X']= (guchar) MY_LEX_IDENT_OR_HEX;
    state_map[(guchar)'b']= state_map[(guchar)'B']= (guchar) MY_LEX_IDENT_OR_BIN;
    state_map[(guchar)'n']= state_map[(guchar)'N']= (guchar) MY_LEX_IDENT_OR_NCHAR;
    return 0;
}







gint lex_casecmp(const gchar *s, const gchar *t, guint len)
{
    while (len-- != 0 &&
        to_upper_lex[(guchar) *s++] == to_upper_lex[(guchar) *t++]) ;
    return (gint) len+1;
}

gint lex_lower(gchar *s,guint len)
{
    char *t = s;
    while (len-- != 0) 
    {
        *t = to_lower_lex[(guchar)(*t)];
        t++;
    }
    return 0;
}



glong parse_strtoll10(const gchar *nptr, gchar **endptr, gint *error)
{
    const gchar *s, *end, *start, *n_end, *true_end;
    gchar *dummy;
    guchar c;
    gulong i, j, k;
    gulong li;
    gint negative;
    gulong cutoff, cutoff2, cutoff3;

    s= nptr;
    /* If fixed length string */
    if (endptr) {
        end= *endptr;
        while (s != end && (*s == ' ' || *s == '\t'))
            s++;
        if (s == end)
            goto no_conv;
    } else {
        endptr= &dummy;         /* Easier end test */
        while (*s == ' ' || *s == '\t')
            s++;
        if (!*s)
            goto no_conv;
        /* This number must be big to guard against a lot of pre-zeros */
        end= s+65535;   /* Can't be longer than this */
    }

    /* Check for a sign.*/
    negative= 0;
    if (*s == '-')
    {
        *error= -1;     /* Mark as negative number */
        negative= 1;
        if (++s == end)
            goto no_conv;
        cutoff=  MAX_NEGATIVE_NUMBER / LFACTOR2;
        cutoff2= (MAX_NEGATIVE_NUMBER % LFACTOR2) / 100;
        cutoff3=  MAX_NEGATIVE_NUMBER % 100;
    }
    else
    {
        *error= 0;
        if (*s == '+')
        {
            if (++s == end)
                goto no_conv;
        }
        cutoff=  ULONGLONG_MAX / LFACTOR2;
        cutoff2= ULONGLONG_MAX % LFACTOR2 / 100;
        cutoff3=  ULONGLONG_MAX % 100;
    }

    /* Handle case where we have a lot of pre-zero */
    if (*s == '0')
    {
        i= 0;
        do
        {
            if (++s == end)
                goto end_i;                /* Return 0 */
        }
        while (*s == '0');
        n_end= s+ INIT_CNT;
    }
    else
    {
        /* Read first digit to check that it's a valid number */
        if ((c= (*s-'0')) > 9)
            goto no_conv;
        i= c;
        n_end= ++s+ INIT_CNT-1;
    }

    /* Handle first 9 digits and store them in i */
    if (n_end > end)
        n_end= end;
    for (; s != n_end ; s++)
    {
        if ((c= (*s-'0')) > 9)
            goto end_i;
        i= i*10+c;
    }
    if (s == end)
        goto end_i;

    /* Handle next 9 digits and store them in j */
    j= 0;
    start= s;                /* Used to know how much to shift i */
    n_end= true_end= s + INIT_CNT;
    if (n_end > end)
        n_end= end;
    do
    {
        if ((c= (*s-'0')) > 9)
            goto end_i_and_j;
        j= j*10+c;
    } while (++s != n_end);
    if (s == end)
    {
        if (s != true_end)
            goto end_i_and_j;
        goto end3;
    }
    if ((c= (*s-'0')) > 9)
        goto end3;

    /* Handle the next 1 or 2 digits and store them in k */
    k=c;
    if (++s == end || (c= (*s-'0')) > 9)
        goto end4;
    k= k*10+c;
    *endptr= (gchar*) ++s;

    /* number string should have ended here */
    if (s != end && (c= (*s-'0')) <= 9)
        goto overflow;

    /* Check that we didn't get an overflow with the last digit */
    if (i > cutoff || (i == cutoff && (j > cutoff2 || (j == cutoff2 &&
                        k > cutoff3))))
        goto overflow;
    li=i*LFACTOR2+ (gulong) j*100 + k;
    return (glong) li;

  overflow:                    /* *endptr is set here */
    *error= -1;
    return negative ? LONGLONG_MIN : (glong) ULONGLONG_MAX;

  end_i:
    *endptr= (gchar*) s;
    return (negative ? ((glong) -(long) i) : (glong) i);

  end_i_and_j:
    li= (gulong) i * lfactor[(guint) (s-start)] + j;
    *endptr= (gchar*) s;
    return (negative ? -((glong) li) : (glong) li);

  end3:
    li=(gulong) i*LFACTOR+ (gulong) j;
    *endptr= (gchar*) s;
    return (negative ? -((glong) li) : (glong) li);

  end4:
    li=(gulong) i*LFACTOR1+ (gulong) j * 10 + k;
    *endptr= (gchar*) s;
    if (negative)
    {
        if (li > MAX_NEGATIVE_NUMBER)
            goto overflow;
        return -((glong) li);
    }
    return (glong) li;

  no_conv:
    /* There was no number to convert.  */
    *error= -1;
    *endptr= (gchar *) nptr;
    return 0;
}
