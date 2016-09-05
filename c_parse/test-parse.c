#include <time.h>
#include <sys/time.h>

#include "parse-lex.h"


int main(int argc,char **argv)
{
    int             count = 0, rc = 0, i = 0,mode = 0;    
    char            sqlsta1[2048] = {0};
    char            sqlsta2[2048] = {0};
    char            sqlsta3[2048] = {0};
    char            sqlsta4[2048] = {0};
    char            sqlsta5[2048] = {0};
    char            sqlsta6[2048] = {0};
    
    SQLPARSELEX     parse_lex;
    struct timeval  time_start;
    struct timeval  time_end;
    double          pers = 0;



    if(argc > 2)  {
        mode = atoi(argv[1]);
        count = atoi(argv[2]);
    } else if (argc > 1) {
        mode = atoi(argv[1]);
        count = 1;
    } else {
        printf("argv invalid.\n");
        return -1;
    }        


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


    sprintf(sqlsta2,   "UPDATE mionldb.TBL_MIONL_TRANS_LOG"
		"   SET "
		"		ext_sp_tp = 'ext_sp_tp', "
		"		debt_at = 'debt_at', "
		"		trans_st = 'trans_st', "
		"		err_cd = 'err_cd', "
		"		acpt_resp_cd = 'acpt_resp_cd', "
		"		industry_resp_cd = 'industry_resp_cd', "
		"		rec_upd_ts = current_timestamp"
		"         WHERE mi_trans_seq = 'mi_trans_seq' AND mi_trans_dt = 'mi_trans_dt'");

    sprintf(sqlsta3,  "select "
		"	cup_branch_ins_id_cd,"
		"	usr_no_region_cd,"
		"	rout_industry_ins_id_cd "
		"	from mionldb.TBL_MIONL_TRANS_LOG  "
		"WHERE mi_trans_seq = 'mi_trans_seq' AND mi_trans_dt = 'mi_trans_dt'");


    sprintf(sqlsta4, "INSERT INTO mionldb.mysqltt"
        "("
        "transmsn_dt_tm, acq_ins_id_cd, sys_tra_no, "
        "tfr_in_in, related_key, acq_ins_tp, fwd_ins_tp, rcv_ins_tp, "
        "iss_ins_tp, rsn_cd, sti_in, sti_takeout_in, fee_in, cross_dist_in, "
        "disc_cd, dom_allot_cd, dif_allot_cd, trans_rcv_ts, to_ts, moni_dist, "
        "risk_in, trans_id, trans_id_conv, trans_seq, trans_seq_conv, trans_tp, "
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

    sprintf(sqlsta5,  "UPDATE mionldb.mysqltt "
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

    sprintf(sqlsta6,  "SELECT * from mionldb.mysqltt "
    "WHERE "
    "transmsn_dt_tm=111111 and acq_ins_id_cd='acq_ins_id_cd' and sys_tra_no='sys_tra_no' and tfr_in_in='tfr_in_in'");
    

    init_charset();
    parse_init(&parse_lex,"utf8");
     

    gettimeofday(&time_start,NULL);
    while(i < count)  {
        i++;
        
        parse_reset(&parse_lex);
        
        rc = parse_sql(&parse_lex,sqlsta4,strlen(sqlsta4));
        if (rc != 0)  {
            printf("parse %d error\n",i);
            break;
        }

        if(mode == 1)
            continue;

        parse_reset(&parse_lex);
        
        rc = parse_sql(&parse_lex,sqlsta5,strlen(sqlsta5));
        if (rc != 0)  {
            printf("parse %d error\n",i);
            break;
        }

        if(mode == 2)
            continue;

        parse_reset(&parse_lex);
        
        rc = parse_sql(&parse_lex,sqlsta6,strlen(sqlsta6));
        if (rc != 0)  {
            printf("parse %d error\n",i);
            break;
        }

    }
    gettimeofday(&time_end,NULL);

    parse_free(&parse_lex);
    

    if (time_end.tv_sec != time_start.tv_sec) {
        pers = (double)count/(time_end.tv_sec - time_start.tv_sec);
    } else {
        pers = -1;
    }

    printf("parse sql, count: %d, cost time: %lds,%ldus.\n",
           count, 
           (long)(time_end.tv_sec - time_start.tv_sec),
           (long)(time_end.tv_usec >time_start.tv_usec ? time_end.tv_usec - time_start.tv_usec : 0));

    printf("pers is %0.2f \n", pers);

    return 0;
}
