/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024		
Topic dofile: Data preparation   
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data.dta", clear 

******************************************************************************** 
* Controls
******************************************************************************** 

* Year of birth 
	fre rabyear 

* Gender 
	fre ragender
	recode ragender (2=0 "Female") (1=1 "Male"), gen(rsex)

* PCs
	sum PC*

******************************************************************************** 
* Outcomes 
******************************************************************************** 

* Years of education 
	fre raedyrs
	recode raedyrs (0/8 = 8) 

* Degree 
	fre DEGREE
	#delimit ; 
	lab define DEGREE 0 "No degree" 1 "GED" 2 "High school diploma" 
					  3 "Two year college degree" 4 "Four year college degree" 
					  5 "Master degree" 6 "Professional degree (Ph.D., M.D., J.D.)" 
					  9 "Degree unknown/Some College"
					;
	#delimit cr				  
	lab value DEGREE DEGREE

* graduate school completion
	recode DEGREE (0/4=0 "No") (5/6=1 "Yes"), gen(grad_d)
	replace grad_d=0 if DEGREE==9
	lab var grad_d "At least graduate school completion"

******************************************************************************** 
* Family's SES 
******************************************************************************** 

* Mother and father's education 
	fre rafeduc FAEDUC 
	fre rameduc MOEDUC
	
* Average and highest educational level among parents
	egen peduH = rowmax(rafeduc rameduc)
	egen peduA = rowmean(rafeduc rameduc)

* ---------------------------------------------------------------------------- *
* Variables for composite index
* ---------------------------------------------------------------------------- *

* 1) Parental education (coded based on years of reported education as <12, 12-15, or 16+
	recode rafeduc (0/11=0 "Low") (12/15=1 "Medium") (16/17=2 "High"), gen(fedu3)
	recode rameduc (0/11=0 "Low") (12/15=1 "Medium") (16/17=2 "High"), gen(medu3)

* 2) Father's occupation (coded as manual, professional, or management) 
	fre FJOB
	#delimit ; 	
	lab define FJOB 1 "MANAGERIAL/PROFESSIONAL" 2 "SALES" 3 "CLERICAL"			 
					4 "SERVICE" 5 "MANUAL/OPERATORS" 6 "ARMED FORCES"			 
					8 "DK (Don't Know)" 9 "NA (Not Ascertained)"
					;
	#delimit cr				
	lab value FJOB FJOB
	recode FJOB (4/5 2 =0 "Low") (3 6 = 1 "Medium") (1=2 "High") (8/9 = .), gen(focc3)

* 3) Perceptions of the families socioeconomic circumstances (well-off, average, or poor or variable)
	fre FAMFIN
	#delimit ; 
	lab define FAMFIN 1 "PRETTY WELL OFF FINANCIALLY" 3 "ABOUT AVERAGE" 		
					5 "POOR" 6 "IT VARIED (VOL)"								 
					8 "DK (Don't Know); NA (Not Ascertained)"					 
					9 "RF (Refused)"
					;
	#delimit cr				
	lab value FAMFIN FAMFIN				
	recode FAMFIN (5 6 =0 "Low") (3 = 1 "Medium") (1=2 "High") (8/9 = .), gen(fampses)

* 4) Count of number of hardships the family experienced: 
	fre FMFINH MOVFIN FAUNEM
	recode FMFINH (1 = 1 "YES") (5 = 0 "NO") (8/9 = .), gen(fhelp)
	recode MOVFIN (1 = 1 "YES") (5 = 0 "NO") (8/9 = .), gen(mov)
	recode FAUNEM (1 = 1 "YES") (5 6 7 = 0 "NO") (8/9 = .), gen(funemp)
	recode FAUNEM (7 = 1 "YES") (1 5 6 = 0 "NO") (8/9 = .), gen(nofather)
	lab var nofather "Father absent from the home"

	sort hhidpn
	egen nhards = rowtotal(fhelp mov funemp  nofather)
	recode nhards (2/3 = 0 "2 or more hardships") (1 = 1 "1 hardships") (0 = 2 "No hardships"), gen(nhards3)

* 5) SES composite index 
	polychoricpca medu3 fedu3 focc3 fampses nhards3, score(SES) nscore(1)
		rename SES1 SES
		lab var SES "SES continuous - 3"
		egen SES_2 = xtile (SES), n(2)		
		egen SES_3 = xtile (SES), n(3)		
	
******************************************************************************** 
* Main independent variable: PGS education 
******************************************************************************** 
	
	rename E4_EA3_W23_SSGAC18 pgsedu

	
save "$dataset_working/data_vars.dta", replace	





















	
