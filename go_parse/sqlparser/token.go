// Copyright 2012, Google Inc. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Copyright 2016 The kingshard Authors. All rights reserved.
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

package sqlparser

import (
	"bytes"
	"fmt"
	"strings"

	"ucloud.cn/sqltypes"
)

const EOFCHAR = 0x100

// Tokenizer is the struct used to generate SQL
// tokens for the parser.
type Tokenizer struct {
	InStream      *strings.Reader
	Sql           []byte
	AllowComments bool
	ForceEOF      bool
	lastChar      uint16
	Position      int
	LastPos       int
	errorToken    []byte
	LastError     string
	posVarIndex   int
	ParseTree     Statement
	ParamList     ParamList
	Storage       []byte
}

// NewStringTokenizer creates a new Tokenizer for the
// sql string.
func NewStringTokenizer(sql string) *Tokenizer {
	return &Tokenizer{InStream: strings.NewReader(sql), Sql: []byte(sql)}
}

var keywords = map[string]int{
	"select": SELECT,
	"insert": INSERT,
	"update": UPDATE,
	"delete": DELETE,
	"from":   FROM,
	"where":  WHERE,
	"group":  GROUP,
	"having": HAVING,
	"order":  ORDER,
	"by":     BY,
	"limit":  LIMIT,
	"for":    FOR,

	"union":     UNION,
	"all":       ALL,
	"minus":     MINUS,
	"except":    EXCEPT,
	"intersect": INTERSECT,

	"join":          JOIN,
	"straight_join": STRAIGHT_JOIN,
	"left":          LEFT,
	"right":         RIGHT,
	"inner":         INNER,
	"outer":         OUTER,
	"cross":         CROSS,
	"natural":       NATURAL,
	"use":           USE,
	"force":         FORCE,
	"on":            ON,
	"into":          INTO,

	"distinct":  DISTINCT,
	"case":      CASE,
	"when":      WHEN,
	"then":      THEN,
	"else":      ELSE,
	"end":       END,
	"as":        AS,
	"and":       AND,
	"or":        OR,
	"not":       NOT,
	"exists":    EXISTS,
	"in":        IN,
	"is":        IS,
	"like":      LIKE,
	"between":   BETWEEN,
	"null":      NULL,
	"asc":       ASC,
	"desc":      DESC,
	"values":    VALUES,
	"duplicate": DUPLICATE,
	"key":       KEY,
	"default":   DEFAULT,
	"set":       SET,
	"lock":      LOCK,
	"unlock":    UNLOCK,
	"tables":    TABLES,
	"read":      READ,
	"write":     WRITE,

	"create": CREATE,
	"alter":  ALTER,
	"rename": RENAME,
	"drop":   DROP,
	"table":  TABLE,
	"index":  INDEX,
	"to":     TO,
	"ignore": IGNORE,
	"if":     IF,
	"unique": UNIQUE,
	"using":  USING,

	"begin":    BEGIN,
	"rollback": ROLLBACK,
	"commit":   COMMIT,

	"names":   NAMES,
	"replace": REPLACE,

	//for kingshard
	"admin":       ADMIN,
	"help":        HELP,
	"start":       START,
	"transaction": TRANSACTION,
	"collate":     COLLATE,
	"offset":      OFFSET,

	//for create table
	"database":     DATABASE,
	"schame":       SCHAME,
	"int":          INT,
	"int1":         TINYINT,
	"tinyint":      TINYINT,
	"int2":         SMALLINT,
	"smallint":     SMALLINT,
	"int3":         MEDIUMINT,
	"mediumint":    MEDIUMINT,
	"int4":         BIGINT,
	"bigint":       BIGINT,
	"real":         REAL,
	"double":       DOUBLE,
	"float8":       DOUBLE,
	"float":        FLOAT,
	"float4":       FLOAT,
	"bit":          BIT,
	"bool":         BOOL,
	"boolean":      BOOLEAN,
	"char":         CHAR,
	"character":    CHAR,
	"nchar":        NCHAR,
	"varbinary":    VARBINARY,
	"nvarchar":     NVARCHAR,
	"varchar":      VARCHAR,
	"tinyblob":     TINYBLOB,
	"blob":         BLOB,
	"mediumblob":   MEDIUMBLOB,
	"longblob":     LONGBLOB,
	"tinytext":     TINYTEXT,
	"text":         TEXT,
	"mediumtext":   MEDIUMTEXT,
	"longtext":     LONGTEXT,
	"dec":          DECIMAL,
	"decimal":      DECIMAL,
	"numeric":      NUMERIC,
	"fixed":        FIXED,
	"enum":         ENUM,
	"serial":       SERIAL,
	"varcharacter": VARCHAR,

	"ascii":             ASCII,
	"binary":            BINARY,
	"unicode":           UNICODE,
	"byte":              BYTE,
	"year":              YEAR,
	"date":              DATE,
	"time":              TIME,
	"timestamp":         TIMESTAMP,
	"datetime":          DATETIME,
	"now":               NOW,
	"localtime":         NOW,
	"localtimestamp":    NOW,
	"current_timestamp": NOW,

	"true":       TRUE,
	"false":      FALSE,
	"signed":     SIGNED,
	"unsigned":   UNSIGNED,
	"zerofill":   ZEROFILL,
	"precision":  PRECISION,
	"national":   NATIONAL,
	"charset":    CHARSET,
	"varying":    VARYING,
	"long":       LONG,
	"geometry":   GEOMETRY,
	"point":      POINT,
	"multipoint": MULTIPOINT,
	"linestring": LINESTRING,
	"polygon":    POLYGON,
	"value":      VALUE,
	"primary":    PRIMARY,
	"dynamic":    DYNAMIC,
	"storage":    STORAGE,
	"disk":       DISK,
	"memory":     MEMORY,
	"references": REFERENCES,
	"match":      MATCH,
	"full":       FULL,
	"partial":    PARTIAL,
	"simple":     SIMPLE,
	"restrict":   RESTRICT,
	"cascade":    CASCADE,
	"no":         NO,
	"action":     ACTION,
	"type":       TYPE,
	"hash":       HASH,
	"btree":      BTREE,
	"rtree":      RTREE,
	"fulltext":   FULLTEXT,
	"indexes":    INDEXES,
	"with":       WITH,
	"parser":     PARSER,
	"spatial":    SPATIAL,
	"foreign":    FOREIGN,
	"engine":     ENGINE,
	"last":       LAST,
	"first":      FIRST,
	"directory":  DIRECTORY,
	"linear":     LINEAR,
	"keys":       KEYS,
	"data":       DATA,
	"comment":    COMMENT_TOKEN,

	"max_rows":   MAX_ROWS,
	"min_rows":   MIN_ROWS,
	"password":   PASSWORD,
	"pack_keys":  PACK_KEYS,
	"checksum":   CHECKSUM,
	"check":      CHECK,
	"row_format": ROW_FORMAT,
	"compressed": COMPRESSED,
	"redundant":  REDUNDANT,
	"compact":    COMPACT,
	"tablespace": TABLESPACE,
	"connection": CONNECTION,
	"algorithm":  ALGORITHM,
	"range":      RANGE,
	"list":       LIST,
	"columns":    COLUMNS,
	"column":     COLUMN,
	"than":       THAN,
	"less":       LESS,
	"maxvalue":   MAX_VALUE,
	"nodegroup":  NODEGROUP,
	"add":        ADD,
	"discard":    DISCARD,
	"import":     IMPORT,
	"change":     CHANGE,
	"modify":     MODIFY,
	"disable":    DISABLE,
	"enable":     ENABLE,
	"convert":    CONVERT,
	"validation": VALIDATION,
	"without":    WITHOUT,
	"rebuild":    REBUILD,
	"optimize":   OPTIMIZE,
	"analyze":    ANALYZE,
	"repair":     REPAIR,
	"coalesce":   COALESCE,
	"truncate":   TRUNCATE,
	"exchange":   EXCHANGE,
	"reorganize": REORGANIZE,
	"after":      AFTER,
	"generated":  GENERATED,
	"always":     ALWAYS,
	"virtual":    VIRTUAL,
	"stored":     STORED,

	"avg_row_length":     AVG_ROW_LENGTH,
	"geometrycollection": GEOMETRYCOLLECTION,
	"multilinestring":    MULTILINESTRING,
	"multipolygon":       MULTIPOLYGON,
	"auto_increment":     AUTO_INC,
	"column_format":      COLUMN_FORMAT,
	"stats_auto_recalc":  STATS_AUTO_RECALC,
	"stats_persistent":   STATS_PERSISTENT,
	"stats_sample_pages": STATS_SAMPLE_PAGES,
	"table_checksum":     TABLE_CHECKSUM,
	"delay_key_write":    DELAY_KEY_WRITE,
	"insert_method":      INSERT_METHOD,
	"key_block_size":     KEY_BLOCK_SIZE,

	"partition":     PARTITION,
	"partitioning":  PARTITIONING,
	"partitions":    PARTITIONS,
	"subpartition":  SUBPARTITION,
	"subpartitions": SUBPARTITIONS,
	"constraint":    CONSTRAINT,
	"global":        GLOBAL,
	"session":       SESSION,
	"local":         LOCAL,
}

