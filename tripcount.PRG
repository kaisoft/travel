CLOSE DATABASES all
IF !FILE('tripcount.csv')
	sqlcmd = "SELECT `id`,sum(1) as tripcount FROM `trip_detail` GROUP BY `id`;"
	WAIT WINDOWS ;
		"do '"+sqlcmd+"'"+CHR(13)+;
		"and save to 'tripcount.csv'"
	RETURN
ENDIF

ERASE .\db\tripcount.dbf
CREATE TABLE .\db\tripcount.dbf (;
	id c(15),;
	tripcount n(5))
APPEND FROM tripcount.csv TYPE DELIMITED
USE

USE .\db\tripcount IN 0 ALIAS tripcount
USE .\db\movement IN 0 ALIAS movement
UPDATE movement ;
	FROM tripcount ;
	WHERE ALLTRIM(movement.id) == ALLTRIM(tripcount.id) ;
	SET movement.tripcount = tripcount.tripcount

CLOSE DATABASES all	
