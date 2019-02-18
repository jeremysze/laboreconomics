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
log using "..\log\empirical_exercise2", replace


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

collapse (mean) *_treat *_contr min_wage_event [pweight = pweight], by(y)

list

// C. Analyze the Annual Averages
gen min_wage_90 = y==1990
gen min_wage_91= y==1991

regress employed_treat employed_contr min_wage_90 min_wage_91 , robust

* It appears that the minimum wage event in 1990 is not significant, 
* but the second minimum wage event in 1991 was significant.

regress employed_treat employed_contr min_wage_90 min_wage_91 y, robust

* Yes they are sensitive. Once time trend was included in the mode, the 
* minumum wage event in 1990 is significant. However, the minimum wage event 
* in 1991 is no longer significant.

// D. Collapse the Original Data into a Panel of State-Year Averages by treatment

use "..\input_data\CPS Data for Minimum Wages, 1985-1996.dta",clear

gen weight2_treat = treatment == 1
gen weight2_contr = treatment == 0

gen employed_treat = employed if treatment == 1
gen employed_contr = employed if treatment == 0


collapse (mean) employed_treat employed_contr ///
(rawsum) weight2_treat weight2_contr ///
[pweight = pweight], by(state y)

sort state y
tab y
tab state

// E. Analyze the State-Year Averages

gen min_wage_90 = y==1990
gen min_wage_91= y==1991
gen min_wage_92_95 = (y>=1992 & y <=1995)

regress employed_treat employed_contr min_wage_* i.state [pweight = weight2_treat], vce(cluster state)

* Are the employment effects of the minimum wage statistically significant?
* Yes, the employment effects of the minimum wage are statistically significant.
* Do they grow or shrink in the wake of the hikes?
* The employment of the treated group shrank in the wake of the hikes.

gen y2 = y*y
regress employed_treat employed_contr min_wage_* i.state y [pweight = weight2_treat], vce(cluster state)
regress employed_treat employed_contr min_wage_* i.state y y2 [pweight = weight2_treat], vce(cluster state)

* Are the estimates sensitive to including linear and quadratic time trends?

* Yes. Employment for the control group is no longer significant. 
* The coefficients for the minimum wage event increased in magnitude.

regress employed_treat employed_contr min_wage_* i.state#c.y [pweight = weight2_treat], robust

log close