// Lex returns the next token form the Tokenizer.
// This function is used by go yacc.
func (tkn *Tokenizer) Lex(lval *yySymType) int {

	tkn.LastPos = tkn.Position
	typ, val := tkn.Scan()
	for typ == COMMENT {
		if tkn.AllowComments {
			break
		}
		tkn.LastPos = tkn.Position
		typ, val = tkn.Scan()
	}
	/*
		switch typ {
		case ID, STRING, NUMBER, VALUE_ARG, COMMENT:
			lval.bytes = val
		}
	*/

	lval.bytes = val
	tkn.errorToken = val

	return typ
}

// Error is called by go yacc if there's a parsing error.
func (tkn *Tokenizer) Error(err string) {
	buf := bytes.NewBuffer(make([]byte, 0, 32))
	if tkn.errorToken != nil {
		fmt.Fprintf(buf, "%s at position %v near %s", err, tkn.Position, tkn.errorToken)
	} else {
		fmt.Fprintf(buf, "%s at position %v", err, tkn.Position)
	}
	tkn.LastError = buf.String()
}

// Scan scans the tokenizer for the next token and returns
// the token type and an optional value.
func (tkn *Tokenizer) Scan() (int, []byte) {
	if tkn.ForceEOF {
		return 0, nil
	}

	if tkn.lastChar == 0 {
		tkn.next()
	}
	tkn.skipBlank()
	switch ch := tkn.lastChar; {
	case isLetter(ch):
		return tkn.scanIdentifier()
	case isDigit(ch):
		return tkn.scanNumber(false)
	case ch == ':':
		return tkn.scanBindVar()
	default:
		tkn.next()
		switch ch {
		case EOFCHAR:
			return 0, nil
		case '=', ',', ';', '(', ')', '+', '*', '%', '&', '|', '^', '~':
			return int(ch), nil
		case '?':
			tkn.posVarIndex++
			buf := new(bytes.Buffer)
			fmt.Fprintf(buf, "%d", tkn.posVarIndex)
			return PARAM, buf.Bytes()
		case '.':
			if isDigit(tkn.lastChar) {
				return tkn.scanNumber(true)
			} else {
				return int(ch), nil
			}
		case '/':
			switch tkn.lastChar {
			case '/':
				tkn.next()
				return tkn.scanCommentType1("//")
			case '*':
				tkn.next()
				return tkn.scanCommentType2()
			default:
				return int(ch), nil
			}
		case '-':
			if tkn.lastChar == '-' {
				tkn.next()
				return tkn.scanCommentType1("--")
			} else {
				return int(ch), nil
			}
		case '<':
			switch tkn.lastChar {
			case '>':
				tkn.next()
				return NE, nil
			case '=':
				tkn.next()
				switch tkn.lastChar {
				case '>':
					tkn.next()
					return NULL_SAFE_EQUAL, nil
				default:
					return LE, nil
				}
			default:
				return int(ch), nil
			}
		case '>':
			if tkn.lastChar == '=' {
				tkn.next()
				return GE, nil
			} else {
				return int(ch), nil
			}
		case '!':
			if tkn.lastChar == '=' {
				tkn.next()
				return NE, nil
			} else {
				return LEX_ERROR, []byte("!")
			}
		case '\'', '"':
			return tkn.scanString(ch, STRING)
		case '`':
			return tkn.scanString(ch, ID)
		default:
			return LEX_ERROR, []byte{byte(ch)}
		}
	}
}

