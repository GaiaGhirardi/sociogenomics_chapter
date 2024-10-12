/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024				
Topic dofile: Sample and standardization
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data_weights.dta", clear	

******************************************************************************** 
* Sample selection
******************************************************************************** 

* ---------------------------------------------------------------------------- *
* From merge 
* ---------------------------------------------------------------------------- *

	drop if _merge1!=3
	drop _merge1	

	drop if _merge2!=3
	drop _merge2

	drop if _merge3!=3
	drop _merge3

* ---------------------------------------------------------------------------- *
* Missing in our variables 
* ---------------------------------------------------------------------------- *

	mark s1 if !missing(rabyear, rsex, SES, raedyrs,						 ///
		pgsedu, PC1_5A, PC1_5B, PC1_5C, PC1_5D, PC1_5E, PC6_10A, PC6_10E,	 ///
		PC6_10D, PC6_10C, PC6_10B, DEGREE, EAWeightFull)
		
	keep if s1==1 

* ---------------------------------------------------------------------------- *
* Year of birth 
* ---------------------------------------------------------------------------- *

	keep if rabyear<=1959 & rabyear>=1920

* ---------------------------------------------------------------------------- *	
* check if only European ancestry 
* ---------------------------------------------------------------------------- *
	fre RACE 

* ---------------------------------------------------------------------------- *
* Drop PGS outliers
* ---------------------------------------------------------------------------- *

	drop if pgsedu<-2.5 | pgsedu>+2.5
	
******************************************************************************** 
* Standardization and centralization post analytical sample
******************************************************************************** 

* ---------------------------------------------------------------------------- *
* PGS EDU
* ---------------------------------------------------------------------------- *

	egen pgsedu_sd = std(pgsedu)
	egen pgsedu_10 = xtile(pgsedu_sd), n(10)
	egen pgsedu_4 = xtile(pgsedu_sd), n(4)

* ---------------------------------------------------------------------------- *
* Years of Birth
* ---------------------------------------------------------------------------- *


	sum rabyear
	generate c_rabyear = rabyear - r(mean)
	lab var c_rabyear "Cetralized in the analytical sample"
		
save "$dataset_working/data_model.dta", replace	






















