/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024		
Topic dofile: Weights  
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

/*
Motivation of usign weights:
Given the risk of non-response and mortality selection, weights were developed 
to specifically account for these potential biases in the sample with genetic data 
(Domingue et al. 2017).
*/

/*
Source:
The weights strategy of this application is taken by Papageorge and Thom (2020) 
Complete reference: Papageorge, N. W., & Thom, K. (2020). Genes, education, and 
labor market outcomes: evidence from the health and retirement study. 
Journal of the European Economic Association, 18(3), 1351-1399.
*/

/*The genetic data were collected in the 2006 and 2008 biomarker sub-sample survey, 
and the sample weights for the sub-sample were provided by the HRS in the two waves. 
The genetic sample collected in 2006 was a randomly selected half of the 2006 sample, 
and the other half was selected for the collection of the biomarkers in 2008. 
To accommodate the survey design, we applied the following sample weights 	
*/

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data_vars.dta", clear	
		
* Logit model 
	gen InGeneticSampleFull=(GENETICS06==1 | GENETICS08==1 | GENETICS10==1 | GENETICS12==1)
		
	recode rameduc (.d=9999) (.m=9999) (.r=9999), gen(rameducM)
	recode rafeduc (.d=9999) (.m=9999) (.r=9999), gen(rafeducM)
	recode DEGREE (.=9999) , gen(DEGREEM)
	recode rsex (.=9999) , gen(rsexM)
	recode rabyear (.=9999) (.m=9999) , gen(rabyearM)
	recode rabplace (.=9999) (.m=9999) , gen(rabplaceM)

	logit InGeneticSampleFull DEGREE raedyrs rabyear rabplace rsex rameduc rafeduc if RACE==1 

* Prediction 	
	predict InGenoProbXBFull if e(sample), xb
	gen InGenoProbFull = normprob(InGenoProbXBFull)
	gen InGenoWeightFull=1/InGenoProbFull	

* Get Respondent Weights
	gen RW_1992=AWGTR
	gen RW_1993=BWGTR
	gen RW_1994=CWGTR
	gen RW_1995=DWGTR
	gen RW_1996=EWGTR
	gen RW_1998=FWGTR
	gen RW_2000=GWGTR
	gen RW_2002=HWGTR
	gen RW_2004=JWGTR
	gen RW_2006=KWGTR
	gen RW_2008=LWGTR
	gen RW_2010=MWGTR
	gen RW_2012=NWGTR
	gen RW_2014=OWGTR
	gen RW_2016=PWGTR
	gen RW_2018=QWGTR

* Get Household Weights
	gen HHW_1992=AWGTHH
	gen HHW_1993=BWGTHH
	gen HHW_1994=CWGTHH
	gen HHW_1995=DWGTHH
	gen HHW_1996=EWGTHH
	gen HHW_1998=FWGTHH
	gen HHW_2000=GWGTHH
	gen HHW_2002=HWGTHH
	gen HHW_2004=JWGTHH
	gen HHW_2006=KWGTHH
	gen HHW_2008=LWGTHH
	gen HHW_2010=MWGTHH
	gen HHW_2012=NWGTHH
	gen HHW_2014=OWGTHH
	gen HHW_2016=PWGTHH
	gen HHW_2018=QWGTHH

	gen RWFirst04=.
	gen HWFirst04=.

	foreach yr in 1992 1993 1994 1995 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 {
		replace RWFirst04=RW_`yr' if RWFirst04==. & RW_`yr'~=. & RW_`yr'>0
		replace HWFirst04=HHW_`yr' if HWFirst04==. & HHW_`yr'~=. & HHW_`yr'>0
	}

* Alternative weights to control for selection in the genetic sample 
	gen RWGeno=.
	replace RWGeno=KBIOWGTR if GENETICS06==1 
	replace RWGeno=LBIOWGTR if GENETICS08==1 
	replace RWGeno=MBIOWGTR if GENETICS10==1 
	replace RWGeno=NBIOWGTR if GENETICS12==1 

	replace RWGeno=KBIOWGTR if ((RWGeno==0 | RWGeno==.) & (KBIOWGTR~=. & KBIOWGTR>0))
	replace RWGeno=LBIOWGTR if ((RWGeno==0 | RWGeno==.) & (LBIOWGTR~=. & LBIOWGTR>0))
	replace RWGeno=MBIOWGTR if ((RWGeno==0 | RWGeno==.) & (MBIOWGTR~=. & MBIOWGTR>0))
	replace RWGeno=NBIOWGTR if ((RWGeno==0 | RWGeno==.) & (NBIOWGTR~=. & NBIOWGTR>0))
	replace RWGeno=OBIOWGTR if ((RWGeno==0 | RWGeno==.) & (OBIOWGTR~=. & OBIOWGTR>0))
	
* Multiplication weights 
	gen EAWeightFull  =RWFirst04*InGenoWeightFull
		replace EAWeightFull=HWFirst04*InGenoWeightFull if RWFirst04==.	

	gen EAWeightG =RWGeno		

save "$dataset_working/data_weights.dta", replace	













	