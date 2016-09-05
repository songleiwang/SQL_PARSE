#
# format
# [tag]
# sql statement
#
#
# [INIT]
# init some database and table before run sql test
#
# [SQL1][SQL2]
# excute all the sql statments in one tag once  
# excute tags one by one
#
# [RECYCLE]
# delete all the sources created in INIT tag 
#
# just check the return values
# make the all the sql can run correctly in uddb
#
[INIT]
DROP DATABASE IF EXISTS test_db_parse;
CREATE DATABASE test_db_parse;
USE test_db_parse;
CREATE TABLE test_tbl_parse_one(A int, B char(20), C float, PRIMARY KEY(A),KEY `index_B` (B));
CREATE TABLE test_tbl_parse_two(FIR int(10), SEC varchar(200), THR float, FOUR double,PRIMARY KEY(FIR),UNIQUE KEY `uindex_SEC` (`SEC`));
CREATE TABLE test_tbl_parse_three(A int, FIR int(10), I int(10), II varchar(200));


INSERT INTO test_tbl_parse_one values(1,"1",0.1);
INSERT INTO test_tbl_parse_one values(2,"2",0.2);
INSERT INTO test_tbl_parse_one values(3,"3",0.3);
INSERT INTO test_tbl_parse_one values(4,"4",0.4);
INSERT INTO test_tbl_parse_one values(5,"1",0.5);
INSERT INTO test_tbl_parse_one values(6,"2",0.6);
INSERT INTO test_tbl_parse_one values(7,"3",0.7);
INSERT INTO test_tbl_parse_one values(8,"4",0.8);
INSERT INTO test_tbl_parse_two values(100,"AAA",1.11,100.11);
INSERT INTO test_tbl_parse_two values(200,"BBB",2.22,200.22);
INSERT INTO test_tbl_parse_two values(300,"CCC",3.33,300.33);
INSERT INTO test_tbl_parse_three values(11,101,1000,"IIII");
INSERT INTO test_tbl_parse_three values(12,202,2000,"IIIIII");



[SQL1]
# select select_options expr
SELECT 'A';
SELECT 1;
SELECT NULL;
SELECT TIME '101010';                       /*TIME FORMAT  'HH:MM:SS'*/
SELECT DATE '20211001';                     /*DATE FORMAT 'YYYY-MM-DD' or 'YY-MM-DD'*/
SELECT TIMESTAMP '20070523091528';          /*TIMESTAMP FORMAT 'YYYY-MM-DD HH:MM:SS' or 'YY-MM-DD HH:MM:SS'*/
SELECT FALSE;                               /*TURE*/
SELECT 0x48;
SELECT 0b100000;
SELECT _gbk 0b100001;                       /*charset is gbk*/
SELECT @abc;                                /*variable*/
SELECT @abc := 5;                           /*set variable*/
SELECT @@autocommit;                        /*system variable*/
SELECT @@global.autocommit;                 /*global system variable*/
SELECT AVG(1000);                           /*AVG BIT_AND BIT_OR BIT_XOR COUNT...*/
SELECT BIT_AND(1000);
SELECT BIT_OR(1000);
SELECT BIT_XOR(1000);
SELECT COUNT(1000);
SELECT MIN(1000);
SELECT MAX(1000);
SELECT STD('ABC');
SELECT STDDEV('ABC');
SELECT STDDEV_SAMP('ABC');
SELECT STDDEV_POP('ABC');
SELECT VARIANCE('ABC');
SELECT VAR_SAMP('ABC');
SELECT VAR_POP('ABC');
SELECT GROUP_CONCAT('ABC','DEF',8);
SELECT TRIM('abc defg ');                    /*one of the function_call_keyword function*/
SELECT CURDATE();                            /*one of the function_call_nonkeyword function*/
SELECT PASSWORD('abc');                      /*one of the function_call_conflict function*/
SELECT 1 + 100;
SELECT ~1000;
SELECT NOT 0;
SELECT (SELECT 'A');
SELECT ('A');
SELECT EXISTS(SELECT 'A');
SELECT 'A' | 'B';
SELECT 5 & 7;
SELECT 5 << 6;
SELECT 8 << 2;
SELECT 1 + 1；
SELECT 2 - 1;
SELECT 3 * 4;
SELECT 6 / 3;
SELECT 10 % 2;
SELECT 10 DIV 2;
SELECT 10 MOD 2;
SELECT 10 ^ 2;
SELECT 'A' IN (SELECT 'B');
SELECT 'A' NOT IN (1,2,3);
SELECT 'A' BETWEEN 1 AND 2;
SELECT 1 NOT BETWEEN 'A' AND 'B';
SELECT 'A' SOUNDS LIKE 'B';
SELECT 'A' LIKE 'B';
SELECT 1 NOT REGEXP 100;
SELECT 'A' IS NULL;
SELECT 'A' IS NOT NULL;
SELECT 'A' = 'B';
SELECT 'A' > 'B';
SELECT 'A' >= 'B';
SELECT 'A' < 'B';
SELECT 'A' <= 'B';
SELECT 'A' != 'B';
SELECT 'A' < ALL(SELECT 1);
SELECT 1 OR 0;
SELECT 1 AND 0;
SELECT 1 XOR 0;
SELECT NOT 1;
SELECT 1 IS TRUE;
SELECT 1 IS NOT FALSE;
SELECT 'A' IS UNKNOWN;
SELECT DISTINCT 'A','B';
SELECT HIGH_PRIORITY 'A' IS NULL;
SELECT SQL_BIG_RESULT 'A', 1+100, CURDATE(), SUBSTRING('abc','a');
SELECT SQL_NO_CACHE SQL_CALC_FOUND_ROWS ALL DATABASE(),'all is ok';

[SQL2]
#select ... from ... where ...        (in one table and no subquery)
SELECT * FROM test_tbl_parse_one;
SELECT A FROM test_tbl_parse_one;
SELECT A,B FROM test_tbl_parse_one;
SELECT *,A,B FROM test_tbl_parse_one;                 /* *must be the first column except id.* */
SELECT test_tbl_parse_one.* FROM test_tbl_parse_one;
SELECT test_tbl_parse_one.A, B, test_tbl_parse_one.C FROM test_tbl_parse_one;
SELECT 1+1 FROM test_tbl_parse_one;
SELECT A IS TRUE,B FROM test_tbl_parse_one;
SELECT AVG(A),MAX(B) FROM test_tbl_parse_one;
SELECT DISTINCT COUNT(C) AS count_c, MIN(B) AS "TEXT_MIN_B" FROM test_tbl_parse_one;
SELECT SQL_CACHE test_tbl_parse_one.A AS_A, B "TEXT_B" FROM test_tbl_parse_one;
SELECT A,B,C FROM test_tbl_parse_one AS AS_TBL;
SELECT AS_TBL.A, AS_TBL.B, test_tbl_parse_one.C FROM test_db_parse.test_tbl_parse_one AS AS_TBL;
SELECT A,B FROM test_tbl_parse_one USE KEY (PRIMARY);
SELECT A,B FROM test_tbl_parse_one IGNORE INDEX (PRIMARY);
SELECT AS_tbl.A,B FROM test_tbl_parse_one AS AS_tbl FORCE INDEX (PRIMARY,index_B);
SELECT * FROM test_tbl_parse_one WHERE A;
SELECT A FROM test_tbl_parse_one AS AS_tbl WHERE AS_tbl.A > 1;
SELECT AS_tbl.A "TEXT_A", B FROM test_tbl_parse_one AS AS_tbl WHERE A = B;
SELECT AS_tbl.A AS AS_A, B FROM test_tbl_parse_one AS AS_tbl WHERE A + 20 = B;    
SELECT AS_tbl.A AS AS_A, B, C FROM test_tbl_parse_one AS AS_tbl WHERE A=1 AND B=1;
SELECT AS_tbl.A, B, C FROM test_tbl_parse_one AS AS_tbl WHERE A=1 AND B=1 OR C IS TRUE;
SELECT A,B,C FROM test_tbl_parse_one WHERE A/B > 1;
SELECT * FROM test_tbl_parse_one WHERE A BETWEEN 5 AND 10;
SELECT A,B FROM test_tbl_parse_one WHERE A IN (1,2,3);
SELECT A,B,C FROM test_tbl_parse_one WHERE B LIKE 'A%' OR B LIKE 'BB_';
SELECT COUNT(A),B FROM test_tbl_parse_one WHERE A>1 GROUP BY A;
SELECT DISTINCT A FROM test_tbl_parse_one GROUP BY A DESC;
SELECT B FROM test_tbl_parse_one GROUP BY B;
SELECT MAX(A) FROM test_tbl_parse_one WHERE A>1 GROUP BY A DESC;
SELECT MAX(A) FROM test_tbl_parse_one  USE KEY FOR GROUP BY (PRIMARY) WHERE A>1 GROUP BY A DESC;
SELECT MAX(A) FROM test_tbl_parse_one WHERE A>1 GROUP BY 'A';
SELECT COUNT(A) FROM test_tbl_parse_one WHERE A>1 GROUP BY ('A'+'B')+1;
SELECT DISTINCT STD(A),B,AVG(C) FROM test_tbl_parse_one WHERE A>1 GROUP BY A DESC,C ASC;
SELECT STD(A),AVG(C) FROM test_tbl_parse_one WHERE A>1 GROUP BY A DESC,C ASC WITH ROLLUP;
SELECT A,B, C FROM test_tbl_parse_one HAVING A=1 OR B=2;
SELECT AS_tbl.A, B, C FROM test_tbl_parse_one AS_tbl HAVING A && B;
SELECT count(AS_tbl.A) FROM test_tbl_parse_one AS_tbl WHERE A > 1 HAVING count(*)>1;
SELECT AVG(AS_tbl.A) FROM test_tbl_parse_one AS_tbl WHERE B > 1 HAVING AVG(*)>1;
SELECT AS_tbl.A FROM test_tbl_parse_one AS_tbl  WHERE B > 1 group by A HAVING AVG(B) = 2;
SELECT MAX(AS_tbl.A),B FROM test_tbl_parse_one AS_tbl  WHERE A > 1 group by B HAVING COUNT(B) = 2;
SELECT A,B,C FROM  test_tbl_parse_one ORDER BY C ASC;
SELECT COUNT(A),B FROM test_tbl_parse_one AS_tbl  WHERE A > 1 group by B HAVING COUNT(B) = 2 ORDER BY B DESC;
SELECT MAX(A),B FROM test_tbl_parse_one IGNORE INDEX FOR ORDER BY (PRIMARY) WHERE A>1 GROUP BY B ORDER by B;
SELECT MAX(A),B FROM test_tbl_parse_one WHERE A>1 GROUP BY B ORDER by B;
SELECT A,B,C FROM test_tbl_parse_one WHERE A>C ORDER BY A DESC, B DESC; 
SELECT A,B FROM test_tbl_parse_one LIMIT 2;
SELECT A,B,C FROM test_tbl_parse_one ORDER BY A LIMIT 2,3;
SELECT A,B,C FROM test_tbl_parse_one WHERE B=1 ORDER BY A LIMIT 3 offset 2;
SELECT MAX(A),B FROM test_tbl_parse_one WHERE A>1 GROUP BY B HAVING MAX(B)>1 ORDER BY A LIMIT 3,5;
SELECT COUNT(A),B FROM test_tbl_parse_one WHERE A>1 GROUP BY A,B HAVING MAX(B)>1 ORDER BY A LIMIT 3,5; 
SELECT CONCAT(A,'-',B) AS full_name FROM test_tbl_parse_one ORDER BY full_name LIMIT 1;
SELECT * FROM test_tbl_parse_one WHERE A=1 INTO DUMPFILE 'filename';
SELECT MAX(A),B FROM test_tbl_parse_one where B != 1 GROUP BY B HAVING MAX(B) < 5 LIMIT 3 INTO OUTFILE 'filename2';
SELECT A, B INTO @x, @y FROM test_db_parse.test_tbl_parse_one LIMIT 1;
SELECT A-B,A+B INTO OUTFILE 'result.txt'FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' FROM test_tbl_parse_one;
SELECT * FROM test_tbl_parse_one WHERE A=1 FOR UPDATE;
SELECT * FROM test_tbl_parse_one WHERE A=1 ORDER BY B LOCK IN SHARE MODE;

