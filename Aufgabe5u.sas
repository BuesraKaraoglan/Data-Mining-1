/* Aufgabe 5u */

options nodate pageno=1 ;

libname DANA "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe5u\Daten" ;  

ods rtf file="C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe5u\Aufgabe5u.rtf" style= EGDEfault ;


/* MLR: Y = B0 + B1*X1 + B2*x" + E */

/* Logistic Model: ln(P/(1-P)) = B0 + B1*X1 + B2*X2 */

/* Odds: P/(1-P) = e^(B0 + B1*X1 + B2*X2) */

/* Probability: P(1-P) = e^(B0 + B1*X1 + B2*X2) */



data DANA.ASPESS_2  ;
 set DANA.ASPESS    ;
BuDef = min(B1-1,1) ;
if BuDef >= 0 ;
run ;


proc sort data=DANA.ASPESS_2;
by BuDef;
run;

title "Boxplot" ;


proc boxplot data=DANA.ASPESS_2;
plot AL*BuDef;
/* 
inset min mean max stddev /
	header = 'Overall Statistics'
	pos = tm;
insetgroup min max /
	header = 'Extremes by Day';
*/
run;


proc boxplot data=DANA.ASPESS_2;
plot HU*BuDef;
run;

proc boxplot data=DANA.ASPESS_2;
plot HO*BuDef;
run;



title "Log. Regression for Beginners - Spessart (SAS)" ;

ODS graphics;

proc logistic data= DANA.ASPESS_2 descending Plots=ALL; 
 model  BuDef = Ng Ho Al Bs Bt Du Hu PHo ;  
 output out=predicted  p=p ;       
run ; quit ; proc print data= predicted ; run ;

/* model  BuDef(event='1') = Ng Ho Al Bs Bt Du Hu PHo ; */ 



title "Log. Regression for Beginners - Spessart, stepwise (SAS)" ;

proc logistic data= DANA.ASPESS_2 descending Plots=ALL ; /* slentry= 0.05  by default  */
 model  BuDef = Ng Ho Al Bs Bt Du Hu PHo / selection= forward slentry= 0.10 ;  
 output out=predicted  p=p ;       
run ; quit ; proc print data= predicted ; run ;

/* model  BuDef(event='1') = Ng Ho Al Bs Bt Du Hu PHo ; */ 


title "PROBE" ;

proc logistic data=DANA.ASPESS_2 descending covout plots=all;
 model  BuDef = Ng Ho Al Bs Bt Du Hu PHo / 
details lackfit EXPB CTABLE PPROB=(0.5) outroc=ROC_TABLE selection= forward slentry= 0.10;
	output out=PRED p=phat lower=lcl upper=ucl
predprob=(individual crossvalidate);
run; quit; 

proc print data=PRED; run; 


proc freq data=PRED;
table _from_ _into_;
table _into_ * _from_;
run;



title "Erweiterungen" ;


* nach zu große intervall für pho wird das nun rausgeschmissen; 

proc logistic data= DANA.ASPESS_2 descending Plots=ALL ; 
 model  BuDef = Al Bs Du Hu  ;  
 output out=predicted  p=p ;       
run ; quit ; proc print data= predicted ; run ;


* anscheinend sind nur AL und BS signifikant genug - nach odds wald ;

proc logistic data= DANA.ASPESS_2 descending Plots=ALL ; 
 model  BuDef = Al Bs ;  
 output out=predicted  p=p ;       
run ; quit ; proc print data= predicted ; run ;





ods rtf close ;








