/* Aufgabe 5v */


libname  SDA_WDH  "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe5v\Daten" ;

ods rtf file="C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe5v\Aufgabe5v.rtf" style= EGDEfault ;


data U_6_1_Daten ;
input Job Gender Raucher Blutdruck Therapieerfolg Anzahl ;
datalines ;
0 1 0 1 0 3
0 1 0 1 1 3
0 1 0 0 0 6
0 1 0 0 1 9
0 1 0 -1 0 1
0 1 0 -1 1 7
0 1 1 1 0 12
0 1 1 1 1 1
0 1 1 0 0 3
0 1 1 0 1 3
0 1 1 -1 0 3
0 1 1 -1 1 9
0 2 0 1 0 6
0 2 0 1 1 11
0 2 0 0 0 1
0 2 0 0 1 7
0 2 0 -1 0 2
0 2 0 -1 1 11
0 2 1 1 0 9
0 2 1 1 1 7
0 2 1 0 0 1
0 2 1 0 1 1
0 2 1 -1 0 1
0 2 1 -1 1 3
1 1 0 1 0 2
1 1 0 1 1 10
1 1 0 0 0 1
1 1 0 0 1 3
1 1 0 -1 0 1
1 1 0 -1 1 13
1 1 1 1 0 9
1 1 1 1 1 1
1 1 1 0 0 9
1 1 1 0 1 13
1 1 1 -1 0 12
1 1 1 -1 1 12
1 2 0 1 0 3
1 2 0 1 1 14
1 2 0 0 0 9
1 2 0 0 1 11
1 2 0 -1 0 3
1 2 0 -1 1 7
1 2 1 1 0 11
1 2 1 1 1 7
1 2 1 0 0 1
1 2 1 0 1 1
1 2 1 -1 0 1
1 2 1 -1 1 2
2 1 0 1 0 3
2 1 0 1 1 7
2 1 0 0 0 9
2 1 0 0 1 9
2 1 0 -1 0 3
2 1 0 -1 1 9
2 1 1 1 0 7
2 1 1 1 1 3
2 1 1 0 0 2
2 1 1 0 1 1
2 1 1 -1 0 10
2 1 1 -1 1 10
2 2 0 1 0 12
2 2 0 1 1 13
2 2 0 0 0 1
2 2 0 0 1 17
2 2 0 -1 0 1
2 2 0 -1 1 3
2 2 1 1 0 13
2 2 1 1 1 1
2 2 1 0 0 3
2 2 1 0 1 3
2 2 1 -1 0 7
2 2 1 -1 1 9
;
run;

ods graphics on ;

title "Logist. Regression : Volles Modell" ;

proc logistic data= U_6_1_Daten outest=betas covout plots= all ;  

freq Anzahl ;
model Therapieerfolg(event='1') = Job Gender Raucher Blutdruck / details lackfit ;
/*
/ selection=stepwise
slentry=0.3
slstay=0.35
*/

output out=pred p=phat lower=lcl upper=ucl
predprob=(individual crossvalidate) ;
run ; quit;



title "Stepwise logistische Regression" ;

proc logistic data= U_6_1_Daten outest=BETAS covout plots= all ;  

freq Anzahl ;
model Therapieerfolg(event='1') = Job Gender Raucher Blutdruck / details lackfit EXPB CTABLE PPROB=(0.4 0.5 0.6) outroc=ROC_TABLE
selection=stepwise
slentry=0.3
slstay=0.35;

output out=PRED p=phat lower=lcl upper=ucl
predprob=(individual crossvalidate) ;
run ; quit;




proc print data= BETAS;
title2 'Parameter Estimates and Covariance Matrix';
run ;

proc print data= PRED;
title2 'Predicted Probabilities and 95% Confidence Limits';
run ;


proc print data=ROC_TABLE;
title2 'ROC-Table: Foundation of ROC Chart';
run ;

proc freq data=PRED;
weight Anzahl;
table _from_ _into_ ;
table _from_ * _into_ ;
title2 'Neutral Classification Table';
run ;


proc freq data=PRED ;
weight Anzahl;
table _from_ _into_ ;
table _into_ * _from_ ;
title2 'Neutral Classification Table2';
run ;