[SQL3]
# select ... from multi table where ...
SELECT test_tbl_parse_one.A FROM test_tbl_parse_one, test_tbl_parse_two;
SELECT t1.A "A_AS" FROM test_tbl_parse_one t1, test_tbl_parse_two, test_tbl_parse_three;
SELECT test_tbl_parse_one.*, test_tbl_parse_two.* FROM test_tbl_parse_one, test_tbl_parse_two;
SELECT A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two;
SELECT C,THR,I FROM test_tbl_parse_one, test_tbl_parse_two, test_tbl_parse_three;
SELECT test_tbl_parse_one.A,test_tbl_parse_two.FIR,test_tbl_parse_three.I FROM test_tbl_parse_one, test_tbl_parse_two, test_tbl_parse_three;
SELECT t1.B, t1.c, t2.FIR, t3.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3;
SELECT test_tbl_parse_one.A, test_tbl_parse_three.A FROM test_tbl_parse_one , test_tbl_parse_three;
SELECT t1.A, t3.A, t2.FIR, t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3;
SELECT A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A =1 OR FIR=200;
SELECT A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A * 100>FIR;
SELECT t1.A AS T1_A,FIR FROM test_tbl_parse_one t1 , test_tbl_parse_two WHERE t1.A BETWEEN 5 AND 10 AND FIR BETWEEN 100 AND 200;
SELECT t1.A,t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A IN (1,2,3) OR t3.A IN (11,2000);
SELECT A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A * 100>FIR AND A>1 AND B != '1' OR C != 0.01 AND FIR != 1 AND SEC != 'AA' XOR THR != 0.01;
SELECT t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , test_tbl_parse_two WHERE t1.B LIKE '[1-3]' AND SEC LIKE '[^C]';
SELECT t1.A, B, test_tbl_parse_three.A, II FROM test_tbl_parse_one t1, test_tbl_parse_three WHERE t1.A + 10=test_tbl_parse_three.A;
SELECT MAX(t1.A),B,COUNT(t3.A) FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY B;
SELECT t1.*, t2.*, t3.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2,test_tbl_parse_three t3 GROUP BY t1.A,t1.B,t1.C,t2.FIR,t2.SEC,t2.THR,FOUR,t3.A,t3.FIR,t3.I,t3.II;
SELECT DISTINCT t1.*, t2.*, t3.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2,test_tbl_parse_three t3 GROUP BY t1.A,t1.B,t1.C,t2.FIR,t2.SEC,t2.THR,FOUR,t3.A,t3.FIR,t3.I,t3.II;
SELECT DISTINCT COUNT(A), MAX(B),FIR FROM test_tbl_parse_one,test_tbl_parse_two WHERE A>2 AND FIR<200 GROUP BY FIR;
SELECT SUM(A) "SUM1", SUM(SEC) SUM2, AVG(B) AS "AVG1", AVG(THR) AS "AVG2" FROM  test_tbl_parse_one,test_tbl_parse_two;
SELECT t1.A AS tbl_1A, t3.A "tbl_3A" FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A+t3.A > 15;
SELECT t1.A+t2.FIR+I FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three;
SELECT t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), test_tbl_parse_three t3;
SELECT B, SEC FROM test_tbl_parse_one IGNORE INDEX (PRIMARY), test_tbl_parse_two IGNORE INDEX (PRIMARY) WHERE A<FIR;
SELECT t1.A, t2.FIR FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WH ERE B != SEC GROUP BY t1.A, t2.FIR HAVING AVG(A) > 5;
SELECT DISTINCT t1.A, t3.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 GROUP BY t1.A,t3.A HAVING AVG(t1.A) != 6 AND MAX(t3.1) > 10;
SELECT A, C, THR FROM test_tbl_parse_one t1,test_tbl_parse_two GROUP BY A DESC, THR ASC;
SELECT t1.A, t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2 ORDER BY t1.B;
SELECT t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A * 100 = t2.FIR ORDER BY t1.B;
SELECT A, C, THR FROM test_tbl_parse_one t1,test_tbl_parse_two GROUP BY A DESC, THR ASC ORDER BY A DESC;
SELECT A, C, THR FROM test_tbl_parse_one t1,test_tbl_parse_two IGNORE INDEX FOR GROUP BY (PRIMARY) GROUP BY A DESC, THR ASC ORDER BY A DESC;
SELECT t1.*, t2.FIR, t3.FIR FROM test_tbl_parse_one t1 IGNORE INDEX (PRIMARY), test_tbl_parse_two t2, test_tbl_parse_three t3 WHERE t1.A + t3.A > 1100 AND t2.FIR+t3.FIR > 1000 GROUP BY t1.A HAVING AVG(t1.A) > 5 ORDER BY t2.THR;
SELECT t1.A, t2.FIR FROM test_tbl_parse_one t1,test_tbl_parse_two t2 LIMIT 1;
SELECT t1.A, t3.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 LIMIT 2,5;
SELECT B, SEC, II FROM test_tbl_parse_one,test_tbl_parse_two,test_tbl_parse_three LIMIT 3 OFFSET 2;
SELECT AVG(t1.A + t2.FIR + t3.A) AS avg_num, COUNT(t3.FIR) FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 GROUP BY (t2.FIR) LIMIT 2,5;
SELECT SUM(t1.B + t3.A) AS sum_num, AVG(t1.A * t3.I) FROM test_tbl_parse_one t1,test_tbl_parse_three t3 ORDER BY sum_num LIMIT 1 OFFSET 0;
SELECT t1.A,t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A=1 AND t2.SEC = 'AAA' INTO DUMPFILE 'filename3';
SELECT t1.*,t2.*,t3.A FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 INTO OUTFILE 'filename4';
SELECT A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A =1 OR FIR=200 FOR UPDATE;
SELECT A, C, THR FROM test_tbl_parse_one t1,test_tbl_parse_two GROUP BY A DESC, THR ASC ORDER BY A DESC LOCK IN SHARE MODE;

[SQL4]
#join 
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two;
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two USE KEY (PRIMARY);
SELECT t1.A,t2.SEC FROM test_tbl_parse_one t1 INNER JOIN test_tbl_parse_two t2;
SELECT t1.A,t2.SEC FROM test_tbl_parse_one t1 INNER JOIN test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC);
SELECT t1.A,test_tbl_parse_three.A FROM test_tbl_parse_one t1 CROSS JOIN test_tbl_parse_three;
SELECT t1.A,t2.FIR,t3.I FROM test_tbl_parse_one t1  STRAIGHT_JOIN test_tbl_parse_two t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 IGNORE INDEX (PRIMARY),test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 FORCE INDEX FOR JOIN (PRIMARY),test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT C,THR FROM test_tbl_parse_one RIGHT JOIN test_tbl_parse_two ON C != THR;
SELECT t1.C, t3.II FROM test_tbl_parse_one t1 LEFT  OUTER JOIN test_tbl_parse_three t3 USING(A);
SELECT t1.A,t2.SEC FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2;
SELECT t1.A,test_tbl_parse_three.A FROM test_tbl_parse_one t1 NATURAL RIGHT OUTER JOIN test_tbl_parse_three;
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > 0.1;
SELECT t1.* ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 ON t1.A+10 = t3.A;
SELECT t1.* ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 USING(A) WHERE t1.A+10 = t3.A;
SELECT t1.A, t3.A FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_one t1 WHERE t1.A + 10 IN(t3.A); 
SELECT A, SEC FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_';
SELECT A, SEC FROM test_tbl_parse_one RIGHT JOIN test_tbl_parse_two t2 ON A BETWEEN 5 AND 7 AND SEC LIKE 'AA_';
SELECT B, SEC, II FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A + 100 > t2.FIR RIGHT OUTER JOIN test_tbl_parse_three t3 ON t1.A + 10 > t3.A;
SELECT MAX(A), MIN(SEC) FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two ON A > 10 ;
SELECT t1.*,t2.* FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 ;
SELECT DISTINCT AVG(A), MIN(FIR) FROM test_tbl_parse_one t1 LEFT OUTER JOIN test_tbl_parse_two ON A < FIR;
SELECT SUM(t1.A) AS s_a, AVG(t3.A) AS s_a_3 , STD(t2.FIR) AS "2_FIR" FROM test_tbl_parse_one t1 STRAIGHT_JOIN test_tbl_parse_three t3 ON t1.A < t3.A INNER JOIN test_tbl_parse_two t2;
SELECT A, FIR FROM test_tbl_parse_one CROSS JOIN test_tbl_parse_two GROUP BY A,FIR;
SELECT B, SEC, II FROM test_tbl_parse_one LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY B,SEC,II;
SELECT A, FIR FROM test_tbl_parse_one JOIN test_tbl_parse_two HAVING A != FIR;
SELECT AVG(t1.A + t3.A) AS "N_AVG", COUNT(t2.FOUR) FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A;
SELECT MAX(t1.A), MIN(t2.FIR) FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2 GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT MAX(t1.A), MIN(t2.FIR) FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2 WHERE t1.A < 10 OR t2.SeC != 'AAA' GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT B,THR,II FROM test_tbl_parse_one RIGHT OUTER JOIN (test_tbl_parse_two , test_tbl_parse_three) ON B != THR HAVING B='1' AND THR != 'AAA';
SELECT t1.*, t2.*, t3.* FROM test_tbl_parse_one t1 RIGHT OUTER JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A != 1 AND t2.FIR != 1 OR t3.A != 1 AND t3.FIR != 1 WHERE t1.A + t2.FIR > t3.A - t3.FIR AND t1.B IS NOT NULL HAVING t1.B='1' AND t2.THR != 'AAA' AND t1.C != 1 AND t3.A BETWEEN 1 AND 100000 AND t3.FIR IN (1,2,3,4,5,6,7,8,9,0,101,102,103);
SELECT t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t1.A;
SELECT t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t3.A DESC,t1.A ASC;
SELECT B,THR,II FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' ORDER BY B,THR DESC;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) ORDER BY t3.A DESC,t1.A ASC;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A HAVING t1.A > 10 OR t2.FOUR > 0 ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.A > 2 GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5  ORDER BY t3.A DESC,t1.A ASC;
SELECT DISTINCT t1.B,t3.II FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.B != "" GROUP BY t1.B,t3.II HAVING MAX(t1.B) > 5  ORDER BY AVG(t1.B);
SELECT t1.* ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 ON t1.A+10 = t3.A LIMIT 2; 
SELECT C,THR FROM test_tbl_parse_one RIGHT JOIN test_tbl_parse_two IGNORE INDEX (PRIMARY) ON C != THR LIMIT 2,5;
SELECT t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 IGNORE INDEX (PRIMARY),test_tbl_parse_three t3) ON t1.A + 10 = t3.A LIMIT 3 OFFSET 3;
SELECT t1.A,t3.A FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A ORDER BY t1.A LIMIT 3;
SELECT t1.A,t3.A FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A WHERE t1.A != 3 AND t3.A > t1.A HAVING t1.A != 4 ORDER BY t1.A LIMIT 3,5;
SELECT AVG(t1.A), t2.FIR AS "T_2" FROM test_tbl_parse_one t1 FORCE INDEX FOR GROUP BY (PRIMARY) CROSS JOIN test_tbl_parse_two t2 ON t1.A < t2.FIR WHERE t1.A != 0 GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT t1.*,t2.*,t3.A FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR CROSS JOIN test_tbl_parse_three t3 INTO OUTFILE 'filename5';
SELECT t1.A,t2.SEC,t3.A FROM test_tbl_parse_one t1 LEFT JOIN(test_tbl_parse_two t2,test_tbl_parse_three t3) ON  t1.A=1 WHERE t2.SEC = 'AAA' AND t3.A = 11 INTO DUMPFILE 'filename7';
SELECT C,THR FROM test_tbl_parse_one RIGHT JOIN test_tbl_parse_two ON C != THR FOR UPDATE;
SELECT B,THR,II FROM test_tbl_parse_one RIGHT OUTER JOIN (test_tbl_parse_two , test_tbl_parse_three) ON B != THR HAVING B='1' AND THR != 'AAA' LOCK IN SHARE MODE;

[SQL5]
#subquery
#single table
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1);
SELECT 5 IN (SELECT A FROM test_tbl_parse_one);
SELECT 5 IN (SELECT A FROM test_tbl_parse_one) IS NOT TRUE;       
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1) AS A1, (SELECT B FROM test_tbl_parse_one WHERE A=2) AS A2;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1) AS A1, (SELECT B FROM test_tbl_parse_one WHERE A=2) AS A2, (SELECT B FROM test_tbl_parse_one WHERE A=3) AS A3, (SELECT B FROM test_tbl_parse_one WHERE A=4) AS A4, (SELECT B FROM test_tbl_parse_one WHERE A=5) AS A5, (SELECT B FROM test_tbl_parse_one WHERE A=6) AS A6, (SELECT B FROM test_tbl_parse_one WHERE A=7) AS A7, (SELECT B FROM test_tbl_parse_one WHERE A=8) AS A8;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1) AS A1, (SELECT B FROM test_tbl_parse_one WHERE A=2) AS A2, (SELECT B FROM test_tbl_parse_one WHERE A=3) AS A3, (SELECT B FROM test_tbl_parse_one WHERE A=4) AS A4, (SELECT B FROM test_tbl_parse_one WHERE A=5) AS A5, (SELECT B FROM test_tbl_parse_one WHERE A=6) AS A6, (SELECT B FROM test_tbl_parse_one WHERE A=7) AS A7, (SELECT B FROM test_tbl_parse_one WHERE A=8) AS A8, A, A, B, B, C, C FROM test_tbl_parse_one;
SELECT 5 IN (SELECT A FROM test_tbl_parse_one) IS TRUE AS BOOL, A,B FROM test_tbl_parse_one;  
SELECT 5 IN (SELECT A FROM test_tbl_parse_one) IS TRUE AS BOOL, A,B FROM (SELECT * FROM test_tbl_parse_one) AS TBL;       
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1) AS A1, (SELECT B FROM test_tbl_parse_one WHERE A=2) AS A2, C AS "A3" FROM test_tbl_parse_one;
SELECT *,(SELECT A FROM test_tbl_parse_one WHERE A = 2) "SUBQURY" FROM test_tbl_parse_one;
SELECT A,B FROM (SELECT * FROM test_tbl_parse_one) AS TBL;
SELECT *,(SELECT A FROM test_tbl_parse_one WHERE A = 2) "SUBQURY" FROM (SELECT A FROM test_tbl_parse_one) AS TBL;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 2) IS NOT NULL AS "NULL" FROM test_tbl_parse_one;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 2) + A AS "SUM" FROM test_tbl_parse_one;
SELECT DISTINCT (SELECT A FROM test_tbl_parse_one WHERE A = 2), B, C FROM test_tbl_parse_one;
SELECT DISTINCT COUNT((SELECT A FROM test_tbl_parse_one WHERE A = 2)), MAX(B), AVG(C) FROM test_tbl_parse_one;
SELECT (SELECT 'ABC'),A,B FROM test_tbl_parse_one USE KEY (PRIMARY);
SELECT (SELECT 'ABC') AS const,AS_tbl.A,B FROM test_tbl_parse_one AS AS_tbl FORCE INDEX (PRIMARY,index_B);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 1) AS COL1, '2' IN (SELECT B FROM test_tbl_parse_one) AS COL2, (SELECT 123) AS COL3, A FROM  test_tbl_parse_one;
SELECT A, (SELECT 'ABC') FROM test_tbl_parse_one WHERE A=1;
SELECT A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one WHERE A=1;
SELECT A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one WHERE A=1 AND EXISTS (SELECT * FROM test_tbl_parse_one);
SELECT A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one WHERE (A,B) = (SELECT A,B FROM test_tbl_parse_one WHERE A=2);
SELECT A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one WHERE A= (SELECT MAX(A) FROM test_tbl_parse_one);
SELECT A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM (SELECT A FROM test_tbl_parse_one) AS TBL WHERE A=1;
SELECT A, B FROM test_tbl_parse_one WHERE (SELECT A FROM test_tbl_parse_one WHERE A=1) IS TRUE;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A = 2) AS C1, B, C FROM test_tbl_parse_one WHERE (SELECT A FROM test_tbl_parse_one WHERE A = 2) IS NULL;
SELECT B, C FROM test_tbl_parse_one WHERE A > (SELECT A FROM test_tbl_parse_one WHERE A=5);
SELECT B, C FROM test_tbl_parse_one WHERE A > ALL (SELECT A FROM test_tbl_parse_one WHERE A=5);
SELECT B, C FROM test_tbl_parse_one WHERE A > ANY (SELECT A FROM test_tbl_parse_one WHERE A=5);
SELECT A,B FROM test_tbl_parse_one WHERE A > 1 AND A IN (SELECT A FROM test_tbl_parse_one WHERE A<5);
SELECT A,B FROM test_tbl_parse_one WHERE A > 1 OR A != ANY (SELECT A FROM test_tbl_parse_one WHERE A<5);
SELECT B, C FROM (SELECT A FROM test_tbl_parse_one) AS TBL WHERE A > (SELECT A FROM test_tbl_parse_one WHERE A=5);
SELECT C FROM test_tbl_parse_one WHERE A BETWEEN (SELECT A FROM test_tbl_parse_one WHERE A=5) AND 1;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5), C FROM test_tbl_parse_one WHERE A IN (SELECT A FROM test_tbl_parse_one WHERE A<5);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one WHERE B='1';
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one HAVING B='1';
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one GROUP BY COL1;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2, C FROM test_tbl_parse_one ORDER BY COL1 ASC;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2, C FROM test_tbl_parse_one GROUP BY COL2,C ORDER BY COL1 ASC ;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one WHERE B='1' AND (A,B) = (SELECT A,B FROM test_tbl_parse_one WHERE A=2) GROUP BY COL1;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one WHERE B='1' AND ROW(A,B) IN (SELECT A,B FROM test_tbl_parse_one) GROUP BY COL1;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 FROM test_tbl_parse_one WHERE B='1' OR ROW(A,B,C) = (SELECT A,B,C FROM test_tbl_parse_one LIMIT 1) GROUP BY COL1;

SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 , C COL3 FROM test_tbl_parse_one WHERE B='1' GROUP BY COL1,C HAVING COL2 > 0.8 ORDER BY C;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 , C COL3 FROM test_tbl_parse_one WHERE B='1' GROUP BY COL1,C HAVING COL2 > 0.8 ORDER BY C FOR UPDATE;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=7), B, C FROM test_tbl_parse_one LIMIT 4;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5), C FROM test_tbl_parse_one WHERE A IN (SELECT A FROM test_tbl_parse_one WHERE A<5) LIMIT 3,5;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 , C COL3 FROM test_tbl_parse_one WHERE B='1' GROUP BY COL1,C HAVING COL2 > 0.8 ORDER BY C LIMIT 1 OFFSET 2;
SELECT A,(SELECT B FROM test_tbl_parse_one LIMIT 1) FROM test_tbl_parse_one WHERE A=1 INTO DUMPFILE 'filename10';
SELECT * FROM (SELECT * FROM test_tbl_parse_one) AS TBL WHERE A=1 LIMIT 1 INTO DUMPFILE 'filename11';
SELECT (SELECT 'ABC'), A, B FROM (SELECT * FROM test_tbl_parse_one) AS TBL WHERE A=1 LIMIT 1 INTO DUMPFILE 'filename12';
SELECT MAX(A),B FROM (SELECT * FROM test_tbl_parse_one) where B != 1 GROUP BY B HAVING MAX(B) < 5 LIMIT 3 INTO OUTFILE 'filename13';
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 , C COL3 FROM (SELECT * FROM test_tbl_parse_one) AS TBL WHERE B='1' GROUP BY COL1,C HAVING COL2 > 0.8 ORDER BY C LIMIT 1 OFFSET 2 LOCK IN SHARE MODE;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=5) AS COL1, (SELECT C FROM test_tbl_parse_one WHERE C>0.7) AS COL2 , C COL3 FROM test_tbl_parse_one WHERE B='1' GROUP BY COL1,C HAVING COL2 > 0.8 ORDER BY C LIMIT 1 OFFSET 2 LOCK IN SHARE MODE;
SELECT A, B FROM test_tbl_parse_one WHERE A > (SELECT A FROM test_tbl_parse_one WHERE A NOT IN (SELECT A FROM test_tbl_parse_one WHERE A !=1));
SELECT A, B FROM test_tbl_parse_one WHERE A > (SELECT A FROM test_tbl_parse_one WHERE A NOT IN (SELECT A FROM test_tbl_parse_one WHERE A !=1))  AND B < ANY (SELECT B FROM test_tbl_parse_one WHERE B IN (SELECT B FROM test_tbl_parse_one WHERE B='1'));

#multi table
SELECT A,(SELECT SEC FROM test_tbl_parse_two WHERE FIR=100) FROM test_tbl_parse_one t1, test_tbl_parse_two t2;
SELECT (SELECT II FROM test_tbl_parse_three WHERE A=11) FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3;
SELECT t1.*,(SELECT II FROM test_tbl_parse_three WHERE A=11) AS COL1,t2.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2;
SELECT test_tbl_parse_one.*,(SELECT II FROM test_tbl_parse_three WHERE A=11) AS COL1, t2.FOUR FROM test_tbl_parse_one, test_tbl_parse_two t2;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=11) AS COL1, (SELECT FIR FROM test_tbl_parse_two WHERE FIR=100) AS COL2, (SELECT A FROM test_tbl_parse_three WHERE A=11) AS COL3 FROM  test_tbl_parse_one;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A; 
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE (t1.A,t1.B) = (SELECT A,B FROM test_tbl_parse_one WHERE A=1); 
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE ROW(t1.A,t1.B) = (SELECT A,B FROM test_tbl_parse_one WHERE A=1); 
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE (t1.A,t3.A) = (SELECT A,B FROM test_tbl_parse_one WHERE A=1); 
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE ROW(t1.A,t3.A,t1.B,t3.FIR) = (SELECT t1.A,t3.A,t1.B,t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A=1 LIMIT 1); 
SELECT t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A OR t3.A > (SELECT A FROM test_tbl_parse_one WHERE A=1); 
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), (SELECT 'ABC'), t1.A FROM test_tbl_parse_one t1 WHERE t1.A > (SELECT 2);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A = (SELECT 2) AND t2.SEC > (SELECT 'AAA');
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A = (SELECT 2) OR (SELECT 'AAA') OR (SELECT II FROM test_tbl_parse_three WHERE A=11);
SElECT * FROM test_tbl_parse_one t1 WHERE 2=(SELECT COUNT(*) FROM test_tbl_parse_two t2 WHERE t1.A + 10 = t2.FIR);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A > ANY (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A <> SOME (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A + t2.FIR > ALL (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one) AND  t2.SEC BETWEEN (SELECT 'BBB') AND 'EEE';
SELECT t1.A, t2.FIR FROM (SELECT * FROM test_tbl_parse_one) t1, (SELECT FIR FROM test_tbl_parse_two) t2;
SELECT t1.*, t2.* FROM (SELECT * FROM test_tbl_parse_one WHERE A=1) t1, (SELECT FIR FROM test_tbl_parse_two WHERE FIR=100) t2;
SELECT t1.A, t2.FIR, t3.II, t4.II, t5.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3, (SELECT * FROM test_tbl_parse_three) t4, (SELECT II FROM test_tbl_parse_three WHERE II='IIII') t5;
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , test_tbl_parse_two WHERE t1.B LIKE '[1-3]' AND SEC LIKE '[^C]';
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM (SELECT * FROM test_tbl_parse_one WHERE A=1) t1 , test_tbl_parse_two WHERE t1.B LIKE '[1-3]' AND SEC LIKE '[^C]';
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , test_tbl_parse_two WHERE t1.B LIKE (SELECT B FROM test_tbl_parse_one WHERE A=1);
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , (SELECT * FROM test_tbl_parse_two WHERE FIR>100) AS TBL WHERE t1.B IN (SELECT B FROM test_tbl_parse_one);
SELECT t1.A, t2.FIR FROM (SELECT * FROM test_tbl_parse_one) t1, (SELECT FIR FROM test_tbl_parse_two) t2 GROUP BY t1.A, t2.FIR;
SELECT (SELECT 1) AS COL,t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY COL,t1.A, t3.A;
SELECT t1.A, t2.FIR FROM  test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE A IN (SELECT T.A  FROM test_tbl_parse_one T ) GROUP BY t1.A,t2.FIR;
SELECT MAX(t1.A),B,COUNT(t3.A),AVG((SELECT A FROM test_tbl_parse_one WHERE A=1)) FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY B;
SELECT MAX(t1.A),B,COUNT(t3.A),(SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1 FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY B,COL1;
SELECT MAX(t1.A),B,COUNT(t3.A),(SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1 FROM (SELECT * FROM test_tbl_parse_one WHERE A > 2 ) AS t1, test_tbl_parse_three t3 GROUP BY B,COL1;
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), test_tbl_parse_three t3;
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), (SELECT * FROM test_tbl_parse_three) AS t3;
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), test_tbl_parse_three t3 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one);
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), test_tbl_parse_three t3 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one) AND t2.FIR > ALL (SELECT FIR FROM test_tbl_parse_two WHERE FIR > 100);
SELECT DISTINCT (SELECT FIR FROM test_tbl_parse_two WHERE FIR=100) AS COL1, t1.A, t3.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 GROUP BY t1.A,t3.A,COL1 HAVING AVG(t1.A) != 6 AND MAX(t3.A) > 10;
SELECT DISTINCT (SELECT FIR FROM test_tbl_parse_two WHERE FIR=100) AS COL1, t1.A, t3.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 GROUP BY t1.A,t3.A,COL1 HAVING AVG(COL1) != 6 OR t1.A IN (SELECT B FROM test_tbl_parse_one);
SELECT (SELECT A FROM test_tbl_parse_three LIMIT 1),t1.A, t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2 ORDER BY t1.B;
SELECT t1.A, t2.SEC FROM (SELECT * FROM test_tbl_parse_one) t1,(SELECT SEC FROM test_tbl_parse_two WHERE SEC > 1) t2 ORDER BY t1.B;
SELECT (SELECT A FROM test_tbl_parse_three LIMIT 1) AS COL1,t1.A, t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2 ORDER BY COL1;
SELECT A, C, THR, (SELECT II FROM test_tbl_parse_three LIMIT 1) AS COL1 FROM test_tbl_parse_one t1,test_tbl_parse_two IGNORE INDEX FOR GROUP BY (PRIMARY) GROUP BY A DESC, THR ASC,COL1 ORDER BY A DESC;
SELECT A, C, THR, (SELECT II FROM test_tbl_parse_three LIMIT 1) AS COL1 FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two IGNORE INDEX FOR GROUP BY (PRIMARY) GROUP BY A DESC, THR ASC,COL1 ORDER BY COL1;
SELECT A, C, THR, (SELECT II FROM test_tbl_parse_three WHERE II='IIII') AS COL1 FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two IGNORE INDEX FOR GROUP BY (PRIMARY) WHERE A IN (SELECT A FROM test_tbl_parse_one) GROUP BY A DESC, THR ASC,COL1 ORDER BY COL1;
SELECT t1.A, t2.FIR, (SELECT 'ABC') "COL1" FROM test_tbl_parse_one t1,test_tbl_parse_two t2 LIMIT 1;
SELECT t1.A, t2.FIR, (SELECT 'ABC') "COL1" FROM test_tbl_parse_one t1,(SELECT * FROM test_tbl_parse_two) t2 LIMIT 1,5;
SELECT AVG(t1.A + t2.FIR + t3.A) AS avg_num, COUNT(t3.FIR), COUNT((SELECT A FROM test_tbl_parse_one WHERE A=5)) FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 GROUP BY (t2.FIR) LIMIT 2,5;
SELECT AVG(t1.A + t2.FIR + t3.A) AS avg_num, COUNT(t3.FIR), COUNT((SELECT A FROM test_tbl_parse_one WHERE A=5)) FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two t2,test_tbl_parse_three t3 GROUP BY (t2.FIR) LIMIT 1 OFFSET 1;
SELECT AVG(t1.A + t2.FIR + t3.A) AS avg_num, COUNT(t3.FIR), COUNT((SELECT A FROM test_tbl_parse_one WHERE A=5)) FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A>1 GROUP BY (t2.FIR) LIMIT 1 OFFSET 1;
SELECT AVG(t1.A + t2.FIR + t3.A) AS avg_num, COUNT(t3.FIR), COUNT((SELECT A FROM test_tbl_parse_one WHERE A=5)) FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A>1 AND t1.A IN (SELECT A FROM test_tbl_parse_one) GROUP BY (t2.FIR) LIMIT 1 OFFSET 1;
SELECT t1.A,t2.SEC,(SELECT 'ABC') AS TBL FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A=1 AND t2.SEC = 'AAA' INTO DUMPFILE 'filename20';
SELECT t1.A,t2.SEC AS TBL FROM (SELECT * FROM test_tbl_parse_one) t1,test_tbl_parse_two t2 WHERE t1.A=1 AND t2.SEC = 'AAA' INTO DUMPFILE 'filename21';
SELECT t1.*,t2.*,t3.A FROM (SELECT * FROM test_tbl_parse_one) t1,(SELECT * FROM test_tbl_parse_two) t2,(SELECT * FROM test_tbl_parse_three) t3 INTO OUTFILE 'filename22';
SELECT t1.*,t2.*,t3.A FROM (SELECT * FROM test_tbl_parse_one) t1,(SELECT * FROM test_tbl_parse_two) t2,(SELECT * FROM test_tbl_parse_three) t3 WHERE t1.A >= ALL (SELECT A FROM test_tbl_parse_one) INTO OUTFILE 'filename23';
SELECT t1.*,t2.*,t3.A FROM (SELECT * FROM test_tbl_parse_one) t1,(SELECT * FROM test_tbl_parse_two) t2,(SELECT * FROM test_tbl_parse_three) t3 WHERE t1.A >= ALL (SELECT A FROM test_tbl_parse_three) INTO OUTFILE 'filename24';
SELECT (SELECT "ABC"),A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A =1 OR FIR=200 FOR UPDATE;
SELECT (SELECT "ABC"),A,B, FIR,SEC FROM test_tbl_parse_one, (SELECT * FROM test_tbl_parse_two) t2 WHERE A=1 OR FIR=200 LOCK IN SHARE MODE;


