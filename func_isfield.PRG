* ตรวจสอบว่ามีฟิลด์นี้ไหมใน table ปัจจุบัน
FUNCTION func_isfield
PARAMETERS lc_fieldname
IF type(lc_fieldname)="U"
	RETURN -1	&& ไม่มี
ELSE
	RETURN 1 && มี
ENDIF
ENDFUNC
