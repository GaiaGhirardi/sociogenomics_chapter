/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Handbook of Quantitative Methods in Sociology
Chapter: Introduction to sociogenomics
Application of GXE using HRS 
Authors: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban
Date: October 2024			
Topic dofile: Master
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

********************************************************************************
* Directories
********************************************************************************

	global dataset_original "/Users/gaia/Library/CloudStorage/OneDrive-IstitutoUniversitarioEuropeo/Handbook/Application_HRS/Data/Original"
	global dataset_working "/Users/gaia/Library/CloudStorage/OneDrive-IstitutoUniversitarioEuropeo/Handbook/Application_HRS/Data/Working"
	global dofile "/Users/gaia/Library/CloudStorage/OneDrive-IstitutoUniversitarioEuropeo/Handbook/Application_HRS/Dofile"
	global output_figures "/Users/gaia/Library/CloudStorage/OneDrive-IstitutoUniversitarioEuropeo/Handbook/Application_HRS/Output/Figures"
	global output_tables "/Users/gaia/Library/CloudStorage/OneDrive-IstitutoUniversitarioEuropeo/Handbook/Application_HRS/Data/Output/Tables"

********************************************************************************
* Controls
********************************************************************************

* Basic controls 
	global controls c_rabyear rsex PC1_5A PC1_5B PC1_5C PC1_5D PC1_5E		 ///
		PC6_10A PC6_10E PC6_10D PC6_10C PC6_10B 

* Controls according to Keller (2014)	
	#delimit ; 				
	global controlsKSES c_rabyear 1.rsex 
				PC1_5A PC1_5B PC1_5C PC1_5D PC1_5E 
				PC6_10A PC6_10E PC6_10D PC6_10C PC6_10B 
				c.pgsedu#c.c_rabyear  c.pgsedu#1.rsex 
				c.pgsedu#c.PC1_5A c.pgsedu#c.PC1_5B c.pgsedu#c.PC1_5D 
				c.pgsedu#c.PC1_5E c.pgsedu#c.PC6_10A c.pgsedu#c.PC6_10B 
				c.pgsedu#c.PC6_10C c.pgsedu#c.PC6_10D c.pgsedu#c.PC6_10E 
				i.SES_2#c.c_rabyear i.SES_2#1.rsex 
				i.SES_2#c.PC1_5A i.SES_2#c.PC1_5B i.SES_2#c.PC1_5C 
				i.SES_2#c.PC1_5D i.SES_2#c.PC1_5E i.SES_2#c.PC6_10A 
				i.SES_2#c.PC6_10B i.SES_2#c.PC6_10C i.SES_2#c.PC6_10D 
				i.SES_2#c.PC6_10E
				;
	#delimit cr

********************************************************************************
* Graphs scheme 
********************************************************************************

	set scheme white_tableau		
				
				
				
				
				
				
				