#multi table in subquery
SELECT t1.A,(SELECT SEC FROM test_tbl_parse_two t2, test_tbl_parse_three t3 WHERE t2.FIR=100 AND t2.FIR != t3.FIR LIMIT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2;
SELECT t1.A,(SELECT SEC FROM test_tbl_parse_two t2, test_tbl_parse_three t3 WHERE t2.FIR=100 AND t2.FIR != t3.FIR LIMIT 1) AND (t1.A,t1.B) = (SELECT A,B FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2;
SELECT t1.A,(SELECT SEC FROM test_tbl_parse_two t2, test_tbl_parse_three t3 WHERE t2.FIR=100 AND t2.FIR != t3.FIR LIMIT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2;

SELECT (SELECT t1.A FROM test_tbl_parse_one, test_tbl_parse_three WHERE t1.A<t3.A LIMIT 1) AS COL1 FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3;
SELECT t1.*,(SELECT II FROM test_tbl_parse_three t3,test_tbl_parse_one t1 WHERE t3.A=11 AND t1.A = 1) AS COL1,t2.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2;
SELECT t1.*,(SELECT II FROM test_tbl_parse_three t3,test_tbl_parse_one t1 WHERE t3.A=11 AND t1.A = 1) AS COL1,t2.* FROM (SELECT t1.* FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t3.A != t1.A) t1, test_tbl_parse_two t2;
SELECT A,FIR,II FROM (SELECT t1.*,t2.*,t3.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3) AS TBL WHERE A != 1;
SELECT A,FIR,II FROM (SELECT t1.*,t2.*,t3.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3) AS TBL WHERE A IN (SELECT A FROM test_tbl_parse_one WHERE A>5);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A!=FIR LIMIT 1) AS COL1, t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A; 
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A!=FIR LIMIT 1) AS COL1, t1.A, t3.A FROM (SELECT t1.*,t2.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A; 
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A!=FIR LIMIT 1) AS COL1, t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A  AND FIR NOT IN (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two); 
SELECT t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A OR t3.A > (SELECT A FROM test_tbl_parse_one, test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1); 
SELECT t1.A, t3.A FROM (SELECT t1.A,t3.II,t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A OR t3.A > (SELECT A FROM test_tbl_parse_one, test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1); 
SELECT t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A + 10 = t3.A OR t3.A > ANY (SELECT A FROM test_tbl_parse_one, test_tbl_parse_two WHERE A=1 AND A != FIR); 
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), (SELECT 'ABC'), t1.A FROM test_tbl_parse_one t1 WHERE t1.A > (SELECT 2);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), (SELECT 'ABC'), t1.A FROM (SELECT t1.*,t2.FIR FROM  test_tbl_parse_one t1, test_tbl_parse_two t2) t1 WHERE t1.A > (SELECT 2);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), (SELECT 'ABC'), t1.A FROM test_tbl_parse_one t1 WHERE (t1.A > ALL (SELECT 2)) AND t1.A IN (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A < FIR);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A = (SELECT 2) AND t2.SEC > ALL (SELECT SEC FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, (SELECT t2.*,t3.A FROM test_tbl_parse_three t3, test_tbl_parse_two t2) t2 WHERE t1.A = (SELECT 2) AND t2.SEC > ALL (SELECT SEC FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1);
SELECT t1.A, t2.SEC, (SELECT 1) FROM (SELECT t1.A,t3.II,t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A = (SELECT 2) OR (SELECT 'AAA') OR (SELECT II FROM test_tbl_parse_three WHERE A=11);
SELECT t1.A, t2.SEC, (SELECT 1) FROM (SELECT t1.A,t3.II,t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A = (SELECT 2) OR (SELECT 'AAA') OR (SELECT II FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A=1 AND t3.A=11);
SELECT (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A != t3.A LIMIT 1),t1.A, t2.SEC, (SELECT 1) FROM  test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM  (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM  (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A < t3.A);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A > ANY (SELECT A FROM test_tbl_parse_one, test_tbl_parse_two WHERE A != FIR);
SELECT t1.A, t2.SEC, (SELECT 1) FROM  (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A > ANY (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) ,(SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A != t3.A LIMIT 1) FROM  (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A > ANY (SELECT A FROM test_tbl_parse_one);
SELECT t1.A, t2.SEC, (SELECT 1) FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE t1.A + t2.FIR > ALL (SELECT A+FIR FROM test_tbl_parse_one,test_tbl_parse_two);
SELECT t1.A, t2.SEC, (SELECT 1) ,(SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A != t3.A LIMIT 1) FROM  (SELECT t1.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1, test_tbl_parse_two t2 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one) AND  t2.SEC BETWEEN (SELECT 'BBB') AND 'EEE';
SELECT t1.A, t2.FIR, t3.II, t4.II, t5.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3, (SELECT t1.C,t3.* FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t4, (SELECT II FROM test_tbl_parse_three WHERE II='IIII') t5;
SELECT t1.A, t2.FIR, t3.II, t4.II, t5.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3, (SELECT t1.C,t3.* FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t4, (SELECT II FROM test_tbl_parse_three WHERE II='IIII') t5 WHERE (t1.A,t3.A) = (SELECT A,B FROM test_tbl_parse_one WHERE A=1);
SELECT t1.A, t2.FIR, t3.II, t4.II, t5.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3, (SELECT t1.C,t3.* FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t4, (SELECT II FROM test_tbl_parse_three WHERE II='IIII') t5 WHERE ROW(t1.A,t3.A,t1.B,t3.FIR) = (SELECT t1.A,t3.A,t1.B,t3.FIR FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A=1 LIMIT 1);
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM (SELECT t1.* FROM test_tbl_parse_one t1, test_tbl_parse_three t3 WHERE t1.A != t3.A) t1 , test_tbl_parse_two WHERE t1.B LIKE '[1-3]' AND SEC LIKE '[^C]';
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , test_tbl_parse_two WHERE t1.B LIKE '[1-3]' AND SEC LIKE '[^C]' AND A LIKE (SELECT t1.A + t3.A FROM test_tbl_parse_one t1 , test_tbl_parse_three t3 LIMIT 1);
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, t2.SEC FROM (SELECT t1.*,t2.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2 WHERE A=1) t1 , test_tbl_parse_two t2 WHERE t1.B LIKE '[1-3]' AND t2.SEC LIKE '[^C]';
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1 , test_tbl_parse_two WHERE t1.B LIKE (SELECT B FROM test_tbl_parse_one WHERE A=1);
SELECT (SELECT 'ABB') AS COL1,t1.B AS T1_B, SEC FROM test_tbl_parse_one t1 , (SELECT t2.*,t3.II FROM test_tbl_parse_two t2 ,test_tbl_parse_three t3 WHERE t2.FIR>100) AS TBL WHERE t1.B IN (SELECT B FROM test_tbl_parse_one);
SELECT t1.A, t2.FIR FROM (SELECT t1.*,t2.SEC FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1, (SELECT t2.FIR,t3.A,t3.II FROM test_tbl_parse_two t2, test_tbl_parse_three t3) t2 GROUP BY t1.A, t2.FIR;
SELECT t1.A, t2.FIR FROM (SELECT t1.*,t2.SEC FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1, (SELECT FIR FROM test_tbl_parse_two) t2 GROUP BY t1.A, t2.FIR;
SELECT (SELECT 1) AS COL,t1.A, t3.A FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY COL,t1.A, t3.A;
SELECT t1.A, t2.FIR FROM  (SELECT t1.*,t2.SEC FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1, test_tbl_parse_two t2 WHERE A IN (SELECT T.A  FROM test_tbl_parse_one T ) GROUP BY t1.A,t2.FIR;
SELECT MAX(t1.A),B,COUNT(t3.A),AVG((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR lIMIT 1)) FROM test_tbl_parse_one t1, test_tbl_parse_three t3 GROUP BY B;
SELECT MAX(t1.A),B,COUNT(t3.A),AVG((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR lIMIT 1)) FROM (SELECT t1.*, t2.SEC FROM test_tbl_parse_one t1, test_tbl_parse_two t2) t1, test_tbl_parse_three t3 GROUP BY B;
SELECT MAX(t1.A),B,COUNT(t3.A),(SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1 FROM (SELECT t1.*, t2.SEC FROM test_tbl_parse_one t1, test_tbl_parse_two t2)  t1, test_tbl_parse_three t3 GROUP BY B,COL1;
SELECT MAX(t1.A),B,COUNT(t3.A),(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1) AS COL1 FROM (SELECT * FROM test_tbl_parse_one WHERE A > 2 ) AS t1, test_tbl_parse_three t3 GROUP BY B,COL1;
SELECT MAX(t1.A),B,COUNT(t3.A),(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1) AS COL1 FROM (SELECT t1.*,t3.II FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A > 2 ) AS t1, test_tbl_parse_three t3 GROUP BY B,COL1;
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), (SELECT t3.*,t1.B FROM test_tbl_parse_one t1, test_tbl_parse_three t3) t3;
SELECT (SELECT 11),t1.A, t2.FIR, t3.A, t3.FIR FROM test_tbl_parse_one t1 USE KEY (PRIMARY),  test_tbl_parse_two t2 FORCE INDEX (PRIMARY,uindex_SEC), (SELECT * FROM test_tbl_parse_three) AS t3 WHERE t1.A IN (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two);
SELECT t1.A, t2.SEC FROM  (SELECT t1.*,t3.II FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A > 2 ) t1,test_tbl_parse_two t2 ORDER BY t1.B;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) AS COL1,t1.A, t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2 ORDER BY COL1;
SELECT t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A * 100 = t2.FIR AND t1.A IN (SELECT (t1.B + t2.SEC) AS A FROM test_tbl_parse_one t1,test_tbl_parse_two t2) ORDER BY t1.B;
SELECT A, C, THR,(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1) AS COL1 FROM test_tbl_parse_one t1,test_tbl_parse_two GROUP BY COL1 DESC, A, C,THR ASC ORDER BY COL1 DESC;
SELECT A, C, THR ,(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1) AS COL1 FROM test_tbl_parse_one t1,test_tbl_parse_two IGNORE INDEX FOR GROUP BY (PRIMARY) GROUP BY A DESC, THR ASC ORDER BY COL1 DESC;
SELECT t1.A, t2.FIR FROM  (SELECT t1.*,t3.II FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A > 2 )  t1,test_tbl_parse_two t2 LIMIT 1;
SELECT t1.A, t3.A FROM (SELECT t1.*,t3.II FROM test_tbl_parse_one t1,test_tbl_parse_three t3) t1,(SELECT t2.SEC,t3.* FROM test_tbl_parse_two t2,test_tbl_parse_three t3) t3 LIMIT 2,5;
SELECT t1.A,t2.SEC FROM (SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) t1,test_tbl_parse_two t2 WHERE t1.A=1 AND t2.SEC = 'AAA' INTO OUTFILE 'filename40';
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1) ,t1.A, t2.SEC FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 LIMIT 1 INTO DUMPFILE 'filename42';
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 AND A != FIR LIMIT 1),A,B, FIR,SEC FROM test_tbl_parse_one, test_tbl_parse_two WHERE A =1 OR FIR=200 FOR UPDATE;
SELECT A, C, THR FROM  (SELECT t1.*,t2.FOUR FROM test_tbl_parse_one t1,test_tbl_parse_two t2) t1,test_tbl_parse_two GROUP BY A DESC, THR ASC ORDER BY A DESC LOCK IN SHARE MODE;

#JOIN
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two;
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two;
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),test_tbl_parse_two.* FROM (SELECT * FROM test_tbl_parse_one) AS t1 JOIN test_tbl_parse_two;
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),t2.* FROM (SELECT * FROM test_tbl_parse_one) AS t1 JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2;
SELECT t1.*,test_tbl_parse_two.* FROM (SELECT * FROM test_tbl_parse_one) AS t1 JOIN test_tbl_parse_two USE KEY (PRIMARY);
SELECT t1.*,test_tbl_parse_two.* FROM  (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 JOIN test_tbl_parse_two USE KEY (PRIMARY);
SELECT t1.*,test_tbl_parse_two.* FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 JOIN  test_tbl_parse_two USE KEY (PRIMARY);
SELECT t1.A,t2.FIR,t3.I,(SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1  STRAIGHT_JOIN test_tbl_parse_two t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT t1.A,t2.FIR,t3.I,(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM (SELECT * FROM test_tbl_parse_one) AS  t1  STRAIGHT_JOIN test_tbl_parse_two t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),t2.FIR,t3.I FROM (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1  STRAIGHT_JOIN test_tbl_parse_two t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT t1.A, (SELECT A FROM test_tbl_parse_one WHERE A=1),t3.I FROM (SELECT * FROM test_tbl_parse_one) AS t1  STRAIGHT_JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.A,t2.FIR,t3.I FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1  STRAIGHT_JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 STRAIGHT_JOIN test_tbl_parse_three t3;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.B,t2.SEC,t3.II FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ,test_tbl_parse_three t3) ON t1.A + 10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t3.II FROM test_tbl_parse_one t1 LEFT JOIN ((SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ,(SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON t1.A + 10 = t3.A;
SELECT t1.B,t2.SEC,t3.II FROM  (SELECT * FROM test_tbl_parse_one) AS t1 LEFT JOIN ((SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 , (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ) ON t1.A + 10 = t3.A;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1), (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1 LEFT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ,(SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON t1.A + 10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.B,t2.SEC,t3.II FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2 FORCE INDEX FOR JOIN (PRIMARY), (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON t1.A + 10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.C, t3.II FROM test_tbl_parse_one t1 LEFT  OUTER JOIN (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 USING(A);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.C, t3.II FROM  (SELECT * FROM test_tbl_parse_one) AS t1 LEFT  OUTER JOIN test_tbl_parse_three t3 USING(A);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.C, t3.II FROM   (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 LEFT  OUTER JOIN test_tbl_parse_three t3 USING(A);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.C, t3.II FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT  OUTER JOIN test_tbl_parse_three t3 USING(A);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.C, t3.II FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT  OUTER JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 USING(A);
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1),test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two WHERE A*100 > FIR AND ROW(t1.A,t1.B) IN (SELECT A,B FROM test_tbl_parse_one);
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two  t2 WHERE A*100 > FIR AND ROW(t1.A,t2.FIR) IN (SELECT A,B FROM test_tbl_parse_one);
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 WHERE A*100 > FIR AND ROW(t1.A,t2.FIR) IN (SELECT t1.A,t3.A FROM test_tbl_parse_one t1,test_tbl_parse_three t3);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.*,test_tbl_parse_two.* FROM (SELECT * FROM test_tbl_parse_one) AS t1 JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),test_tbl_parse_two.* FROM (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),test_tbl_parse_two.* FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 JOIN test_tbl_parse_two WHERE A*100 > FIR;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t2.* FROM test_tbl_parse_one JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A*100 > FIR;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.*,test_tbl_parse_two.* FROM (SELECT * FROM test_tbl_parse_one) AS t1 JOIN test_tbl_parse_two WHERE A*100 > FIR AND A IN (SELECT A FROM test_tbl_parse_one);
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.*,test_tbl_parse_two.* FROM (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 JOIN test_tbl_parse_two WHERE A*100 > FIR AND A IN (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3);
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),test_tbl_parse_one.*,t2.* FROM test_tbl_parse_one JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A*100 > FIR AND A IN  (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR);
SELECT t1.*,t2.* FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A*100 > FIR AND A > ALL  (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR);
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > ANY (SELECT C FROM test_tbl_parse_one);
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > ANY (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3);
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > ANY (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR);
SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > ANY (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 );

SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1,t1.* ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 ON t1.A+10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 USING(A) WHERE t1.A+10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) ,t3.* FROM (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3 LEFT JOIN test_tbl_parse_one t1 USING(A) WHERE t1.A+10 = t3.A;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), t3.A FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_one t1 WHERE t1.A + 10 IN(t3.A); 
SELECT t1.A, t3.A ,(SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_three t3 STRAIGHT_JOIN (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 WHERE t1.A + 10 IN(t3.A); 
SELECT t1.A, t3.A ,(SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_three t3 STRAIGHT_JOIN (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 WHERE t1.A + 10 IN(t3.A) AND EXISTS (SELECT * FROM test_tbl_parse_one); 
SELECT t1.A, t3.A ,(SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_three t3 STRAIGHT_JOIN (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 WHERE t1.A + 10 IN(t3.A) AND EXISTS (SELECT t1.*,t2.* FROM test_tbl_parse_one t1, test_tbl_parse_two t2); 

SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1), A, SEC FROM (SELECT * FROM test_tbl_parse_one) AS t1 INNER JOIN test_tbl_parse_two t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_';
SELECT  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),A, SEC FROM (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 INNER JOIN test_tbl_parse_two t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_';
SELECT A, (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 INNER JOIN test_tbl_parse_two t2 WHERE A BETWEEN 5 AND 7 AND  (SELECT A FROM test_tbl_parse_one LIMIT 1) LIKE 'AA_';
SELECT A, SEC FROM test_tbl_parse_one INNER JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_' OR A IN  (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3);
SELECT A, SEC FROM test_tbl_parse_one INNER JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_' AND A < ANY  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 );
SELECT B, SEC, II FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A + 100 > t2.FIR RIGHT OUTER JOIN (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON t1.A + 10 > t3.A;
SELECT B, SEC, t3.II FROM (SELECT * FROM test_tbl_parse_one) AS t1 LEFT JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON t1.A + 100 > t2.FIR RIGHT OUTER JOIN test_tbl_parse_three t3 ON t1.A + 10 > t3.A;
SELECT MAX((SELECT A FROM test_tbl_parse_one WHERE A=1)), MIN(SEC) FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two ON A > 10 ;
SELECT MAX((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)), MIN(SEC) FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 RIGHT JOIN test_tbl_parse_two ON A > 10 ;
SELECT t1.*,t2.*,(SELECT A FROM test_tbl_parse_one WHERE A=1) FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 ;
SELECT t1.*,t2.* FROM  (SELECT * FROM test_tbl_parse_one) AS t1 RIGHT JOIN test_tbl_parse_two t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 ;
SELECT t1.*,t2.* FROM test_tbl_parse_one t1 RIGHT JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 ;
SELECT t1.*,t2.* FROM test_tbl_parse_one t1 RIGHT JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 AND A > ALL (SELECT A FROM test_tbl_parse_one);
SELECT t1.*,t2.* FROM test_tbl_parse_one t1 RIGHT JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON A != 1 AND B != '1' OR C != 0.1 AND FIR != 1 AND SEC !='A' OR THR != 0.1 AND FOUR != 0.1 AND A IN  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 );
SELECT DISTINCT (SELECT A FROM test_tbl_parse_one WHERE A=1), AVG(A), MIN(FIR) FROM test_tbl_parse_one t1 LEFT OUTER JOIN test_tbl_parse_two ON A < FIR;
SELECT DISTINCT AVG((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)), MIN(t2.FIR) FROM test_tbl_parse_one t1 LEFT OUTER JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON A < FIR;
SELECT DISTINCT AVG(A), MIN( (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1)) FROM  (SELECT A FROM test_tbl_parse_one) t1 LEFT OUTER JOIN test_tbl_parse_two ON A < FIR;
SELECT SUM(t1.A) AS s_a, AVG(t3.A) AS s_a_3 , STD(t2.FIR) AS "2_FIR" , (SELECT A FROM test_tbl_parse_one WHERE A=1) "QU_1" FROM test_tbl_parse_one t1 STRAIGHT_JOIN test_tbl_parse_three t3 ON t1.A < t3.A INNER JOIN test_tbl_parse_two t2;
SELECT SUM((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)) "2_QU_1", SUM(t1.A) AS s_a, AVG(t3.A) AS s_a_3 , STD(t2.FIR) AS "2_FIR" FROM test_tbl_parse_one t1 STRAIGHT_JOIN test_tbl_parse_three t3 ON t1.A < t3.A INNER JOIN (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2;
SELECT SUM(t1.A) AS s_a, AVG(t3.A) AS s_a_3 , STD(t2.FIR) AS "2_FIR" FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 STRAIGHT_JOIN (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON t1.A < t3.A INNER JOIN test_tbl_parse_two t2;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1), A, FIR FROM test_tbl_parse_one CROSS JOIN test_tbl_parse_two GROUP BY A,FIR;

SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),B, SEC, II FROM test_tbl_parse_one LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY B,SEC,II;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), SEC, II FROM (SELECT * FROM test_tbl_parse_one) AS t1 LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY B,SEC,II;
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), B, SEC, II FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY B,SEC,II;
SELECT (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), B, SEC, t3.II FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON B != '1' RIGHT JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON t3.II != 1 GROUP BY B,SEC,t3.II;


SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, SEC, II FROM test_tbl_parse_one LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY COL1,SEC,II;
SELECT B, SEC, II FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN test_tbl_parse_two ON B != '1' RIGHT JOIN test_tbl_parse_three ON II != 1 GROUP BY B,SEC,II;
SELECT B, SEC, t3.II FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON B != '1' RIGHT JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON t3.II != 1 GROUP BY B,SEC,t3.II;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1) AS A, FIR FROM test_tbl_parse_one JOIN test_tbl_parse_two HAVING A != FIR AND A IN  (SELECT A FROM test_tbl_parse_one);
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) AS A, FIR FROM test_tbl_parse_one JOIN test_tbl_parse_two HAVING A != FIR AND A > ANY  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 );
SELECT A, FIR, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM test_tbl_parse_one JOIN test_tbl_parse_two HAVING A != FIR OR A <= ANY (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3);
SELECT AVG(t1.A + t3.A) AS "N_AVG", COUNT(t2.FOUR), MIN((SELECT A FROM test_tbl_parse_one WHERE A=1)) FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A;
SELECT AVG(t1.A + t3.A) AS "N_AVG", COUNT(t2.FOUR) FROM (SELECT * FROM test_tbl_parse_one) AS t1 t1 LEFT JOIN ((SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2, test_tbl_parse_three t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A;
SELECT AVG(t1.A + t3.A) AS "N_AVG", COUNT(t2.FOUR),(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM  (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 LEFT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2, test_tbl_parse_three t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A;
SELECT AVG(t1.A + t3.A) AS "N_AVG", COUNT(t2.FOUR), (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) AS COL1 FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2,  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A, COL1;
SELECT AVG(t1.A + t3.A + (SELECT A FROM test_tbl_parse_one WHERE A=1)) AS "N_AVG", COUNT(t2.FOUR) , MAX((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)+(SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1)) FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A + t2.FIR > t3.A GROUP BY t1.A DESC,t2.FOUR,t3.A;
SELECT MAX((SELECT A FROM test_tbl_parse_one WHERE A=1)), MIN(t2.FIR) FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2 GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT MAX((SELECT A FROM test_tbl_parse_one WHERE A=1)), MIN(t2.FIR) FROM  (SELECT * FROM test_tbl_parse_one) AS  t1 NATURAL LEFT JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT MAX(t1.A), MIN((SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1)) FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1 NATURAL LEFT JOIN test_tbl_parse_two t2 GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10 AND A > ANY  (SELECT A FROM test_tbl_parse_one);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS A,MAX(t1.A), MIN(t2.FIR) FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2 WHERE t1.A < 10 OR t2.SeC != 'AAA' GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) AS A,MAX(t1.A), MIN(t2.FIR) FROM test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_two t2 WHERE t1.A < 10 OR t2.SeC != 'AAA' GROUP BY A HAVING MAX(t1.A) > 5 AND MIN(t2.FIR) > 10;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),(SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),B,THR,II FROM test_tbl_parse_one RIGHT OUTER JOIN (test_tbl_parse_two , test_tbl_parse_three) ON B != THR HAVING B='1' AND THR != 'AAA';
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),B,THR,t3.II FROM (SELECT * FROM test_tbl_parse_one) AS t1 RIGHT OUTER JOIN ((SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 , test_tbl_parse_three t3) ON B != THR HAVING B='1' AND THR != 'AAA';
SELECT t1.*, t2.*, t3.*,(SELECT A FROM test_tbl_parse_one WHERE A=1) FROM (SELECT * FROM test_tbl_parse_one) AS  t1 RIGHT OUTER JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2,  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON t1.A != 1 AND t2.FIR != 1 OR t3.A != 1 AND t3.FIR != 1 WHERE t1.A + t2.FIR > t3.A - t3.FIR AND t1.B IS NOT NULL HAVING t1.B='1' AND t2.THR != 'AAA' AND t1.C != 1 AND t3.A BETWEEN 1 AND 100000 AND t3.FIR IN (1,2,3,4,5,6,7,8,9,0,101,102,103);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, t1.*, t2.*, t3.* FROM test_tbl_parse_one t1 RIGHT OUTER JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A != 1 AND t2.FIR != 1 OR t3.A != 1 AND t3.FIR != 1 WHERE t1.A + t2.FIR > t3.A - t3.FIR AND t1.B IS NOT NULL HAVING t1.B='1' AND t2.THR != 'AAA' AND t1.C != 1 AND t3.A BETWEEN 1 AND 100000 AND t3.FIR IN (1,2,3,4,5,6,7,8,9,0,101,102,103) AND t1.A IN (SELECT A FROM test_tbl_parse_one) AND t1.A IN  (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3) AND t1.A IN  (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR) AND t2.FIR IN  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 );
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) COL2, t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t1.A;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, (SELECT A FROM (SELECT * FROM test_tbl_parse_one) AS t1,test_tbl_parse_two WHERE A=1 LIMIT 1) COL2, t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t1.A,COL1;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, (SELECT A FROM (SELECT * FROM test_tbl_parse_one) AS t1,(SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 WHERE A=1 LIMIT 1) COL2, t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t1.A,COL1;
SELECT t1.A,t3.A , (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) AS COL1 FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ORDER BY t3.A DESC,t1.A ASC, COL1 ASC;
SELECT t1.A,t3.A FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1 JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ORDER BY t3.A DESC,t1.A ASC;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),THR,II, (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' ORDER BY B,THR DESC;
SELECT t1.B,t2.THR,t3.II FROM test_tbl_parse_one t11 JOIN test_tbl_parse_three t3 ON II != '1' JOIN test_tbl_parse_two t22 ON THR != '1' CROSS JOIN  (SELECT * FROM test_tbl_parse_one) AS t1 INNER JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ORDER BY B,THR DESC;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),B,THR,II,(SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' ORDER BY B,THR DESC;
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),B,THR,II FROM  (SELECT * FROM test_tbl_parse_one) AS t1 JOIN test_tbl_parse_three t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' ORDER BY B,THR DESC;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),B,THR,II FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' ORDER BY B,THR DESC;
SELECT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),B,t2.THR,t3.II FROM (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 ON II != '1' JOIN test_tbl_parse_two t2 ON THR != '1' JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t4  ORDER BY B,THR DESC;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.A,t2.FOUR,t3.A, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 ,test_tbl_parse_three t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A ORDER BY t3.A DESC,t1.A ASC ;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1),t1.A,t2.FOUR,t3.A FROM  (SELECT * FROM test_tbl_parse_one) AS t1 NATURAL RIGHT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2 ,test_tbl_parse_three t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t2.FOUR,t3.A FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 NATURAL RIGHT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ,test_tbl_parse_three t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 , (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A AND  A IN (SELECT A FROM test_tbl_parse_one) ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 , (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3) WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A AND  A IN (SELECT A FROM test_tbl_parse_one) AND A > ANY  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) ORDER BY t3.A DESC,t1.A ASC ;
SELECT t1.A,t2.FOUR,t3.A FROM test_tbl_parse_one t1 NATURAL RIGHT JOIN (test_tbl_parse_two t2 , (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3) CROSS JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t4 WHERE t1.A >0 AND t2.FOUR != 0 OR t3.A > t1.A AND  A IN (SELECT A FROM test_tbl_parse_one) AND A > ANY  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) ORDER BY t3.A DESC,t1.A ASC ;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.A,t3.A FROM test_tbl_parse_one t1 JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 WHERE t1.A > 2 GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5  ORDER BY t3.A DESC,t1.A ASC;
SELECT  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.A,t3.A FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1 JOIN test_tbl_parse_three t3 WHERE t1.A > 2 GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5  ORDER BY t3.A DESC,t1.A ASC;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.A > 2 GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5  ORDER BY t3.A DESC,t1.A ASC;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.A > 2 AND t1.A IN  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5  ORDER BY t3.A DESC,t1.A ASC;
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1), t1.A,t3.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.A > 2 AND t1.A IN  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) GROUP BY t1.A,t3.A HAVING MAX(t1.A) > 5 OR AVG ( (SELECT A FROM test_tbl_parse_one))  ORDER BY t3.A DESC,t1.A ASC;
SELECT DISTINCT (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),t1.B,t3.II FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.B != "" GROUP BY t1.B,t3.II HAVING MAX(t1.B) > 5  ORDER BY AVG(t1.B);
SELECT DISTINCT t1.B,t3.II FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.B != "" GROUP BY t1.B,t3.II HAVING MAX((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)) > 5  ORDER BY AVG((SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1));
SELECT DISTINCT t1.B,t3.II FROM  (SELECT * FROM test_tbl_parse_one) AS  t1 JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3 WHERE t1.B != "" GROUP BY t1.B,t3.II HAVING MAX(t1.B) > 5  ORDER BY AVG(t1.B);
SELECT DISTINCT t1.B,t3.II FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.B != "" GROUP BY t1.B,t3.II HAVING MAX(t1.B) > 5 AND t1.B >= ALL ((SELECT A FROM test_tbl_parse_one)) ORDER BY AVG(t1.B);
SELECT DISTINCT t1.B,t3.II, (SELECT A FROM test_tbl_parse_one) FROM test_tbl_parse_one t1 JOIN test_tbl_parse_three t3 WHERE t1.B != "" AND t1.A IN  (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3) GROUP BY t1.B,t3.II HAVING MAX(t1.B) > 5  ORDER BY AVG(t1.B);
SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1) ,t3.* FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 ON t1.A+10 = t3.A LIMIT 2; 
SELECT t1.* ,t3.* FROM  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3 LEFT JOIN (SELECT * FROM test_tbl_parse_one) AS t1 ON t1.A+10 = t3.A LIMIT 2; 
SELECT  (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1) FROM test_tbl_parse_three t3 LEFT JOIN  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 ON t1.A+10 = t3.A LIMIT 2; 
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1, t1.A,t3.A FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A ORDER BY t1.A,COL1 LIMIT 3;
SELECT t1.A,t3.A, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A ORDER BY t1.A LIMIT 3;

SELECT  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), t1.A,t3.A FROM (SELECT * FROM test_tbl_parse_one) AS  t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A WHERE t1.A != 3 AND t3.A > t1.A HAVING t1.A != 4 ORDER BY t1.A LIMIT 3,5;
SELECT  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), t1.A,t3.A FROM (SELECT * FROM test_tbl_parse_one) AS  t1 RIGHT JOIN test_tbl_parse_three t3 ON t1.A != t3.A WHERE t1.A != 3 AND t3.A > t1.A AND t1.A IN  (SELECT A FROM test_tbl_parse_one) HAVING t1.A != 4  AND t1.A !=  (SELECT A FROM test_tbl_parse_one WHERE A=1) ORDER BY t1.A LIMIT 3,5;
SELECT t1.A,t3.A FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 RIGHT JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3 ON t1.A != t3.A WHERE t1.A != 3 AND t3.A > t1.A HAVING t1.A != 4 ORDER BY t1.A LIMIT 3,5;
SELECT t1.A,t3.A, (SELECT A FROM test_tbl_parse_one WHERE A=1) FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 RIGHT JOIN  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3 ON t1.A != t3.A WHERE t1.A != 3 AND t3.A > t1.A HAVING t1.A != 4 OR t1.A IN  (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR)  ORDER BY t1.A LIMIT 3,5;

SELECT COUNT( (SELECT A FROM test_tbl_parse_one WHERE A=1)),AVG(t1.A), t2.FIR AS "T_2" FROM  (SELECT * FROM test_tbl_parse_one) AS  t1  CROSS JOIN test_tbl_parse_two t2 FORCE INDEX FOR GROUP BY (PRIMARY) ON t1.A < t2.FIR WHERE t1.A != 0 AND t1.A >  ANY (SELECT A FROM test_tbl_parse_one) GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT MAX( (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1)),AVG(t1.A), t2.FIR AS "T_2" FROM  (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3)  t1  CROSS JOIN test_tbl_parse_two t2 FORCE INDEX FOR GROUP BY (PRIMARY) ON t1.A < t2.FIR WHERE t1.A != 0 GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 AND t1.A > ANY  (SELECT (t1.A + t2.FIR + t3.A) AS A FROM test_tbl_parse_one t1, test_tbl_parse_two t2, test_tbl_parse_three t3) ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT AVG( (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1)),AVG(t1.A), t2.FIR AS "T_2" FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR )  t1  CROSS JOIN test_tbl_parse_two t2 FORCE INDEX FOR GROUP BY (PRIMARY) ON t1.A < t2.FIR WHERE t1.A != 0 GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 AND t1.A NOT IN  (SELECT t1.A FROM  test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1) AS COL1,AVG(t1.A), t2.FIR AS "T_2" FROM (SELECT * FROM test_tbl_parse_one) t1 CROSS JOIN test_tbl_parse_two t2 ON t1.A < t2.FIR WHERE t1.A != 0 OR t2.FIR IN  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1) +  (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1),AVG(t1.A), t2.FIR AS "T_2" FROM test_tbl_parse_one t1 FORCE INDEX FOR GROUP BY (PRIMARY) CROSS JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 )  t2 ON t1.A < t2.FIR WHERE t1.A != 0 GROUP BY t1.A,t2.FIR DESC HAVING MAX(t1.A) > 0 ORDER BY T_2 LIMIT 1 OFFSET 2;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.*,t2.*,t3.A FROM  (SELECT * FROM test_tbl_parse_one) AS  t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR CROSS JOIN test_tbl_parse_three t3 INTO OUTFILE 'filename51';
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1),t1.*,t2.*,t3.A FROM  (SELECT * FROM test_tbl_parse_one) AS  t1 LEFT JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON t1.A != t2.FIR CROSS JOIN test_tbl_parse_three t3 INTO OUTFILE 'filename52';
SELECT t1.A,t2.SEC,t3.A FROM  (SELECT t1.*, t2.FOUR FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR ) t1 LEFT JOIN ( (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2, (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1)  t3) ON  t1.A=1 WHERE t2.SEC = 'AAA' AND t3.A = 11 LIMIT 1 INTO DUMPFILE 'filename53';
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1), C,THR FROM  (SELECT * FROM test_tbl_parse_one) AS t1 RIGHT JOIN test_tbl_parse_two ON C != THR FOR UPDATE;
SELECT  (SELECT A FROM test_tbl_parse_one WHERE A=1), C,THR FROM  (SELECT * FROM test_tbl_parse_one) AS t1 RIGHT JOIN  (SELECT t3.II, t2.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 ) t2 ON C != THR FOR UPDATE;
SELECT B,THR,t3.II, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1) FROM  (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 RIGHT OUTER JOIN (test_tbl_parse_two , test_tbl_parse_three t3) ON B != THR HAVING B='1' AND THR != 'AAA' AND t1.B > ANY (SELECT A FROM test_tbl_parse_one) LOCK IN SHARE MODE;
SELECT B,THR,t3.II, (SELECT A FROM test_tbl_parse_one,test_tbl_parse_two WHERE A=1 LIMIT 1), AVG( (SELECT t1.A FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A=1 LIMIT 1)) AS "AVG" FROM  (SELECT t1.*, t2.FOUR, t3.II FROM test_tbl_parse_one t1,test_tbl_parse_two t2, test_tbl_parse_three t3) t1 RIGHT OUTER JOIN (test_tbl_parse_two t2,  (SELECT t1.C, t2.FOUR, t3.* FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_two t2 INNER JOIN test_tbl_parse_one t1) t3) ON B != THR WHERE t2.THR > ANY  (SELECT t2.FIR FROM  test_tbl_parse_two t2 NATURAL LEFT JOIN test_tbl_parse_three t3 ) GROUP BY B,THR,t3.II HAVING B='1' AND THR != 'AAA' AND t1.B > ANY (SELECT A FROM test_tbl_parse_one) LOCK IN SHARE MODE;

[SQL6]
#UNION
(SELECT * FROM test_tbl_parse_one) UNION (SELECT * FROM test_tbl_parse_one);
(SELECT A FROM test_tbl_parse_one) UNION (SELECT B FROM test_tbl_parse_one);
(SELECT A,B FROM test_tbl_parse_one) UNION (SELECT B,C FROM test_tbl_parse_one);
(SELECT A FROM test_tbl_parse_one) UNION (SELECT B FROM test_tbl_parse_one) UNION (SELECT C FROM test_tbl_parse_one);
(SELECT * FROM test_tbl_parse_one WHERE A = 1) UNION (SELECT * FROM test_tbl_parse_one);
(SELECT * FROM test_tbl_parse_one WHERE A = 1) UNION (SELECT * FROM test_tbl_parse_one LIMIT 1);
(SELECT COUNT(*) FROM test_tbl_parse_one WHERE A = 1) UNION (SELECT AVG(A) FROM test_tbl_parse_one LIMIT 1) UNION (SELECT MAX(C) FROM test_tbl_parse_one);
(SELECT A,B,AVG(A) FROM test_tbl_parse_one GROUP BY A) UNION (SELECT * FROM test_tbl_parse_one);
(SELECT A,B,C FROM test_tbl_parse_one ORDER BY A) UNION (SELECT * FROM test_tbl_parse_one ORDER BY C);
(SELECT A FROM test_tbl_parse_one GROUP BY A) UNION (SELECT B FROM test_tbl_parse_one  ORDER BY B);
(SELECT A FROM test_tbl_parse_one) UNION (SELECT B FROM test_tbl_parse_one) ORDER BY A;
(SELECT A FROM test_tbl_parse_one) UNION (SELECT B FROM test_tbl_parse_one) LIMIT 1;
(SELECT A FROM test_tbl_parse_one LIMIT 1,2) UNION (SELECT B FROM test_tbl_parse_one) LIMIT 1;
(SELECT A FROM test_tbl_parse_one LIMIT 1,2) UNION (SELECT B FROM test_tbl_parse_one LIMIT 2 OFFSET 4) LIMIT 1;
(SELECT A FROM test_tbl_parse_one ORDER BY A LIMIT 1,2) UNION (SELECT B FROM test_tbl_parse_one GROUP BY B LIMIT 2 OFFSET 4) ORDER BY A LIMIT 1;
(SELECT * FROM test_tbl_parse_one USE KEY FOR GROUP BY (PRIMARY) GROUP BY A) UNION (SELECT * FROM test_tbl_parse_one FORCE INDEX (PRIMARY,index_B));
(SELECT A FROM test_tbl_parse_one WHERE A > 5 AND A BETWEEN 8 AND 10) UNION (SELECT B FROM test_tbl_parse_one);
(SELECT AVG(t1.A) AS COL FROM test_tbl_parse_one t1) UNION (SELECT t2.B FROM test_tbl_parse_one t2) ORDER BY COL;
(SELECT A,B FROM test_tbl_parse_one WHERE A LIKE 1 ORDER BY A) UNION (SELECT COUNT(*),MAX(A) AS A FROM test_tbl_parse_one GROUP BY A HAVING MIN(A) < 1 ORDER BY A) UNION (SELECT B,C FROM test_tbl_parse_one FOR UPDATE);
(SELECT A,B FROM test_tbl_parse_one WHERE A LIKE 1 ORDER BY A) UNION DISTINCT (SELECT COUNT(*),MAX(A) AS A FROM test_tbl_parse_one GROUP BY A HAVING MIN(A) < 1 ORDER BY A) UNION ALL (SELECT B,C FROM test_tbl_parse_one FOR UPDATE);
(SELECT * FROM test_tbl_parse_one) UNION (SELECT FIR,SEC,THR FROM test_tbl_parse_two);
(SELECT *,A FROM test_tbl_parse_one) UNION (SELECT * FROM test_tbl_parse_two) UNION (SELECT * FROM test_tbl_parse_three);
(SELECT *,A FROM test_tbl_parse_one ORDER BY A) UNION (SELECT * FROM test_tbl_parse_two GROUP BY FIR) UNION (SELECT * FROM test_tbl_parse_three);
(SELECT *,A FROM test_tbl_parse_one  t1 WHERE A > 1 ORDER BY A) UNION (SELECT * FROM test_tbl_parse_two t2 WHERE SEC LIKE '1%' GROUP BY FIR) UNION (SELECT * FROM test_tbl_parse_three t3);
(SELECT *,B FROM test_tbl_parse_one t1 WHERE t1.A > 1 ORDER BY t1.A) UNION (SELECT * FROM test_tbl_parse_two t2 WHERE SEC LIKE '1%' GROUP BY FIR) UNION (SELECT * FROM test_tbl_parse_three t3 WHERE t3.A IN (1,2,3,4,5));
(SELECT *,C FROM test_tbl_parse_one LIMIT 1) UNION (SELECT * FROM test_tbl_parse_two LIMIT 1,3) UNION (SELECT * FROM test_tbl_parse_three LIMIT 2 OFFSET 4);
(SELECT *,B FROM test_tbl_parse_one LIMIT 1) UNION (SELECT * FROM test_tbl_parse_two LIMIT 1,3) UNION (SELECT * FROM test_tbl_parse_three LIMIT 2 OFFSET 4) LIMIT 1;
(SELECT *,B FROM test_tbl_parse_one USE KEY FOR GROUP BY (PRIMARY) GROUP BY A) UNION (SELECT * FROM test_tbl_parse_two FORCE INDEX (PRIMARY));
(SELECT *,B FROM test_tbl_parse_one USE KEY FOR GROUP BY (PRIMARY) GROUP BY A) UNION (SELECT * FROM test_tbl_parse_two FORCE INDEX (PRIMARY) ORDER BY SEC LIMIT 1);
(SELECT *,B AS COLB FROM test_tbl_parse_one ) UNION (SELECT * FROM test_tbl_parse_two FORCE INDEX (PRIMARY)) ORDER BY COLB LIMIT 1;
(SELECT COUNT(*) AS COL1 FROM test_tbl_parse_one ) UNION (SELECT COUNT(*) FROM test_tbl_parse_two FORCE INDEX (PRIMARY)) ORDER BY COL1 LIMIT 1;
(SELECT COUNT(*) AS COL1 FROM test_tbl_parse_one ) UNION ALL (SELECT COUNT(*) FROM test_tbl_parse_two FORCE INDEX (PRIMARY)) ORDER BY COL1 LIMIT 1;
(SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) UNION (SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2);
(SELECT t1.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) UNION (SELECT t1.A,t3.A,t3.FIR FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE t1.A != t3.A);
(SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR) UNION (SELECT t1.*,t3.* FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE  t1.A < t3.A);
(SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR) UNION (SELECT t1.*,t3.* FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE  t1.A < t3.A) LIMIT 5;
(SELECT t1.A AS COL1, t1.B, t1.C ,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR) UNION (SELECT t1.*,t3.* FROM test_tbl_parse_one t1,test_tbl_parse_three t3 WHERE  t1.A < t3.A) ORDER BY COL1 LIMIT 5;
(SELECT t1.*,t22.FIR FROM test_tbl_parse_one t1 USE KEY FOR GROUP BY (PRIMARY,index_B),test_tbl_parse_two t22 GROUP BY t1.A,t22.FIR) UNION (SELECT t2.* FROM test_tbl_parse_two t2 FORCE INDEX (PRIMARY) ) UNION (SELECT t3.* FROM test_tbl_parse_three t3 WHERE t3.A BETWEEN 1 AND 15);
(SELECT t1.*,t22.FIR FROM test_tbl_parse_one t1 USE KEY FOR GROUP BY (PRIMARY,index_B),test_tbl_parse_two t22 GROUP BY t1.A,t22.FIR) UNION ALL (SELECT t2.* FROM test_tbl_parse_two t2 FORCE INDEX (PRIMARY) ) UNION DISTINCT (SELECT t3.* FROM test_tbl_parse_three t3 WHERE t3.A BETWEEN 1 AND 15);
(SELECT t1.*,t22.FIR FROM test_tbl_parse_one t1 USE KEY FOR GROUP BY (PRIMARY,index_B),test_tbl_parse_two t22 GROUP BY t1.A,t22.FIR) UNION ALL (SELECT test_tbl_parse_one.*,test_tbl_parse_two.FIR FROM test_tbl_parse_one JOIN test_tbl_parse_two USE KEY (PRIMARY));
(SELECT A,B FROM test_tbl_parse_one) UNION (SELECT B,C FROM test_tbl_parse_one) UNION DISTINCT (SELECT t1.A,t2.SEC FROM test_tbl_parse_one t1 INNER JOIN test_tbl_parse_two t2);
(SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two WHERE A*100 > FIR LIMIT 3) UNION (SELECT test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two ON A*100 > FIR WHERE C > 0.1 LIMIT 3);
(SELECT *,A FROM test_tbl_parse_one) UNION (SELECT * FROM test_tbl_parse_two) UNION ALL (SELECT t1.* ,t3.A FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 ON t1.A+10 = t3.A) UNION ALL(SELECT t1.* ,t3.FIR FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_one t1 USING(A) WHERE t1.A+10 = t3.A) LIMIT 5;
(SELECT t1.A, t3.A FROM test_tbl_parse_three t3 STRAIGHT_JOIN test_tbl_parse_one t1 WHERE t1.A + 10 IN(t3.A)) UNION ALL (SELECT A, SEC FROM test_tbl_parse_one INNER JOIN test_tbl_parse_two t2 WHERE A BETWEEN 5 AND 7 AND SEC LIKE 'AA_') ;
(SELECT (SELECT A FROM test_tbl_parse_one WHERE A=1),test_tbl_parse_one.*,test_tbl_parse_two.* FROM test_tbl_parse_one JOIN test_tbl_parse_two) UNION ALL (SELECT t1.*,t2.*,t2.FIR FROM test_tbl_parse_one t1 RIGHT JOIN test_tbl_parse_two t2 ON t1.A BETWEEN 5 AND 7 AND t2.SEC LIKE 'AA_');


#INSERT
[SQL7]
INSERT test_tbl_parse_one VALUES(10001,'1',1.01);
INSERT INTO test_tbl_parse_one VALUES(10002,'2',2.01);
INSERT LOW_PRIORITY test_tbl_parse_two VALUES (10001,'1',1.01,1.02);
INSERT LOW_PRIORITY INTO test_tbl_parse_two VALUES (10002,'2',2.01,2.02);
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three  VALUES (10001,1,'I','I');
INSERT LOW_PRIORITY INTO test_tbl_parse_two VALUES (10002,'2',2.01,2.02) ON DUPLICATE KEY UPDATE FIR=10012;

INSERT test_tbl_parse_one () VALUES(10003,'3',3.01);
INSERT INTO test_tbl_parse_one () VALUES(10004,'4',4.01);
INSERT LOW_PRIORITY test_tbl_parse_two () VALUES (10003,'3',1.01,1.02);
INSERT LOW_PRIORITY INTO test_tbl_parse_two () VALUES (10004,'4',1.01,1.02);
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three () VALUES (10001,1,'I','I');
INSERT test_tbl_parse_one () VALUES(10003,'3',3.01) ON DUPLICATE KEY UPDATE A=10013,B=100;

INSERT test_tbl_parse_one (A,B,C) VALUES(10005,'5',5.01);
INSERT INTO test_tbl_parse_one (A,B,C) VALUES(10006,'6',6.01);
INSERT LOW_PRIORITY test_tbl_parse_two (FIR,SEC) VALUES (10005,'5');
INSERT LOW_PRIORITY INTO test_tbl_parse_two (FIR,SEC,THR,FOUR) VALUES (10006,'6',1.01,1.02);
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three (A,FIR,II,I) VALUES (10005,1,'I','I');
INSERT LOW_PRIORITY test_tbl_parse_two (FIR,SEC) VALUES (10005,'5') ON DUPLICATE KEY UPDATE SEC=10013;

INSERT test_tbl_parse_one SET A=10011;
INSERT INTO test_tbl_parse_one SET B=1;
INSERT LOW_PRIORITY test_tbl_parse_two SET FIR=10011,SEC='11';
INSERT LOW_PRIORITY INTO test_tbl_parse_two SET FIR=10012,THR=0.001;
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three SET A=10011,FIR=10011,I='OO',II='OO';
INSERT LOW_PRIORITY INTO test_tbl_parse_two SET FIR=10011 ON DUPLICATE KEY UPDATE FIR=10012;
INSERT LOW_PRIORITY INTO test_tbl_parse_two SET FIR=10011 ON DUPLICATE KEY UPDATE FIR=10012,SEC='II';

INSERT test_tbl_parse_one SELECT * FROM test_tbl_parse_one;
INSERT INTO test_tbl_parse_one SELECT * FROM test_tbl_parse_one WHERE A = 1;
INSERT LOW_PRIORITY test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR = 1;
INSERT LOW_PRIORITY INTO test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR > 1;
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three SELECT * FROM test_tbl_parse_three WHERE A != 1;
INSERT LOW_PRIORITY INTO test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR > 1 ON DUPLICATE KEY UPDATE FIR=10012;
INSERT LOW_PRIORITY INTO test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR > 1 ON DUPLICATE KEY UPDATE FIR=10012,SEC='II';

INSERT test_tbl_parse_one () SELECT t1.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
INSERT INTO test_tbl_parse_one () SELECT * FROM test_tbl_parse_one WHERE A = 1 ORDER BY A;
INSERT LOW_PRIORITY test_tbl_parse_two () SELECT * FROM test_tbl_parse_two WHERE FIR = 1 GROUP BY FIR HAVING AVG(FIR) > 1;
INSERT LOW_PRIORITY INTO test_tbl_parse_two () SELECT * FROM test_tbl_parse_two WHERE FIR > 1 OR FIR BETWEEN 1 AND 1000;
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three () SELECT t1.A,t2.FIR,t3.I,t3.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A != 1;
INSERT LOW_PRIORITY INTO test_tbl_parse_two () SELECT * FROM test_tbl_parse_two USE KEY FOR GROUP BY (PRIMARY) WHERE FIR > 1 ON DUPLICATE KEY UPDATE FIR=10012;
INSERT LOW_PRIORITY INTO test_tbl_parse_two () SELECT * FROM test_tbl_parse_two IGNORE KEY (PRIMARY) WHERE FIR > 1 ON DUPLICATE KEY UPDATE FIR=10012,SEC='II';

INSERT test_tbl_parse_one SELECT t1.* FROM test_tbl_parse_one t1 CROSS JOIN test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
INSERT INTO test_tbl_parse_one (A,B,C) SELECT * FROM (SELECT * FROM test_tbl_parse_one) AS TBL WHERE A = 1 ORDER BY A;
INSERT LOW_PRIORITY test_tbl_parse_two (FIR,SEC) SELECT TBL.A,t2.SEC FROM (SELECT * FROM test_tbl_parse_one) AS TBL INNER JOIN test_tbl_parse_two t2;
INSERT LOW_PRIORITY INTO test_tbl_parse_two (FIR,SEC,THR,FOUR) (SELECT * FROM test_tbl_parse_two) UNION (SELECT * FROM test_tbl_parse_three);
INSERT HIGH_PRIORITY IGNORE INTO test_tbl_parse_three (A,FIR,II,I) SELECT * FROM test_tbl_parse_two UNION SELECT * FROM test_tbl_parse_three LIMIT 5 ;
INSERT LOW_PRIORITY test_tbl_parse_two (FIR,SEC,THR,FOUR) (SELECT * FROM test_tbl_parse_two WHERE FIR != 1) UNION (SELECT * FROM test_tbl_parse_three WHERE A != 1) LIMIT 5 ON DUPLICATE KEY UPDATE SEC=10013;

#UPDATE
[SQL8]
UPDATE test_tbl_parse_one SET A=20001;
UPDATE test_tbl_parse_one SET A=20001 WHERE A>20000;
UPDATE test_tbl_parse_one SET A=20001 WHERE A>20000 AND B> (SELECT SEC FROM test_tbl_parse_two LIMIT 1);

UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one AS TBL SET A=20001, B='1';
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one AS TBL SET A=20001, B='1' WHERE A!=B;
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one AS TBL SET A=20001, B='1' WHERE A!=B OR B > ANY (SELECT SEC FROM test_tbl_parse_two);

UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR SET  FIR=20001,SEC='1';
UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR SET FIR=20001,SEC='1' WHERE A <> 1;
UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR SET  FIR=20001,SEC='1' WHERE A <> 1 AND A <> (SELECT AVG(A) FROM test_tbl_parse_one GROUP BY A LIMIT 1);

UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t1 NATURAL LEFT JOIN test_tbl_parse_three t3  SET t1.A=20001 ;
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t1 NATURAL JOIN test_tbl_parse_three t3  SET t1.A=20001 WHERE A IN (1,2,3,4,5);
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t1 NATURAL JOIN test_tbl_parse_three t3  SET t1.A=20001 WHERE A IN (1,2,3,4,5) AND A IN (SELECT A FROM test_tbl_parse_three ORDER BY A );
UPDATE test_tbl_parse_one, test_tbl_parse_two SET A=20001;
UPDATE test_tbl_parse_one, test_tbl_parse_two SET A=20001, FIR=20005;
UPDATE test_tbl_parse_one, test_tbl_parse_two SET A=20001 WHERE A>20000;
UPDATE test_tbl_parse_one, test_tbl_parse_two SET A=20001, SEC='1' WHERE A>20000 AND B> (SELECT II FROM test_tbl_parse_three LIMIT 1);
UPDATE test_tbl_parse_one t1,(SELECT * FROM test_tbl_parse_one) AS TBL SET t1.A=20001;
UPDATE test_tbl_parse_one t1,(SELECT * FROM test_tbl_parse_one) AS TBL SET t1.A=20001 WHERE t1.A != 1 AND TBL.B != '1';
UPDATE test_tbl_parse_one t1,(SELECT * FROM test_tbl_parse_three) AS TBL ,test_tbl_parse_two SET t1.A=20001,THR=0.1 WHERE t1.A != 1 AND t1.B != '1' OR TBL.A != (SELECT FIR FROM test_tbl_parse_three LIMIT 1);
UPDATE test_tbl_parse_one t1,(SELECT * FROM test_tbl_parse_one) AS TBL SET t1.A=20001 WHERE t1.A != 1 AND t1.B != '1' OR TBL.C != (SELECT THR FROM test_tbl_parse_two LIMIT 1);
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one, test_tbl_parse_two AS TBL SET A=20001, B='1';
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one, test_tbl_parse_two AS TBL SET A=20001, B='1' WHERE A!=B;
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t1, test_tbl_parse_two, test_tbl_parse_two AS TBL SET t1.A=20001, B='1' WHERE t1.A!=B OR B > ANY (SELECT A FROM test_tbl_parse_three);
UPDATE test_tbl_parse_one, (SELECT * FROM test_tbl_parse_two) AS TBL SET A=20001, B='1',C=0.11;
UPDATE test_tbl_parse_one, (SELECT * FROM test_tbl_parse_two) AS TBL SET A=20001, B='1',C=0.11 WHERE B LIKE '1%';
UPDATE test_tbl_parse_one, (SELECT * FROM test_tbl_parse_two) AS TBL SET A=20001, B='1',C=0.11 WHERE B LIKE '1%' XOR C =  ANY (SELECT A FROM test_tbl_parse_three ORDER BY A);

UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR,test_tbl_parse_two t3  SET  t2.FIR=20001,t2.SEC='1';
UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR, test_tbl_parse_three t3 SET t2.FIR=20001,t2.SEC='1' WHERE t1.A <> 1;
UPDATE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR, test_tbl_parse_three t3 SET t2.FIR=20001,t2.SEC='1' WHERE t1.A <> 1 AND t1.A <> (SELECT AVG(A) FROM test_tbl_parse_one GROUP BY A LIMIT 1);
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR,(SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) AS TBL SET t2.FIR=20001,t2.SEC='1';
UPDATE LOW_PRIORITY IGNORE (SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) AS TBL, test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR SET t2.FIR=20001,t2.SEC='1' WHERE t2.FIR BETWEEN 100 AND 200;
UPDATE LOW_PRIORITY IGNORE test_tbl_parse_one t0, (SELECT t1.*,t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2) AS TBL, test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR SET t2.FIR=20001,t2.SEC='1' WHERE t2.FIR BETWEEN 100 AND 200 XOR t2.SEC IN  (SELECT SEC FROM test_tbl_parse_two WHERE THR >= SOME (SELECT A FROM test_tbl_parse_three));

#DELETE
DELETE FROM test_tbl_parse_one;
DELETE QUICK FROM test_tbl_parse_one;
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one;
DELETE QUICK FROM test_tbl_parse_one WHERE A=1;
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1';
DELETE QUICK FROM test_tbl_parse_one WHERE A=1 OR A<10;
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' OR A BETWEEN 1 AND 100;
DELETE QUICK FROM test_tbl_parse_one WHERE A=(SELECT A FROM test_tbl_parse_three LIMIT 1);
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t1.A FROM test_tbl_parse_three t1);
DELETE QUICK FROM test_tbl_parse_one WHERE A= SOME (SELECT A FROM test_tbl_parse_three,test_tbl_parse_two);
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t1.A FROM test_tbl_parse_three t1,test_tbl_parse_two t2,test_tbl_parse_three t3);
DELETE QUICK FROM test_tbl_parse_one WHERE A= ANY (SELECT A FROM test_tbl_parse_three JOIN test_tbl_parse_two);
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t3.A FROM test_tbl_parse_three t3 LEFT JOIN test_tbl_parse_two t2 ON t3.A != t2.FIR);

DELETE QUICK FROM test_tbl_parse_three WHERE A=(SELECT t1.A FROM test_tbl_parse_one t1,  test_tbl_parse_one JOIN test_tbl_parse_two);
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t1.A FROM test_tbl_parse_three t1 LEFT JOIN (test_tbl_parse_two t2 , test_tbl_parse_three t3) ON t1.A != t3.A);
DELETE QUICK FROM test_tbl_parse_one WHERE A= ANY (SELECT A FROM test_tbl_parse_three JOIN test_tbl_parse_two) ORDER BY A;


DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t1.C FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR) ORDER BY A;
DELETE QUICK FROM test_tbl_parse_one WHERE A=(SELECT A FROM test_tbl_parse_one,  test_tbl_parse_one JOIN test_tbl_parse_two) ORDER BY A LIMIT 1;
DELETE QUICK LOW_PRIORITY FROM test_db_parse.test_tbl_parse_one WHERE A=1 AND B !='1' AND C != (SELECT t1.C FROM test_tbl_parse_one t1 LEFT JOIN (test_tbl_parse_two t2, test_tbl_parse_three t3) ON t1.A != t3.A) ORDER BY A LIMIT 5;


DELETE test_tbl_parse_one.* FROM test_tbl_parse_one;
DELETE QUICK test_tbl_parse_one.* FROM test_tbl_parse_one;
DELETE QUICK LOW_PRIORITY IGNORE test_tbl_parse_one.* FROM test_tbl_parse_one;

DELETE test_tbl_parse_one.*, test_tbl_parse_two.* FROM test_tbl_parse_one,test_tbl_parse_two;
DELETE QUICK test_tbl_parse_one.*, test_tbl_parse_two.* FROM test_tbl_parse_one,test_tbl_parse_two ;
DELETE QUICK LOW_PRIORITY IGNORE test_tbl_parse_one.*, test_tbl_parse_two.*,  test_tbl_parse_three.* FROM test_tbl_parse_one,test_tbl_parse_two,test_tbl_parse_three;

DELETE t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2;
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  test_tbl_parse_three.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three;

DELETE t1.*, t2.* FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2;
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  test_tbl_parse_three.* FROM test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three);

