* procedure get_movementid.prg
* ���������Ҫԡ����դ�������͹���
PARAMETERS mperiod,clear_flag
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
fname_mid = path_db+"movement"

IF !EMPTY(clear_flag)
	IF (clear_flag)=1
		* ��ҧ��������ª�����Ҫԡ����դ�������͹����ҡ clear_flag = 1
		ERASE fname_mid+".dbf"
		ERASE fname_mid+".cdx"
		ERASE fname_mid+".bak"
	ENDIF
ENDIF

IF !FILE(fname_mid+".dbf")
	CREATE table &fname_mid (id c(15),name c(35))
ELSE
	USE &fname_mid IN 0
ENDIF

* �Ҥ�����դ�������͹������������������Ҥ����ѹ�֡�����������
USE &fname IN 0 ALIAS newpv
SELECT id FROM newpv WHERE id NOT in ( SELECT id FROM movement WHERE 1=1 ) INTO CURSOR tmp

WAIT windows ALLTRIM(mperiod)+" - movement id = "+ALLTRIM(STR(RECCOUNT("tmp"))) nowait
SELECT movement 
APPEND FROM DBF('tmp')

CLOSE DATABASES all
RETURN



