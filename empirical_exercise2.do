/****************************************************************************
* File name: empirical_exercise2.do
* Author(s): Sze, J.
* Date: 2/7/2019
* Description: 
* Answers to empirical exercise 2 for Labor Economics
*
* Inputs: 
* ..\input_data\CPS Data for Minimum Wages, 1985-1996.dta" 
* 
* Outputs:
* 
***************************************************************************/
*log using "..\log\empirical_exercise2", replace


use "..\input_data\CPS Data for Minimum Wages, 1985-1996.dta",clear

// A. Explore the Data

describe
sum
tab grade
tab treatment

