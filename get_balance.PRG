* procedure get_balance.prg
* �����ṹ¡�Ңͧ��������ʹ��ṹ����͹��� (�ѹ�֡����� movement.dbf)
PARAMETERS mperiod

* ��Ǩ�ͺ parameter mperiod ����͹�����
IF CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))=CTOD("  /  /  ")
	MESSAGEBOX("Can't Get_Newpv Because Parameter [mperiod]='"+mperiod+"' Error!!",0+16,"Error")
	RETURN
ENDIF

* ��˹���ҵ���÷����Թ���
loc_frmdate = CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))	&& �ѹ����������
loc_todate = endofmonth(loc_frmdate)	&& �ѹ�������ش
path_db = SYS(5)+CURDIR()+"db\"
path_calcresult = "d:\aiyara_dbs\calc\result\"

* ��Ǩ�ͺ����������������
fname_result = path_calcresult+SUBSTR(DTOS(loc_todate),1,6)+"\"+DTOS(loc_todate)+"\result.dbf"
fname_movement = path_db+"movement.dbf"
IF !FILE(fname_result)
	MESSAGEBOX("Can't get_balance Because filename ['"+fname_result +"'] not found!!",0+16,"Error")
	RETURN
ENDIF
IF !FILE(fname_movement )
	MESSAGEBOX("Can't get_balance Because filename ['"+fname_movement +"'] not found!!",0+16,"Error")
	RETURN
ENDIF

WAIT windows "get_balance for "+DTOS(loc_todate) NOWAIT
* �Դ������ͧ���
CLOSE DATABASES all
USE &fname_result IN 0 ALIAS lastperiod
USE &fname_movement IN 0 ALIAS movement

* ������Ŵ������
SELECT movement
IF func_isfield("bal_a")=-1
	ALTER table ALIAS() add COLUMN bal_a n(15)
ENDIF
IF func_isfield("bal_b")=-1
	ALTER table ALIAS() add COLUMN bal_b n(15)
ENDIF
IF func_isfield("bal_c")=-1
	ALTER table ALIAS() add COLUMN bal_c n(15)
ENDIF

* ����
SELECT id,out_a , out_b , out_c ;
	FROM lastperiod ;
	WHERE out_a+out_b+out_c <>0 ;
	AND id in (SELECT id FROM movement WHERE 1=1) ;
	INTO CURSOR tmp READWRITE

* ��ͧ��������੾�Т�ⵢ�����
SELECT tmp
UPDATE tmp SET out_b = 0, out_c = 0 WHERE out_a = MAX(out_a,out_b,out_c)
UPDATE tmp SET out_a = 0, out_c = 0 WHERE out_b = MAX(out_a,out_b,out_c)
UPDATE tmp SET out_a = 0, out_b = 0 WHERE out_c = MAX(out_a,out_b,out_c)

* �ѹ�֡��
UPDATE movement SET bal_a = 0 , bal_b = 0 , bal_c = 0 WHERE 1=1
UPDATE movement ;
	FROM tmp ;
	WHERE movement.id = tmp.id ;
	SET ;
		movement.bal_a = tmp.out_a ,;
		movement.bal_b = tmp.out_b ,;
		movement.bal_c = tmp.out_c

CLOSE DATABASES ALL
