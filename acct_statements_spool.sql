set serveroutput on
set linesize 6000
set trims on
set feedback off
spool FIN_MD_ACCOUNT_STATEMENTS.lst

declare
out_retcode number(5):=0;
--out_retcode(50) :=0;
out_rec varchar2(32767);

BEGIN
LOOP

FIN_MD_ACCOUNT_STATEMENTS_NEW_PAK.FIN_MD_ACCOUNT_STATEMENTS_NEW_PRO('006836',out_retCode,out_rec);
IF (out_retcode = 0 ) THEN
 	dbms_output.put_line(out_rec);
ELSE
exit;

END IF;
END LOOP;
END;
/
--spool off