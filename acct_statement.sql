------------------------------------------------------------------
---PACKAGE CREATION-----------
------------------------------------------------------------------


CREATE OR REPLACE PACKAGE FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK AS
PROCEDURE FIN_MD_ACCOUNT_STATEMENTS_NEW_PRO(inp_str IN varchar2,out_retCode OUT Number,out_rec OUT varchar2);
END FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK;

------------------------------------------------------------------
--PACKAGE BODY CREATION----
------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK AS
outArr  basp0099.ArrayType;

--v_sol_id                        tbaadm.gam.sol%type
v_foracid                         varchar2(16);
v_acct_name                       varchar2(100);
v_sol_id                          varchar2(50);
v_acct_crncy_code                 varchar2(16);
v_schm_code	                      varchar2(16);
v_schm_type                       varchar2(16);
v_address_line1                   varchar2(100);
v_clr_bal_amt                     number(20,4);
v_cifId                           varchar2(15);
v_from_date		      	          date;
v_to_date		                  date;
v_ts_cnt                          number(20,4);

---------------------------------------------------------
--CURSOR------
---------------------------------------------------------

Cursor P (v_cifId varchar2) is

SELECT foracid, acct_name,acct_crncy_code,schm_code,schm_type,address_line1, clr_bal_amt,from_date,to_date, ts_cnt
            
FROM   TBAADM.GAM
WHERE  cif_id =v_cifId  AND ROWNUM < 25;

---------------------------------------------------------
---PROCEDURE AND INPUTS DECLARATION--
---------------------------------------------------------

PROCEDURE FIN_MD_ACCOUNT_STATEMENTS_NEW_PRO(inp_str IN varchar2,out_retCode OUT Number,out_rec OUT varchar2) AS

BEGIN

--{

        out_retCode :=0;
        basp0099.formInputarr(inp_str,outArr);

        
        v_cifId	  := outArr(0);
	v_from_date       := outArr(1);
	v_to_date	  := outArr(2);
	v_from_date       := to_date(outArr(1),'dd-mm-yyyy');
	v_to_date         := to_date(outArr(2),'dd-mm-yyyy');

        IF(NOT P%ISOPEN)THEN
        --{
              OPEN P(v_cifId);
        --}
        END IF;

        IF(P%ISOPEN) THEN
        --{
              FETCH P INTO

                v_foracid,
                v_acct_name,
                v_sol_id,
                v_acct_crncy_code,
                v_schm_code,
                v_schm_type,
                v_clr_bal_amt,
                v_cifId,
                v_from_date,
                v_to_date;
	
        --}
        END IF;

-------------------------
--BRANCH NAME
------------------------

Begin
{
       Select  sol_desc
       Into    v_br_name
       From    tbaadm.sol
       Where   sol_id = v_sol_id
       And     del_flg = 'N';

       Exception When No_Data_Found Then
       v_br_name       :='';
}
End;

----------------------FETCHING OUTPUTS-----------------------------------------------------


IF(P%FOUND)THEN
--{
                OUT_REC :=(

                        v_foracid                          ||'|'||
                        v_acct_name                        ||'|'||
                        v_sol_id                           ||'|'||
                        v_acct_crncy_code                  ||'|'||
                        v_schm_code                        ||'|'||
                        v_schm_type                        ||'|'||
                        v_clr_bal_amt                      ||'|'||
                        v_cifId                            ||'|'||
                        v_from_date                        ||'|'||
                        v_to_date                          ||'|'||             
                                        
       
	                  );
--{
ELSE
--}
                        CLOSE P;
                        out_retCode :=1;
                        return;
--}
END IF;

END FIN_MD_ACCOUNT_STATEMENTS_NEW_PRO;
END FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK;
/
Grant Execute On FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK to tbagen,tbautil,tbaadm,custom
/
DROP  PUBLIC SYNONYM FIN_MD_ACCOUNT_STATEMENTS
/
CREATE PUBLIC SYNONYM FIN_MD_ACCOUNT_STATEMENTS FOR FIN_MD_ACCOUNT_STATEMENTS
/
--GRANT ALL ON FIN_BANK_NEW_PAK  to tbagen,tbautil,system,tbaadm,custom
GRANT ALL ON FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK  to tbagen,tbautil,custom
/
show err

