/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024			
Topic dofile: Logit, LOWESS, and years of education as robustness checks 
--------------------------------------------------------------------------------
----------------------------------------------------------------------------- */

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data_model.dta", clear	

* ---------------------------------------------------------------------------- *
* Logit
* ---------------------------------------------------------------------------- *

	logistic grad_d c.pgsedu_sd##i.SES_2 $controlsKSES [pweight=EAWeightFull] , vce(robust)
	margins, at(pgsedu_sd=(-2(1)2) SES_2=(1,2)) 
	#delimit ; 
	marginsplot, recast(line)  ciopts(recast(rarea)) 							
		ci1opt(color(purple%70))													 
		ci2opt(color(ebblue%70))													 
		plot1opts(lc(purple) lpattern(solid))										 
		plot2opts(lc(ebblue) lpattern("--"))												 
		xtitle("PGI EA", size(small))  											 
		title("Logit", size(medium)) 											 
		ytitle("Predicted probabilities", size (small))	
		legend(order(2 "High-SES" 1 "Low-SES") pos(6) size(small) col(2))		 
		name(gr1, replace) 
		;
	#delimit cr	

* ---------------------------------------------------------------------------- *
* LOWESS
* ---------------------------------------------------------------------------- *

	preserve
	collapse (mean) grad_d , by(SES_2 pgsedu_10)
	#delimit ; 
	twoway (scatter grad_d pgsedu_10 if SES_2==1,  ms(D) mcol(purple%70)) 				
	   (scatter grad_d pgsedu_10 if SES_2==2,  ms(0) mcol(ebblue%70))  ||				
	   (lowess  grad_d pgsedu_10 if SES_2==1, lpatt(solid) lcol(purple))							     
	   (lowess  grad_d pgsedu_10 if SES_2==2, lpatt("--") lcol(ebblue)),								
	   xtitle("PGI EA in deciles") 
	   ytitle("", size (small))	
	   title("LOWESS", size(medium)) 	
	   legend(order (1 "Mean Low-SES" 2 "Mean High-SES"						 
	   3 "Lowess Low-SES" 4 "Lowess High-SES") pos(6) size(small) row(2)) name(gr2, replace)	
	;
	#delimit cr	
	restore
	
	graph combine gr1 gr2, cols(2) ycom

	graph export "$output_figures/RC_2.png", replace width(1600) height(1100)
	graph export "$output_figures/RC_2.pdf", replace 
	graph export "$output_figures/RC_2.tif", width(3900) replace
	
* ---------------------------------------------------------------------------- *
* Years of education 
* ---------------------------------------------------------------------------- *

* Model and graph 
	regress raedyrs c.pgsedu_sd##i.SES_2 $controlsKSES [pweight=EAWeightFull] , vce(robust)
	local t = _b[2.SES_2#c.pgsedu_sd]/_se[2.SES_2#c.pgsedu_sd]
	disp 2*ttail(e(df_r),abs(`t'))
	local x2_`var': disp %4.3f 2*ttail(e(df_r),abs(`t'))
	disp `x2_`var''
	matrix beta_`var' = e(b)
	disp beta_`var'[1,5]
	local ciao_`var' : di %4.3f beta_`var'[1,5] 
	margins,  at(pgsedu_sd=(-2(1)2) SES_2=(1,2))
	#delimit ; 	
	marginsplot, recast(line)  ciopts(recast(rarea)) 							 
		ci1opt(color(purple%70))													 
		ci2opt(color(ebblue%70))													 
		plot1opts(lc(purple) lpattern(solid))										 
		plot2opts(lc(ebblue) lpattern("--"))											 
		xtitle("PGI EA", size(medium))  											 
		title("", size(medium)) 												 
		legend(order(2 "High-SES" 1 "Low-SES") pos(6) size(medium) col(2))	
		note("PGI EA x Family SES estimate: {bf:`ciao_`var''}" "p-value: {bf:`x2_`var''} ", size(small))		
		name(grad_d, replace) 
		;
	#delimit cr	
	
	graph export "$output_figures/RC_1.png", replace width(1600) height(1100)
	graph export "$output_figures/RC_1.pdf", replace 
	graph export "$output_figures/RC_1.tif", width(3900) replace
		








