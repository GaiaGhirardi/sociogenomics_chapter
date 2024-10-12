/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024		
Topic dofile: Descriptives
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data_model.dta", clear	

********************************************************************************
* Table 
********************************************************************************

* main descriptive statistics table
	asdoc sum pgsedu_sd grad_d i.SES_2 i.rsex rabyear , replace
	
********************************************************************************
* Graphs 
********************************************************************************

u "$dataset_working/data_model.dta", clear	

* ---------------------------------------------------------------------------- *
* Independent variables 
* ---------------------------------------------------------------------------- *

* PGS
	#delimit ; 
	kdens pgsedu_sd, norm color(dkgreen%30) recast(area) xtitle("") 			 
	title("1. PGI EDU", size(medsmall)) 										 
	name(pgs1, replace) note (Obs: 9129, size(vsmall)) 
	;
	#delimit cr	
	
* PGS by family SES
	#delimit ; 
	twoway kdensity pgsedu_sd if SES_2==1,  legend(label(1 "Low SES") 
			position(6) rows(1)) || 
		   kdensity pgsedu_sd if SES_2==2,  lcolor(midgreen) legend(label(2 "High SES")) 
		   xtitle("PGI") ytitle("") name(gr1, replace) title("PGI by family SES")
	;
	#delimit cr	
	
* ---------------------------------------------------------------------------- *
* Controls 
* ---------------------------------------------------------------------------- *

* Gender 
	catplot rsex, percent  recast(bar) b1t("") title("Gender ") 		     ///
			hor var1opts(lab(labsize(*0.6))) name(BIO_SEX, replace)

* Year of birth
	#delimit ; 
	catplot rabyear, percent  recast(bar) b1t("")								 
			title("Year of birth") hor var1opts(lab(labsize(*0.6)))				 
			name(yearbirth, replace)
		;
	#delimit cr	
	
	graph combine yearbirth BIO_SEX, name(controls, replace) 













