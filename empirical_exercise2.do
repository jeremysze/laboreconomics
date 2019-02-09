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
sum [aweight = pweight]

tab state
tab grade
tab employed
tab treatment

tab y treatment
tab age treatment
tab grade treatment,m


// B. Collapse the Data to Annual Averages by treatment
gen employed_treat = employed if treatment == 1
gen employed_contr = employed if treatment == 0
gen min_wage_event = (y == 1990 | y == 1991)

collapse (mean) *_treat *_contr min_wage_event [aweight = pweight], by(y)

list

// C. Analyze the Annual Averages

regress employed_treat employed_contr min_wage_event i.y, robust


// D. Collapse the Original Data into a Panel of State-Year Averages by treatment

use "..\input_data\CPS Data for Minimum Wages, 1985-1996.dta",clear

gen pweight2 = 1
gen employed_treat = employed if treatment == 1
gen employed_contr = employed if treatment == 0


collapse (mean) *_treat *_contr (sum) pweight2 [aweight = pweight], by(treatment state y)

reshape wide i(state) j(y) 
