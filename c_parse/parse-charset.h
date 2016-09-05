#ifndef PARSE_CHARSET_H
#define PARSE_CHARSET_H


#include <stdio.h>
#include <stdlib.h>
#include "parse-lex.h"
#include "util-alloc.h"

#define MAX_NEGATIVE_NUMBER     ((gulong) (0x8000000000000000L))
#define INIT_CNT                9
#define LFACTOR                 (1000000000UL)
#define LFACTOR1                (10000000000UL)
#define LFACTOR2                (100000000000UL)


#define LONGLONG_MIN            ((glong) 0x8000000000000000L)
#define LONGLONG_MAX            ((glong) 0x7FFFFFFFFFFFFFFFL)

#define ULONGLONG_MAX           ((gulong)(~0UL))


/* Flags for strxfrm */
#define MY_STRXFRM_LEVEL1          0x00000001 /* for primary weights   */
#define MY_STRXFRM_LEVEL2          0x00000002 /* for secondary weights */
#define MY_STRXFRM_LEVEL3          0x00000004 /* for tertiary weights  */
#define MY_STRXFRM_LEVEL4          0x00000008 /* fourth level weights  */
#define MY_STRXFRM_LEVEL5          0x00000010 /* fifth level weights   */
#define MY_STRXFRM_LEVEL6          0x00000020 /* sixth level weights   */
#define MY_STRXFRM_LEVEL_ALL       0x0000003F /* Bit OR for the above six */
#define MY_STRXFRM_NLEVELS         6          /* Number of possible levels*/

#define MY_STRXFRM_PAD_WITH_SPACE  0x00000040 /* if pad result with spaces */
#define MY_STRXFRM_PAD_TO_MAXLEN   0x00000080 /* if pad tail(for filesort) */

#define MY_STRXFRM_DESC_LEVEL1     0x00000100 /* if desc order for level1 */
#define MY_STRXFRM_DESC_LEVEL2     0x00000200 /* if desc order for level2 */
#define MY_STRXFRM_DESC_LEVEL3     0x00000300 /* if desc order for level3 */
#define MY_STRXFRM_DESC_LEVEL4     0x00000800 /* if desc order for level4 */
#define MY_STRXFRM_DESC_LEVEL5     0x00001000 /* if desc order for level5 */
#define MY_STRXFRM_DESC_LEVEL6     0x00002000 /* if desc order for level6 */
#define MY_STRXFRM_DESC_SHIFT      8

#define MY_STRXFRM_UNUSED_00004000 0x00004000 /* for future extensions     */
#define MY_STRXFRM_UNUSED_00008000 0x00008000 /* for future extensions     */

#define MY_STRXFRM_REVERSE_LEVEL1  0x00010000 /* if reverse order for level1 */
#define MY_STRXFRM_REVERSE_LEVEL2  0x00020000 /* if reverse order for level2 */
#define MY_STRXFRM_REVERSE_LEVEL3  0x00040000 /* if reverse order for level3 */
#define MY_STRXFRM_REVERSE_LEVEL4  0x00080000 /* if reverse order for level4 */
#define MY_STRXFRM_REVERSE_LEVEL5  0x00100000 /* if reverse order for level5 */
#define MY_STRXFRM_REVERSE_LEVEL6  0x00200000 /* if reverse order for level6 */
#define MY_STRXFRM_REVERSE_SHIFT   16


#define MY_ALL_CHARSETS_SIZE 1024             

//gboolean init_charset();
//gboolean free_charset();

gint add_charset(CHARSET_INFO *cs);
gint find_charset(gchar *name,CHARSET_INFO **out_cs);

//

gint init_state_maps(CHARSET_INFO *cs);
//gboolean init_state_maps(SQLPARSELEX *parse_lex);
glong parse_strtoll10(const gchar *nptr, gchar **endptr, gint *error);



#endif
