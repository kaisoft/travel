* Function EndOfMonth
* Use For : Find Last Date of the Month
* Last Update : 28/07/2016
FUNCTION EndOfMonth
	PARAMETERS loc_D_calcdate
	next_month = IIF(MONTH(loc_D_calcdate)+1>12,1,MONTH(loc_D_calcdate)+1)
	next_year = IIF(MONTH(loc_D_calcdate)+1>12,YEAR(loc_D_calcdate)+1,year(loc_D_calcdate))	
	RETURN CTOD("1/"+ALLTRIM(STR(next_month))+"/"+ALLTRIM(STR(next_year)))-1
ENDFUNC
