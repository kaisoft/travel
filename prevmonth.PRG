* Function PrevMonth
* Use For : Find First Date of Previos Month
* Last Update : 28/07/2016
FUNCTION PrevMonth
	PARAMETERS loc_D_calcdate
	prev_month = IIF(MONTH(loc_D_calcdate)=1,12,MONTH(loc_D_calcdate)-1)
	prev_year = IIF(MONTH(loc_D_calcdate)=1,YEAR(loc_D_calcdate)-1,year(loc_D_calcdate))	
	RETURN CTOD("1/"+ALLTRIM(STR(prev_month))+"/"+ALLTRIM(STR(prev_year)))
ENDFUNC
