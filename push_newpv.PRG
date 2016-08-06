* procedure push_newpv
* รวมคะแนนจากแต่ละงวดเดือนลงในmovement.dbf
PARAMETERS mperiod

* ตรวจสอบ parameter mperiod ที่ป้อนเข้ามา
IF CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))=CTOD("  /  /  ")
	MESSAGEBOX("Can't Get_Newpv Because Parameter [mperiod]='"+mperiod+"' Error!!",0+16,"Error")
	RETURN
ENDIF

* กำหนดค่าตัวแปรที่ดำเนินการ
loc_frmdate = CTOD("01/"+SUBSTR(mperiod,5,2)+"/"+SUBSTR(mperiod,1,4))	&& วันที่เริ่มต้น
loc_todate = endofmonth(loc_frmdate)	&& วันที่สิ้นสุด
path_db = SYS(5)+CURDIR()+"db\"
path_calcresult = "d:\aiyara_dbs\calc\result\"
fname_tact = path_db+"tactive.dbf"	&& ข้อมูลการทำ t_active แต่ละงวดเดือน
fname_calcdate = path_calcresult+SUBSTR(DTOS(loc_todate),1,6)+"\"+DTOS(loc_todate)+"\result.dbf"	&& หาสถานะ personal active 

* ตรวจสอบไฟล์มีอยู่หรือไม่
fname_newpv = path_db+SUBSTR(DTOS(loc_todate),1,4)+"\"+SUBSTR(DTOS(loc_todate),1,6)+".dbf"
fname_movement = path_db+"movement.dbf"
IF !FILE(fname_newpv )
	MESSAGEBOX("Can't get_balance Because filename ['"+fname_newpv +"'] not found!!",0+16,"Error")
	RETURN
ENDIF
IF !FILE(fname_movement)
	MESSAGEBOX("Can't fname_movement Because filename ['"+fname_movement +"'] not found!!",0+16,"Error")
	RETURN
ENDIF
IF !FILE(fname_calcdate)
	MESSAGEBOX("Can't fname_calcdate Because filename ['"+fname_calcdate+"'] not found!!",0+16,"Error")
	RETURN
ENDIF

WAIT windows "push_newpv with "+dtos(loc_todate) NOWAIT

* เปิดไฟล์ที่ต้องการ
CLOSE DATABASES all
USE &fname_newpv IN 0 ALIAS newpv
USE &fname_movement IN 0 ALIAS movement

* เพิ่มฟิลด์ที่จำเป็นลงใน movement
SELECT movement

* sum all newpv
field_all_bs = "new_bs"
field_all_a = "new_a"
field_all_b = "new_b"
field_all_c = "new_c"
IF func_isfield(field_all_bs)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_all_bs+" n(5)"
	&cmd
ENDIF
IF func_isfield(field_all_a)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_all_a+" n(15)"
	&cmd
ENDIF
IF func_isfield(field_all_b)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_all_b+" n(15)"
	&cmd
ENDIF
IF func_isfield(field_all_c)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_all_c+" n(15)"
	&cmd
ENDIF

field_mtleg = "mtleg"
field_mtpv = "mtpv"
IF func_isfield(field_mtleg)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_mtleg+" c(1)"
	&cmd
ENDIF
IF func_isfield(field_mtpv)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_mtpv+" n(15)"
	&cmd
ENDIF

field_tp = "tp"
field_tripcount = "tripcount"
field_ticket = "ticket"
IF func_isfield(field_tp)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_tp+" n(10)"
	&cmd
ENDIF
IF func_isfield(field_tripcount)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_tripcount+" n(5)"
	&cmd
ENDIF
IF func_isfield(field_ticket)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_ticket+" n(5)"
	&cmd
ENDIF

