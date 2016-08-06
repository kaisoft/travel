CLOSE DATABASES all
USE .\db\movement IN 0 ALIAS movement

SELECT id,tp,tripcount,ticket FROM movement WHERE tp>=160 INTO CURSOR tmp readwrite
SELECT tmp
GO top
DO WHILE .not. EOF()
	DO case
	CASE tripcount+1 >= 5 AND tp>=720
		nticket = 2
	CASE tripcount+1 >= 5 AND tp>=480 AND tp<720
		nticket = 1	
	CASE tripcount+1 >= 4 AND tp>=600
		nticket = 2
	CASE tripcount+1 >= 4 AND tp>=400 AND tp<600
		nticket = 1			
	CASE tripcount+1 >= 3 AND tp>=480
		nticket = 2
	CASE tripcount+1 >= 3 AND tp>=320 AND tp<480
		nticket = 1
	CASE tripcount+1 >= 2 AND tp>=360
		nticket = 2
	CASE tripcount+1 >= 2 AND tp>=240 AND tp<360
		nticket = 1
	CASE tripcount+1 >= 1 AND tp>=240
		nticket = 2
	CASE tripcount+1 >= 1 AND tp>=160 AND tp<240
		nticket = 1
	OTHERWISE
		nticket = 0
	ENDCASE
	replace ticket WITH nticket
	SKIP
ENDDO

UPDATE movement from tmp ;
	WHERE ALLTRIM(movement.id) == ALLTRIM(tmp.id) ;
	SET movement.ticket = tmp.ticket
