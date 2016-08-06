*ฟังก์ชั่นใช้ค้นหาทีมที่มีคะแนนไม่มากและไม่น้อยกว่าอีกทีม (ทีมขนาดกลาง,จาก 3 ทีม)
*
*หมายเหตุ 
*   ต้องเตรียมตัวแปร answer ไว้ก่อนเพื่อ passing arrau โดยประกาศ dimemsion answer(2) 
*   โดยหลังเรียกใช้ฟังก์ชั่นแล้ว ฟังก์ชั่นจะนำคำตอบไปใส่ไว้ในตัวแปร answer ให้ใช้ภายหลังได้ดังนี้
*   answer(1) = ชื่อทีม , answer(2) = คะแนนของทีม 
*
*รูปแบบบการเรียกใช้
*1) เรียงข้อมูลให้เฉยๆ =midleg(400,300,500,@answer)
*2) คืนค่าเป็นชื่อทีม =midleg(400,300,500,@answer,1)
*2) คืนค่าเป็นคะแนนของทีม =midleg(400,300,500,@answer,2)

PARAMETERS n_LegA,n_LegB,n_LegC,aLeg,returntype
IF EMPTY(returntype)
	returntype=0
ENDIF

DIMENSION ar_leg(3,2)
ar_leg(1,1)="A"
ar_leg(1,2)=n_LegA
ar_leg(2,1)="B"
ar_leg(2,2)=n_LegB
ar_leg(3,1)="C"
ar_leg(3,2)=n_LegC

*CLEAR
*DISPLAY MEMORY LIKE ar_leg

ASORT(ar_leg,2)
*DISPLAY MEMORY LIKE ar_leg

aLeg(1)=ar_leg(2,1)
aLeg(2)=ar_leg(2,2)

*DISPLAY MEMORY LIKE aleg

DO CASE
CASE returntype=1
	RETURN aLeg(1)
CASE returntype=2
	RETURN aLeg(2)
OTHERWISE
	RETURN	
ENDCASE 

RETURN