DELETE t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A = 1;
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  t3.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A + t2.FIR > t3.A;

DELETE t1.*, t2.* FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 WHERE t1.A BETWEEN 1 AND 100 AND t2.FIR != 1;
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A <> 1 OR t2.FIR != 100;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  test_tbl_parse_three.* FROM test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three) WHERE A IN (1,2,3,4,5);

DELETE t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A = 1 AND A > (SELECT A FROM test_tbl_parse_three LIMIT 1);
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  t3.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A + t2.FIR > t3.A;

DELETE t1.*, t2.* FROM test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 WHERE t1.A BETWEEN 1 AND 100 AND t2.FIR != 1;
DELETE QUICK t1.*, t2.* FROM test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A <> 1 OR t2.FIR != 100;
DELETE QUICK LOW_PRIORITY IGNORE t1.*, t2.*,  test_tbl_parse_three.* FROM test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three) WHERE A IN (1,2,3,4,5);

DELETE FROM test_tbl_parse_one.* USING test_tbl_parse_one;
DELETE QUICK FROM test_tbl_parse_one.* USING test_tbl_parse_one;
DELETE QUICK LOW_PRIORITY IGNORE FROM test_tbl_parse_one.* USING test_tbl_parse_one;

DELETE FROM test_tbl_parse_one.*, test_tbl_parse_two.* USING test_tbl_parse_one,test_tbl_parse_two;
DELETE QUICK FROM test_tbl_parse_one.*, test_tbl_parse_two.* USING test_tbl_parse_one,test_tbl_parse_two ;
DELETE QUICK LOW_PRIORITY IGNORE FROM test_tbl_parse_one.*, test_tbl_parse_two.*,  test_tbl_parse_three.* USING test_tbl_parse_one,test_tbl_parse_two,test_tbl_parse_three;

