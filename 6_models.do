/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024				
Topic dofile: Models and graphs 
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %9.2f
clear matrix
clear mata
set maxvar 32000

u "$dataset_working/data_model.dta", clear	

* ---------------------------------------------------------------------------- *
* Main impact PGI EA and family SES
* ---------------------------------------------------------------------------- *	

* Model and graph 
	reg grad_d c.pgsedu_sd SES_2 $controls [pweight=EAWeightFull] , vce(robust)
	estimates store m2_grad_d	
	#delimit ; 
	coefplot(m2_grad_d, keep (pgsedu_sd) lab("") mfcolor(red%50) ms(0) mcol(red) ciopts(lpatt(solid)lcol(red%90)))		 
		(m2_grad_d, keep (SES_2) lab("") mfcolor(orange%50) ms(D) mcol(orange) ciopts(lpatt(solid)lcol(orange%90))),      
		mfcolor(white) msize(huge)											     
		xscale(range(0(.05)0.15))										 
		xlabel(0(.05)0.15,  valuelabel labsize(large)) xline(0)			 
		xlabel(,  valuelabel labsize(medium)) ylabel(,  valuelabel labsize(medium))	 
		xline(0, lcolor(red))  														 
		coeflabels(pgsedu_sd  = "PGI EA" SES_2 = "SES")							     
		mlabel mlabsize(medium) format(%9.2g)  mlabposition(3) mlabgap(*22)			 	
		title("", size(medium)) legend(off) name(`var', replace) 
		;
	#delimit cr	

	graph export "$output_figures/coefplot.png", replace width(1600) height(1100)
	graph export "$output_figures/coefplot.pdf", replace 
	graph export "$output_figures/coefplot.tif", width(3900) replace
	
* ---------------------------------------------------------------------------- *
* Interaction PGI EA and family SES
* ---------------------------------------------------------------------------- *

* Model and graph 
	reg grad_d c.pgsedu_sd##i.SES_2 $controlsKSES [pweight=EAWeightFull] , vce(robust)
	margins, at(pgsedu_sd=(-2(1)2) SES_2=(1,2)) 
	local t = _b[2.SES_2#c.pgsedu_sd ]/_se[2.SES_2#c.pgsedu_sd ]
	disp 2*ttail(e(df_r),abs(`t'))
	local x2_`var': disp %4.3f 2*ttail(e(df_r),abs(`t'))
	disp `x2_`var''
	matrix beta_`var' = e(b)
	disp beta_`var'[1,5]
	local ciao_`var' : di %4.3f beta_`var'[1,5] 
	#delimit ; 
	marginsplot, recast(line)  ciopts(recast(rarea)) 							 
		ci1opt(color(purple%70))													 
		ci2opt(color(ebblue%50))													 
		plot1opts(lc(purple) lpattern(solid))										 
		plot2opts(lc(ebblue) lpattern("--"))										 								 
		xtitle("PGI EA", size(medium))  
		ytitle("Predicted probabilities", size(small))
		title("", size(medium)) 												 
		legend(order(2 "High-SES" 1 "Low-SES") pos(6) size(medium) col(2))	
		note("PGI EA x Family SES estimate: {bf:`ciao_`var''}" "p-value: {bf:`x2_`var''} ", size(small))		
		name(grad_d, replace) 
	;
	#delimit cr	
	
	graph export "$output_figures/margisplot.png", replace width(1600) height(1100)
	graph export "$output_figures/margisplot.pdf", replace 
	graph export "$output_figures/margisplot.tif", width(3900) replace
