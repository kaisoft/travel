CLOSE DATABASES ALL

fname_inv = "d:\aiyara_dbs\calc\inv.dbf"
fname_tact = "d:\aiyara_dbs\calc_v2\travel\db\tactive"
monthly_maintain_pv = 250
IF !FILE(fname_inv )
	MESSAGEBOX("Can't get_balance Because filename ['"+fname_inv+"'] not found!!",0+16,"Error")
	RETURN
ENDIF

* ลบไฟล์ tactive เดิม
ERASE fname_tact+".dbf"
ERASE fname_tact+".cdx"
ERASE fname_tact+".bak"	

CREATE TABLE &fname_tact (;
	invdate d(8),;
	invid n(15),;
	id c(15),;
	balpv n(5),;
	newpv n(5),;
	postpv n(5),;
	chgflag l(1),;
	active_to d(8))
	
USE
USE &fname_tact IN 0 ALIAS t_act
SELECT t_act
INDEX on id TAG id

USE &fname_inv IN 0 ALIAS inv
SELECT * FROM inv WHERE invtype = 4 INTO CURSOR inv_tactive

* หาวันที่เริ่มต้นและสิ้นสุด
SELECT inv_tactive
CALCULATE min(date) TO min_date
CALCULATE max(date) TO max_date
FOR iyear = YEAR(min_date) TO YEAR(max_date)
	FOR imonth = MONTH(min_date) TO MONTH(max_date)
		WAIT windows "Process T-Active Invoice "+ALLTRIM(STR(imonth))+"/"+ALLTRIM(STR(iyear)) NOWAIT
		SELECT * FROM inv WHERE invtype = 4 AND YEAR(date)=iyear AND MONTH(date)=imonth INTO CURSOR inv_tactive
		*BROWSE TITLE ALLTRIM(STR(imonth))+"/"+ALLTRIM(STR(iyear))
		SELECT inv_tactive
		GO TOP
		DO WHILE .not. EOF()
			*IF inv_tactive.invid = 449243
			*	SUSPEND
			*ENDIF
			
			* หายอดยกมา (ถ้ามี) เพื่อเตรียมสถานะไว้วางลงใน table
			SELECT * FROM t_act WHERE id=inv_tactive.id AND invid = (SELECT MAX(invid) FROM t_act WHERE id=inv_tactive.id) INTO CURSOR mybalance
			IF RECCOUNT("mybalance")<>0
				*m_balpv = IIF(!chgflag,mybalance.postpv,0)
				m_balpv = mybalance.postpv
				m_activeto = mybalance.active_to
			ELSE 
				m_balpv = 0
				m_activeto = CTOD("  /  /  ")
			ENDIF
			* เตรียมสถานะอื่นๆเพิ่มเติม
			m_invid = inv_tactive.invid
			m_newpv = inv_tactive.gtpv
			m_postpv = m_balpv + m_newpv 			
			
			IF m_postpv < monthly_maintain_pv
			
				* คะแนนไม่ครบ สะสมไปก่อน
				SELECT t_act
				APPEND BLANK
				replace ;
					invdate WITH inv_tactive.date ,;
					invid WITH m_invid ,;
					id WITH inv_tactive.id ,;
					balpv WITH m_balpv ,;
					newpv WITH m_newpv ,;
					postpv WITH m_postpv ,;
					active_to WITH m_activeto ,;
					chgflag WITH .f.
			ELSE
			
				* คะแนนครบ บันทึกการ active
				DO WHILE m_postpv >= monthly_maintain_pv
					m_activeto = IIF(m_activeto=CTOD("  /  /  ") or m_activeto<inv_tactive.date,endofmonth(inv_tactive.date),endofmonth(nextmonth(m_activeto)))
					m_postpv = m_postpv - monthly_maintain_pv
					
					* เพิ่ม record ใหม่
					SELECT t_act
					APPEND BLANK
					replace ;
						invdate WITH inv_tactive.date ,;
						invid WITH m_invid ,;
						id WITH inv_tactive.id ,;
						balpv WITH m_balpv ,;
						newpv WITH m_newpv ,;
						postpv WITH m_postpv ,;
						active_to WITH m_activeto ,;
						chgflag WITH .t.
						
					* ปรับข้อมูลสำหรับการบันทึกสถานะรอบเดือนใหม่
					m_newpv = 0
					m_balpv = m_postpv
					m_invid = m_invid+1
				ENDDO 

			ENDIF
			
			SELECT inv_tactive
			SKIP
		ENDDO	
	NEXT imonth
NEXT iyear

SELECT t_act
CLOSE DATABASES all

