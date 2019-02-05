/****************************************************************************
* File name: empirical_exercise1.do
* Author(s): Sze, J.
* Date: 2/2/2019
* Description: 
* Answers to empirical exercise 1 for Labor Economics
*
* Inputs: 
* ..\input_data\Small CPS, 2018.dta" 
* 
* Outputs:
* 
***************************************************************************/
log using "..\log\empirical_exercise1", replace

use "..\input_data\Small CPS, 2018.dta",clear

// 1. Explore the Data
codebook  idcode
	// 11,000 unique ids

describe 
histogram age
graph close
sum age
tab1 age female race hispanic married veteran region state metro size grade public union topcode

tab female union
tab female public
tab female grade

tab veteran,m
// 60 obs with missing veteran status

gen white = (race == 1)
gen black = (race == 2)
gen indian = (race == 3)
gen asianpi = (race == 4)
gen other = (race == 5)
list in 1/5

tab rotation month


//  2. Compute Monthly Averages
sum weight
// no negative values

svyset [pweight = weight]

// Average weekly hours and wages by month (weighted)
svy: mean wage, over(month)
svy: mean hours, over(month)

preserve
gen mean_hours = hours
gen mean_wages = wage
gen p50_hours = hours
gen p50_wages = wage
gen p90_wages = wage
gen p10_wages = wage

collapse (mean) mean_hours mean_wages ///
(p50) p50_hours p50_wages ///
(p10) p10_wages ///
(p90) p90_wages ///
[pweight = weight], by(month)

list, table
restore

// 3. Examine the Weights
sum weight
histogram weight
graph close

list idcode wage weight in 1/2
// The weight is the sampling weight. It contains the number of individuals in
// the population that each observation represents.
total weight
// The weight adds up to 1.13e+08 or 113,203,560. This is the population size.

// 4. Plot the Wage and log-Wage Distributions
gen lg_wage = log(wage), after(wage)
histogram wage, normal
graph export "..\outputs\ee1_wage.pdf",as(pdf) replace
// The spike at the end is caused by top coding the people who earn above a 
// certain amount
histogram lg_wage, normal
graph export "..\outputs\ee1_ln_wage.pdf",as(pdf) replace

graph close

sum wage, detail
global p10 = r(p10)
global p50 = r(p50)
global p90 = r(p90) 

global differences = ($p90 - $p50) / ($p50 - $p10)

di "Ratio of 90-10 percentile ratio: " $p90/$p10
di "Ratio of the difference between the wages at the 90th and 50th percentiles to the difference between the wages at the 50th and 10th percentiles: " $differences
// This tells us how much more income above the median verse the bottom half makes.
// 5. Collapse the Data to Occupation Averages

global list age female married veteran public union hours wage rwage grade white black indian asianpi other
foreach i of global list{
gen mean_`i' = `i'
}
gen med_wage = wage
gen occupation_wt = 1

collapse (mean) mean_* ///
(p50) med_wage ///
(sum) occupation_wt ///
[pweight = weight], by(occupation)

list 

svyset [pweight = occupation_wt]
 

// 6. Analyze the Occupation Averages
gen lg_mean_wage = log(mean_wage)
svy: regress lg_mean_wage mean_hours
predict yhat1
svy: regress lg_mean_wage mean_grade
predict yhat2

twoway scatter lg_mean_wage mean_hours || lfit yhat1 mean_hours
graph export "..\outputs\ee1_scatter_hour.pdf",as(pdf) replace

twoway scatter lg_mean_wage mean_grade || lfit yhat2 mean_grade
graph export "..\outputs\ee1_scatter_grade.pdf",as(pdf) replace
graph close

svy: regress lg_mean_wage mean_hours mean_grade
predict yhat3

svy: regress lg_mean_wage mean_hours mean_grade mean_female mean_white mean_black mean_indian mean_asianpi


log close
