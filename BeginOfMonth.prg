* Function BeginOfMonth
* Use For : Find First Date of the Month
* Last Update : 28/07/2016
FUNCTION BeginOfMonth
	PARAMETERS loc_D_calcdate
	RETURN CTOD("1/"+ALLTRIM(STR(MONTH(loc_D_calcdate)))+"/"+ALLTRIM(STR(YEAR(loc_D_calcdate))))
ENDFUNC