DELETE FROM t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2;
DELETE QUICK FROM t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2;
DELETE QUICK LOW_PRIORITY IGNORE FROM t1.*, t2.*,  test_tbl_parse_three.* USING test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three;

DELETE FROM t1.*, t2.* USING test_tbl_parse_one t1 JOIN test_tbl_parse_two t2;
DELETE QUICK FROM t1.*, t2.* USING test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE FROM t1.*, t2.*, test_tbl_parse_three.* USING test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three);

DELETE FROM  t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A = 1;
DELETE QUICK FROM t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE FROM t1.*, t2.*,  t3.* USING test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A + t2.FIR > t3.A;

DELETE FROM t1.*, t2.* USING test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 WHERE t1.A BETWEEN 1 AND 100 AND t2.FIR != 1;
DELETE QUICK FROM t1.*, t2.* USING test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A <> 1 OR t2.FIR != 100;
DELETE QUICK LOW_PRIORITY IGNORE FROM  t1.*, t2.*,  test_tbl_parse_three.* USING test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three) WHERE A IN (1,2,3,4,5);


DELETE FROM  t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A = 1 AND A > (SELECT A FROM test_tbl_parse_three LIMIT 1);
DELETE QUICK FROM  t1.*, t2.* USING test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
DELETE QUICK LOW_PRIORITY IGNORE FROM t1.*, t2.*,  test_tbl_parse_three.* USING test_tbl_parse_one t1,test_tbl_parse_two t2,test_tbl_parse_three WHERE t1.A + t2.FIR > t3.A;

