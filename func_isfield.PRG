* ��Ǩ�ͺ����տ�Ŵ������� table �Ѩ�غѹ
FUNCTION func_isfield
PARAMETERS lc_fieldname
IF type(lc_fieldname)="U"
	RETURN -1	&& �����
ELSE
	RETURN 1 && ��
ENDIF
ENDFUNC
