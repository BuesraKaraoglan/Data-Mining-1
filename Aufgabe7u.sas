/* Aufgabe 7u */


libname DAN "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7u\Daten" ;  

ods rtf file="C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7u\Aufgabe7u.rtf" style= EGDEfault ;


/* LOG REG und dann DA */


data DAN.DEPRESS;
set DAN.DEPRESS;
run;

ods graphics on;

title "Logistische Regression: Volles Modell";

proc logistic data=DAN.DEPRESS descending plots=all;
model CASES = SEX AGE MARITAL EDUCAT EMPLOY INCOME RELIG DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL;
	output out=predicted p=p;
run; quit; proc print data=predicted; run; 

title "Logistische Regression: Reduziertes Modell";

proc logistic data=DAN.DEPRESS descending plots=all;
model CASES = SEX INCOME RELIG BEDDAYS;
	output out=predicted p=p;
run; quit; proc print data=predicted; run; 


title "Diskriminanzanalyse mit DISCRIM: Volles Modell";

proc discrim data= DAN.DEPRESS outstat=DEPR_Stat out= Out_Disc_DEPR
             method=normal pool=yes 
             list crossvalidate    ; 
   class CASES ; 
   priors prop ; 
   *id xvalues ; 
   var SEX AGE MARITAL EDUCAT EMPLOY INCOME RELIG DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL ;  
run ; 


title "Diskriminanzanalyse mit DISCRIM: Reduziertes Modell";

proc discrim data= DAN.DEPRESS outstat=DEPR_Stat out= Out_Disc_DEPR
             method=normal pool=yes 
             list crossvalidate    ; 
   class CASES ; 
   priors prop ; 
   *id xvalues ; 
   var SEX INCOME RELIG BEDDAYS;  
run ; 


title "Diskriminanzanalyse mit CANDISC: Volles Modell";

proc candisc data= DAN.DEPRESS out=Out_Can_DEPR distance anova all ;
   class CASES ;
   var SEX AGE MARITAL EDUCAT EMPLOY INCOME RELIG DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL ;  
run ;



title "Diskriminanzanalyse mit CANDISC: Reduziertes Modell";

proc candisc data= DAN.DEPRESS out=Out_Can_DEPR distance anova all ;
   class CASES ;
      var SEX INCOME RELIG BEDDAYS;  
run ;





title "Sind Frauen depressiver?";


 data WORK.DEPRESS_TAB_1  ;
    input
    SEX $ DEPRESSION_NEU $  ANZAHL ;
    datalines ;
    F    JA     40
    F    NEIN  143
    M    JA     10
    M    NEIN  101
    ;


    PROC FREQ  DATA= WORK.DEPRESS_TAB_1   ORDER=DATA     ;
    TABLES  SEX * DEPRESSION_NEU  / ALL ;  WEIGHT ANZAHL  ;
    EXACT PCHI CHISQ FISHER ;

    RUN ;  QUIT ;

	PROC FREQ  DATA= WORK.DEPRESS_TAB_1   ORDER=DATA     ;
    TABLES  DEPRESSION_NEU * SEX  / ALL ;  WEIGHT ANZAHL  ;
    EXACT PCHI CHISQ FISHER ;

    RUN ;  QUIT ;