/* Aufgabe 7v */

*Aufgabe 7v Margarine;

libname EMD  "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7v\Daten" ;

options ps= 6000 ls= 82 pageno=1 ;

ods rtf file= "C:\Users\Büsra\Desktop\Karaoglan_DM\Data Mining Teil 1\Aufgabe7v\Aufgabe7vTeil1.rtf" style= EGDEFAULT ;
ods graphics on ;

 /*************************************************************** */ 
 /*          HELM   S A M P L E   L I B R A R Y                   */ 
 /*          DISKRIMINANZ_2016_A.sas                              */ 
 /*    NAME: MARGARINE_1                                          */ 
 /*   TITLE: Kanonische Komponenten Analyse mit PROC CANDISC      */ 
 /*   TITLE: Lineare Diskriminanzanalyse(Fisher) mit PROC DISCRIM */ 
 /*    DATA: MARGARINE Daten aus Backhaus et al: MVA Methoden     */ 
 /*************************************************************** */ 
title ; title2 ;
 
data EMD.MARGARINE_1  ;
input NR  MARKE $ STREICH_F  HALTBAR_K ;
datalines ;
 1  A  2  3
 2  A  3  4
 3  A  6  5
 4  A  4  4
 5  A  3  2
 6  A  4  7
 7  A  3  5
 8  A  2  4
 9  A  5  6
10  A  3  6
11  A  3  3
12  A  4  5
13  B  5  4
14  B  4  3
15  B  7  5
16  B  3  3
17  B  4  4
18  B  5  2
19  B  4  2
20  B  5  5
21  B  6  7
22  B  5  3
23  B  6  4
24  B  6  6
;
run ;



title "Logistische Regression: Volles Modell";

proc logistic data=EMD.MARGARINE_1 descending plots=all;
model MARKE = STREICH_F  HALTBAR_K ;
	output out=predicted p=p;
run; quit; proc print data=predicted; run; 




title "Logistische Regression: Reduziertes Modell";

proc logistic data=EMD.MARGARINE_1 descending plots=all;
model MARKE = STREICH_F;
	output out=predicted p=p;
run; quit; proc print data=predicted; run; 



title 'MARGARINE Daten' ; 
proc means data= EMD.MARGARINE_1 ;
 var STREICH_F  HALTBAR_K ; 
  by MARKE ;
run ;

symbol v=dot height=2  width=2 ;

title 'MARGARINE Daten: Basis Plots' ; 
proc gplot data= EMD.MARGARINE_1 ;    
      plot STREICH_F * HALTBAR_K = MARKE ; 
      plot HALTBAR_K * STREICH_F = MARKE ;  
run ;


title 'Hauptkomponenten Analyse der MARGARINE Daten: PCA Plot' ; 
proc princomp data= EMD.MARGARINE_1 out=Out_Prin_MARGA plots=all ;
   var STREICH_F  HALTBAR_K ;  
    id MARKE ;
run ;


title 'Diskriminanz  Analyse der MARGARINE Daten: Can Plot' ; 
proc candisc data= EMD.MARGARINE_1 out=Out_Can_MARGA distance anova all ;
   class MARKE ;
   var STREICH_F  HALTBAR_K ;  
run ;

data Out_Can_MARGA ;
 set Out_Can_MARGA ;
 Can2 = +0.1 ;
 if MARKE='B' then Can2= -0.1 ;
 run ;

proc template ;
   define statgraph SCATTER ;
      begingraph ;
         entrytitle 'MARGARINE Daten' ;
         layout overlayequated / equatetype=fit
            xaxisopts=(label='Canonical Variable 1' griddisplay=on)
            yaxisopts=(label='Canonical Variable 2') ;
            scatterplot x=Can1 y=Can2 / group=MARKE name='MARGA' ;
            layout gridded / autoalign=(topleft) ;
               discretelegend 'MARGA' / border=false opaque=false ;
            endlayout ;
         endlayout ;
      endgraph ;
   end ;
run;

proc sgrender data=Out_Can_MARGA template=SCATTER ;
run;


title 'Diskriminanz  Analyse der MARGARINE Daten: Discrim' ; 
proc discrim data=  EMD.MARGARINE_1 outstat=MARGA_Stat out= Out_Disc_MARGA
             method=normal pool=yes 
             list crossvalidate    ; 
   class MARKE ; 
   priors prop ; 
   *id xvalues ; 
   var STREICH_F  HALTBAR_K ;  
   title2 'Lineare Diskriminanz Funktion (Fisher)' ; 
run ; 
 
title ; title2 ;






