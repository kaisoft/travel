*�ѧ��������ҷ������դ�ṹ����ҡ��������¡����ա��� (�����Ҵ��ҧ,�ҡ 3 ���)
*
*�����˵� 
*   ��ͧ���������� answer ����͹���� passing arrau �»�С�� dimemsion answer(2) 
*   ����ѧ���¡��ѧ�������� �ѧ���蹨йӤӵͺ�������㹵���� answer ����������ѧ��ѧ���
*   answer(1) = ���ͷ�� , answer(2) = ��ṹ�ͧ��� 
*
*�ٻẺ�������¡��
*1) ���§������������ =midleg(400,300,500,@answer)
*2) �׹����繪��ͷ�� =midleg(400,300,500,@answer,1)
*2) �׹����繤�ṹ�ͧ��� =midleg(400,300,500,@answer,2)

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
