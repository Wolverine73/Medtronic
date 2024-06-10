
libname specslib "\\data\Pace\PSR_statistics\Neuro\Reports\Clinical_Reports\PSTM\Documents\ADaM\specsLib";
libname srcolx   "\\data\Pace\PSR_statistics\Neuro\Reports\Clinical_Reports\PSTM\Data\OLXPAN";


/***********************************************************************************************************
Step 1. OLX condition assignment
************************************************************************************************************/
data ca;
set specslib.adslshell(where=(astudyid^=' ')) srcolx.RD_CONDITION_ASSIGNMENT (where=(armname= 'Pain_Stim_Arm_5') drop=siteid sitename);

	ASTUDYID='PSTM';
	STUDYID='OLX.AVAIL.' || "PSTM";
	SRC_USUBJID='OLX.AVAIL.' || "PSTM" || '.' || SUBJECTNUMBERSTR;
	USUBJID	   ='OLX.AVAIL.' || "PSTM" || '.' || SUBJECTNUMBERSTR;
	SUBJID=SUBJECTNUMBERSTR;
	SITEID=put(SITE_NUMBER, 8.);
	keep ASTUDYID STUDYID SRC_USUBJID  USUBJID SUBJID SITEID subjectnumberstr;
run;

data RD_CONDITION_ASSIGNMENT;
set srcolx.RD_CONDITION_ASSIGNMENT;
run;
data adslshell;
set specslib.adslshell;
run;
data RD_ELIGIBILITY;
set Srcolx.RD_ELIGIBILITY;
run;


proc sql;
create table xx as
select armname, count(*) as cnt
from x
group by armname
order by armname;
quit;

proc contents data = y;
run;

proc sql;
connect to oracle (USER=stropb2 PASS="Bss101699" PATH=LSH1.CORP.MEDTRONIC.COM); 
create table m_dm as 
select * from connection to oracle (
	select * 
	from ba_pan_sdtm_prd.m_dm
);
disconnect from oracle;
quit;