func (tkn *Tokenizer) skipBlank() {
	ch := tkn.lastChar
	for ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t' {
		tkn.next()
		ch = tkn.lastChar
	}
}

func (tkn *Tokenizer) scanIdentifier() (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	buffer.WriteByte(byte(tkn.lastChar))
	for tkn.next(); isLetter(tkn.lastChar) || isDigit(tkn.lastChar); tkn.next() {
		buffer.WriteByte(byte(tkn.lastChar))
	}
	lowered := bytes.ToLower(buffer.Bytes())
	if keywordId, found := keywords[string(lowered)]; found {
		return keywordId, lowered
	}
	return ID, buffer.Bytes()
}

func (tkn *Tokenizer) scanBindVar() (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	buffer.WriteByte(byte(tkn.lastChar))
	for tkn.next(); isLetter(tkn.lastChar) || isDigit(tkn.lastChar) || tkn.lastChar == '.'; tkn.next() {
		buffer.WriteByte(byte(tkn.lastChar))
	}
	if buffer.Len() == 1 {
		return LEX_ERROR, buffer.Bytes()
	}
	return VALUE_ARG, buffer.Bytes()
}

func (tkn *Tokenizer) scanMantissa(base int, buffer *bytes.Buffer) {
	for digitVal(tkn.lastChar) < base {
		tkn.ConsumeNext(buffer)
	}
}