* เพิ่มฟืลด์ของแต่ละเดือน
*กำหนดชื่อฟิลด์ (แยกเดือน)
field_in_a = "a_"+mperiod
field_in_b = "b_"+mperiod
field_in_c = "c_"+mperiod
field_pact = "p_"+mperiod
field_tact = "t_"+mperiod
field_bs = "bs_"+mperiod

IF func_isfield(field_in_a)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_in_a+" n(15)"
	&cmd
ENDIF
IF func_isfield(field_in_b)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_in_b+" n(15)"
	&cmd
ENDIF
IF func_isfield(field_in_c)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_in_c+" n(15)"
	&cmd
ENDIF
IF func_isfield(field_pact)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_pact+" l(1)"
	&cmd
ENDIF
IF func_isfield(field_tact)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_tact+" l(1)"
	&cmd
ENDIF
IF func_isfield(field_bs)=-1
	cmd = "ALTER table ALIAS() add COLUMN "+field_bs+" n(5)"
	&cmd
ENDIF

* update newpv ในงวดเดือน
cmd = "UPDATE movement "
cmd = cmd + "FROM newpv "
cmd = cmd + "WHERE ALLTRIM(movement.id) == ALLTRIM(newpv.id) "
cmd = cmd + "SET "
cmd = cmd + "movement."+field_in_a+" = newpv.in_a "
cmd = cmd + ",movement."+field_in_b+" = newpv.in_b "
cmd = cmd + ",movement."+field_in_c+" = newpv.in_c "
cmd = cmd + ",movement."+field_bs+" = newpv.newbs"
&cmd

*Update tact
USE &fname_tact IN 0 ALIAS t_act_all
SELECT id,.t. as active,active_to FROM t_act_all ;
	WHERE MONTH(active_to) = MONTH(loc_todate) ;
	AND YEAR(active_to)=YEAR(loc_todate)  ;
	INTO CURSOR t_act_this
cmd = "UPDATE movement "
cmd = cmd + "FROM t_act_this "
cmd = cmd + "WHERE ALLTRIM(movement.id) == ALLTRIM(t_act_this.id) "
cmd = cmd + "SET movement."+field_tact+" = t_act_this.active "
&cmd
SELECT t_act_all
USE

* update p_act
USE &fname_calcdate IN 0 ALIAS result
SELECT id,active,qualifyd ;
	FROM result ;
	WHERE active AND qualifyd>=loc_todate ;
	AND id in ( SELECT id FROM newpv WHERE 1=1) ;
	INTO CURSOR p_act_this
cmd = "UPDATE movement "
cmd = cmd + "FROM p_act_this "
cmd = cmd + "WHERE ALLTRIM(movement.id) == ALLTRIM(p_act_this.id) "
cmd = cmd + "SET movement."+field_pact+" = p_act_this.active "
&cmd
SELECT result

*Update จำนวน Newbasic
SELECT movement
cmd = "REPLACE ALL "+field_all_bs+" WITH "+field_all_bs+"+"+field_bs
&cmd

*Update ผลรวม newpv เฉพาะที่ p_active และ t_active
SELECT * FROM newpv ;
	WHERE ;
	id in (SELECT id FROM t_act_this WHERE 1=1) ;
	AND id in (SELECT id FROM p_act_this WHERE 1=1) ;
	INTO CURSOR newpv_active	
cmd = "UPDATE movement "
cmd = cmd + "FROM newpv_active "
cmd = cmd + "WHERE ALLTRIM(movement.id) == ALLTRIM(newpv_active.id) "
cmd = cmd + "SET "
cmd = cmd + "movement."+field_all_a+" = movement."+field_all_a+"+newpv_active.in_a "
cmd = cmd + ",movement."+field_all_b+" = movement."+field_all_b+"+newpv_active.in_b "
cmd = cmd + ",movement."+field_all_c+" = movement."+field_all_c+"+newpv_active.in_c "
&cmd

SELECT newpv
USE
SELECT t_act_this
USE
SELECT p_act_this
USE
SELECT newpv_active
USE

CLOSE DATABASES ALL
