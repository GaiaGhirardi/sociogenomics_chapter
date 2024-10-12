/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024			
Topic dofile: Merge  
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

	clear all
	set more off, perm
	set cformat %9.2f
	clear matrix
	clear mata
	set maxvar 32000
	
* ---------------------------------------------------------------------------- *
* PGI (only European ancestry) dataset
* ---------------------------------------------------------------------------- *

*open dataset
	u "$dataset_original/pgenscore4e_r.dta", clear 

*describe variables useful to merge datasets
	describe hhid pn

*generate link variable to merge datasets 
	gen hhidpn = hhid + pn
	destring hhidpn, replace
	format hhidpn %20.4f

*check if there are duplicates 
	duplicates tag hhidpn, generate(dupl)
	tab dupl
	count if dupl!=0
	drop dupl
	
*keep only variables of interest
	keep hhidpn PC* E4_EA3_W23_SSGAC18 	

*save dataset 		
	save "$dataset_working/pgs", replace 

* ---------------------------------------------------------------------------- *
* Childhood dataset 
* ---------------------------------------------------------------------------- *

*open dataset
	u "$dataset_original/AGGCHLDFH2016A_R.dta", clear 

*describe and rename variables useful to merge datasets	
	describe HHID PN
	rename HHID hhid 
	rename PN pn 

*generate link variable to merge datasets 
	gen hhidpn = hhid + pn
	destring hhidpn, replace
	format hhidpn %20.4f

*check if there are duplicates 
	duplicates tag hhidpn, generate(dupl)
	tab dupl
	count if dupl!=0
	drop dupl
	
*keep only variables of interest
	keep hhidpn MOEDUC FAEDUC FJOB FAMFIN FMFINH MOVFIN FAUNEM  	

*save dataset 		
	save "$dataset_working/childhood", replace 

* ---------------------------------------------------------------------------- *
* Rand longitudinal dataset 1992 - 2018 
* ---------------------------------------------------------------------------- *

*open dataset
	u "$dataset_original/randhrs1992_2018v2.dta", clear

*chek if there are duplicates 
	duplicates list hhidpn
	destring hhidpn hhid pn, replace 

*keep only variables of interest
	keep hhidpn ragender rabyear rafeduc rameduc s1hhidpn raspid1 raedyrs rabplace 

*save dataset 		
	save "$dataset_working/randhrs1992_2018v2", replace 

* ---------------------------------------------------------------------------- *
* Tracking dataset  
* ---------------------------------------------------------------------------- *

*open dataset
	u "$dataset_original/trk2020tr_r.dta", clear

*describe and rename variables useful to merge datasets	
	describe HHID PN
	rename HHID hhid 
	rename PN pn 

*generate link variable to merge datasets 
	gen hhidpn = hhid + pn
	destring hhidpn, replace
	format hhidpn %20.4f

*check if there are duplicates 
	duplicates tag hhidpn, generate(dupl)
	tab dupl
	drop dupl
	
*keep only variables of interest
	keep hhidpn DEGREE SCHLYRS GENETICS* RACE *GTR *THH	

*save dataset 	
	save "$dataset_working/track2020", replace 

* ---------------------------------------------------------------------------- *
* merge 
* ---------------------------------------------------------------------------- *

* PGI and rand longitudinal dataset
	u "$dataset_working/randhrs1992_2018v2.dta", clear 
	joinby hhidpn using "$dataset_working/pgs.dta", unmatched(both)
	fre _merge
	rename _merge _merge1 
	save "$dataset_working/data.dta", replace

*Childhood dataset	
	u "$dataset_working/data.dta", clear 
	joinby hhidpn using "$dataset_working/childhood.dta", unmatched(both)
	fre _merge
	rename _merge _merge2
	save "$dataset_working/data.dta", replace

*Tracking dataset	
	u "$dataset_working/data.dta", clear 
	joinby hhidpn using "$dataset_working/track2020.dta", unmatched(both)
	fre _merge
	rename _merge _merge3
	save "$dataset_working/data.dta", replace
