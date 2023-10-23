/* Aufgabe 7v Teil 2 */

libname DAN "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7u\Daten" ;  

ods rtf file="C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7v\Aufgabe7uTeil2.rtf" style= EGDEfault ;


/* LOG REG und dann DA */


data DAN.DEPRESS;
set DAN.DEPRESS;
run;

ods graphics on;

title "Logistische Regression: Volles Modell";

proc logistic data=DAN.DEPRESS descending covout plots=all;
model CASES = SEX AGE MARITAL EDUCAT EMPLOY INCOME RELIG DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL / 
details lackfit EXPB CTABLE PPROB=(0.4 0.5 0.6) outroc=ROC_TABLE selection=stepwise slentry=0.3 slstay=0.35;
	output out=PRED p=phat lower=lcl upper=ucl
predprob=(individual crossvalidate);
run; quit; 

proc print data=PRED; run; 


title "Aufgabe 7v Teil 2 - Logistische Regression: Confusion Matrix";

proc freq data=PRED;
table _from_ _into_;
table _into_ * _from_;
run;

