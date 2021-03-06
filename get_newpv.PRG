* procedure get_newpv.prg
* ������ṹ�����ѹ���Ъ�ǧ����
PARAMETERS mperiod
CLOSE DATABASES all

* ��Ǩ�ͺ parameter mperiod ����͹�����
IF CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))=CTOD("  /  /  ")
	MESSAGEBOX("Can't Get_Newpv Because Parameter [mperiod]='"+mperiod+"' Error!!",0+16,"Error")
	RETURN
ENDIF

* ��˹���ҵ���÷����Թ���
loc_frmdate = CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))	&& �ѹ����������
loc_todate = endofmonth(loc_frmdate)	&& �ѹ�������ش
path_calcresult = "d:\aiyara_dbs\calc\result\"

* ��Ǩ�ͺ������ / ���ҧ�������
path_db = SYS(5)+CURDIR()+"db\"
IF !directory(path_db)
	MD db	&& ���ҧ directory db �ҡ�ѧ�����
ENDIF
fname = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+".dbf"
fname_log = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+"_log.dbf"
fname_bslog = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+"_bslog.dbf"

IF FILE(fname_log) AND .T.
	nAnswer = MESSAGEBOX("Files "+fname_log+" was exist!! , do you need to re-create",32+4+256,"Please Select...")
	IF nAnswer = 7 && answer 'NO'
		RETURN	&& end procedure
	ELSE
		ERASE &fname_log
		ERASE &fname
		ERASE &fname_bslog
	ENDIF
ELSE
	ERASE &fname_log
	ERASE &fname
	ERASE &fname_bslog
ENDIF

* ���ҧ�������
CREATE table &fname_bslog (period d(8) ,firstdate d(8) ,id c(15),sponsor c(15),ownpv n(10),newpv n(10))
USE
CREATE table &fname_log (period d(8) ,id c(15),in_a n(10),in_b n(10),in_c n(10),newbs n(10))
USE
USE &fname_log IN 0 ALIAS newpvlog

* ������ṹ�����ѹ���Ъ�ǧ����
loc_calcdate = loc_frmdate
DO WHILE loc_calcdate <= loc_todate	
	fname_calcdate = path_calcresult+SUBSTR(DTOS(loc_calcdate),1,6)+"\"+DTOS(loc_calcdate)+"\result.dbf"
	IF FILE(fname_calcdate)
		*?fname_calcdate,loc_calcdate
		* ���ҧ�����������´�ͧ��ṹ������ѹ
		USE &fname_calcdate IN 0 ALIAS result
		SELECT result
		GO TOP
		DO WHILE .not. EOF()
			SELECT result
			IF (result.in_a+result.in_b+result.in_c) <> 0 
				WAIT WINDOWS ;
					"["+DTOC(loc_calcdate)+"] "+fname_calcdate+" "+;
					ALLTRIM(STR(RECNO()/RECCOUNT()*100,5,2))+"%" NOWAIT

				SELECT newpvlog
				APPEND blank
				REPLACE ;
					period WITH result.period ,;
					id WITH result.id ,;
					in_a WITH result.in_a ,;
					in_b WITH result.in_b ,;
					in_c WITH result.in_c
			ENDIF
			SELECT result
			SKIP
		ENDDO

		* �� newbasic �������		
		SELECT period,firstdate,id,sponsor,ownpv,newpv ;
			FROM result ;
			WHERE ownpv>=1000 ;
				AND ownpv-newpv<1000 ;
				AND newpv<>0 ;
			INTO CURSOR newbasic_all
			
		* �ѹ�֡ŧ� bslog
		SELECT newbasic_all
		USE &fname_bslog IN 0 ALIAS newbs_log
		SELECT newbs_log
		APPEND FROM DBF("newbasic_all")
		USE		
		
		* ����ӹǹ newbasic �¡��� sponsor
		SELECT sponsor as id ,SUM(1) as newbs ;
			FROM newbasic_all ;
			GROUP BY sponsor ;
			INTO CURSOR newbasic_sum
			
		* ��Ѻ��ا����� newpvlog
		UPDATE newpvlog ;
			FROM newbasic_sum ;
			WHERE ALLTRIM(newpvlog.id) == ALLTRIM(newbasic_sum.id) ;
			AND newpvlog.period == loc_calcdate ;
			SET newpvlog.newbs = newbasic_sum.newbs
		
		SELECT result
		USE
	ELSE
		?"Error File : "+fname_calcdate+" Not Found!!!"
	ENDIF
	loc_calcdate = loc_calcdate+1
	*loc_calcdate = endofmonth(loc_calcdate)
ENDDO

* ���ҧ���������ṹ��駧Ǵ
WAIT windows DTOC(loc_calcdate)+" - Make Summary" NOWAIT
SELECT newpvlog
mperiod = SUBSTR(DTOS(newpvlog.period),1,6)

cmd = "SELECT "
cmd = cmd + "mperiod as mperiod,"
cmd = cmd + "newpvlog.id"
cmd = cmd + ",SUM(newpvlog.in_a) as in_a"
cmd = cmd + ",SUM(newpvlog.in_b) as in_b"
cmd = cmd + ",SUM(newpvlog.in_c) as in_c "
cmd = cmd + ",SUM(newpvlog.newbs) as newbs "
cmd = cmd + "FROM newpvlog "
cmd = cmd + "GROUP BY newpvlog.id "
cmd = cmd + "INTO TABLE '"+ALLTRIM(fname)+"'"
&cmd

*SELECT ;
	SUBSTR(DTOS(newpvlog.period),1,6) as mperiod,;
	newpvlog.id,;
	SUM(newpvlog.in_a) as in_a,;
	SUM(newpvlog.in_b) as in_b,;
	SUM(newpvlog.in_c) as in_c ;
	FROM newpvlog ;
	GROUP BY newpvlog.id ;
	INTO TABLE &fname

CLOSE DATABASES all
RETURN
