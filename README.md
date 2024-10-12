# Chapter in Handbook of Quantitative Methods in Sociology

**Title**:  Integrating molecular genetics methods to social stratification research

**Authors**: Gaia Ghirardi, Selin Köksal, Fabrizio Bernardi, Nicola Barban

**Chapter**: This chapter aims to equip sociologists with fundamental knowledge to integrate genetics data into their research. Here, we provide an example of GxE analysis by applying some of the concepts discussed in this chapter. In this application, we ask: Do genes matter more for educational attainment among high or low-SES individuals? This is the same as asking whether the PGI for educational attainment is more predictive of educational attainment among low or high-SES individuals. We address this question using data from the Health and Retirement Study (HRS). 

## Data  

HRS is a longitudinal survey focusing on a representative sample of US individuals aged 50 and above, conducted every two years from 1992 to 2022. It gathers comprehensive data on health, social, and economic well-being during the transition to retirement and older age. Between 2006 and 2012, the HRS also collected blood and saliva samples, providing genetic information from more than 12,000 individuals with European genetic ancestry. The data used in this example are publicly available. To access the data, readers must register on the HRS website and provide their email address, username, and additional details. 

## Datasets

'pgenscore4e_r', 'randhrs1992_2018v2', and 'trk2020tr_r'. 

## Dofile description 

| Dofile name               |  Description                                                                      |  
|---------------------------|-----------------------------------------------------------------------------------|            
| 0_master                  | Master dofile                                                                     | 
| 1_merge                   | Merges the phenotypic and genetic datasets                                        |
| 2_data                    | Basic data management and variables encoding                                      |
| 3_weights                 | Weights construction                                                              |
| 4_sample_standardization  | Variable standardization                                                          |
| 5_descriptives            | Basic descriptive statistics of the main variables                                |
| 6_models                  | Main analyses                                                                     | 
| 7_robustness_checks       | Robustness checks                                                                 |

## Software 

- Stata 

