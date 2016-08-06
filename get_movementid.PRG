* procedure get_movementid.prg
* รวมรหัสสมาชิกที่มีความเคลื่อนไหว
PARAMETERS mperiod,clear_flag
CLOSE DATABASES all

* ตรวจสอบ parameter mperiod ที่ป้อนเข้ามา
IF CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))=CTOD("  /  /  ")
	MESSAGEBOX("Can't Get_Newpv Because Parameter [mperiod]='"+mperiod+"' Error!!",0+16,"Error")
	RETURN
ENDIF

* กำหนดค่าตัวแปรที่ดำเนินการ
loc_frmdate = CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))	&& วันที่เริ่มต้น
loc_todate = endofmonth(loc_frmdate)	&& วันที่สิ้นสุด
path_calcresult = "d:\aiyara_dbs\calc\result\"

* ตรวจสอบไฟล์เดิม / สร้างไฟล์ใหม่
path_db = SYS(5)+CURDIR()+"db\"
IF !directory(path_db)
	MD db	&& สร้าง directory db หากยังไม่มี
ENDIF
fname = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+".dbf"
fname_log = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+"_log.dbf"
fname_mid = path_db+"movement"

IF !EMPTY(clear_flag)
	IF (clear_flag)=1
		* ล้างข้อมูลรายชื่อสมาชิกที่มีความเคลื่อนไหวหาก clear_flag = 1
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

* หาคนที่มีความเคลื่อนไหวเพิ่มมาใหม่ไม่เอาคนที่บันทึกรหัสไว้แล้ว
USE &fname IN 0 ALIAS newpv
SELECT id FROM newpv WHERE id NOT in ( SELECT id FROM movement WHERE 1=1 ) INTO CURSOR tmp

WAIT windows ALLTRIM(mperiod)+" - movement id = "+ALLTRIM(STR(RECCOUNT("tmp"))) nowait
SELECT movement 
APPEND FROM DBF('tmp')

CLOSE DATABASES all
RETURN