DELETE FROM t1.*, t2.* USING test_tbl_parse_one t1 JOIN test_tbl_parse_two t2 WHERE t1.A BETWEEN 1 AND 100 AND t2.FIR != 1;
DELETE QUICK FROM t1.*, t2.* USING test_tbl_parse_one t1 LEFT JOIN test_tbl_parse_two t2 ON t1.A != t2.FIR WHERE t1.A <> 1 OR t2.FIR != 100;
DELETE QUICK LOW_PRIORITY IGNORE FROM t1.*, t2.*,  test_tbl_parse_three.* USING test_tbl_parse_one t1 NATURAL LEFT JOIN (test_tbl_parse_two t2,test_tbl_parse_three) WHERE A IN (1,2,3,4,5);

#REPLACE
[SQL10]
REPLACE test_tbl_parse_one VALUES(10001,'1',1.01);
REPLACE INTO test_tbl_parse_one VALUES(10002,'2',2.01);
REPLACE LOW_PRIORITY test_tbl_parse_two VALUES (10001,'1',1.01,1.02);
REPLACE LOW_PRIORITY INTO test_tbl_parse_two VALUES (10002,'2',2.01,2.02);
REPLACE DELAYED  INTO test_tbl_parse_three  VALUES (10001,1,1,"II");