func (tkn *Tokenizer) scanNumber(seenDecimalPoint bool) (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	if seenDecimalPoint {
		buffer.WriteByte('.')
		tkn.scanMantissa(10, buffer)
		goto exponent
	}

	if tkn.lastChar == '0' {
		// int or float
		tkn.ConsumeNext(buffer)
		if tkn.lastChar == 'x' || tkn.lastChar == 'X' {
			// hexadecimal int
			tkn.ConsumeNext(buffer)
			tkn.scanMantissa(16, buffer)
		} else {
			// octal int or float
			seenDecimalDigit := false
			tkn.scanMantissa(8, buffer)
			if tkn.lastChar == '8' || tkn.lastChar == '9' {
				// illegal octal int or float
				seenDecimalDigit = true
				tkn.scanMantissa(10, buffer)
			}
			if tkn.lastChar == '.' || tkn.lastChar == 'e' || tkn.lastChar == 'E' {
				goto fraction
			}
			// octal int
			if seenDecimalDigit {
				return LEX_ERROR, buffer.Bytes()
			}
		}
		goto exit
	}

	// decimal int or float
	tkn.scanMantissa(10, buffer)

fraction:
	if tkn.lastChar == '.' {
		tkn.ConsumeNext(buffer)
		tkn.scanMantissa(10, buffer)
	}

exponent:
	if tkn.lastChar == 'e' || tkn.lastChar == 'E' {
		tkn.ConsumeNext(buffer)
		if tkn.lastChar == '+' || tkn.lastChar == '-' {
			tkn.ConsumeNext(buffer)
		}
		tkn.scanMantissa(10, buffer)
	}

exit:
	return NUMBER, buffer.Bytes()
}

func (tkn *Tokenizer) scanString(delim uint16, typ int) (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	for {
		ch := tkn.lastChar
		tkn.next()
		if ch == delim {
			if tkn.lastChar == delim {
				tkn.next()
			} else {
				break
			}
		} else if ch == '\\' {
			if tkn.lastChar == EOFCHAR {
				return LEX_ERROR, buffer.Bytes()
			}
			if decodedChar := sqltypes.SqlDecodeMap[byte(tkn.lastChar)]; decodedChar == sqltypes.DONTESCAPE {
				ch = tkn.lastChar
			} else {
				ch = uint16(decodedChar)
			}
			tkn.next()
		}
		if ch == EOFCHAR {
			return LEX_ERROR, buffer.Bytes()
		}
		buffer.WriteByte(byte(ch))
	}
	return typ, buffer.Bytes()
}

func (tkn *Tokenizer) scanCommentType1(prefix string) (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	buffer.WriteString(prefix)
	for tkn.lastChar != EOFCHAR {
		if tkn.lastChar == '\n' {
			tkn.ConsumeNext(buffer)
			break
		}
		tkn.ConsumeNext(buffer)
	}
	return COMMENT, buffer.Bytes()
}

func (tkn *Tokenizer) scanCommentType2() (int, []byte) {
	buffer := bytes.NewBuffer(make([]byte, 0, 8))
	buffer.WriteString("/*")
	for {
		if tkn.lastChar == '*' {
			tkn.ConsumeNext(buffer)
			if tkn.lastChar == '/' {
				tkn.ConsumeNext(buffer)
				break
			}
			continue
		}
		if tkn.lastChar == EOFCHAR {
			return LEX_ERROR, buffer.Bytes()
		}
		tkn.ConsumeNext(buffer)
	}
	return COMMENT, buffer.Bytes()
}

func (tkn *Tokenizer) ConsumeNext(buffer *bytes.Buffer) {
	if tkn.lastChar == EOFCHAR {
		// This should never happen.
		panic("unexpected EOF")
	}
	buffer.WriteByte(byte(tkn.lastChar))
	tkn.next()
}

func (tkn *Tokenizer) next() {
	if ch, err := tkn.InStream.ReadByte(); err != nil {
		// Only EOF is possible.
		tkn.lastChar = EOFCHAR
	} else {
		tkn.lastChar = uint16(ch)
	}
	tkn.Position++
}

func isLetter(ch uint16) bool {
	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_' || ch == '@'
}

func digitVal(ch uint16) int {
	switch {
	case '0' <= ch && ch <= '9':
		return int(ch) - '0'
	case 'a' <= ch && ch <= 'f':
		return int(ch) - 'a' + 10
	case 'A' <= ch && ch <= 'F':
		return int(ch) - 'A' + 10
	}
	return 16 // larger than any legal digit val
}

func isDigit(ch uint16) bool {
	return '0' <= ch && ch <= '9'
}