REPLACE test_tbl_parse_one () VALUES(10003,'3',3.01);
REPLACE INTO test_tbl_parse_one () VALUES(10004,'4',4.01);
REPLACE LOW_PRIORITY test_tbl_parse_two () VALUES (10003,'3',1.01,1.02);
REPLACE LOW_PRIORITY INTO test_tbl_parse_two () VALUES (10004,'4',1.01,1.02);
REPLACE   INTO test_tbl_parse_three () VALUES (10001,1,1,'I');


REPLACE test_tbl_parse_one (A,B,C) VALUES(10005,'5',5.01);
REPLACE INTO test_tbl_parse_one (A,B,C) VALUES(10006,'6',6.01);
REPLACE LOW_PRIORITY test_tbl_parse_two (FIR,SEC) VALUES (10005,'5');
REPLACE LOW_PRIORITY INTO test_tbl_parse_two (FIR,SEC,THR,FOUR) VALUES (10006,'6',1.01,1.02);
REPLACE   INTO test_tbl_parse_three (A,FIR,II,I) VALUES (10005,1,'I',1);


REPLACE test_tbl_parse_one SET A=10011;
REPLACE INTO test_tbl_parse_one SET A=0, B=1;
REPLACE LOW_PRIORITY test_tbl_parse_two SET FIR=10011,SEC='11';
REPLACE LOW_PRIORITY INTO test_tbl_parse_two SET FIR=10012,THR=0.001;
REPLACE   INTO test_tbl_parse_three SET A=10011,FIR=10011,I=0,II='OO';


REPLACE test_tbl_parse_one SELECT * FROM test_tbl_parse_one;
REPLACE INTO test_tbl_parse_one SELECT * FROM test_tbl_parse_one WHERE A = 1;
REPLACE LOW_PRIORITY test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR = 1;
REPLACE LOW_PRIORITY INTO test_tbl_parse_two SELECT * FROM test_tbl_parse_two WHERE FIR > 1;
REPLACE   INTO test_tbl_parse_three SELECT * FROM test_tbl_parse_three WHERE A != 1;

REPLACE test_tbl_parse_one () SELECT t1.* FROM test_tbl_parse_one t1,test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
REPLACE INTO test_tbl_parse_one () SELECT * FROM test_tbl_parse_one WHERE A = 1 ORDER BY A;
REPLACE LOW_PRIORITY test_tbl_parse_two () SELECT * FROM test_tbl_parse_two WHERE FIR = 1 GROUP BY FIR HAVING AVG(FIR) > 1;
REPLACE LOW_PRIORITY INTO test_tbl_parse_two () SELECT * FROM test_tbl_parse_two WHERE FIR > 1 OR FIR BETWEEN 1 AND 1000;
REPLACE   INTO test_tbl_parse_three () SELECT t1.A,t2.FIR,t3.I,t3.II FROM test_tbl_parse_one t1, test_tbl_parse_two t2,test_tbl_parse_three t3 WHERE t1.A != 1;


REPLACE test_tbl_parse_one SELECT t1.* FROM test_tbl_parse_one t1 CROSS JOIN test_tbl_parse_two t2 WHERE t1.A != t2.FIR;
REPLACE INTO test_tbl_parse_one (A,B,C) SELECT * FROM (SELECT * FROM test_tbl_parse_one) AS TBL WHERE A = 1 ORDER BY A;
REPLACE LOW_PRIORITY test_tbl_parse_two (FIR,SEC) SELECT TBL.A,t2.SEC FROM (SELECT * FROM test_tbl_parse_one) AS TBL INNER JOIN test_tbl_parse_two t2;
REPLACE LOW_PRIORITY INTO test_tbl_parse_two (FIR,SEC,THR,FOUR) (SELECT * FROM test_tbl_parse_two) UNION (SELECT * FROM test_tbl_parse_three);
REPLACE   INTO test_tbl_parse_three (A,FIR,II,I) SELECT * FROM test_tbl_parse_two UNION SELECT * FROM test_tbl_parse_three LIMIT 5 ;

